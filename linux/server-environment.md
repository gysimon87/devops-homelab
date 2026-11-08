Linux Server Environment

Overview

This document describes the Linux server environment used in my personal DevOps homelab.

The server runs as a virtual machine on Oracle VirtualBox and is used for practicing Linux system administration, networking, remote access, and automation.

Host Environment

Component	Configuration
Host OS	Windows 11
Hardware	HP EliteDesk 800 G4 DM
CPU	Intel Core i5-8500
RAM	16 GB DDR4
Hypervisor	Oracle VirtualBox

Virtual Machine

Component	Configuration
Hostname	ubuntu-server-01
Operating System	Ubuntu Server
Allocated Memory	4 GB
Network Interfaces	2
Remote Access	OpenSSH

Network Configuration

The virtual machine uses two network adapters:

Interface	Mode	IP Address	Purpose
enp0s3	NAT	10.0.2.15	Internet connectivity
enp0s8	Host-only	192.168.56.101	Host-to-VM communication

NAT

NAT provides internet access to the virtual machine through the host computer.

Host-only

Host-only networking allows communication between the Windows host and the virtual machine without exposing the VM directly to the physical network.

Remote Access

OpenSSH is installed and enabled.

SSH key-based authentication is configured and tested successfully from external client devices.

Password authentication remains enabled.

Storage

The root filesystem uses LVM.

| Component | Configuration |
|---|---|
| Root Logical Volume | 33 GB |
| Filesystem Used Space | Approximately 6.3 GB |
| Filesystem Available Space | Approximately 25 GB |
| Filesystem Utilization | Approximately 21% |

System Verification

The following commands are used to inspect the server configuration:

Command	Purpose
hostnamectl	Display system hostname and OS information
ip -br addr	Display network interfaces and IP addresses
ip route	Display routing table
free -h	Check memory usage
df -h /	Check root filesystem usage
systemctl status ssh	Check SSH service status

Current Status

* Ubuntu Server is operational.
* NAT and Host-only networking are configured.
* SSH remote access is working.
* Key-based authentication has been tested.
* Basic system administration exercises have been completed.

Next Steps

* Document process and service management.
* Document system logging and troubleshooting.
* Expand Bash scripting and automation exercises.
