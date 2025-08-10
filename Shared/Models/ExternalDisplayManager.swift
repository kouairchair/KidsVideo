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
    
    private override init() {
        super.init()
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
