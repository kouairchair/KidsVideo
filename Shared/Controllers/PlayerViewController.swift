//
//  PlayerViewController.swift
//  KidsVideo
//
//  Created by headspinnerd on 2021/09/26.
//

import UIKit
import AVKit

class PlayerViewController: UIViewController  {
    
    let defaultConfig = DefaultConfig()
    var summerPlayerView: SummerPlayerView?
    let contents = ContentsMaker.getContents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let sampleTheme = ThemeMaker.getTheme()
        
        summerPlayerView = SummerPlayerView(configuration: defaultConfig, theme: sampleTheme,targetView: view)
        
        summerPlayerView?.delegate = self
        
        if let currentItem = contents.first {
            summerPlayerView?.setupPlayList(currentItem: currentItem, items: contents)
        }
        
        view.addSubview(summerPlayerView!)

        summerPlayerView?.pinEdges(targetView: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension PlayerViewController : SummerPlayerViewDelegate {
    func didFinishVideo() {
        
        if self.defaultConfig.playbackMode == .quit {
            moveViewController()
        }
    }
    
    func didStartVideo() {
        
    }
    
    func didChangeSliderValue(_ seekTime: CMTime) {
        
    }
    func didPressBackButton() {
        moveViewController()
    }
    
    func didPressNextButton() {
        
    }
    
    func didPressPreviousButton() {
        
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
    
    fileprivate func moveViewController() {
        // TODO: to be implemented
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "MainVC")
//        self.present(controller, animated: true, completion: nil)
    }
}
