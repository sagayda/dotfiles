return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
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

  -- {
  --   "iabdelkareem/csharp.nvim",
  --   lazy = false,
  --   dependencies = {
  --     "williamboman/mason.nvim", -- Required, automatically installs omnisharp
  --     "mfussenegger/nvim-dap",
  --     "Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
  --   },
  --   config = function()
  --     require("mason").setup() -- Mason setup must run before csharp, only if you want to use omnisharp
  --     require("csharp").setup()
  --   end,
  --   opts = {
  --     lsp = {
  --       omnisharp = {
  --         enable = false,
  --       },
  --     },
  --   },
  -- },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
