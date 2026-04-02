# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

```
install-shadowsocks.sh ──copy──► ~/Library/LaunchAgents/com.github.yylonly.shadowsocks.plist
        │                                    │
        │                              launchctl load
        ▼                                    ▼
   brew install                     ┌─────────────────┐
                                    │ start-shadowsocks.sh
                                    │ (invoked by launchd)
                                    └────────┬────────┘
                                             │ runs
                                             ▼
                                    ss-server -c /opt/homebrew/etc/shadowsocks-libev.json
```

## Common Commands

```bash
./install-shadowsocks.sh      # Install brew, shadowsocks-libev, copy plist, load service
./shadowsocks-wizard.sh       # Interactively configure shadowsocks-libev.json
./uninstall-shadowsocks.sh    # Unload and remove the launchd agent
launchctl list | grep shadows  # Check if service is running
```

## Configuration

- **Shadowsocks config**: `/opt/homebrew/etc/shadowsocks-libev.json` (configured via wizard)
- **launchd plist location**: `~/Library/LaunchAgents/`
- **Service label**: `com.github.yylonly.shadowsocks`

## Important Notes

- The plist hardcodes the path to `start-shadowsocks.sh` as `/Users/yylonly/mac-automation/shadowsocks/`. This path must match the actual deployment location for the service to work.
- The `uninstall-shadowsocks.sh` uses a different plist name (`com.shadowsocks-libev`) than what `install-shadowsocks.sh` creates (`com.github.yylonly.shadowsocks`) - this appears to be an inconsistency.
