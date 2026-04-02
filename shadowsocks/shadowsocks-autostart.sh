#!/bin/bash

PLIST_NAME="com.shadowsocks-libev"
PLIST_PATH="$HOME/Library/LaunchAgents/${PLIST_NAME}.plist"
LAUNCHCTL_LABEL="homebrew.${PLIST_NAME}"

install() {
    if [ -f "$PLIST_PATH" ]; then
        echo "Already installed: $PLIST_PATH"
    else
        echo "Installing..."
    fi

    launchctl load "$PLIST_PATH" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "Installed and loaded successfully."
    else
        echo "Failed to load. Try running manually: launchctl load $PLIST_PATH"
    fi
}

uninstall() {
    echo "Unloading..."
    launchctl unload "$PLIST_PATH" 2>/dev/null
    rm -f "$PLIST_PATH"
    echo "Uninstalled."
}

case "$1" in
    install)
        install
        ;;
    uninstall)
        uninstall
        ;;
    *)
        echo "Usage: $0 {install|uninstall}"
        ;;
esac
