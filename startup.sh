#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "Esse script precisa ser executado como root!"
  exit
fi

for cmd in wg ip iptables; do
    if ! command -v $cmd &> /dev/null; then
        echo "O comando '$cmd' não foi encontrado. Instale o WireGuard/iptables."
        exit
    fi
done

echo ""
echo "[1] Configuar novo servidor"
echo "[2] Configuar novo cliente"
echo "[3] Adicionar Peer no servidor"
echo "[4] Adicionar Servidor no cliente"
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