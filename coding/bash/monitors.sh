#!/usr/bin/env bash

if [[ "$1" == "active" ]]; then
	hyprctl monitors | rg focused\|Monitor | awk '/focused: yes/ {print prev} {prev = $0}' | rg -o 'Monitor [^( ]*' | cut -d' ' -f1 --complement
else
	hyprctl monitors | rg -e '^Monitor' | awk '/HEADLESS/{exit} {print}' | rg -o 'Monitor [^( ]*' | cut -d' ' -f1 --complement
fi
