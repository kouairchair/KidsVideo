//
//  VideoPlaybackManager.swift
//  KidsVideo
//
//  Created by AI Assistant
//

import Foundation
import CoreData

class VideoPlaybackManager {
    static let shared = VideoPlaybackManager()
    
    private init() {}
    
    private var context: NSManagedObjectContext {
        return PersistenceController.shared.container.viewContext
    }
    
    // MARK: - Save playback data
    func updatePlaybackTime(channel: String, videoIndex: Int, additionalTime: TimeInterval) {
        let playback = getOrCreatePlayback(channel: channel, videoIndex: videoIndex)
        playback.totalPlaybackTime += additionalTime
        playback.lastPlayedDate = Date()
        
        saveContext()
    }
    
    func markVideoAsPlayed(channel: String, videoIndex: Int) {
        let playback = getOrCreatePlayback(channel: channel, videoIndex: videoIndex)
        playback.lastPlayedDate = Date()
        
        saveContext()
    }
    
    // MARK: - Retrieve playback data
    func getPlaybackData(channel: String, videoIndex: Int) -> VideoPlayback? {
        let request: NSFetchRequest<VideoPlayback> = VideoPlayback.fetchRequest()
        request.predicate = NSPredicate(format: "channel == %@ AND videoIndex == %d", channel, videoIndex)
        
        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            print("Error fetching playback data: \(error)")
            return nil
        }
    }
    
    func getAllPlaybackData(for channel: String) -> [VideoPlayback] {
        let request: NSFetchRequest<VideoPlayback> = VideoPlayback.fetchRequest()
        request.predicate = NSPredicate(format: "channel == %@", channel)
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching all playback data: \(error)")
            return []
        }
    }
    
    func getLastPlayedVideo(for channel: String) -> VideoPlayback? {
        let request: NSFetchRequest<VideoPlayback> = VideoPlayback.fetchRequest()
        request.predicate = NSPredicate(format: "channel == %@ AND lastPlayedDate != nil", channel)
        request.sortDescriptors = [NSSortDescriptor(key: "lastPlayedDate", ascending: false)]
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            print("Error fetching last played video: \(error)")
            return nil
        }
    }
    
    // MARK: - Private helpers
    private func getOrCreatePlayback(channel: String, videoIndex: Int) -> VideoPlayback {
        if let existing = getPlaybackData(channel: channel, videoIndex: videoIndex) {
            return existing
        }
        
        let newPlayback = VideoPlayback(context: context)
        newPlayback.channel = channel
        newPlayback.videoIndex = Int32(videoIndex)
        newPlayback.totalPlaybackTime = 0.0
        
        return newPlayback
    }
    
    private func saveContext() {
        PersistenceController.shared.save()
    }
}