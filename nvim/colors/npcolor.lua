-- ~/.config/nvim/colors/npcolor.lua

vim.opt.background = "dark"
vim.cmd("highlight clear")

local bg = "#2a2e38"
local fg = "#f0fdff"

vim.api.nvim_set_hl(0, "Normal",      { fg = fg, bg = bg })
vim.api.nvim_set_hl(0, "NormalNC",    { fg = fg, bg = bg })
vim.api.nvim_set_hl(0, "NormalFloat", { fg = fg, bg = bg })
vim.api.nvim_set_hl(0, "LineNr",      { fg = "#4a5060", bg = bg })
vim.api.nvim_set_hl(0, "CursorLine",  { bg = "#343844" })
vim.api.nvim_set_hl(0, "CursorLineNr",{ fg = "#f0fdff", bg = "#343844" })
vim.api.nvim_set_hl(0, "Comment",     { fg = "#6b7280", italic = true })
vim.api.nvim_set_hl(0, "Visual",      { bg = "#3a4060" })
vim.api.nvim_set_hl(0, "StatusLine",  { fg = fg, bg = "#343844" })
vim.api.nvim_set_hl(0, "VertSplit",   { fg = "#343844", bg = bg })
vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = bg, bg = bg })
