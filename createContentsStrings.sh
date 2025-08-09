#!/bin/sh

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

# process_videos "$HOME/Projects/KidsVideo/Shared/Resources/Movie/シンカリオン" "shinkalion"
# process_videos "$HOME/Projects/KidsVideo/Shared/Resources/Movie/マイクラ" "minecraft"
process_videos "$HOME/Projects/KidsVideo/Shared/Resources/Movie/ジョブレイバー" "jobraver"

cat $workFile | pbcopy
rm -rf $workFile
