//
//  VideoPlaybackTracker.swift
//  KidsVideo
//
//  Created by AI Assistant
//

import Foundation
import AVFoundation

class VideoPlaybackTracker {
    static let shared = VideoPlaybackTracker()
    
    private var playbackStartTime: Date?
    private var currentContent: Content?
    private var timeObserver: Any?
    
    private init() {}
    
    // MARK: - Start tracking
    func startTracking(content: Content, player: AVPlayer) {
        currentContent = content
        playbackStartTime = Date()
        let channelStr = stringFromChannel(content.channel)
        
        // Mark as played immediately when starting
        VideoPlaybackManager.shared.markVideoAsPlayed(
            channel: channelStr,
            videoIndex: content.videoIndex
        )
        
        // Remove previous observer if exists
        if let observer = timeObserver {
            player.removeTimeObserver(observer)
        }
        
        // Add periodic time observer to track playback time
        let interval = CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] _ in
            self?.updatePlaybackTime()
        }
    }
    
    // MARK: - Stop tracking
    func stopTracking(player: AVPlayer) {
        if let observer = timeObserver {
            player.removeTimeObserver(observer)
            timeObserver = nil
        }
        
        updatePlaybackTime() // Final update
        playbackStartTime = nil
        currentContent = nil
    }
    
    // MARK: - Private methods
    private func updatePlaybackTime() {
        guard let content = currentContent,
              let startTime = playbackStartTime else { return }
        
        let currentTime = Date()
        let additionalTime = currentTime.timeIntervalSince(startTime)
        let channelStr = stringFromChannel(content.channel)
        
        // Only update if we've tracked for at least 1 second
        if additionalTime >= 1.0 {
            VideoPlaybackManager.shared.updatePlaybackTime(
                channel: channelStr,
                videoIndex: content.videoIndex,
                additionalTime: additionalTime
            )
            
            // Reset start time for next interval
            playbackStartTime = currentTime
        }
    }
}
