//
//  SoundSelectView.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/22.
//

import SwiftUI

struct SoundSelectView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var current: SoundType?   // ← Homeから渡される現在の選択
    @State private var animateGradient = false
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    animateGradient ? Color.indigo.opacity(0.7) : Color.blue.opacity(0.4),
                    Color.black
                ],
                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                endPoint: animateGradient ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: animateGradient)
            .onAppear { animateGradient = true }
            
            VStack(spacing: 40) {
                Text("夜音 - Yoruoto")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(.top, 50)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        ForEach(SoundType.allCases, id: \.self) { type in
                            // 🔎 再生中かどうかはBindingから判定
                            let isActive = (type == current)
                            
                            Button {
                                current = type   // ← HomeのselectedSoundが更新される
                                dismiss()        // モーダルを閉じる（Homeで再生＆背景切替）
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
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(isActive ? Color.yellow.opacity(0.3) : Color.white.opacity(0.1)) // 再生中は黄色背景
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                }
                .frame(maxHeight: 400)
                
                Button {
                    current = nil  // 全停止（Home側でstopAllされる）
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
            }
        }
    }
}

#Preview {
    SoundSelectView(current: .constant(.wave))
}
