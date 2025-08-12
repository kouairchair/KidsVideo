//
//  PlayerFeature.swift
//  KidsVideo
//
//  TCA Player Feature - Video player state management
//

import ComposableArchitecture
import Foundation
import AVFoundation

// MARK: - Player Feature

@Reducer
struct PlayerFeature {
    @ObservableState
    struct State: Equatable {
        var selectedChannel: Channel
        var contents: [Content] = []
        var currentContent: Content?
        var isPlaying = false
        var currentTime: TimeInterval = 0
        var duration: TimeInterval = 0
        var volume: Float = 1.0
        var isLoading = false
        
        init(selectedChannel: Channel) {
            self.selectedChannel = selectedChannel
        }
    }
    
    enum Action {
        case onAppear
        case onDisappear
        case loadContents
        case contentsLoaded([Content])
        case selectContent(Content)
        case play
        case pause
        case seek(TimeInterval)
        case volumeChanged(Float)
        case timeUpdated(TimeInterval, TimeInterval) // currentTime, duration
        case playbackFinished
        case nextContent
        case previousContent
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case didDismiss
        }
    }
    
    @Dependency(\.playerClient) var playerClient
    @Dependency(\.contentClient) var contentClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.loadContents)
                
            case .onDisappear:
                return .run { _ in
                    await playerClient.stop()
                }
                
            case .loadContents:
                let contents = contentClient.getContents(state.selectedChannel)
                return .send(.contentsLoaded(contents))
                
            case .contentsLoaded(let contents):
                state.contents = contents
                if let firstContent = contents.first {
                    state.currentContent = firstContent
                    return .send(.selectContent(firstContent))
                }
                return .none
                
            case .selectContent(let content):
                state.currentContent = content
                state.isLoading = true
                return .run { send in
                    await playerClient.loadContent(content)
                    await send(.play)
                }
                
            case .play:
                state.isPlaying = true
                state.isLoading = false
                return .run { _ in
                    await playerClient.play()
                }
                
            case .pause:
                state.isPlaying = false
                return .run { _ in
                    await playerClient.pause()
                }
                
            case .seek(let time):
                state.currentTime = time
                return .run { _ in
                    await playerClient.seek(time)
                }
                
            case .volumeChanged(let volume):
                state.volume = volume
                return .run { _ in
                    await playerClient.setVolume(volume)
                }
                
            case .timeUpdated(let currentTime, let duration):
                state.currentTime = currentTime
                state.duration = duration
                return .none
                
            case .playbackFinished:
                return .send(.nextContent)
                
            case .nextContent:
                guard let currentContent = state.currentContent,
                      let currentIndex = state.contents.firstIndex(of: currentContent),
                      currentIndex + 1 < state.contents.count else {
                    return .none
                }
                let nextContent = state.contents[currentIndex + 1]
                return .send(.selectContent(nextContent))
                
            case .previousContent:
                guard let currentContent = state.currentContent,
                      let currentIndex = state.contents.firstIndex(of: currentContent),
                      currentIndex > 0 else {
                    return .none
                }
                let previousContent = state.contents[currentIndex - 1]
                return .send(.selectContent(previousContent))
                
            case .delegate:
                return .none
            }
        }
    }
}

// MARK: - Dependencies

struct PlayerClient {
    var loadContent: @Sendable (Content) async -> Void
    var play: @Sendable () async -> Void
    var pause: @Sendable () async -> Void
    var stop: @Sendable () async -> Void
    var seek: @Sendable (TimeInterval) async -> Void
    var setVolume: @Sendable (Float) async -> Void
}

extension PlayerClient: DependencyKey {
    static let liveValue = PlayerClient(
        loadContent: { content in
            // Implementation will integrate with existing SummerPlayerView
            await MainActor.run {
                NotificationCenter.default.post(name: .loadContent, object: content)
            }
        },
        play: {
            await MainActor.run {
                NotificationCenter.default.post(name: .playContent, object: nil)
            }
        },
        pause: {
            await MainActor.run {
                NotificationCenter.default.post(name: .pauseContent, object: nil)
            }
        },
        stop: {
            await MainActor.run {
                NotificationCenter.default.post(name: .stopContent, object: nil)
            }
        },
        seek: { time in
            await MainActor.run {
                NotificationCenter.default.post(name: .seekContent, object: time)
            }
        },
        setVolume: { volume in
            await MainActor.run {
                NotificationCenter.default.post(name: .volumeChanged, object: volume)
            }
        }
    )
}

struct ContentClient {
    var getContents: @Sendable (Channel) -> [Content]
}

extension ContentClient: DependencyKey {
    static let liveValue = ContentClient(
        getContents: { channel in
            if let configuration = ChildConfigurationManager.loadConfiguration() {
                return configuration.videos.compactMap { contentData in
                    guard let contentChannel = channelFromString(contentData.channel) else { return nil }
                    return Content(fileName: contentData.fileName, fileExt: contentData.fileExt, totalTime: contentData.totalTime, channel: contentChannel)
                }.filter { $0.channel == channel }
            } else {
                return []
            }
        }
    )
}

extension DependencyValues {
    var playerClient: PlayerClient {
        get { self[PlayerClient.self] }
        set { self[PlayerClient.self] = newValue }
    }
    
    var contentClient: ContentClient {
        get { self[ContentClient.self] }
        set { self[ContentClient.self] = newValue }
    }
}

// MARK: - Notification Extensions

extension Notification.Name {
    static let loadContent = Notification.Name("loadContent")
    static let playContent = Notification.Name("playContent")
    static let pauseContent = Notification.Name("pauseContent")
    static let stopContent = Notification.Name("stopContent")
    static let seekContent = Notification.Name("seekContent")
    static let volumeChanged = Notification.Name("volumeChanged")
}
