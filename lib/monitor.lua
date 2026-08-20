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
        return false
    end
    hl.monitor({ output = target, disabled = true })
    return true
end

---@param target string
function M.enable(target)
    hl.monitor({ output = target, disabled = false })
end

return M
