-- IRON - repl access for python, R, etc.
return {
  "Vigemus/iron.nvim",
  config = function()
    require("iron.core").setup({
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
          sh = {
            command = {"bash", "-c", "'conda init && conda activate $CONDA_DEFAULT_ENV'" }
          },
          python = {
            command = { "ipython", "--no-confirm-exit", "--no-autoindent", "--matplotlib" }, -- must be python or envs don't work
            format = require("iron.fts.common").bracketed_paste
          },
        },
        -- How the repl window will be displayed
        -- See below for more information
        repl_open_cmd = require('iron.view').split.vertical.botright(0.4),
      },
      -- You can set them here or manually add keymaps to the functions in iron.core
      keymaps = {
        -- If repl_open_command is a table as above, then the following keymaps are
        -- available
        -- toggle_repl_with_cmd_1 = "<leader>rv",  THESE ARE FOR MULTIPLE REPL INSTANCES
        -- toggle_repl_with_cmd_2 = "<leader>rh",
        toggle_repl = "<leader>ir", -- toggles the repl open and closed.
        restart_repl = "<leader>iR", -- calls `IronRestart` to restart the repl
        send_motion = "<leader>isc",
        visual_send = "<leader>isc",
        send_file = "<leader>isf",
        send_paragraph = "<leader>isp",
        send_until_cursor = "<leader>isu",
        interrupt = "<leader>ii",
        exit = "<leader>iq",
        clear = "<leader>ic",
      },
      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = {
        italic = false
      },
      ignore_blank_lines = false, -- ignore blank lines when sending visual select lines
    })
  end,
}
