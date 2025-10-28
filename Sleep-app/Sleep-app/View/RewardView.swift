//
//  RewardView.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/27.
//

import SwiftUI
import GoogleMobileAds

final class RewardedAdManager: NSObject, ObservableObject, FullScreenContentDelegate {
    @Published var isReady = false
    private var rewardedAd: RewardedAd?
    private let adUnitID = "ca-app-pub-3940256099942544/1712485313" // テストID

    func load() {
        let request = Request()
        RewardedAd.load(with: adUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("❌ Failed to load ad:", error.localizedDescription)
                self?.isReady = false
                return
            }
            print("✅ Rewarded ad loaded successfully.")
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
            self?.isReady = true
        }
    }

    func show(from root: UIViewController, onReward: @escaping () -> Void) {
        guard let ad = rewardedAd else { return }
        ad.present(from: root, userDidEarnRewardHandler: onReward) // ✅ 新しい書き方
        rewardedAd = nil
        load() // 次の広告をプリロード
    }

    func adDidDismissFullScreenContent(_ ad: any FullScreenPresentingAd) {
        print("🌀 Ad dismissed — reloading next one...")
        load()
    }
}

struct RewardedButton: View {
    @StateObject private var ads = RewardedAdManager()
    var onReward: () -> Void

    var body: some View {
        Button(ads.isReady ? "動画を見て保存を解放" : "読み込み中…") {
            if let root = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow }).first?.rootViewController {
                ads.show(from: root, onReward: onReward)
            }
        }
        .onAppear { ads.load() }
        .disabled(!ads.isReady)
    }
}
