local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    scss = { "prettier" },
    css = { "prettier" },
    c = { "my_formatter" },
    cpp = { "my_formatter" },
    xml = { "xstyler" },
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
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
