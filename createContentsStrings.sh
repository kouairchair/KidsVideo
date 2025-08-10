
#!/bin/sh
# List of YouTube URLs and channel numbers (tuple array)
# Format: "URL チャンネル番号"
TARGET_URLS=(
    "https://youtu.be/byTCfdoa_lI?si=CoR1vBzSUko0KMvi 2"
    # "https://youtu.be/xxxxxxx 1"
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
    
    find "$directory" -name "*.mp4" -print0 | while IFS= read -r -d '' filePath; do
        fileName=$(basename "$filePath" .mp4)
        durationWork=$(mediainfo --Inform="Video;%Duration/String%" "$filePath")
        durationMinutes=$(echo "$durationWork" | cut -d' ' -f1)
        durationSeconds=$(echo "$durationWork" | cut -d' ' -f3)
        #ゼロ埋め
        durationSeconds=$(printf "%02d" "${durationSeconds}")
        duration="${durationMinutes}:${durationSeconds}"
        echo "            Content(fileName: \"$fileName\", fileExt: \"mp4\", totalTime: \"$duration\", channel: .$channel)," >> $workFile           
    done
}

for FILE in *\ *; do mv "$FILE" "${FILE// /_}"; done
workFile="$HOME/Projects/KidsVideo/workFile.txt"
touch $workFile
ls $workFile
cat /dev/null > $workFile

process_videos "$DOWNLOAD_DIR" "$TARGET_NAME"

cat $workFile | pbcopy
rm -rf $workFile
