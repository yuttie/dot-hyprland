#!/bin/bash
set -euo pipefail
OFFSCREEN_MON="OFFSCREEN"

# Ensure the target monitor exists, otherwise create it as headless
if ! hyprctl -j monitors | jq -e --arg mon "$OFFSCREEN_MON" '.[] | select(.name==$mon)' >/dev/null; then
    hyprctl output create headless "$OFFSCREEN_MON"
    sleep 0.2
fi

readarray -t ACTIVE_WS < <(
    hyprctl -j monitors \
    | jq -r --arg off "$OFFSCREEN_MON" '.[] | select(.name != $off) | .activeWorkspace.name' \
    | sort -u
)

# Helper to check if a name is in ACTIVE_WS
is_active_ws() {
    local n="$1"
    for a in "${ACTIVE_WS[@]}"; do
        [[ "$a" == "$n" ]] && return 0
    done
    return 1
}

readarray -t WS_TO_HIDE < <(
    hyprctl -j workspaces \
    | jq -r --arg off "$OFFSCREEN_MON" '
        .[]
        | select(.monitor != $off)
        | select((.name|startswith("special:"))|not)
        | .name
        ' \
    | sort -u
)

for ws in "${WS_TO_HIDE[@]}"; do
    if is_active_ws "$ws"; then
        continue
    fi
    hyprctl dispatch moveworkspacetomonitor "name:$ws" "$OFFSCREEN_MON"
done
