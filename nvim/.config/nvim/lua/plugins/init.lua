return {
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        opts = require "configs.conform",
    },

    {
        "neovim/nvim-lspconfig",
        config = function()
            require "configs.lspconfig"
        end,
    },

    {
        "windwp/nvim-autopairs",
        opts = {
            enable_check_bracket_line = false,
        },
    },
    {
        "folke/which-key.nvim",
        opts = {
            keys = {
                scroll_down = "<c-j>", -- binding to scroll down inside the popup
                scroll_up = "<c-k>", -- binding to scroll up inside the popup
            },
        },
    },
}
