//
//  HomeView.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/22.
//

import SwiftUI
import AVKit

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    var body: some View {
        ZStack {
            if let s = viewModel.selectedSound,
               let url = Bundle.main.url(forResource: s.bgVideoName, withExtension: "mp4") {
                VideoBackgroundView(player: AVPlayer(url: url))
                    .id(s.bgVideoName)           
                    .ignoresSafeArea()
            } else {
                viewModel.AnimatedGradientView()
            }
            
            VStack(spacing: 40) {
                Spacer()
                Text("夜音 - Yoruoto")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                
                Text(viewModel.selectedSound == nil ? "音を選んで始めよう" : "再生中：\(viewModel.selectedSound!.displayName)")
                    .foregroundColor(.white.opacity(0.9))
                    .font(.title3)
                
                Button {
                    viewModel.showingSoundSelect = true
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
        .sheet(isPresented: $viewModel.showingSoundSelect) {
            // 💡 単一の真実：選択状態をBindingで渡す
            SoundSelectView(current: $viewModel.selectedSound)
        }
        // 💿 再生はHome側で一元管理（選択が変わったら再生/停止）
        .onChange(of: viewModel.selectedSound) { oldValue, newValue in
            SoundManager.shared.stopAll()
            if let t = newValue {
                SoundManager.shared.playSound(named: t.rawValue)
            }
        }
    }
}

#Preview {
    HomeView()
}
