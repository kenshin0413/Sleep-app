//
//  SoundSelectView.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/22.
//

import SwiftUI

struct SoundSelectView: View {
    @ObservedObject var soundViewModel: SoundSelectViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @State private var animateGradient = false
    
    var body: some View {
        ZStack {
            homeViewModel.AnimatedGradientBackground()
            VStack(spacing: 40) {
                Text("夜音 - Yoruoto")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(.top, 50)
                // .vertical 縦方向 showsIndicators バーの有無
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        ForEach(SoundType.allCases, id: \.self) { type in
                            let isActive = soundViewModel.selectedSounds.contains(type)
                            
                            Button {
                                soundViewModel.toggleSound(type)
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: isActive ? "pause.circle.fill" : "play.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(.white)
                                    
                                    Text(type.displayName)
                                        .font(.title3.bold())
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    // ラウンディッドレクタングル
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(isActive ? Color.yellow.opacity(0.3) : Color.white.opacity(0.1))
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                }
                // スクロールバー非表示
                .scrollIndicators(.hidden)
                
                Button {
                    soundViewModel.stopAll()   // サウンドを止める
                    homeViewModel.stopAll()
                    dismiss()
                } label: {
                    Text("すべて停止")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.4))
                        .cornerRadius(16)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 30)
                
                Button {
                    dismiss()
                } label: {
                    Label("閉じる", systemImage: "xmark.circle.fill")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                        .padding()
                }
            }
        }
        .onAppear {
            soundViewModel.onSelectedSoundsChanged = { sounds in
                homeViewModel.updateBackground(for: sounds)
            }
        }
    }
}

#Preview {
    SoundSelectView(soundViewModel: SoundSelectViewModel(), homeViewModel: HomeViewModel())
}
