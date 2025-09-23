#!/bin/bash
set -euo pipefail
OFFSCREEN_MON="OFFSCREEN"

rofi_workspace() {
    hyprctl -j workspaces \
    | jq -r '.[] | .name' \
    | rofi -dmenu -i -p "Switch workspace"
}

CHOSEN="$(rofi_workspace)" || exit 1
if [ -z "$CHOSEN" ]; then
    exit 1
fi

if hyprctl -j workspaces | jq -e --arg off "$OFFSCREEN_MON" --arg target "$CHOSEN" '.[] | select(.monitor == $off and .name == $target)'; then
    # If the chosen workspace is on the offscreen monitor, bring it back to the current monitor
    CUR_MON="$(hyprctl -j activeworkspace | jq -r '.monitor')"
    hyprctl dispatch moveworkspacetomonitor "name:$CHOSEN" "$CUR_MON"
fi
hyprctl dispatch workspace "name:$CHOSEN"
