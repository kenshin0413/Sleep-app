//
//  TemplateCreateView.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/29.
//

import SwiftUI
import Foundation

struct TemplateCreateView: View {
    @ObservedObject var templateVM: TemplateViewModel
    @ObservedObject var homeVM: HomeViewModel
    @State private var title = ""
    @State private var soundSettings: [SoundSetting] = [SoundSetting(soundType: .rain, durationSeconds: 600)]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 他のViewと同様のグラデーション背景＋星
                homeVM.AnimatedGradientBackground()
                StarryOverlayView()
                    .allowsHitTesting(false)
                
                VStack(spacing: 12) {
                    
                    Form {
                        Section {
                            TextField("例: 雨＋焚き火の夜", text: $title)
                        } header: {
                            Text("テンプレ名").foregroundColor(.white)
                        }
                        
                        Section {
                            Text("左にスワイプで削除")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            
                            ForEach($soundSettings) { $setting in
                                VStack(alignment: .leading, spacing: 8) {
                                    Picker("サウンド", selection: $setting.soundType) {
                                        ForEach(SoundType.allCases, id: \.self) { type in
                                            Text(type.displayName).tag(type)
                                        }
                                    }
                                    
                                    Toggle("終了時刻で指定", isOn: Binding(
                                        get: { setting.endTime != nil },
                                        set: { useEnd in
                                            if useEnd {
                                                // 終了時刻で指定する場合は再生時間をクリア
                                                setting.endTime = Date()
                                                setting.durationSeconds = nil
                                            } else {
                                                // 再生時間で指定に戻す場合は終了時刻をクリアし、デフォルト値を設定
                                                setting.endTime = nil
                                                if setting.durationSeconds == nil { setting.durationSeconds = 600 }
                                            }
                                        }
                                    ))
                                    
                                    if setting.endTime != nil {
                                        DatePicker("終了時刻",
                                                   selection: Binding(
                                                    get: { setting.endTime ?? Date() },
                                                    set: { setting.endTime = $0 }
                                                   ),
                                                   displayedComponents: .hourAndMinute)
                                    } else {
                                        // 分表示（ローカライズ対応）
                                        Stepper(
                                            String(
                                                format: NSLocalizedString("再生時間: %d 分", comment: "Stepper label: duration minutes"),
                                                (setting.durationSeconds ?? 0) / 60
                                            ),
                                            value: Binding(
                                                get: { (setting.durationSeconds ?? 0) / 60 },
                                                set: { setting.durationSeconds = $0 * 60 }
                                            ),
                                            in: 1...60,
                                            step: 5
                                        )
                                    }
                                }
                            }
                            .onDelete { index in
                                soundSettings.remove(atOffsets: index)
                            }
                            
                            Button {
                                soundSettings.append(SoundSetting(soundType: .rain, durationSeconds: 300))
                            } label: {
                                Label("サウンドを追加", systemImage: "plus.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        } header: {
                            Text("サウンド設定").foregroundColor(.white)
                        }
                        
                        Button("保存") {
                            let template = SoundTemplate(
                                id: UUID(),
                                title: title.isEmpty ? "新しいテンプレート" : title,
                                sounds: soundSettings
                            )
                            templateVM.add(template)
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.indigo)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("テンプレ作成")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Label("閉じる", systemImage: "xmark.circle.fill")
                            .foregroundColor(.yellow)
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    TemplateCreateView(templateVM: TemplateViewModel(), homeVM: HomeViewModel())
}
