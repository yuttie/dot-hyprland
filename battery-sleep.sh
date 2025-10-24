#!/bin/sh
set -euo pipefail
[[ "$(cat /sys/class/power_supply/AC*/online)" == "1" ]] || systemctl suspend-then-hibernate
