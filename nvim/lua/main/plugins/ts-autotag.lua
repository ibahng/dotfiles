-- TS-AUTOTAG - auto close and rename HTML/XML tags
return {
  "windwp/nvim-ts-autotag",
  event = "InsertEnter",
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = false,
  },
}
