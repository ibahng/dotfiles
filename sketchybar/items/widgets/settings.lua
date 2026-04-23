local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local settings_widget = sbar.add("item", "widgets.settings", {
    position = "right",
    icon = { string = icons.settings, padding_left = 0 },
    label = { drawing = false },
    popup = { align = "center", height = 35 }
})

local restart = sbar.add("item", {
    position = "popup." .. settings_widget.name,
    icon = { string = icons.restart },
    label = { string = "Restart" }
})

restart:subscribe("mouse.clicked", function()
    sbar.exec("sketchybar --reload")
end)

local stop = sbar.add("item", {
    position = "popup." .. settings_widget.name,
    icon = { string = icons.stop },
    label = { string = "Stop" }
})

stop:subscribe("mouse.clicked", function()
    sbar.exec("brew services stop sketchybar")
end)

local edit_configuration = sbar.add("item", {
    position = "popup." .. settings_widget.name,
    icon = { string = icons.pencil },
    label = { string = "Edit Config" }
})

local function build_script(editor)
    return "osascript -e 'tell application \"Terminal\" to if (count of windows) = 0 then reopen' -e 'tell application \"Terminal\" to activate' -e 'tell application \"Terminal\" to do script \"cd ~/.config/sketchybar && " .. editor .. " config.json\" in front window'"
end

edit_configuration:subscribe("mouse.clicked", function()
    sbar.exec(build_script("code"), function(output)
        if output == "" then
            sbar.exec(build_script("vim"))
        end
    end)
end)

local upgrade = sbar.add("item", {
    position = "popup." .. settings_widget.name,
    icon = { string = icons.upgrade },
    label = { string = "Upgrade" },
    drawing = "off"
})

local loading = false
upgrade:subscribe("mouse.clicked", function()
    if loading then
        return
    end
    loading = true
    sbar.exec("$CONFIG_DIR/scripts/upgrade.sh", function()
        loading = false
    end)
end)

sbar.add("bracket", "widgets.settings.bracket", { settings_widget.name }, {
    background = { color = colors.bg1 }
})

sbar.add("item", "widgets.settings.padding", {
    position = "right",
    width = settings.group_paddings
})

settings_widget:subscribe("mouse.clicked", function()
    settings_widget:set( { popup = { drawing = "toggle" } })
    sbar.exec("git fetch origin && git log --oneline main..origin/main", function(output)
        if output == "" then
            upgrade:set( { drawing = "off" })
        else
            upgrade:set( { drawing = "on" })
        end
    end)
end)

settings_widget:subscribe("mouse.exited.global", function()
    settings_widget:set( { popup = { drawing = "off" } })
end)
