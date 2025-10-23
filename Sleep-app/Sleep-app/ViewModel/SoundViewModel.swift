//
//  SoundViewModel.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/22.
//

import Foundation

final class SoundViewModel: ObservableObject {
    @Published var sounds: [SoundItem] = SoundType.allCases.map { SoundItem(type: $0) }
    
    func toggleSound(_ item: SoundItem) {
        // 再生停止の実処理（例）
        stopAll()
        if let idx = sounds.firstIndex(where: { $0.id == item.id }) {
            sounds[idx].isPlaying.toggle()
            if sounds[idx].isPlaying {
                SoundManager.shared.playSound(named: sounds[idx].type.rawValue)
            }
        }
    }
    
    func stopAll() {
        SoundManager.shared.stopAll()
        for i in sounds.indices { sounds[i].isPlaying = false }
    }
}
