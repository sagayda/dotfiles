require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<C-a>", "<cmd>wa<CR>", { desc = "general save all files" })
map("n", "<S-k>", "<cmd>lua require('pretty_hover').hover()<cr>", { desc = "LSP hover" })

-- map("i", "jk", "<ESC>")

-- map({ "n", "f", "v" }, "<C-s>", "<cmd> w <cr>")
