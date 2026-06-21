#!/bin/bash
set -euo pipefail

BUILTIN_MONITORS="$(hyprctl -j monitors all | jq -r '.[] | .name | select(startswith("eDP"))')"
for mon in $BUILTIN_MONITORS; do
    hyprctl keyword monitor "$mon, preferred, auto, 1"
done

TARGET_MONITORS="$(
    hyprctl -j monitors \
    | jq -r '.[] | .name | select(startswith("eDP") | not)'
)"

for mon in $TARGET_MONITORS; do
    hyprctl keyword monitor "$mon, disable"
done
