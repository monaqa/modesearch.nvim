# 🔎 modesearch.nvim

Lua implementation of [modesearch.vim](https://github.com/monaqa/modesearch.vim).

# Installation

Follow the documentation of your favorite plugin manager.

# Usage

## Basic Usage

Setup example:

```lua
modesearch.setup {
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
}

vim.keymap.set({"n", "x"}, "/", function()
    modesearch.keymap.prompt.show "rawstr"
end)

vim.keymap.set("c", "<C-x>", function()
    modesearch.keymap.mode.cycle { "rawstr", "regexp" }
end)
```

## Integration with [kensaku.vim](https://github.com/lambdalisue/kensaku.vim)

The following plugins are additionally required:

* [vim-denops/denops.vim](https://github.com/vim-denops/denops.vim)
* [lambdalisue/kensaku.vim](https://github.com/lambdalisue/kensaku.vim)

```lua
modesearch.setup {
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
        migemo = {
            prompt = "[migemo]/",
            converter = function(query)
                return [[\v]] .. vim.fn["kensaku#query"](query)
            end,
        },
    },
}

vim.keymap.set({"n", "x"}, "/", function()
    modesearch.keymap.prompt.show "rawstr"
end)

vim.keymap.set("c", "<C-x>", function()
    modesearch.keymap.mode.cycle { "rawstr", "migemo", "regexp" }
end)
```
