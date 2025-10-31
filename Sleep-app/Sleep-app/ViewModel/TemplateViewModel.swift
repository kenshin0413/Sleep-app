//
//  TemplateViewModel.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/29.
//

import Foundation
import SwiftUI

final class TemplateViewModel: ObservableObject {
    @Published var templates: [SoundTemplate] = [] {
        didSet { saveTemplates() }
    }
    
    private let key = "savedSoundTemplates"
    
    init() {
        loadTemplates()
    }
    
    func add(_ template: SoundTemplate) {
        templates.append(template)
    }
    
    func delete(at offsets: IndexSet) {
        templates.remove(atOffsets: offsets)
    }
    
    func delete(template: SoundTemplate) {
        if let index = templates.firstIndex(of: template) {
            templates.remove(at: index)
        }
    }
    
    func play(_ template: SoundTemplate,
              soundVM: SoundSelectViewModel,
              homeVM: HomeViewModel) {
        soundVM.stopAll()
        
        // すべてのサウンドを再生
        for sound in template.sounds {
            let type = sound.soundType
            soundVM.playSound(type)
            
            if let end = sound.endTime {
                soundVM.setEndTime(for: type, endTime: end)
            } else if let sec = sound.durationSeconds {
                soundVM.setTimer(for: type, seconds: sec)
            }
        }
        // 背景ローテーションにテンプレ内の全サウンドを反映（保存順に）
        let orderedTypes = template.sounds.map { $0.soundType }
        homeVM.updateBackground(for: orderedTypes)
    }
    
    private func saveTemplates() {
        if let data = try? JSONEncoder().encode(templates) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    private func loadTemplates() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([SoundTemplate].self, from: data) {
            templates = decoded
        }
    }
}
