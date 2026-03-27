#!/bin/bash

PLIST_NAME="com.github.yylonly.shadowsocks"
PLIST_PATH="$HOME/Library/LaunchAgents/$PLIST_NAME.plist"
REPO_PLIST="$(dirname "$0")/$PLIST_NAME.plist"

echo "Installing shadowsocks-libev launchd agent..."

# Copy plist to LaunchAgents
cp "$REPO_PLIST" "$PLIST_PATH"
echo "Copied plist to $PLIST_PATH"

# Load the service
launchctl load "$PLIST_PATH"
echo "Service loaded."

echo "Done. shadowsocks-libev will start automatically at login."
