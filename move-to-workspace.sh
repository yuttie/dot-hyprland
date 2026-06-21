#!/bin/bash
set -euo pipefail

rofi_workspace() {
    hyprctl -j workspaces \
    | jq -r '.[] | .name' \
    | rofi -dmenu -i -p "Move to workspace"
}

NAME="$(rofi_workspace)" || exit 1
if [ -n "$NAME" ]; then
    hyprctl dispatch movetoworkspace "name:$NAME"
fi
