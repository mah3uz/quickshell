#!/bin/env bash

if [ -z "$1" ]; then
	echo "usage: $0 network-interface" >&2
	echo "e.g. $0 eth0" >&2
	exit
fi

humanize_bytes() {
    local bytes="$1"
    if [[ -z "$bytes" || ! "$bytes" =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid input. Please provide a positive integer for bytes." >&2
        return 1
    fi
    numfmt --to=iec --format="%.1f" "$bytes"
}

while true; do
	R1=$(cat /sys/class/net/"$1"/statistics/rx_bytes)
	T1=$(cat /sys/class/net/"$1"/statistics/tx_bytes)
	sleep 1
	R2=$(cat /sys/class/net/"$1"/statistics/rx_bytes)
	T2=$(cat /sys/class/net/"$1"/statistics/tx_bytes)
	TBPS=$(expr "$T2" - "$T1")
	RBPS=$(expr "$R2" - "$R1")
	
	echo " $(humanize_bytes "$TBPS"): $(humanize_bytes "$RBPS")"
done

