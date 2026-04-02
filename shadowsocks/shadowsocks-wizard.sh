#!/bin/bash

CONFIG_PATH="/opt/homebrew/etc/shadowsocks-libev.json"

echo "=== Shadowsocks-libev Configuration Wizard ==="
echo

# Server address
read -p "Server address [$server]: " input
server=${input:-"0.0.0.0"}

# Server port
read -p "Server port [8388]: " input
server_port=${input:-8388}

# Local port
read -p "Local port [1080]: " input
local_port=${input:-1080}

# Password
read -s -p "Password: " password
echo
while [ -z "$password" ]; do
    echo "Password cannot be empty. Please enter a password:"
    read -s -p "Password: " password
    echo
done

# Timeout
read -p "Timeout in seconds [60]: " input
timeout=${input:-60}

# Method
echo "Encryption method:"
echo "  1) aes-256-cfb (recommended)"
echo "  2) aes-128-cfb"
echo "  3) chacha20-ietf"
echo "  4) xchacha20-ietf-poly1305"
read -p "Select method [1]: " input
case ${input:-1} in
    2) method="aes-128-cfb" ;;
    3) method="chacha20-ietf" ;;
    4) method="xchacha20-ietf-poly1305" ;;
    *) method="aes-256-cfb" ;;
esac

# Generate JSON
cat > "$CONFIG_PATH" << EOF
{
    "server":"$server",
    "server_port":$server_port,
    "local_port":$local_port,
    "password":"$password",
    "timeout":$timeout,
    "method":"$method"
}
EOF

echo
echo "Configuration saved to $CONFIG_PATH"
