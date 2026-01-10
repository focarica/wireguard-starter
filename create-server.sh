#!/bin/bash

default_interface=$(ip route get 8.8.8.8 | awk -- '{print $5}')
default_ip="10.0.0.1/24"
default_port="51820"


clear
echo "#############################################"
echo "#     Assistente de Criação VPN - Server    #"
echo "#############################################"
echo ""

echo "Defina um nome para a interface de rede: "
read vpn_interface_name
echo ""

# Criacao de chaves
source ./key-gen.sh "${vpn_interface_name}" 


cd /etc/wireguard/; touch ${vpn_interface_name}.conf

echo ""
read -p "$(echo -e "Endereço IP Virtual (CIDR) [${default_ip}]: ")" vpn_server_ip
vpn_server_ip=${vpn_server_ip:-$default_ip}

read -p "$(echo -e "Porta de escuta [${default_port}]: ")" vpn_server_port
vpn_server_port=${vpn_server_port:-$default_port}

config_path="/etc/wireguard/${vpn_interface_name}.conf"

# Criacao da base inicial
cat <<EOF > "$config_path"
[Interface]
PrivateKey = ${private_key}
ListenPort = ${vpn_server_port}
Address = ${vpn_server_ip}

PostUp = iptables -A FORWARD -i ${vpn_interface_name} -j ACCEPT; iptables -t nat -A POSTROUTING -o ${default_interface} -j MASQUERADE
PostDown = iptables -D FORWARD -i ${vpn_interface_name} -j ACCEPT; iptables -t nat -D POSTROUTING -o ${default_interface}  -j MASQUERADE
EOF

chmod 600 "$config_path"

echo ""
echo "Configuração criada com sucesso!"
echo "----------------------------------------------------"
cat "$config_path"
echo "----------------------------------------------------"