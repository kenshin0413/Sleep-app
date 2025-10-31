//
//  SoundTime.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/29.
//

import Foundation

struct SoundTemplate: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var sounds: [SoundSetting] // ← 複数サウンド対応
}


