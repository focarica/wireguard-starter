#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be executed as root!"
  exit 1
fi

for cmd in wg ip iptables; do
    if ! command -v $cmd &> /dev/null; then
        echo "The command '$cmd' was not found. Install WireGuard/iptables."
        exit 1
    fi
done

if [[ ! -d /etc/wireguard/ ]]; then
    mkdir -p /etc/wireguard/
    echo "Created wireguard dir in /etc/"
fi

echo ""
echo "[1] Configure new server"
echo "[2] Configure new client"
echo "[3] Add new client on the server"
echo "[4] Add new server on the client"
read -p "Select option [1-4]: " user_select
while ! [[ "$user_select" =~ ^[1-4]$ ]]; do
  echo "Invalid selection. Choose 1, 2, 3 or 4."
  read -p "Select option [1-4]: " user_select
done

cd lib/

case "$user_select" in
  1) source ./create-server.sh ;;
  2) source ./create-client.sh ;;
  3) source ./add-new-client.sh ;;
  4) source ./add-new-server.sh ;;
esac