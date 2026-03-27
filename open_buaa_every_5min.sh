#!/bin/bash
# 打开北航教务网站自动化脚本
# 每1分钟打开一次 https://kyfw.buaa.edu.cn/

URL="https://kyfw.buaa.edu.cn/"
INTERVAL=60  # 1分钟 = 60秒

echo "开始自动化任务：每1分钟打开北航教务网站"
echo "URL: $URL"
echo "按 Ctrl+C 停止"

while true; do
    open "$URL"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 已打开北航教务网站"
    sleep $INTERVAL
done
