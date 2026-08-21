local M = {}

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

---@param dir 1|-1
---@return function
function M.focus_adjacent(dir)
    return function()
        local target = adjacent_workspace(dir)
        if target then
            hl.dispatch(hl.dsp.focus({ workspace = "name:" .. target }))
        end
    end
end

return M
