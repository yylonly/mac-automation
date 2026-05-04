#!/bin/bash

# Network Watcher for Shadowsocks
# Monitors network changes and restarts shadowsocks service

SERVICE_LABEL="com.github.yylonly.shadowsocks"
SHADOWSOCKS_JSON="/opt/homebrew/etc/shadowsocks-libev.json"
LOG_FILE="/Users/yylonly/mac-automation/shadowsocks/logs/network-watcher.log"
PID_FILE="/Users/yylonly/mac-automation/shadowsocks/logs/network-watcher.pid"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

get_current_default_route() {
    route -n get default 2>/dev/null | grep "interface:" | awk '{print $2}'
}

get_active_interfaces() {
    networksetup -listallhardwareports 2>/dev/null | while read line; do
        if [[ "$line" =~ "Hardware Port:" ]]; then
            port=$(echo "$line" | sed 's/Hardware Port: //')
        elif [[ "$line" =~ "Device:" ]]; then
            device=$(echo "$line" | sed 's/Device: //')
            if [[ -n "$device" ]]; then
                ifconfig "$device" 2>/dev/null | grep -q "status: active" && echo "$device"
            fi
        fi
    done
}

is_vpn_active() {
    # Check if any utun interface has an IP address (VPN connected)
    # Disconnected VPN leaves utun interfaces but no inet address
    for iface in $(ifconfig 2>/dev/null | grep -E "^utun[0-9]+:" | sed 's/:.*//'); do
        if ifconfig "$iface" 2>/dev/null | grep -q "inet "; then
            return 0
        fi
    done
    return 1
}

restart_shadowsocks() {
    log "Network change detected, restarting shadowsocks..."

    # Unload the service
    launchctl unload -w "$HOME/Library/LaunchAgents/com.github.yylonly.shadowsocks.plist" 2>/dev/null

    # Wait a moment for cleanup
    sleep 1

    # Load the service again
    launchctl load -w "$HOME/Library/LaunchAgents/com.github.yylonly.shadowsocks.plist"

    log "Shadowsocks service restarted successfully"
}

# Check if already running
if [[ -f "$PID_FILE" ]]; then
    OLD_PID=$(cat "$PID_FILE")
    if kill -0 "$OLD_PID" 2>/dev/null; then
        log "Network watcher already running with PID $OLD_PID"
        exit 1
    fi
fi

# Write PID
echo $$ > "$PID_FILE"

log "Network watcher started (PID: $$)"
log "Monitoring network changes..."

# Store initial state
LAST_ROUTE=$(get_current_default_route)
LAST_INTERFACES=$(get_active_interfaces | sort | tr '\n' ' ')
LAST_VPN=$(is_vpn_active && echo "yes" || echo "no")

log "Initial state - Route: $LAST_ROUTE, VPN: $LAST_VPN"

# Main monitoring loop
while true; do
    sleep 5

    CURRENT_ROUTE=$(get_current_default_route)
    CURRENT_INTERFACES=$(get_active_interfaces | sort | tr '\n' ' ')
    CURRENT_VPN=$(is_vpn_active && echo "yes" || echo "no")

    # Check for network changes
    if [[ "$CURRENT_ROUTE" != "$LAST_ROUTE" ]] || \
       [[ "$CURRENT_INTERFACES" != "$LAST_INTERFACES" ]] || \
       [[ "$CURRENT_VPN" != "$LAST_VPN" ]]; then

        log "Network change detected:"
        log "  Route: $LAST_ROUTE -> $CURRENT_ROUTE"
        log "  VPN: $LAST_VPN -> $CURRENT_VPN"
        log "  Interfaces: $LAST_INTERFACES -> $CURRENT_INTERFACES"

        # Wait a bit more to ensure network is stable
        sleep 3

        restart_shadowsocks

        # Update state
        LAST_ROUTE=$CURRENT_ROUTE
        LAST_INTERFACES=$CURRENT_INTERFACES
        LAST_VPN=$CURRENT_VPN
    fi
done
