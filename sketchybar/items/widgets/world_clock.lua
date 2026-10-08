local colors = require("colors")
local settings = require("settings")

local config = settings.world_clock or {}
local all_cities = config.cities or {
  { tz = "America/Los_Angeles", name = "Los Angeles", enabled = true },
  { tz = "America/Chicago", name = "Chicago", enabled = true },
  { tz = "Asia/Hong_Kong", name = "Hong Kong", enabled = true },
}

local cities = {}
for _, city in ipairs(all_cities) do
  if city.enabled == true then
    table.insert(cities, city)
  end
end

local update_freq = config.update_freq or 15
local time_format = config.format or "%H:%M"

local clock_items = {}
local master_bracket = nil

-- Build items in reverse order so on-screen left-to-right order matches cities array
for i = #cities, 1, -1 do
  local city = cities[i]

  local top_item = sbar.add("item", "widgets.world_clock." .. i .. ".tag", {
    position = "right",
    padding_left = -5,
    width = 0,
    label = {
      color = colors.blue,
      font = {
        family = settings.font.numbers,
        style = settings.font.style_map["Bold"],
        size = 11.0,
      },
      string = city.abbr or "---",
    },
    y_offset = 6,
    background = { drawing = false },
  })

  local bottom_item = sbar.add("item", "widgets.world_clock." .. i .. ".time", {
    position = "right",
    padding_left = -5,
    label = {
      color = colors.white,
      font = {
        family = settings.font.numbers,
        style = settings.font.style_map["Bold"],
        size = 11.0,
      },
      string = "--:--",
    },
    y_offset = -6,
    background = { drawing = false },
  })

  local bracket = sbar.add("bracket", "widgets.world_clock." .. i .. ".bracket", {
    top_item.name,
    bottom_item.name,
  }, {
    background = {
      color = colors.bg1,
      corner_radius = 0,
      border_width = 0,
      border_color = colors.transparent,
      height = 30,
    },
    update_freq = update_freq,
  })

  sbar.add("item", "widgets.world_clock." .. i .. ".padding", {
    position = "right",
    width = settings.group_paddings,
    background = { drawing = false },
  })

  clock_items[i] = {
    tag = top_item,
    time = bottom_item,
    abbr = city.abbr,
  }

  if not master_bracket then
    master_bracket = bracket
  end
end

-- Assemble shell command to fetch timezone abbreviation (%Z) and time in a single batch
local cmd_parts = {}
for _, city in ipairs(cities) do
  table.insert(cmd_parts, string.format('TZ="%s" date "+%%Z %s"', city.tz, time_format))
end
local update_cmd = table.concat(cmd_parts, "; ")

local function update_clocks()
  if #cities == 0 then return end
  sbar.exec(update_cmd, function(result)
    local idx = 1
    for line in result:gmatch("[^\r\n]+") do
      local item = clock_items[idx]
      if item then
        local tz_abbr, time_val = line:match("^(%S+)%s+(%S+)$")
        if tz_abbr and time_val then
          if item.abbr then
            tz_abbr = item.abbr
          elseif tz_abbr:match("^[+-]%d+$") then
            tz_abbr = "SGT"
          end
          item.tag:set({ label = { string = tz_abbr } })
          item.time:set({ label = { string = time_val } })
        end
      end
      idx = idx + 1
    end
  end)
end

if master_bracket then
  master_bracket:subscribe({ "routine", "forced", "system_woke" }, function(env)
    update_clocks()
  end)
end

-- Initial update
update_clocks()
