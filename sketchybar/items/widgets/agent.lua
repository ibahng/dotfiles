local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local lunajson = require("lunajson")
local file = require("utils.file")

local popup_width = 280
local sessions_dir = (os.getenv("HOME") or "") .. "/.cache/agent_sessions"

-- Create Event
sbar.add("event", "agent_status_update")

-- Label Item (added first so it sits on the right side of the bracket)
local agent_label = sbar.add("item", "widgets.agent.label", {
  position = "right",
  icon = { drawing = false },
  label = {
    string = "",
    color = colors.white,
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 10.5,
    },
  },
  padding_left = 1,
  padding_right = 6,
  drawing = false,
  updates = true,
})

-- Icon Item (added second so it sits on the left side of the bracket)
local agent_icon = sbar.add("item", "widgets.agent.icon", {
  position = "right",
  icon = {
    string = "􀫥", -- SF Symbol Processor/AI
    color = colors.grey,
    font = {
      style = settings.font.style_map["Regular"],
      size = 14.0,
    },
  },
  label = { drawing = false },
  padding_left = 6,
  padding_right = 6,
  drawing = true,
  updates = true,
  update_freq = 1,
  popup = {
    align = "center",
    height = 30,
  }
})

-- Bracket Group
local agent_bracket = sbar.add("bracket", "widgets.agent.bracket", {
  agent_icon.name,
  agent_label.name,
}, {
  background = {
    color = colors.bg1,
    corner_radius = 0,
    border_width = 0,
    border_color = colors.transparent,
    height = 30,
  },
  drawing = true,
  updates = true,
})

local agent_padding = sbar.add("item", "widgets.agent.padding", {
  position = "right",
  width = settings.group_paddings,
  drawing = true,
  updates = true,
})

-- Popup Details & State Management
local function update_agent_status()
  local p = io.popen("ls " .. sessions_dir .. "/*.json 2>/dev/null")
  if not p then return end

  local sessions = {}
  local now = os.time()

  for json_path in p:lines() do
    local content, err = file.read(json_path)
    if not err and content and #content > 0 then
      local ok, session = pcall(lunajson.decode, content)
      if ok and session and session.repo then
        local ts = session.timestamp or now
        -- Auto clean completed tasks after 15s or stale tasks after 10m
        if session.status == "done" and (now - ts) > 15 then
          os.remove(json_path)
        elseif (now - ts) > 600 then
          os.remove(json_path)
        else
          table.insert(sessions, session)
        end
      end
    end
  end
  p:close()

  if #sessions == 0 then
    agent_bracket:set({ drawing = true })
    agent_icon:set({
      drawing = true,
      padding_right = 6,
      icon = {
        color = colors.grey,
        string = "􀫥",
      },
    })
    agent_label:set({ drawing = false, label = { string = "" } })
    agent_padding:set({ drawing = true })
    return
  end

  agent_bracket:set({ drawing = true })
  agent_icon:set({ drawing = true, padding_right = 0 })
  agent_label:set({ drawing = true })
  agent_padding:set({ drawing = true })

  -- Check priority (approvals > errors > running > done)
  local approvals = {}
  local runnings = {}
  local dones = {}

  for _, s in ipairs(sessions) do
    if s.status == "approval" then
      table.insert(approvals, s)
    elseif s.status == "running" then
      table.insert(runnings, s)
    else
      table.insert(dones, s)
    end
  end

  if #approvals > 0 then
    local app = approvals[1]
    agent_icon:set({ icon = { color = colors.orange, string = "􀀦" } })
    agent_label:set({ label = { string = app.repo .. ": " .. (app.action and app.action ~= "" and app.action or "approval needed"), color = colors.orange } })
  elseif #sessions == 1 then
    local s = sessions[1]
    local color = colors.blue
    local icon_sym = "􀫥"
    if s.status == "done" then
      color = colors.green
      icon_sym = "􀄬"
    elseif s.status == "error" then
      color = colors.red
      icon_sym = "􀜪"
    end
    agent_icon:set({ icon = { color = color, string = icon_sym } })
    agent_label:set({ label = { string = s.repo .. ": " .. (s.action or "working..."), color = colors.white } })
  else
    agent_icon:set({ icon = { color = colors.magenta, string = "􀫥" } })
    agent_label:set({ label = { string = tostring(#sessions) .. " active agents", color = colors.white } })
  end
end

-- Popup toggle
local function toggle_agent_popup()
  local is_open = agent_icon:query().popup.drawing == "on"
  if is_open then
    agent_icon:set({ popup = { drawing = false } })
    sbar.remove('/widgets.agent.item\\.*/')
    return
  end

  sbar.remove('/widgets.agent.item\\.*/')

  local p = io.popen("ls " .. sessions_dir .. "/*.json 2>/dev/null")
  if not p then return end

  local count = 0
  for json_path in p:lines() do
    local content, err = file.read(json_path)
    if not err and content and #content > 0 then
      local ok, s = pcall(lunajson.decode, content)
      if ok and s and s.repo then
        local color = colors.blue
        local icon_str = "􀫥"
        if s.status == "approval" then
          color = colors.orange
          icon_str = "􀀦"
        elseif s.status == "done" then
          color = colors.green
          icon_str = "􀄬"
        elseif s.status == "error" then
          color = colors.red
          icon_str = "􀜪"
        end

        sbar.add("item", "widgets.agent.item." .. count, {
          position = "popup." .. agent_icon.name,
          width = popup_width,
          align = "left",
          icon = {
            string = icon_str,
            color = color,
            padding_left = 10,
            font = {
              style = settings.font.style_map["Regular"],
              size = 14.0,
            },
          },
          label = {
            string = s.repo .. " — " .. (s.action or s.status),
            color = colors.white,
            padding_right = 10,
            font = {
              family = settings.font.numbers,
              style = settings.font.style_map["Bold"],
              size = 11.5,
            },
          },
          click_script = 'osascript -e "tell application \\"Kitty\\" to activate" && sketchybar --set ' .. agent_icon.name .. ' popup.drawing=false'
        })
        count = count + 1
      end
    end
  end
  p:close()

  if count == 0 then
    sbar.add("item", "widgets.agent.item.empty", {
      position = "popup." .. agent_icon.name,
      width = popup_width,
      align = "center",
      label = {
        string = "No active agent sessions",
        color = colors.grey,
        font = {
          family = settings.font.numbers,
          style = settings.font.style_map["Regular"],
          size = 11.5,
        },
      },
    })
  end

  agent_icon:set({ popup = { drawing = true } })
end

-- Subscriptions
agent_icon:subscribe("mouse.clicked", toggle_agent_popup)
agent_label:subscribe("mouse.clicked", toggle_agent_popup)
agent_icon:subscribe("mouse.exited.global", function()
  agent_icon:set({ popup = { drawing = false } })
  sbar.remove('/widgets.agent.item\\.*/')
end)

-- Regular poll (every 2 seconds) and instant event trigger
agent_icon:subscribe({"routine", "agent_status_update", "system_woke", "forced"}, update_agent_status)
agent_label:subscribe({"routine", "agent_status_update", "system_woke", "forced"}, update_agent_status)

-- Initial update on launch
update_agent_status()
