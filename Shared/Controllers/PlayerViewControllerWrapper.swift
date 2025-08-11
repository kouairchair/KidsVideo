//
//  PlayerViewControllerWrapper.swift
//  KidsVideo
//
//  Created by headspinnerd on 2021/09/26.
//

import SwiftUI

struct PlayerViewControllerWrapper : UIViewControllerRepresentable {
    let selectedChannel: Channel
    let action: (() -> Void)
    var onDismiss: (() -> Void)?
    
    func makeUIViewController(context: Context) -> PlayerViewController {
        action()
        let playerVC = PlayerViewController()
        playerVC.selectedChannel = selectedChannel
        return playerVC
    }
    
    func updateUIViewController(_ uiViewController: PlayerViewController, context: Context) {
        // Update the view controller if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onDismiss: onDismiss)
    }
    
    class Coordinator: NSObject {
        let onDismiss: (() -> Void)?
        
        init(onDismiss: (() -> Void)?) {
            self.onDismiss = onDismiss
        }
    }
}
