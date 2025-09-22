#!/bin/bash
set -euo pipefail

CHOSEN="$(cat <<EOF | rofi -dmenu -p "Display menu")" || exit 1
Disable external monitors
Enable external monitors
EOF

case "$CHOSEN" in
    "Disable external monitors")
        exec $(dirname $0)/disable-external-monitors.sh
        ;;
    "Enable external monitors")
        exec $(dirname $0)/enable-external-monitors.sh
        ;;
esac
