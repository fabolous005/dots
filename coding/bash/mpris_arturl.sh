#!/usr/bin/env bash

playerctl -p spotify metadata -F -f '{{mpris:artUrl}}' | while read -r url; do
    if [ "$url" != "" ]; then
        player_name=$(playerctl -p spotify metadata -f '{{playerName}}')
        if [ "$player_name" == "spotify" ]; then
            curl -o ~/.cache/mpris_art.jpeg "$url" && pidof eww && eww reload
        fi
    fi
done
