//
//  MenuImage.swift
//  KidsVideo
//
//  Created by tanakabp on 2021/09/28.
//

import SwiftUI
 
public struct MenuImage: Identifiable, Equatable {
    public var id = UUID().uuidString
    
    let fileName: String
    let channel: Channel
    let image: UIImage?
    
    public init(fileName: String, fileExt: String, channel: Channel) {
        self.fileName = fileName
        self.channel = channel
        if let path = Bundle.main.path(forResource: fileName, ofType: fileExt),
           let image = UIImage(contentsOfFile: path) {
            self.image = image
        } else {
            self.image = nil
        }
    }
    
    public static func == (lhs: MenuImage, rhs: MenuImage) -> Bool {
        return lhs.id == rhs.id && lhs.fileName == rhs.fileName && lhs.channel == rhs.channel
    }
}
