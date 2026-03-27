#!/bin/bash
# 打开北航教务网站自动化脚本
# 每1分钟打开一次 https://kyfw.buaa.edu.cn/

URL="https://kyfw.buaa.edu.cn/"
INTERVAL=60  # 1分钟 = 60秒

echo "开始自动化任务：每1分钟打开北航教务网站"
echo "URL: $URL"
echo "按 Ctrl+C 停止"

while true; do
    # 在 Safari 中关闭所有标签页，只保留一个空白页后打开URL
    osascript -e '
        tell application "Safari"
            if (count of windows) = 0 then
                make new document
                set URL of front document to "'"$URL"'"
            else
                tell front window
                    # 关闭除第一个tab外的所有tab
                    repeat while (count of tabs) > 1
                        close tab 2 of front window
                    end repeat
                    # 第一个tab加载URL
                    set URL of tab 1 to "'"$URL"'"
                end tell
            end if
        end tell
    ' 2>/dev/null
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 已打开北航教务网站"
    sleep $INTERVAL
done
