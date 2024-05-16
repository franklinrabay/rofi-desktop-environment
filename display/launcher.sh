#!/bin/bash

# TEMP: This will be moved to .config
dir="$ROFI_ENV_DIR"

# Function to list connected displays and their resolutions
list_resolutions() {
	xrandr | grep ' connected' | while read line; do
		display=$(echo $line | awk '{print $1}')
		resolutions=$(xrandr | grep "^   " | awk '{print $1}')
		for res in $resolutions; do
			echo "$display $res"
		done
	done
}

# Use Rofi to select a display and resolution
selected_option=$(list_resolutions | rofi -dmenu -i -p "Select Display and Resolution:" -matching fuzzy -no-custom -theme ${dir}/style/search-icon-name.rasi)

# Check if user made a selection
if [ -z "$selected_option" ]; then
	echo "No selection made."
	exit 1
fi

# Extract display and resolution
selected_display=$(echo "$selected_option" | awk '{print $1}')
selected_resolution=$(echo "$selected_option" | awk '{print $2}')

# Apply the selected resolution
xrandr --output $selected_display --mode $selected_resolution

# Check for errors
if [ $? -eq 0 ]; then
	echo "Display resolution changed successfully."
else
	echo "Failed to change display resolution."
fi
