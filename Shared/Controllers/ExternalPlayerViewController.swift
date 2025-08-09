//
//  ExternalPlayerViewController.swift
//  KidsVideo
//
//  Created by AI Assistant on 2025/08/09.
//

import UIKit
import AVFoundation

class ExternalPlayerViewController: UIViewController {
    
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupExternalView()
    }
    
    private func setupExternalView() {
        view.backgroundColor = .black
        
        // ステータスバーを非表示にする
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatePlayerLayerFrame()
    }
    
    func setupPlayerFromMain(summerPlayerView: SummerPlayerView) {
        // メインプレイヤーから外部ディスプレイ用のプレイヤーを設定
        player = summerPlayerView.queuePlayer

        // 既存のプレイヤーレイヤーを削除
        playerLayer?.removeFromSuperlayer()

        // 新しいプレイヤーレイヤーを作成
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.backgroundColor = UIColor.black.cgColor
        playerLayer?.videoGravity = .resizeAspectFill // 画面を埋めるように設定
        view.layer.addSublayer(playerLayer!)
        // フレームを必ず設定
        playerLayer?.frame = view.bounds
    }

    private func updatePlayerLayerFrame() {
        playerLayer?.frame = view.bounds
    }
    
    func updateVideoGravity(_ gravity: AVLayerVideoGravity) {
        playerLayer?.videoGravity = gravity
        print("External display video gravity changed to: \(gravity.rawValue)")
    }
    
    deinit {
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        player = nil
    }
}
