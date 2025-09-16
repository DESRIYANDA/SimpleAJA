--// Real Minigame Monitor
--// Script untuk monitor semua remote events dan arguments saat bermain normal

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local lp = Players.LocalPlayer

print("📡 REAL MINIGAME MONITOR LOADED")
print("Play minigame normally - all events will be captured!")
print("=================================================")

-- Storage for captured events
local capturedEvents = {}
local monitoringActive = false

-- Function to start monitoring
local function startMonitoring()
    if not hookmetamethod then
        warn("❌ hookmetamethod not available - cannot monitor events")
        return
    end
    
    monitoringActive = true
    print("🎯 MONITORING STARTED - Play minigame normally!")
    print("   All reelfinished events will be captured")
    
    -- Hook all FireServer calls
    local originalFireServer
    originalFireServer = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "FireServer" and monitoringActive then
            -- Log ALL FireServer calls during minigame
            if self.Name == "reelfinished" or string.find(self.Name:lower(), "reel") or string.find(self.Name:lower(), "fish") then
                local eventData = {
                    remote = self,
                    remoteName = self.Name,
                    remotePath = self:GetFullName(),
                    method = method,
                    args = args,
                    timestamp = tick()
                }
                
                table.insert(capturedEvents, eventData)
                
                print("📨 CAPTURED EVENT: " .. self.Name)
                print("   Path: " .. self:GetFullName())
                print("   Args: " .. #args .. " arguments")
                for i, arg in ipairs(args) do
                    print("     [" .. i .. "] " .. tostring(arg) .. " (" .. type(arg) .. ")")
                end
                print("   Time: " .. os.date("%H:%M:%S", eventData.timestamp))
                print("")
            end
        end
        
        return originalFireServer(self, ...)
    end)
    
    print("✅ Hook active - play minigame normally!")
end

-- Function to stop monitoring
local function stopMonitoring()
    monitoringActive = false
    print("🛑 MONITORING STOPPED")
    print("📊 Total events captured: " .. #capturedEvents)
end

-- Function to show captured events
local function showCapturedEvents()
    print("📋 CAPTURED EVENTS SUMMARY:")
    print("Total events: " .. #capturedEvents)
    print("=====================================")
    
    for i, event in ipairs(capturedEvents) do
        print("Event " .. i .. ":")
        print("  Remote: " .. event.remoteName)
        print("  Path: " .. event.remotePath)
        print("  Args: " .. #event.args)
        for j, arg in ipairs(event.args) do
            print("    [" .. j .. "] " .. tostring(arg) .. " (" .. type(arg) .. ")")
        end
        print("  Time: " .. os.date("%H:%M:%S", event.timestamp))
        print("")
    end
end

-- Function to replay last captured reelfinished
local function replayLastReelFinished()
    local lastReelEvent = nil
    
    -- Find last reelfinished event
    for i = #capturedEvents, 1, -1 do
        if capturedEvents[i].remoteName == "reelfinished" then
            lastReelEvent = capturedEvents[i]
            break
        end
    end
    
    if not lastReelEvent then
        warn("❌ No reelfinished event captured yet!")
        return
    end
    
    if not (lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled) then
        warn("⚠️ Must be in reel minigame to replay!")
        return
    end
    
    print("🔄 REPLAYING LAST REELFINISHED:")
    print("   Original args: " .. #lastReelEvent.args)
    for i, arg in ipairs(lastReelEvent.args) do
        print("     [" .. i .. "] " .. tostring(arg) .. " (" .. type(arg) .. ")")
    end
    
    local success, error = pcall(function()
        lastReelEvent.remote:FireServer(unpack(lastReelEvent.args))
    end)
    
    if success then
        print("   ✅ Replay successful!")
        pcall(function() lp.PlayerGui.reel.Enabled = false end)
    else
        print("   ❌ Replay failed: " .. tostring(error))
    end
end

-- Function to test with captured arguments but different rate
local function testWithCapturedArgs(newRate)
    local lastReelEvent = nil
    
    -- Find last reelfinished event
    for i = #capturedEvents, 1, -1 do
        if capturedEvents[i].remoteName == "reelfinished" then
            lastReelEvent = capturedEvents[i]
            break
        end
    end
    
    if not lastReelEvent then
        warn("❌ No reelfinished event captured yet!")
        return
    end
    
    if not (lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled) then
        warn("⚠️ Must be in reel minigame to test!")
        return
    end
    
    print("🧪 TESTING WITH CAPTURED STRUCTURE:")
    print("   Original rate: " .. tostring(lastReelEvent.args[1]))
    print("   New rate: " .. tostring(newRate))
    
    -- Create new args with modified rate but same structure
    local newArgs = {}
    for i, arg in ipairs(lastReelEvent.args) do
        if i == 1 then
            newArgs[i] = newRate -- Replace rate
        else
            newArgs[i] = arg -- Keep other args exactly the same
        end
    end
    
    print("   Testing args:")
    for i, arg in ipairs(newArgs) do
        print("     [" .. i .. "] " .. tostring(arg) .. " (" .. type(arg) .. ")")
    end
    
    local success, error = pcall(function()
        lastReelEvent.remote:FireServer(unpack(newArgs))
    end)
    
    if success then
        print("   ✅ Test successful!")
        pcall(function() lp.PlayerGui.reel.Enabled = false end)
    else
        print("   ❌ Test failed: " .. tostring(error))
    end
end

-- Key bindings
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.M then
        if monitoringActive then
            stopMonitoring()
        else
            startMonitoring()
        end
        
    elseif input.KeyCode == Enum.KeyCode.L then
        showCapturedEvents()
        
    elseif input.KeyCode == Enum.KeyCode.R then
        replayLastReelFinished()
        
    elseif input.KeyCode == Enum.KeyCode.T then
        testWithCapturedArgs(80)
        
    elseif input.KeyCode == Enum.KeyCode.Y then
        testWithCapturedArgs(90)
        
    elseif input.KeyCode == Enum.KeyCode.U then
        testWithCapturedArgs(95)
        
    elseif input.KeyCode == Enum.KeyCode.C then
        capturedEvents = {}
        print("🗑️ Captured events cleared")
    end
end)

-- Auto-start monitoring when reel appears
lp.PlayerGui.ChildAdded:Connect(function(gui)
    if gui.Name == "reel" then
        print("🎣 REEL DETECTED!")
        if not monitoringActive then
            print("   Starting auto-monitoring...")
            startMonitoring()
        end
        print("📖 CONTROLS:")
        print("   M = Toggle monitoring on/off")
        print("   L = List captured events")
        print("   R = Replay last reelfinished")
        print("   T = Test with 80% using captured structure")
        print("   Y = Test with 90% using captured structure")
        print("   U = Test with 95% using captured structure")
        print("   C = Clear captured events")
    end
end)

lp.PlayerGui.ChildRemoved:Connect(function(gui)
    if gui.Name == "reel" then
        print("🏁 REEL ENDED")
        if monitoringActive then
            print("   Monitoring still active for next reel")
        end
    end
end)

print("🎮 Real Minigame Monitor Ready!")
print("Cast rod and play minigame normally - all events will be captured")
print("Press M to start/stop monitoring manually")