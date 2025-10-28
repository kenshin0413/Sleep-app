//
//  HomeView.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/22.
//

import SwiftUI
import AVKit

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var soundViewModel = SoundSelectViewModel()
    
    var body: some View {
        ZStack {
            // sにサウンドネーム
            if let s = homeViewModel.selectedSound,
               let url = Bundle.main.url(forResource: s.bgVideoName, withExtension: "mp4") {
                VideoBackgroundView(player: AVPlayer(url: url))
                // .idがないとサウンドの区別ができない
                    .id(s.bgVideoName)
                    .transition(.opacity.animation(.easeInOut(duration: 1.5)))
                // 全画面表示
                    .ignoresSafeArea()
            } else {
                homeViewModel.AnimatedGradientBackground()
            }
            
            VStack(spacing: 40) {
                Spacer()
                Text("夜音 - Yoruoto")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                
                if homeViewModel.selectedSounds.isEmpty {
                    Text("音を選んで始めよう")
                        .foregroundColor(.white.opacity(0.9))
                        .font(.title3)
                } else {
                    VStack {
                        Text("再生中の音：")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.subheadline)
                        // .mapは配列から該当の要素を取り出す
                        Text(homeViewModel.selectedSounds.map { $0.displayName }.joined(separator: "・"))
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                
                Button {
                    homeViewModel.showingSoundSelect = true
                } label: {
                    Label("サウンドを選ぶ", systemImage: "music.note.list")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal, 30)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Capsule())
                        .shadow(radius: 10)
                }
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $homeViewModel.showingSoundSelect) {
            SoundSelectView(soundViewModel: soundViewModel,
                            homeViewModel: homeViewModel)
        }
    }
}

#Preview {
    HomeView()
}
