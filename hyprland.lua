-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")


------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal   = os.getenv("HOME") .. "/.local/bin/term"
local editor     = terminal .. " -- sh -c 'sleep 0.05; exec nvim'"
local webbrowser = "/usr/bin/firefox"
local webbrowser_private = "/usr/bin/firefox --private-window"
local subwebbrowser = "/usr/bin/google-chrome-stable"
local rofi       = "rofi -no-case-sensitive -matching regex -sort -sorting-method fzf"
local menu       = rofi .. " -modi drun##run -show drun -show-icons -drun-show-actions"


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
-- hl.on("hyprland.start", function ()
--   hl.exec_cmd(terminal)
--   hl.exec_cmd("nm-applet")
--   hl.exec_cmd("waybar & hyprpaper & firefox")
-- end)

hl.on("hyprland.start", function()
    -- Import specific environment variables into the systemd user session and dbus
    local env_vars_to_import = "DISPLAY WAYLAND_DISPLAY"
    local my_env_vars_to_import = "XCURSOR_THEME XCURSOR_SIZE HYPRCURSOR_SIZE XDG_SESSION_TYPE XDG_CURRENT_DESKTOP XDG_CURRENT_SESSION XDG_SESSION_DESKTOP LIBSEAT_BACKEND GDK_BACKEND QT_QPA_PLATFORM SDL_VIDEODRIVER QT_QPA_PLATFORMTHEME MOZ_ENABLE_WAYLAND WINIT_UNIX_BACKEND _JAVA_AWT_WM_NONREPARENTING XMODIFIERS QT_IM_MODULE QT_IM_MODULES QT5_IM_MODULE SDL_IM_MODULE GLFW_IM_MODULE"
    hl.exec_cmd("systemctl --user import-environment " .. env_vars_to_import .. " " .. my_env_vars_to_import)
    hl.exec_cmd("dbus-update-activation-environment --systemd " .. env_vars_to_import .. " " .. my_env_vars_to_import)

    -- Wallpaper
    hl.exec_cmd("hyprpaper")

    -- Idle daemon
    hl.exec_cmd("hypridle")

    -- Polkit agent
    hl.exec_cmd("sh -c '[ -x /usr/libexec/hyprpolkitagent ] && exec /usr/libexec/hyprpolkitagent || exec /usr/lib/hyprpolkitagent/hyprpolkitagent'")

    hl.exec_cmd("fcitx5 -dr")
    hl.exec_cmd("waybar")

    -- Settings for Gnome apps
    local gnome_schema = "org.gnome.desktop.interface"
    hl.exec_cmd("gsettings set " .. gnome_schema .. " color-scheme 'prefer-light'")  -- Valid values are “default”, “prefer-dark”, “prefer-light”
    hl.exec_cmd("gsettings set " .. gnome_schema .. " icon-theme 'WhiteSur-light'")
    hl.exec_cmd("gsettings set " .. gnome_schema .. " gtk-theme 'WhiteSur-Light'")
    hl.exec_cmd("gsettings set " .. gnome_schema .. " gtk-key-theme 'Emacs'")
    hl.exec_cmd("gsettings set " .. gnome_schema .. " font-name 'Sans 10'")
    hl.exec_cmd("gsettings set " .. gnome_schema .. " monospace-font-name 'Monospace 10'")
    hl.exec_cmd("gsettings set " .. gnome_schema .. " cursor-theme 'Breeze'")
    hl.exec_cmd("gsettings set " .. gnome_schema .. " cursor-size '32'")
    hl.exec_cmd("gsettings set " .. gnome_schema .. " font-antialiasing 'rgba'")
    hl.exec_cmd("gsettings set " .. gnome_schema .. " font-hinting 'none'")
    hl.exec_cmd("gsettings set org.gnome.settings-daemon.plugins.xsettings overrides \"{'Gtk/IMModule':<'fcitx'>}\"")

    -- Apps
    hl.exec_cmd("xrdb -load ~/.Xresources")
    hl.exec_cmd("pasystray")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("dropbox")
    hl.exec_cmd("1password --silent")
    hl.exec_cmd("slack --startup")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_THEME", "Breeze")
hl.env("XCURSOR_SIZE", "32")
hl.env("HYPRCURSOR_SIZE", "32")

hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_CURRENT_SESSION", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("LIBSEAT_BACKEND", "logind")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland,x11")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")  -- Has effect also for Qt6 (no need to be qt6ct)
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("WINIT_UNIX_BACKEND", "x11")
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")

-- Input method
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULES", "wayland;fcitx;ibus")
hl.env("QT5_IM_MODULE", "fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
hl.env("GLFW_IM_MODULE", "ibus")

-- App-specific variables
hl.env("GQ_NEW_INSTANCE", "yes")
hl.env("OOO_DISABLE_RECOVERY", "1")


-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

hl.config({
    ecosystem = {
        enforce_permissions = true,
    },
})

hl.permission({ binary = "/usr/bin/hyprlock", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/wl-mirror", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/wdisplays", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/wayvnc", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/hyprpicker", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/grim", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/grimblast", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/libexec/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 6,
        gaps_out = 12,

        border_size = 6,

        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(33ff7aee)"}, angle = 45 },
            inactive_border = "rgba(ffffff33)",
        },

        layout = "dwindle",

        no_focus_fallback = true,

        allow_tearing = false,
    },

    decoration = {
        rounding = 12,
        dim_special = 0.5,
        dim_around = 0.5,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 96,
            render_power = 2,
            color        = "rgba(00000066)",
            offset       = {0, 18},
            scale        = 0.95,
        },

        blur = {
            enabled        = true,
            size           = 8,
            passes         = 3,
            ignore_opacity = true,
            noise          = 0.02,
        },

        motion_blur = {
            enabled = false,
            samples = 30,
        },
    },

    group = {
        auto_group = true,
        insert_after_current = true,
        focus_removed_window = true,
        drag_into_group = 1,
        merge_groups_on_drag = false,
        merge_groups_on_groupbar = false,
        merge_floated_into_tiled_on_groupbar = false,
        group_on_movetoworkspace = false,

        col = {
            border_active = { colors = {"rgba(33ccffee)", "rgba(33ff7aee)"}, angle = 45 },
            border_inactive = "rgba(ffffff33)",
        },

        groupbar = {
            enabled = true,
            font_size = 12,
            gradients = true,
            height = 16,
            indicator_gap = 0,
            indicator_height = 0,
            render_titles = true,
            text_offset = 0,
            text_padding = 6,
            rounding = 10,
            round_only_edges = true,
            gradient_rounding = 10,
            gradient_round_only_edges = true,
            text_color = "rgba(000000cc)",
            text_color_inactive = "rgba(00000077)",
            col = {
                active = "rgba(ffffff88)",
                inactive = "rgba(ffffff33)",
            },
            gaps_in = 3,
            gaps_out = 6,
            keep_upper_gap = false,
            blur = true,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1   }, {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0,    0   }, {1,    1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5,  0.5 }, {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0   }, {0.1,  1} } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 5,    bezier = "default" })
hl.animation({ leaf = "border",        enabled = false })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 3,    bezier = "easeOutQuint", style = "popin 90%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 3,    bezier = "easeOutQuint", style = "popin 90%" })
hl.animation({ leaf = "windowsMove",   enabled = true,  speed = 3,    bezier = "easeOutQuint" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fadeSwitch",    enabled = false })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 2, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 2, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "specialWorkspaceIn",  enabled = true,  speed = 2,   bezier = "almostLinear", style = "slidefadevert top 5%"    })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true,  speed = 1.5, bezier = "almostLinear", style = "slidefadevert bottom 5%" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 5,    bezier = "easeOutQuint" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        force_split = 2,
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
        mouse_move_enables_dpms = false,
        key_press_enables_dpms = true,
        focus_on_activate = true,
        on_focus_under_fullscreen = 1,
        exit_window_retains_fullscreen = true,
        anr_missed_pings = 5,
    },
})


----------------
---- RENDER ----
----------------

hl.config({
    render = {
        direct_scanout = 2,
    },
})


----------------
---- CURSOR ----
----------------

hl.config({
    cursor = {
        zoom_detached_camera = false,
        zoom_disable_aa = true,
        hide_on_key_press = true,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout = "jp",
        kb_variant = "my-dvorak",
        kb_options = "ctrl:nocaps",
        numlock_by_default = true,
        repeat_delay = 300,
        repeat_rate = 60,

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.config({
    binds = {
        scroll_event_delay = 0,
        allow_workspace_cycles = true,
        ignore_group_lock = false,
        window_direction_monitor_fallback = false,
    },
})


------------------
---- XWayland ----
------------------

hl.config({
    xwayland = {
        enabled = true,
        force_zero_scaling = true,
    },
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local function bind(keys, dispatcher)
    return hl.bind(table.concat(keys, " + "), dispatcher)
end

-- Launch app
bind({mainMod, "semicolon"},       hl.dsp.exec_cmd(terminal))
bind({mainMod, "E"},               hl.dsp.exec_cmd(editor))
bind({mainMod, "W"},               hl.dsp.exec_cmd(webbrowser))
bind({mainMod, "CONTROL", "W"},    hl.dsp.exec_cmd(webbrowser_private))
bind({mainMod, "SHIFT", "W"},      hl.dsp.exec_cmd(subwebbrowser))
bind({mainMod, "R"},               hl.dsp.exec_cmd(menu))
bind({mainMod, "Zenkaku_Hankaku"}, hl.dsp.exec_cmd("killall fcitx5; fcitx5 -dr"))

-- Session
bind({mainMod, "CONTROL", "X"}, hl.dsp.exec_cmd("loginctl lock-session"))
bind({mainMod, "CONTROL", "Q"}, hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- Monitor
bind({mainMod, "comma"},            hl.dsp.focus({ monitor = "l" }))
bind({mainMod, "period"},           hl.dsp.focus({ monitor = "r" }))
bind({mainMod, "CONTROL", "Left"},  hl.dsp.focus({ monitor = "l" }))
bind({mainMod, "CONTROL", "Right"}, hl.dsp.focus({ monitor = "r" }))
bind({mainMod, "CONTROL", "Up"},    hl.dsp.focus({ monitor = "u" }))
bind({mainMod, "CONTROL", "Down"},  hl.dsp.focus({ monitor = "d" }))

-- Workspace

--- Next (dir = 1) or previous (dir = -1) workspace name on a monitor,
--- in lexicographic order, wrapping around. Single pass, no allocation.
---@param dir 1|-1
---@param mon? HL.MonitorSelector
---@param lt? fun(a: string, b: string): boolean
---@return string|nil
local function adjacent_workspace(dir, mon, lt)
    local monitor = mon and hl.get_monitor(mon) or hl.get_active_monitor()
    if not monitor then return nil end

    local active = hl.get_active_workspace(monitor)
    if not active then return nil end
    local current = active.name

    lt = lt or function(a, b) return a < b end
    -- Searching backwards is the same search with the order flipped.
    local before = dir > 0 and lt or function(a, b) return lt(b, a) end

    local best, wrap = nil, nil
    for _, ws in ipairs(hl.get_workspaces()) do
        local m = ws.monitor
        if m and m.id == monitor.id and not ws.special then
            local name = ws.name
            if before(current, name) and (best == nil or before(name, best)) then
                best = name
            end
            if wrap == nil or before(name, wrap) then
                wrap = name
            end
        end
    end

    return best or wrap
end

function focus_adjacent_workspace(dir)
    return function()
        local target = adjacent_workspace(dir)
        if target then
            hl.dispatch(hl.dsp.focus({ workspace = "name:" .. target }))
        end
    end
end

bind({mainMod, "B"},                         hl.dsp.focus({ workspace = "previous_per_monitor" }))
bind({mainMod, "SHIFT", "Tab"},              focus_adjacent_workspace(-1))
bind({mainMod, "Tab"},                       focus_adjacent_workspace(1))
bind({mainMod, "Left"},                      focus_adjacent_workspace(-1))
bind({mainMod, "Right"},                     focus_adjacent_workspace(1))
bind({mainMod, "mouse_left"},                focus_adjacent_workspace(-1))
bind({mainMod, "mouse_right"},               focus_adjacent_workspace(1))
bind({mainMod, "V"},                         hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/switch-workspace.sh"))
bind({mainMod, "SHIFT", "R"},                hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/rename-workspace.sh"))
bind({mainMod, "SHIFT", "comma"},            hl.dsp.workspace.move({ monitor = "l" }))
bind({mainMod, "SHIFT", "period"},           hl.dsp.workspace.move({ monitor = "r" }))
bind({mainMod, "SHIFT", "CONTROL", "Left"},  hl.dsp.workspace.move({ monitor = "l" }))
bind({mainMod, "SHIFT", "CONTROL", "Right"}, hl.dsp.workspace.move({ monitor = "r" }))
bind({mainMod, "SHIFT", "CONTROL", "Up"},    hl.dsp.workspace.move({ monitor = "u" }))
bind({mainMod, "SHIFT", "CONTROL", "Down"},  hl.dsp.workspace.move({ monitor = "d" }))
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Special workspace
bind({mainMod, "C"}, hl.dsp.window.move({ workspace = "special", follow = false }))
bind({mainMod, "S"}, hl.dsp.workspace.toggle_special("special"))
hl.gesture({ fingers = 4, direction = "vertical", action = "special", workspace_name = "special" })

-- Dwindle layout
bind({mainMod, "slash"}, hl.dsp.layout("togglesplit"))

-- Group
bind({mainMod, "T"}, function()
    local w = hl.get_active_window()
    if w == nil then
        return
    end
    if w.group == nil then
        hl.dispatch(hl.dsp.group.toggle())
    end
end)
bind({mainMod, "CONTROL", "T"}, function()
    local w = hl.get_active_window()
    if w == nil then
        return
    end
    if w.group ~= nil then
        hl.dispatch(hl.dsp.group.toggle())
    end
end)
bind({mainMod, "P"},          hl.dsp.group.prev())
bind({mainMod, "N"},          hl.dsp.group.next())
bind({mainMod, "mouse_up"},   hl.dsp.group.prev())
bind({mainMod, "mouse_down"}, hl.dsp.group.next())
bind({mainMod, "SHIFT", "P"}, hl.dsp.group.move_window({ forward = false }))
bind({mainMod, "SHIFT", "N"}, hl.dsp.group.move_window({ forward = true }))

-- Focused window
bind({mainMod, "CONTROL", "C"},     hl.dsp.window.close())
bind({mainMod, "space"},            hl.dsp.window.cycle_next({ floating = true }))
bind({mainMod, "space"},            hl.dsp.window.alter_zorder({ mode = "top" }))
bind({mainMod, "CONTROL", "space"}, hl.dsp.window.cycle_next({ tiled = true }))
bind({mainMod, "SHIFT", "space"},   hl.dsp.window.float({ action = "toggle" }))
bind({mainMod, "F"},                hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
bind({mainMod, "CONTROL", "F"},     hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
bind({mainMod, "SHIFT", "S"},       hl.dsp.window.pin())

-- Move focus
bind({mainMod, "H"}, hl.dsp.focus({ direction = "l" }))
bind({mainMod, "L"}, hl.dsp.focus({ direction = "r" }))
bind({mainMod, "K"}, hl.dsp.focus({ direction = "u" }))
bind({mainMod, "J"}, hl.dsp.focus({ direction = "d" }))

-- Move focused window
bind({mainMod, "SHIFT", "H"},   hl.dsp.window.move({ direction = "l" }))
bind({mainMod, "SHIFT", "L"},   hl.dsp.window.move({ direction = "r" }))
bind({mainMod, "SHIFT", "K"},   hl.dsp.window.move({ direction = "u" }))
bind({mainMod, "SHIFT", "J"},   hl.dsp.window.move({ direction = "d" }))
bind({mainMod, "CONTROL", "H"}, hl.dsp.window.move({ direction = "l", group_aware = true }))
bind({mainMod, "CONTROL", "L"}, hl.dsp.window.move({ direction = "r", group_aware = true }))
bind({mainMod, "CONTROL", "K"}, hl.dsp.window.move({ direction = "u", group_aware = true }))
bind({mainMod, "CONTROL", "J"}, hl.dsp.window.move({ direction = "d", group_aware = true }))
bind({mainMod, "M"},            hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/move-to-workspace.sh"))
bind({mainMod, "SHIFT", "M"},   hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/move-to-workspace-silent.sh"))

-- Move/resize windows with mainMod + LMB/RMB and dragging
bind({mainMod, "mouse:272"}, hl.dsp.window.drag(), { mouse = true })
bind({mainMod, "mouse:273"}, hl.dsp.window.resize(), { mouse = true })
bind({mainMod, "mouse:274"}, hl.dsp.window.close())

-- Magnifier
local function zoom(r)
    local factor = hl.get_config("cursor.zoom_factor")
    hl.config({ cursor = { zoom_factor = math.max(factor * r, 1) } })
end
local zoom_coef = 2 ^ (1 / 2)
bind({mainMod, "Page_Up"},               function() zoom(zoom_coef)     end)
bind({mainMod, "Page_Down"},             function() zoom(1 / zoom_coef) end)
bind({mainMod, "Equal"},                 function() zoom(zoom_coef)     end)
bind({mainMod, "Minus"},                 function() zoom(1 / zoom_coef) end)
bind({mainMod, "CONTROL", "mouse_up"},   function() zoom(zoom_coef)     end)
bind({mainMod, "CONTROL", "mouse_down"}, function() zoom(1 / zoom_coef) end)
hl.gesture({
    fingers = 3,
    direction = "vertical",
    mods = mainMod,
    action = {
        start  = function(e) zoom(zoom_coef ^ (-0.025 * e.delta.y)) end,
        update = function(e) zoom(zoom_coef ^ (-0.025 * e.delta.y)) end,
    },
})

-- Screen capture
local grimblast = "grimblast --notify save"
local cwebp = "cwebp -lossless -q 100 -m 6 -mt"
bind({         "Print"},            hl.dsp.exec_cmd(grimblast .. " screen - | " .. cwebp .. " -o ~/Pictures/screen_$(date +%Y-%m-%d-%H%M%S).webp -- -"))
bind({mainMod, "Print"},            hl.dsp.exec_cmd(grimblast .. " output - | " .. cwebp .. " -o ~/Pictures/output_$(date +%Y-%m-%d-%H%M%S).webp -- -"))
bind({         "SHIFT", "Print"},   hl.dsp.exec_cmd(grimblast .. " active - | " .. cwebp .. " -o ~/Pictures/active_$(date +%Y-%m-%d-%H%M%S).webp -- -"))
bind({         "CONTROL", "Print"}, hl.dsp.exec_cmd(grimblast .. " area   - | " .. cwebp .. " -o ~/Pictures/area_$(date +%Y-%m-%d-%H%M%S).webp   -- -"))
bind({         "CONTROL", "SHIFT", "Print"}, hl.dsp.exec_cmd('grim -g "$(slurp)" -t ppm - | tesseract -l eng stdin stdout | wl-copy'))

-- Rofi
local findUserDirs = os.getenv("HOME") .. "/.config/hypr/find-user-dirs.sh"
local findPapers = os.getenv("HOME") .. "/.config/hypr/find-papers.sh"
bind({mainMod, "SHIFT", "F"},   hl.dsp.exec_cmd(rofi .. " -show window"))
bind({mainMod, "SHIFT", "D"},   hl.dsp.exec_cmd("path=$(" .. findUserDirs .. " | " .. rofi .. " -dmenu -i -p \"Open a directory\"); if [ -n \"$path\" ]; then xdg-open \"$path\"; fi"))
bind({mainMod, "SHIFT", "T"},   hl.dsp.exec_cmd("path=$(" .. findUserDirs .. " | " .. rofi .. " -dmenu -i -p \"Open a terminal with a directory\"); if [ -n \"$path\" ]; then " .. terminal .. " --working-directory \"$path\"; fi"))
bind({mainMod, "CONTROL", "P"}, hl.dsp.exec_cmd("path=$(" .. findPapers   .. " | " .. rofi .. " -dmenu -i -p \"Open a paper\" -theme-str \"window { width: 50%; }\"); if [ -n \"$path\" ]; then xdg-open \"$HOME/Literature/$path\"; fi"))

bind({mainMod, "CONTROL", "D"}, hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/show-display-menu.sh"))

-- swaync
bind({mainMod, "CONTROL", "N"}, hl.dsp.exec_cmd("swaync-client -t"))

-- Audio control
bind({"XF86AudioRaiseVolume"}, hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),     { locked = true, repeating = true })
bind({"XF86AudioLowerVolume"}, hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),     { locked = true, repeating = true })
bind({"XF86AudioMute"},        hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"),     { locked = true, repeating = true })
bind({"XF86AudioMicMute"},     hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true, repeating = true })

-- Debug
bind({mainMod, "F12"}, hl.dsp.exec_cmd("hyprctl -j activewindow | wl-copy"))


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-- Change the border color for maximized windows
hl.window_rule({ border_color = { colors = {"rgba(ccff33ee)", "rgba(ff7a33ee)"}, angle = 45 }, match = { fullscreen_state_client = 1 } })

-- Make some windows floating by default
hl.window_rule({ float = true, match = { class = "^(org.gnome.Calculator)$" } })
hl.window_rule({ float = true, match = { title = "^(New Text Note — Okular)$" } })
hl.window_rule({ float = true, match = { class = "^(blender-5.0)$" } })
hl.window_rule({ float = true, match = { class = "^(wdisplays)$" } })
hl.window_rule({ float = true, match = { class = "^(geeqie)$", title = "(Move - Geeqie)" } })
hl.window_rule({ float = true, match = { class = "^(nemo)$", title = "^(.*Properties)$" } })
hl.window_rule({ float = true, match = { class = "^(org.inkscape.Inkscape)$", title = "(SVG Input)" } })
hl.window_rule({ float = true, match = { class = "^()$", title = "(Picture in picture)" } })  -- Chrome's picture in picture window
hl.window_rule({ float = true, match = { class = "^(firefox)$", title = "(Picture-in-Picture)" } })  -- Firefox's picture in picture window
hl.window_rule({ float = true, match = { class = "^(file-.*)$", title = "^(Export Image as .*)$" } })  -- GIMP

-- Games
hl.window_rule({ workspace = "game", match = { class = "^(steam)$" } })
hl.window_rule({ workspace = "game", match = { title = "^(Steam)$" } })
hl.window_rule({ tag = "+game", match = { class = "^(Minecraft)" } })
hl.window_rule({ tag = "+game", match = { class = "^(steam_app_1808500)$" } })  -- ARC Raiders
hl.window_rule({ tag = "+game", match = { class = "^(steam_app_949230)$" } })  -- Cities: Skylines II
hl.window_rule({ tag = "+game", match = { class = "^(steam_app_526870)$" } })  -- Satisfactory
hl.window_rule({ tag = "+game", match = { class = "^(steam_app_2489330)$" } })  -- Whiskerwood
hl.window_rule({
    name = "game-windows",
    match = { tag = "game" },
    float = true,
    fullscreen = true,
    content = "game",
    workspace = "game",
})

-- Firefox's own notification windows
hl.window_rule({ tag = "+firefox-notification", match = { class = "^(firefox)$", title = "^()$" } })
hl.window_rule({ match = { tag = "firefox-notification" }, float = true })
hl.window_rule({ match = { tag = "firefox-notification" }, move = "100%-w-20 20" })
hl.window_rule({ match = { tag = "firefox-notification" }, pin = true })
hl.window_rule({ match = { tag = "firefox-notification" }, no_initial_focus = true })
hl.window_rule({ match = { tag = "firefox-notification" }, suppress_event = "activate activatefocus" })
hl.window_rule({ match = { tag = "firefox-notification" }, border_size = 0 })

-- Modal windows
-- Pin entry windows
hl.window_rule({ tag = "+modal", match = { class = "^(pinentry-.*|hyprpolkitagent|gcr-prompter)$" } })
-- File open/save dialogs
hl.window_rule({ tag = "+modal", match = { class = "^(xdg-desktop-portal-gtk)$" } })
hl.window_rule({ tag = "+modal", match = { class = "^(firefox)$, match:title ^(Save Image)$" } })
hl.window_rule({ tag = "+modal", match = { class = "^(mozc_tool)$, match:title ^(export to file|import from file)$" } })
hl.window_rule({ tag = "+modal", match = { class = "^(nemo)$, match:title ^(Select Target Folder For Move)$" } })
-- Rules
hl.window_rule({ match = { tag = "modal" }, float = true })
hl.window_rule({ match = { tag = "modal" }, stay_focused = true })
hl.window_rule({ match = { tag = "modal" }, dim_around = true })

-- Idle inhibit rules
hl.window_rule({ idle_inhibit = "focus", match = { class = "^(mpv)$" } })

-- Disable blur
hl.window_rule({ no_blur = true, match = { class = "^()$", title = "^()$" } })  -- For Google Chrome's menus

-- Layer rules
hl.layer_rule({ match = { namespace = "waybar" }, blur = true })
hl.layer_rule({ match = { namespace = "rofi" }, dim_around = true, blur = true, animation = "fade" })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, dim_around = true, animation = "slide right" })

-- Workspace rules
hl.workspace_rule({ workspace = "s[true]", gaps_in = 24, gaps_out = 48 })


----------------------------
--- HOST-SPECIFIC CONFIG ---
----------------------------
local function get_hostname()
    local f = io.popen("hostname")
    if not f then return nil end
    local name = f:read("*l")  -- read one line
    f:close()
    return name
end

require("host_specific." .. get_hostname())
