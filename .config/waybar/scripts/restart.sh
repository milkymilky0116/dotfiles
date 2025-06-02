#!/bin/bash

# Restart Waybar script

# Check if waybar is running
if pgrep -x "waybar" > /dev/null; then
    echo "Killing waybar..."
    killall waybar
    # Wait a moment to ensure waybar is fully terminated
    sleep 0.5
else
    echo "Waybar is not running."
fi

# Start waybar
echo "Starting waybar..."
waybar &

echo "Waybar restarted successfully!"
