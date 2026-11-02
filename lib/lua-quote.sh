# shellcheck shell=bash

# Print $1 as a Lua string literal, for text spliced into the Lua that
# `hyprctl dispatch` and `hyprctl eval` run. Only the backslash, the
# quote and line breaks need escaping in a single-quoted Lua string.
lua_quote() {
    local s=$1 bs=\\
    s=${s//"$bs"/"$bs$bs"}
    s=${s//"'"/"$bs'"}
    s=${s//$'\n'/"${bs}n"}
    s=${s//$'\r'/"${bs}r"}
    printf "'%s'" "$s"
}
