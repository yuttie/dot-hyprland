local M = {}

---@return string|nil
function M.get_hostname()
    local f = io.popen("hostname")
    if not f then return nil end
    local name = f:read("*l")  -- read one line
    f:close()
    return name
end

return M
