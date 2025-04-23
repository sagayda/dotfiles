local configs = require "nvchad.configs.lspconfig"

require("lspconfig.configs").avalonia = {
    default_config = {
        name = "Avalonia LSP",
        cmd = {
            -- "/usr/bin/dotnet",
            -- "/home/lira/scripts/bin/avalonia-lsp/avalonia-server/AvaloniaLanguageServer.dll",
            "avalonia-ls",
        },
        root_dir = require("lspconfig.util").root_pattern "*.csproj",
        filetypes = { "axaml" },
    },
}

-- local cap = vim.tbl_deep_extend(
--     "force",
--     vim.lsp.protocol.make_client_capabilities(),
--     require("cmp_nvim_lsp").default_capabilities()
-- )
--
-- local cap = vim.lsp.protocol.make_client_capabilities()
-- cap.workspace.didChangeWatchedFiles.dynamicRegistration = true

local servers = {
    lua_ls = {
        on_init = function(client)
            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if
                    path ~= vim.fn.stdpath "config"
                    and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
                then
                    return
                end
            end

            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                runtime = {
                    version = "LuaJIT",
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                        "/usr/share/lua/5.4/",
                        "/usr/share/lua/5.3/",
                    },
                },
            })
        end,
        settings = {
            Lua = {
                diagnostics = {
                    disable = {
                        "undefined-global",
                        "lowercase-global",
                    },
                },
            },
        },
    },
    mesonlsp = {},
    vala_ls = {},
    bashls = {},
    html = {},
    cssls = {},
    clangd = {},
    cmake = {},
    hyprls = {},
    somesass_ls = {},
    glsl_analyzer = {},
    avalonia = {
        on_attach = function(client)
            vim.api.nvim_set_keymap(
                "",
                "<leader>B",
                string.format("<Cmd>!%s '%s' <CR>", "avalonia-solution-parser", client.root_dir),
                { noremap = true, desc = "Build Avalonia project", silent = true }
            )
        end,
    },

    lemminx = {
        filetypes = { "xml", "axaml" },
    },

    csharp_ls = {
        -- cmd = { "csharp-ls", "--loglevel", "error" },
        cmd = { "/home/lira/.local/share/nvim/mason/bin/csharp-ls" },
        -- handlers = {
        --     ["textDocument/definition"] = require("csharpls_extended").handler,
        --     ["textDocument/typeDefinition"] = require("csharpls_extended").handler,
        -- },
        on_attach = function(client) -- for overload selection
            if client.server_capabilities.signatureHelpProvider then
                -- require("lsp-overloads").setup(client, { ui = { border = "rounded" } })
                require("lsp-overloads").setup(client)

                vim.api.nvim_set_keymap("n", "<A-s>", ":LspOverloadsSignature<CR>", { noremap = true, silent = true })
                vim.api.nvim_set_keymap(
                    "i",
                    "<A-s>",
                    "<cmd>LspOverloadsSignature<CR>",
                    { noremap = true, silent = true }
                )
            end
        end,
        -- capabilities.textDocument.completion.completionItem.snippetSupport = false
        capabilities = {
            textDocument = {
                completion = {
                    completionItem = {
                        snippetSupport = false,
                    },
                },
            },
            workspace = {
                didChangeWatchedFiles = {
                    dynamicRegistration = true,
                },
            },
        },
    },
    --
    -- omnisharp = {
    --     cmd = { "/usr/bin/omnisharp" },
    --     handlers = {
    --         ["textDocument/definition"] = function(...)
    --             return require("omnisharp_extended").handler(...)
    --         end,
    --     },
    --     on_attach = function(client)
    --         if client.server_capabilities.signatureHelpProvider then
    --             require("lsp-overloads").setup(client, { ui = { border = "rounded" } })
    --
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
    --     settings = {
    --         MsBuild = {
    --             -- LoadProjectsOnDemand = true,
    --         },
    --
    --         RoslynExtensionsOptions = {
    --             -- EnableAnalyzersSupport = true,
    --             -- EnableImportCompletion = true,
    --             EnableDecompilationSupport = true,
    --         },
    --     },
    -- },
}
function collect_keys(tbl, prefix, visited, out)
    prefix = prefix or ""
    visited = visited or {}
    out = out or {}

    if visited[tbl] then
        return out
    end
    visited[tbl] = true

    for key, value in pairs(tbl) do
        local full_key = prefix .. tostring(key)
        table.insert(out, full_key)

        if type(value) == "table" then
            collect_keys(value, full_key .. ".", visited, out)
        end
    end

    return out
end

for name, opts in pairs(servers) do
    --   opts.on_attach = configs.on_attach
    if opts.on_attach == nil then
        opts.on_attach = configs.on_attach
    end

    -- opts.on_init = configs.on_init
    if opts.on_init == nil then
        opts.on_init = configs.on_init
    end

    if opts.capabilities ~= nil then
        opts.capabilities =
            vim.tbl_deep_extend("force", require("cmp_nvim_lsp").default_capabilities(), opts.capabilities)
    else
        opts.capabilities = require("cmp_nvim_lsp").default_capabilities()
    end

    require("lspconfig")[name].setup(opts)

    if name == "csharp_ls" then
        require("csharpls_extended").buf_read_cmd_bind()
    end
end
