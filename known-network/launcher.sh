#!/bin/bash

dir=$ROFI_ENV_DIR

# List all known networks
known_networks=$(nmcli connection show | awk '/wifi/ {print $1}' | sort | uniq)
# Display the list of known networks in rofi and get the user selection
selected_network=$(echo "$known_networks" | rofi -dmenu -i -p "" -matching fuzzy -no-custom -theme ${dir}/style/search-icon-name.rasi)
# If a network is selected, connect to it
if [ -n "$selected_network" ]; then
	nmcli connection up "$selected_network"
fi
