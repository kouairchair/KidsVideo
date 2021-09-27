

import Foundation

public struct Content {
    let fileName: String
    let fileExt: String
    let totalTime: String
    
    public init(fileName: String, fileExt: String, totalTime: String) {
        self.fileName = fileName
        self.fileExt = fileExt
        self.totalTime = totalTime
    }
}
