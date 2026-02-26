-- COMMENT - commenting out multiple lines
return {
  "terrortylor/nvim-comment",
  config = function()
    require('nvim_comment').setup({
      marker_padding = true,
      comment_empty = true,
      line_mapping = nil,
      operator_mapping = "co",
      comment_chunk_text_object = "ic"
    })
  end,
}
