local M = {}

local config = require "modesearch.config"
local core = require "modesearch.core"
local state = require "modesearch.state"

M.prompt = {}
M.mode = {}

function M.prompt.show(mode_name)
    local mode = config.options.modes[mode_name]
    if mode == nil then
        error("Mode '" .. mode_name .. "' is not defined.")
    end
    state.current_mode_name = mode_name
    return core.prompt()
end

---@param mode_names string[]
function M.mode.cycle(mode_names)
    local index = nil
    for i, name in ipairs(mode_names) do
        if state.current_mode_name == name then
            index = i
            break
        end
    end
    if index == nil then
        return ""
    end
    if index >= #mode_names then
        index = index % #mode_names
    end
    local next_mode_name = mode_names[index + 1]
    if config.options.modes[next_mode_name] == nil then
        error("Mode '" .. next_mode_name .. "' is not defined.")
    end
    state.current_mode_name = next_mode_name
    return core.exprstr "<CR>"
end

return M
