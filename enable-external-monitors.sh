#!/bin/bash
set -euo pipefail
OFFSCREEN_MON="OFFSCREEN"

TARGET_MONITORS="$(
    hyprctl -j monitors all \
    | jq -r --arg off "$OFFSCREEN_MON" '.[] | .name | select((startswith("eDP") | not) and (. != $off))'
)"

for mon in $TARGET_MONITORS; do
    hyprctl keyword monitor "$mon, preferred, auto, 1"
done
