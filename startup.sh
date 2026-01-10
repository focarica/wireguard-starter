#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "Esse script precisa ser executado como root!"
  exit
fi

echo "##############################"
echo "Assistente de criacao de VPN - Server" 

echo "Defina um nome para a interface de rede: "
read interface_name

######## Criacao de chaves
key_dir="/etc/wireguard/keys/$interface_name"

mkdir -p "$key_dir"
chmod 700 "$key_dir"

wg genkey | tee "$key_dir/privatekey" | wg pubkey > "$key_dir/publickey"

chmod 600 "$key_dir/privatekey"
chmod 644 "$key_dir/publickey"

private_key=$(cat "$key_dir/privatekey")
public_key=$(cat "$key_dir/publickey")

echo "Public Key gerada:"
cat "$key_dir/publickey"

#########
default_interface=route | grep '^default' | grep -o '[^ ]*$'

cd /etc/wireguard/; mkdir ${interface_name}.conf
