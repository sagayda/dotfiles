vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.foldlevel = 99

require "nvchad.mappings"

local map = vim.keymap.set

map("n", "<leader>ra", require "nvchad.lsp.renamer", { desc = "NvRenamer" })
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

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

-- local wk = require "which-key"
--
-- wk.add {
--   {
--     "<leader>gd",
--     "<cmd>lua require('omnisharp_extended').lsp_definition()<cr>",
--     desc = "Go to definition",
--     mode = "n",
--   },
--   {
--     "<leader>D",
--     "<cmd>lua require('omnisharp_extended').lsp_type_definition()<cr>",
--     desc = "Go to type definition",
--     mode = "n",
--   },
--   {
--     "<leader>gr",
--     "<cmd>lua require('omnisharp_extended').telescope_lsp_references()<cr>",
--     desc = "Telescope references",
--     mode = "n",
--   },
--   {
--     "<leader>gi",
--     "<cmd>lua require('omnisharp_extended').lsp_implementation()<cr>",
--     desc = "Go to implementation",
--     mode = "n",
--   },
-- }
