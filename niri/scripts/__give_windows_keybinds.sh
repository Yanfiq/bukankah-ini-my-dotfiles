#!/bin/bash

LOCKFILE="/tmp/niri-win-rdp.lock"
# Listen to the JSON event stream
niri msg --json event-stream | while read -r line; do
    # 1. Detect if a window focus change event occurred
    if echo "$line" | jq -e '.WindowFocusChanged' > /dev/null; then
        
        # 2. Extract the ID of the newly focused window
        WINDOW_ID=$(echo "$line" | jq -r '.WindowFocusChanged.id')
        
        # 3. Query the full window list to find the app_id for this ID
        # We use select() to match the ID and then grab the app_id field
        APP_ID=$(niri msg --json windows | jq -r ".[] | select(.id == $WINDOW_ID) | .app_id")
        
        # 4. Echo the result
        # if APP_ID == "Microsoft Windows"; then
        #   echo "test"
        #
        # else
        #
        if [[ "$APP_ID" == "Microsoft Windows" ]]; then
            # echo "Windows Focused"
            # Remove lockfile so next non-RDP focus will trigger rebind
            [[ -f "$LOCKFILE" ]] && rm -f "$LOCKFILE"
            # Unbind keys
            echo "include ~/.config/niri/windows_unbinds.conf" > ~/.config/hypr/custom/windows_unbinds_intermediary.conf
            hyprctl reload

        else
            # echo "Windows not focused"
            # Only rebind if lockfile does not exist
            if [[ ! -f "$LOCKFILE" ]]; then
              # echo "Rebinding keys..."
              # Create lockfile
              touch "$LOCKFILE"
              cat /dev/null > ~/.config/hypr/custom/windows_unbinds_intermediary.conf
              hyprctl reload
            fi
        fi
    fi
done

