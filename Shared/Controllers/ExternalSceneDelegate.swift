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

        print("✅ ExternalSceneDelegate: willConnectTo")

        // Create the window for the external display
        self.window = UIWindow(windowScene: windowScene)

        // Create and set up the root view controller
        let externalPlayerVC = ExternalPlayerViewController()
        self.window?.rootViewController = externalPlayerVC
        
        // Store the view controller in the manager for later access
        ExternalDisplayManager.shared.externalPlayerViewController = externalPlayerVC
        
        // Sync the player state if the main player is already running
        ExternalDisplayManager.shared.syncPlayerToExternalDisplay()

        self.window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        print("✅ ExternalSceneDelegate: sceneDidDisconnect")
        
        // Clean up resources
        ExternalDisplayManager.shared.externalPlayerViewController = nil
        self.window = nil
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // When the external screen becomes active, ensure content is synced.
        ExternalDisplayManager.shared.syncPlayerToExternalDisplay()
    }
}
