
#!/bin/sh
# YouTube動画ダウンロード & Content生成スクリプト（子供ごとの動画リスト対応版）
#
# このスクリプトは、YouTube動画をダウンロードして、子供ごとの動画リスト切り替え機能に
# 対応したContentエントリを生成します。
#
# 使用方法:
# 1. TARGET_URLSに動画URL、チャンネル番号、子供指定を追加
# 2. スクリプトを実行すると、最初の動画がダウンロードされます
# 3. 生成されたContentエントリがクリップボードにコピーされます
#
# 子供指定:
# - niichan: 長男専用
# - nichan: 次男専用  
# - both: 両方共通
#
# チャンネル番号:
# 1: シンカリオン, 2: マイクラ, 3: ジョブレイバー, 4: 恐竜, 5: ナンバーブロックス
#
# オプション:
# DRY_RUN=1 を設定すると、実際のダウンロードを行わずに設定確認のみ実行

# List of YouTube URLs, channel numbers, and child targeting (tuple array)
# Format: "URL チャンネル番号 子供指定"
# 子供指定: niichan(長男), nichan(次男), both(両方)
TARGET_URLS=(
    "https://youtu.be/byTCfdoa_lI?si=CoR1vBzSUko0KMvi 2 both"
    # "https://youtu.be/xxxxxxx 1 niichan"
    # "https://youtu.be/xxxxxxx 4 nichan"
    # "https://youtu.be/xxxxxxx 5 niichan"
    # 他の組み合わせをここに追加
)

# チャンネル番号とディレクトリ・チャンネル名の対応
get_channel_info() {
    local channel_num=$1
    case $channel_num in
        1)
            echo "シンカリオン shinkalion"
            ;;
        2)
            echo "マイクラ minecraft"
            ;;
        3)
            echo "ジョブレイバー jobraver"
            ;;
        4)
            echo "恐竜 dinasaur"
            ;;
        5)
            echo "ナンバーブロックス numberblocks"
            ;;
        *)
            echo "ダウンロード download"
            ;;
    esac
}

# 子供指定から対象を判定する関数
get_child_target() {
    local child_spec=$1
    case $child_spec in
        niichan)
            echo "長男"
            ;;
        nichan)
            echo "次男"
            ;;
        both)
            echo "両方"
            ;;
        *)
            echo "両方"
            ;;
    esac
}

# 子供指定の妥当性をチェックする関数
validate_child_spec() {
    local child_spec=$1
    case $child_spec in
        niichan|nichan|both)
            return 0
            ;;
        *)
            echo "警告: 不正な子供指定 '$child_spec' (デフォルトで'both'を使用)"
            return 1
            ;;
    esac
}

# 単一動画をダウンロード・処理する関数
process_single_video() {
    local url=$1
    local channel_num=$2
    local child_spec=$3
    
    # 入力検証
    if [ -z "$url" ] || [ -z "$channel_num" ] || [ -z "$child_spec" ]; then
        echo "エラー: URL、チャンネル番号、子供指定がすべて必要です"
        return 1
    fi
    
    validate_child_spec "$child_spec"
    
    CHANNEL_INFO=$(get_channel_info $channel_num)
    TARGET_DIR=$(echo $CHANNEL_INFO | awk '{print $1}')
    TARGET_NAME=$(echo $CHANNEL_INFO | awk '{print $2}')
    CHILD_TARGET=$(get_child_target $child_spec)
    
    # Directory to save downloaded videos
    DOWNLOAD_DIR="$HOME/Projects/KidsVideo/Shared/Resources/Movie/$TARGET_DIR"
    mkdir -p "$DOWNLOAD_DIR"
    
    echo "動画をダウンロード中: $url -> $TARGET_DIR ($CHILD_TARGET対象)"
    
    # Download video from YouTube
    if [ "$DRY_RUN" = "1" ]; then
        echo "DRY_RUN: ダウンロードをスキップしました"
        # 既存のmp4ファイルがあればそれを処理
        if [ -n "$(find "$DOWNLOAD_DIR" -name "*.mp4" -print -quit)" ]; then
            echo "既存のmp4ファイルを処理します"
            # ダウンロード・処理後にXcodeプロジェクトへ追加
            add_files_to_xcodeproj "$DOWNLOAD_DIR"
            
            # Contentエントリ生成
            process_videos "$DOWNLOAD_DIR" "$TARGET_NAME" "$CHILD_TARGET"
        else
            echo "DRY_RUN: mp4ファイルが見つからないため、サンプルのContentエントリを生成します"
            echo "            // $CHILD_TARGET対象の動画 (サンプル)" >> $workFile
            echo "            Content(fileName: \"sample_video\", fileExt: \"mp4\", totalTime: \"00:00\", channel: .$TARGET_NAME)," >> $workFile
        fi
    else
        yt-dlp -f "best[height<=720]" -o "$DOWNLOAD_DIR/%(title)s.%(ext)s" "$url"
        
        if [ $? -eq 0 ]; then
            echo "ダウンロード完了: $TARGET_DIR ($CHILD_TARGET対象)"
            
            # ダウンロード・処理後にXcodeプロジェクトへ追加
            add_files_to_xcodeproj "$DOWNLOAD_DIR"
            
            # Contentエントリ生成
            process_videos "$DOWNLOAD_DIR" "$TARGET_NAME" "$CHILD_TARGET"
        else
            echo "エラー: 動画のダウンロードに失敗しました: $url"
            return 1
        fi
    fi
}

########################################
# Xcodeプロジェクトに動画ファイルを追加する処理
# 追加するには、mp4ファイルをproject.pbxprojに登録する必要がある
# ここでは簡易的に新規mp4ファイルを検出し、xcodeprojコマンドで追加する例
# xcodeproj gemが必要: gem install xcodeproj

add_files_to_xcodeproj() {
    local dir="$1"
    local xcodeproj_path="$HOME/Projects/KidsVideo/KidsVideo.xcodeproj"
    for f in "$dir"/*.mp4; do
        if [ -f "$f" ]; then
            echo "Adding $f to Xcode project..."
            xcodeproj "$xcodeproj_path" add "$f" --group "Shared/Resources/Movie"
        fi
    done
}

# Function to process videos in a directory
process_videos() {
    local directory=$1
    local channel=$2
    local child_target=$3
    
    find "$directory" -name "*.mp4" -print0 | while IFS= read -r -d '' filePath; do
        fileName=$(basename "$filePath" .mp4)
        durationWork=$(mediainfo --Inform="Video;%Duration/String%" "$filePath")
        durationMinutes=$(echo "$durationWork" | cut -d' ' -f1)
        durationSeconds=$(echo "$durationWork" | cut -d' ' -f3)
        #ゼロ埋め
        durationSeconds=$(printf "%02d" "${durationSeconds}")
        duration="${durationMinutes}:${durationSeconds}"
        echo "            // $child_target対象の動画" >> $workFile
        echo "            Content(fileName: \"$fileName\", fileExt: \"mp4\", totalTime: \"$duration\", channel: .$channel)," >> $workFile           
    done
}

# メイン処理: 最初の動画を処理
if [ ${#TARGET_URLS[@]} -eq 0 ]; then
    echo "エラー: TARGET_URLSが空です"
    exit 1
fi

# 1つだけ選択して実行（最初の要素）
SELECTED="${TARGET_URLS[0]}"
SELECTED_URL=$(echo $SELECTED | awk '{print $1}')
SELECTED_CHANNEL_NUM=$(echo $SELECTED | awk '{print $2}')
SELECTED_CHILD_SPEC=$(echo $SELECTED | awk '{print $3}')

echo "=== 子供ごとの動画リスト対応版 - Content生成スクリプト ==="
echo "処理対象動画: $SELECTED_URL"
echo "チャンネル: $SELECTED_CHANNEL_NUM"
echo "子供指定: $SELECTED_CHILD_SPEC"
echo ""

# ワークファイル準備
for FILE in *\ *; do mv "$FILE" "${FILE// /_}" 2>/dev/null; done
workFile="/tmp/KidsVideo_workFile.txt"
touch $workFile
cat /dev/null > $workFile

# 動画処理実行
process_single_video "$SELECTED_URL" "$SELECTED_CHANNEL_NUM" "$SELECTED_CHILD_SPEC"

echo ""
echo "=== 生成されたContentエントリ ==="
cat $workFile
echo ""
if command -v pbcopy >/dev/null 2>&1; then
    echo "Contentエントリがクリップボードにコピーされました"
    cat $workFile | pbcopy
else
    echo "pbcopyが利用できません。上記のContentエントリを手動でコピーしてください。"
fi
rm -rf $workFile

echo ""
echo "=== 完了 ==="
