//
//  MusicMaker.swift
//  KidsVideo
//
//  Created by headspinnerd on 2021/09/29.
//

import Foundation

struct MusicMaker {
    public static func getTodayMusic() -> Music {
        
        let musics = [
            Music(fileName: "baby-game-mane-8780", fileExt: "mp3"),
            Music(fileName: "fanny-stories-main-7231", fileExt: "mp3"),
            Music(fileName: "happy-children-8770", fileExt: "mp3")
        ]
        
        if let todaysDay = Calendar.current.dateComponents([.day], from: Date()).day {
            let index = todaysDay % musics.count - 1
            if index >= 0 && musics.count > index {
                return musics[index]
            }
        }
        
        return musics[0]
    }
}
