#!/bin/bash

BLACKOUTER_PID=0
trap 'kill 0' EXIT
# Listen to the JSON event stream
while read -r line; do
    # 1. Detect if a window focus change event occurred
    if jq -e '.WindowFocusChanged' <<<"$line" > /dev/null; then
        
        # 2. Check the focused output
        current_output_raw=$(niri msg focused-output)
        
        fragile_monitor='(eDP-1)'

        if [[ "$current_output_raw" != *"$fragile_monitor"* ]]; then
            if [[ $BLACKOUTER_PID -eq 0 ]]; then
                ./__blackout_oled.sh &
                BLACKOUTER_PID=$!
            fi
        elif [[ "$current_output_raw" == *"$fragile_monitor"* ]]; then
            if [[ $BLACKOUTER_PID -ne 0 ]] && kill -0 "$BLACKOUTER_PID" 2>/dev/null; then
                kill "$BLACKOUTER_PID"
            fi
            BLACKOUTER_PID=0
        fi  
    fi
done < <(niri msg --json event-stream)
