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
            // Reo x Anpanman
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
            // Reo
            Content(fileName: "レオくんがきょうりゅうをやっつける戦隊ヒーローをあらってあげよう_トイキッズ", fileExt: "mp4", totalTime: "11:32", channel: .reo_anpanman),
            Content(fileName: "レオくんがヘビのラジコンであそぶよ！逃げたヘビを追いかけよう！_トイキッズ", fileExt: "mp4", totalTime: "10:32", channel: .reo_anpanman),
            Content(fileName: "レオくんが公園でこんちゅうをつかまえるよ！たくさん昆虫つかまえられるかな？_トイキッズ", fileExt: "mp4", totalTime: "14:04", channel: .reo_anpanman),
            // Suzukawa Ayako
            Content(fileName: "プラレール博2018in東京に行ってきた_Toy_Model_Trains_Museum_2018", fileExt: "mp4", totalTime: "12:15", channel: .suzukawaAyako),
            Content(fileName: "自作の踏切を電装化してみた", fileExt: "mp4", totalTime: "16:49", channel: .suzukawaAyako),
            Content(fileName: "みずのくにのきかんしゃトーマス:_Thomas_in_water_world", fileExt: "mp4", totalTime: "6:06", channel: .suzukawaAyako),
            Content(fileName: "逗子駅の増結解放と田浦駅のドアカットをみてきた_横須賀線が11両と4両にわかれる理由がここにある", fileExt: "mp4", totalTime: "15:45", channel: .suzukawaAyako),
            // Meru Chan
            Content(fileName: "メルちゃん_お誕生日会_プレゼント_バースデイパーティー_:_Mell-chan_Birthday_Party", fileExt: "mp4", totalTime: "10:25", channel: .meruchan),
            Content(fileName: "メルちゃん_学校ごっこ_化石掘り_宝石掘り_:_Mell-chan_School_Digging_for_Fossil_Mermaid", fileExt: "mp4", totalTime: "6:16", channel: .meruchan),
            Content(fileName: "メルちゃん_おままごと_納豆ごはん_お味噌汁_朝ごはんお料理__Mellchan_Natto_Fermented_Soybeans_Cooking_Toy_Playset", fileExt: "mp4", totalTime: "10:09", channel: .meruchan),
            Content(fileName: "リーメント_ハローキティ_スーパーマーケット_ミニチュア_:_Hello_Kitty_Supermarket_Re-ment_Miniature_Food", fileExt: "mp4", totalTime: "10:45", channel: .meruchan),
            Content(fileName: "メルちゃん_ようちえんの先生_ほいくしさんセット__Mellchan_kindergarten_Teacher_Playset", fileExt: "mp4", totalTime: "9:42", channel: .meruchan),
            Content(fileName: "リーメント_リラックマルーム_スッキリいい気分♪_バスルーム_:_Rilakkuma_Bathroom!_Miniature_Toy_Re-ment", fileExt: "mp4", totalTime: "12:34", channel: .meruchan),
            Content(fileName: "ドラえもん_ごはんセット_ミニチュア_リーメント_:_Doraemon_Miniature_Food_Set!_Re-ment", fileExt: "mp4", totalTime: "14:31", channel: .meruchan),
            Content(fileName: "ドラえもん_のび太の部屋_リーメント_毎日が大冒険_:_Doraemon_Miniature_Nobita's_Room!_Re-ment", fileExt: "mp4", totalTime: "13:42", channel: .meruchan),
            Content(fileName: "ハッピーセット_なりきりマクドナルド_大量_開封_ミニチュア_:_McDonalds_Happy_Meal_Toys_|_Miniature_McDonalds_Toy", fileExt: "mp4", totalTime: "5:30", channel: .meruchan),
            Content(fileName: "メルちゃんおいしゃさん_いちごクリニック_ネネちゃん_ばんそうこうだらけ_:_Mell-chan_Hospital_Playset_|_Doctor_Toys", fileExt: "mp4", totalTime: "9:06", channel: .meruchan),
            Content(fileName: "まぜまぜアイス屋さん_ロールアイス_Mixing_Ice_Cream_Flavor_Ice_Cream_Shop", fileExt: "mp4", totalTime: "7:14", channel: .meruchan),
            Content(fileName: "スライムクリームでスイーツ作り_ナムノムズ_サプライズトイ_:_Num_Noms_Snackables_Slime_Kits", fileExt: "mp4", totalTime: "12:49", channel: .meruchan),
            // little Angel
            Content(fileName: "痛いっ～助けてママ_-_赤ちゃんが好きな歌_|_童謡と子供の歌_|_Little_Angel_-_リトルエンジェル日本語", fileExt: "mp4", totalTime: "3:19", channel: .littleAngel),
            Content(fileName: "ひとりでできるよ！_-_成長のうた_|_子供が喜ぶアニメ_|_童謡と子供の歌_|_Little_Angel_-_リトルエンジェル日本語", fileExt: "mp4", totalTime: "3:21", channel: .littleAngel),
            Content(fileName: "１０このカップケーキ_すうじの歌_数字を学ぶ_童謡と子供の歌_Little_Angel-リトルエンジェル日本語", fileExt: "mp4", totalTime: "3:33", channel: .littleAngel),
            Content(fileName: "あぶない！火事だ！_-_火と戦う消防隊！_-_消防士と消防車_|_乗り物の歌_|_童謡と子供の歌_|_Little_Angel_-_リトルエンジェル日本語", fileExt: "mp4", totalTime: "3:33", channel: .littleAngel),
            Content(fileName: "夏か冬どっちが最高？_-_夏のうた_冬のうた_|_はんたいことば_|_童謡と子供の歌_|_Little_Angel_-_リトルエンジェル日本語", fileExt: "mp4", totalTime: "4:16", channel: .littleAngel),
            Content(fileName: "カラフルな列車のおもちゃ___色を学ぼう__おもちゃで学ぶ__乗り物__教育アニメ__童謡と子供の歌__Little_Angel__リトルエンジェル日本語", fileExt: "mp4", totalTime: "3:41", channel: .littleAngel),
            Content(fileName: "たのしい一日のはじまり_スクーターにのってゴーゴー！|_子供が好きなアニメ_|_童謡と子供の歌_|_Little_Angel_-_リトルエンジェル日本語", fileExt: "mp4", totalTime: "2:57", channel: .littleAngel),
            Content(fileName: "ちびっこ消防士さんの体験_|_消防車_|_乗り物の歌_|_子供の歌メドレー_|_童謡_|_Little_Angel_-_リトルエンジェル日本語", fileExt: "mp4", totalTime: "3:28", channel: .littleAngel),
            Content(fileName: "ママ、はやく元気になってね_お医者さんごっこ_子供の歌メドレー_童謡_Little_Angel-リトルエンジェル日本語", fileExt: "mp4", totalTime: "36:31", channel: .littleAngel),
            Content(fileName: "泣かないでベイビーしゅん_-_きもちの歌_|_教育アニメ_|_童謡と子供の歌_|_Little_Angel_-_リトルエンジェル日本語", fileExt: "mp4", totalTime: "3:39", channel: .littleAngel),
            Content(fileName: "ロケットにのって宇宙を探検だ！☆_|_宇宙飛行士_|_子供が喜ぶアニメ_|_子供の歌メドレー_|_童謡_|_Little_Angel_-_リトルエンジェル日本語", fileExt: "mp4", totalTime: "3:52", channel: .littleAngel),
            Content(fileName: "ようこそ、ちびっこ洗車屋さんへ！_|_子供が喜ぶアニメ_|_ごっこ遊び_|_童謡と子供の歌_|_Little_Angel_-_リトルエンジェル日本語", fileExt: "mp4", totalTime: "3:48", channel: .littleAngel),
            Content(fileName: "ジュース屋さんごっこして遊ぼう！_-_色のうた_|_教育アニメ_|_子供の歌メドレー_|_童謡_|_Little_Angel_-_リトルエンジェル日本語", fileExt: "mp4", totalTime: "4:18", channel: .littleAngel),
            Content(fileName: "ひこうきではシートベルトをしよう！_-_子供向け安全教育_|_教育アニメ_|_童謡と子供の歌_|_Little_Angel_-_リトルエンジェル日本語", fileExt: "mp4", totalTime: "3:48", channel: .littleAngel),
        ]
        
        return contents
    }
}
