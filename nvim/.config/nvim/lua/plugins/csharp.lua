return {
  {
    "iabdelkareem/csharp.nvim",
    ft = "cs",
    dependencies = {
      "williamboman/mason.nvim", -- Required, automatically installs omnisharp
      "mfussenegger/nvim-dap",
      "Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
      "Issafalcon/lsp-overloads.nvim",
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
  {
    "Issafalcon/lsp-overloads.nvim",
    opts = {
      keymaps = {
        next_signature = "<C-F>",
        previous_signature = "<C-G>",
        next_parameter = "<C-l>",
        previous_parameter = "<C-h>",
        close_signature = "<A-s>",
      },
    },
  },
}
