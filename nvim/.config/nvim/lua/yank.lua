-- Minimal yank ring implementation
-- ─────────────────── DEFAULT BEHAVIOUR ─────────────────────────────
--
--           Almost all numbered registers are used
--              to store delete/change history
--                         ▲
--         ╭───────────────┴───────────────────╮
--     ╭───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───╮
--     │ ~ │ ! │ @ │ # │ $ │ % │ ^ │ & │ * │ ( │ ) │ _ │
--     │ ` │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │ 8 │ 9 │ 0 │ - │
--     ╰───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───╯
--                                             ╰─┬─╯
--                                               ▼
--                                     Only one register stores
--                                         the yank history
--
-- ─────────────────── MODIFIED BEHAVIOUR ────────────────────────────
--
--       First half is used to store
--          delete/change history
--                   ▲
--         ╭─────────┴─────────╮
--     ╭───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───╮
--     │ ~ │ ! │ @ │ # │ $ │ % │ ^ │ & │ * │ ( │ ) │ _ │
--     │ ` │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │ 8 │ 9 │ 0 │ - │
--     ╰───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───╯
--                             ╰─────────┬─────────╯
--                                       ▼
--                              Last half is used to
--                               store yank history
--
-- ─────────────── REGISTER ALLOCATION SCHEME ────────────────────────
-- ╭───┬──────────────────────────┬───┬──────────────────╮
-- │ 1 │ Last delete              │ 0 │ Last yank        │
-- │ 2 │ Second last delete       │ 9 │ Second last yank │
-- │ 3 │ Third last delete        │ 8 │ Third last yank  │
-- │ 4 │ Fourth last delete       │ 7 │ Fourth last yank │
-- │ 5 │ Fifth last delete        │ 6 │ Fifth last yank  │
-- ╰───┴──────────────────────────┴───┴──────────────────╯
--
-- ─────────────── CYCLE REGISTERS ───────────────────────────────────
-- It is possible to cycle through registers using the configured
-- keybindings. (See last two lines of this file)
-- 1. The cycle starts either at 0 or 1 (based on your last action)
-- 2. The registers cycle in numerical order.
--    Since last Nth delete or yank is at most N+1 positions away,
--    few cycles is required for recent yanks and deletes
-- ───────────────────────────────────────────────────────────────────

local prev0, prev9
vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("yank_history", {}),
    desc = "Store previous yanks in latter half of numbered registers (VimEnter hooks)",
    pattern = "*",
    callback = function()
        prev0 = vim.fn.getreginfo "0"
        prev9 = vim.fn.getreginfo "9"
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = "yank_history",
    desc = "Store previous yanks in latter half of numbered registers",
    pattern = "*",
    callback = function()
        if vim.v.event.regname ~= "" then
            return
        end
        vim.fn.setreg("6", vim.fn.getreginfo "7")
        vim.fn.setreg("7", vim.fn.getreginfo "8")
        vim.fn.setreg("8", vim.fn.getreginfo "9")
        if vim.v.event.operator == "y" then
            prev0.isunnamed = false
            vim.fn.setreg("9", prev0)
            prev9 = vim.fn.getreginfo "9"
            prev0 = vim.fn.getreginfo "0"
        else
            vim.fn.setreg("9", prev9)
        end
    end,
})
