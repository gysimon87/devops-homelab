# Linux Networking and Firewall

## 1. Objective

The goal of this lab was to understand Linux network configuration, IP addressing, routing, DNS resolution, network sockets, SSH connectivity, and basic firewall management.

The exercises were performed on an Ubuntu Server virtual machine running in Oracle VirtualBox.

## 2. Lab Environment

- Operating System: Ubuntu Server
- Hostname: ubuntu-server-01
- Hypervisor: Oracle VirtualBox
- Host OS: Windows 11
- Network adapters: NAT and Host-only

## 3. Network Interface Configuration

The virtual machine uses two network interfaces.

| Interface | Network Mode | IP Address | Purpose |
|---|---|---|---|
| enp0s3 | NAT | 10.0.2.15/24 | Internet connectivity |
| enp0s8 | Host-only | 192.168.56.101/24 | Host-to-VM communication |

The interfaces were inspected using:

`bash: ip -br addr`

The `-br` option displays network information in a brief format.

### NAT

The NAT adapter provides internet connectivity through VirtualBox.

The default gateway is:

`10.0.2.2`

### Host-only

The Host-only adapter allows communication between the host computer and the virtual machine through a separate virtual network.

The VM uses the following address:

`192.168.56.101`

## 4. IP Routing

The routing table was inspected using:

`bash: ip route`

The default route is:

`default via 10.0.2.2 dev enp0s3`

This means that traffic without a more specific matching route is forwarded through the NAT interface.

The Host-only network has a directly connected route:

`192.168.56.0/24 dev enp0s8`

### Route Verification

The `ip route get` command was used to determine which interface and gateway Linux selects for a destination.

Examples:

```
bash:
ip route get 8.8.8.8
ip route get 192.168.56.1
```

Observed behavior:

- Internet traffic uses enp0s3.
- Host-only network traffic uses enp0s8.

This demonstrates the longest prefix match routing principle: Linux selects the most specific matching route.

## 5. Network Connectivity Testing

Connectivity was tested using ICMP ping.

```
bash:
ping -c 4 8.8.8.8
ping -c 4 google.com
```

The `-c 4` option limits the test to four packets.

Both tests completed successfully with no packet loss.

The first test verified IP connectivity.

The second test also verified that the hostname could be resolved through DNS.

## 6. DNS Resolution

DNS configuration was inspected using:

`bash: resolvectl status`

The active DNS server was:

`192.168.64.1`

This address is provided by the VirtualBox NAT networking environment.

DNS resolution was tested using:

`bash: resolvectl query google.com`

The response contained both IPv4 and IPv6 addresses.

- A records provide IPv4 addresses.
- AAAA records provide IPv6 addresses.

Ubuntu uses systemd-resolved for DNS resolution.

The local DNS stub resolver listens on loopback addresses, including 127.0.0.53 and 127.0.0.54.

## 7. Network Socket Inspection

Listening sockets and active network connections were inspected using `ss`.

`bash: sudo ss -tulpn`

Important options:

- `-t`: display TCP sockets.
- `-u`: display UDP sockets.
- `-l`: display listening sockets.
- `-p`: show associated processes.
- `-n`: display numerical addresses and port numbers.

The following services were observed:

| Service | Protocol | Port | Purpose |
|---|---|---|---|
| SSH | TCP | 22 | Remote administration |
| systemd-resolved | TCP/UDP | 53 | DNS resolution |
| systemd-networkd | UDP | 68 | DHCP client |

Active TCP connections were inspected using:

`bash: sudo ss -tnp`

The `-n` option prevents name and service resolution, while `-p` displays process information.

Additional socket and process information was inspected using:

```
bash:
sudo lsof -i :22
sudo lsof -i :53
```

This helped identify which processes were using the SSH and DNS ports.

## 8. Firewall Configuration with UFW

The Uncomplicated Firewall (UFW) was configured to provide basic host-level traffic filtering.

Before enabling the firewall, SSH access was explicitly allowed:

`bash: sudo ufw allow 22/tcp`

The firewall was enabled using:

`bash: sudo ufw enable`

Its configuration was verified using:

`bash: sudo ufw status verbose`

### Active Firewall Policy

| Setting | Configuration |
|---|---|
| Firewall status | Active |
| Default incoming policy | Deny |
| Default outgoing policy | Allow |
| Default routed policy | Disabled |
| SSH TCP port 22 | Allowed |
| Logging | Enabled, low level |

The SSH rule is applied to both IPv4 and IPv6.

### Understanding the Firewall Rules

The default incoming deny policy blocks incoming traffic unless an explicit rule allows it.

The SSH rule allows incoming TCP connections on port 22.

The default outgoing allow policy permits outbound connections initiated by the server.

The firewall configuration was applied successfully without losing the existing SSH connection.

## 9. Firewall Logging

UFW logging was enabled with low verbosity.

Firewall-related kernel messages can be inspected using:

`bash: sudo journalctl -k --grep='UFW'`

The `-k` option selects kernel messages.

The `--grep` option filters messages containing the specified text.

Not every firewall event necessarily produces a log entry. Logging depends on the configured verbosity and whether matching traffic occurs.

## 10. Key Learnings

During this lab, I practiced and verified:

- Inspecting Linux network interfaces.
- Understanding NAT and Host-only networking.
- Reading and interpreting the routing table.
- Understanding default routes and longest prefix matching.
- Testing IP connectivity using ping.
- Understanding DNS resolution and A/AAAA records.
- Inspecting listening sockets and active connections.
- Identifying processes using network ports.
- Configuring a host firewall with UFW.
- Allowing SSH access while enabling default incoming traffic restrictions.
- Inspecting firewall-related log messages.

## Conclusion

The Ubuntu Server networking environment was successfully inspected and verified.

The virtual machine uses NAT for internet access and Host-only networking for host communication.

DNS resolution, routing, SSH connectivity, and network sockets were examined.

UFW was enabled with a default-deny incoming policy, while SSH access remained available through an explicit firewall rule.

These exercises provided practical experience with Linux networking and basic server security.
