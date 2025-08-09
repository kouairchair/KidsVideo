import Foundation
import AVKit

public enum PlaybackMode {
    case quit
    case loopPlay
    case nextPlay
}

public class SummerPlayerView: UIView {
    
    public var delegate: SummerPlayerViewDelegate?
    
    public var totalDuration: CMTime? {
        return self.queuePlayer.currentItem?.asset.duration
    }
    
    public var playerStatus: AVPlayer.Status  {
        return self.queuePlayer.status
    }
    
    public var currentTime: CMTime? {
        return self.queuePlayer.currentTime()
    }
    
    private var contents: [Content]?
    
    private var isTouched = false
    
    private var hideControl = true
    
    private var playbackMode:PlaybackMode = .loopPlay
    
    private var currentVideoIndex = 0
    
    var queuePlayer: AVQueuePlayer!
    
    private var playerLayer: AVPlayerLayer?
    
    private let contentsListView = ContentListView()
    
    private var playerScreenView = PlayerScreenView()
    
    var playerControlView: PlayerControllView?
    
    private var configuration: SummerPlayerViewConfig = InternalConfiguration()
    
    private var theme: SummerPlayerViewTheme = defaultTheme()
    
    private var playerScreenDelegate: PlayerScreenViewDelegate?
    
    internal var playerCellForItem: ((UICollectionView, IndexPath)->(UICollectionViewCell))? = nil
    
    private var isRepeatMode = false
    
    required public init(configuration: SummerPlayerViewConfig, theme: SummerPlayerViewTheme, targetView: UIView) {
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        self.bounds = targetView.bounds
        
        self.theme = theme
        self.configuration = configuration
        self.backgroundColor = self.theme.backgroundViewColor
        self.playbackMode = self.configuration.playbackMode
        
        setupPlayer()
        setupSummerPlayerView(targetView.bounds)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        setupPlayer()
        setupSummerPlayerView(nil)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        translatesAutoresizingMaskIntoConstraints = false
        setupPlayer()
        setupSummerPlayerView(nil)
    }
    
    private func regulatePlayerView(isFullScreen:Bool) {
        var playerViewRect : CGRect
        
        if isFullScreen {
            playerViewRect = self.bounds
        } else {
            playerViewRect = Utills.getWholeViewRect(self.bounds)!
        }
        
        playerLayer?.frame = playerViewRect
    }
    
    
    private func didRegisterPlayerItemCell(_ identifier: String, collectioViewCell cell: UICollectionViewCell.Type) {
        contentsListView.didRegisterPlayerItemCell(identifier, collectioViewCell: cell)
    }
    
    public func setupPlayList(currentItem: Content, items: [Content]) {
        
        self.contents = items
        self.currentVideoIndex = 0

        if let url = currentItem.getUrl() {
            didLoadVideo(url)
            contentsListView.setPlayList(currentItem: currentItem, items: items)
        }
    }
    
    private func setupSummerPlayerView(_ viewRect: CGRect?) {
        if let viewRect = viewRect {
            let wholeViewRect = Utills.getWholeViewRect(viewRect)
            
            setupInsideViews(wholeViewRect , wholeRect: viewRect)
            
            bringSubviewToFront(contentsListView)
            if let playerControlView = playerControlView {
                bringSubviewToFront(playerControlView)
            }
            bringSubviewToFront(playerScreenView)
        }
    }
    
    private func setupPlayer() {
        queuePlayer = AVQueuePlayer()
        queuePlayer.addObserver(contentsListView, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        playerLayer = AVPlayerLayer(player: queuePlayer)
        playerLayer?.backgroundColor = UIColor.black.cgColor
        playerLayer?.videoGravity = .resizeAspect
        
        regulatePlayerView(isFullScreen: false)
        
        self.layer.addSublayer(playerLayer!)
        
        queuePlayer.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1, preferredTimescale: 100),
            queue: DispatchQueue.main,
            using: { [weak self] (cmtime) in
                self?.playerScreenView.videoDidChange(cmtime)
            })
    }
    
    private func setupPlayerScreenView(_ standardRect: CGRect?) {
        playerScreenView = PlayerScreenView(frame: CGRect(x: standardRect!.origin.x, y: 0, width: standardRect!.width, height: standardRect!.height))
        print("testtest playerScreenView.frame:\(playerScreenView.frame)")
        playerScreenView.applyTheme(self.theme)
        playerScreenView.delegate = self
        addSubview(playerScreenView)
    }
    
    private func setupPlayerControllView(_ wholeRect: CGRect?) {
        let quarterViewRect = Utills.getQuarterViewRect(wholeRect!)
        self.playerControlView = PlayerControllView(frame: CGRect(x: quarterViewRect!.origin.x, y: 0, width: quarterViewRect!.width, height: quarterViewRect!.height))
        self.playerControlView!.delegate = self
        addSubview(self.playerControlView!)
    }
    
    // MARK: - AirPlay Support
    func setupAirPlayRoutePickerDelegate(_ delegate: AVRoutePickerViewDelegate?) {
        // PlayerControlViewからAVRoutePickerViewにアクセスしてデリゲートを設定
        if let playerControlView = self.playerControlView {
            playerControlView.setAirPlayRoutePickerDelegate(delegate)
        }
    }
    
    func getAirPlayRoutePicker() -> AVRoutePickerView? {
        // PlayerControlViewからAVRoutePickerViewを取得
        if let playerControlView = self.playerControlView {
            return playerControlView.getAirPlayRoutePicker()
        }
        return nil
    }
    
    // MARK: - External Display Support
    func configureForExternalDisplay() {
        // 外部ディスプレイが接続されている場合の設定
        if ExternalDisplayManager.shared.isExternalDisplayConnected {
            // メインディスプレイでは動画を非表示にして、コントロールのみ表示
            playerLayer?.isHidden = true
            
            // 外部ディスプレイのコンテンツを更新
            ExternalDisplayManager.shared.updateExternalDisplayContent()
            
            print("SummerPlayerView configured for external display")
        } else {
            // 外部ディスプレイが接続されていない場合は通常表示
            playerLayer?.isHidden = false
        }
    }
    
    func updateForExternalDisplayConnection() {
        // 外部ディスプレイの接続状態が変わった時の処理
        configureForExternalDisplay()
    }
    
    func setVideoGravityForExternalDisplay(_ gravity: AVLayerVideoGravity) {
        // 外部ディスプレイ用のビデオグラビティ設定
        if let externalVC = ExternalDisplayManager.shared.externalPlayerViewController {
            externalVC.updateVideoGravity(gravity)
        }
    }
    
    private func setupContentsListView(_ wholeRect: CGRect?) {
        contentsListView.createOverlayViewWith(wholeViewWidth: wholeRect!.size.width,configuration: configuration, theme: self.theme)
        contentsListView.delegate = self
        contentsListView.translatesAutoresizingMaskIntoConstraints = false
        contentsListView.isHidden = false
        addSubview(contentsListView)
        contentsListView.backgroundColor = .clear
        contentsListView.pinEdges(targetView: self)
    }
    
    private func setupInsideViews(_ standardRect: CGRect? , wholeRect : CGRect?) {
        guard (standardRect != nil) else { return }
        
        setupPlayerScreenView(standardRect)
        
        setupPlayerControllView(wholeRect)
        
        setupContentsListView(wholeRect)
        
    }
    
}

extension SummerPlayerView: PlayerControlViewDelegate {
    func didPressedAirPlayButton() {
        delegate?.didPressAirPlayButton()
    }
    
    private func playPreviousContent(_ forceBack: Bool) {
        if forceBack || (currentTime?.asDouble ?? 0) > 10 {
            // 再生後10秒以上たってたら、前の動画に戻るのではなく、動画の最初に戻す
            seekToTime(CMTime.zero)
        } else {
            if let latestItems = contents {
                if (currentVideoIndex == 0) {
                    currentVideoIndex = latestItems.count - 1
                } else if(currentVideoIndex > 0) {
                    currentVideoIndex -= 1
                }
                if let contents = contents {
                    let currentItem = contents[currentVideoIndex]
                    contentsListView.setPlayList(currentItem: currentItem, items: contents)
                }
                
                if let previousMovieUrl = latestItems[currentVideoIndex].getUrl() {
                    resetPlayer(previousMovieUrl)
                }
            }
        }
    }
    
     func didPressedPreviousButton() {
        playerScreenView.resetPlayerUI()
        
        playPreviousContent(false)
        delegate?.didPressPreviousButton()
    }
    
    func didPressedRepeatButton() -> (isRepeatMode: Bool, repeatTime: CMTime?) {
        isRepeatMode = !isRepeatMode
        delegate?.didPressRepeatButton(isRepeating: isRepeatMode)
        if isRepeatMode {
            playerScreenView.repeatSeakTime = currentTime
            playerScreenView.resetPlayerUI()
            playPreviousContent(true)
            return (true, currentTime)
        } else {
            playerScreenView.repeatSeakTime = nil
            return (false, nil)
        }
    }
    
    private func loopPlayContent() {
        if let latestItems = contents,
           let newURL = latestItems[currentVideoIndex].getUrl() {
            resetPlayer(newURL)
        }
    }
    
    private func playNextContent() {
        if let latestItems = contents {
            if (currentVideoIndex >= 0 && currentVideoIndex < latestItems.count - 1) {
                currentVideoIndex += 1
            } else if(currentVideoIndex == latestItems.count - 1 ) {
                currentVideoIndex = 0
            }
            if let contents = contents {
                let currentItem = contents[currentVideoIndex]
                contentsListView.setPlayList(currentItem: currentItem, items: contents)
            }
            
            if let nextMovieUrl = latestItems[currentVideoIndex].getUrl() {
                resetPlayer(nextMovieUrl)
            }
        }
    }
    
    func didPressedNextButton() {
        playerScreenView.resetPlayerUI()
        
        playNextContent()
        
        delegate?.didPressNextButton()
        
    }
    
    func didPressedBackButton() {
        
        finishVideo()
        delegate?.didPressBackButton()
        
    }
    
    private func finishVideo() {
        self.queuePlayer.pause()
        self.playerLayer?.removeFromSuperlayer()
        
    }
    
    private func pauseVideo() {
        self.queuePlayer.pause()
        
    }
}

extension SummerPlayerView: PlayerScreenViewDelegate {
    func didChangeSliderValue(_ seekTime: CMTime) {
        delegate?.didChangeSliderValue(seekTime)
    }
    
    func didPressedMoreButton() {
        delegate?.didPressMoreButton()
    }
    
    func didSelectItem(_ index: Int) {
        delegate?.didPressContentsListView(index: index)
    }
    
    func didTappedPlayerScreenView(_ isTapped: Bool) {
        
        if self.hideControl {
            
            self.contentsListView.isHidden = true
            self.playerControlView?.isHidden = true
            
            isTouched = true
            
        } else {
            self.contentsListView.isHidden = false
            self.playerControlView?.isHidden = false
            isTouched = false
            
            
        }
        self.hideControl = !self.hideControl
        
        regulatePlayerView(isFullScreen: isTouched)
    }
    
    func currentVideoIndex(_ index: Int, _ url: URL) {
        currentVideoIndex = index
        resetPlayer(url)
    }
    
    func didLoadVideo(_ url: URL) {
        resetPlayer(url)
    }
    
    func seekToTime(_ seekTime: CMTime) {
        self.queuePlayer.currentItem?.seek(to: seekTime, completionHandler: nil)
    }
    
    func playPause(_ isActive: Bool) {
        isActive ? queuePlayer.play() : queuePlayer.pause()
        
        delegate?.didPressPlayButton(isActive: isActive)
    }
    
    private func resetPlayer(_ url: URL) {
        if isRepeatMode {
            isRepeatMode = false
            playerScreenView.repeatSeakTime = nil
            delegate?.didPressRepeatButton(isRepeating: false)
            playerControlView?.changeRepeatStatus(isRepeatMode: false, repeatTime: nil)
        }
        
        queuePlayer.removeAllItems()
        
        let playerItem = AVPlayerItem(url: url)
        queuePlayer.insert(playerItem, after: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        queuePlayer.play()
        
        if let title = self.contents?[currentVideoIndex].fileName {
            playerScreenView.videoDidStart(title: title)
        }
    }
    
    @objc private func playerItemDidPlayToEndTime() {
        pauseVideo()
        playerScreenView.resetPlayerUI()
        
        if(configuration.playbackMode == PlaybackMode.loopPlay) {
            loopPlayContent()
        } else if(configuration.playbackMode == PlaybackMode.nextPlay) {
            
            playerScreenView.resetPlayerUI()
            playNextContent()
            
        } else if(configuration.playbackMode == PlaybackMode.quit) {
            finishVideo()
        }
        
        delegate?.didFinishVideo()
    }
    
    
}

extension UIView {
    
    public func pinEdges(targetView: UIView) {
        leadingAnchor.constraint(equalTo: targetView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: targetView.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: targetView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: targetView.bottomAnchor).isActive = true
    }
    
}
