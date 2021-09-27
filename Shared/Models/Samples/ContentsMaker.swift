//
//  ContentsMaker.swift
//  SummerPlayerViewDemo
//
//  Created by derrick on 2020/09/29.
//  Copyright © 2020 Derrick. All rights reserved.
//

import Foundation

struct ContentsMaker {
    public static func getContents() -> [Content] {
        
        let contents = [
            Content(fileName: "レオくんがアンパンマンたちと遊ぶよ！ビーズの中からペロペロキャンディ！レオスマイル", fileExt: "mp4", totalTime: "10:47"),
            Content(fileName: "レオくんがアンパンマンのおしゃべりすいはんきと元気100ばい和食セットであそぶよ！レオスマイル", fileExt: "mp4", totalTime: "11:30")
        ]
        
        return contents
    }
}
