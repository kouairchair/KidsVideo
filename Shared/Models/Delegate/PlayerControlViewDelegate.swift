//
//  PlayerControlViewDelegate.swift
//  SummerPlayerView
//
//  Created by derrick on 2020/09/13.
//  Copyright © 2020 Derrick. All rights reserved.
//

import UIKit
import AVKit

protocol PlayerControlViewDelegate  {
    func didPressedBackButton()
    func didPressedPreviousButton()
    func didPressedRepeatButton() -> (isRepeatMode: Bool, repeatTime: CMTime?)
    func didPressedNextButton()
    func didPressedAirPlayButton()
}
