

import UIKit
import AVFoundation

class VideoCollectionViewCell: UICollectionViewCell {
    
    // サムネイルキャッシュ用の静的辞書
    private static var thumbnailCache: [String: UIImage] = [:]
    
    let videoThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let totalTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor.black
        label.alpha = 0.8
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.numberOfLines = 1
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(videoThumbnail)
        addSubview(totalTimeLabel)
        
        videoThumbnail.pinEdges(targetView: self)
        totalTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        totalTimeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        totalTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        totalTimeLabel.trailingAnchor.constraint(equalTo:trailingAnchor, constant: -10).isActive = true
    }
    
    private func applyTheme(_ theme: SummerPlayerViewTheme) {
        totalTimeLabel.textColor = theme.totalTimeLabelTextColor
        totalTimeLabel.font = theme.totalTimeLableTextFont
        totalTimeLabel.backgroundColor = theme.totalTimeLableBackground
    }
    
    // 動画の最初のフレームをサムネイルとして生成する関数
    private func generateThumbnailFromVideo(fileName: String, fileExt: String) -> UIImage? {
        // キャッシュキーを作成
        let cacheKey = "\(fileName).\(fileExt)"
        
        // キャッシュから取得を試行
        if let cachedThumbnail = VideoCollectionViewCell.thumbnailCache[cacheKey] {
            return cachedThumbnail
        }
        
        guard let videoPath = Bundle.main.path(forResource: fileName, ofType: fileExt) else {
            return nil
        }
        
        let videoURL = URL(fileURLWithPath: videoPath)
        let asset = AVAsset(url: videoURL)
        
        // 動画の最初のフレーム（0秒）を取得
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.maximumSize = CGSize(width: 300, height: 300) // サムネイルサイズを制限
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: CMTime.zero, actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            // キャッシュに保存
            VideoCollectionViewCell.thumbnailCache[cacheKey] = thumbnail
            
            return thumbnail
        } catch {
            print("Error generating thumbnail: \(error)")
            return nil
        }
    }
    
    func setData(_ playListItem: Content?, theme: SummerPlayerViewTheme) {
        guard let playListItem = playListItem else {
            return
        }
        totalTimeLabel.text = playListItem.totalTime
        
        // まず画像ファイルを探す
        if let path = Bundle.main.path(forResource: playListItem.fileName, ofType:"png") ?? Bundle.main.path(forResource: playListItem.fileName, ofType:"jpeg") ?? Bundle.main.path(forResource: playListItem.fileName, ofType:"jpg") {
            if let image = UIImage(contentsOfFile: path) {
                videoThumbnail.image = image
            }
        } else {
            // 画像ファイルが見つからない場合、動画の最初のフレームをサムネイルとして使用
            if let thumbnail = generateThumbnailFromVideo(fileName: playListItem.fileName, fileExt: playListItem.fileExt) {
                videoThumbnail.image = thumbnail
            } else {
                // サムネイル生成にも失敗した場合、デフォルト画像を表示
                videoThumbnail.image = UIImage(systemName: "video.fill")
                videoThumbnail.tintColor = .gray
            }
            debugPrint("\(playListItem.fileName).png not found, using video thumbnail")
        }
        
        applyTheme(theme)
    }
    
    // キャッシュをクリアする静的メソッド（メモリ不足時に呼び出すことを想定）
    static func clearThumbnailCache() {
        thumbnailCache.removeAll()
    }
}
