#!/bin/bash
# Lanza el sidebar correcto según la resolución de cada monitor

eww kill 2>/dev/null
sleep 0.5

monitors=$(hyprctl monitors -j)
count=$(echo "$monitors" | jq 'length')

# Monitor 0 (primario)
height0=$(echo "$monitors" | jq -r '.[] | select(.id == 0) | .height')
if [ "$height0" -ge 1440 ]; then
    eww open sidebar
else
    eww open sidebar-compact
fi

