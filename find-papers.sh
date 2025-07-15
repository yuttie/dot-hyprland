#!/bin/sh
set -eu
fd --type f --type l --follow --no-ignore --extension pdf --base-directory ~/Literature
