local state = require "modesearch.state"
local config = require "modesearch.config"
local M = {}

---@param text string
---@return string
function M.exprstr(text)
    return vim.api.nvim_replace_termcodes(text, true, true, true)
end

---@alias converter fun(query: string): string
---@alias mode {prompt: string, converter: converter}

-- ---@type mode[]
-- local modes = {
--     {
--         name = "rawstr",
--         converter = function(query)
--             return [[\V]] .. vim.fn.escape(query, [[/\]])
--         end,
--     },
--     {
--         name = "migemo",
--         converter = function(query)
--             return [[\v]] .. vim.fn["kensaku#query"](query)
--         end,
--     },
--     {
--         name = "regexp",
--         converter = function(query)
--             return [[\v]] .. vim.fn.escape(query, [[/]])
--         end,
--     },
-- }

-- ---@param prev_mode mode
-- ---@return mode
-- local function default_mode_converter(prev_mode)
--     local new_mode_name = ({
--         ["rawstr"] = "migemo",
--         ["migemo"] = "regexp",
--         ["regexp"] = "rawstr",
--     })[prev_mode.name]
--     for _, mode in ipairs(modes) do
--         if mode.name == new_mode_name then
--             return mode
--         end
--     end
--     return modes[1]
-- end

-- local current_mode = modes[1]
-- local prompt_active = false

---@return string?
local function _prompt()
    local prev_mode_name = state.current_mode_name
    local prev_mode = config.options.modes[prev_mode_name]
    local query = vim.fn.input {
        prompt = prev_mode.prompt,
        cancelreturn = M.exprstr "<Nul>",
    }
    while state.current_mode_name ~= prev_mode_name do
        prev_mode_name = state.current_mode_name
        prev_mode = config.options.modes[prev_mode_name]
        query = vim.fn.input {
            prompt = prev_mode.prompt,
            default = query,
            cancelreturn = M.exprstr "<Nul>",
        }
    end
    if query == M.exprstr "<Nul>" then
        return nil
    end
    return query
end

function M.prompt()
    state.prompt_active = true
    local query = _prompt()
    state.prompt_active = false
    if query == nil then
        return ""
    end
    local search_cmd = "/"
    if query == "" then
        return search_cmd .. M.exprstr "<CR>"
    end
    local current_mode = config.options.modes[state.current_mode_name]
    return search_cmd .. current_mode.converter(query) .. M.exprstr "<CR>"
end

-- function M.change_mode()
--     if not prompt_active then
--         return ""
--     end
--     local new_mode = default_mode_converter(current_mode)
--     current_mode = new_mode
--     return M.exprstr "<CR>"
-- end

function M.highlight_paint()
    local query = vim.fn.getcmdline()
    if query == "" then
        return
    end
    local current_mode = config.options.modes[state.current_mode_name]
    local regex = current_mode.converter(query)
    local is_success, result = pcall(vim.fn.matchadd, "IncSearch", regex)
    if is_success then
        state.modesearch_match_id = result
    end
    vim.cmd.redraw()
end

function M.highlight_clear()
    if state.modesearch_match_id ~= nil then
        vim.fn.matchdelete(state.modesearch_match_id)
        state.modesearch_match_id = nil
    end
end

return M
