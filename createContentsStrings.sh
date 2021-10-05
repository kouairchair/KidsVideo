#!/bin/sh
for FILE in *\ *; do mv "$FILE" "${FILE// /_}"; done
workFile="/Users/headspinnerd/Projects/KidsVideo/workFile.txt"
touch $workFile
ls $workFile
cat /dev/null > $workFile
#for filePath in `ls ~/Projects/KidsVideo/Shared/Resources/Movie/アンパンマンxレオくん/*.mp4`
#for filePath in `ls ~/Projects/KidsVideo/Shared/Resources/Movie/レオくん/*.mp4`
for filePath in `ls ~/Projects/KidsVideo/Shared/Resources/Movie/リトルエンジェル/*.mp4`
#for filePath in `ls ~/Projects/KidsVideo/Shared/Resources/Movie/MeruChan/*.mp4`
#for filePath in `ls ~/Projects/KidsVideo/Shared/Resources/Movie/鈴川絢子/*.mp4`
do
    fileName=`echo $filePath | awk -F "/" '{print $NF}' | sed 's/.mp4//g'`
    durationWork=`mediainfo --Inform="Video;%Duration/String%" $filePath`
    durationMinutes=`echo $durationWork | cut -d' ' -f1`
    durationSeconds=`echo $durationWork | cut -d' ' -f3`
    #ゼロ埋め
    durationSeconds=`printf "%02d" "${durationSeconds}"`
    duration="${durationMinutes}:${durationSeconds}"
    #echo "            Content(fileName: \""$fileName\"", fileExt: \""mp4\"", totalTime: \""$duration\"", channel: .reo_anpanman)," >> $workFile           
    #echo "            Content(fileName: \""$fileName\"", fileExt: \""mp4\"", totalTime: \""$duration\"", channel: .reo)," >> $workFile           
    #echo "            Content(fileName: \""$fileName\"", fileExt: \""mp4\"", totalTime: \""$duration\"", channel: .meruchan)," >> $workFile           
    echo "            Content(fileName: \""$fileName\"", fileExt: \""mp4\"", totalTime: \""$duration\"", channel: .littleAngel)," >> $workFile           
    #echo "            Content(fileName: \""$fileName\"", fileExt: \""mp4\"", totalTime: \""$duration\"", channel: .suzukawaAyako)," >> $workFile           
#            Content(fileName: "レオくんがアンパンマンのおしゃべりすいはんきと元気100ばい和食セットであそぶよ！レオスマイル", fileExt: "mp4", totalTime: "11:30", channel: .reo_anpanman),
done
cat $workFile | pbcopy
rm -rf $workFile
