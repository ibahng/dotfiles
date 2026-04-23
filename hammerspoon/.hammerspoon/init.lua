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

-- 1. Configuration
local desktopStyle = {
    fontName = "SFMono-Regular",
    statsSize = 12,
    color = { white = 1, alpha = 0.8 },
    position = { x = 40, y = 70, w = 700, h = 267 } 
}

-- 2. Create the Canvas
local infoCanvas = hs.canvas.new(desktopStyle.position)
infoCanvas:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
infoCanvas:level(hs.canvas.windowLevels.desktopIcon)

-- 3. Helper: Get System Stats
local function getSystemStats()
    local function safe(fn)
        local ok, result = pcall(fn)
        return ok and result or "ERROR"
    end
    local username = safe(function()
        local user = hs.execute("whoami"):gsub("%s+", "")
        local host = hs.execute("hostname -s"):gsub("%s+", "")
        return user .. "@" .. host
    end)
    local os_ver = safe(function()
        local name = hs.execute("sw_vers -productName"):gsub("%s+", "")
        local version = hs.execute("sw_vers -productVersion"):gsub("%s+", "")
        local build = hs.execute("sw_vers -buildVersion"):gsub("%s+", "")
        local arch = hs.execute("uname -m"):gsub("%s+", "")
        return string.format("%s %s (%s) %s", name, version, build, arch)
    end)
    local host = safe(function()
        local name = hs.execute("system_profiler SPHardwareDataType | awk -F': ' '/Model Name/{print $2}'"):gsub("%s+$", "")
        local chip = hs.execute("system_profiler SPHardwareDataType | awk -F': ' '/Chip/{print $2}'"):gsub("%s+$", "")
        return string.format("%s (%s, 2020)", name, chip)
    end)
    local kernel = safe(function()
        return hs.execute("uname -sr"):gsub("%s+$", "")
    end)
    local uptime = safe(function()
        local u = hs.execute("sysctl -n kern.boottime | awk '{print $4}' | tr -d ','")
        local boot = tonumber(u)
        local now = os.time()
        local diff = now - boot
        local days = math.floor(diff / 86400)
        local hours = math.floor((diff % 86400) / 3600)
        local mins = math.floor((diff % 3600) / 60)
        return string.format("%d days, %d hours, %d mins", days, hours, mins)
    end)
    local shell = safe(function()
        local s = hs.execute("zsh --version"):match("zsh (%S+)")
        return "zsh " .. (s or "ERROR")
    end)
    local displays = safe(function()
        local result = {}
        for _, screen in ipairs(hs.screen.allScreens()) do
            local name = screen:name()
            local mode = screen:currentMode()
            local tag = (screen == hs.screen.primaryScreen()) and "[Built-in]" or "[External]"
            table.insert(result, string.format("%dx%d @ %dHz %s", mode.w, mode.h, mode.freq, tag))
        end
        return result
    end)
    local wm = safe(function()
        local v = hs.execute("defaults read /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/CoreGraphics.framework/Versions/A/Resources/Info.plist CFBundleShortVersionString"):gsub("%s+", "")
        return "Quartz Compositor " .. v .. " (with Yabai)"
    end)
    local wm_theme = safe(function()
        local dark = hs.execute("defaults read -g AppleInterfaceStyle 2>/dev/null"):gsub("%s+", "")
        local mode = (dark == "Dark") and "Dark" or "Light"
        local accent = hs.execute("defaults read -g AppleAccentColor 2>/dev/null"):gsub("%s+", "")
        local colors = { ["-1"] = "Graphite", ["0"] = "Red", ["1"] = "Orange", ["2"] = "Yellow", ["3"] = "Green", ["4"] = "Blue", ["5"] = "Purple", ["6"] = "Pink" }
        local color = colors[accent] or "Blue"
        return color .. " (" .. mode .. ")"
    end)
    local load = safe(function()
        local cpu = hs.host.cpuUsage()
        return string.format("Apple M1 (8) @ 3.20 GHz  [%.1f%% load]", cpu.overall.active)
    end)
    local gpu = safe(function()
        local cores = hs.execute("system_profiler SPDisplaysDataType | awk -F': ' '/Total Number of Cores/{print $2}'"):gsub("%s+$", "")
        return string.format("Apple M1 (%s) [Integrated]", cores)
    end)
    local mem = safe(function()
        local m = hs.host.vmStat()
        local pageSize = m.pageSize
        local memTotal = m.memSize / (1024^3)
        local memUsed = (m.pagesActive + m.pagesWiredDown + m.pagesUsedByVMCompressor) * pageSize / (1024^3)
        local pct = (memUsed / memTotal) * 100
        return string.format("%.2f GiB / %.2f GiB (%.0f%%)", memUsed, memTotal, pct)
    end)
    local swap = safe(function()
        local s = hs.execute("sysctl -n vm.swapusage")
        local used = s:match("used = (%S+)M")
        local total = s:match("total = (%S+)M")
        if used and total then
            local usedN = tonumber(used) / 1024
            local totalN = tonumber(total) / 1024
            local pct = (usedN / totalN) * 100
            return string.format("%.2f GiB / %.2f GiB (%.0f%%)", usedN, totalN, pct)
        end
        return "ERROR"
    end)
    local ip = safe(function()
        return hs.execute("ipconfig getifaddr en0"):gsub("%s+", "") .. "/24"
    end)
    local locale = safe(function()
        return hs.execute("defaults read -g AppleLocale"):gsub("%s+", "") .. ".UTF-8"
    end)

    local boldFont  = { name = "SFMono-Bold", size = desktopStyle.statsSize }
    local normFont  = { name = desktopStyle.fontName, size = desktopStyle.statsSize }
    local keyColor  = { white = 1, alpha = 0.9 }
    local valColor  = { white = 1, alpha = 0.85 }
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
        .. line("Shell", shell)

    if type(displays) == "table" then
        for i, screen in ipairs(hs.screen.allScreens()) do
            result = result .. line("Display (" .. screen:name() .. ")", displays[i] or "ERROR")
        end
    end

    result = result
        .. line("WM", wm)
        .. line("WM Theme", wm_theme)
        .. line("CPU", load)
        .. line("GPU", gpu)
        .. line("Memory", mem)
        .. line("Swap", swap)
        .. line("Local IP (en0)", ip)
        .. line("Locale", locale)

    return result
end

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
        frame = { x = 15, y = 30, w = 200, h = 245 }
    }

    infoCanvas[3] = {
        type = "text",
        text = styledText,
        frame = { x = 230, y = 15, w = 480, h = 245 }
    }
end

-- 5. Initialize and Start
updateDisplay()
infoCanvas:show()

-- Refresh every 1 second
if infoTimer then infoTimer:stop() end
infoTimer = hs.timer.doEvery(1, updateDisplay)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
  hs.reload()
end)
hs.alert.show("Config loaded")

print(hs.execute("df -k /"))
