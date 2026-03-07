return {
  "3rd/image.nvim",
  config = function()
    require("image").setup({
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
        },
      },
      max_width = 80,
      max_height = 40,
      -- window_overlap_clear_enabled = true,
      -- window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    })
  end,
}
