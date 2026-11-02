#!/bin/bash
set -euo pipefail

. "$(dirname "$0")/lib/lua-quote.sh"

rofi_workspace() {
    hyprctl -j workspaces \
    | jq -r '.[] | .name' \
    | rofi -dmenu -i -p "Rename workspace"
}

TARGET="$(hyprctl -j activeworkspace | jq -r -L "$(dirname "$0")/lib" 'include "workspace"; selector')"
NAME="$(rofi_workspace)" || exit 1
if [ -n "$NAME" ]; then
    hyprctl dispatch "hl.dsp.workspace.rename({ workspace = $(lua_quote "$TARGET"), name = $(lua_quote "$NAME") })"
fi
