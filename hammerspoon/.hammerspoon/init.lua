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

-- 1. Configuration
local desktopStyle = {
    fontName = "SFMono-Regular",
    statsSize = 12,
    color = { white = 1, alpha = 0.8 },
    position = { x = 40, y = 70, w = 760, h = 340 } 
}

-- 2. Create the Canvas
local infoCanvas = hs.canvas.new(desktopStyle.position)
infoCanvas:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
infoCanvas:level(hs.canvas.windowLevels.desktopIcon)

local appleAscii = [[
                    'c.       
                 ,xNMM.       
               .OMMMMo        
               OMMM0,         
     .;loddo:' loolloddol;.   
   cKMMMMMMMMMMNWMMMMMMMMMM0: 
 .KMMMMMMMMMMMMMMMMMMMMMMMWd. 
 XMMMMMMMMMMMMMMMMMMMMMMMX.   
;MMMMMMMMMMMMMMMMMMMMMMMM:    
:MMMMMMMMMMMMMMMMMMMMMMMM:    
.MMMMMMMMMMMMMMMMMMMMMMMMX.   
 kMMMMMMMMMMMMMMMMMMMMMMMMWd. 
 .XMMMMMMMMMMMMMMMMMMMMMMMMMMk
  .XMMMMMMMMMMMMMMMMMMMMMMMMK.
    kMMMMMMMMMMMMMMMMMMMMMMd  
     ;KMMMMMMMWXXWMMMMMMMk.   
       .cooc,.    .,coo:.     
]]


local function getSystemStats()
    local output = hs.execute("/opt/homebrew/bin/fastfetch --format json 2>/dev/null")
    local data = hs.json.decode(output)

    -- Index the results by type
    local d = {}
    for _, item in ipairs(data) do
        if not item.error then
            d[item.type] = item.result
        end
    end

    -- Title
    local username = d["Title"].userName .. "@" .. d["Title"].hostName:gsub("%.local", "")

    -- OS
    local os_ver = string.format("%s %s %s (%s) arm64", d["OS"].name, d["OS"].codename, d["OS"].version, d["OS"].buildID)

    -- Host
    local host = d["Host"].name

    -- Kernel
    local kernel = string.format("%s %s", d["Kernel"].name, d["Kernel"].release)

    -- Uptime
    local diff = math.floor(d["Uptime"].uptime / 1000000000)
    local days = math.floor(diff / 86400)
    local hours = math.floor((diff % 86400) / 3600)
    local mins = math.floor((diff % 3600) / 60)
    local uptime = string.format("%d days, %d hours, %d mins", days, hours, mins)

    -- Packages
    local packages = string.format("%d (brew), %d (brew-cask)", d["Packages"].brew, d["Packages"].brewCask)

    -- Displays
    local displayLines = {}
    for _, disp in ipairs(d["Display"]) do
        local tag = disp.type == "Builtin" and "[Built-in]" or "[External]"
        table.insert(displayLines, {
            key = string.format("Display (%s)", disp.name),
            val = string.format("%dx%d @ %.0fHz %s", disp.output.width, disp.output.height, disp.output.refreshRate, tag)
        })
    end

    -- WM
    local wm = string.format("%s %s (with %s)", d["WM"].prettyName, d["WM"].version, d["WM"].pluginName)

    -- WM Theme
    local wm_theme = d["WMTheme"]

    -- Theme
    local theme = d["Theme"].theme1

    -- Font
    local font_str = d["Font"].display

    -- Cursor
    local cursor = string.format("%s (%spx)", d["Cursor"].theme, d["Cursor"].size)

    -- CPU with live usage
    local cpuUsage = hs.host.cpuUsage()
    local cpuLoad = (cpuUsage and cpuUsage.overall) and cpuUsage.overall.active or 0
    local cpu = string.format("%s (%d) @ %.2f GHz (%.1f%%)", d["CPU"].cpu, d["CPU"].cores.physical, d["CPU"].frequency.max / 1000, cpuLoad)

    -- GPU
    local gpu_data = d["GPU"][1]
    local gpu = string.format("%s (%d) [%s]", gpu_data.name, gpu_data.coreCount, gpu_data.type)

    -- Memory
    local memUsed = d["Memory"].used / (1024^3)
    local memTotal = d["Memory"].total / (1024^3)
    local memPct = (memUsed / memTotal) * 100
    local mem = string.format("%.2f GiB / %.2f GiB (%.0f%%)", memUsed, memTotal, memPct)

    -- Swap
    local swapUsed = d["Swap"][1].used / (1024^3)
    local swapTotal = d["Swap"][1].total / (1024^3)
    local swapPct = (swapUsed / swapTotal) * 100
    local swap = string.format("%.2f GiB / %.2f GiB (%.0f%%)", swapUsed, swapTotal, swapPct)

    -- Disk (first non-hidden volume)
    local disk_data = d["Disk"][1]
    local diskUsed = disk_data.bytes.used / (1024^3)
    local diskTotal = disk_data.bytes.total / (1024^3)
    local diskPct = (diskUsed / diskTotal) * 100
    local diskType = table.concat(disk_data.volumeType, ", ")
    local disk = string.format("%.2f GiB / %.2f GiB (%.0f%%) - %s [%s]", diskUsed, diskTotal, diskPct, disk_data.filesystem, diskType)

    -- IP
    local ip = d["LocalIp"][1].ipv4

    -- Battery
    local batt_data = d["Battery"][1]
    local battStatus = table.concat(batt_data.status, ", ")
    local batt
    if batt_data.timeRemaining and battStatus == "Discharging" then
        local tr = math.floor(batt_data.timeRemaining)
        local bHours = math.floor(tr / 3600)
        local bMins = math.floor((tr % 3600) / 60)
        batt = string.format("(%s): %.0f%% (%d hours, %d mins remaining) [%s]", batt_data.modelName, batt_data.capacity, bHours, bMins, battStatus)
    else
        batt = string.format("(%s): %.0f%% [%s]", batt_data.modelName, batt_data.capacity, battStatus)
    end

    -- Power Adapter
    local power = (d["PowerAdapter"] and d["PowerAdapter"][1]) and
        string.format("%dW", d["PowerAdapter"][1].watts) or "N/A"

    -- Build styled text
    local boldFont  = { name = "SFMono-Bold", size = desktopStyle.statsSize }
    local normFont  = { name = desktopStyle.fontName, size = desktopStyle.statsSize }
    local keyColor  = { white = 1, alpha = 1.0 }
    local valColor  = { white = 1, alpha = 0.8 }
    local para      = { alignment = "left" }

    local function line(key, value)
        return hs.styledtext.new(key .. ": ", { font = boldFont, color = keyColor, paragraphStyle = para })
            .. hs.styledtext.new(value .. "\n", { font = normFont, color = valColor, paragraphStyle = para })
    end

    local result = hs.styledtext.new(username .. "\n", {
        font = boldFont,
        color = { hex = "#5BA4CF", alpha = 1.0 },
        paragraphStyle = para
    })
    .. hs.styledtext.new(string.rep("-", #username) .. "\n", {
        font = normFont,
        color = { white = 1, alpha = 0.4 },
        paragraphStyle = para
    })
    .. line("OS", os_ver)
    .. line("Host", host)
    .. line("Kernel", kernel)
    .. line("Uptime", uptime)
    .. line("Packages", packages)

    for _, disp in ipairs(displayLines) do
        result = result .. line(disp.key, disp.val)
    end

    result = result
        .. line("WM", wm)
        .. line("WM Theme", wm_theme)
        .. line("Theme", theme)
        .. line("Font", font_str)
        .. line("Cursor", cursor)
        .. line("CPU", cpu)
        .. line("GPU", gpu)
        .. line("Memory", mem)
        .. line("Swap", swap)
        .. line("Disk (/)", disk)
        .. line("Local IP (en0)", ip)
        .. line("Battery", batt)
        .. line("Power Adapter", power)

    return result
end

-- 4. Define the Update Function 
local function updateDisplay()
  local styledText = getSystemStats()

  infoCanvas[1] = {
    type = "rectangle",
    action = "fill",
    fillColor = { red = 0.15, green = 0.15, blue = 0.15, alpha = 0.4 },  -- dark charcoal
    roundedRectRadii = { xRadius = 10, yRadius = 10 },
    frame = { x = "0%", y = "0%", w = "100%", h = "100%" }
  }

  infoCanvas[2] = {
    type = "text",
    text = hs.styledtext.new(appleAscii, {
      font = { name = desktopStyle.fontName, size = 10.3 },
      color = { white = 1, alpha = 0.8 },
      paragraphStyle = { alignment = "left" }
    }),
    frame = { x = 15, y = 55, w = 200, h = 500 }
  }

  infoCanvas[3] = {
    type = "text",
    text = styledText,
    frame = { x = 230, y = 15, w = 600, h = 500 }
  }
end

-- 5. Initialize and Start
updateDisplay()
infoCanvas:show()

-- Refresh every 1 second
if infoTimer then infoTimer:stop() end
infoTimer = hs.timer.doEvery(1, updateDisplay)

-- -- Spotify Now Playing Canvas
-- spotifyCanvas = hs.canvas.new({ x = 40, y = 420, w = 400, h = 50 })
-- spotifyCanvas:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
-- spotifyCanvas:level(hs.canvas.windowLevels.desktopIcon)

-- local boldFont = { name = "SFMono-Bold", size = 12 }
-- local normFont = { name = "SFMono-Regular", size = 12 }

-- local function updateSpotify()
--   if not hs.spotify.isRunning() then
--     spotifyCanvas[1] = {
--       type = "text",
--       text = hs.styledtext.new("Spotify not running", {
--         font = normFont,
--         color = { white = 1, alpha = 0.4 },
--         paragraphStyle = { alignment = "left" }
--       }),
--       frame = { x = 10, y = 12, w = 380, h = 30 }
--     }
--     return
--   end

--   local track  = hs.spotify.getCurrentTrack()  or "Unknown"
--   local artist = hs.spotify.getCurrentArtist() or "Unknown"

--   local styledLine = hs.styledtext.new("♫  ", { font = boldFont, color = { hex = "#5BA4CF", alpha = 1.0 } })
--     .. hs.styledtext.new(track, { font = boldFont, color = { white = 1, alpha = 1.0 } })
--     .. hs.styledtext.new("  —  " .. artist, { font = normFont, color = { white = 1, alpha = 0.6 } })

--   spotifyCanvas[1] = {
--     type = "text",
--     text = styledLine,
--     frame = { x = 10, y = 12, w = 380, h = 30 }
--   }
-- end

-- updateSpotify()
-- spotifyCanvas:show()

-- if spotifyTimer then spotifyTimer:stop() end
-- spotifyTimer = hs.timer.doEvery(1, updateSpotify)
