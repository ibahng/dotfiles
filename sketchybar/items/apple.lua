local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Padding item required because of bracket
sbar.add("item", { width = 5, background = { drawing = false } })

local apple = sbar.add("item", {
  icon = {
    font = { size = 14.0 },
    string = icons.apple,
    padding_right = 6,
    padding_left = 6,
  },
  label = { drawing = false },
  background = {
    color = colors.bg2,
    border_color = colors.black,
    border_width = 1,
    height = 24,
    corner_radius = 4,
    drawing = true,
  },
  padding_left = 3,
  padding_right = 3,
  click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0"
})

-- Double border for apple using a single item bracket
sbar.add("bracket", { apple.name }, {
  background = {
    color = colors.transparent,
    height = 30,
    corner_radius = 6,
    border_color = colors.grey,
    border_width = 2,
    drawing = true,
  }
})

-- Padding item required because of bracket
sbar.add("item", { width = 7, background = { drawing = false } })
