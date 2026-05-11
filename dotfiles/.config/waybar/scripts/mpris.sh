#!/bin/bash

# === CONFIG ===
ICON_PLAY=""
ICON_PAUSE=""
ICON_NEXT=""
ICON_PREV=""
ICON_MUSIC="󰝚"

TITLE=$(playerctl metadata title 2>/dev/null)
ARTIST=$(playerctl metadata artist 2>/dev/null)
STATUS=$(playerctl status 2>/dev/null)
PLAYER=$(playerctl metadata --format '{{playerName}}' 2>/dev/null)

# === HIDE MODULE WHEN NOTHING IS ACTIVE ===
if [ -z "$STATUS" ] || [ "$STATUS" == "Stopped" ]; then
    echo "{}"
    exit 0
fi

# === Determine icon based on status ===
if [ "$STATUS" == "Playing" ]; then
    STATUS_ICON=$ICON_PAUSE
elif [ "$STATUS" == "Paused" ]; then
    STATUS_ICON=$ICON_PLAY
else
    STATUS_ICON=$ICON_MUSIC
fi

# === Truncate long titles ===
MAX_LEN=25
if [ ${#TITLE} -gt $MAX_LEN ]; then
    TITLE="${TITLE:0:$MAX_LEN}…"
fi

# === Output JSON for Waybar ===
TEXT="$ICON_MUSIC  $TITLE  $ICON_PREV  $STATUS_ICON  $ICON_NEXT"
TOOLTIP="$PLAYER\n$ARTIST - $TITLE"

echo "{\"text\": \"$TEXT\", \"tooltip\": \"$TOOLTIP\"}"
