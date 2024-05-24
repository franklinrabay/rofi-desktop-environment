#!/bin/bash

dir=$ROFI_ENV_DIR
customDir=$ROFI_ENV_CUSTOM_DIR

# Function to get all available layouts
get_layouts() {
	localectl list-x11-keymap-layouts
}

# Function to get all available variants for a given layout
get_variants() {
	local layout=$1
	local variants

	# Deserialize the JSON file and extract variants for the given layout
	if [[ -f ${customDir}/keyboard.json ]]; then
		variants=$(jq -r ".$layout[]" ${customDir}/keyboard.json)
	fi

	if [[ -n "$variants" ]]; then
		echo "$variants"
	else
		localectl list-x11-keymap-variants "$layout"
	fi
}

# Get the current layout
CURRENT_LAYOUT=$(setxkbmap -query | grep layout | awk '{print $2}')

# Fetch all available layouts
LAYOUTS=($(get_layouts))

# Deserialize the JSON file to get custom layouts and add them to the list

if [[ -f ${customDir}/keyboard.json ]]; then
	while IFS= read -r layout; do
		LAYOUTS+=("$layout")
	done < <(jq -r 'keys[]' ${customDir}/keyboard.json)
fi

# Create a menu using Rofi to select layout
LAYOUT_CHOICE=$(printf "%s\n" "${LAYOUTS[@]}" | rofi -dmenu -p "  $CURRENT_LAYOUT" -theme ${dir}/style/search-icon-name.rasi)

# Check if a layout was chosen and if it's different from the current one
if [[ -n "$LAYOUT_CHOICE" ]]; then
	# Fetch all available variants for the chosen layout
	VARIANTS=($(get_variants "$LAYOUT_CHOICE"))

	# Check if there are any variants available
	if [[ ${#VARIANTS[@]} -gt 0 ]]; then
		# Create a menu using Rofi to select variant
		VARIANT_CHOICE=$(printf "%s\n" "${VARIANTS[@]}" | rofi -dmenu -p "Variant" -theme ${dir}/style/search-icon-name.rasi)
	fi

	# Set the new layout with or without the chosen variant
	if [[ -n "$VARIANT_CHOICE" ]]; then
		setxkbmap -layout "$LAYOUT_CHOICE" -variant "$VARIANT_CHOICE"
		notify-send "Keyboard Layout" "Changed to $LAYOUT_CHOICE ($VARIANT_CHOICE)"
	else
		setxkbmap -layout "$LAYOUT_CHOICE"
		notify-send "Keyboard Layout" "Changed to $LAYOUT_CHOICE"
	fi
fi
