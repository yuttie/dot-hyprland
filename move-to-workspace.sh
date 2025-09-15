#!/bin/bash
set -euo pipefail
OFFSCREEN_MON="OFFSCREEN"

rofi_workspace() {
    hyprctl -j workspaces \
    | jq -r --arg off "$OFFSCREEN_MON" '.[] | select(.monitor != $off) | .name' \
    | rofi -dmenu -i -p "Move to workspace"
}

NAME="$(rofi_workspace)" || exit 1
if [ -n "$NAME" ]; then
    hyprctl dispatch movetoworkspace "name:$NAME"
fi
