#!/bin/bash

export PATH=/usr/local/bin:/usr/bin:/bin

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"

cd "$WALLPAPER_DIR" || exit 1

IFS=$'\n'

SELECTED_WALL=$(ls -t *.jpg *.png *.gif *.jpeg 2>/dev/null | \
    while read -r a; do echo -en "$a\0icon\x1f$a\n"; done | \
    rofi -dmenu -p "Wallpaper")

[ -z "$SELECTED_WALL" ] && exit 1
SELECTED_PATH="$WALLPAPER_DIR/$SELECTED_WALL"

# SET WALLPAPER
/usr/bin/swww img "$SELECTED_PATH"

# GENERATE COLORS (NON-INTERACTIVE)
matugen image "$SELECTED_PATH" -m dark

# SYMLINK
ln -sf "$SELECTED_PATH" "$SYMLINK_PATH"

# RELOAD WAYBAR
pkill waybar && waybar &
