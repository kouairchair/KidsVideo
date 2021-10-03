//
//  Music.swift
//  KidsVideo
//
//  Created by headspinnerd on 2021/09/29.
//

import Foundation

public struct Music {
    let fileName: String
    let fileUrl: URL?
    
    public init(fileName: String, fileExt: String) {
        self.fileName = fileName
        if let url = Bundle.main.url(forResource: fileName, withExtension: fileExt) {
            self.fileUrl = url
        } else {
            self.fileUrl = nil
        }
    }
}
