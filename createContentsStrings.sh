#!/bin/bash
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
    "https://www.youtube.com/watch?v=1D5B5CRg3r0 2 jinan"
    # "https://youtu.be/xxxxxxx 1 chonan"
    # 他の組み合わせをここに追加
)

# Function to process videos in a directory
process_videos() {
    local directory=$1
    local channel=$2
    local child=$3
    local fileName filePath durationWork durationMinutes durationSeconds duration jsonEntry
    
    for filePath in "$directory"/*.mp4; do
        [ -f "$filePath" ] || continue
        fileName=$(basename "$filePath" .mp4)
        
        # Check if file already exists in JSON before adding
        if [ "$child" = "chonan" ] || [ "$child" = "both" ]; then
            if jq -e --arg fname "$fileName" '.videos[] | select(.fileName == $fname)' "$HOME/Projects/KidsVideo/Shared/Resources/videos_chonan.json" >/dev/null 2>&1; then
                echo "Skipping duplicate entry for chonan: $fileName"
            else
                durationWork=$(mediainfo --Inform="Video;%Duration/String%" "$filePath")
                durationMinutes=$(echo "$durationWork" | cut -d' ' -f1)
                durationSeconds=$(echo "$durationWork" | cut -d' ' -f3)
                durationSeconds=$(printf "%02d" "${durationSeconds}")
                duration="${durationMinutes}:${durationSeconds}"
                jsonEntry=$(jq -n --arg fileName "$fileName" --arg fileExt "mp4" --arg totalTime "$duration" --arg channel "$channel" '{fileName: $fileName, fileExt: $fileExt, totalTime: $totalTime, channel: $channel}')
                jq ".videos += [${jsonEntry}]" "$HOME/Projects/KidsVideo/Shared/Resources/videos_chonan.json" > "$HOME/Projects/KidsVideo/Shared/Resources/videos_chonan.json.tmp" && mv "$HOME/Projects/KidsVideo/Shared/Resources/videos_chonan.json.tmp" "$HOME/Projects/KidsVideo/Shared/Resources/videos_chonan.json"
                echo "Added to chonan: $fileName"
            fi
        fi
        
        if [ "$child" = "jinan" ] || [ "$child" = "both" ]; then
            if jq -e --arg fname "$fileName" '.videos[] | select(.fileName == $fname)' "$HOME/Projects/KidsVideo/Shared/Resources/videos_jinan.json" >/dev/null 2>&1; then
                echo "Skipping duplicate entry for jinan: $fileName"
            else
                if [ ! -v durationWork ]; then
                    durationWork=$(mediainfo --Inform="Video;%Duration/String%" "$filePath")
                    durationMinutes=$(echo "$durationWork" | cut -d' ' -f1)
                    durationSeconds=$(echo "$durationWork" | cut -d' ' -f3)
                    durationSeconds=$(printf "%02d" "${durationSeconds}")
                    duration="${durationMinutes}:${durationSeconds}"
                    jsonEntry=$(jq -n --arg fileName "$fileName" --arg fileExt "mp4" --arg totalTime "$duration" --arg channel "$channel" '{fileName: $fileName, fileExt: $fileExt, totalTime: $totalTime, channel: $channel}')
                fi
                jq ".videos += [${jsonEntry}]" "$HOME/Projects/KidsVideo/Shared/Resources/videos_jinan.json" > "$HOME/Projects/KidsVideo/Shared/Resources/videos_jinan.json.tmp" && mv "$HOME/Projects/KidsVideo/Shared/Resources/videos_jinan.json.tmp" "$HOME/Projects/KidsVideo/Shared/Resources/videos_jinan.json"
                echo "Added to jinan: $fileName"
            fi
        fi
    done
}

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
            echo "ナンバーブロックス numberblocks"
            ;;
    esac
}

# Remove old duplicate entries first (optional cleanup)
# You can uncomment these lines if you want to clean existing JSON files
# echo '{"videos":[],"menuImages":[],"backgroundImage":"menu_background_image_chonan"}' > "$HOME/Projects/KidsVideo/Shared/Resources/videos_chonan.json"
# echo '{"videos":[],"menuImages":[],"backgroundImage":"menu_background_image_jinan"}' > "$HOME/Projects/KidsVideo/Shared/Resources/videos_jinan.json"

########################################
# Xcodeプロジェクトに動画ファイルを追加する処理
# 追加するには、mp4ファイルをproject.pbxprojに登録する必要がある
# ここでは簡易的に新規mp4ファイルを検出し、xcodeprojコマンドで追加する例
# xcodeproj gemが必要: gem install xcodeproj

add_files_to_xcodeproj() {
    local dir="$1"
    local xcodeproj_path="$HOME/Projects/KidsVideo/KidsVideo.xcodeproj"
    if command -v xcodeproj >/dev/null 2>&1; then
        for f in "$dir"/*.mp4; do
            if [ -f "$f" ]; then
                echo "Adding $f to Xcode project..."
                xcodeproj "$xcodeproj_path" add "$f" --group "Shared/Resources/Movie"
            fi
        done
    else
        echo "xcodeproj command not found, skipping Xcode project update"
    fi
}

# Main processing loop
for entry in "${TARGET_URLS[@]}"; do
    url=$(echo $entry | awk '{print $1}')
    channel_num=$(echo $entry | awk '{print $2}')
    child=$(echo $entry | awk '{print $3}')
    channel_info=$(get_channel_info $channel_num)
    target_dir=$(echo $channel_info | awk '{print $1}')
    target_name=$(echo $channel_info | awk '{print $2}')
    download_dir="$HOME/Projects/KidsVideo/Shared/Resources/Movie/$target_dir"
    mkdir -p "$download_dir"
    
    echo "Processing: $url for $child ($target_name)"
    
    if [ "$DRY_RUN" != "1" ]; then
        yt-dlp -f "bestvideo[height<=720]+bestaudio/best[height<=720]" -o "$download_dir/%(title)s.%(ext)s" "$url"
        add_files_to_xcodeproj "$download_dir"
        # .webmファイルがあればmp4に変換（映像ストリームがある場合のみ）し、元の.webmを削除
        for file in "$download_dir"/*.webm; do
            [ -f "$file" ] || continue
            # 映像ストリームがあるか判定
            has_video=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_type -of csv=p=0 "$file")
            if [ "$has_video" = "video" ]; then
                ffmpeg -i "$file" -c:v libx264 -c:a aac "${file%.webm}.mp4"
                rm "$file"
            else
                echo "映像ストリームなし: $file (変換しません)"
            fi
        done
    fi
    
    process_videos "$download_dir" "$target_name" "$child"
done

echo "Processing complete!"

# Rename files with spaces to use underscores
cd "$HOME/Projects/KidsVideo/Shared/Resources/Movie" 2>/dev/null || true
for FILE in *\ *; do 
    if [ -e "$FILE" ]; then
        mv "$FILE" "${FILE// /_}"
    fi
done 2>/dev/null || true
cd - >/dev/null || true
