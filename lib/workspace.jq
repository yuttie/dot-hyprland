# Selector that picks out exactly this workspace, given an entry of
# `hyprctl -j workspaces`. Mirrors selector() in workspace.lua: a rename
# changes only .name, and "name:" matches .address.
def selector:
    if .id or .type == "special" then .address else "name:" + .address end;

# One rofi script-mode row per workspace: its name to show and its
# selector as the info that rofi hands back in ROFI_INFO.
def rofi_rows:
    .[] | "\(.name)\u0000info\u001f\(selector)";
