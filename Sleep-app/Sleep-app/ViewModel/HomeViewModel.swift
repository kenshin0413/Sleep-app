//
//  HomeViewModel.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/23.
//
import SwiftUI
import Foundation

class HomeViewModel: ObservableObject {
    @Published var selectedSound: SoundType? = nil
    @Published var animateGradient = false
    @Published var showingSoundSelect = false
    @Published var animate = false
    
    func AnimatedGradientView() -> some View {
        LinearGradient(
            colors: [
                animate ? Color.indigo.opacity(0.7) : Color.blue.opacity(0.4),
                Color.black
            ],
            startPoint: animate ? .topLeading : .bottomTrailing,
            endPoint: animate ? .bottomTrailing : .topLeading
        )
        .ignoresSafeArea()
        .onAppear {
            // ここで1回だけトリガーを入れる
            withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                self.animate = true
            }
        }
    }
}
