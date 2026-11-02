#!/bin/bash
set -euo pipefail

# Usage: move-to-workspace.sh [--follow] [--single]
#   --follow  also switch to the destination workspace
#   --single  move only the focused window, leaving the rest of its group
#
# The options set the mode the menu opens in. Inside the menu, Alt+F
# toggles --follow and Alt+G toggles --single.
#
# The menu is a rofi script mode: rofi runs this script again for every
# event, with ROFI_RETV saying what happened and ROFI_DATA carrying the
# mode from the previous run.

toggle() {
    if [ "$1" = true ]; then echo false; else echo true; fi
}

on_off() {
    if [ "$1" = true ]; then echo on; else echo off; fi
}

. "$(dirname "$0")/lib/lua-quote.sh"

if [ -z "${ROFI_RETV:-}" ]; then
    FOLLOW=false
    SINGLE=false
    for arg in "$@"; do
        case "$arg" in
            --follow) FOLLOW=true ;;
            --single) SINGLE=true ;;
            *) echo "Usage: $0 [--follow] [--single]" >&2; exit 2 ;;
        esac
    done
    # The script inherits rofi's environment, so this seeds its first run.
    export ROFI_DATA="$FOLLOW $SINGLE"
    exec rofi -show move -modi "move:$0" \
        -kb-move-word-forward Control+Right \
        -kb-custom-1 Alt+f \
        -kb-custom-2 Alt+g
fi

read -r FOLLOW SINGLE <<< "$ROFI_DATA"

case "$ROFI_RETV" in
    1|2)
        MOVE=move_to_workspace
        if [ "$SINGLE" = true ]; then
            MOVE=move_single_to_workspace
        fi
        # Rofi passes on any ROFI_INFO it was started with, so it says
        # nothing about text typed in.
        if [ "$ROFI_RETV" = 1 ]; then
            # A listed workspace comes with its selector.
            TARGET="$ROFI_INFO"
        elif [[ "$1" =~ ^[[:digit:]]+$ ]]; then
            # A number typed in is a numbered workspace; "name:" refuses
            # numbers.
            TARGET="$1"
        else
            # Other text typed in is the address of a named workspace,
            # created if there is none. "name:" keeps it from being read as
            # a selector such as "next".
            TARGET="name:$1"
        fi
        # Rofi would show anything printed here as a new list instead of
        # closing.
        hyprctl eval "require('lib.window').$MOVE($(lua_quote "$TARGET"), $FOLLOW)" > /dev/null
        exit 0
        ;;
    10) FOLLOW="$(toggle "$FOLLOW")" ;;
    11) SINGLE="$(toggle "$SINGLE")" ;;
esac

PROMPT="Move to workspace"
UNIT=group
if [ "$SINGLE" = true ]; then
    PROMPT="Move single window to workspace"
    UNIT=window
fi
if [ "$FOLLOW" = false ]; then
    PROMPT="$PROMPT (silent)"
fi

printf '\0prompt\x1f%s\n' "$PROMPT"
printf '\0message\x1f%s\n' "<b>Alt+F</b> follow: $(on_off "$FOLLOW")    <b>Alt+G</b> move: $UNIT"
printf '\0data\x1f%s\n' "$FOLLOW $SINGLE"
printf '\0use-hot-keys\x1ftrue\n'
printf '\0keep-filter\x1ftrue\n'
printf '\0keep-selection\x1ftrue\n'
hyprctl -j workspaces | jq -r -L "$(dirname "$0")/lib" 'include "workspace"; rofi_rows'
