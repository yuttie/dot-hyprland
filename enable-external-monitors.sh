#!/bin/bash
set -euo pipefail

TARGET_MONITORS="$(
    hyprctl -j monitors all \
    | jq -r '.[] | .name | select(startswith("eDP") | not)'
)"

for mon in $TARGET_MONITORS; do
    hyprctl keyword monitor "$mon, preferred, auto, 1"
done
