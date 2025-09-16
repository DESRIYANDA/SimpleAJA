--// Fishing Remote Event Monitor
--// Script untuk monitor semua remote events saat fishing normal

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local lp = Players.LocalPlayer

print("🔍 FISHING REMOTE EVENT MONITOR LOADED")
print("Play minigame normally - all events will be logged!")
print("===============================================")

-- Store captured events for analysis
local capturedEvents = {}
local monitoringActive = false

-- Function to log events with timestamp
local function logEvent(eventName, args, source)
    local timestamp = tick()
    local eventData = {
        name = eventName,
        args = args,
        source = source,
        time = timestamp,
        timeString = os.date("%H:%M:%S", timestamp)
    }
    
    table.insert(capturedEvents, eventData)
    
    print("📡 [" .. eventData.timeString .. "] " .. source .. " -> " .. eventName)
    if args and #args > 0 then
        for i, arg in ipairs(args) do
            print("   Arg " .. i .. ": " .. tostring(arg) .. " (" .. type(arg) .. ")")
        end
    else
        print("   No arguments")
    end
    print("")
end

-- Hook all FireServer calls to monitor outgoing events
local function setupOutgoingMonitor()
    if not hookmetamethod then
        warn("⚠️ hookmetamethod not available - cannot monitor outgoing events")
        return false
    end
    
    print("🔍 Setting up outgoing event monitor...")
    
    local originalFireServer
    originalFireServer = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "FireServer" then
            local eventName = self.Name
            local eventPath = self:GetFullName()
            
            -- Only log fishing-related events
            if string.find(eventName:lower(), "reel") or 
               string.find(eventName:lower(), "cast") or 
               string.find(eventName:lower(), "fish") or 
               string.find(eventName:lower(), "catch") or
               string.find(eventPath:lower(), "fishing") then
                logEvent(eventName, args, "OUTGOING")
            end
        end
        
        return originalFireServer(self, ...)
    end)
    
    print("✅ Outgoing monitor active")
    return true
end

-- Monitor incoming events (from server)
local function setupIncomingMonitor()
    print("🔍 Setting up incoming event monitor...")
    
    -- Monitor reelfinished specifically
    if ReplicatedStorage:FindFirstChild("events") and ReplicatedStorage.events:FindFirstChild("reelfinished") then
        ReplicatedStorage.events.reelfinished.OnClientEvent:Connect(function(...)
            logEvent("reelfinished", {...}, "INCOMING")
        end)
        print("✅ reelfinished incoming monitor active")
    end
    
    -- Monitor other fishing events
    local eventsFolder = ReplicatedStorage:FindFirstChild("events")
    if eventsFolder then
        for _, event in pairs(eventsFolder:GetChildren()) do
            if event:IsA("RemoteEvent") and (
                string.find(event.Name:lower(), "reel") or
                string.find(event.Name:lower(), "cast") or
                string.find(event.Name:lower(), "fish") or
                string.find(event.Name:lower(), "catch")
            ) then
                event.OnClientEvent:Connect(function(...)
                    logEvent(event.Name, {...}, "INCOMING")
                end)
                print("✅ " .. event.Name .. " incoming monitor active")
            end
        end
    end
end

-- Start monitoring
local function startMonitoring()
    if monitoringActive then return end
    
    print("🟢 STARTING MONITORING...")
    monitoringActive = true
    capturedEvents = {}
    
    local outgoingSuccess = setupOutgoingMonitor()
    setupIncomingMonitor()
    
    print("🎯 Monitoring active! Play fishing minigame normally.")
    print("   All fishing-related events will be logged with arguments.")
end

-- Stop monitoring
local function stopMonitoring()
    if not monitoringActive then return end
    
    print("🔴 STOPPING MONITORING...")
    monitoringActive = false
    
    print("📊 CAPTURED EVENTS SUMMARY:")
    print("Total events captured: " .. #capturedEvents)
    
    -- Group events by name
    local eventCounts = {}
    for _, event in ipairs(capturedEvents) do
        eventCounts[event.name] = (eventCounts[event.name] or 0) + 1
    end
    
    for eventName, count in pairs(eventCounts) do
        print("   " .. eventName .. ": " .. count .. " times")
    end
end

-- Show detailed analysis of captured events
local function analyzeEvents()
    if #capturedEvents == 0 then
        print("❌ No events captured yet!")
        return
    end
    
    print("📋 DETAILED EVENT ANALYSIS:")
    print("============================")
    
    for i, event in ipairs(capturedEvents) do
        print("[" .. i .. "] " .. event.timeString .. " - " .. event.source .. " -> " .. event.name)
        if event.args and #event.args > 0 then
            for j, arg in ipairs(event.args) do
                print("      Arg " .. j .. ": " .. tostring(arg) .. " (" .. type(arg) .. ")")
            end
        end
        print("")
    end
end

-- Show only reelfinished events
local function analyzeReelFinished()
    local reelEvents = {}
    for _, event in ipairs(capturedEvents) do
        if event.name == "reelfinished" then
            table.insert(reelEvents, event)
        end
    end
    
    if #reelEvents == 0 then
        print("❌ No reelfinished events captured!")
        return
    end
    
    print("🎣 REELFINISHED ANALYSIS:")
    print("=========================")
    
    for i, event in ipairs(reelEvents) do
        print("[" .. i .. "] " .. event.timeString .. " - " .. event.source)
        if event.args and #event.args > 0 then
            print("   Rate: " .. tostring(event.args[1]))
            print("   Caught: " .. tostring(event.args[2]))
            if event.args[3] then
                print("   Extra Arg 3: " .. tostring(event.args[3]))
            end
            if event.args[4] then
                print("   Extra Arg 4: " .. tostring(event.args[4]))
            end
        end
        print("")
    end
end

-- Key bindings
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        startMonitoring()
    elseif input.KeyCode == Enum.KeyCode.F2 then
        stopMonitoring()
    elseif input.KeyCode == Enum.KeyCode.F3 then
        analyzeEvents()
    elseif input.KeyCode == Enum.KeyCode.F4 then
        analyzeReelFinished()
    elseif input.KeyCode == Enum.KeyCode.F5 then
        -- Clear captured events
        capturedEvents = {}
        print("🗑️ Captured events cleared!")
    end
end)

-- Auto-start monitoring when reel GUI appears
lp.PlayerGui.ChildAdded:Connect(function(gui)
    if gui.Name == "reel" and not monitoringActive then
        print("🎣 REEL GUI DETECTED! Auto-starting monitoring...")
        startMonitoring()
    end
end)

-- Show instructions
print("🎮 FISHING EVENT MONITOR CONTROLS:")
print("F1 = Start monitoring")
print("F2 = Stop monitoring") 
print("F3 = Show all captured events")
print("F4 = Show only reelfinished events")
print("F5 = Clear captured events")
print("")
print("🎯 WORKFLOW:")
print("1. Press F1 or cast rod to start monitoring")
print("2. Play fishing minigame NORMALLY")
print("3. Let the fish bite and complete minigame naturally")
print("4. Press F4 to see exact reelfinished arguments used")
print("5. Use those exact arguments in Always Catch!")
print("")
print("📡 Ready to monitor! Cast your rod and play normally...")