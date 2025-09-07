#!/bin/bash
set -euo pipefail
OFFSCREEN_MON="OFFSCREEN"

CANDIDATES="$(hyprctl -j workspaces | jq -r --arg mon "$OFFSCREEN_MON" '.[] | select(.monitor==$mon) | .name' | sort)"

if [[ -z "$CANDIDATES" ]]; then
  notify-send "Hyprland" "No workspaces on $OFFSCREEN_MON"
  exit 0
fi

CHOSEN="$(echo "$CANDIDATES" | rofi -dmenu -p "Restore workspace")" || exit 1

CUR_MON="$(hyprctl -j activeworkspace | jq -r '.monitor')"

hyprctl dispatch moveworkspacetomonitor "name:$CHOSEN" "$CUR_MON"
hyprctl dispatch workspace "name:$CHOSEN"
