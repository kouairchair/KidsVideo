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
            MenuImage(fileName: "アンパンマンxレオくん", fileExt: "jpeg"),
            MenuImage(fileName: "レオくん", fileExt: "jpeg"),
            MenuImage(fileName: "鈴川綾子", fileExt: "png"),
            MenuImage(fileName: "リトルエンジェル", fileExt: "jpeg"),
            MenuImage(fileName: "MeruChan", fileExt: "png")
        ]
        
        return menuImages
    }
}
