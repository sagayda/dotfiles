return {
  {
    "iabdelkareem/csharp.nvim",
    ft = "cs",
    dependencies = {
      "williamboman/mason.nvim", -- Required, automatically installs omnisharp
      "mfussenegger/nvim-dap",
      "Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
    },
    opts = {
      lsp = {
        omnisharp = {
          enable = false,
        },
      },
    },
  },
  {
    "Hoffs/omnisharp-extended-lsp.nvim",
    ft = "cs",
  },
}
