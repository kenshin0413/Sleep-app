//
//  Star.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/27.
//

import Foundation

struct Star: Identifiable {
    let id: Int
    let size: CGFloat
    let opacity: Double
    let startPosition: CGPoint
    let offsetX: CGFloat
    let offsetY: CGFloat
    let duration: Double
    var animate: Bool = false
}
