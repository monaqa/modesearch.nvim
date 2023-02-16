local M = {}

---@class modesearchopts
M.defaults = {
    modes = {
        rawstr = {
            prompt = "[rawstr]/",
            converter = function(query)
                return [[\V]] .. vim.fn.escape(query, [[/\]])
            end,
        },
        regexp = {
            prompt = "[regexp]/",
            converter = function(query)
                return [[\v]] .. vim.fn.escape(query, [[/]])
            end,
        },
    },
    -- keymaps = {
    --     n = {
    --         ["/"] = modesearch.keymap.prompt.show "rawstr",
    --     },
    --     c = {
    --         ["<C-x>"] = modesearch.keymap.cycle_mode { "rawstr", "migemo", "regexp" },
    --     },
    -- },
}

---@type modesearchopts
M.options = {}

function M.setup(options)
    M.options = vim.tbl_deep_extend("force", {}, M.defaults, options or {})
end

return M
