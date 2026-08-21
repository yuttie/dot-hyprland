---@param keys string[]
---@param dispatcher any
local function bind(keys, dispatcher)
    return hl.bind(table.concat(keys, " + "), dispatcher)
end

return bind
