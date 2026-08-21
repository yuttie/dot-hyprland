local M = {}

---@param r number
function M.zoom(r)
    local factor = hl.get_config("cursor.zoom_factor")
    hl.config({ cursor = { zoom_factor = math.max(factor * r, 1) } })
end

return M
