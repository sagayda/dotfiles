require "nvchad.mappings"
local map = vim.keymap.set

map({ "n", "v" }, "<leader>rr", function()
    require("nvchad.term").runner { pos = "bo sp", id = "run", cmd = "lua init.lua" }
end, { desc = "Run dotnet project" })
