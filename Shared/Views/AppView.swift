//
//  AppView.swift
//  KidsVideo
//
//  TCA App Root View
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                MenuView(store: store.scope(state: \.menu, action: \.menu))
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .sheet(isPresented: viewStore.binding(
                get: \.isPlayerPresented,
                send: { _ in .dismissPlayer }
            )) {
                if let playerStore = store.scope(state: \.player, action: \.player) {
                    PlayerView(store: playerStore)
                }
            }
        }
    }
}

#Preview {
    AppView(store: Store(initialState: AppFeature.State()) {
        AppFeature()
    })
}