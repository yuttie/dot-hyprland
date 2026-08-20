local M = {}

local function count_other_monitors(target)
    local n = 0
    for _, mon in ipairs(hl.get_monitors()) do
        if mon.name ~= target then
            n = n + 1
        end
    end
    return n
end

---@param target string
---@return boolean ok
function M.disable(target)
    if count_other_monitors(target) == 0 then
        hl.notification.create({
            text = ("Refusing to disable %s: no other active monitor found"):format(target),
            timeout = 5000,
            color = "rgb(ff5555)",
        })
        return false
    end
    hl.monitor({ output = target, disabled = true })
    return true
end

return M
