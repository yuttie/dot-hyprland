#!/bin/bash
set -euo pipefail

rofi_workspace() {
    hyprctl -j workspaces \
    | jq -r '.[] | .name' \
    | rofi -dmenu -i -p "Switch workspace"
}

CHOSEN="$(rofi_workspace)" || exit 1
if [ -z "$CHOSEN" ]; then
    exit 1
fi

hyprctl dispatch workspace "name:$CHOSEN"
