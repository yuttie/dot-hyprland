local M = {}

--- Move the active window to a workspace, together with the rest of its
--- group if it is in one.
---@param workspace HL.WorkspaceSelector
---@param follow boolean
function M.move_to_workspace(workspace, follow)
    hl.dispatch(hl.dsp.window.move({ workspace = workspace, follow = follow }))
end

--- Move the active window alone to a workspace. If it shares a group with
--- other windows, take it out of the group first so they stay behind.
---@param workspace HL.WorkspaceSelector
---@param follow boolean
function M.move_single_to_workspace(workspace, follow)
    local w = hl.get_active_window()
    if w == nil then
        return
    end
    if w.group ~= nil and w.group.size > 1 then
        hl.dispatch(hl.dsp.window.move({ window = w, out_of_group = true }))
    end
    hl.dispatch(hl.dsp.window.move({ window = w, workspace = workspace, follow = follow }))
end

return M
