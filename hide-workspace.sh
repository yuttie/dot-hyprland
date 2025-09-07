#!/bin/bash
set -euo pipefail
OFFSCREEN_MON="OFFSCREEN"

# Ensure the target monitor exists, otherwise create it as headless
if ! hyprctl -j monitors | jq -e --arg mon "$OFFSCREEN_MON" '.[] | select(.name==$mon)' >/dev/null; then
  hyprctl output create headless "$OFFSCREEN_MON"
  sleep 0.2
fi

CUR_WS="$(hyprctl -j activeworkspace | jq -r '.name')"
CUR_MON="$(hyprctl -j activeworkspace | jq -r '.monitor')"

if [[ "$CUR_MON" == "$OFFSCREEN_MON" ]]; then
  notify-send "Hyprland" "Workspace $CUR_WS is already hidden on $OFFSCREEN_MON"
  exit 0
fi

hyprctl dispatch moveworkspacetomonitor "name:$CUR_WS" "$OFFSCREEN_MON"
hyprctl dispatch focusmonitor "$CUR_MON"
hyprctl dispatch workspace previous_per_monitor || hyprctl dispatch workspace emptynm
