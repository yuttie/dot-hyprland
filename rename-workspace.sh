#!/bin/bash
set -euo pipefail

rofi_workspace() {
    hyprctl -j workspaces \
    | jq -r '.[] | .name' \
    | rofi -dmenu -i -p "Rename workspace"
}

NAME="$(rofi_workspace)" || exit 1
if [ -n "$NAME" ]; then
    hyprctl dispatch renameworkspace $(hyprctl -j activeworkspace | jq .id) "$NAME"
fi
