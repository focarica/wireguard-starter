#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be executed as root!"
  exit
fi

for cmd in wg ip iptables; do
    if ! command -v $cmd &> /dev/null; then
        echo "The command '$cmd' was not found. Install WireGuard/iptables."
        exit
    fi
done

if [[ ! -d /etc/wireguard/ ]]; then
    mkdir /etc/wireguard/
    echo "Created wireguard dir in /etc/"
fi

echo ""
echo "[1] Configure new server"
echo "[2] Configure new client"
echo "[3] Add new client on the server"
echo "[4] Add new server on the client"
read user_select

if [[ $user_select == 1 ]]; then
	source ./create-server.sh
fi

if [[ $user_select == 2 ]]; then
  source ./create-client.sh
fi

if [[ $user_select == 3 ]]; then
	source ./add-new-client.sh
fi

if [[ $user_select == 4 ]]; then
	source ./add-new-server.sh
fi