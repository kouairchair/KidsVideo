# AirPlay機能実装ガイド

## 概要
KidsVideoアプリにAirPlay送信機能を追加しました。この機能により、ユーザーは動画をAirPlay対応デバイス（Apple TV、AirPlay対応テレビなど）にワンタップで送信できます。

## 実装内容

### 1. AVRoutePickerViewの統合
- カスタムAirPlayボタンを`AVRoutePickerView`に置き換え
- 標準的なAirPlay機能を提供
- 自動的に利用可能なAirPlayデバイスを検出

### 2. デリゲート設定
```swift
// PlayerViewControllerでAVRoutePickerViewDelegateを実装
class PlayerViewController: UIViewController, AVRoutePickerViewDelegate {
    
    private func setupAirPlay() {
        if let summerPlayerView = summerPlayerView {
            summerPlayerView.setupAirPlayRoutePickerDelegate(self)
        }
    }
    
    // AVRoutePickerViewDelegateメソッド
    func routePickerViewDidEndPresentingRoutes(_ routePickerView: AVRoutePickerView) {
        print("AirPlay route selection ended")
    }
    
    func routePickerViewWillBeginPresentingRoutes(_ routePickerView: AVRoutePickerView) {
        print("AirPlay route selection will begin")
    }
}
```

### 3. UI統合
- PlayerControlViewにAVRoutePickerViewを配置
- 既存のUIデザインに合わせたスタイリング
- 白いアイコンで統一感を保持

## 使用方法

### ユーザー向け
1. 動画再生中に右上のAirPlayボタンをタップ
2. 利用可能なAirPlayデバイスが表示される
3. 送信したいデバイスを選択
4. 動画がAirPlayデバイスで再生開始

### 開発者向け
```swift
// AirPlay機能の有効化
let playerVC = PlayerViewController()
playerVC.setupAirPlay() // 自動的に呼び出される

// カスタムデリゲート処理
extension PlayerViewController: AVRoutePickerViewDelegate {
    func routePickerViewDidEndPresentingRoutes(_ routePickerView: AVRoutePickerView) {
        // AirPlay接続終了時の処理
    }
}
```

## 注意事項

### 1. 無料Apple Developerアカウントの制限
- **配布制限**: 無料アカウントではApp Store配布不可
- **自己デバイス配布**: 開発者自身のデバイスでのみ動作
- **署名**: 7日間有効な開発用証明書が必要

### 2. AirPlay利用時の制約
- **ネットワーク**: 同じWi-Fiネットワーク内でのみ動作
- **デバイス対応**: AirPlay対応デバイスが必要
- **動画形式**: 標準的な動画形式（MP4、MOV等）を推奨

### 3. ビルド署名の更新
```bash
# 証明書の更新が必要な場合
# Xcode → Preferences → Accounts → 該当アカウント → Download Manual Profiles
```

### 4. Info.plist設定
```xml
<key>NSLocalNetworkUsageDescription</key>
<string>AirPlay機能を使用するために、ローカルネットワークへのアクセスが必要です。</string>
<key>NSBonjourServices</key>
<array>
    <string>_airplay._tcp</string>
    <string>_raop._tcp</string>
</array>
```

## トラブルシューティング

### AirPlayボタンが表示されない
1. ネットワーク接続を確認
2. AirPlay対応デバイスが同じネットワーク上にあるか確認
3. Info.plist設定を確認

### AirPlay接続ができない
1. デバイス間の距離を確認
2. ファイアウォール設定を確認
3. ネットワーク設定を確認

### 動画が再生されない
1. 動画形式の互換性を確認
2. AirPlayデバイスの対応状況を確認
3. ネットワーク帯域幅を確認

## 技術仕様

### 使用フレームワーク
- `AVFoundation`: AirPlay機能の基盤
- `AVKit`: 動画プレイヤー機能
- `UIKit`: UI実装

### 対応デバイス
- iOS 11.0以上
- iPadOS 13.0以上
- AirPlay対応デバイス

### 対応動画形式
- MP4 (H.264)
- MOV
- その他AVFoundationでサポートされる形式

## 今後の拡張可能性

1. **カスタムAirPlayUI**: より詳細なAirPlay設定画面
2. **複数デバイス対応**: 複数のAirPlayデバイスへの同時配信
3. **AirPlay 2対応**: より高度なAirPlay機能の活用
4. **オフライン機能**: AirPlay非対応時の代替機能

## 参考リンク

- [AVRoutePickerView Documentation](https://developer.apple.com/documentation/avfoundation/avroutepickerview)
- [AirPlay Developer Guide](https://developer.apple.com/airplay/)
- [AVFoundation Framework](https://developer.apple.com/documentation/avfoundation) 