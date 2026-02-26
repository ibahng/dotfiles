-- VIM-VISUAL-MULTI - multiple cursors plugin
return {
  "mg979/vim-visual-multi",
  init = function()
    -- Disable default mappings so we can define our own
    vim.g.VM_default_mappings = 0

    -- Custom keybindings
    vim.g.VM_maps = {
      -- Navigation
      ['Next'] = 'n',
      ['Previous'] = 'N',
      ['Skip'] = 'q',
      ['Remove Region'] = 'Q',
    }

    -- Additional options
    vim.g.VM_add_cursor_at_pos_no_mappings = 1
  end,
}
