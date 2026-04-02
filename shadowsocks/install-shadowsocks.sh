#!/bin/bash

PLIST_NAME="com.github.yylonly.shadowsocks"
PLIST_PATH="$HOME/Library/LaunchAgents/$PLIST_NAME.plist"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_PLIST="$REPO_DIR/$PLIST_NAME.plist"

# Ensure LaunchAgents directory exists
mkdir -p "$HOME/Library/LaunchAgents"

# Check if brew is installed
if ! command -v brew &>/dev/null; then
    echo "brew not found. Installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ $? -ne 0 ]; then
        echo "Failed to install brew."
        exit 1
    fi
    echo "brew installed successfully."

    # Auto config brew environment
    if ! grep -q 'brew shellenv zsh' ~/.zprofile 2>/dev/null; then
        echo >> ~/.zprofile
        echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> ~/.zprofile
    fi
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
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

# Ensure config exists
CONFIG_PATH="/opt/homebrew/etc/shadowsocks-libev.json"
if [ ! -f "$CONFIG_PATH" ]; then
    echo "Config file not found. Running wizard..."
    "$REPO_DIR/shadowsocks-wizard.sh"
fi

echo "Installing shadowsocks-libev launchd agent..."

# Debug: print paths
echo "DEBUG: REPO_DIR=$REPO_DIR"
echo "DEBUG: REPO_PLIST=$REPO_PLIST"
echo "DEBUG: PLIST_PATH=$PLIST_PATH"
echo "DEBUG: File exists at REPO_PLIST? $([ -f "$REPO_PLIST" ] && echo YES || echo NO)"

# Copy plist to LaunchAgents
cp "$REPO_PLIST" "$PLIST_PATH"
echo "Copied plist to $PLIST_PATH"

# Unload existing service if any (to avoid EIO errors)
launchctl unload "$PLIST_PATH" 2>/dev/null

# Load the service
launchctl load "$PLIST_PATH" && echo "Service loaded." || echo "Failed to load service."

echo "Done. shadowsocks-libev will start automatically at login."
