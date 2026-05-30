#!/usr/bin/env bash
set -euo pipefail

target="${1:-eDP-1}"

# Count active monitors other than the target.
# `hyprctl monitors -j` returns active monitors only.
other_active_count="$(
  hyprctl monitors -j |
    jq --arg target "$target" '[.[] | select(.name != $target)] | length'
)"

if (( other_active_count > 0 )); then
  hyprctl keyword monitor "$target, disable"
else
  notify-send "Refusing to disable $target" "No other active monitor found"
  exit 1
fi
