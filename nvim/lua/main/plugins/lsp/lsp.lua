return {
  "hrsh7th/cmp-nvim-lsp",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/lazydev.nvim", opts = {} },
  },
  config = function()
    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    vim.lsp.config("texlab", {
      capabilities = capabilities,
      settings = {
        texlab = {
          diagnostics = {
            ignoredPatterns = {
              "Unused label",
              "Undefined reference",
            },
          },
        },
      },
    })

    vim.lsp.config("pyright", {
      capabilities = capabilities,
      filetypes = { "python" },
      settings = {
        python = {
          pythonPath = vim.fn.getcwd() .. "/.venv/bin/python",
          venvPath = vim.fn.getcwd(),
          venv = ".venv",
        },
      },
    })

    vim.lsp.config("*", {
      capabilities = capabilities,
    })
  end,
}
