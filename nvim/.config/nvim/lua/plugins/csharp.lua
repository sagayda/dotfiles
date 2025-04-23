return {
    -- {
    --     "iabdelkareem/csharp.nvim",
    --     enable = false,
    --     ft = "cs",
    --     dependencies = {
    --         "williamboman/mason.nvim", -- Required, automatically installs omnisharp
    --         "mfussenegger/nvim-dap",
    --         "Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
    --     },
    --     opts = {
    --         lsp = {
    --             omnisharp = {
    --                 enable = false,
    --             },
    --         },
    --     },
    -- },
    {
        "Decodetalkers/csharpls-extended-lsp.nvim",
    },
    -- {
    --     "Hoffs/omnisharp-extended-lsp.nvim",
    -- },
    {
        "Issafalcon/lsp-overloads.nvim",
        -- cmd = { "LspOverloadsSignature" },
    },
    {
        "nvim-tree/nvim-tree.lua",
        opts = {
            filters = {
                custom = { "*.meta" },
            },
        },
    },
}
