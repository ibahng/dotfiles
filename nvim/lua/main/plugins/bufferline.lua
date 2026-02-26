-- BUFFERLINE - tab bar on the top
return {
  "akinsho/bufferline.nvim",
  opts = {
    options = {
      themable = true,
      mode = "buffers",
      numbers = "none",
      indicator = {
          icon = '▌',
          style = 'icon',
      },
      -- buffer_close_icon = '',
      modified_icon = "●",
      -- close_icon = "",
      -- close_icon = '',
      left_trunc_marker = "",
      right_trunc_marker = "",
      max_name_length = 30,
      max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
      tab_size = 27,
      name_formatter = function(buf)
        local parent = vim.fn.fnamemodify(buf.path, ":h:t")
        if parent ~= "." then
          return parent .. "/" .. buf.name
        end
        return buf.name
      end,
      diagnostics = false,
      diagnostics_update_in_insert = false,
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        return "("..count..")"
      end,
      -- NOTE: this will be called a lot so don't do any heavy processing here
      custom_filter = function(buf_number)
        local buftype = vim.bo[buf_number].buftype
        local bufname = vim.fn.bufname(buf_number)

        -- Include Iron REPL terminal buffers
        if buftype == "terminal" and (string.match(bufname, "iron") or vim.bo[buf_number].filetype == "iron") then
          return true
        end

        -- Exclude other terminal buffers (optional)
        if buftype == "terminal" then
          return false
        end

        -- Exclude other unwanted buffer types
        if buftype == "quickfix" or buftype == "help" or buftype == "nofile" then
          return false
        end

        return true
      end,
      offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
      show_buffer_icons = true,
      show_buffer_close_icons = false,
      show_close_icon = false,
      show_tab_indicators = true,
      persist_buffer_sort = true,
      -- can also be a table containing 2 custom separators
      -- [focused and unfocused]. eg: { '|', '|' }
      separator_style = "none",
      enforce_regular_tabs = true,
      always_show_bufferline = true,
      -- sort_by = 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
      --   -- add custom logic
      --   return buffer_a.modified > buffer_b.modified
      -- end
    },
    highlights = {
      -- BACKGROUND =================================================
      fill = { -- the background color of empty area to the left or right when there arent enough tabs
        bg = '#000000',
      },
      background = { -- the bg and fg colors of none selected buffertabs
        bg = '#000000',
        fg = '#9ea8bd',
      },

      -- BUFFER =====================================================
      buffer_selected = { -- the respective background and font colors of the buffertab that is selected
        fg = '#ffffff',
        bg = '#444863',
        bold = true,
        italic = true
      },
      buffer_visible = { -- a visible but non focused buffertab bg and fg; this is not applicable to nonsplit screen cases
        fg = '#ededed',
        bg = '#373a4f',
        bold = true,
      },

      -- CLOSE BUTTON ================================================this is disabled 
      -- close_button = {
      --   guifg = { attribute = "fg", highlight = "TabLine" },
      --   guibg = { attribute = "bg", highlight = "TabLine" },
      -- },
      -- close_button_visible = {
      --   guifg = { attribute = "fg", highlight = "TabLine" },
      --   guibg = { attribute = "bg", highlight = "TabLine" },
      -- },
      -- close_button_selected = {
      --   guifg = '#000000',
      --   guibg = '#ffc9de',
      -- },

      -- TAB ========================================================this is disabled, to enable need to make mode = tab in line 7
      -- tab_selected = {
      --   guifg = { attribute = "fg", highlight = "TabLine" },
      --   guibg = { attribute = "bg", highlight = "TabLine" },
      --   gui = 'bold',
      -- },
      -- tab = {
      --   guifg = { attribute = "fg", highlight = "TabLine" },
      --   guibg = { attribute = "bg", highlight = "TabLine" },
      -- },
      -- tab_close = {
      --   -- guifg = {attribute='fg',highlight='LspDiagnosticsDefaultError'},
      --   guifg = { attribute = "fg", highlight = "TabLineSel" },
      --   guibg = { attribute = "bg", highlight = "Normal" },
      -- },

      -- DUPLICATE ==================================================refers to duplicate buffertabs, same color scheme as buffers section but italicized
      duplicate_selected = {
        fg = '#ffffff',
        bg = '#444863',
        gui = 'italic',
      },
      duplicate_visible = {
        fg = '#ffffff',
        bg = '#000000',
        gui = "italic",
      },
      duplicate = {
        fg = '#ffffff',
        bg = '#000000',
        gui = "italic",
      },

      -- MODIFIED ===================================================
      modified = {
        fg = '#4caf50',
        bg = '#000000',
      },
      modified_selected = {
        fg = '#4caf50',
        bg = '#444863',
      },
      modified_visible = {
        fg = '#3d8f40',
        bg = '#373a4f',
      },

      -- SEPARATOR ==================================================
      separator = {
        fg = '#000000',
        bg = 'NONE',
      },
      separator_selected = {
        fg = 'NONE',
        bg = 'NONE',
      },
      separator_visible = {
        fg = 'NONE',
        bg = 'NONE',
      },

      -- INDICATOR ==================================================
      indicator_visible = {
        fg = '#ff0000',
        bg = '#373a4f',
      },
      indicator_selected = {
        fg = '#FFB74D',
        bg = '#444863',
      },
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)

    -- Make Iron REPL buffers listed
    vim.api.nvim_create_autocmd({"TermOpen", "BufEnter"}, {
      pattern = "*",
      callback = function()
        local bufname = vim.fn.bufname()
        local buftype = vim.bo.buftype

        -- Check if this is an Iron REPL buffer
        if buftype == "terminal" and (
          string.match(bufname, "iron") or
          string.match(bufname, "python") or
          string.match(bufname, "ipython") or
          string.match(bufname, "julia") or
          string.match(bufname, "R")  -- adjust patterns as needed
        ) then
          vim.bo.buflisted = true
        end
      end,
    })
  end,
}
