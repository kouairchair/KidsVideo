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
# - chonan: 長男専用
# - jinan: 次男専用
# - both: 両方共通
#
# チャンネル番号:
# 1: シンカリオン, 2: マイクラ, 3: ジョブレイバー, 4: 恐竜, 5: ナンバーブロックス
#
# オプション:
# DRY_RUN=1 を設定すると、実際のダウンロードを行わずに設定確認のみ実行

# List of YouTube URLs, channel numbers, and child targeting (tuple array)
# Format: "URL チャンネル番号 子供指定"
# 子供指定: chonan(長男), jinan(次男), both(両方)
TARGET_URLS=(
    "https://youtu.be/byTCfdoa_lI?si=CoR1vBzSUko0KMvi 2 both"
    # "https://youtu.be/xxxxxxx 1 chonan"
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
        *)
            echo "ダウンロード download"
            ;;
    esac
}

# 1つだけ選択して実行（最初の要素）
SELECTED="${TARGET_URLS[0]}"
SELECTED_URL=$(echo $SELECTED | awk '{print $1}')
SELECTED_CHANNEL_NUM=$(echo $SELECTED | awk '{print $2}')
SELECTED_CHILD=$(echo $SELECTED | awk '{print $3}')
CHANNEL_INFO=$(get_channel_info $SELECTED_CHANNEL_NUM)
TARGET_DIR=$(echo $CHANNEL_INFO | awk '{print $1}')
TARGET_NAME=$(echo $CHANNEL_INFO | awk '{print $2}')

# Directory to save downloaded videos
DOWNLOAD_DIR="$HOME/Projects/KidsVideo/Shared/Resources/Movie/$TARGET_DIR"
mkdir -p "$DOWNLOAD_DIR"

# Download video from YouTube
yt-dlp -f "best[height<=720]" -o "$DOWNLOAD_DIR/%(title)s.%(ext)s" "$SELECTED_URL"

# Directory to save downloaded videos
DOWNLOAD_DIR="$HOME/Projects/KidsVideo/Shared/Resources/Movie/{TARGET}"
mkdir -p "$DOWNLOAD_DIR"

# Download videos from YouTube
for URL in "${TARGET_URLS[@]}"; do
    yt-dlp -f "best[height<=720]" -o "$DOWNLOAD_DIR/%(title)s.%(ext)s" "$URL"
done

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

# ダウンロード・処理後にXcodeプロジェクトへ追加
add_files_to_xcodeproj "$DOWNLOAD_DIR"

# Function to process videos in a directory
process_videos() {
    local directory=$1
    local channel=$2
    local child=$3
    local fileName filePath durationWork durationMinutes durationSeconds duration jsonEntry
    for filePath in "$directory"/*.mp4; do
        [ -f "$filePath" ] || continue
        fileName=$(basename "$filePath" .mp4)
        durationWork=$(mediainfo --Inform="Video;%Duration/String%" "$filePath")
        durationMinutes=$(echo "$durationWork" | cut -d' ' -f1)
        durationSeconds=$(echo "$durationWork" | cut -d' ' -f3)
        durationSeconds=$(printf "%02d" "${durationSeconds}")
        duration="${durationMinutes}:${durationSeconds}"
        jsonEntry=$(jq -n --arg fileName "$fileName" --arg fileExt "mp4" --arg totalTime "$duration" --arg channel "$channel" '{fileName: $fileName, fileExt: $fileExt, totalTime: $totalTime, channel: $channel}')
        if [ "$child" = "chonan" ] || [ "$child" = "both" ]; then
            jq ".videos += [${jsonEntry}]" "$HOME/Projects/KidsVideo/Shared/Resources/videos_chonan.json" > "$HOME/Projects/KidsVideo/Shared/Resources/videos_chonan.json.tmp" && mv "$HOME/Projects/KidsVideo/Shared/Resources/videos_chonan.json.tmp" "$HOME/Projects/KidsVideo/Shared/Resources/videos_chonan.json"
        fi
        if [ "$child" = "jinan" ] || [ "$child" = "both" ]; then
            jq ".videos += [${jsonEntry}]" "$HOME/Projects/KidsVideo/Shared/Resources/videos_jinan.json" > "$HOME/Projects/KidsVideo/Shared/Resources/videos_jinan.json.tmp" && mv "$HOME/Projects/KidsVideo/Shared/Resources/videos_jinan.json.tmp" "$HOME/Projects/KidsVideo/Shared/Resources/videos_jinan.json"
        fi
    done
}

for FILE in *\ *; do mv "$FILE" "${FILE// /_}"; done

for entry in "${TARGET_URLS[@]}"; do
    url=$(echo $entry | awk '{print $1}')
    channel_num=$(echo $entry | awk '{print $2}')
    child=$(echo $entry | awk '{print $3}')
    channel_info=$(get_channel_info $channel_num)
    target_dir=$(echo $channel_info | awk '{print $1}')
    target_name=$(echo $channel_info | awk '{print $2}')
    download_dir="$HOME/Projects/KidsVideo/Shared/Resources/Movie/$target_dir"
    mkdir -p "$download_dir"
    if [ "$DRY_RUN" != "1" ]; then
        yt-dlp -f "best[height<=720]" -o "$download_dir/%(title)s.%(ext)s" "$url"
    fi
    process_videos "$download_dir" "$target_name" "$child"
done
