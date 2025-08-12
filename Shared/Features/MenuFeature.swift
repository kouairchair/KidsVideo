//
//  MenuFeature.swift
//  KidsVideo
//
//  TCA Menu Feature - Main menu state management
//

import ComposableArchitecture
import Foundation
import AVFAudio
#if canImport(UIKit)
                import UIKit
#endif

// MARK: - Menu Feature

@Reducer
struct MenuFeature {
    @ObservableState
    struct State: Equatable {
        var menuImages: [MenuImage] = []
        var isAnimating = false
        var currentAlphaValue: Double = 3.0
        var backgroundImageName: String = "menu_background_image_jinan"
        var isBackgroundMusicPlaying = false
    }
    
    enum Action {
        case onAppear
        case onDisappear
        case didTapChannel(Channel)
        case startAnimation
        case loadMenuImages
        case menuImagesLoaded([MenuImage])
        case playBackgroundMusic
        case stopBackgroundMusic
        case changeBrightness(Double)
        case backToMenuNotificationReceived
    }
    
    @Dependency(\.backgroundMusicClient) var backgroundMusicClient
    @Dependency(\.menuImageClient) var menuImageClient
    @Dependency(\.configurationClient) var configurationClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(
                    .send(.loadMenuImages),
                    .send(.startAnimation),
                    .send(.playBackgroundMusic)
                )
                
            case .onDisappear:
                return .send(.stopBackgroundMusic)
                
            case .loadMenuImages:
                let images = menuImageClient.getImages()
                return .send(.menuImagesLoaded(images))
                
            case .menuImagesLoaded(let images):
                state.menuImages = images
                
                // Load background image from configuration
                if let configuration = configurationClient.loadConfiguration() {
                    state.backgroundImageName = configuration.backgroundImage
                }
                return .none
                
            case .startAnimation:
                state.isAnimating = true
                return .none
                
            case .didTapChannel( _):
                return .send(.stopBackgroundMusic)
                
            case .playBackgroundMusic:
                state.isBackgroundMusicPlaying = true
                return .run { _ in
                    await backgroundMusicClient.play()
                }
                
            case .stopBackgroundMusic:
                state.isBackgroundMusicPlaying = false
                return .run { _ in
                    await backgroundMusicClient.stop()
                }
                
            case .changeBrightness(let value):
                state.currentAlphaValue = value
                return .run { _ in
                    await backgroundMusicClient.changeBrightness(value)
                }
                
            case .backToMenuNotificationReceived:
                return .send(.playBackgroundMusic)
            }
        }
    }
}

// MARK: - Dependencies

struct BackgroundMusicClient {
    var play: @Sendable () async -> Void
    var stop: @Sendable () async -> Void
    var changeBrightness: @Sendable (Double) async -> Void
}

extension BackgroundMusicClient: DependencyKey {
    static let liveValue = BackgroundMusicClient(
        play: {
            await MainActor.run {
                // Stop any existing player before creating/playing a new one
                ContentView.sharedBDPlayer?.stop()
                do {
                    ContentView.sharedBDPlayer = try AVAudioPlayer(contentsOf: MusicMaker.getTodayMusic().fileUrl!)
                    ContentView.sharedBDPlayer?.play()
                } catch {
                    print("Couldn't play audio. Error: \(error)")
                }
            }
        },
        stop: {
            await MainActor.run {
                ContentView.sharedBDPlayer?.stop()
            }
        },
        changeBrightness: { value in
            await MainActor.run {
#if canImport(UIKit)
                let keyWindow: UIWindow?
                if #available(iOS 15.0, *) {
                    keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.keyWindow
                } else {
                    keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
                }
                guard let window = keyWindow else {
                    print("Warning: Could not get key window, skipping brightness adjustment")
                    return
                }
                window.alpha = value * 0.1
#endif
            }
        }
    )
}

struct MenuImageClient {
    var getImages: @Sendable () -> [MenuImage]
}

extension MenuImageClient: DependencyKey {
    static let liveValue = MenuImageClient(
        getImages: {
            MenuImageMaker.getImages()
        }
    )
}

struct ConfigurationClient {
    var loadConfiguration: @Sendable () -> VideoConfiguration?
}

extension ConfigurationClient: DependencyKey {
    static let liveValue = ConfigurationClient(
        loadConfiguration: {
            ChildConfigurationManager.loadConfiguration()
        }
    )
}

extension DependencyValues {
    var backgroundMusicClient: BackgroundMusicClient {
        get { self[BackgroundMusicClient.self] }
        set { self[BackgroundMusicClient.self] = newValue }
    }
    
    var menuImageClient: MenuImageClient {
        get { self[MenuImageClient.self] }
        set { self[MenuImageClient.self] = newValue }
    }
    
    var configurationClient: ConfigurationClient {
        get { self[ConfigurationClient.self] }
        set { self[ConfigurationClient.self] = newValue }
    }
}
