#!/bin/bash

PLIST_NAME="com.github.yylonly.shadowsocks"
PLIST_PATH="$HOME/Library/LaunchAgents/$PLIST_NAME.plist"

echo "Uninstalling shadowsocks-libev launchd agent..."

# Unload the service
if launchctl list | grep -q "$PLIST_NAME"; then
    launchctl unload "$PLIST_PATH"
    echo "Service unloaded."
fi

# Remove plist
if [ -f "$PLIST_PATH" ]; then
    rm "$PLIST_PATH"
    echo "Removed $PLIST_PATH"
fi

echo "Done. shadowsocks-libev has been uninstalled."
