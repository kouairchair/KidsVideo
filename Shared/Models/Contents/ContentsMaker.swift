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
            Content(fileName: "おでかけ_福岡アンパンマンこどもミュージアムアンパンマン顔ボールで遊ぼう_トイキッズ", fileExt: "mp4", totalTime: "14:27", channel: .reo_anpanman),
            Content(fileName: "レオくんがアンパンマンのおしゃべりすいはんきと元気100ばい和食セットであそぶよ！レオスマイル", fileExt: "mp4", totalTime: "11:30", channel: .reo_anpanman),
            Content(fileName: "レオくんがこうえんでアンパンマンのカプセルをさがすよ！_トイキッズ", fileExt: "mp4", totalTime: "11:25", channel: .reo_anpanman),
            Content(fileName: "レオくんがコンビニごっこをしてあそぶよ！コキンちゃんがお客さん！_レオスマイル", fileExt: "mp4", totalTime: "14:38", channel: .reo_anpanman),
            Content(fileName: "レオくんがマックイーンでこうえんにいくよ！アンパンマンたちの顔をさがそう！_トイキッズ", fileExt: "mp4", totalTime: "13:41", channel: .reo_anpanman),
            Content(fileName: "レオくんがこうえんのすなばでアンパンマンとあそぶよきれいにあらってあげよう_トイキッズ", fileExt: "mp4", totalTime: "12:04", channel: .reo_anpanman),
            Content(fileName: "レオくんがアンパンマンのプレイマットであそぶよ！こうえんにパーツをさがしにいくよ！_トイキッズ", fileExt: "mp4", totalTime: "11:50", channel: .reo_anpanman),
            Content(fileName: "レオくんがアンパンマンたちと遊ぶよ！ビーズの中からペロペロキャンディ！レオスマイル", fileExt: "mp4", totalTime: "10:47", channel: .reo_anpanman),
            Content(fileName: "レオくんがアンパンマンのどこでもすなばであそぶよ！こうえんにいってすなあそびをするよ！_トイキッズ", fileExt: "mp4", totalTime: "12:33", channel: .reo_anpanman),
            Content(fileName: "レオくんとあーやんがどこでもすなばであそぶよ！すなのなかにはばいきんまんたちがかくれているよ！_トイキッズ", fileExt: "mp4", totalTime: "11:18", channel: .reo_anpanman),
            Content(fileName: "レオくんがきょうりゅうをやっつける戦隊ヒーローをあらってあげよう_トイキッズ", fileExt: "mp4", totalTime: "11:32", channel: .reo),
            Content(fileName: "レオくんがヘビのラジコンであそぶよ！逃げたヘビを追いかけよう！_トイキッズ", fileExt: "mp4", totalTime: "10:32", channel: .reo),
            Content(fileName: "レオくんが公園でこんちゅうをつかまえるよ！たくさん昆虫つかまえられるかな？_トイキッズ", fileExt: "mp4", totalTime: "14:04", channel: .reo),
            Content(fileName: "ママ、はやく元気になってね_お医者さんごっこ_子供の歌メドレー_童謡_Little Angel-リトルエンジェル日本語", fileExt: "mp4", totalTime: "36:32", channel: .littleAngel),
            Content(fileName: "自作の踏切を電装化してみた", fileExt: "mp4", totalTime: "16:50", channel: .suzukawaAyako),
            Content(fileName: "まぜまぜアイス屋さん_ロールアイス_Mixing_Ice_Cream_Flavor_Ice_Cream_Shop", fileExt: "mp4", totalTime: "7:15", channel: .meruchan)
        ]
        
        return contents
    }
}
