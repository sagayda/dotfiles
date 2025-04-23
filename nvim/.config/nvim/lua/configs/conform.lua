local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        scss = { "prettier" },
        css = { "prettier" },
        c = { "my_formatter" },
        cpp = { "my_formatter" },
        xml = { "xstyler" },
        cs = { "my_csharpier" },
        glsl = { "glsl_analyzer" },
        vala = { "uncrustify" },
    },

    formatters = {
        my_formatter = {
            command = "clang-format",
            args = '--style="{BasedOnStyle: microsoft}"',
        },
        xmlformat = {
            prepend_args = { "--preserve", "Window" },
        },
        xstyler = {
            command = "/home/lira/.dotnet/tools/xstyler",
            stdin = false,
            args = { "-f", "$FILENAME" },
        },
        my_csharpier = {
            command = "csharpier",
            args = { "format", "$FILENAME", "--write-stdout" },
            stdin = true,
        },
        uncrustify = {
            args = function(self, ctx)
                return {
                    "-c",
                    "/home/lira/.config/uncrustify/default.cfg",
                    "-q",
                    "-l",
                    vim.bo[ctx.buf].filetype:upper(),
                }
            end,
        },
    },

    format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
    },
}

return options
