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
    var onSelectedSoundsChanged: (([SoundType]) -> Void)?
    
    func toggleSound(_ type: SoundType) {
        // もし選んだサウンドがselectedSoundsにあったら
        if selectedSounds.contains(type) {
            // サウンドを止める
            SoundManager.shared.stopSound(named: type.rawValue)
            selectedSounds.removeAll { $0 == type }
        } else {
            // サウンドを再生する
            SoundManager.shared.playSound(named: type.rawValue)
            selectedSounds.append(type)
        }
    }
    
    func stopAll() {
        SoundManager.shared.stopAll()       // 音を止める
        selectedSounds.removeAll()          // 音の状態をクリア
        selectedSound = nil                 // もし持っているなら nil に
    }
}
