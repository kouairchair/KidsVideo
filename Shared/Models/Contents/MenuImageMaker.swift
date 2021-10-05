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
            MenuImage(fileName: "アンパンマンxレオくん", fileExt: "jpeg", channel: .reo_anpanman),
//            MenuImage(fileName: "レオくん", fileExt: "jpeg", channel: .reo),
            MenuImage(fileName: "鈴川綾子", fileExt: "png", channel: .suzukawaAyako),
            MenuImage(fileName: "リトルエンジェル", fileExt: "jpeg", channel: .littleAngel),
            MenuImage(fileName: "MeruChan", fileExt: "png", channel: .meruchan)
        ]
        
        return menuImages
    }
}
