//
//  ExternalSceneDelegate.swift
//  KidsVideo
//
//  Created by AI Assistant on 2025/08/09.
//

import UIKit

class ExternalSceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 外部ディスプレイ専用のシーン設定
        if session.role == .windowExternalDisplay {
            setupExternalDisplayScene(windowScene: windowScene)
        }
    }
    
    private func setupExternalDisplayScene(windowScene: UIWindowScene) {
        // 外部ディスプレイ用のウィンドウを作成
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .black
        
        // 外部ディスプレイ専用のビューコントローラーを設定
        let externalPlayerVC = ExternalPlayerViewController()
        window?.rootViewController = externalPlayerVC
        window?.makeKeyAndVisible()
        
        // ExternalDisplayManagerに登録
        ExternalDisplayManager.shared.externalPlayerViewController = externalPlayerVC
        
        // 既にメインプレイヤーが存在する場合は同期
        ExternalDisplayManager.shared.updateExternalDisplayContent()
        
        print("External display scene configured: \(windowScene.screen.bounds)")
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // 外部ディスプレイシーンが切断された時の処理
        ExternalDisplayManager.shared.externalPlayerViewController = nil
        window = nil
        print("External display scene disconnected")
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // 外部ディスプレイがアクティブになった時の処理
        ExternalDisplayManager.shared.updateExternalDisplayContent()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
    }
}