//
//  Channel.swift
//  KidsVideo
//
//  Created by headspinnerd on 2021/09/29.
//

import Foundation

public enum Channel {
    case shinkalion, minecraft, jobraver, dinasaur, numberblocks
}

func channelFromString(_ channelString: String) -> Channel? {
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
    default:
        return nil
    }
}
