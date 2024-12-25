local configs = require "nvchad.configs.lspconfig"

require("lspconfig.configs").avalonia = {
  default_config = {
    name = "Avalonia LSP",
    cmd = {
      "/usr/bin/dotnet",
      "/home/lira/scripts/bin/avalonia-lsp/avalonia-server/AvaloniaLanguageServer.dll",
    },
    root_dir = require("lspconfig.util").root_pattern "*.csproj",
    filetypes = { "axaml" },
  },
}

local servers = {
  lua_ls = {},
  bashls = {},
  html = {},
  cssls = {},
  clangd = {},
  cmake = {},
  hyprls = {},
  somesass_ls = {},
  avalonia = {
    on_attach = function(client)
      vim.api.nvim_set_keymap(
        "",
        "<leader>B",
        string.format(
          "<Cmd>!%s '%s' '%s' <CR>",
          "/usr/bin/dotnet",
          "/home/lira/scripts/bin/avalonia-lsp/solution-parser/SolutionParser.dll",
          client.root_dir
        ),
        { noremap = true, desc = "Build Avalonia project", silent = true }
      )
    end,
  },

  lemminx = {
    filetypes = { "xml", "axaml" },
  },

  omnisharp = {
    cmd = { "dotnet", "/home/lira/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll" },
    handlers = {
      ["textDocument/definition"] = function(...)
        return require("omnisharp_extended").handler(...)
      end,
    },
    on_attach = function(client) -- for overload selection
      if client.server_capabilities.signatureHelpProvider then
        vim.api.nvim_set_keymap("n", "<A-s>", ":LspOverloadsSignature<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("i", "<A-s>", "<cmd>LspOverloadsSignature<CR>", { noremap = true, silent = true })
      end
    end,
    settings = {
      RoslynExtensionsOptions = {
        -- EnableAnalyzersSupport = true,
        EnableImportCompletion = true,
      },
    },
  },
}

for name, opts in pairs(servers) do
  --   opts.on_attach = configs.on_attach
  if opts.on_attach == nil then
    opts.on_attach = configs.on_attach
  end

  -- opts.on_init = configs.on_init
  if opts.on_init == nil then
    opts.on_init = configs.on_init
  end

  -- opts.capabilities = configs.capabilities
  if opts.capabilities == nil then
    opts.capabilities = configs.capabilities
  end

  require("lspconfig")[name].setup(opts)
end

-- <==>

-- -- load defaults i.e lua_lsp
-- require("nvchad.configs.lspconfig").defaults()
--
-- local lspconfig = require "lspconfig"
--
-- -- EXAMPLE
-- local servers = { "html", "cssls", "clangd", "cmake", "hyprls", "somesass_ls", "omnisharp", "lemminx" }
-- local nvlsp = require "nvchad.configs.lspconfig"
--
-- -- lsps with default config
-- for _, lsp in ipairs(servers) do
--   lspconfig[lsp].setup {
--     on_attach = nvlsp.on_attach,
--     on_init = nvlsp.on_init,
--     capabilities = nvlsp.capabilities,
--   }
-- end
--
-- lspconfig.omnisharp.setup {
--   cmd = { "dotnet", "/home/lira/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll" },
--   on_attach = function(client) -- for overload selection
--     if client.server_capabilities.signatureHelpProvider then
--       vim.api.nvim_set_keymap("n", "<A-s>", ":LspOverloadsSignature<CR>", { noremap = true, silent = true })
--       vim.api.nvim_set_keymap("i", "<A-s>", "<cmd>LspOverloadsSignature<CR>", { noremap = true, silent = true })
--     end
--   end,
-- }
--
-- lspconfig.lemminx.setup {
--   filetypes = { "xml", "axaml" },
-- }
--
-- local configs = require "lspconfig.configs"
-- local root_pattern = require("lspconfig.util").root_pattern
--
-- local dotnet_path = "/usr/bin/dotnet"
-- local avalonia_lsp_path = "/home/lira/scripts/bin/avalonia-lsp/avalonia-server/AvaloniaLanguageServer.dll"
-- local avalonia_parser_path = "/home/lira/scripts/bin/avalonia-lsp/solution-parser/SolutionParser.dll"
--
-- if not configs.avalonia then
--   configs.avalonia = {
--     default_config = {
--       name = "Avalonia LSP",
--       cmd = {
--         -- i have no fck clue what it this, but it enables avalonia on any C# projects
--         dotnet_path,
--         avalonia_lsp_path,
--       },
--       root_dir = root_pattern "*.csproj",
--       filetypes = { "axaml" },
--       -- on_init = function(client)
--       --   vim.api.nvim_create_autocmd("BufWritePost", {
--       --     pattern = { "*.axaml" },
--       --     command = string.format("!%s '%s' '%s' >/dev/null", dotnet_path, avalonia_parser_path, client.root_dir),
--       --   })
--       -- end,
--       on_attach = function(client)
--         vim.api.nvim_set_keymap(
--           "",
--           "<leader>cA",
--           string.format("<Cmd>!%s '%s' '%s' >/dev/null<CR>", dotnet_path, avalonia_parser_path, client.root_dir),
--           { noremap = true, desc = "Build Avalonia project", silent = true }
--         )
--       end,
--     },
--   }
-- end
--
-- lspconfig.avalonia.setup {
--   settings = {},
-- }
--
-- -- lspconfig.some_sass_language_server.setup {
-- --   filetypes = "scss"
-- -- }
-- -- lspconfig.hyprls.setup {
-- --   filetypes = "hyprlang",
-- --   on_attach = nvlsp.on_attach,
-- --   on_init = nvlsp.on_init,
-- --   capabilities = nvlsp.capabilities,
-- -- }
--
-- -- configuring single server, example: typescript
-- -- lspconfig.ts_ls.setup {
-- --   on_attach = nvlsp.on_attach,
-- --   on_init = nvlsp.on_init,
-- --   capabilities = nvlsp.capabilities,
-- -- }
