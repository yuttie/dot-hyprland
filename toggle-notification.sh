#!/bin/bash
set -euo pipefail
UNIT=auto-reenable-notification
if makoctl mode | grep -q -F --line-regexp 'do-not-disturb'; then
    # do-not-disturb mode is enabled
    echo in do-not-disturb mode
    makoctl mode -r 'do-not-disturb'
    systemctl --user stop $UNIT.timer 2> /dev/null || true
else
    # do-not-disturb mode is disabled
    echo not in do-not-disturb mode
    makoctl mode -a 'do-not-disturb'
    systemd-run --user --unit=$UNIT --on-active=30m \
        makoctl mode -r 'do-not-disturb'
fi
