-- TOGGLETERM - terminal within nvim
return {
  "akinsho/toggleterm.nvim",
  opts = {
    size = 50,
    direction = "float",
    float_opts = {
      border = "curved",
      width = function()
        return math.ceil(vim.o.columns * 0.97)
      end,
      height = function()
        return math.ceil(vim.o.lines * 0.85)
      end,
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    -- Create three floating terminals (global so keymaps.lua can access them)
    local Terminal = require('toggleterm.terminal').Terminal

    _G.term1 = Terminal:new({
        direction = "float",
        float_opts = {
            border = "curved",
        },
        hidden = true,
    })

    _G.term2 = Terminal:new({
        direction = "float",
        float_opts = {
            border = "curved",
        },
        hidden = true,
    })

    _G.term3 = Terminal:new({
        direction = "float",
        float_opts = {
            border = "curved",
        },
        hidden = true,
    })
    
    _G.term4 = Terminal:new({
        direction = "float",
        float_opts = {
            border = "curved",
        },
        hidden = true,
    })

  end,
}
