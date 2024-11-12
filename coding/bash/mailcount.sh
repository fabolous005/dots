#!/usr/bin/env bash

current="$(cat ~/.cache/mailcount)"

[ "${1}" -le "$current" ] && exit 0;

echo  "${1}" > ~/.cache/mailcount
if [ "$(hyprctl activewindow -j | jq .class)" != "thunderbird" ]; then
	pw-play ~/.local/share/sounds/alerts/new-mail.caf
fi
