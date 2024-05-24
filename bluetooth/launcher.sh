#!/bin/bash

dir=$ROFI_ENV_DIR

# Function to list paired Bluetooth devices
list_devices() {
	echo -e "devices" | bluetoothctl | grep Device | cut -d ' ' -f 3- | sort -u
}

# Use Rofi to select a Bluetooth device
selected_device=$(list_devices | rofi -dmenu -i -p "󰂯" -matching fuzzy -no-custom -theme ${dir}/style/search-icon-name.rasi)

if [ -z "$selected_device" ]; then
	echo "No device selected."
	exit 1
fi

# Extract MAC address and Name
device_name=$(echo "$selected_device" | cut -d ' ' -f 1-)
device_mac=$(bluetoothctl devices | grep "Jabra" | awk '{print $2}')

echo $device_mac

# Function to check connection status
is_connected() {
	echo -e "info $1" | bluetoothctl | grep "Connected: yes"
}

# TODO: Prompt connection for unknown devices
# TODO: Seek for devices nearby to pair a new device (Perhaps in a separated launcher?)

# Connect or Disconnect based on current status
if is_connected "$device_mac"; then
	echo "Disconnecting from $device_name..."
	echo -e "disconnect $device_mac" | bluetoothctl
else
	echo "Connecting to $device_name..."
	echo -e "connect $device_mac" | bluetoothctl
fi
