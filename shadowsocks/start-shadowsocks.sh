#!/bin/bash

exec /opt/homebrew/opt/shadowsocks-libev/bin/ss-server \
    -c /opt/homebrew/etc/shadowsocks-libev.json
