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
            Content(fileName: "『シンカリオン チェンジ ザ ワールド』特別編「戦いの記録」", fileExt: "mp4", totalTime: "24:08", channel: .shinkalion),
            Content(fileName: "ついに家が完成!!めっちゃ大変だった…マイクラ実況Part3", fileExt: "mp4", totalTime: "18:58", channel: .minecraft),
            Content(fileName: "ゾンビ_VS_10個のセキュリティ", fileExt: "mp4", totalTime: "27:25", channel: .minecraft),
            Content(fileName: "ダイヤ大量発見!!レア鉱石を掘りまくれ!!マイクラ実況Part5", fileExt: "mp4", totalTime: "23:30", channel: .minecraft),
            Content(fileName: "【特装合体ロボ ジョブレイバー 第1話】出動せよ！ポリスブレイバー【トミカ】", fileExt: "mp4", totalTime: "12:00", channel: .jobraver),
            Content(fileName: "【特装合体ロボ ジョブレイバー 第5話】スーパーアンビュランスとレッドサラマンダー【トミカ】", fileExt: "mp4", totalTime: "12:00", channel: .jobraver),

        ]
        
        return contents
    }
}
