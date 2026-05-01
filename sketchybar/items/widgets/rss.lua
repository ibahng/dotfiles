-- local colors = require("colors")
-- local settings = require("settings")

-- local rss = sbar.add("item", "widgets.rss", {
--     position = "right",
--     scroll_texts = true,
--     icon = { drawing = false },
--     label = {
--         string = "Loading RSS...",
--         max_chars = settings.rss.max_chars,
--     },
--     update_freq = settings.rss.update_freq,
--     script = "$CONFIG_DIR/scripts/rss.sh"
-- })

-- rss:subscribe({"routine", "system_woke"})

-- sbar.add("item", "widgets.rss.padding", {
--     position = "right",
--     width = settings.group_paddings
-- })
