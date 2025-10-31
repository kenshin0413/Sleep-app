//
//  SoundSetting.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/29.
//

import Foundation

struct SoundSetting: Identifiable, Codable, Equatable {
    let id: UUID
    var soundType: SoundType
    var durationSeconds: Int?
    var endTime: Date?
    
    init(id: UUID = UUID(),
         soundType: SoundType,
         durationSeconds: Int? = nil,
         endTime: Date? = nil) {
        self.id = id
        self.soundType = soundType
        self.durationSeconds = durationSeconds
        self.endTime = endTime
    }
}

