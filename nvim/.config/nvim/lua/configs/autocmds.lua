-- tsfolds

-- vim.api.nvim_create_autocmd({ "FileType" }, {
--     callback = function()
--         if require("nvim-treesitter.parsers").has_parser() then
--             print "ASD"
--             vim.opt.foldmethod = "expr"
--             vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
--             -- vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
--         else
--             vim.opt.foldexpr = "indent"
--         end
--     end,
-- })

-- open folds
vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
    command = "normal zR",
})

-- highlight yanks
vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank { timeout = 500 }
    end,
})
