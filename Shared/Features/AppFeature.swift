//
//  AppFeature.swift
//  KidsVideo
//
//  TCA App Feature - Root app state management
//

import ComposableArchitecture
import Foundation

// MARK: - App Feature

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var menu = MenuFeature.State()
        var player: PlayerFeature.State?
        var isPlayerPresented = false
    }
    
    enum Action {
        case menu(MenuFeature.Action)
        case player(PlayerFeature.Action)
        case presentPlayer(Channel)
        case dismissPlayer
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.menu, action: \.menu) {
            MenuFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .menu(.didTapChannel(let channel)):
                state.player = PlayerFeature.State(selectedChannel: channel)
                state.isPlayerPresented = true
                return .none
                
            case .presentPlayer(let channel):
                state.player = PlayerFeature.State(selectedChannel: channel)
                state.isPlayerPresented = true
                return .none
                
            case .dismissPlayer:
                state.isPlayerPresented = false
                state.player = nil
                return .none
                
            case .player(.delegate(.didDismiss)):
                return .send(.dismissPlayer)
                
            case .menu, .player:
                return .none
            }
        }
        .ifLet(\.player, action: \.player) {
            PlayerFeature()
        }
    }
}