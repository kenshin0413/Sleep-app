//
//  TemplateCreateViewModel.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/29.
//

import Foundation
import SwiftUI

final class TemplateCreateViewModel: ObservableObject {
    @Published var selectedSound: SoundType = .rain
    @Published var selectedMinutes: Int = 10
    @Published var useEndTime = false
    @Published var selectedEndTime = Date()
    @Published var title = ""
    
    func makeTemplate() -> SoundTemplate {
        // まず1つのサウンド設定を作成
        let setting = SoundSetting(
            soundType: selectedSound,
            durationSeconds: useEndTime ? nil : selectedMinutes * 60,
            endTime: useEndTime ? selectedEndTime : nil
        )
        // その設定を配列としてSoundTemplateに渡す
        return SoundTemplate(
            id: UUID(),
            title: title.isEmpty ? String(format: NSLocalizedString("%@テンプレ", comment: "Default template title: '<sound> Template'"), selectedSound.displayName) : title,
            sounds: [setting]
        )
    }
}
