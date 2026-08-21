local M = {}

function M.group_active_window()
    local w = hl.get_active_window()
    if w == nil then
        return
    end
    if w.group == nil then
        hl.dispatch(hl.dsp.group.toggle())
    end
end

return M
