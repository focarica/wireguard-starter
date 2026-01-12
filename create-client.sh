#!/bin/bash

default_ip="10.0.0.100/24"

echo "#############################################"
echo "#     VPN Creation Assistant - Client       #"
echo "#############################################"
echo ""

echo "Enter a name for the network interface: "
read vpn_interface_name
echo ""

source ./key-gen.sh "${vpn_interface_name}"

cd /etc/wireguard/; touch ${vpn_interface_name}.conf

echo ""
read -p "$(echo -e "Virtual IP Address [${default_ip}]: ")" vpn_server_ip
vpn_server_ip=${vpn_server_ip:-$default_ip}

config_path="/etc/wireguard/${vpn_interface_name}.conf"

cat <<EOF > "$config_path"
[Interface]
Address = ${vpn_server_ip}
PrivateKey = ${private_key}
EOF

chmod 600 "$config_path"

echo ""
echo "Configuration created successfully!"
echo "----------------------------------------------------"
cat "$config_path"
echo "----------------------------------------------------"