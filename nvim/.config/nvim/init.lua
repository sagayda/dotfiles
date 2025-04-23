vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
    {
        "NvChad/NvChad",
        lazy = false,
        branch = "v2.5",
        import = "nvchad.plugins",
    },

    { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
    require "mappings"
end)

require("aerial").setup {
    -- optionally use on_attach to set keymaps when aerial has attached to a buffer
    on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
    end,
    backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
    highlight_on_hover = true,
    manage_folds = false,
    show_guides = true,
}
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")

local luasnip = require "luasnip"
local cmp = require "cmp"
local lspkind = require "lspkind"

cmp.setup {
    completion = {
        completeopt = "menu,menuone,noselect",
    },
    sorting = { priority_weight = 2 },
    sources = cmp.config.sources {
        { name = "luasnip", kind = "" },
        { name = "nvim_lsp" },
        { name = "buffer" },
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            local kind = lspkind.cmp_format { mode = "symbol_text", maxwidth = 50 }(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = "    (" .. (strings[2] or "") .. ")"

            return kind
        end,
    },
    -- formatting = {
    --     format = lspkind.cmp_format {
    --         mode = "symbol_text",
    --         menu = {
    --             buffer = "[Buffer]",
    --             nvim_lsp = "[LSP]",
    --             luasnip = "[LuaSnip]",
    --             nvim_lua = "[Lua]",
    --             latex_symbols = "[Latex]",
    --         },
    --     },
    -- },
    enabled = function()
        local is_floating = vim.api.nvim_win_get_config(0).relative ~= ""
        -- local is_snip = require("luasnip").in_snippet()
        if is_floating then
            return false
        end
        return true
    end,
    experimental = {
        ghost_text = true,
    },
    preselect = cmp.PreselectMode.None,

    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                if not cmp.get_active_entry() then
                    cmp.select_next_item { count = 0, behavior = cmp.SelectBehavior.Select }
                else
                    cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                end
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                if not cmp.get_active_entry() then
                    cmp.select_prev_item { count = 0, { behavior = cmp.SelectBehavior.Select } }
                else
                    cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
                end
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                if cmp.get_active_entry() then
                    cmp.confirm {
                        select = true,
                    }
                elseif luasnip.locally_jumpable(1) then
                    luasnip.jump(1)
                else
                    cmp.select_next_item { count = 0, behavior = cmp.SelectBehavior.Select }
                    cmp.confirm { select = true }
                end
            elseif luasnip.locally_jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
}

vim.treesitter.language.register("xml", "axaml")

vim.lsp.handlers["window/showMessage"] = function(...) end

require "yank"
require "cyrilic"
require "configs.autocmds"
