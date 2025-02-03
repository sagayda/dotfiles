vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.foldlevel = 99

require("telescope").load_extension "csharpls_definition"
require "nvchad.mappings"

map = vim.keymap.set

-- map("n", "<leader>ra", require "nvchad.lsp.renamer", { desc = "NvRenamer" })
-- map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
-- map("n", "<leader>gd", "<cmd>Telescope csharpls_definition<cr>", { desc = "Telescope definition" })
-- map("n", "<leader>gi", "<cmd>Telescope lsp_implementations<cr>", { desc = "Telescope implementation" })
-- map("n", "<leader>gr", "<cmd>Telescope lsp_references<cr>", { desc = "Telescope references" })

map("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>ra", require "nvchad.lsp.renamer", { desc = "NvRenamer" })

map("n", "<leader>gd", "<cmd>lua require('omnisharp_extended').lsp_definition()<cr>", { desc = "Go to definition" })
map(
    "n",
    "<leader>D",
    "<cmd>lua require('omnisharp_extended').lsp_type_definition()<cr>",
    { desc = "Go to type definition" }
)
map(
    "n",
    "<leader>gr",
    "<cmd>lua require('omnisharp_extended').telescope_lsp_references()<cr>",
    { desc = "Telescope references" }
)
map(
    "n",
    "<leader>gi",
    "<cmd>lua require('omnisharp_extended').lsp_implementation()<cr>",
    { desc = "Go to implementation" }
)
