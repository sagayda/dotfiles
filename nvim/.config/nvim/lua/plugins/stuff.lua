return {
    {
        "elkowar/yuck.vim",
        -- lazy = false,
        ft = "yuck",
    },
    {
        "NStefan002/speedtyper.nvim",
        cmd = "Speedtyper",
        opts = {},
    },
    {
        "lambdalisue/vim-suda",
        cmd = { "SudaWrite", "SudaRead" },
    },
    {
        "vimwiki/vimwiki",
        lazy = false,
    },
    {
        "Fildo7525/pretty_hover",
        event = "LspAttach",
        opts = {},
    },
    {
        "folke/todo-comments.nvim",
        lazy = false,
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
    {
        "stevearc/aerial.nvim",
        opts = {},
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "chrisgrieser/nvim-spider",
        keys = {
            {
                "e",
                "<cmd>lua require('spider').motion('e')<CR>",
                mode = { "n", "o", "x" },
            },
            {
                "w",
                "<cmd>lua require('spider').motion('w')<CR>",
                mode = { "n", "o", "x" },
            },

            {
                "b",
                "<cmd>lua require('spider').motion('b')<CR>",
                mode = { "n", "o", "x" },
            },
        },
    },
    {
        "onsails/lspkind.nvim",
    },
    {
        "gbprod/cutlass.nvim",
        lazy = false,
        opts = {
            cut_key = "x",
        },
    },
}
