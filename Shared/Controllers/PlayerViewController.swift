//
//  PlayerViewController.swift
//  KidsVideo
//
//  Created by headspinnerd on 2021/09/26.
//

import UIKit
import AVKit

class PlayerViewController: UIViewController, UIGestureRecognizerDelegate  {
    
    let defaultConfig = DefaultConfig()
    var summerPlayerView: SummerPlayerView?
    var contents: [Content] {
        ContentsMaker.getContents().filter { $0.channel == selectedChannel }
    }
    var selectedChannel: Channel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        let sampleTheme = ThemeMaker.getTheme()
        print("testtest view.frame:\(view.frame)")
        // Remark: 2021/10/5段階では、view.frameは画面全体のframeで、iPad 6thなら(0.0, 0.0, 1024.0, 768.0), 34インチモニタ全画面では(0.0, 0.0, 4468.0, 1871.0)
        summerPlayerView = SummerPlayerView(configuration: defaultConfig, theme: sampleTheme, targetView: view)
        
        summerPlayerView?.delegate = self
        
        if let currentItem = contents.first {
            summerPlayerView?.setupPlayList(currentItem: currentItem, items: contents)
        }
        
        view.addSubview(summerPlayerView!)

        summerPlayerView?.pinEdges(targetView: view)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension PlayerViewController : SummerPlayerViewDelegate {
    func didFinishVideo() {
        
        if self.defaultConfig.playbackMode == .quit {
            goBackViewController()
        }
    }
    
    func didStartVideo() {
        
    }
    
    func didChangeSliderValue(_ seekTime: CMTime) {
        
    }
    func didPressBackButton() {
        goBackViewController()
    }
    
    func didPressNextButton() {
        
    }
    
    func didPressPreviousButton() {
        
    }
    
    func didPressRepeatButton(isRepeating: Bool) {
        let font = UIFont(name: "HiraginoSans-W3", size: 17)
        if isRepeating {
            self.showToast(message: "繰り返し再生:ON", font: font, type: .notice)
        } else {
            self.showToast(message: "繰り返し再生:OFF", font: font, type: .alert)
        }
    }
    
    func didPressAirPlayButton() {
        
    }
    
    func didPressMoreButton() {
        
    }
    
    func didPressContentsListView(index: Int) {
        if contents.count > index {
            let currentItem = contents[index]
            summerPlayerView?.setupPlayList(currentItem: currentItem, items: contents)
            // TODO: 前回再生したところで再開する？
//            if let currentTime = lastCurrentTimeWork {
//                self.summerPlayerView?.queuePlayer.currentItem?.seek(to: currentTime, completionHandler: nil)
//            }
        }
    }
    
    func didPressPlayButton(isActive: Bool) {
        
    }
    
}

extension PlayerViewController {
    
    fileprivate func goBackViewController() {
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: .backToMenuNotification, object: nil)
    }
}
