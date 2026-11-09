Linux Process and Service Management

1. Overview

This document covers basic Linux process management, systemd service management, and system logging using journalctl.

The practical exercises were performed on an Ubuntu Server virtual machine running in VirtualBox.

Topics covered:

* Listing and inspecting processes
* Understanding process relationships
* Managing systemd services and sockets
* Inspecting service dependencies
* Reading and filtering system logs
* Creating custom systemd services
* Understanding service types and restart policies
* Testing automatic service recovery

2. Process Management

2.1 Listing processes

The ps command displays information about running processes.

ps -eo pid,ppid,stat,%cpu,%mem,comm --sort=-%cpu | head -n 15

Options:

* -e: Select all processes.
* -o: Define the output columns.
* pid: Process ID.
* ppid: Parent Process ID.
* stat: Process state.
* %cpu: CPU usage.
* %mem: Memory usage.
* comm: Command name.
* --sort=-%cpu: Sort by CPU usage in descending order.
* head -n 15: Display the first 15 lines.

2.2 Understanding process states

Common process states shown in the STAT column:

State	Meaning
R	Running or runnable
S	Interruptible sleep
D	Uninterruptible sleep
T	Stopped
Z	Zombie
I	Idle kernel thread

Additional characters may provide further information:

* s: Session leader.
* l: Multithreaded process.
* +: Process belongs to the foreground process group.

Process state is useful when investigating resource usage or processes that appear to be stuck.

2.3 Process hierarchy

The pstree command displays processes as a parent-child hierarchy.

pstree -p

The -p option displays process IDs.

A typical SSH session may have a hierarchy similar to:

systemd(1)
  └─sshd
      └─sshd
          └─bash
              └─zsh
                  └─command

This illustrates how a user shell and commands started inside it are related to the SSH daemon.

Understanding parent-child relationships helps when investigating how processes were started and which service manages them.

3. systemd Service Management

3.1 Checking service status

systemctl is the primary command-line tool for managing systemd units.

sudo systemctl status ssh.service

Important fields:

* Loaded: Unit file location and loading state.
* enabled: Whether the service is configured to start automatically.
* Active: Current runtime state.
* Main PID: Main process ID.
* Tasks: Number of processes and threads associated with the service.
* Memory: Reported memory usage.
* CGroup: Control group containing the service processes.

Common service states:

State	Meaning
active (running)	Service is running
active (exited)	Service completed successfully but remains logically active
inactive (dead)	Service is not running
failed	Service terminated unsuccessfully or failed to start

3.2 Service commands

sudo systemctl start example.service
sudo systemctl stop example.service
sudo systemctl restart example.service
sudo systemctl enable example.service
sudo systemctl disable example.service

* start: Start a service.
* stop: Stop a service.
* restart: Restart a service.
* enable: Configure automatic startup during boot.
* disable: Remove automatic startup configuration.

Important distinction:

* enabled does not mean that a service is currently running.
* active does not mean that a service is enabled for automatic startup.

Check these states separately:

systemctl is-enabled example.service
systemctl is-active example.service

3.3 Inspecting unit files

systemctl cat ssh.socket

This displays the unit file and its configuration.

Common sections:

* [Unit]: General unit information and dependencies.
* [Socket]: Socket-specific configuration.
* [Service]: Service execution settings.
* [Install]: Installation and startup relationships.

3.4 Socket activation

Some services use systemd socket activation.

For example:

sudo systemctl status ssh.socket
sudo systemctl status ssh.service

The SSH socket listens for incoming connections and can trigger the SSH service.

Inspect the socket configuration:

systemctl cat ssh.socket

Important directives:

* ListenStream: Defines a stream socket, commonly TCP.
* ListenDatagram: Defines a datagram socket, commonly UDP.
* Accept=no: The service handles incoming connections rather than systemd creating a separate service instance for each connection.
* WantedBy: Defines the target that pulls in the unit when enabled.
* RequiredBy: Defines a required relationship from another unit.

A socket unit and its corresponding service are separate systemd units.

3.5 Inspecting dependencies

systemctl list-dependencies ssh.service

This displays the dependency hierarchy of a unit.

Common dependency relationships include:

* Requires: Strong dependency.
* Wants: Weaker dependency.
* After: Ordering relationship.
* Before: Reverse ordering relationship.
* Conflicts: Units that cannot be active together.

The dependency tree can contain indirect dependencies inherited through other units and targets. Not every displayed unit is necessarily a direct dependency.

4. System Logging with journalctl

journalctl is used to query logs collected by systemd-journald.

4.1 Displaying service logs

sudo journalctl -u ssh.service

Useful options:

Option	Description
-u	Filter by unit
-n 20	Show the latest 20 entries
-f	Follow new log entries
-b	Show logs from the current boot
-b -1	Show logs from the previous boot
--since	Set the beginning of the time range
--until	Set the end of the time range
-p err	Filter by error priority
--no-pager	Print output directly
-o verbose	Display detailed journal fields
-o short-monotonic	Display monotonic timestamps

Examples:

sudo journalctl -u ssh.service -n 20 --no-pager
sudo journalctl -u ssh.service -f
sudo journalctl -p err -b --no-pager
sudo journalctl -b -1

4.2 Searching for specific events

The --grep option filters messages using a regular expression.

sudo journalctl -u ssh.service --grep="Failed password" --no-pager

This is useful when investigating authentication failures or other specific events.

For detailed metadata:

sudo journalctl -u ssh.service -o verbose

Useful fields include:

* _BOOT_ID: Identifier of the boot session.
* _SYSTEMD_UNIT: Associated systemd unit.
* _CMDLINE: Process command line.
* MESSAGE: Log message.

4.3 Understanding boot sessions

sudo journalctl -b -1

The -b -1 option displays the previous boot session, not just the boot sequence itself.

A boot session includes all available journal entries from that session.

4.4 Monotonic timestamps

sudo journalctl -u devops-lab-loop.service -n 10 -o short-monotonic --no-pager

Monotonic timestamps represent elapsed time since the current boot.

They are useful when investigating timing differences because they are not affected by changes to the system’s calendar clock in the same way as ordinary timestamps.

5. Creating a Custom systemd Service

A custom service was created to understand how systemd executes and manages processes.

5.1 Creating the script

Location:

/srv/devops-lab/scripts/service-demo.sh

Script:

#!/bin/bash
LOG_FILE="/var/log/devops-lab-service.log"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Demo service executed" >> "$LOG_FILE"

The script writes a timestamped entry to a log file.

5.2 Creating the oneshot unit

Location:

/usr/local/lib/systemd/system/devops-lab-demo.service

Configuration:

[Unit]
Description=DevOps Lab Demo Service
After=local-fs.target
[Service]
Type=oneshot
ExecStart=/bin/bash /srv/devops-lab/scripts/service-demo.sh
User=root
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target

Important directives:

* Description: Human-readable service description.
* After: Defines startup ordering.
* Type=oneshot: Runs a short-lived task and waits for it to finish.
* ExecStart: Command executed when the service starts.
* User: User account used to execute the command.
* RemainAfterExit=yes: Keeps the unit logically active after the command exits.
* WantedBy: Defines the target used for automatic startup when enabled.

5.3 Validating and loading the unit

sudo systemd-analyze verify /usr/local/lib/systemd/system/devops-lab-demo.service
sudo systemctl daemon-reload

* systemd-analyze verify checks the unit configuration.
* daemon-reload makes systemd reload unit definitions.

5.4 Understanding oneshot service states

Without RemainAfterExit=yes, a successful oneshot service normally returns to:

inactive (dead)

With RemainAfterExit=yes, it remains:

active (exited)

This does not mean that the original process is still running. It means systemd considers the completed task active.

5.5 Masking and unmasking

sudo systemctl mask devops-lab-demo.service
sudo systemctl unmask devops-lab-demo.service

Masking prevents a unit from being started, including through dependencies.

Systemd normally creates a symbolic link to /dev/null at the unit’s name.

A unit file located at the same path prevents this link from being created. In the lab, the unit file was moved to /usr/local/lib/systemd/system/ before masking.

Important distinction:

* disable removes automatic startup configuration.
* mask prevents the unit from being started.
* unmask removes the mask.
* unmask does not enable the service.

6. Creating a Long-Running Service

A second service was created to demonstrate a continuously running process.

6.1 Service script

Location:

/srv/devops-lab/scripts/service-demo-loop.sh
#!/bin/basha
while true
do
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Demo service is running"
    sleep 30
done

The script runs indefinitely and writes messages to standard output.

6.2 Service unit

Location:

/usr/local/lib/systemd/system/devops-lab-loop.service
[Unit]
Description=DevOps Lab Continuous Demo Service
After=local-fs.target
[Service]
Type=simple
ExecStart=/bin/bash /srv/devops-lab/scripts/service-demo-loop.sh
User=root
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target

Important directives:

* Type=simple: The process started by ExecStart is considered the main service process.
* ExecStart: Starts the Bash script.
* Restart=on-failure: Restarts the service after an unexpected failure.
* RestartSec=5: Waits five seconds before attempting a restart.

6.3 Process hierarchy and CGroup

After starting the service:

sudo systemctl start devops-lab-loop.service
sudo systemctl status devops-lab-loop.service

The service status showed a process hierarchy similar to:

CGroup:
  ├─bash
  └─sleep

The Bash script is the main process, while sleep is its child process.

Systemd uses control groups (CGroups) to track and manage processes belonging to a service.

6.4 Logging through standard output

The script writes messages to standard output instead of a separate log file.

Systemd captures the output and makes it available through journald.

sudo journalctl -u devops-lab-loop.service -f

This follows new log entries in real time.

Standard output (stdout) and standard error (stderr) are separate output streams. Both can be captured by journald.

7. Testing Automatic Service Restart

The restart policy was tested by modifying the script to exit with a non-zero status after three iterations.

Test script:

#!/bin/bash
COUNT=0
while true
do
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Demo service is running"
    sleep 10
    ((COUNT++))
    if [ "$COUNT" -ge 3 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Simulated service failure" >&2
        exit 1
    fi
done

After modifying the script, the service had to be restarted to execute the updated version.

sudo systemctl restart devops-lab-loop.service
sudo journalctl -u devops-lab-loop.service -f

Expected behavior:

1. The script starts.
2. It executes three iterations.
3. It prints a simulated failure message to standard error.
4. It exits with status code 1.
5. Systemd detects the failure.
6. Restart=on-failure schedules a restart.
7. The service starts again after the configured delay.

Relevant journal messages:

Main process exited, code=exited, status=1/FAILURE
Failed with result 'exit-code'.
Scheduled restart job
Started DevOps Lab Continuous Demo Service.

The test confirmed that systemd can automatically restart a service after an unexpected process failure.

The service was stopped manually after the test:

sudo systemctl stop devops-lab-loop.service

A manual stop does not trigger the configured automatic restart policy.

8. Useful Diagnostic Commands

Command	Purpose
ps -eo pid,ppid,stat,%cpu,%mem,comm	List processes
pstree -p	Display process hierarchy
systemctl status SERVICE	Inspect service status
systemctl cat UNIT	Display unit configuration
systemctl list-dependencies UNIT	Inspect unit dependencies
systemctl list-units --type=socket --all	List socket units
systemctl list-unit-files --type=socket	List installed socket unit files
systemctl show SERVICE	Display service properties
systemd-analyze verify FILE	Validate a unit file
journalctl -u SERVICE	Read service logs
journalctl -p err -b	Show current boot errors
journalctl -f	Follow new journal entries

9. Key Takeaways

* Linux processes form parent-child relationships.
* PID and PPID help identify process ownership and hierarchy.
* Process states provide useful information during troubleshooting.
* systemd manages services, sockets, dependencies, and service lifecycles.
* A service being enabled does not mean it is currently running.
* Socket activation allows systemd to start services when a connection arrives.
* journald provides centralized logging and filtering.
* Monotonic timestamps help investigate timing behavior.
* Type=oneshot is suitable for short-lived tasks.
* Type=simple is suitable for continuously running processes.
* CGroups allow systemd to track processes belonging to a service.
* Restart=on-failure can automatically recover a service after an unexpected failure.
* Manual service stops do not trigger automatic restart policies.

The goal of these exercises was to understand the basic behavior of Linux processes and systemd services, and to develop a foundation for troubleshooting real-world Linux environments.
