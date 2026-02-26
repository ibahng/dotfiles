vim.opt.relativenumber = true                   -- set relative numbered lines
vim.opt.cmdheight = 4                           -- more space in the neovim command line for displaying messages
vim.opt.number = true                           -- set numbered lines
vim.opt.mouse = "a"                             -- allow mouse to be used in neovim
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.cursorline = true                       -- highlight the current line
vim.opt.number = true                           -- set numbered lines
vim.opt.numberwidth = 4                         -- set number column width to 4 {default 4}
vim.opt.scrolloff = 20                          -- keep 8 lines above/below cursor
vim.opt.sidescrolloff = 12                      -- keep 8 columns left/right of cursor
vim.opt.showtabline = 2                         -- always show tabs
vim.opt.clipboard = "unnamedplus"               -- makes vim clipboard the global system clipboard
vim.opt.shiftwidth = 2                          -- make the tab 2 spaces
vim.opt.expandtab = true                        -- convert tabs to spaces
vim.opt.termguicolors = true                    -- set term gui colors (most terminals support this)
vim.opt.softtabstop = 2
vim.opt.background = "dark"                     -- Force dark mode

vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='#8e93a5' })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='#8e93a5' })

