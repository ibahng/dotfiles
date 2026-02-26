-- TREESITTER - syntax aware code parser
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "python",
      "c",
      "cpp",
      "lua",
      "bash",
      "verilog",
      "html",
      "css",
      "markdown_inline",
      "markdown",
      "javascript",
      "jsdoc",
      "typescript",
      "json",
      "yaml",
      "asm",
      "nasm",
      "bibtex"
    },
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = { "" }, -- list of language that will be disabled
      additional_vim_regex_highlighting = true,
    },
    -- indent = { enable = true, disable = { "" } },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  },
}
