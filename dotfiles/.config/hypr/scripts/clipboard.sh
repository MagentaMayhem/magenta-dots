#!/bin/bash

while true; do
    # Run rofi and store output
    chosen=$(cliphist list | rofi -dmenu -i -p "Clipboard" -kb-custom-1 "Alt+d")
    exit_code=$?   # Capture rofi exit code RIGHT AWAY

    # Exit if menu closed
    [ $exit_code -eq 1 ] && exit

    # If Alt+D pressed (rofi sends exit code 10)
    if [ $exit_code -eq 10 ]; then
        echo "$chosen" | cliphist delete
        notify-send "Clipboard" "Deleted entry"
        continue  # Reopen menu
    fi

    # Otherwise copy the item and exit
    echo "$chosen" | cliphist decode | wl-copy
    notify-send "Clipboard" "Copied!"
    exit
done

