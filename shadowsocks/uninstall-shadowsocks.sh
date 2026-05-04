#!/bin/bash

PLIST_NAME="com.github.yylonly.shadowsocks"
PLIST_PATH="$HOME/Library/LaunchAgents/$PLIST_NAME.plist"
WATCHER_PLIST_NAME="com.github.yylonly.shadowsocks.network-watcher"
WATCHER_PLIST_PATH="$HOME/Library/LaunchAgents/$WATCHER_PLIST_NAME.plist"

echo "Uninstalling shadowsocks-libev launchd agents..."

# Unload network watcher
if launchctl list | grep -q "$WATCHER_PLIST_NAME"; then
    launchctl unload "$WATCHER_PLIST_PATH"
    echo "Network watcher unloaded."
fi

# Unload the service
if launchctl list | grep -q "$PLIST_NAME"; then
    launchctl unload "$PLIST_PATH"
    echo "Service unloaded."
fi

# Remove plists
if [ -f "$WATCHER_PLIST_PATH" ]; then
    rm "$WATCHER_PLIST_PATH"
    echo "Removed $WATCHER_PLIST_PATH"
fi

if [ -f "$PLIST_PATH" ]; then
    rm "$PLIST_PATH"
    echo "Removed $PLIST_PATH"
fi

echo "Done. shadowsocks-libev has been uninstalled."
