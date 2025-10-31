//
//  SoundViewModel.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/22.
//

import Foundation
import SwiftUI

class SoundSelectViewModel: ObservableObject {
    @Published var sounds: [SoundItem] = SoundType.allCases.map { SoundItem(type: $0) }
    @Published var selectedSound: SoundType? = nil
    @Published var selectedSounds: [SoundType] = [] {
        didSet {
            // 音が変更されたらHomeViewModelに通知
            onSelectedSoundsChanged?(selectedSounds)
        }
    }
    @Published var remainingTimes: [SoundType: Int] = [:]
    @Published var timers: [SoundType: Timer?] = [:]
    @Published var presetTimers: [SoundType: Int] = [:]
    @Published var isTimerRunning: [SoundType: Bool] = [:]
    @Published var endTimes: [SoundType: Date] = [:]
    var onSelectedSoundsChanged: (([SoundType]) -> Void)?
    
    func toggleSound(_ type: SoundType) {
        if selectedSounds.contains(type) {
            stopSound(type)          // ← 直接停止処理を書かず「stopSound」を呼ぶ
        } else {
            playSound(type)          // ← 直接再生せず「playSound」を呼ぶ（ここでタイマー開始）
        }
    }
    
    func startTimer(for type: SoundType, seconds: Int) {
        timers[type]??.invalidate()
        remainingTimes[type] = seconds
        
        timers[type] = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            guard let remaining = self.remainingTimes[type] else { return }
            
            if remaining > 0 {
                self.remainingTimes[type] = remaining - 1   // @MainActorなのでメイン
                self.objectWillChange.send()                // 念のためUI更新を通知
            } else {
                timer.invalidate()
                // 0秒になったら自動停止（仕様に合わせてサウンドも止める）
                self.stopSound(type)
                self.presetTimers[type] = nil
                self.remainingTimes[type] = nil
            }
        }
    }
    
    func playSound(_ type: SoundType) {
        // Stop BGM when any app sound starts
        BGMManager.shared.stop()
        SoundManager.shared.playSound(named: type.rawValue)
        if !selectedSounds.contains(type) { selectedSounds.append(type) }
        
        if let end = endTimes[type] { // 🕒 終了時刻が設定済みなら残り時間計算してスタート
            let seconds = Int(end.timeIntervalSinceNow)
            if seconds > 0 {
                startTimer(for: type, seconds: seconds)
            } else {
                stopSound(type)
            }
        } else if let remaining = remainingTimes[type], remaining > 0 {
            startTimer(for: type, seconds: remaining)
        } else if let preset = presetTimers[type] {
            startTimer(for: type, seconds: preset)
        }
    }
    
    func stopAll() {
        SoundManager.shared.stopAll()
        // すべてのサウンドのタイマー情報をリセット
        for type in SoundType.allCases {
            cancelTimer(for: type)
            endTimes[type] = nil
        }
        selectedSounds.removeAll()
        selectedSound = nil
        // Resume BGM when nothing is playing
        BGMManager.shared.startIfNeeded()
    }
    
    func setTimer(for type: SoundType, seconds: Int) {
        presetTimers[type] = seconds
        remainingTimes[type] = seconds     // ← 再生前でもUIに表示
        endTimes[type] = Date().addingTimeInterval(TimeInterval(seconds))
        
        if selectedSounds.contains(type) {
            startTimer(for: type, seconds: seconds)  // 再生中なら即開始
        } // 未再生ならスタンバイ表示だけ
    }
    
    func setEndTime(for type: SoundType, endTime: Date) {
        endTimes[type] = endTime
        let seconds = Int(endTime.timeIntervalSinceNow)
        remainingTimes[type] = max(seconds, 0)
        
        if selectedSounds.contains(type), seconds > 0 {
            startTimer(for: type, seconds: seconds)
        }
    }
    
    func stopSound(_ type: SoundType) {
        SoundManager.shared.stopSound(named: type.rawValue)
        selectedSounds.removeAll { $0 == type }
        
        // ❌ ここで remainingTimes や presetTimers を消さない
        pauseTimer(for: type)   // ← 一時停止（残り時間は保持）
        if selectedSounds.isEmpty {
            BGMManager.shared.startIfNeeded()
        }
    }
    
    func cancelTimer(for type: SoundType) {
        timers[type]??.invalidate()
        timers[type] = nil
        remainingTimes[type] = nil
        presetTimers[type] = nil
        isTimerRunning[type] = false
        endTimes[type] = nil
    }
    
    func pauseTimer(for type: SoundType) {
        timers[type]??.invalidate()
        timers[type] = nil
        // remainingTimes[type] は保持（再開用）
    }
    
    func resumeTimer(for type: SoundType) {
        if let remaining = remainingTimes[type], remaining > 0 {
            startTimer(for: type, seconds: remaining)
        } else if let preset = presetTimers[type] {
            startTimer(for: type, seconds: preset)
        }
    }
}
