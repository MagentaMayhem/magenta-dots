#!/usr/bin/env bash

# Auto-hide Cava when no player is playing
status=$(playerctl status 2>/dev/null | head -n1 || echo "Stopped")

if [[ "$status" != "Playing" ]]; then
    echo "{\"text\": \"\"}"
    exit 0
fi

# Create temporary config for Cava
config_file=$(mktemp)
trap 'rm -f "$config_file"' EXIT

cat <<EOF > "$config_file"
[general]
framerate = 60
bars = 25

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

# Convert Cava digits (0-7) to Unicode bar symbols
bar_map=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)

cava -p "$config_file" | while read -r line; do
    out=""
    for n in $(echo "$line" | sed 's/;/ /g'); do
        out="$out${bar_map[$n]}"
    done
    echo "{\"text\": \"$out\"}"
done

