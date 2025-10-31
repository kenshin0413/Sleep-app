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
    @State private var showTimePickerFor: SoundType? = nil
    @State private var selectedEndTime = Date()
    @State private var showTemplateView = false
    
    var body: some View {
        ZStack {
            homeViewModel.AnimatedGradientBackground()
            VStack(spacing: 20) {
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
                                    
                                    if let remaining = soundViewModel.remainingTimes[type] {
                                        Text(String(format: "%02d:%02d", remaining / 60, remaining % 60))
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .monospacedDigit()
                                    } else if let end = soundViewModel.endTimes[type] {
                                        Text(end.formatted(date: .omitted, time: .shortened))
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Menu {
                                        Button("5分") {
                                            soundViewModel.setTimer(for: type, seconds: 300)
                                        }
                                        
                                        Button("10分") {
                                            soundViewModel.setTimer(for: type, seconds: 600)
                                        }
                                        
                                        Button("15分") {
                                            soundViewModel.setTimer(for: type, seconds: 900)
                                        }
                                        
                                        Button("終了時刻を指定") {
                                            selectedEndTime = Date().addingTimeInterval(300)
                                            showTimePickerFor = type
                                        }
                                        
                                        Divider()
                                        Button("キャンセル") {
                                            soundViewModel.cancelTimer(for: type)
                                        }
                                    } label: {
                                        Image(systemName: "timer")
                                            .foregroundColor(.white)
                                    }
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
                    .padding(.horizontal, 20)
                }
                // スクロールバー非表示
                .scrollIndicators(.hidden)
                
                Button {
                    showTemplateView = true
                } label: {
                    Label("テンプレート一覧", systemImage: "music.note.list")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.3))
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                }
                
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
                        .padding(.horizontal, 20)
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
        .sheet(item: $showTimePickerFor) { type in
            VStack {
                Text("終了時刻を設定")
                    .font(.headline)
                    .padding(.top)
                
                DatePicker("終了時刻", selection: $selectedEndTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .padding()
                
                Button("設定") {
                    soundViewModel.setEndTime(for: type, endTime: selectedEndTime)
                    showTimePickerFor = nil
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showTemplateView) {
            TemplateListView(
                templateVM: TemplateViewModel(),
                soundVM: soundViewModel,
                homeVM: homeViewModel
            )
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
