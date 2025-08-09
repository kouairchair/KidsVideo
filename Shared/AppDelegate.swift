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
        
        let sceneConfiguration: UISceneConfiguration
        
        if connectingSceneSession.role == .windowExternalDisplay {
            // 外部ディスプレイ用のシーン設定
            sceneConfiguration = UISceneConfiguration(name: "External Display", sessionRole: connectingSceneSession.role)
            sceneConfiguration.delegateClass = ExternalSceneDelegate.self
            print("Configuring external display scene")
        } else {
            // メインディスプレイ用のシーン設定
            sceneConfiguration = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
            sceneConfiguration.delegateClass = SceneDelegate.self
            print("Configuring main display scene")
        }
        
        return sceneConfiguration
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        print("Scene sessions discarded: \(sceneSessions.count)")
    }
}