#!/bin/sh
hyprctl --instance 0 'keyword misc:allow_session_lock_restore 1'
killall -9 hyprlock
sleep 3
hyprctl --instance 0 'dispatch exec hyprlock'
sleep 3
hyprctl --instance 0 'keyword misc:allow_session_lock_restore 0'
