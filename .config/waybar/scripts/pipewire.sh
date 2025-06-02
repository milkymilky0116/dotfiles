#!/bin/bash

# Get volume and mute status from wpctl
volume_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

# Check if muted
if [[ $volume_info == *"[MUTED]"* ]]; then
    muted=true
else
    muted=false
fi

# Extract volume percentage
volume=$(echo "$volume_info" | awk '{print $2}')
volume_percent=$(echo "$volume * 100" | bc | cut -d. -f1)

# Prepare JSON output for waybar
if $muted; then
    echo "{\"percentage\": $volume_percent, \"class\": \"muted\", \"icon\": \"muted\", \"text\": \"婢 $volume_percent%\", \"tooltip\": \"Muted: $volume_percent%\"}"
else
    # Set icon based on volume level
    if [ "$volume_percent" -lt 30 ]; then
        icon=""
        icon_class="low"
    elif [ "$volume_percent" -lt 70 ]; then
        icon=""
        icon_class="medium"
    else
        icon=""
        icon_class="high"
    fi
    echo "{\"percentage\": $volume_percent, \"class\": \"$icon_class\", \"icon\": \"$icon_class\", \"text\": \"$icon $volume_percent%\", \"tooltip\": \"Volume: $volume_percent%\"}"
fi
