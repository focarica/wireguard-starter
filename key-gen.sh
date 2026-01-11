#!/bin/bash

interface_name=$1

key_dir="/etc/wireguard/keys/$interface_name"

mkdir -p "$key_dir"
chmod 700 "$key_dir"

wg genkey | tee "$key_dir/privatekey" | wg pubkey > "$key_dir/publickey"

chmod 600 "$key_dir/privatekey"
chmod 644 "$key_dir/publickey"

private_key=$(cat "$key_dir/privatekey")
public_key=$(cat "$key_dir/publickey")

echo "Public Key generated:"
cat "$key_dir/publickey"
