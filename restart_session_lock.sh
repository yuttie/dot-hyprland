#!/bin/sh
hyprctl --instance 0 'keyword misc:allow_session_lock_restore true'
hyprctl --instance 0 'dispatch exec hyprlock'
hyprctl --instance 0 'keyword misc:allow_session_lock_restore false'
