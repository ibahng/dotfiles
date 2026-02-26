-- MASON - LSP server installer and manager
return {
  "williamboman/mason-lspconfig.nvim",
  opts = {
      -- list of servers for mason to install
    ensure_installed = {
      "lua_ls",
      "pyright",
      "texlab",
      "clangd",
    },
  },
  dependencies = {
    {
      "williamboman/mason.nvim",
      opts = {
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      },
    },
    "neovim/nvim-lspconfig",
  },
}
