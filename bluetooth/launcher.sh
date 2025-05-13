#!/bin/bash

dir=$ROFI_ENV_DIR

# Function to scan for nearby Bluetooth devices
scan_devices() {
    echo -e "scan on" | bluetoothctl > /dev/null
    sleep 10
    echo -e "scan off" | bluetoothctl > /dev/null
    echo -e "devices" | bluetoothctl | grep Device | cut -d ' ' -f 3- | sort -u
}

# Use Rofi to select a Bluetooth device
selected_device=$(scan_devices | rofi -dmenu -i -p "󰂯" -matching fuzzy -theme ${dir}/style/search-icon-name.rasi)

if [ -z "$selected_device" ]; then
    echo "[RofiDE] No device selected."
    exit 1
fi

# Extract MAC address and Name
device_name=$(echo "$selected_device" | cut -d ' ' -f 2-)
device_mac=$(echo "$selected_device" | cut -d ' ' -f 1)

# Function to check if device is already paired
is_paired() {
    echo -e "paired-devices" | bluetoothctl | grep "$1" > /dev/null
}

# Function to check connection status
is_connected() {
    echo -e "info $1" | bluetoothctl | grep "Connected: yes" > /dev/null
}

# Pair and connect to device if not already paired
if ! is_paired "$device_mac"; then
    echo "Pairing with $device_name..."
    echo -e "pair $device_mac" | bluetoothctl
    echo -e "trust $device_mac" | bluetoothctl
fi

# Connect if not already connected
if ! is_connected "$device_mac"; then
    echo "Connecting to $device_name..."
    echo -e "connect $device_mac" | bluetoothctl
    notify-send "Bluetooth" "Connected to $device_name"
else
    echo "Disconnecting from $device_name..."
    echo -e "disconnect $device_mac" | bluetoothctl
    notify-send "Bluetooth" "Disconnected from $device_name"
fi
