---@diagnostic disable: lowercase-global
hs = hs
spoon = spoon

---@diagnostic enable: lowercase-global



-- hs.loadSpoon("AClock")
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "C", function()
--   spoon.AClock:toggleShow()
-- end)


hs.hotkey.bind({"alt"}, "`", function()
  hs.application.launchOrFocus("ChatGPT")
end)

hs.hotkey.bind({"alt"}, "B", function()
  hs.application.launchOrFocus("Brave Browser")
end)

hs.hotkey.bind({"alt"}, "N", function()
  hs.application.launchOrFocus("Notes")
end)

hs.hotkey.bind({"alt"}, "\\", function()
  hs.application.launchOrFocus("kitty")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
  hs.reload()
end)
hs.alert.show("Config loaded")
