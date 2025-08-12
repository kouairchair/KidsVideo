//
//  PlayerView.swift
//  KidsVideo
//
//  TCA Player View - Uses TCA store for state management
//

import SwiftUI
import ComposableArchitecture

struct PlayerView: View {
    let store: StoreOf<PlayerFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                PlayerViewControllerWrapper(
                    selectedChannel: viewStore.selectedChannel,
                    action: {
                        // This will be called when navigating to player
                    }
                )
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Close") {
                            viewStore.send(.delegate(.didDismiss))
                        }
                    }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onDisappear {
                viewStore.send(.onDisappear)
            }
        }
    }
}

#Preview {
    PlayerView(store: Store(initialState: PlayerFeature.State(selectedChannel: .minecraft)) {
        PlayerFeature()
    })
}
