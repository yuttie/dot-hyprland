#!/bin/sh
set -eu
upower -b > /dev/null 2>&1 \
    && ! grep --line-regexp 1 /sys/class/power_supply/AC*/online > /dev/null 2>&1 \
    && systemctl suspend-then-hibernate
