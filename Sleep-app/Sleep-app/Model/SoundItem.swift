//
//  SoundItem.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/22.
//

import Foundation
// CaseIterableを使うことで.allCasesが使える
enum SoundType: String, CaseIterable, Identifiable, Codable {
    case wave, rain, fire, insects, forest, thunder, rainⅡ, water
    
    var id: String { self.rawValue }
    var displayName: String {
        switch self {
        case .wave: return NSLocalizedString("波 ", comment: "Wave sound label with trailing space")
        case .rain: return NSLocalizedString("雨 ", comment: "Rain sound label with trailing space")
        case .fire: return NSLocalizedString("焚き火 ", comment: "Bonfire sound label with trailing space")
        case .insects: return NSLocalizedString("虫 ", comment: "Insects sound label with trailing space")
        case .forest: return NSLocalizedString("森", comment: "Forest sound label")
        case .thunder: return NSLocalizedString("雷", comment: "Thunder sound label")
        case .rainⅡ: return NSLocalizedString("雨Ⅱ", comment: "Rain II sound label")
        case .water: return NSLocalizedString("水", comment: "Water sound label")
            
        }
    }
    
    var bgVideoName: String {
        switch self {
        case .wave: return "wave_bg"
        case .rain: return "rain_bg"
        case .fire: return "fire_bg"
        case .insects: return "night_bg"
        case .forest: return "forest_bg"
        case .thunder: return "thunder_bg"
        case .rainⅡ: return "rainⅡ_bg"
        case .water: return "water_bg"
            
        }
    }
}

struct SoundItem: Identifiable {
    let id = UUID()
    let type: SoundType
    var isPlaying: Bool = false
    
    var name: String { type.displayName }
}
