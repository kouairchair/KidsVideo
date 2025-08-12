import Foundation

public struct Content: Equatable, Hashable, Identifiable {
    public let id = UUID()
    let fileName: String
    let fileExt: String
    let channel: Channel
    let totalTime: String
    let videoIndex: Int // Index in the JSON array
    
    public init(fileName: String, fileExt: String, totalTime: String, channel: Channel, videoIndex: Int = 0) {
        self.fileName = fileName
        self.fileExt = fileExt
        self.channel = channel
        self.totalTime = totalTime
        self.videoIndex = videoIndex
    }
    
    // Get playback data for this content
    func getPlaybackData() -> VideoPlayback? {
        let channelStr = stringFromChannel(channel)
        return VideoPlaybackManager.shared.getPlaybackData(channel: channelStr, videoIndex: videoIndex)
    }
    
    // Get total playback time in seconds
    func getTotalPlaybackTime() -> TimeInterval {
        return getPlaybackData()?.totalPlaybackTime ?? 0.0
    }
    
    // Get last played date
    func getLastPlayedDate() -> Date? {
        return getPlaybackData()?.lastPlayedDate
    }
}
