local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "network_update"
-- for the network interface "en0", which is fired every 2.0 seconds.
sbar.exec("killall network_load >/dev/null 2>&1; $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load en0 network_update 2.0")

local function format_rate(rate_str)
  if not rate_str or rate_str == "" then return "000  Bps" end
  local num, unit = rate_str:match("(%d+)%s*(%a+)")
  if num and unit then
    if unit == "Bps" then
      return string.format("%03d  Bps", tonumber(num))
    else
      return string.format("%03d %s", tonumber(num), unit)
    end
  end
  return rate_str
end

local wifi_down = sbar.add("item", "widgets.wifi2", {
  position = "right",
  padding_left = -5,
  width = 0,
  icon = {
    padding_right = 0,
    font = {
      style = settings.font.style_map["Bold"],
      size = 9.5,
    },
    string = icons.wifi.download,
  },
  label = {
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 10.0,
    },
    color = colors.blue,
    string = "000  Bps",
  },
  y_offset = -5,
  background = { drawing = false },
})

local wifi_up = sbar.add("item", "widgets.wifi1", {
  position = "right",
  padding_left = -5,
  icon = {
    padding_right = 0,
    font = {
      style = settings.font.style_map["Bold"],
      size = 9.5,
    },
    string = icons.wifi.upload,
  },
  label = {
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 10.0,
    },
    color = colors.red,
    string = "000  Bps",
  },
  y_offset = 5,
  background = { drawing = false },
})

local wifi = sbar.add("item", "widgets.wifi.icon", {
  position = "right",
  padding_left = 6,
  padding_right = 2,
  icon = {
    font = {
      style = settings.font.style_map["Regular"],
      size = 15.0,
    },
    string = icons.wifi.connected,
    color = colors.white,
  },
  label = { drawing = false },
  background = { drawing = false },
})

-- Background around the item
local wifi_bracket = sbar.add("bracket", "widgets.wifi.bracket", {
  wifi.name,
  wifi_up.name,
  wifi_down.name,
}, {
  background = {
    color = colors.bg1,
    corner_radius = 0,
    border_width = 0,
    border_color = colors.transparent,
    height = 30,
  },
})

sbar.add("item", "widgets.wifi.padding", {
  position = "right",
  width = settings.group_paddings,
  background = { drawing = false },
})

wifi_up:subscribe("network_update", function(env)
  local up_str = format_rate(env.upload)
  local down_str = format_rate(env.download)
  local up_color = (up_str:find("^000")) and colors.grey or colors.red
  local down_color = (down_str:find("^000")) and colors.grey or colors.blue

  wifi_up:set({
    icon = { color = up_color },
    label = {
      string = up_str,
      color = up_color,
    }
  })
  wifi_down:set({
    icon = { color = down_color },
    label = {
      string = down_str,
      color = down_color,
    }
  })
end)

local function update_wifi_status()
  sbar.exec("ipconfig getifaddr en0", function(ip)
    local connected = not (ip == "" or ip == nil)
    wifi:set({
      icon = {
        string = connected and icons.wifi.connected or icons.wifi.disconnected,
        color = connected and colors.white or colors.red,
      },
    })
    if connected then
      sbar.exec("scutil --nc list | grep 'Connected'", function(result)
        if result and result ~= "" then
          wifi:set({
            icon = {
              string = icons.wifi.vpn,
              color = colors.white,
            },
          })
        end
      end)
    end
  end)
end

wifi:subscribe({"wifi_change", "system_woke", "routine", "forced"}, update_wifi_status)
update_wifi_status()
