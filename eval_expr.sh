#!/bin/bash
set -euo pipefail

expr=$(rofi -dmenu -p 'Python Expression' -l 0 < /dev/null)
result=$(echo -n "$expr" | python -c "from sys import stdin; import math; print(eval(stdin.read()))")
action=$(notify-send --icon="calculator" --action="copy=Copy" "Evaluation Result" "$result")
case "$action" in
    "copy")
        echo -n "$result" | wl-copy
        ;;
esac
