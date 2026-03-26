#!/bin/bash
# 打开北航首页自动化脚本
# 每5分钟打开一次 https://www.buaa.edu.cn/

URL="https://www.buaa.edu.cn/"
INTERVAL=300  # 5分钟 = 300秒

echo "开始自动化任务：每5分钟打开北航首页"
echo "URL: $URL"
echo "按 Ctrl+C 停止"

while true; do
    open "$URL"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 已打开北航首页"
    sleep $INTERVAL
done
