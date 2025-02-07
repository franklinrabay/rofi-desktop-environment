#!/bin/bash

dir=$ROFI_ENV_DIR

TODO_FILE="$HOME/.todo_list"

touch "$TODO_FILE"

PROMPT=$(cat "$TODO_FILE" | rofi -dmenu -i -p "To-Do List" -theme ${dir}/style/search-icon-name.rasi)

if [ -n "$PROMPT" ]; then
	if grep -Fxq "$PROMPT" "$TODO_FILE"; then
		grep -Fxv "$PROMPT" "$TODO_FILE" >"$TODO_FILE.tmp" && mv "$TODO_FILE.tmp" "$TODO_FILE"
	else
		echo "$PROMPT" >>"$TODO_FILE"
	fi
fi
