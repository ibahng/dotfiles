local obj = {}
obj.__index = obj

local vaultPath = "/Users/ingyubahng/Workspaces/vault"
local targetConversationId = "7a752614-2d3f-4606-b9cf-6a24f84b9c73"
local hudWidth = 680
local inputHeight = 58
local responseHeight = 420
local topOffset = 60

local webview = nil
local usercontent = nil
local isVisible = false
local currentTask = nil

local function getHudFrame(height)
    local screen = hs.screen.mainScreen()
    local screenFrame = screen:frame()
    local x = screenFrame.x + (screenFrame.w - hudWidth) / 2
    local y = screenFrame.y + topOffset
    return { x = x, y = y, w = hudWidth, h = height }
end

local function generateHTML()
    return [[
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }
    html, body {
        width: 100%;
        height: 100%;
        margin: 0;
        padding: 0;
        background-color: transparent !important;
        background: transparent !important;
        overflow: hidden;
        font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "SF Pro Display", -system-ui, sans-serif;
        color: #f5f5f7;
        -webkit-font-smoothing: antialiased;
    }
    .hud-container {
        width: 100%;
        height: 100%;
        background: linear-gradient(165deg, rgba(32, 32, 38, 0.96) 0%, rgba(14, 14, 18, 0.98) 100%);
        border: 1px solid rgba(255, 255, 255, 0.12);
        border-top: 1px solid rgba(255, 255, 255, 0.22);
        border-radius: 16px;
        -webkit-mask-image: -webkit-radial-gradient(white, black);
        clip-path: inset(0 round 16px);
        -webkit-clip-path: inset(0 round 16px);
        display: flex;
        flex-direction: column;
        overflow: hidden;
    }
    
    /* Input View */
    .input-bar {
        display: flex;
        align-items: center;
        padding: 0 20px;
        height: 58px;
        min-height: 58px;
        cursor: text;
    }
    .input-field {
        flex: 1;
        background: transparent;
        border: none;
        outline: none;
        color: #ffffff;
        font-size: 15px;
        font-weight: 400;
        letter-spacing: -0.01em;
        user-select: text;
        -webkit-user-select: text;
    }
    .input-field::placeholder {
        color: rgba(235, 235, 245, 0.38);
    }
    .badge {
        font-size: 11px;
        font-weight: 500;
        text-transform: uppercase;
        letter-spacing: 0.04em;
        padding: 4px 8px;
        border-radius: 6px;
        background: rgba(255, 255, 255, 0.08);
        border: 0.5px solid rgba(255, 255, 255, 0.12);
        color: rgba(235, 235, 245, 0.6);
        margin-left: 12px;
        user-select: none;
        -webkit-user-select: none;
    }

    /* Loading View */
    .loading-bar {
        display: flex;
        align-items: center;
        padding: 0 20px;
        height: 55px;
        min-height: 55px;
    }
    .spinner-text {
        font-size: 14.5px;
        font-weight: 400;
        letter-spacing: -0.01em;
        color: rgba(235, 235, 245, 0.38);
        flex: 1;
    }
    .pulse-bar {
        width: 100%;
        height: 2.5px;
        background: linear-gradient(90deg, #3b82f6, #8b5cf6, #ec4899, #3b82f6);
        background-size: 300% 100%;
        opacity: 0.85;
        animation: gradientPulse 1.6s infinite linear;
        border-radius: 0 0 16px 16px;
    }
    @keyframes gradientPulse {
        0% { background-position: 0% 50%; }
        100% { background-position: 300% 50%; }
    }

    /* Response View */
    .response-view {
        display: none;
        flex-direction: column;
        height: 100%;
        padding: 16px 20px 14px 20px;
        overflow: hidden;
        border-radius: 0 0 16px 16px;
    }
    .response-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 12px;
        padding-bottom: 10px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        user-select: none;
        -webkit-user-select: none;
    }
    .response-title {
        font-size: 13px;
        font-weight: 600;
        color: #a78bfa;
        letter-spacing: -0.01em;
    }
    .response-content {
        flex: 1;
        overflow-y: auto;
        padding-right: 6px;
        font-size: 13.5px;
        line-height: 1.55;
        color: rgba(245, 245, 247, 0.94);
        user-select: text;
        -webkit-user-select: text;
    }
    .response-content::-webkit-scrollbar {
        width: 5px;
    }
    .response-content::-webkit-scrollbar-thumb {
        background: rgba(255, 255, 255, 0.22);
        border-radius: 4px;
    }
    .response-content h1, .response-content h2, .response-content h3 {
        color: #ffffff;
        margin: 12px 0 6px 0;
        font-weight: 600;
    }
    .response-content h1 { font-size: 17px; }
    .response-content h2 { font-size: 15px; }
    .response-content h3 { font-size: 13.5px; }
    .response-content p { margin-bottom: 8px; }
    .response-content ul, .response-content ol {
        margin: 6px 0 8px 18px;
    }
    .response-content li { margin-bottom: 4px; }
    .response-content pre {
        background: rgba(0, 0, 0, 0.5);
        padding: 10px;
        border-radius: 8px;
        margin: 8px 0;
        overflow-x: auto;
        border: 1px solid rgba(255, 255, 255, 0.08);
    }
    .response-content code {
        font-family: "SF Mono", Menlo, Monaco, Consolas, monospace;
        font-size: 12px;
        color: #93c5fd;
    }
    .response-footer {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        margin-top: 10px;
        padding-top: 10px;
        border-top: 1px solid rgba(255, 255, 255, 0.08);
        font-size: 11px;
        color: rgba(235, 235, 245, 0.4);
        user-select: none;
        -webkit-user-select: none;
    }
</style>
</head>
<body>
<div class="hud-container" id="hud">
    <!-- Input Mode -->
    <div class="input-bar" id="inputView" onclick="document.getElementById('promptInput').focus()">
        <input type="text" class="input-field" id="promptInput" placeholder="Ask or command CASPER..." autofocus autocomplete="off" spellcheck="false" />
        <span class="badge">Vault</span>
    </div>

    <!-- Loading Mode -->
    <div id="loadingView" style="display: none; flex-direction: column; width: 100%;">
        <div class="loading-bar">
            <span class="spinner-text" id="loadingText">Thinking in vault...</span>
            <span class="badge">Processing</span>
        </div>
        <div class="pulse-bar"></div>
    </div>

    <!-- Response Mode -->
    <div class="response-view" id="responseView">
        <div class="response-header">
            <span class="response-title">CASPER Response</span>
            <span class="badge">Session: 7a752614</span>
        </div>
        <div class="response-content" id="responseContent"></div>
        <div class="response-footer">
            <span>Esc to dismiss • Enter for new prompt</span>
        </div>
    </div>
</div>

<script>
    const inputView = document.getElementById('inputView');
    const loadingView = document.getElementById('loadingView');
    const responseView = document.getElementById('responseView');
    const promptInput = document.getElementById('promptInput');
    const responseContent = document.getElementById('responseContent');

    function sendToLua(action, data) {
        data = data || {};
        data.action = action;
        if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.casper) {
            window.webkit.messageHandlers.casper.postMessage(data);
        }
    }

    function renderMarkdown(md) {
        if (!md) return "";
        try {
            let html = md
                .replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
                .replace(/^### (.*$)/gim, '<h3>$1</h3>')
                .replace(/^## (.*$)/gim, '<h2>$1</h2>')
                .replace(/^# (.*$)/gim, '<h1>$1</h1>')
                .replace(/```([\s\S]*?)```/gm, '<pre><code>$1</code></pre>')
                .replace(/`([^`]+)`/g, '<code>$1</code>')
                .replace(/^\s*-\s+(.*$)/gim, '<li>$1</li>')
                .replace(/^\s*\d+\.\s+(.*$)/gim, '<li>$1</li>')
                .replace(/\n\n/g, '<p></p>')
                .replace(/\n/g, '<br/>');
            return html;
        } catch(e) {
            return md;
        }
    }

    function showInputState() {
        inputView.style.display = 'flex';
        loadingView.style.display = 'none';
        responseView.style.display = 'none';
        promptInput.value = '';
        sendToLua('resize', { height: 58 });
        setTimeout(() => {
            promptInput.focus();
            promptInput.select();
        }, 10);
    }

    function showLoadingState(text) {
        inputView.style.display = 'none';
        loadingView.style.display = 'flex';
        responseView.style.display = 'none';
        if (text) document.getElementById('loadingText').innerText = text;
        sendToLua('resize', { height: 58 });
    }

    function showResponseState(data) {
        inputView.style.display = 'none';
        loadingView.style.display = 'none';
        responseView.style.display = 'flex';
        const rawText = (typeof data === 'object' && data.text) ? data.text : (data || '');
        responseContent.innerHTML = renderMarkdown(rawText);
    }

    promptInput.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
            const val = promptInput.value.trim();
            if (val) {
                showLoadingState("Thinking in vault session...");
                sendToLua('submit', { prompt: val });
            }
        } else if (e.key === 'Escape') {
            sendToLua('close');
        }
    });

    window.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            sendToLua('close');
        } else if (e.key === 'Enter' && responseView.style.display === 'flex') {
            showInputState();
        }
    });
</script>
</body>
</html>
]]
end

local function initWebview()
    if webview then return end

    usercontent = hs.webview.usercontent.new("casper")
    usercontent:setCallback(function(message)
        local body = message.body
        if not body then return end
        
        if body.action == "submit" then
            obj.runQuery(body.prompt)
        elseif body.action == "close" then
            obj.hide()
        elseif body.action == "resize" and body.height then
            if webview then
                local newFrame = getHudFrame(body.height)
                webview:frame(newFrame)
            end
        end
    end)

    local initialFrame = getHudFrame(inputHeight)
    webview = hs.webview.new(initialFrame, { developerExtras = false }, usercontent)
    webview:windowStyle(hs.webview.windowMasks.borderless)
    webview:transparent(true)
    webview:allowTextEntry(true)
    webview:level(hs.drawing.windowLevels.floating)
    webview:behavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
    webview:shadow(false)
    webview:html(generateHTML())
end

function obj.show()
    initWebview()
    local frame = getHudFrame(inputHeight)
    webview:frame(frame)
    webview:show()
    webview:bringToFront(true)
    
    local win = webview:hswindow()
    if win then
        win:focus()
    end
    
    webview:evaluateJavaScript("showInputState();")
    isVisible = true
end

function obj.hide()
    if webview then
        webview:hide()
    end
    isVisible = false
end

function obj.toggle()
    if isVisible then
        obj.hide()
    else
        obj.show()
    end
end

function obj.runQuery(promptText)
    if not promptText or promptText == "" then return end

    -- Cancel any previous pending task
    if currentTask and currentTask:isRunning() then
        currentTask:terminate()
    end

    local command = string.format(
        'export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"; cd %s && agy --conversation %s -p "$1" --dangerously-skip-permissions',
        vaultPath,
        targetConversationId
    )

    currentTask = hs.task.new(
        "/bin/zsh",
        function(exitCode, stdOut, stdErr)
            currentTask = nil
            
            local resultText = ""
            if exitCode == 0 then
                resultText = (stdOut and stdOut ~= "") and stdOut or "CASPER completed with no output."
            else
                local errMsg = (stdErr and stdErr ~= "") and stdErr or (stdOut and stdOut ~= "" and stdOut or "Unknown error")
                resultText = "Error (" .. tostring(exitCode) .. "):\n" .. errMsg
            end

            if webview then
                -- Resize frame to expanded response height directly in Lua
                local frame = getHudFrame(responseHeight)
                webview:frame(frame)
                
                -- Ensure webview is visible and focused
                webview:show()
                webview:bringToFront(true)
                local win = webview:hswindow()
                if win then win:focus() end

                -- Deliver JSON payload safely to WebKit
                local payload = hs.json.encode({ text = resultText })
                webview:evaluateJavaScript("showResponseState(" .. payload .. ");")
            end
        end,
        {
            "-l",
            "-c",
            command,
            "casper-runner",
            promptText
        }
    )
    currentTask:start()
end

-- Global shortcut: Cmd + Shift + Space
hs.hotkey.bind({"cmd", "shift"}, "space", function()
    obj.toggle()
end)

return obj
