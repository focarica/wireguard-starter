# wireguard-starter
Bash script to quickly create and manage a basic WireGuard VPN setup.

This project provides an interactive CLI that helps you:
- Create a WireGuard server configuration
- Create a WireGuard client configuration
- Add new clients to an existing server
- Add new servers to an existing client

The goal is to simplify the initial setup process while keeping everything transparent and close to the operating system and networking concepts.

This project is intended mainly for learning, lab environments, and small self-hosted setups. This is not a production-grade VPN manager or to ready to heavy use.


## Project Structure

- **startup.sh**  
  Entry point. Displays a menu and routes execution to the correct script.

- **create-server.sh**  
  Creates a new WireGuard server configuration and enables IPv4 forwarding if requested.

- **create-client.sh**  
  Creates a new WireGuard client configuration.

- **add-new-client.sh**  
  Adds a new client peer to an existing server configuration.

- **add-new-server.sh**  
  Adds a new server peer to an existing client configuration.

- **key-gen.sh**  
  Generates WireGuard public/private keys and exposes them to the caller script.

## How to Use

### Requirements

You must have the following installed:

- WireGuard (`wg`)
- iproute2 (`ip`)
- iptables
- Bash
- Root privileges

On most Linux distributions:

```bash
sudo apt install wireguard iproute2 iptables
```

### Running

Clone the repository and execute:

```bash
sudo ./startup.sh
```

All WireGuard configurations are created under:

`/etc/wireguard/`

**Important Notes**

    This project executes privileged system commands (iptables, sysctl, file system changes).

    Use only in controlled environments (VMs, lab machines, test servers).

    Do NOT commit generated keys or /etc/wireguard content to Git.

[Future Improvements](https://github.com/focarica/wireguard-starter/issues)
