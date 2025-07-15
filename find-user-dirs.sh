#!/bin/sh
set -eu
fd --type d --type l --follow --no-ignore --owner $USER --exclude /snapshot --exclude /proc --exclude /sys --exclude /dev --exclude /mnt --exclude /tmp --base-directory / --absolute-path
