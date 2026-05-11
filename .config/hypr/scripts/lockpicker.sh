#!/bin/bash

# === CONFIG ===
HYPRLOCK_DIR="$HOME/.config/hypr/hyprlock"
SYMLINK_PATH="$HOME/.config/hypr/hyprlock.conf"

cd "$HYPRLOCK_DIR" || exit 1

# === Handle spaces in filenames ===
IFS=$'\n'

# === CONFIG SELECTION WITH ROFI ===
# list only *.conf files (ignore directories)
SELECTED_CONF=$(for a in $(ls *.conf 2>/dev/null); do echo "$a"; done | rofi -dmenu -p "🔒 Select Hyprlock config:")
[ -z "$SELECTED_CONF" ] && exit 1
SELECTED_PATH="$HYPRLOCK_DIR/$SELECTED_CONF"

# === CREATE SYMLINK ===
mkdir -p "$(dirname "$SYMLINK_PATH")"
ln -sf "$SELECTED_PATH" "$SYMLINK_PATH"

# === FEEDBACK ===
notify-send "Hyprlock" "Switched to config: $SELECTED_CONF"
echo "Switched Hyprlock config to: $SELECTED_CONF"

# === OPTIONAL: Reload hyprlock (if already running) ===
# pkill -USR1 hyprlock  # Uncomment if you want it to auto-reload
