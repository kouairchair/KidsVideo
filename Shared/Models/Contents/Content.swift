

import Foundation

public struct Content {
    let fileName: String
    let fileExt: String
    let channel: Channel
    let totalTime: String
    
    public init(fileName: String, fileExt: String, totalTime: String, channel: Channel) {
        self.fileName = fileName
        self.fileExt = fileExt
        self.channel = channel
        self.totalTime = totalTime
    }
}
