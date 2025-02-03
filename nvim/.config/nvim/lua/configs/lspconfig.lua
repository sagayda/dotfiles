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

    -- csharp_ls = {
    --     handlers = {
    --         ["textDocument/definition"] = require("csharpls_extended").handler,
    --         ["textDocument/typeDefinition"] = require("csharpls_extended").handler,
    --     },
    --     on_attach = function(client) -- for overload selection
    --         if client.server_capabilities.signatureHelpProvider then
    --             vim.api.nvim_set_keymap("n", "<A-s>", ":LspOverloadsSignature<CR>", { noremap = true, silent = true })
    --             vim.api.nvim_set_keymap(
    --                 "i",
    --                 "<A-s>",
    --                 "<cmd>LspOverloadsSignature<CR>",
    --                 { noremap = true, silent = true }
    --             )
    --         end
    --     end,
    --     capabilities = {
    --         workspace = {
    --             didChangeWatchedFiles = {
    --                 dynamicRegistration = true,
    --             },
    --         },
    --     },
    -- },

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
                vim.api.nvim_set_keymap(
                    "i",
                    "<A-s>",
                    "<cmd>LspOverloadsSignature<CR>",
                    { noremap = true, silent = true }
                )
            end
        end,
        capabilities = {
            workspace = {
                didChangeWatchedFiles = {
                    dynamicRegistration = true,
                },
            },
        },
        settings = {
            MsBuild = {
                -- LoadProjectsOnDemand = true,
            },

            RoslynExtensionsOptions = {
                -- EnableAnalyzersSupport = true,
                -- EnableImportCompletion = true,
                EnableDecompilationSupport = true,
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
