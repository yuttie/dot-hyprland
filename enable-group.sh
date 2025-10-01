#!/bin/bash
set -euo pipefail

json="$(hyprctl -j activewindow 2>/dev/null || true)"
[ -z "${json}" ] && exit 0

if [ "$(jq '.grouped | length' <<<"$json")" -eq 0 ]; then
    hyprctl dispatch togglegroup
fi
