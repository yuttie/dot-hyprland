#!/bin/bash
set -euo pipefail

# Usage: switch-workspace.sh [--here]
#   --here  bring the workspace to the current monitor instead of
#           switching to the monitor it is on

HERE=false
for arg in "$@"; do
    case "$arg" in
        --here) HERE=true ;;
        *) echo "Usage: $0 [--here]" >&2; exit 2 ;;
    esac
done

PROMPT="Switch workspace"
if [ "$HERE" = true ]; then
    PROMPT="Bring workspace here"
fi

rofi_workspace() {
    hyprctl -j workspaces \
    | jq -r '.[] | .name' \
    | rofi -dmenu -i -p "$PROMPT"
}

CHOSEN="$(rofi_workspace)" || exit 1
if [ -z "$CHOSEN" ]; then
    exit 1
fi

hyprctl dispatch "hl.dsp.focus({ workspace = 'name:$CHOSEN', on_current_monitor = $HERE })"
