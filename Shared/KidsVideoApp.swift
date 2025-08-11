//
//  KidsVideoApp.swift
//  Shared
//
//  Created by headspinnerd on 2021/09/26.
//

import SwiftUI
import UIKit
import ComposableArchitecture

@main
struct KidsVideoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    let persistenceController = PersistenceController.shared
    
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }

    var body: some Scene {
        WindowGroup {
            AppView(store: KidsVideoApp.store)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)) { _ in
                    // メモリ警告時にサムネイルキャッシュをクリア
                    VideoCollectionViewCell.clearThumbnailCache()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                    // バックグラウンド移行時にサムネイルキャッシュをクリア
                    VideoCollectionViewCell.clearThumbnailCache()
                }
        }
    }
}
