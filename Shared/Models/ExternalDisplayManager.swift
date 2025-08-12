//
//  ExternalDisplayManager.swift
//  KidsVideo
//
//  Created by AI Assistant on 2025/08/09.
//

import UIKit
import AVFoundation

class ExternalDisplayManager: NSObject {
    static let shared = ExternalDisplayManager()
    
    var externalPlayerViewController: ExternalPlayerViewController?
    private weak var mainPlayerViewController: PlayerViewController?
    
    // 電力削減機能のプロパティ
    private var originalBrightness: CGFloat = 1.0
    private var isInPowerSavingMode: Bool = false
    private var externalDisplayCheckTimer: Timer?
    
    private override init() {
        super.init()
        setupExternalDisplayMonitoring()
    }
    
    deinit {
        stopExternalDisplayMonitoring()
    }
    
    // 外部ディスプレイ監視を開始
    private func setupExternalDisplayMonitoring() {
        // 画面接続の通知を監視
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenDidConnect(_:)),
            name: UIScreen.didConnectNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenDidDisconnect(_:)),
            name: UIScreen.didDisconnectNotification,
            object: nil
        )
        
        // 定期的にチェックするタイマーを設定（念のため）
        startExternalDisplayCheckTimer()
    }
    
    private func stopExternalDisplayMonitoring() {
        NotificationCenter.default.removeObserver(self)
        externalDisplayCheckTimer?.invalidate()
        externalDisplayCheckTimer = nil
    }
    
    private func startExternalDisplayCheckTimer() {
        externalDisplayCheckTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.checkExternalDisplayConnection()
        }
    }
    
    @objc private func screenDidConnect(_ notification: Notification) {
        print("External display connected")
        DispatchQueue.main.async { [weak self] in
            self?.handleExternalDisplayConnected()
        }
    }
    
    @objc private func screenDidDisconnect(_ notification: Notification) {
        print("External display disconnected")
        DispatchQueue.main.async { [weak self] in
            self?.handleExternalDisplayDisconnected()
        }
    }
    
    private func checkExternalDisplayConnection() {
        let isCurrentlyConnected = UIScreen.screens.count > 1
        let wasConnected = externalPlayerViewController != nil
        
        if wasConnected && !isCurrentlyConnected {
            // 接続が切れた場合
            DispatchQueue.main.async { [weak self] in
                self?.handleExternalDisplayDisconnected()
            }
        } else if !wasConnected && isCurrentlyConnected {
            // 新しく接続された場合
            DispatchQueue.main.async { [weak self] in
                self?.handleExternalDisplayConnected()
            }
        }
    }
    
    private func handleExternalDisplayConnected() {
        exitPowerSavingMode()
        // 既存の外部ディスプレイ接続処理
    }
    
    private func handleExternalDisplayDisconnected() {
        // 外部ディスプレイが切断された時の処理
        externalPlayerViewController = nil
        
        // 電力削減モードを有効化
        enterPowerSavingMode()
        
        print("External display disconnected - entering power saving mode")
    }
    
    // 電力削減モードを有効化
    private func enterPowerSavingMode() {
        guard !isInPowerSavingMode else { return }
        
        isInPowerSavingMode = true
        
        // 現在の画面の明度を保存
        originalBrightness = UIScreen.main.brightness
        
        // 画面の明度を下げる（30%に）
        UIScreen.main.brightness = max(0.3, originalBrightness * 0.3)
        
        // メインプレイヤーに電力削減モードを通知
        if let mainPlayer = mainPlayerViewController {
            mainPlayer.enterPowerSavingMode()
        }
        
        // アプリケーションレベルの電力削減
        UIApplication.shared.isIdleTimerDisabled = false // スリープを許可
        
        print("Entered power saving mode - brightness reduced, idle timer enabled")
    }
    
    // 電力削減モードを無効化
    private func exitPowerSavingMode() {
        guard isInPowerSavingMode else { return }
        
        isInPowerSavingMode = false
        
        // 画面の明度を元に戻す
        UIScreen.main.brightness = originalBrightness
        
        // メインプレイヤーに通常モードを通知
        if let mainPlayer = mainPlayerViewController {
            mainPlayer.exitPowerSavingMode()
        }
        
        // アプリケーションレベルの設定を戻す
        UIApplication.shared.isIdleTimerDisabled = true // スリープを無効化
        
        print("Exited power saving mode - brightness restored, idle timer disabled")
    }

    func registerMainPlayer(_ playerViewController: PlayerViewController) {
        mainPlayerViewController = playerViewController
    }
    
    func unregisterMainPlayer() {
        mainPlayerViewController = nil
    }
    
    func syncPlayerToExternalDisplay(mainPlayer: PlayerViewController) {
        guard let externalVC = externalPlayerViewController,
              let summerPlayerView = mainPlayer.summerPlayerView else {
            print("Cannot sync player: externalVC or summerPlayerView is nil.")
            return
        }
        
        print("Syncing player state to external display.")
        externalVC.setupPlayerFromMain(summerPlayerView: summerPlayerView)
    }
    
    func syncPlayerToExternalDisplay() {
        guard let mainPlayer = mainPlayerViewController else {
            print("Cannot sync player: mainPlayer is nil.")
            return
        }
        syncPlayerToExternalDisplay(mainPlayer: mainPlayer)
    }
    
    func enableExternalDisplayMode() {
        guard let externalVC = externalPlayerViewController else {
            print("External display not connected.")
            return
        }
        
        // Show video on external display
        externalVC.showVideo()
        syncPlayerToExternalDisplay()
        print("External display mode enabled.")
    }
    
    func disableExternalDisplayMode() {
        guard let externalVC = externalPlayerViewController else {
            print("External display not connected.")
            return
        }
        
        // Hide video on external display
        externalVC.hideVideo()
        print("External display mode disabled.")
    }
    
    var isExternalDisplayConnected: Bool {
        return externalPlayerViewController != nil
    }
}
