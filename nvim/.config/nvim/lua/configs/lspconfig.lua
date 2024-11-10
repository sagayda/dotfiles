-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls", "clangd", "cmake", "hyprls", "somesass_ls", "omnisharp", "lemminx" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

lspconfig.omnisharp.setup {
  cmd = { "dotnet", "/home/lira/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll" },
}

local configs = require "lspconfig.configs"
local root_pattern = require("lspconfig.util").root_pattern

local dotnet_path = "/usr/bin/dotnet"
local avalonia_lsp_path = "/home/lira/scripts/bin/avalonia-lsp/avalonia-server/AvaloniaLanguageServer.dll"
local avalonia_parser_path = "/home/lira/scripts/bin/avalonia-lsp/solution-parser/SolutionParser.dll"

if not configs.avalonia then
  configs.avalonia = {
    default_config = {
      name = "Avalonia LSP",
      cmd = {
        dotnet_path,
        avalonia_lsp_path,
      },
      root_dir = root_pattern "*.csproj",
      filetypes = { "axaml", "xml" },
      on_init = function(client)
        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = { "*.axaml" },
          command = string.format("!%s '%s' '%s' >/dev/null", dotnet_path, avalonia_parser_path, client.root_dir),
        })
      end,
    },
  }
end

lspconfig.avalonia.setup {
  settings = {},
}

-- lspconfig.some_sass_language_server.setup {
--   filetypes = "scss"
-- }
-- lspconfig.hyprls.setup {
--   filetypes = "hyprlang",
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
