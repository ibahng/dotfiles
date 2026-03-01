---@diagnostic disable: lowercase-global
hs = hs
spoon = spoon

---@diagnostic enable: lowercase-global



-- hs.loadSpoon("AClock")
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "C", function()
--   spoon.AClock:toggleShow()
-- end)


hs.hotkey.bind({"alt"}, "`", function()
  hs.application.launchOrFocus("Calendar")
end)


hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
  hs.reload()
end)
hs.alert.show("Config loaded")
