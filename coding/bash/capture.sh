#!/usr/bin/env bash

if [[ "$1" == monitor ]]; then
	grim -o "$(/home/fabian/coding/bash/monitors.sh active)" ~/.cache/screenshot.png || notify-send -u critical "Could not determine output"
	wl-copy < ~/.cache/screenshot.png
elif [[ "$1" == select ]]; then
	cords=$(slurp)
	if [[ "$2" == name ]]; then
		name=$(/home/fabian/coding/python/through.py)
		file_name="$HOME/pictures/$name.png"
		grim -g "$cords" "$file_name"
		wl-copy < "$name"
	else
		grim -g "$cords" ~/.cache/screenshot.png
		wl-copy < ~/.cache/screenshot.png
	fi
fi
