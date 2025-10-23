//
//  VideoBackgroundView.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/22.
//

import SwiftUI
import AVKit

struct VideoBackgroundView: UIViewRepresentable {
    let player: AVPlayer
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        // プレイヤーレイヤーを作成
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = UIScreen.main.bounds
        // ループ再生設定
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem, queue: .main) { _ in
            player.seek(to: .zero)
            player.play()
        }
        
        view.layer.addSublayer(playerLayer)
        player.play()
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
