

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
    
    private var playerControlView = PlayerControllView()
    
    private var configuration: SummerPlayerViewConfig = InternalConfiguration()
    
    private var theme: SummerPlayerViewTheme = defaultTheme()
    
    private var playerScreenDelegate: PlayerScreenViewDelegate?
    
    internal var playerCellForItem: ((UICollectionView, IndexPath)->(UICollectionViewCell))? = nil
    
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
        
        guard let path = Bundle.main.path(forResource: currentItem.fileName, ofType:currentItem.fileExt) else {
            debugPrint("\(currentItem.fileName).\(currentItem.fileExt) not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        didLoadVideo(url)
        
        contentsListView.setPlayList(currentItem: currentItem, items: items)
    }
    
    private func setupSummerPlayerView( _ viewRect: CGRect?) {
        if(viewRect != nil) {
            let wholeViewRect = Utills.getWholeViewRect(viewRect!)
            
            setupInsideViews(wholeViewRect , wholeRect: viewRect)
            
            bringSubviewToFront(contentsListView)
            bringSubviewToFront(playerControlView)
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
        self.playerScreenView = PlayerScreenView(frame: CGRect(x: standardRect!.origin.x, y: 0, width: standardRect!.width, height: standardRect!.height))
        self.playerScreenView.applyTheme(self.theme)
        self.playerScreenView.delegate = self
        addSubview(self.playerScreenView)
    }
    
    private func setupPlayerControllView(_ wholeRect: CGRect?) {
        let quarterViewRect = Utills.getQuarterViewRect(wholeRect!)
        self.playerControlView = PlayerControllView(frame: CGRect(x: quarterViewRect!.origin.x, y: 0, width: quarterViewRect!.width, height: quarterViewRect!.height))
        self.playerControlView.delegate = self
        addSubview(self.playerControlView)
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

extension SummerPlayerView:PlayerControlViewDelegate {
    func didPressedAirPlayButton() {
        delegate?.didPressAirPlayButton()
    }
    
    private func playPreviousContent() {
        if let latestItems = contents {
            if(currentVideoIndex == 0) {
                currentVideoIndex = latestItems.count-1
            } else if(currentVideoIndex > 0) {
                currentVideoIndex -= 1
            }
            let newURL = URL(string: latestItems[currentVideoIndex].fileName)
            resetPlayer(newURL!)
        }
    }
    
     func didPressedPreviousButton() {
        playerScreenView.resetPlayerUI()
        
        playPreviousContent()
        delegate?.didPressPreviousButton()
    }
    
    private func loopPlayContent() {
        if let latestItems = contents {
            let newURL = URL(string: latestItems[currentVideoIndex].fileName)
            resetPlayer(newURL!)
        }
    }
    
    
    private func playNextContent() {
        if let latestItems = contents {
            if(currentVideoIndex >= 0 && currentVideoIndex < latestItems.count-1) {
                currentVideoIndex += 1
            } else if(currentVideoIndex == latestItems.count-1 ) {
                currentVideoIndex = 0
            }
            let newURL = URL(string: latestItems[currentVideoIndex].fileName)
            resetPlayer(newURL!)
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
            self.playerControlView.isHidden = true
            
            isTouched = true
            
        } else {
            self.contentsListView.isHidden = false
            self.playerControlView.isHidden = false
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

