#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
# Hyprlock Config Switcher

THEMES_DIR="$HOME/.config/hypr/hyprlock"
HYPRLOCK_CONF="$HOME/.config/hypr/hyprlock.conf"

IFS=$'\n'

SELECTED=$(for f in $(ls -1 "$THEMES_DIR"/*.conf 2>/dev/null); do
    echo -en "$(basename "$f" .conf)\0icon\x1fsystem-lock-screen\n"
done | rofi -dmenu -p " HyprLock")

[ -z "$SELECTED" ] && exit 0

ln -sf "$THEMES_DIR/$SELECTED.conf" "$HYPRLOCK_CONF"