Linux Package Management

Overview

This document covers package management on Ubuntu Server and Termux, including package repositories, package installation, package inspection, dependencies, package removal, upgrades, and package integrity checks.

The practical exercises were performed on:

* Ubuntu Server 24.04 LTS (Noble)
* Termux on Android (aarch64)

Both environments use APT and DPKG as their underlying package management tools, but they differ significantly in their operating system environment and package configuration.

⸻

1. APT and DPKG

APT (Advanced Package Tool) manages software packages and resolves dependencies.

DPKG is the lower-level Debian package management system responsible for installing, removing, and querying individual .deb packages.

The relationship between them:

* APT handles repositories, package downloads, and dependency resolution.
* DPKG performs the actual installation and removal of Debian packages.
* APT uses DPKG to manage locally installed packages.

Important APT commands

Command	Description
sudo apt update	Refresh package repository metadata
sudo apt upgrade	Upgrade installed packages
sudo apt full-upgrade	Upgrade packages and handle dependency changes, including removals if required
apt search PACKAGE	Search for packages
apt show PACKAGE	Display package information
sudo apt install PACKAGE	Install a package
sudo apt remove PACKAGE	Remove a package but retain configuration files
sudo apt purge PACKAGE	Remove a package and its package-managed configuration files
sudo apt autoremove	Remove automatically installed packages that are no longer required
apt list --installed	List installed packages
apt list --upgradable	List packages with available upgrades

⸻

2. Updating Package Repository Metadata

Before upgrading installed software, refresh the local package index:

sudo apt update

This operation downloads updated repository metadata. It does not upgrade installed packages.

To check which packages can be upgraded:

apt list --upgradable

This makes it possible to review available updates before applying them.

Important distinction

* apt update refreshes package metadata.
* apt upgrade upgrades installed packages.
* apt full-upgrade can also remove packages if required to resolve dependency changes.

⸻

3. Package Information and Inspection

APT and DPKG provide different levels of package information.

Display package information

apt show htop

Displays information such as:

* Package version
* Architecture
* Dependencies
* Description
* Package size
* Repository information

Inspect the installed package state

dpkg -s htop

The output includes the package status, version, architecture, and dependencies.

Example status:

Status: install ok installed

List files installed by a package

dpkg -L htop

This lists files belonging to the installed package.

Identify which package owns a file

dpkg -S /usr/bin/htop

This identifies the package that owns the specified file.

Check package repository and version information

apt-cache policy htop

This displays the installed version, candidate version, and available repository versions.

Check manually installed packages

apt-mark showmanual htop

This can be used to determine whether a package is marked as manually installed.

⸻

4. Package Search and Dependencies

Search for a package

apt search htop

Display package dependencies

apt depends htop

This displays required dependencies and other dependency relationships.

APT distinguishes between mandatory dependencies and optional recommendations or suggestions.

Dependency inspection

The following commands are useful when investigating package relationships:

apt show htop
apt depends htop
apt-cache depends htop

A package may be required by another installed package even when it appears to be an ordinary application.

Example: htop and ubuntu-server

During the practical exercise, the following command was used:

apt remove --simulate htop

APT planned to remove both:

* htop
* ubuntu-server

The reason was that the ubuntu-server metapackage depends on htop.

This demonstrates why package removal should always be reviewed before execution.

⸻

5. Simulating Package Operations

APT supports simulation mode, which allows operations to be reviewed without making changes.

Simulate package removal

sudo apt remove --simulate htop

Simulate package purge

sudo apt purge --simulate htop

Simulate automatic package cleanup

sudo apt autoremove --simulate

Simulate a normal upgrade

sudo apt upgrade --simulate

Simulate a full upgrade

sudo apt full-upgrade --simulate

Simulation is particularly useful on servers because it allows potential package removals and dependency changes to be reviewed before execution.

Important: --simulate does not perform the requested package operation.

⸻

6. Remove vs Purge vs Autoremove

These operations have different purposes.

Remove

sudo apt remove PACKAGE

Removes the package but generally retains package-managed configuration files.

Purge

sudo apt purge PACKAGE

Removes the package and its package-managed configuration files.

It does not automatically remove every file an application may have created in the user’s home directory or elsewhere.

Autoremove

sudo apt autoremove

Removes packages that were automatically installed as dependencies and are no longer required.

Before executing:

sudo apt autoremove --simulate

Important distinction

autoremove does not simply remove every package that is not currently being used.

APT uses its installation and dependency tracking information to determine which automatically installed packages are no longer required.

⸻

7. Package Status and Integrity Checks

DPKG maintains information about installed packages and their installation states.

List installed packages

dpkg -l

The first two characters in the status column describe the desired and current package states.

Common examples:

* ii: package is installed and configured.
* rc: package has been removed but configuration files remain.

Display package configuration remnants

dpkg -l | awk '$1 == "rc" {print $2, $3}'

This filters packages in the rc state.

Check for incomplete or problematic package states

sudo dpkg --audit

This checks for partially installed or otherwise problematic package states.

Check package dependencies

sudo apt-get check

This checks whether package dependencies are satisfied.

Note: apt check is not a valid APT operation. The correct command is apt-get check.

⸻

8. Upgrading Ubuntu Server

Before upgrading, review the available updates:

sudo apt update
apt list --upgradable

Simulate the upgrade:

sudo apt upgrade --simulate

If the proposed changes are acceptable:

sudo apt upgrade

After the upgrade, check whether a reboot is required:

ls -l /var/run/reboot-required*

The files may not exist if no reboot is currently required.

Check the running kernel:

uname -r

After a kernel upgrade, the newly installed kernel is not active until the system boots with it.

Practical upgrade exercise

On the Ubuntu Server lab VM:

* 15 installed packages were upgraded.
* 7 additional packages were installed.
* The additional packages included components for kernel version 6.8.0-149.
* The previous running kernel was 6.8.0-147-generic.
* After reboot, the active kernel was 6.8.0-149-generic.

The upgrade completed successfully.

A boot issue occurred during the subsequent restart. It was investigated separately as a VirtualBox lab environment issue.

⸻

9. Termux Package Management

Termux runs on Android and provides a Linux-like command-line environment.

It uses APT and DPKG internally, while pkg provides additional convenience commands and Termux-specific behavior.

Common Termux commands

Termux command	Purpose
pkg update	Refresh package metadata
pkg upgrade	Upgrade installed packages
pkg install PACKAGE	Install a package
pkg uninstall PACKAGE	Uninstall a package
pkg search PACKAGE	Search for packages
pkg show PACKAGE	Display package information
pkg list-installed	List installed packages

Equivalent APT commands can also be used for many package management operations.

Example: installing htop

pkg update
pkg search htop
pkg install htop

Verify the installation:

dpkg -s htop

Inspect installed files:

dpkg -L htop

Run the application:

htop

Termux environment differences

Termux does not run a conventional Linux distribution with its own Linux kernel.

Instead:

* Android provides the Linux kernel.
* Termux applications run inside the Android application sandbox.
* Termux uses its own filesystem prefix.
* The default prefix is typically /data/data/com.termux/files/usr.
* System services are not managed by systemd.

For this reason, Linux server administration commands and service management workflows cannot always be transferred directly to Termux.

⸻

10. Ubuntu Server vs Termux

Feature	Ubuntu Server	Termux
Package management	APT / DPKG	APT / DPKG
Convenience interface	APT	pkg
Architecture in the lab	amd64	aarch64
Kernel	Linux kernel	Android host kernel
Init system	systemd	No systemd
Filesystem layout	Standard Linux hierarchy	Termux-specific prefix
Typical use	Server and infrastructure workloads	Command-line tools on Android

The package management foundations are similar, but the operating environments are fundamentally different.

⸻

11. Useful Troubleshooting Commands

Command	Purpose
apt list --upgradable	Check available upgrades
apt-cache policy PACKAGE	Inspect package versions and repositories
dpkg -s PACKAGE	Inspect installed package status
dpkg -L PACKAGE	List package files
dpkg -S FILE	Identify the owning package
sudo dpkg --audit	Check package database state
sudo apt-get check	Check package dependencies
sudo apt autoremove --simulate	Review unnecessary dependency cleanup
uname -r	Display the running kernel version

⸻

12. Key Takeaways

* APT manages package repositories, downloads, and dependency resolution.
* DPKG manages individual Debian packages and their installation states.
* apt update does not upgrade installed software.
* apt upgrade can install additional dependency packages without removing existing packages.
* apt full-upgrade may remove packages when necessary to resolve dependency changes.
* Always inspect simulated package operations before making potentially disruptive changes.
* remove, purge, and autoremove serve different purposes.
* A package can be required by a metapackage even if it appears unnecessary.
* Kernel upgrades require a reboot before the new kernel becomes active.
* Termux uses the same underlying package management foundations but operates within Android’s environment.

Package management is an essential part of Linux system administration and provides the foundation for maintaining reliable and up-to-date infrastructure.
