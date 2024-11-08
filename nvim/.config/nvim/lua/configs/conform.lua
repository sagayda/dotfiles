local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    scss = { "prettier" },
    css = { "prettier" },
    c = { "my_formatter" },
    cpp = { "my_formatter" },
  },

   formatters = {
    my_formatter = {
      command = 'clang-format',
      args = '--style="{BasedOnStyle: microsoft}"',
    }
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
