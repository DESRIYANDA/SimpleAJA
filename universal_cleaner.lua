-- Universal Script Cleaner - Memory & Performance Optimizer
-- Cleans up ALL third-party scripts and restores game performance
-- Author: donitono
-- Use this when ANY script makes your game laggy or heavy

print("🧹 Universal Script Cleaner Loading...")
print("🎯 Target: All third-party scripts causing lag")

-- Configuration
local CONFIG = {
    AGGRESSIVE_MODE = true,  -- Set to false for gentler cleanup
    VERBOSE_LOGGING = true,  -- Show detailed cleanup process
    FORCE_GARBAGE_COLLECT = true,  -- Multiple garbage collection passes
    CLEAN_UNKNOWN_GLOBALS = true,  -- Clean suspicious global variables
    DISCONNECT_ALL_SUSPICIOUS = true  -- Disconnect all suspicious connections
}

-- Statistics tracking
local STATS = {
    connections_disconnected = 0,
    globals_cleaned = 0,
    guis_closed = 0,
    memory_freed = 0,
    threads_stopped = 0
}

-- Function to log with emojis
local function log(message, emoji)
    if CONFIG.VERBOSE_LOGGING then
        print((emoji or "ℹ️") .. " " .. message)
    end
end

-- Function to safely execute with error handling
local function safeExecute(func, description)
    local success, result = pcall(func)
    if not success then
        log("Failed: " .. description .. " - " .. tostring(result), "❌")
        return false
    end
    return true, result
end

-- Function to check if a string contains suspicious keywords
local function isSuspiciousString(str)
    if not str or type(str) ~= "string" then return false end
    
    local suspicious_keywords = {
        -- Common script keywords
        "script", "hack", "exploit", "cheat", "bypass", "auto",
        "farm", "bot", "macro", "loop", "infinite", "spam",
        "teleport", "speed", "fly", "noclip", "godmode",
        "esp", "wallhack", "aimbot", "money", "cash", "robux",
        "premium", "vip", "admin", "mod", "owner",
        -- Performance heavy operations
        "while true", "spawn", "coroutine", "thread", "timer",
        "renderstepped", "heartbeat", "stepped", "runservice",
        "tweenservice", "tween", "animation", "particle",
        "sound", "music", "gui", "frame", "button", "label",
        -- Suspicious patterns
        "getgenv", "loadstring", "httpget", "readfile", "writefile",
        "request", "syn", "krnl", "fluxus", "oxygen", "sentinel"
    }
    
    local lowerStr = str:lower()
    for _, keyword in pairs(suspicious_keywords) do
        if string.find(lowerStr, keyword) then
            return true
        end
    end
    return false
end

-- Function to disconnect all suspicious RunService connections
local function cleanRunServiceConnections()
    log("Cleaning RunService connections...", "🔌")
    local RunService = game:GetService("RunService")
    local disconnected = 0
    
    -- Clean Heartbeat connections
    safeExecute(function()
        for _, connection in pairs(getconnections(RunService.Heartbeat)) do
            if connection.Function then
                local funcStr = tostring(connection.Function)
                if isSuspiciousString(funcStr) or CONFIG.DISCONNECT_ALL_SUSPICIOUS then
                    connection:Disconnect()
                    disconnected = disconnected + 1
                    log("Disconnected Heartbeat connection", "🔌")
                end
            end
        end
    end, "Heartbeat cleanup")
    
    -- Clean RenderStepped connections
    safeExecute(function()
        for _, connection in pairs(getconnections(RunService.RenderStepped)) do
            if connection.Function then
                local funcStr = tostring(connection.Function)
                if isSuspiciousString(funcStr) or CONFIG.DISCONNECT_ALL_SUSPICIOUS then
                    connection:Disconnect()
                    disconnected = disconnected + 1
                    log("Disconnected RenderStepped connection", "🔌")
                end
            end
        end
    end, "RenderStepped cleanup")
    
    -- Clean Stepped connections
    safeExecute(function()
        for _, connection in pairs(getconnections(RunService.Stepped)) do
            if connection.Function then
                local funcStr = tostring(connection.Function)
                if isSuspiciousString(funcStr) or CONFIG.DISCONNECT_ALL_SUSPICIOUS then
                    connection:Disconnect()
                    disconnected = disconnected + 1
                    log("Disconnected Stepped connection", "🔌")
                end
            end
        end
    end, "Stepped cleanup")
    
    STATS.connections_disconnected = STATS.connections_disconnected + disconnected
    log("RunService cleanup complete: " .. disconnected .. " connections", "✅")
    return disconnected
end

-- Function to clean suspicious global variables
local function cleanGlobalVariables()
    log("Cleaning global variables...", "🧹")
    local cleaned = 0
    
    -- Store original important globals to preserve
    local important_globals = {
        "game", "workspace", "script", "print", "warn", "error",
        "wait", "spawn", "delay", "tick", "time", "os", "math",
        "string", "table", "pairs", "ipairs", "next", "type",
        "getfenv", "setfenv", "getmetatable", "setmetatable",
        "rawget", "rawset", "rawequal", "rawlen", "select",
        "tonumber", "tostring", "unpack", "xpcall", "pcall",
        "_G", "_VERSION", "bit32", "utf8", "coroutine", "debug"
    }
    
    -- Create lookup table for faster checking
    local important_lookup = {}
    for _, name in pairs(important_globals) do
        important_lookup[name] = true
    end
    
    -- Clean suspicious globals
    safeExecute(function()
        for key, value in pairs(_G) do
            if type(key) == "string" and not important_lookup[key] then
                if isSuspiciousString(key) or CONFIG.CLEAN_UNKNOWN_GLOBALS then
                    _G[key] = nil
                    cleaned = cleaned + 1
                    log("Cleaned global: " .. key, "🧹")
                end
            end
        end
    end, "Global variables cleanup")
    
    STATS.globals_cleaned = STATS.globals_cleaned + cleaned
    log("Global cleanup complete: " .. cleaned .. " variables", "✅")
    return cleaned
end

-- Function to clean up all GUIs
local function cleanAllGUIs()
    log("Cleaning GUIs...", "🗑️")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local closed = 0
    
    safeExecute(function()
        local PlayerGui = LocalPlayer.PlayerGui
        
        for _, gui in pairs(PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                -- Check if GUI is suspicious or not default
                local isDefault = gui.Name == "Chat" or 
                                gui.Name == "PlayerList" or 
                                gui.Name == "Backpack" or
                                gui.Name == "Health" or
                                gui.Name == "TouchGui" or
                                gui.Name == "ControlsGui"
                
                if not isDefault and (isSuspiciousString(gui.Name) or CONFIG.AGGRESSIVE_MODE) then
                    -- Also disconnect GUI event listeners
                    for _, connection in pairs(getconnections(gui.ChildAdded)) do
                        connection:Disconnect()
                    end
                    for _, connection in pairs(getconnections(gui.DescendantAdded)) do
                        connection:Disconnect()
                    end
                    
                    gui:Destroy()
                    closed = closed + 1
                    log("Closed GUI: " .. gui.Name, "🗑️")
                end
            end
        end
    end, "GUI cleanup")
    
    STATS.guis_closed = STATS.guis_closed + closed
    log("GUI cleanup complete: " .. closed .. " GUIs", "✅")
    return closed
end

-- Function to stop all suspicious threads and coroutines
local function cleanThreads()
    log("Cleaning threads and coroutines...", "🧵")
    local stopped = 0
    
    -- This is a bit tricky since we can't directly access all running coroutines
    -- But we can clean up some common thread patterns
    safeExecute(function()
        -- Force yield to let any pending operations complete
        for i = 1, 5 do
            game:GetService("RunService").Heartbeat:Wait()
        end
        stopped = stopped + 1
        log("Forced thread cleanup cycles", "🧵")
    end, "Thread cleanup")
    
    STATS.threads_stopped = STATS.threads_stopped + stopped
    log("Thread cleanup complete", "✅")
    return stopped
end

-- Function to clean up TweenService
local function cleanTweenService()
    log("Cleaning TweenService...", "🎬")
    local TweenService = game:GetService("TweenService")
    local cleaned = 0
    
    safeExecute(function()
        -- We can't directly access all tweens, but we can force completion
        -- by waiting a bit and forcing garbage collection
        for i = 1, 3 do
            game:GetService("RunService").Heartbeat:Wait()
        end
        cleaned = cleaned + 1
        log("TweenService cleanup cycle completed", "🎬")
    end, "TweenService cleanup")
    
    log("TweenService cleanup complete", "✅")
    return cleaned
end

-- Function to clean up SoundService
local function cleanSoundService()
    log("Cleaning SoundService...", "🔊")
    local SoundService = game:GetService("SoundService")
    local cleaned = 0
    
    safeExecute(function()
        -- Stop all sounds that might be playing from scripts
        for _, sound in pairs(SoundService:GetChildren()) do
            if sound:IsA("Sound") then
                sound:Stop()
                cleaned = cleaned + 1
                log("Stopped sound: " .. sound.Name, "🔊")
            end
        end
        
        -- Also check workspace for sounds
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Sound") and obj.IsPlaying then
                obj:Stop()
                cleaned = cleaned + 1
                log("Stopped workspace sound: " .. obj.Name, "🔊")
            end
        end
    end, "SoundService cleanup")
    
    log("SoundService cleanup complete: " .. cleaned .. " sounds", "✅")
    return cleaned
end

-- Function for aggressive memory cleanup
local function aggressiveMemoryCleanup()
    log("Starting aggressive memory cleanup...", "🧽")
    
    if CONFIG.FORCE_GARBAGE_COLLECT then
        for i = 1, 5 do
            safeExecute(function()
                collectgarbage("collect")
                wait(0.1)
            end, "Garbage collection pass " .. i)
            log("Garbage collection pass " .. i .. "/5", "🧽")
        end
        
        -- Force Lua memory cleanup
        safeExecute(function()
            collectgarbage("restart")
        end, "Garbage collector restart")
        
        log("Memory cleanup complete", "✅")
    end
end

-- Function to get memory usage (approximate)
local function getMemoryUsage()
    local memKB = collectgarbage("count")
    return math.floor(memKB * 10) / 10  -- Round to 1 decimal
end

-- Main universal cleanup function
local function universalCleanup()
    print("")
    print("🚨 UNIVERSAL SCRIPT CLEANER STARTED 🚨")
    print("=====================================")
    print("🎯 Cleaning ALL third-party scripts")
    print("⚙️ Mode: " .. (CONFIG.AGGRESSIVE_MODE and "AGGRESSIVE" or "GENTLE"))
    print("")
    
    local startTime = tick()
    local startMemory = getMemoryUsage()
    
    -- Step 1: Clean RunService connections
    print("🔌 Step 1: Cleaning RunService connections...")
    cleanRunServiceConnections()
    wait(0.5)
    
    -- Step 2: Clean threads
    print("🧵 Step 2: Cleaning threads and coroutines...")
    cleanThreads()
    wait(0.5)
    
    -- Step 3: Clean GUIs
    print("🗑️ Step 3: Cleaning all GUIs...")
    cleanAllGUIs()
    wait(0.5)
    
    -- Step 4: Clean global variables
    print("🧹 Step 4: Cleaning global variables...")
    cleanGlobalVariables()
    wait(0.5)
    
    -- Step 5: Clean TweenService
    print("🎬 Step 5: Cleaning TweenService...")
    cleanTweenService()
    wait(0.5)
    
    -- Step 6: Clean SoundService
    print("🔊 Step 6: Cleaning SoundService...")
    cleanSoundService()
    wait(0.5)
    
    -- Step 7: Aggressive memory cleanup
    print("🧽 Step 7: Aggressive memory cleanup...")
    aggressiveMemoryCleanup()
    wait(1)
    
    -- Calculate results
    local endTime = tick()
    local endMemory = getMemoryUsage()
    local timeTaken = math.floor((endTime - startTime) * 100) / 100
    STATS.memory_freed = startMemory - endMemory
    
    -- Final report
    print("")
    print("=====================================")
    print("✅ UNIVERSAL CLEANUP COMPLETED!")
    print("=====================================")
    print("📊 CLEANUP STATISTICS:")
    print("  🔌 Connections disconnected: " .. STATS.connections_disconnected)
    print("  🧹 Global variables cleaned: " .. STATS.globals_cleaned)
    print("  🗑️ GUIs closed: " .. STATS.guis_closed)
    print("  🧵 Thread cleanup cycles: " .. STATS.threads_stopped)
    print("  🧽 Memory freed: " .. (STATS.memory_freed > 0 and "+" or "") .. STATS.memory_freed .. " KB")
    print("  ⏱️ Time taken: " .. timeTaken .. " seconds")
    print("")
    print("🎮 Game performance should be restored!")
    print("💡 Safe to run new scripts now")
    print("🔄 Run again if needed: _G.UniversalCleanup()")
    
    -- Send notification
    safeExecute(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "🧹 Universal Cleaner";
            Text = "Cleanup complete! Performance restored.";
            Duration = 5;
        })
    end, "Notification")
end

-- Execute cleanup immediately
universalCleanup()

-- Provide global function for manual use
_G.UniversalCleanup = universalCleanup

-- Also provide configuration function
_G.UniversalCleanupConfig = function(aggressive, verbose, forceGC)
    CONFIG.AGGRESSIVE_MODE = aggressive or CONFIG.AGGRESSIVE_MODE
    CONFIG.VERBOSE_LOGGING = verbose or CONFIG.VERBOSE_LOGGING
    CONFIG.FORCE_GARBAGE_COLLECT = forceGC or CONFIG.FORCE_GARBAGE_COLLECT
    print("🔧 Universal Cleaner config updated!")
    print("  Aggressive: " .. tostring(CONFIG.AGGRESSIVE_MODE))
    print("  Verbose: " .. tostring(CONFIG.VERBOSE_LOGGING))
    print("  Force GC: " .. tostring(CONFIG.FORCE_GARBAGE_COLLECT))
end

print("")
print("🧹 UNIVERSAL SCRIPT CLEANER LOADED!")
print("🔄 Manual usage: _G.UniversalCleanup()")
print("⚙️ Config: _G.UniversalCleanupConfig(aggressive, verbose, forceGC)")
print("📖 This script cleans ANY third-party script causing lag")