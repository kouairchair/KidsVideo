//
//  PlayerViewControllerWrapper.swift
//  KidsVideo
//
//  Created by headspinnerd on 2021/09/26.
//

import SwiftUI

struct PlayerViewControllerWrapper : UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> PlayerViewController {
        return PlayerViewController()
    }
    
    func updateUIViewController(_ uiViewController: PlayerViewController, context: Context) {
        
    }
}
