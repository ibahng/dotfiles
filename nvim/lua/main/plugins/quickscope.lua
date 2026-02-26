-- QUICKSCOPE - f and t highlighting
return {
  "unblevable/quick-scope",
  init = function()
    vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }
  end,
  config = function()
    vim.cmd "highlight QuickScopePrimary guifg='#00ffff' gui=underline ctermfg=155 cterm=underline"
    vim.cmd "highlight QuickScopeSecondary guifg='#ff00ff' gui=underline ctermfg=81 cterm=underline"
  end,
}
