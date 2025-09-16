--// Always Catch Comparison Tester
--// Script untuk compare Always Catch v1 vs v2 dengan berbagai argumen

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local lp = Players.LocalPlayer

print("=== ALWAYS CATCH COMPARISON TESTER ===")
print("SPACE = Always Catch v1 (Hook Method)")
print("ENTER = Always Catch v2 (Direct FireServer)")
print("Q = Test v1 dengan 100% + true")
print("W = Test v1 dengan random% + true") 
print("E = Test v2 dengan natural timing")
print("R = Test v2 dengan instant")
print("T = Test v2 dengan long delay")
print("=====================================")

-- Always Catch v1 simulation (Hook-like behavior)
local function alwaysCatchV1(rate, caught)
    rate = rate or 100
    caught = caught or true
    print("🎯 ALWAYS CATCH V1 SIMULATION")
    print("   Method: Hook-like FireServer override")
    print("   Rate: " .. rate .. "%")
    print("   Caught: " .. tostring(caught))
    
    -- Simulate hook behavior - immediate override
    ReplicatedStorage.events.reelfinished:FireServer(rate, caught)
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
    print("✅ v1 Completed (Hook Method)")
end

-- Always Catch v2 simulation (Event-based with timing)
local function alwaysCatchV2(options)
    options = options or {}
    local rate = options.rate or math.random(60, 90)
    local caught = options.caught or true
    local delay = options.delay or math.random(200, 400) / 100
    
    print("🌟 ALWAYS CATCH V2 SIMULATION")
    print("   Method: Event-based with natural timing")
    print("   Rate: " .. rate .. "%")
    print("   Caught: " .. tostring(caught))
    print("   Delay: " .. delay .. " seconds")
    
    task.spawn(function()
        if delay > 0 then
            print("   ⏱️ Waiting for natural timing...")
            task.wait(delay)
        end
        
        print("   🚀 Firing reelfinished...")
        ReplicatedStorage.events.reelfinished:FireServer(rate, caught)
        pcall(function() lp.PlayerGui.reel.Enabled = false end)
        print("✅ v2 Completed (Event Method)")
    end)
end

-- Check if in reel minigame
local function canTest()
    return lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled
end

-- Key bindings
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if not canTest() then
        if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.Return or
           input.KeyCode == Enum.KeyCode.Q or input.KeyCode == Enum.KeyCode.W or
           input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.R or
           input.KeyCode == Enum.KeyCode.T then
            warn("⚠️ Harus dalam reel minigame untuk testing!")
        end
        return
    end
    
    if input.KeyCode == Enum.KeyCode.Space then
        -- Basic Always Catch v1
        alwaysCatchV1(100, true)
        
    elseif input.KeyCode == Enum.KeyCode.Return then
        -- Basic Always Catch v2
        alwaysCatchV2()
        
    elseif input.KeyCode == Enum.KeyCode.Q then
        -- Test v1 perfect
        alwaysCatchV1(100, true)
        
    elseif input.KeyCode == Enum.KeyCode.W then
        -- Test v1 random
        alwaysCatchV1(math.random(70, 95), true)
        
    elseif input.KeyCode == Enum.KeyCode.E then
        -- Test v2 natural
        alwaysCatchV2({
            rate = math.random(65, 88),
            caught = true,
            delay = math.random(200, 400) / 100
        })
        
    elseif input.KeyCode == Enum.KeyCode.R then
        -- Test v2 instant
        alwaysCatchV2({
            rate = math.random(80, 95),
            caught = true,
            delay = 0
        })
        
    elseif input.KeyCode == Enum.KeyCode.T then
        -- Test v2 long delay
        alwaysCatchV2({
            rate = math.random(60, 85),
            caught = true,
            delay = math.random(300, 600) / 100
        })
    end
end)

-- Monitor reel status
lp.PlayerGui.ChildAdded:Connect(function(gui)
    if gui.Name == "reel" then
        print("🎣 REEL DETECTED! Ready for comparison testing!")
        print("   SPACE/ENTER untuk basic test, Q/W/E/R/T untuk advanced test")
    end
end)

lp.PlayerGui.ChildRemoved:Connect(function(gui)
    if gui.Name == "reel" then
        print("🏁 REEL ENDED")
    end
end)

print("🆚 Comparison Tester loaded! Cast dan test perbedaan v1 vs v2!")