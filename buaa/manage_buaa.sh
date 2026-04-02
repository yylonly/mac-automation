#!/bin/bash
# 北航教务网站自动打开 - 管理脚本

PLIST_NAME="com.buaa.open.plist"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLIST_SOURCE="$SCRIPT_DIR/$PLIST_NAME"
PLIST_DEST="$HOME/Library/LaunchAgents/$PLIST_NAME"

install() {
    if [ ! -f "$PLIST_SOURCE" ]; then
        echo "错误: 找不到 $PLIST_SOURCE"
        exit 1
    fi
    cp "$PLIST_SOURCE" "$PLIST_DEST"
    launchctl load "$PLIST_DEST"
    echo "安装成功!"
}

uninstall() {
    launchctl unload "$PLIST_DEST" 2>/dev/null
    rm -f "$PLIST_DEST"
    echo "卸载成功!"
}

start() {
    launchctl start com.buaa.open
    echo "已触发一次打开"
}

stop() {
    launchctl unload "$PLIST_DEST"
    echo "已停止服务"
}

status() {
    launchctl list | grep com.buaa.open
}

case "$1" in
    install)
        install
        ;;
    uninstall)
        uninstall
        ;;
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        status
        ;;
    *)
        echo "用法: $0 {install|uninstall|start|stop|status}"
        exit 1
        ;;
esac
