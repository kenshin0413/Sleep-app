//
//  BGMManager.swift
//  Sleep-app
//
//  Background music controller: plays app-wide BGM when no sounds are active.
//

import Foundation
import AVFoundation

final class BGMManager {
    static let shared = BGMManager()
    
    var bgmFileName: String = "bgm"
    
    private var player: AVAudioPlayer?
    
    private init() {}
    
    func startIfNeeded() {
        guard player?.isPlaying != true else { return }
        start()
    }
    
    func start() {
        guard let url = Bundle.main.url(forResource: bgmFileName, withExtension: "mp3") else {
            print("[BGM] Missing file: \(bgmFileName).mp3")
            return
        }
        do {
            let p = try AVAudioPlayer(contentsOf: url)
            p.numberOfLoops = -1
            p.volume = 0.4 // subtle background
            p.prepareToPlay()
            p.play()
            player = p
            print("[BGM] Started: \(bgmFileName)")
        } catch {
            print("[BGM] Start error: \(error)")
        }
    }
    
    func stop() {
        player?.stop()
        player = nil
        print("[BGM] Stopped")
    }
    
    var isPlaying: Bool { player?.isPlaying == true }
}
