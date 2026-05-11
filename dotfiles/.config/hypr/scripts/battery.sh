#!/bin/sh

# ====== CONFIG ======
WARNING=34        # warn at 20%
CRITICAL=10       # critical at 10%
SUSPEND=5         # suspend at 5%
INTERVAL=60       # check every 60 seconds
# ====================

BATTERY_PATH=$(upower -e | grep BAT)

if [ -z "$BATTERY_PATH" ]; then
    echo "No battery detected."
    exit 1
fi

warned=0
critical_warned=0

while true; do
    PERCENT=$(upower -i "$BATTERY_PATH" | awk '/percentage/ {gsub("%",""); print $2}')
    STATE=$(upower -i "$BATTERY_PATH" | awk '/state/ {print $2}')

    # Only alert when discharging
    if [ "$STATE" = "discharging" ]; then

        if [ "$PERCENT" -le "$WARNING" ] && [ "$warned" -eq 0 ]; then
            notify-send "⚠ Low Battery" "Battery at ${PERCENT}%"
            warned=1
        fi

        if [ "$PERCENT" -le "$CRITICAL" ] && [ "$critical_warned" -eq 0 ]; then
            notify-send "❗ Critical Battery" "Battery at ${PERCENT}%"
            critical_warned=1
        fi

        if [ "$PERCENT" -le "$SUSPEND" ]; then
            notify-send "💤 Suspending" "Battery at ${PERCENT}%"
            sleep 5
            systemctl suspend
        fi

    else
        # Reset warnings if charging
        warned=0
        critical_warned=0
    fi

    sleep "$INTERVAL"
done
