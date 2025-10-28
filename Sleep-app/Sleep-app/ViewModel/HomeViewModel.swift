//
//  HomeViewModel.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/23.
//
import SwiftUI
import Foundation

final class HomeViewModel: ObservableObject {
    @Published var selectedSounds: [SoundType] = []
    @Published var selectedSound: SoundType? = nil
    @Published var showingSoundSelect = false
    @Published var animate = false
    @Published private var animateGradient = false
    
    private var timer: Timer?
    private var currentIndex = 0
    
    func AnimatedGradientBackground() -> some View {
        ZStack {
            // リニアグラディエント 2色以上の色を滑らかに変化させて塗りつぶす背景
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black,
                    animate
                    ? Color(red: 0.05, green: 0.05, blue: 0.2)
                    : Color(red: 0.1, green: 0.0, blue: 0.3),
                    Color.purple.opacity(0.8)
                ]),
                startPoint: animate ? .topLeading : .bottomTrailing,
                endPoint: animate ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animate)
            .onAppear { self.animate = true }
            
            // 🌠 流れ星レイヤー
            StarryOverlayView()
        }
    }
    
    func updateBackground(for selectedSounds: [SoundType]) {
        self.selectedSounds = selectedSounds
        // もしselectedSoundsが選ばれていたら
        if !selectedSounds.isEmpty {
            // 背景再生
            startBackgroundRotation()
        } else {
            // 背景停止
            stopBackgroundRotation()
        }
    }
    
    private func startBackgroundRotation() {
        // まず前のタイマーを止める
        stopBackgroundRotation()
        // 背景を1回変更する
        changeBackground()
        // 10秒ごとに背景を変えるタイマーを起動
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            self?.changeBackground()
        }
    }
    // すべてのサウンドが止まったとき用
    private func stopBackgroundRotation() {
        // 現在動いているタイマーを止める
        timer?.invalidate()
        timer = nil
        // 背景の順番を最初に戻す
        currentIndex = 0
    }
    
    private func changeBackground() {
        guard !selectedSounds.isEmpty else {
            selectedSound = nil
            return
        }
        // 音を順番に切り替えられる
        selectedSound = selectedSounds[currentIndex % selectedSounds.count]
        // 次のサウンドが選ばれるようになる
        currentIndex += 1
    }
    // ここだけサウンド周りの処理
    func stopAll() {
        SoundManager.shared.stopAll()
        selectedSounds.removeAll()
        selectedSound = nil
        stopBackgroundRotation()
    }
}
