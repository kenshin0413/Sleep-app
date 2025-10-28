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
        // 画面いっぱいに映像を広げる
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = UIScreen.main.bounds
        // ループ再生設定
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem, queue: .main) { _ in
            // 再生位置を最初（0秒）に戻す
            player.seek(to: .zero)
            // 再生開始（ループ再生になる）
            player.play()
        }
        
        view.layer.addSublayer(playerLayer)
        player.play()
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
