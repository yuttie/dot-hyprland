#!/bin/bash
set -euo pipefail

# Usage: move-to-workspace.sh [--follow] [--single]
#   --follow  also switch to the destination workspace
#   --single  move only the focused window, leaving the rest of its group

FOLLOW=false
SINGLE=false
for arg in "$@"; do
    case "$arg" in
        --follow) FOLLOW=true ;;
        --single) SINGLE=true ;;
        *) echo "Usage: $0 [--follow] [--single]" >&2; exit 2 ;;
    esac
done

MOVE=move_to_workspace
PROMPT="Move to workspace"
if [ "$SINGLE" = true ]; then
    MOVE=move_single_to_workspace
    PROMPT="Move single window to workspace"
fi
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
    hyprctl eval "require('lib.window').$MOVE('name:$NAME', $FOLLOW)"
fi
