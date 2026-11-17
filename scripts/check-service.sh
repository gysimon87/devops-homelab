#!/bin/bash

log_message() {
    echo "[INFO] $1"
}

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <hostname> <port>"
    exit 1
fi

HOSTNAME="$1"
PORT="$2"

check_port() {
	if [[ ! "$PORT" =~ ^[0-9]+$ ]]; then
		echo "Error: Port must contain only numbers."
		return 1
	fi

	if (( PORT < 1 || PORT > 65535 )); then
		echo "Invalid port"
		return 1
	fi
	return 0
}

if ! check_port; then
    exit 1
fi
log_message "Starting service check"
log_message "Checking host: $HOSTNAME"
log_message "Checking port: $PORT"
log_message "Service check completed"
