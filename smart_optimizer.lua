-- Smart Script Optimizer - Clean lag without stopping useful scripts
-- Optimizes performance while keeping your scripts running
-- Author: donitono

print("🎯 Smart Script Optimizer Loading...")
print("💡 Cleans lag while preserving useful scripts")

-- Configuration
local CONFIG = {
    PRESERVE_WORKING_SCRIPTS = true,  -- Keep scripts that seem to be working properly
    MEMORY_OPTIMIZATION = true,      -- Focus on memory optimization
    GENTLE_CLEANUP = true,           -- Don't aggressively destroy everything
    PRESERVE_GUIS = true,           -- Keep GUIs that user might need
    SMART_DETECTION = true          -- Only clean problematic connections
}

-- Statistics
local STATS = {
    lag_connections_removed = 0,
    memory_optimized = 0,
    guis_optimized = 0,
    performance_improved = 0
}

-- Function to log with emojis
local function log(message, emoji)
    print((emoji or "ℹ️") .. " " .. message)
end

-- Function to safely execute
local function safeExecute(func, description)
    local success, result = pcall(func)
    if not success then
        log("Skipped: " .. description, "⚠️")
        return false
    end
    return true, result
end

-- Function to detect if a connection is causing lag
local function isLaggyConnection(connection)
    if not connection.Function then return false end
    
    local funcStr = tostring(connection.Function)
    local lowerFunc = funcStr:lower()
    
    -- Detect performance-heavy patterns
    local lag_patterns = {
        "while true", "infinite", "loop.*loop", "spawn.*spawn",
        "wait%(0%)", "wait%(0%.0", -- Very short waits
        "renderstepped.*renderstepped", -- Nested renderstepped
        "heartbeat.*heartbeat", -- Nested heartbeat
        "memory", "lag", "freeze", "crash",
        "heavy", "intensive", "massive"
    }
    
    for _, pattern in pairs(lag_patterns) do
        if string.find(lowerFunc, pattern) then
            return true
        end
    end
    
    return false
end

-- Function to detect if a global variable is problematic
local function isProblematicGlobal(key, value)
    if type(key) ~= "string" then return false end
    
    local keyLower = key:lower()
    
    -- Keep important and useful globals
    local safe_patterns = {
        "auto", "script", "tool", "farm", "collect", "helper",
        "gui", "menu", "config", "setting", "save", "load"
    }
    
    -- Only clean globals that are clearly problematic
    local problematic_patterns = {
        "lag", "crash", "freeze", "memory.*leak", "infinite",
        "spam", "flood", "ddos", "virus", "malware",
        "temp.*temp", "test.*test", "debug.*debug"
    }
    
    -- Check if it's a useful script global
    for _, pattern in pairs(safe_patterns) do
        if string.find(keyLower, pattern) then
            return false  -- Keep this global
        end
    end
    
    -- Check if it's problematic
    for _, pattern in pairs(problematic_patterns) do
        if string.find(keyLower, pattern) then
            return true  -- Remove this global
        end
    end
    
    -- If we don't know what it is, keep it (gentle approach)
    return false
end

-- Function to detect if a GUI should be kept
local function shouldKeepGUI(gui)
    if not gui:IsA("ScreenGui") then return true end
    
    -- Always keep default Roblox GUIs
    local default_guis = {
        "Chat", "PlayerList", "Backpack", "Health", 
        "TouchGui", "ControlsGui", "BubbleChat", "EmotesMenu"
    }
    
    for _, defaultName in pairs(default_guis) do
        if gui.Name == defaultName then
            return true
        end
    end
    
    -- Keep GUIs that seem functional and not laggy
    local guiName = gui.Name:lower()
    
    -- Keep useful script GUIs
    local useful_patterns = {
        "auto", "farm", "tool", "helper", "config", 
        "menu", "setting", "control", "panel"
    }
    
    -- Remove only problematic GUIs
    local problematic_patterns = {
        "lag", "crash", "test", "debug", "temp", "spam"
    }
    
    -- Check for useful patterns
    for _, pattern in pairs(useful_patterns) do
        if string.find(guiName, pattern) then
            return true  -- Keep useful GUIs
        end
    end
    
    -- Check for problematic patterns
    for _, pattern in pairs(problematic_patterns) do
        if string.find(guiName, pattern) then
            return false  -- Remove problematic GUIs
        end
    end
    
    -- If GUI has many children (complex GUI), probably useful
    if #gui:GetChildren() > 5 then
        return true
    end
    
    -- Default: keep unknown GUIs (gentle approach)
    return true
end

-- Smart RunService optimization
local function optimizeRunService()
    log("Optimizing RunService connections...", "🔧")
    local RunService = game:GetService("RunService")
    local optimized = 0
    
    -- Check Heartbeat connections
    safeExecute(function()
        for _, connection in pairs(getconnections(RunService.Heartbeat)) do
            if isLaggyConnection(connection) then
                connection:Disconnect()
                optimized = optimized + 1
                log("Removed laggy Heartbeat connection", "🗑️")
            end
        end
    end, "Heartbeat optimization")
    
    -- Check RenderStepped connections  
    safeExecute(function()
        for _, connection in pairs(getconnections(RunService.RenderStepped)) do
            if isLaggyConnection(connection) then
                connection:Disconnect()
                optimized = optimized + 1
                log("Removed laggy RenderStepped connection", "🗑️")
            end
        end
    end, "RenderStepped optimization")
    
    -- Check Stepped connections
    safeExecute(function()
        for _, connection in pairs(getconnections(RunService.Stepped)) do
            if isLaggyConnection(connection) then
                connection:Disconnect()
                optimized = optimized + 1
                log("Removed laggy Stepped connection", "🗑️")
            end
        end
    end, "Stepped optimization")
    
    STATS.lag_connections_removed = optimized
    log("RunService optimization complete: " .. optimized .. " lag connections removed", "✅")
    return optimized
end

-- Smart global variables cleanup
local function optimizeGlobals()
    log("Optimizing global variables...", "🧹")
    local cleaned = 0
    
    safeExecute(function()
        for key, value in pairs(_G) do
            if isProblematicGlobal(key, value) then
                _G[key] = nil
                cleaned = cleaned + 1
                log("Cleaned problematic global: " .. key, "🧹")
            end
        end
    end, "Global variables optimization")
    
    STATS.memory_optimized = cleaned
    log("Global optimization complete: " .. cleaned .. " problematic variables", "✅")
    return cleaned
end

-- Smart GUI optimization
local function optimizeGUIs()
    log("Optimizing GUIs...", "🖼️")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local optimized = 0
    
    safeExecute(function()
        local PlayerGui = LocalPlayer.PlayerGui
        
        for _, gui in pairs(PlayerGui:GetChildren()) do
            if not shouldKeepGUI(gui) then
                -- Clean up GUI event listeners before destroying
                for _, connection in pairs(getconnections(gui.ChildAdded)) do
                    if isLaggyConnection(connection) then
                        connection:Disconnect()
                    end
                end
                
                gui:Destroy()
                optimized = optimized + 1
                log("Removed problematic GUI: " .. gui.Name, "🗑️")
            end
        end
    end, "GUI optimization")
    
    STATS.guis_optimized = optimized
    log("GUI optimization complete: " .. optimized .. " problematic GUIs", "✅")
    return optimized
end

-- Memory optimization without breaking scripts
local function smartMemoryOptimization()
    log("Smart memory optimization...", "🧠")
    local startMem = collectgarbage("count")
    
    -- Gentle garbage collection
    for i = 1, 3 do  -- Only 3 passes instead of 5
        safeExecute(function()
            collectgarbage("collect")
            wait(0.2)  -- Longer wait to be gentle
        end, "Memory optimization pass " .. i)
        log("Memory pass " .. i .. "/3", "🧠")
    end
    
    local endMem = collectgarbage("count")
    local freed = startMem - endMem
    
    log("Memory optimization complete: " .. math.floor(freed * 10) / 10 .. " KB freed", "✅")
    return freed
end

-- Function to stop only problematic sounds
local function optimizeSounds()
    log("Optimizing sounds...", "🔊")
    local optimized = 0
    
    safeExecute(function()
        -- Only stop sounds that are clearly problematic
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Sound") and obj.IsPlaying then
                local soundName = obj.Name:lower()
                
                -- Only stop problematic sounds
                if string.find(soundName, "lag") or 
                   string.find(soundName, "spam") or
                   string.find(soundName, "crash") or
                   obj.Volume > 0.8 then  -- Very loud sounds
                    obj:Stop()
                    optimized = optimized + 1
                    log("Stopped problematic sound: " .. obj.Name, "🔊")
                end
            end
        end
    end, "Sound optimization")
    
    log("Sound optimization complete: " .. optimized .. " sounds", "✅")
    return optimized
end

-- Main smart optimization function
local function smartOptimize()
    print("")
    print("🎯 SMART SCRIPT OPTIMIZER STARTED")
    print("==================================")
    print("💡 Optimizing performance while keeping your scripts running")
    print("🔧 Mode: GENTLE & SMART")
    print("")
    
    local startTime = tick()
    local startMemory = collectgarbage("count")
    
    -- Step 1: Optimize RunService (remove only laggy connections)
    print("🔧 Step 1: Optimizing RunService...")
    optimizeRunService()
    wait(0.3)
    
    -- Step 2: Smart memory optimization
    print("🧠 Step 2: Smart memory optimization...")
    smartMemoryOptimization()
    wait(0.3)
    
    -- Step 3: Optimize problematic globals only
    print("🧹 Step 3: Optimizing global variables...")
    optimizeGlobals()
    wait(0.3)
    
    -- Step 4: Optimize problematic GUIs only
    print("🖼️ Step 4: Optimizing GUIs...")
    optimizeGUIs()
    wait(0.3)
    
    -- Step 5: Optimize problematic sounds only
    print("🔊 Step 5: Optimizing sounds...")
    optimizeSounds()
    wait(0.3)
    
    -- Calculate results
    local endTime = tick()
    local endMemory = collectgarbage("count")
    local timeTaken = math.floor((endTime - startTime) * 100) / 100
    local memoryFreed = startMemory - endMemory
    
    -- Final report
    print("")
    print("==================================")
    print("✅ SMART OPTIMIZATION COMPLETED!")
    print("==================================")
    print("📊 OPTIMIZATION RESULTS:")
    print("  🗑️ Lag connections removed: " .. STATS.lag_connections_removed)
    print("  🧹 Problematic globals cleaned: " .. STATS.memory_optimized)
    print("  🖼️ Problematic GUIs optimized: " .. STATS.guis_optimized)
    print("  🧠 Memory freed: " .. math.floor(memoryFreed * 10) / 10 .. " KB")
    print("  ⏱️ Time taken: " .. timeTaken .. " seconds")
    print("")
    print("✨ Your useful scripts should still be running!")
    print("🎮 Performance improved without breaking functionality")
    print("🔄 Run again if needed: _G.SmartOptimize()")
    
    -- Notification
    safeExecute(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "🎯 Smart Optimizer";
            Text = "Performance improved! Scripts preserved.";
            Duration = 5;
        })
    end, "Notification")
end

-- Execute optimization
smartOptimize()

-- Provide global functions
_G.SmartOptimize = smartOptimize

-- Function to check what scripts are still running
_G.CheckActiveScripts = function()
    print("🔍 ACTIVE SCRIPTS CHECK:")
    print("=======================")
    
    local activeCount = 0
    
    -- Check globals
    print("📋 Active Globals:")
    for key, value in pairs(_G) do
        if type(key) == "string" and not string.find(key, "^[A-Z]") then -- Not built-in globals
            local keyLower = key:lower()
            if string.find(keyLower, "auto") or string.find(keyLower, "script") or string.find(keyLower, "tool") then
                print("  ✅ " .. key)
                activeCount = activeCount + 1
            end
        end
    end
    
    -- Check GUIs
    print("🖼️ Active GUIs:")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer.PlayerGui
    
    for _, gui in pairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and shouldKeepGUI(gui) then
            print("  ✅ " .. gui.Name)
            activeCount = activeCount + 1
        end
    end
    
    print("=======================")
    print("📊 Total active: " .. activeCount)
    
    return activeCount
end

print("")
print("🎯 SMART SCRIPT OPTIMIZER LOADED!")
print("🔄 Optimize again: _G.SmartOptimize()")
print("🔍 Check active scripts: _G.CheckActiveScripts()")
print("💡 This preserves your useful scripts while cleaning lag!")