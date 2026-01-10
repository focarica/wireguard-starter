#!/bin/bash

echo "#############################################"
echo "#     Assistente de Criação VPN - Server    #"
echo "#          Adicionando um novo peer         #"
echo "#############################################"
echo ""

# Mostra todos .conf criados
echo "Configurações encontradas em /etc/wireguard/:"
if ls /etc/wireguard/*.conf 1> /dev/null 2>&1; then
    ls /etc/wireguard/*.conf | xargs -n 1 basename -s .conf | sed 's/^/ - /'
else
    echo " Nenhuma configuração encontrada."
    exit 1
fi
echo ""

echo "Para qual interface deseja adicionar um novo cliente? "
read vpn_interface_name

config_path="/etc/wireguard/${vpn_interface_name}.conf"

if [[ ! -f "$config_path" ]]; then
    echo ""
    echo "ERRO CRÍTICO: O arquivo de configuração '$config_path' não existe."
    echo "Verifique o nome da interface e tente novamente."
    exit 1
fi

echo "Chave PUBLICA do cliente: "
read public_key_peer
if [[ -z "$public_key_peer" ]]; then
    echo "Erro: A chave pública é obrigatória."
    exit 1
fi

echo "IPs permitidos (AllowedIPs) ex: 10.0.0.2/32: "
read allowed_ips
if [[ -z "$allowed_ips" ]]; then
    echo "Erro: O IP permitido é obrigatório."
    exit 1
fi

echo "" >> "${config_path}"
cat << EOF >> ${config_path}
[Peer]
PublicKey = ${public_key_peer}
AllowedIPs = ${allowed_ips}
EOF

echo ""
echo "Novo cliente adicionado com sucesso!"
echo "----------------------------------------------------"
cat "$config_path"
echo "----------------------------------------------------"