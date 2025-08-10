# createContentsStrings.sh 使用例 (Usage Examples)

## 子供ごとの動画リスト切り替え機能対応版

このドキュメントは、更新された `createContentsStrings.sh` スクリプトの使用方法を説明します。

### 基本的な使用方法

1. **TARGET_URLS配列の設定**
```bash
TARGET_URLS=(
    "https://youtu.be/video1 1 niichan"    # 長男専用のシンカリオン動画
    "https://youtu.be/video2 4 nichan"     # 次男専用の恐竜動画
    "https://youtu.be/video3 2 both"       # 両方共通のマイクラ動画
    "https://youtu.be/video4 5 niichan"    # 長男専用のナンバーブロックス動画
)
```

2. **スクリプトの実行**
```bash
# 通常実行（実際にダウンロード）
./createContentsStrings.sh

# テスト実行（ダウンロードなし）
DRY_RUN=1 ./createContentsStrings.sh
```

### チャンネル番号一覧

| 番号 | チャンネル | ディレクトリ | コード名 |
|------|-----------|-------------|----------|
| 1 | シンカリオン | シンカリオン | shinkalion |
| 2 | マイクラ | マイクラ | minecraft |
| 3 | ジョブレイバー | ジョブレイバー | jobraver |
| 4 | 恐竜 | 恐竜 | dinasaur |
| 5 | ナンバーブロックス | ナンバーブロックス | numberblocks |

### 子供指定オプション

| 指定 | 意味 | 対象 |
|------|------|------|
| `niichan` | 長男専用 | 長男のみ |
| `nichan` | 次男専用 | 次男のみ |
| `both` | 両方共通 | 両方の子供 |

### 生成されるContentエントリの例

```swift
// 長男対象の動画
Content(fileName: "sample_shinkalion_video", fileExt: "mp4", totalTime: "24:08", channel: .shinkalion),

// 次男対象の動画  
Content(fileName: "sample_dinosaur_video", fileExt: "mp4", totalTime: "54:25", channel: .dinasaur),

// 両方対象の動画
Content(fileName: "sample_minecraft_video", fileExt: "mp4", totalTime: "11:45", channel: .minecraft),
```

### 実装された機能

1. **子供ごとの動画ターゲティング**: 各動画が長男、次男、または両方のどちらを対象とするかを指定可能
2. **入力検証**: 不正な子供指定は自動的に 'both' にフォールバック
3. **エラーハンドリング**: ダウンロード失敗やパラメータ不正の適切な処理
4. **テストモード**: DRY_RUN=1 でダウンロードなしでのテスト実行
5. **詳細ログ**: 処理状況の詳細な表示
6. **新チャンネル対応**: ナンバーブロックス (チャンネル5) の追加

### 注意事項

- スクリプトは最初の動画のみを処理します（現在の実装）
- yt-dlp とmediainfoがインストールされている必要があります
- macOSでは自動的にクリップボードにコピーされます
- Linuxでは手動でコピーする必要があります