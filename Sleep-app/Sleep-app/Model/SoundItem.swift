//
//  SoundItem.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/22.
//

import Foundation

enum SoundType: String, CaseIterable, Hashable {
    case wave, rain, fire, insects, forest, thunder, rainⅡ, water
    
    var displayName: String {
        switch self {
        case .wave: return "波 "
        case .rain: return "雨 "
        case .fire: return "焚き火 "
        case .insects: return "虫 "
        case .forest: return "森"
        case .thunder: return "雷"
        case .rainⅡ: return "雨Ⅱ"
        case .water: return "水"
            
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
// 2) リスト表示用のアイテム
struct SoundItem: Identifiable {
    let id = UUID()
    let type: SoundType
    var isPlaying: Bool = false
    
    var name: String { type.displayName }
}
