//
//  PlayerViewController.swift
//  KidsVideo
//
//  Created by headspinnerd on 2021/09/26.
//

import UIKit
import AVKit
import AVFoundation

class PlayerViewController: UIViewController, UIGestureRecognizerDelegate, AVRoutePickerViewDelegate  {
    
    let defaultConfig = DefaultConfig()
    var summerPlayerView: SummerPlayerView?
    var contents: [Content] {
        if let configuration = ChildConfigurationManager.loadConfiguration() {
            return configuration.videos.enumerated().compactMap { (index, contentData) in
                guard let channel = channelFromString(contentData.channel) else { return nil }
                return Content(fileName: contentData.fileName, fileExt: contentData.fileExt, totalTime: contentData.totalTime, channel: channel, videoIndex: index)
            }.filter { $0.channel == selectedChannel }
        } else {
            return []
        }
    }
    var selectedChannel: Channel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        // 外部ディスプレイマネージャーに登録
        ExternalDisplayManager.shared.registerMainPlayer(self)
        
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
        
        // AirPlay機能の設定
        setupAirPlay()
        
        // 外部ディスプレイが接続されている場合の処理
        handleExternalDisplayIfConnected()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 外部ディスプレイマネージャーから登録解除
        ExternalDisplayManager.shared.unregisterMainPlayer()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - External Display Support
    private func handleExternalDisplayIfConnected() {
        if ExternalDisplayManager.shared.isExternalDisplayConnected {
            // 外部ディスプレイのコンテンツを更新
            ExternalDisplayManager.shared.syncPlayerToExternalDisplay()
            
            // メインディスプレイではコントロールを表示し、動画は外部ディスプレイに表示
            summerPlayerView?.configureForExternalDisplay()
        }
    }
    
    // MARK: - AirPlay Setup
    private func setupAirPlay() {
        // AVRoutePickerViewのデリゲートを設定
        if let summerPlayerView = summerPlayerView {
            summerPlayerView.setupAirPlayRoutePickerDelegate(self)
        }
    }
    
    @objc private func turnOffExternalDisplay() {
        ExternalDisplayManager.shared.disableExternalDisplayMode()
    }
}

extension PlayerViewController : SummerPlayerViewDelegate {
    func didFinishVideo() {
        
        if self.defaultConfig.playbackMode == .quit {
            goBackViewController()
        }
    }
    
    func didStartVideo() {
        // Post notification to stop menu background music
        NotificationCenter.default.post(name: Notification.Name("PlayerDidStartNotification"), object: nil)
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
        // AVRoutePickerViewが自動的にAirPlay機能を処理するため、
        // このメソッドは空のままにしておきます
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

// MARK: - AVRoutePickerViewDelegate
extension PlayerViewController {
    func routePickerViewDidEndPresentingRoutes(_ routePickerView: AVRoutePickerView) {
        // AirPlayルート選択が終了した時の処理
        print("AirPlay route selection ended")
    }
    
    func routePickerViewWillBeginPresentingRoutes(_ routePickerView: AVRoutePickerView) {
        // AirPlayルート選択が開始される時の処理
        print("AirPlay route selection will begin")
    }
}

extension PlayerViewController {
    
    fileprivate func goBackViewController() {
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: .backToMenuNotification, object: nil)
    }
}
