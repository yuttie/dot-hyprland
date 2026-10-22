#!/bin/bash
set -euo pipefail

# Usage: switch-workspace.sh [--here]
#   --here  bring the workspace to the current monitor instead of
#           switching to the monitor it is on
#
# The option sets the mode the menu opens in. Inside the menu, Alt+H
# toggles it.
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

if [ -z "${ROFI_RETV:-}" ]; then
    HERE=false
    for arg in "$@"; do
        case "$arg" in
            --here) HERE=true ;;
            *) echo "Usage: $0 [--here]" >&2; exit 2 ;;
        esac
    done
    # The script inherits rofi's environment, so this seeds its first run.
    export ROFI_DATA="$HERE"
    exec rofi -show switch -modi "switch:$0" \
        -kb-custom-1 Alt+h
fi

HERE="$ROFI_DATA"

case "$ROFI_RETV" in
    1|2)
        # Rofi would show anything printed here as a new list instead of
        # closing.
        hyprctl dispatch "hl.dsp.focus({ workspace = 'name:$1', on_current_monitor = $HERE })" > /dev/null
        exit 0
        ;;
    10) HERE="$(toggle "$HERE")" ;;
esac

PROMPT="Switch workspace"
if [ "$HERE" = true ]; then
    PROMPT="Bring workspace here"
fi

printf '\0prompt\x1f%s\n' "$PROMPT"
printf '\0message\x1f%s\n' "<b>Alt+H</b> bring here: $(on_off "$HERE")"
printf '\0data\x1f%s\n' "$HERE"
printf '\0use-hot-keys\x1ftrue\n'
printf '\0keep-filter\x1ftrue\n'
printf '\0keep-selection\x1ftrue\n'
hyprctl -j workspaces | jq -r '.[] | .name'
