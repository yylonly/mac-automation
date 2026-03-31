#!/bin/bash

PLIST_NAME="com.github.yylonly.shadowsocks"
PLIST_PATH="$HOME/Library/LaunchAgents/$PLIST_NAME.plist"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_PLIST="$REPO_DIR/$PLIST_NAME.plist"

# Check if brew is installed
if ! command -v brew &>/dev/null; then
    echo "brew not found. Installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ $? -ne 0 ]; then
        echo "Failed to install brew."
        exit 1
    fi
    echo "brew installed successfully."
fi

# Check if shadowsocks-libev is installed
if ! brew list shadowsocks-libev &>/dev/null; then
    echo "shadowsocks-libev not found. Installing via brew..."
    brew install shadowsocks-libev
    if [ $? -ne 0 ]; then
        echo "Failed to install shadowsocks-libev."
        exit 1
    fi
    echo "shadowsocks-libev installed successfully."
fi

echo "Installing shadowsocks-libev launchd agent..."

# Copy plist to LaunchAgents
cp "$REPO_PLIST" "$PLIST_PATH"
echo "Copied plist to $PLIST_PATH"

# Load the service
launchctl load "$PLIST_PATH"
echo "Service loaded."

echo "Done. shadowsocks-libev will start automatically at login."
