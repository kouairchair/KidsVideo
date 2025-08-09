//
//  MenuImageMaker.swift
//  KidsVideo
//
//  Created by tanakabp on 2021/09/28.
//

import Foundation

struct MenuImageMaker {
    public static func getImages() -> [MenuImage] {
        
        let menuImages = [
            MenuImage(fileName: "マイクラ", fileExt: "jpeg", channel: .minecraft),
            MenuImage(fileName: "シンカリオン", fileExt: "jpeg", channel: .shinkalion),
            MenuImage(fileName: "ジョブレイバー", fileExt: "jpeg", channel: .jobraver)
        ]
        
        return menuImages
    }
}
