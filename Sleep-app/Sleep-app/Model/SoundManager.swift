//
//  SoundManager.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/22.
//

import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    private var players: [String: AVAudioPlayer] = [:]
    /// 指定した音を再生（同時再生対応）
    func playSound(named fileName: String) {
        /// 指定した音を再生（同時再生対応）
        if let existingPlayer  = players[fileName], existingPlayer.isPlaying {
            return
        }
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("⚠️ サウンドファイルが見つかりません: \(fileName)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1 //無限ループ
            player.prepareToPlay()
            player.play()
            players[fileName] = player
        } catch {
            print("⚠️ 音の再生に失敗しました: \(error.localizedDescription)")
        }
    }
    /// 指定した音を停止
    func stopSound(named fileName: String) {
        if let player = players[fileName] {
            player.stop()
            players.removeValue(forKey: fileName)
        }
    }
    /// 全停止
    func stopAll() {
        for (_, player) in players {
            player.stop()
        }
        players.removeAll()
    }
    /// 再生中かどうか確認
    func isPlaying(_ fileName: String) -> Bool {
        return players[fileName]? .isPlaying ?? false
    }
}
