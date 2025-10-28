//
//  Sleep_appApp.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/22.
//

import SwiftUI
import GoogleMobileAds

@main
struct Sleep_appApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        // ✅ SDK初期化（v11対応）
        MobileAds.shared.start(completionHandler: nil)

        // ✅ （任意）テスト端末設定
        MobileAds.shared.requestConfiguration.testDeviceIdentifiers = ["YOUR-DEVICE-ID"]

        print("✅ Google Mobile Ads SDK initialized successfully")
        return true
    }
}

