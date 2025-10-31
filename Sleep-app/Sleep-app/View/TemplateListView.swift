//
//  TemplateListView.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/29.
//

import SwiftUI
import Foundation

struct TemplateListView: View {
    @ObservedObject var templateVM: TemplateViewModel
    @ObservedObject var soundVM: SoundSelectViewModel
    @ObservedObject var homeVM: HomeViewModel
    @StateObject private var listVM = TemplateListViewModel()
    @State private var templateToDelete: SoundTemplate? = nil
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                // ✅ SoundSelectViewと同じ背景
                homeVM.AnimatedGradientBackground()
                    .ignoresSafeArea()
                
                // 星エフェクトを同じにしたい場合
                StarryOverlayView()
                    .allowsHitTesting(false)
                
                VStack {
                    
                    Text("テンプレタップで再生・長押しで削除")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 8)
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(templateVM.templates) { template in
                                Button {
                                    listVM.onSelect(template,
                                                    using: templateVM,
                                                    soundVM: soundVM,
                                                    homeVM: homeVM)
                                    dismiss()
                                } label: {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(template.title)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        
                                        Text(template.sounds.map { $0.soundType.displayName }.joined(separator: "＋"))
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        
                                        ForEach(template.sounds) { s in
                                            HStack {
                                                Text("・" + s.soundType.displayName)
                                                // 終了時刻がある場合は優先して表示（両方ある古いデータへの対処）
                                                if let end = s.endTime {
                                                    Text("〜 " + end.formatted(date: .omitted, time: .shortened))
                                                } else if let sec = s.durationSeconds {
                                                    Text(String(format: NSLocalizedString("%d分", comment: "minutes"), sec / 60))
                                                } else {
                                                    Text("制限なし")
                                                }
                                            }
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(16)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            templateToDelete = template
                                        } label: {
                                            Label("削除", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                    .scrollIndicators(.hidden)
                    
                    Button {
                        dismiss()
                    } label: {
                        Label("閉じる", systemImage: "xmark.circle.fill")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.bottom, 60)
                    }
                }
            }
            .navigationTitle("")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("テンプレート一覧")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        listVM.showCreate = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .sheet(isPresented: $listVM.showCreate) {
            TemplateCreateView(templateVM: templateVM, homeVM: homeVM)
        }
        .ignoresSafeArea()
        .alert(item: $templateToDelete) { template in
            Alert(
                title: Text("テンプレートを削除しますか？"),
                message: Text(template.title),
                primaryButton: .destructive(Text("削除")) {
                    templateVM.delete(template: template)
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    TemplateListView(
        templateVM: TemplateViewModel(),
        soundVM: SoundSelectViewModel(),
        homeVM: HomeViewModel()
    )
}
