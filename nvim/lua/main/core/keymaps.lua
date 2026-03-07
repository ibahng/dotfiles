local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set
local wk = require("which-key")

keymap("", "<Space>", "<Nop>", opts)

-- QUALITY OF LIFE KEYBINDS =======================================================================
keymap("i", "jk", "<esc>", opts)                -- sets the shift from insert to normal mode as jk
keymap("v", "q", "<esc>", opts)                 -- sets the shift from visual to normal mode as q
keymap("n", "k", "gk", opts)                    -- allows for easier vertical navigation within wrapped lines
keymap("n", "j", "gj", opts)
keymap("n", "<c-d>", "<c-d>zz", opts)           -- centers the cursor while moving vertically in a buffer using ctrl d and ctrl u 
keymap("n", "<c-u>", "<c-u>zz", opts)
keymap("n", "<leader>w", ":set wrap!<cr>", opts)              -- toggles text wraping

-- BUFFER NAVIGATION ==============================================================================
keymap("n", "<leader>e", "<cmd>Neotree toggle<cr>", { noremap = true, silent = true, desc = 'Neotree Toggle' })         -- neotree toggle
keymap("n", "<leader>a", "<cmd>AerialToggle!<CR>", { noremap = true, silent = true, desc = 'Aerial Toggle' })         -- neotree toggle
keymap("n", "<c-h>", "<c-w>h", opts)                          -- moving cursor to window on the left
keymap("n", "<c-l>", "<c-w>l", opts)                          -- moving cursor to window on the right
keymap("n", "<c-j>", "<c-w>j", opts)                          -- moving cursor to window on the left
keymap("n", "<c-k>", "<c-w>k", opts)                          -- moving cursor to window on the right

-- TOGGLETERM TERMINALS ===========================================================================
keymap({ "n", "t" }, "<C-7>", function() _G.term1:toggle() end, opts)
keymap({ "n", "t" }, "<C-8>", function() _G.term2:toggle() end, opts)
keymap({ "n", "t" }, "<C-9>", function() _G.term3:toggle() end, opts)
keymap({ "n", "t" }, "<C-0>", function() _G.term4:toggle() end, opts)

-- BUFFERLINE NAVIGATION AND REARRANGEMENT ========================================================
keymap("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", opts)        -- moving between buffer tabs on top using shift h and l
keymap("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", opts)

-- PEEK MARKDOWN PREVIEW ==========================================================================

local function visual_cursors_with_delay()
  vim.cmd('silent! execute "normal! \\<Plug>(VM-Visual-Cursors)"')
  vim.cmd('sleep 200m')
  vim.cmd('silent! execute "normal! A"')
end

-- WHICH-KEY MAPPINGS =============================================================================
wk.add({
  -- BUFFERLINE NAVIGATION AND REARRANGEMENT ======================================================
  { "<leader>b", group = "BufferLine", remap = false },
  { "<leader>bl", "<cmd>BufferLineMoveNext<cr>", desc = "Move Right", remap = false },
  { "<leader>bh", "<cmd>BufferLineMovePrev<cr>", desc = "Move Left", remap = false },
  { "<leader>bq", "<cmd>bp!|bd#<cr>", desc = "Close Buffer", remap = false },

  -- TELESCOPE ====================================================================================
  { "<leader>f", group = "Telescope", remap = false },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "File Search", remap = false },
  { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Text Search", remap = false },

  -- PEEK MARKDOWN =================================================================================
  { "<leader>p", group = "Peek Markdown", remap = false },
  { "<leader>po", "<cmd>PeekOpen<cr>", desc = "Open Preview", remap = false },
  { "<leader>pq", "<cmd>PeekClose<cr>", desc = "Close Preview", remap = false },

  -- IRON REPL (functional keymaps defined in iron.lua, descriptions for which-key below) ==========
  { "<leader>i", group = "IronREPL", remap = false },
  { "<leader>ir", desc = "Toggle REPL" },
  { "<leader>iR", desc = "Restart REPL" },
  { "<leader>is", group = "Send", remap = false },
  { "<leader>isc", desc = "Send Motion" },
  { "<leader>isf", desc = "Send File" },
  { "<leader>isp", desc = "Send Paragraph" },
  { "<leader>isu", desc = "Send Until Cursor" },
  { "<leader>ii", desc = "Interrupt" },
  { "<leader>iq", desc = "Exit" },
  { "<leader>ic", desc = "Clear" },

  -- VIMTEX LATEX =================================================================================
  { "<leader>l", group = "Vimtex", remap = false },
  { "<leader>ll", "<cmd>VimtexCompile<cr>", desc = "Compile", remap = false },
  { "<leader>li", "<cmd>VimtexInfo<cr>", desc = "Info", remap = false },
  { "<leader>lt", "<cmd>VimtexTocToggle<cr>", desc = "TOC Toggle", remap = false },
  { "<leader>la", "<cmd>VimtexReload<cr>", desc = "Reload", remap = false },
  { "<leader>lv", "<cmd>VimtexView<cr>", desc = "View", remap = false },

  -- AUTOSESSION ==================================================================================
  { "<leader>w", group = "AutoSession", remap = false },
  { "<leader>wr", "<cmd>AutoSession restore<cr>", desc = "Restore", remap = false },
  { "<leader>ws", "<cmd>AutoSession save<cr>", desc = "Save", remap = false },

  -- VISUAL MULTI =================================================================================
  { "<leader>m", group = "Visual Multi", remap = false },
  { "<leader>mn", "<Plug>(VM-Find-Under)", desc = "Find Word", remap = false, mode = { "n" } },
  { "<leader>ma", "<Plug>(VM-Select-All)<Tab>", desc = "Select All", remap = false, mode = { "n" } },
  { "<leader>mp", "<Plug>(VM-Add-Cursor-At-Pos)", desc = "Add Cursor At Pos", remap = false, mode = { "n" } },
  { "<leader>mv", visual_cursors_with_delay, desc = "Visual Cursors", remap = false, mode = { "v" } },
  { "<leader>mo", "<Plug>(VM-Toggle-Mappings)", desc = "Toggle Mappings", remap = false, mode = { "n" } },
})

-- CUSTOM SNIPPETS
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)                    -- moves lines in visual mode
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)


