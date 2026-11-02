local M = {}

--- Next (dir = 1) or previous (dir = -1) workspace on a monitor, by name
--- in lexicographic order, wrapping around. Single pass, no sorting.
---
--- Names need not be unique: workspace 2 renamed to "web" and a named
--- workspace "web" both show "web". Ties are broken by address, which
--- is unique, so that every workspace is reached.
---@param dir 1|-1
---@param mon? HL.MonitorSelector
---@param lt? fun(a: string, b: string): boolean
---@return HL.Workspace|nil
local function adjacent_workspace(dir, mon, lt)
    local monitor = mon and hl.get_monitor(mon) or hl.get_active_monitor()
    if not monitor then return nil end

    local current = hl.get_active_workspace(monitor)
    if not current then return nil end

    lt = lt or function(a, b) return a < b end
    ---@param a HL.Workspace
    ---@param b HL.Workspace
    local function less(a, b)
        if lt(a.name, b.name) then return true end
        if lt(b.name, a.name) then return false end
        return a.addressable_name < b.addressable_name
    end
    -- Searching backwards is the same search with the order flipped.
    local before = dir > 0 and less or function(a, b) return less(b, a) end

    local best, wrap = nil, nil
    for _, ws in ipairs(hl.get_workspaces()) do
        local m = ws.monitor
        if m and m.id == monitor.id and not ws.special then
            if before(current, ws) and (best == nil or before(ws, best)) then
                best = ws
            end
            if wrap == nil or before(ws, wrap) then
                wrap = ws
            end
        end
    end

    return best or wrap
end

---@param dir 1|-1
---@return function
function M.focus_adjacent(dir)
    return function()
        local target = adjacent_workspace(dir)
        if target then
            -- Pass the workspace itself, and Hyprland addresses it exactly.
            -- A rename changes only the name shown: workspace 2 renamed to
            -- "web" is still addressed as "2", and "name:web" would create
            -- a new, empty workspace instead of finding it.
            hl.dispatch(hl.dsp.focus({ workspace = target }))
        end
    end
end

return M
