//
//  ExternalDisplayManager.swift
//  KidsVideo
//
//  Created by AI Assistant on 2025/08/09.
//

import UIKit
import AVFoundation
import AVKit

// MARK: - Notification Names
extension Notification.Name {
    static let externalDisplayDidConnect = Notification.Name("ExternalDisplayDidConnect")
    static let externalDisplayDidDisconnect = Notification.Name("ExternalDisplayDidDisconnect")
}

class ExternalDisplayManager: NSObject {
    static let shared = ExternalDisplayManager()
    
    private var externalWindow: UIWindow?
    var externalPlayerViewController: ExternalPlayerViewController? // Changed from private to internal
    private weak var mainPlayerViewController: PlayerViewController?
    
    private override init() {
        super.init()
        setupNotifications()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(externalDisplayDidConnect),
            name: UIScreen.didConnectNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(externalDisplayDidDisconnect),
            name: UIScreen.didDisconnectNotification,
            object: nil
        )
    }
    
    @objc private func externalDisplayDidConnect(_ notification: Notification) {
        guard let externalScreen = notification.object as? UIScreen else { return }
        setupExternalDisplay(screen: externalScreen)
    }
    
    @objc private func externalDisplayDidDisconnect(_ notification: Notification) {
        cleanupExternalDisplay()
    }
    
    private func setupExternalDisplay(screen: UIScreen) {
        // 外部ディスプレイ専用のウィンドウを作成
        externalWindow = UIWindow(frame: screen.bounds)
        externalWindow?.screen = screen
        externalWindow?.isHidden = false
        
        // 外部ディスプレイ専用のビューコントローラーを作成
        externalPlayerViewController = ExternalPlayerViewController()
        externalWindow?.rootViewController = externalPlayerViewController
        
        // メインプレイヤーから動画情報を同期
        if let mainPlayer = mainPlayerViewController {
            syncPlayerToExternalDisplay(mainPlayer: mainPlayer)
        }
        
        print("External display connected: \(screen.bounds)")
    }
    
    private func cleanupExternalDisplay() {
        externalWindow?.isHidden = true
        externalWindow = nil
        externalPlayerViewController = nil
        
        print("External display disconnected")
    }
    
    func registerMainPlayer(_ playerViewController: PlayerViewController) {
        mainPlayerViewController = playerViewController
        
        // 既に外部ディスプレイが接続されている場合
        if UIScreen.screens.count > 1 && externalWindow == nil {
            setupExternalDisplay(screen: UIScreen.screens[1])
        }
    }
    
    func unregisterMainPlayer() {
        mainPlayerViewController = nil
        cleanupExternalDisplay()
    }
    
    private func syncPlayerToExternalDisplay(mainPlayer: PlayerViewController) {
        guard let externalVC = externalPlayerViewController,
              let summerPlayerView = mainPlayer.summerPlayerView else { return }
        
        // 外部ディスプレイに動画プレイヤーを設定
        externalVC.setupPlayerFromMain(summerPlayerView: summerPlayerView)
    }
    
    func updateExternalDisplayContent() {
        if let mainPlayer = mainPlayerViewController {
            syncPlayerToExternalDisplay(mainPlayer: mainPlayer)
        }
    }
    
    var isExternalDisplayConnected: Bool {
        return UIScreen.screens.count > 1
    }
    
    var externalScreenBounds: CGRect? {
        return UIScreen.screens.count > 1 ? UIScreen.screens[1].bounds : nil
    }
}
