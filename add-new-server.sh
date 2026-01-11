#!bin/bash

default_allowed_ips="0.0.0.0/0"

echo "##############################################"
echo "#     VPN Creation Assistant - Client        #"
echo "#         Adding a new server                #"
echo "##############################################"
echo ""

# Mostra todos .conf criados
echo "Configurations found in /etc/wireguard/:"
if ls /etc/wireguard/*.conf 1> /dev/null 2>&1; then
    ls /etc/wireguard/*.conf | xargs -n 1 basename -s .conf | sed 's/^/ - /'
else
    echo "No configurations found."
    exit 1
fi
echo ""

echo "Which interface do you want to add a new client to? "
read vpn_interface_name
if [[ -z $vpn_interface_name ]]; then
    echo "Error: VPN interface is required"
    exit 1
fi 

config_path="/etc/wireguard/${vpn_interface_name}.conf"

if [[ ! -f "$config_path" ]]; then
    echo ""
    echo "Error: The configuration file '$config_path' does not exist."
    echo "Check the interface name and try again."
    exit 1
fi

echo "Server PUBLIC key: "
read public_key_peer
if [[ -z "$public_key_peer" ]]; then
    echo "Error: Public key is required."
    exit 1
fi

echo "Server endpoint: "
read server_endpoint
if [[ -z "$server_endpoint" ]]; then
    echo "Error: Server endpoint is required."
    exit 1
fi

read -p "$(echo -e "AllowedIPs: [$default_allowed_ips]: ")" allowed_ips 
allowed_ips=${allowed_ips:-default_allowed_ips}

echo "" >> "${config_path}"
cat << EOF >> ${config_path}
[Peer]
PublicKey = ${public_key_peer}
Endpoint = ${server_endpoint}

AllowedIPs = ${allowed_ips}
PersistentKeepalive = 15
EOF

echo ""
echo "New Server added successfully!"
echo "----------------------------------------------------"
tail -n 5 "$config_path"
echo "----------------------------------------------------"