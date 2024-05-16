#!/bin/bash

dir="$ROFI_ENV_DIR"

list_networks() {
	nmcli --fields SSID,SIGNAL,BARS,SECURITY,IN-USE dev wifi list | awk 'NR>1 && !seen[$1]++'
}

# Preload wifi networks to load rofi a bit faster
nmcli device wifi rescan

#
selected_network=$(list_networks | rofi -dmenu -i -p "" -matching fuzzy -no-custom -theme ${dir}/style/search-icon-name.rasi)

# Get SSID of the selected network
selected_ssid=$(echo "$selected_network" | awk '{print $1}')
uuid=$(nmcli -t -f NAME,UUID con show | grep "$selected_ssid" | cut -d':' -f2)

# If no network is selected, exit
[ -z "$selected_ssid" ] && exit 1

# Check if the network requires a password
security=$(echo "$selected_network" | awk '{print $4}')

echo $security
echo $selected_ssid

if [ ! -z "$uuid" ]; then
	# Check if there is a password for this UUID
	password_field=$(nmcli -s -g 802-11-wireless-security.psk connection show "$uuid")

	if [ ! -z "$password_field" ]; then
		echo "Password is already saved for $selected_ssid."
		nmcli device wifi connect "$selected_ssid"
	else
		echo "No password saved for $selected_ssid. Prompt for password."
		# Prompt for the password using Rofi
		wifi_password=$(rofi -dmenu -password -p "Password: " -no-custom)
		# Use the password to connect or update the connection
	fi
else
	echo "else"
	wifi_password=$(rofi -dmenu -password -p "Password: " -no-custom)
	# Connect to the network
	nmcli dev wifi connect "$selected_ssid" password "$wifi_password"

fi

# Notify the user
notify-send "Connected to $selected_ssid"
