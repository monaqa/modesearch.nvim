local M = {}

local config = require("modesearch.config")
local core = require("modesearch.core")
local state = require("modesearch.state")

M.keymap = require("modesearch.keymap")

local augroup = vim.api.nvim_create_augroup("modesearch", {})

function M.setup(tbl)
    config.setup(tbl)

    vim.api.nvim_create_autocmd("CmdlineLeave", {
        group = augroup,
        pattern = "*",
        callback = core.highlight_clear,
    })

    vim.api.nvim_create_autocmd("CmdlineChanged", {
        pattern = "@",
        callback = function()
            if state.prompt_active then
                core.highlight_clear()
                core.highlight_paint()
            end
        end,
    })
end

return M
