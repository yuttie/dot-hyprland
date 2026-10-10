#!/bin/bash
set -euo pipefail

# Usage: move-to-workspace.sh [--follow]
#   --follow  also switch to the destination workspace

FOLLOW=false
for arg in "$@"; do
    case "$arg" in
        --follow) FOLLOW=true ;;
        *) echo "Usage: $0 [--follow]" >&2; exit 2 ;;
    esac
done

PROMPT="Move to workspace"
if [ "$FOLLOW" = false ]; then
    PROMPT="$PROMPT (silent)"
fi

rofi_workspace() {
    hyprctl -j workspaces \
    | jq -r '.[] | .name' \
    | rofi -dmenu -i -p "$PROMPT"
}

NAME="$(rofi_workspace)" || exit 1
if [ -n "$NAME" ]; then
    hyprctl eval "require('lib.window').move_to_workspace('name:$NAME', $FOLLOW)"
fi
