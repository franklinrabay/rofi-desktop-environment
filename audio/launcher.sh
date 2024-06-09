#!/bin/bash

dir=$ROFI_ENV_DIR

# Function to get a list of available sinks (audio outputs) with descriptions
get_sinks() {
	pactl list short sinks | awk '{print $1}' | while read -r index; do
		description=$(pactl list sinks | awk -v RS= '/index: '"$index"'/{for (i=1; i<=NF; i++) if ($i == "Description:") {print $(i+1); break}}')
		echo "$index $description"
	done
}

# Function to get a list of available sources (audio inputs) with descriptions
get_sources() {
	pactl list short sources | awk '{print $1}' | while read -r index; do
		description=$(pactl list sources | awk -v RS= '/index: '"$index"'/{for (i=1; i<=NF; i++) if ($i == "Description:") {print $(i+1); break}}')
		echo "$index $description"
	done
}

# Function to get the current default sink (audio output)
get_current_sink() {
	pactl info | grep "Default Sink" | awk '{print $3}'
}

# Function to get the current default source (audio input)
get_current_source() {
	pactl info | grep "Default Source" | awk '{print $3}'
}

# Function to set the default sink (audio output)
set_sink() {
	pactl set-default-sink "$1"
}

# Function to set the default source (audio input)
set_source() {
	pactl set-default-source "$1"
}

# Get the user's choice of input/output
CHOICE=$(printf "Input\nOutput" | rofi -dmenu -p "Select Audio Device Type" -theme ${dir}/style/search-icon-name.rasi)

if [[ "$CHOICE" == "Output" ]]; then
	# Get the current default sink
	CURRENT_SINK=$(get_current_sink)

	# Get available sinks and display them in rofi
	SINKS=($(get_sinks))
	SINK_CHOICE=$(printf "%s\n" "${SINKS[@]}" | rofi -dmenu -p "  $CURRENT_SINK" -theme ${dir}/style/search-icon-name.rasi)

	# Extract the selected sink index
	SINK_INDEX=$(echo "$SINK_CHOICE" | awk '{print $1}')

	# Set the chosen sink as the default
	if [[ -n "$SINK_INDEX" ]]; then
		set_sink "$SINK_INDEX"
		notify-send "Audio Output" "Changed to $SINK_CHOICE"
	fi
elif [[ "$CHOICE" == "Input" ]]; then
	# Get the current default source
	CURRENT_SOURCE=$(get_current_source)

	# Get available sources and display them in rofi
	SOURCES=($(get_sources))
	SOURCE_CHOICE=$(printf "%s\n" "${SOURCES[@]}" | rofi -dmenu -p "  $CURRENT_SOURCE" -theme ${dir}/style/search-icon-name.rasi)

	# Extract the selected source index
	SOURCE_INDEX=$(echo "$SOURCE_CHOICE" | awk '{print $1}')

	# Set the chosen source as the default
	if [[ -n "$SOURCE_INDEX" ]]; then
		set_source "$SOURCE_INDEX"
		notify-send "Audio Input" "Changed to $SOURCE_CHOICE"
	fi
else
	echo "Invalid choice."
	exit 1
fi
