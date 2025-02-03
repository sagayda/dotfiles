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
    -- backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
    highlight_on_hover = true,
    manage_folds = true,
    show_guides = true,
}
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")

local luasnip = require "luasnip"
local cmp = require "cmp"

cmp.setup {
    enabled = function()
        local is_floating = vim.api.nvim_win_get_config(0).relative ~= ""
        -- local is_snip = require("luasnip").in_snippet()
        if is_floating then
            return false
        end
        return true
    end,
    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                if not cmp.get_active_entry() then
                    cmp.select_next_item { count = 0 }
                else
                    cmp.select_next_item()
                end
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                if not cmp.get_active_entry() then
                    cmp.select_prev_item { count = 0 }
                else
                    cmp.select_prev_item()
                end
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(1) then
                luasnip.jump(1)
            elseif cmp.visible() then
                cmp.confirm {
                    select = true,
                }
            else
                fallback()
            end
        end, { "i", "s" }),
    },
}

vim.treesitter.language.register("xml", "axaml")

-- require("luasnip").filetype_extend("cs", { "unity" })
-- require("luasnip").filetype_extend("cs", { "csharpdoc" })

local function escape(str)
    -- Эти символы должны быть экранированы, если встречаются в langmap
    local escape_chars = [[;,."|\]]
    return vim.fn.escape(str, escape_chars)
end

-- Наборы символов, введенных с зажатым шифтом
local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]
-- Наборы символов, введенных как есть
-- Здесь я не добавляю ',.' и 'бю', чтобы впоследствии не было рекурсивного вызова комманды
local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
vim.opt.langmap = vim.fn.join({
    --  ; - разделитель, который не нужно экранировать
    --  |
    escape(ru_shift)
        .. ";"
        .. escape(en_shift),
    escape(ru) .. ";" .. escape(en),
}, ",")
