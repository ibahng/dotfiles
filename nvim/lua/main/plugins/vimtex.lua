-- VIMTEX - LaTeX support
return {
  "lervag/vimtex",
  lazy = false,
  init = function()
    -- when using skim, in sync, use /opt/homebrew/bin/nvim --headless -c "VimtexInverseSearch %line '%file'" 
    -- with full path of nvim (see more here: https://github.com/lervag/vimtex/issues/2779)

    vim.g['vimtex_view_method'] = 'skim'
    vim.g['vimtex_view_skim_sync'] = 1
    vim.g['vimtex_view_skim_activate'] = 1

    -- Compiler configuration (lualatex)
    vim.g['vimtex_compiler_method'] = 'latexmk'
    vim.g['vimtex_compiler_latexmk'] = {
      executable = 'latexmk',
      options = {
        '-verbose',
        '-file-line-error',
        '-synctex=1',
        '-interaction=nonstopmode',
      },
    }
    vim.g['vimtex_compiler_latexmk_engines'] = {
      _ = '-lualatex',
    }

    --  vim.keymap.set("n", "<leader>lv", "<leader>lv") -- forward search 
    vim.g['vimtex_fold_enabled'] = 0
    vim.g['vimtex_fold_levelmarker'] = '>'
    vim.g['vimtex_indent_enabled'] = 1
    vim.g.vimtex_fold_types = {
      preamble = { enabled = 1 }, -- enable folding of preamble
      items = {enabled = 0},
      envs = {
        blacklist = {
          'figure',
          'table',
          'definition', 'theorem', 'lemma', 'example', 'corollary', 'solution', 'proof',
          'enumerate', 'itemize', 'equation', 'align'
        },
        whitelist = {
          'item'
        }
      },
      sections = {
        parse_levels = 1,
      }
    }
  end,
}
