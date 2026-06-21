#!/bin/bash
set -euo pipefail

TARGET_MONITORS="$(
    hyprctl -j monitors all \
    | jq -r '.[] | .name | select(startswith("eDP") | not)'
)"

for mon in $TARGET_MONITORS; do
    hyprctl eval "hl.monitor({ output = '$mon', mode = 'preferred', position = 'auto', scale = 1 })"
done
