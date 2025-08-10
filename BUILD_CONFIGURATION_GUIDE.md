# 子供ごとの動画リスト切り替え機能の使用方法

このドキュメントでは、Xcodeでビルド時に子供用アプリを切り替える方法を説明します。

## 概要

アプリは以下の2つの構成をサポートしています：

- **NICHAN (次男用)**: 恐竜のメニューを含む動画リスト + 共通コンテンツ
- **NIICHAN (長男用)**: Numberblocksを含む動画リスト + 共通コンテンツ
- **共通コンテンツ**: シンカリオン、マイクラ、ジョブレイバー

## Xcodeでの設定方法

### 方法1: ビルド構成の作成（推奨）

1. **Xcodeプロジェクトを開く**
2. **プロジェクト設定を開く**
   - Project Navigator でプロジェクト名をクリック
   - 「Info」タブを選択

3. **新しい構成を作成**
   - 「Configurations」セクションで「+」ボタンをクリック
   - 「Duplicate "Debug" Configuration」を選択
   - 名前を「Debug-NICHAN」に変更
   - 同様に「Debug-NIICHAN」も作成

4. **Swift Compiler Flagsを設定**
   - 「Build Settings」タブを選択
   - 「Swift Compiler - Custom Flags」を検索
   - 「Other Swift Flags」に以下を追加：
     - Debug-NICHAN: `-DNICHAN`
     - Debug-NIICHAN: `-DNIICHAN`

5. **スキームの作成**
   - Product → Scheme → Manage Schemes
   - 既存のスキームを複製
   - 名前を「KidsVideo-NICHAN」「KidsVideo-NIICHAN」に変更
   - 各スキームで対応するBuild Configurationを選択

### 方法2: 環境変数の使用（開発・テスト用）

1. **Xcodeでスキームを編集**
   - Product → Scheme → Edit Scheme
   - 「Run」の「Arguments」タブを選択
   - 「Environment Variables」に追加：
     - Name: `TARGET_CHILD`
     - Value: `NICHAN` または `NIICHAN`

## ファイル構成

```
KidsVideo/
├── Shared/
│   ├── Models/
│   │   └── Config/
│   │       └── ChildConfiguration.swift  # 構成管理システム
│   └── Resources/
│       ├── videos_nichan.json            # 次男用動画リスト
│       ├── videos_niichan.json           # 長男用動画リスト
│       ├── 恐竜.jpeg                     # 次男専用メニュー画像
│       └── Numberblocks.jpeg             # 長男専用メニュー画像
```

## 各構成の違い

### NICHAN (次男用) - videos_nichan.json
- **専用コンテンツ**: 恐竜
- **背景画像**: menu_background_image_ryuichi
- **メニュー項目**: マイクラ、シンカリオン、ジョブレイバー、恐竜

### NIICHAN (長男用) - videos_niichan.json  
- **専用コンテンツ**: Numberblocks
- **背景画像**: menu_background_image_ryoma
- **メニュー項目**: マイクラ、シンカリオン、ジョブレイバー、Numberblocks

## 動作確認

1. **ビルド前の確認**
   - JSON設定ファイルが正しく配置されているか確認
   - 画像リソースが存在するか確認

2. **実行時の確認**
   - メニュー画面で適切な項目が表示されるか
   - 背景画像が構成に応じて変更されるか
   - 動画リストが正しくフィルタされているか

## トラブルシューティング

### 構成が切り替わらない場合
1. Swift Compiler Flagsが正しく設定されているか確認
2. JSONファイルがBundle.mainに含まれているか確認
3. 環境変数TARGET_CHILDが正しく設定されているか確認

### 画像が表示されない場合
1. 画像ファイルがプロジェクトに追加されているか確認
2. Bundle.mainでパスが見つかるか確認

### JSONファイルが読み込まれない場合
1. JSONファイルがプロジェクトのリソースに追加されているか確認
2. JSON形式が正しいか確認（JSONLintなどで検証）

## 新しいコンテンツの追加

1. **新しいチャンネルの追加**
   - `Channel.swift`にenumケースを追加
   - `ContentsMaker.swift`と`MenuImageMaker.swift`の`channelFromString`関数を更新

2. **動画の追加**
   - 対応するJSONファイル（videos_nichan.json または videos_niichan.json）に動画情報を追加
   - 必要に応じて画像リソースを追加

3. **メニュー項目の追加**
   - JSONファイルの`menuImages`配列に新しい項目を追加
   - 対応する画像ファイルをリソースに追加