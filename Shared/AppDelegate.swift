//
//  AppDelegate.swift
//  KidsVideo
//
//  Created by AI Assistant on 2025/08/09.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        print("Connecting scene with role: \(connectingSceneSession.role.rawValue)")
        
        let sceneConfiguration: UISceneConfiguration
        
        if connectingSceneSession.role == .windowExternalDisplay {
            // 外部ディスプレイ用のシーン設定
            print("✅ Configuring for external display.")
            sceneConfiguration = UISceneConfiguration(name: "External Display", sessionRole: connectingSceneSession.role)
            sceneConfiguration.delegateClass = ExternalSceneDelegate.self
        } else {
            // メインディスプレイ用のシーン設定
            print("✅ Configuring for main display.")
            sceneConfiguration = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
            sceneConfiguration.delegateClass = SceneDelegate.self
        }
        
        return sceneConfiguration
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        print("Scene sessions discarded: \(sceneSessions.count)")
    }
}
