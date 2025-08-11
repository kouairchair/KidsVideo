//
//  TCATests.swift
//  KidsVideo Tests
//
//  Unit tests for TCA features
//

import XCTest
import ComposableArchitecture
@testable import KidsVideo

final class TCATests: XCTestCase {
    
    func testAppFeatureInitialState() {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        // Test initial state
        store.state.isPlayerPresented = false
        store.state.player = nil
    }
    
    func testMenuFeatureOnAppear() {
        let store = TestStore(initialState: MenuFeature.State()) {
            MenuFeature()
        } withDependencies: {
            $0.menuImageClient = .testValue
            $0.configurationClient = .testValue
            $0.backgroundMusicClient = .testValue
        }
        
        store.send(.onAppear)
        store.receive(.loadMenuImages)
        store.receive(.startAnimation) {
            $0.isAnimating = true
        }
        store.receive(.playBackgroundMusic) {
            $0.isBackgroundMusicPlaying = true
        }
    }
    
    func testPlayerFeatureInitialization() {
        let initialState = PlayerFeature.State(selectedChannel: .minecraft)
        let store = TestStore(initialState: initialState) {
            PlayerFeature()
        } withDependencies: {
            $0.contentClient = .testValue
            $0.playerClient = .testValue
        }
        
        store.send(.onAppear)
        store.receive(.loadContents)
    }
    
    func testChannelNavigation() {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        store.send(.presentPlayer(.minecraft)) {
            $0.isPlayerPresented = true
            $0.player = PlayerFeature.State(selectedChannel: .minecraft)
        }
        
        store.send(.dismissPlayer) {
            $0.isPlayerPresented = false
            $0.player = nil
        }
    }
}

// MARK: - Test Dependencies

extension MenuImageClient {
    static let testValue = Self(
        getImages: {
            [
                MenuImage(fileName: "Test", fileExt: "jpeg", channel: .minecraft)
            ]
        }
    )
}

extension ConfigurationClient {
    static let testValue = Self(
        loadConfiguration: {
            VideoConfiguration(
                videos: [],
                menuImages: [],
                backgroundImage: "test_background"
            )
        }
    )
}

extension BackgroundMusicClient {
    static let testValue = Self(
        play: {},
        stop: {},
        changeBrightness: { _ in }
    )
}

extension ContentClient {
    static let testValue = Self(
        getContents: { _ in
            [
                Content(fileName: "test", fileExt: "mp4", totalTime: "10:00", channel: .minecraft)
            ]
        }
    )
}

extension PlayerClient {
    static let testValue = Self(
        loadContent: { _ in },
        play: {},
        pause: {},
        stop: {},
        seek: { _ in },
        setVolume: { _ in }
    )
}