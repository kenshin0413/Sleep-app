//
//  StarViewModel.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/27.
//

import Foundation
import SwiftUI

final class StarViewModel: ObservableObject {
    @Published var stars: [Star] = []
    private var isActive = true // ← Viewが表示中かどうかを追跡
    
    func generateStars(in size: CGSize) {
        stars = (0..<8).map { i in
            Star(
                id: i,
                size: CGFloat.random(in: 1...2),
                opacity: Double.random(in: 0.6...1),
                startPosition: CGPoint(
                    x: CGFloat.random(in: 0...(size.width * 0.4)),
                    y: CGFloat.random(in: 0...(size.height * 0.5))
                ),
                offsetX: CGFloat.random(in: 400...700),
                offsetY: CGFloat.random(in: 400...800),
                duration: Double.random(in: 6...10)
            )
        }
    }
    
    func startAnimation() {
        isActive = true
        for i in stars.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...2)) { [weak self] in
                guard let self = self else { return } // ← selfが破棄済みなら即return
                guard self.isActive, i < self.stars.count else { return } // ← 安全チェック
                self.stars[i].animate = true
            }
        }
    }
    
    func stopAnimation() {
        isActive = false
    }
    
    deinit {
        print("💀 StarViewModel deinitialized")
    }
}
