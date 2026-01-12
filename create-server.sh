#!/bin/bash

default_interface=$(ip route get 8.8.8.8 | awk -- '{print $5}')
default_ip="10.0.0.1/24"
default_port="51820"
default_allow_ipv4_forward="Y"


echo "#############################################"
echo "#     VPN Creation Assistant - Server       #"
echo "#############################################"
echo ""

echo "Enter a name for the network interface: "
read vpn_interface_name
echo ""

# Criacao de chaves
source ./key-gen.sh "${vpn_interface_name}" 


cd /etc/wireguard/; touch ${vpn_interface_name}.conf

echo ""
read -p "$(echo -e "Virtual IP Address [${default_ip}]: ")" vpn_server_ip
vpn_server_ip=${vpn_server_ip:-$default_ip}

read -p "$(echo -e "Listening Port [${default_port}]: ")" vpn_server_port
vpn_server_port=${vpn_server_port:-$default_port}

config_path="/etc/wireguard/${vpn_interface_name}.conf"

# Criacao da base inicial
cat << EOF > "$config_path"
[Interface]
PrivateKey = ${private_key}
ListenPort = ${vpn_server_port}
Address = ${vpn_server_ip}

PostUp = iptables -A FORWARD -i ${vpn_interface_name} -j ACCEPT; iptables -t nat -A POSTROUTING -o ${default_interface} -j MASQUERADE
PostDown = iptables -D FORWARD -i ${vpn_interface_name} -j ACCEPT; iptables -t nat -D POSTROUTING -o ${default_interface}  -j MASQUERADE
EOF

chmod 600 "$config_path"


read -p "Allow the server to forward packets now (required for proper routing)? [Y/n]: " ipv4_forward_answer
ipv4_forward_answer="${ipv4_forward_answer:-$default_allow_ipv4_forward}"

case "$ipv4_forward_answer" in
    [Yy])
        echo "Enabling IPv4 forwarding..."

        sysctl -w net.ipv4.ip_forward=1 >/dev/null

        if grep -q "^net.ipv4.ip_forward" /etc/sysctl.conf; then
            sed -i 's/^net.ipv4.ip_forward=.*/net.ipv4.ip_forward=1/' /etc/sysctl.conf
        else
            echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
        fi

        echo "IPv4 forwarding enabled successfully."
        ;;
    [Nn])
        echo "You chose NOT to enable packet forwarding now."
        echo "The VPN will not route traffic until you enable it."
        ;;
    *)
        echo "Invalid option. Please answer Y or N."
        ;;
esac

echo ""
echo "Configuration created successfully!"
echo "----------------------------------------------------"
cat "$config_path"
echo "----------------------------------------------------"