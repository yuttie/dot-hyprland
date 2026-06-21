#!/bin/sh
hyprctl --instance 0 eval "hl.config({ misc = { allow_session_lock_restore = true } })"
killall -9 hyprlock
sleep 3
hyprctl --instance 0 eval "hl.exec_cmd('hyprlock')"
sleep 3
hyprctl --instance 0 eval "hl.config({ misc = { allow_session_lock_restore = false } })"
