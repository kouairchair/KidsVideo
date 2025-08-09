//
//  ExternalDisplayManager.swift
//  KidsVideo
//
//  Created by AI Assistant on 2025/08/09.
//

import UIKit
import AVFoundation
import AVKit

class ExternalDisplayManager: NSObject {
    static let shared = ExternalDisplayManager()
    
    var externalPlayerViewController: ExternalPlayerViewController?
    private weak var mainPlayerViewController: PlayerViewController?
    
    var isExternalDisplayConnected: Bool {
        return UIScreen.screens.count > 1
    }
    
    private override init() {
        super.init()
    }
    
    func registerMainPlayer(_ playerViewController: PlayerViewController) {
        self.mainPlayerViewController = playerViewController
    }
    
    func unregisterMainPlayer() {
        self.mainPlayerViewController = nil
    }
    
    func syncPlayerToExternalDisplay() {
        guard let mainPlayer = mainPlayerViewController,
              let externalVC = externalPlayerViewController,
              let summerPlayerView = mainPlayer.summerPlayerView else {
            print("Cannot sync player: mainPlayer, externalVC, or summerPlayerView is nil.")
            return
        }
        
        print("Syncing player state to external display.")
        externalVC.setupPlayerFromMain(summerPlayerView: summerPlayerView)
    }
}
