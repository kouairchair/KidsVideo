//
//  KidsVideoApp.swift
//  Shared
//
//  Created by headspinnerd on 2021/09/26.
//

import SwiftUI

@main
struct KidsVideoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
