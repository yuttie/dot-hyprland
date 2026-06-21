#!/bin/bash
set -euo pipefail

rofi_workspace() {
    hyprctl -j workspaces \
    | jq -r '.[] | .name' \
    | rofi -dmenu -i -p "Rename workspace"
}

TARGET="$(hyprctl -j activeworkspace | jq .id)"
NAME="$(rofi_workspace)" || exit 1
if [ -n "$NAME" ]; then
    hyprctl dispatch "hl.dsp.workspace.rename({ workspace = '$TARGET', name = '$NAME' })"
fi
