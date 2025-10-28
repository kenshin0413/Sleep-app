//
//  SoundManager.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/22.
//

import Foundation
import AVFoundation
// ロック画面・コントロールセンターにも表示
import MediaPlayer
// アプリ外で画像を扱う
import UIKit

class SoundManager {
    static let shared = SoundManager()
    private var players: [String: AVAudioPlayer] = [:]
    private var currentFileName: String?
    
    private init() {
        configureAudioSession()
        configureRemoteCommands()
    }
    /// 🔊 バックグラウンド再生を有効にする設定
    private func configureAudioSession() {
        do {
            // .playback 消音でも鳴る、バックグラウンド鳴る
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            // .setActive 上で決めた処理を有効化これがないと上は意味ない
            try AVAudioSession.sharedInstance().setActive(true)
            print("✅ AudioSession 有効化済み（バックグラウンド再生OK）")
        } catch {
            print("⚠️ AudioSession 設定エラー: \(error.localizedDescription)")
        }
    }
    /// 🎵 再生
    func playSound(named fileName: String) {
        if let existingPlayer = players[fileName], existingPlayer.isPlaying {
            return
        }
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("⚠️ サウンドファイルが見つかりません: \(fileName)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            player.prepareToPlay()
            player.play()
            players[fileName] = player
            currentFileName = fileName
            
            updateNowPlayingInfo(title: fileName)
            print("🎶 \(fileName) 再生開始")
        } catch {
            print("⚠️ 再生エラー: \(error.localizedDescription)")
        }
    }
    
    /// ⏹ 停止（個別）
    func stopSound(named fileName: String) {
        if let player = players[fileName] {
            player.stop()
            players.removeValue(forKey: fileName)
        }
        if currentFileName == fileName {
            clearNowPlayingInfo()
        }
    }
    
    /// ⏹ 全停止
    func stopAll() {
        for (_, player) in players {
            player.stop()
        }
        players.removeAll()
        clearNowPlayingInfo()
    }
    /// 🧠 再生中かどうか
    func isPlaying(_ fileName: String) -> Bool {
        return players[fileName]?.isPlaying ?? false
    }
    
    private func configureRemoteCommands() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] _ in
            if let name = self?.currentFileName {
                self?.players[name]?.play()
                self?.updateNowPlayingInfo(title: name)
            }
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            if let name = self?.currentFileName {
                self?.players[name]?.pause()
                self?.updateNowPlayingInfo(title: name, isPlaying: false)
            }
            return .success
        }
        
        print("🎛️ Remote Command 設定完了")
    }
    
    private func updateNowPlayingInfo(title: String, isPlaying: Bool = true) {
        var nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: title,
            MPMediaItemPropertyArtist: "夜音アプリ",
        ]
        // 🔹 AppIconをロック画面に表示
        if let icon = UIImage(named: "NowPlayingIcon") {
            let artwork = MPMediaItemArtwork(boundsSize: icon.size) { _ in icon }
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func clearNowPlayingInfo() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
}
