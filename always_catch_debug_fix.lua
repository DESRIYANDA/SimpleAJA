--// Always Catch Debug & Fix Tool
--// Script untuk debug dan fix masalah mode natural yang gagal

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')
local lp = Players.LocalPlayer

print("🔧 ALWAYS CATCH DEBUG & FIX TOOL LOADED")
print("G = Debug current reel state")
print("H = Test improved natural mode")
print("J = Test fixed realistic mode") 
print("K = Monitor all reelfinished events")
print("=====================================")

-- Enhanced debug function
local function debugReelState()
    local reelGui = lp.PlayerGui:FindFirstChild("reel")
    if reelGui then
        print("🔍 REEL DEBUG INFO:")
        print("   GUI Name: " .. reelGui.Name)
        print("   GUI Enabled: " .. tostring(reelGui.Enabled))
        print("   GUI Visible: " .. tostring(reelGui.Visible))
        print("   GUI Parent: " .. tostring(reelGui.Parent))
        
        -- Check for children
        for _, child in pairs(reelGui:GetChildren()) do
            print("   Child: " .. child.Name .. " (" .. child.ClassName .. ")")
            if child:IsA("Frame") or child:IsA("ScreenGui") then
                print("     Visible: " .. tostring(child.Visible))
                if child:FindFirstChild("bar") then
                    print("     Has bar: YES")
                end
            end
        end
        
        -- Check rod state
        local tool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("values") then
            print("   Rod: " .. tool.Name)
            if tool.values:FindFirstChild("lure") then
                print("   Lure Value: " .. tool.values.lure.Value)
            end
        end
    else
        print("❌ No reel GUI found!")
    end
end

-- Improved natural test with better parameters
local function testImprovedNatural()
    if not (lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled) then
        warn("⚠️ Must be in reel minigame!")
        return
    end
    
    print("🌿 IMPROVED NATURAL TEST")
    
    -- Use better parameters that work
    local rate = math.random(85, 95) -- Higher success rate
    local delay = math.random(100, 200) / 100 -- Shorter delay (1-2 seconds)
    
    print("   Rate: " .. rate .. "%")
    print("   Delay: " .. delay .. " seconds")
    
    task.spawn(function()
        task.wait(delay)
        
        -- Try multiple methods to ensure success
        local success1 = pcall(function()
            ReplicatedStorage.events.reelfinished:FireServer(rate, true)
        end)
        
        if success1 then
            print("   ✅ FireServer success")
        else
            print("   ❌ FireServer failed")
        end
        
        -- Try to hide GUI
        task.wait(0.1)
        local success2 = pcall(function()
            if lp.PlayerGui:FindFirstChild("reel") then
                lp.PlayerGui.reel.Enabled = false
                lp.PlayerGui.reel.Visible = false
            end
        end)
        
        if success2 then
            print("   ✅ GUI hidden successfully")
        else
            print("   ❌ GUI hide failed")
        end
    end)
end

-- Fixed realistic test with proven parameters
local function testFixedRealistic()
    if not (lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled) then
        warn("⚠️ Must be in reel minigame!")
        return
    end
    
    print("👤 FIXED REALISTIC TEST")
    
    -- Use parameters similar to successful Perfect mode
    local rate = 90 -- Fixed high rate like Perfect mode
    local delay = 0.5 -- Very short delay
    
    print("   Rate: " .. rate .. "% (fixed high)")
    print("   Delay: " .. delay .. " seconds (short)")
    
    task.spawn(function()
        task.wait(delay)
        
        -- Use exact same method as Perfect mode
        ReplicatedStorage.events.reelfinished:FireServer(rate, true)
        print("   🚀 Using same method as Perfect mode")
        
        -- Force hide GUI like Perfect mode
        pcall(function() 
            lp.PlayerGui.reel.Enabled = false 
            print("   ✅ GUI disabled")
        end)
    end)
end

-- Event monitor to see what's happening
local monitorActive = false
local function toggleEventMonitor()
    monitorActive = not monitorActive
    
    if monitorActive then
        print("📡 EVENT MONITOR STARTED")
        
        -- Hook reelfinished events
        local connection
        connection = ReplicatedStorage.events.reelfinished.OnClientEvent:Connect(function(...)
            local args = {...}
            print("📨 REELFINISHED RECEIVED:", unpack(args))
        end)
        
        -- Monitor for 10 seconds
        task.spawn(function()
            task.wait(10)
            connection:Disconnect()
            monitorActive = false
            print("📡 EVENT MONITOR STOPPED")
        end)
    else
        print("📡 EVENT MONITOR STOPPED")
    end
end

-- Key bindings
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.G then
        debugReelState()
    elseif input.KeyCode == Enum.KeyCode.H then
        testImprovedNatural()
    elseif input.KeyCode == Enum.KeyCode.J then
        testFixedRealistic()
    elseif input.KeyCode == Enum.KeyCode.K then
        toggleEventMonitor()
    end
end)

-- Auto-debug when reel appears
lp.PlayerGui.ChildAdded:Connect(function(gui)
    if gui.Name == "reel" then
        print("🎣 REEL DETECTED!")
        task.wait(0.5) -- Wait for GUI to fully load
        debugReelState()
        print("   Ready for testing! Press H/J for improved tests")
    end
end)

-- Monitor reel removal
lp.PlayerGui.ChildRemoved:Connect(function(gui)
    if gui.Name == "reel" then
        print("🏁 REEL REMOVED - Check if fish was caught!")
    end
end)

print("🔧 Debug tool ready! Cast rod and use G/H/J/K keys for testing")
print("   G = Debug current state")
print("   H = Test improved natural (higher success rate)")
print("   J = Test fixed realistic (same method as Perfect)")
print("   K = Monitor reelfinished events")