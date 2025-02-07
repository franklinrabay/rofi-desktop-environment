#!/bin/bash

dir=$ROFI_ENV_DIR

TODO_FILE="$HOME/.todo_list"

touch "$TODO_FILE"

PROMPT=$(cat "$TODO_FILE" | rofi -dmenu -i -p "To-Do List" -theme ${dir}/style/search-icon-name.rasi)

if [ -n "$PROMPT" ]; then
	# If the selected item matches an item in the file, remove it
	# Otherwise, add it to the file
	if grep -Fxq "$PROMPT" "$TODO_FILE"; then
		# Create empty file if removing last item
		if [ $(wc -l < "$TODO_FILE") -eq 1 ]; then
			> "$TODO_FILE"
		else
			grep -Fxv "$PROMPT" "$TODO_FILE" >"$TODO_FILE.tmp" && mv "$TODO_FILE.tmp" "$TODO_FILE"
		fi
	else
		echo "$PROMPT" >>"$TODO_FILE"
	fi
fi
