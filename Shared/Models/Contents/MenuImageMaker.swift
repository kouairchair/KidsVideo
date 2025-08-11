//
//  MenuImageMaker.swift
//  KidsVideo
//
//  Created by tanakabp on 2021/09/28.
//

import Foundation

struct MenuImageMaker {
    public static func getImages() -> [MenuImage] {
        // Try to load from configuration first
        if let configuration = ChildConfigurationManager.loadConfiguration() {
            return configuration.menuImages.compactMap { menuImageData in
                guard let channel = channelFromString(menuImageData.channel) else {
                    print("Unknown channel: \(menuImageData.channel)")
                    return nil
                }
                return MenuImage(fileName: menuImageData.fileName, 
                               fileExt: menuImageData.fileExt, 
                               channel: channel)
            }
        }
        
        // Fallback to default menu images if configuration loading fails
        let menuImages = [
            MenuImage(fileName: "マイクラ", fileExt: "jpeg", channel: .minecraft),
            MenuImage(fileName: "シンカリオン", fileExt: "jpeg", channel: .shinkalion),
            MenuImage(fileName: "ジョブレイバー", fileExt: "jpeg", channel: .jobraver),
            MenuImage(fileName: "恐竜", fileExt: "jpeg", channel: .dinasaur),
        ]
        
        return menuImages
    }
}

// Global function for channel conversion
public func channelFromString(_ channelString: String) -> Channel? {
    switch channelString.lowercased() {
    case "shinkalion":
        return .shinkalion
    case "minecraft":
        return .minecraft
    case "jobraver":
        return .jobraver
    case "dinasaur":
        return .dinasaur
    case "numberblocks":
        return .numberblocks
    case "jinan":
        return .jinan
    case "chonan":
        return .chonan
    default:
        return nil
    }
}
