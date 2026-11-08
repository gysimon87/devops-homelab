# DevOps Homelab

Personal DevOps and Linux homelab projects, infrastructure configuration, and automation.

## Overview

This repository documents my personal DevOps and Linux homelab environment.

The main goal is to develop practical skills in Linux system administration, networking, scripting, automation, and infrastructure management through hands-on projects.

The environment is built using local virtualization and gradually expanded with additional DevOps tools and technologies.

## Lab Environment

| Component | Configuration |
|---|---|
| Host OS | Windows 11 |
| Hardware | HP EliteDesk 800 G4 DM |
| CPU | Intel Core i5-8500 |
| Memory | 16 GB DDR4 |
| Hypervisor | Oracle VirtualBox |
| Server OS | Ubuntu Server |
| Virtual Machine | ubuntu-server-01 |
| Memory Allocation | 4 GB |
| Network | NAT + Host-only |
| Remote Access | OpenSSH |

## Projects and Practical Exercises

### Linux System Administration

- Linux command-line fundamentals
- User and group management
- File permissions and ownership
- setgid and umask
- Process and service management
- System logs and troubleshooting
- Scheduled tasks with cron

### Networking and Security

- VirtualBox NAT and Host-only networking
- IP configuration and routing
- DNS resolution
- Network socket inspection
- Firewall configuration with UFW
- SSH remote access

### Scripting and Automation

- Bash scripting
- File and directory checks
- HTTP health checks
- System health checks
- Task automation

### Cloud and DevOps

Planned learning areas:

- Python scripting
- Git and version control
- Infrastructure as Code (Terraform / OpenTofu)
- Configuration management with Ansible
- Docker and containerization
- Kubernetes
- CI/CD pipelines
- Cloud infrastructure

## Documentation

Detailed documentation of completed exercises:

| Document | Description |
|---|---|
| [Server Environment](linux/server-environment.md) | Lab infrastructure and server configuration |
| [Users, Groups and Permissions](linux/users-groups-permissions.md) | Linux user management, permissions, setgid and umask |
| [Networking and Firewall](linux/networking-and-firewall.md) | Network interfaces, routing, DNS, sockets and UFW |

Each document includes objectives, implementation details, verification procedures, and lessons learned.

## Learning Objectives

- Strengthen Linux system administration skills.
- Understand networking and server infrastructure.
- Develop Bash and Python scripting skills.
- Learn Infrastructure as Code (IaC).
- Gain practical experience with Ansible, Docker, and Kubernetes.
- Build and document reproducible infrastructure projects.

## Status

This is an ongoing learning project.

New technologies, configurations, and practical exercises will be added as the lab evolves.
