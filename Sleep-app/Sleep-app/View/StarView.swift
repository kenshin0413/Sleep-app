//
//  StarOverlayView.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/26.
//

import SwiftUI

struct StarryOverlayView: View {
    @StateObject var viewModel = StarViewModel()
    
    var body: some View {
        // ジオメトリ・リーダー サイズや座標情報を取得
        GeometryReader { geo in
            ZStack {
                ForEach(viewModel.stars) { star in
                    Circle()
                        .fill(Color.white.opacity(star.opacity))
                        .frame(width: star.size, height: star.size)
                        .position(star.startPosition)
                        .offset(x: star.animate ? star.offsetX : 0,
                                y: star.animate ? star.offsetY : 0)
                        .animation(
                            // イーズイン ゆっくり加速して動く
                            .easeIn(duration: star.duration)
                            // 永遠に繰り返す
                            .repeatForever(autoreverses: false),
                            // star.animateの値が変化したときにアニメーションをトリガー
                            value: star.animate
                        )
                }
            }
            // オンアピアー 画面が表示された瞬間に
            .onAppear {
                viewModel.generateStars(in: geo.size)
                viewModel.startAnimation()
            }
            // オンディスアピアー ビューが画面から消えたときに実行
            .onDisappear {
                viewModel.stopAnimation() // ← 破棄前に停止
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [.black, .indigo, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        StarryOverlayView()
    }
}
