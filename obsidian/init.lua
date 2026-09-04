-- init.lua

vim.opt.shiftwidth = 2                          -- make the tab 2 spaces
vim.opt.breakindent = true                      -- wrapped lines maintain same indent as first line
vim.opt.scrolloff = 20                          -- keep 8 lines above/below cursor
vim.opt.tablenav = true

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

-- Set your leader key first (must come before any keymap using <leader>)
vim.g.mapleader = " "

-- User feedback via vim.notify
vim.keymap.set("n", "<leader>r", function()
  vim.cmd("obcommand app:reload")
  vim.notify("Reloaded!")
end, { desc = "Reload" })

-- Basic normal-mode remaps
keymap("n", "k", "gk", opts)                    -- allows for easier vertical navigation within wrapped lines
keymap("n", "j", "gj", opts)
keymap("n", "<c-d>", "<c-d>zz", opts)           -- centers the cursor while moving vertically in a buffer using ctrl d and ctrl u 
keymap("n", "<c-u>", "<c-u>zz", opts)

keymap("n", "L", ":obcommand workspace:next-tab<CR>", opts)           -- centers the cursor while moving vertically in a buffer using ctrl d and ctrl u 
keymap("n", "H", ":obcommand workspace:previous-tab<CR>", opts)
keymap("n", "<leader>bq", ":obcommand workspace:close<CR>", opts)

keymap("n", "<leader>e", ":obcommand app:toggle-left-sidebar<CR>", opts)
keymap("n", "<leader>a", ":obcommand app:toggle-right-sidebar<CR>", opts)
keymap("n", "<leader>h", ":obcommand file-explorer:open<CR>", opts)

-- focus on tab group hjkl is set in internal keybindings
-- bold, italic, strikethrough, highlight, code is set in internal keybindings
