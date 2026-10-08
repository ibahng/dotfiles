local settings = require("settings")
local colors = require("colors")

-- Padding item on the far right screen edge
sbar.add("item", {
  position = "right",
  width = settings.group_paddings,
  background = { drawing = false }
})

local cal_down = sbar.add("item", {
  position = "right",
  padding_left = 1,
  padding_right = 6,
  width = 0,
  label = {
    color = colors.white,
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 11.0
    }
  },
  y_offset = -6,
  background = { drawing = false }
})

local cal_up = sbar.add("item", {
  position = "right",
  padding_left = 1,
  padding_right = 6,
  label = {
    color = colors.blue,
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 11.0
    }
  },
  y_offset = 6,
  background = { drawing = false }
})

-- Bracket for calendar background
local cal_bracket = sbar.add("bracket", { cal_up.name, cal_down.name }, {
  background = {
    color = colors.bg1,
    corner_radius = 0,
    border_width = 0,
    border_color = colors.transparent,
    height = 30,
  },
  update_freq = 1
})

-- Standardized margin between calendar and weather
sbar.add("item", {
  position = "right",
  width = settings.group_paddings,
  background = { drawing = false }
})

cal_bracket:subscribe({ "forced", "routine", "system_woke" }, function(env)
  -- Format with fixed 10-character length (%a %b %d) so width never shifts
  local up_value = os.date("%a %b %d")
  local down_value = os.date("%H:%M:%S")
  cal_up:set({ label = { string = up_value } })
  cal_down:set({ label = { string = down_value } })
end)
