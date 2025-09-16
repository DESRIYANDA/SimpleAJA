--// Real Arguments Test Based on Captured Data
--// Testing dengan exact arguments yang ter-capture: (100, false)

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local lp = Players.LocalPlayer

print("🎯 REAL ARGUMENTS TEST")
print("Based on captured data: (100, false)")
print("=====================================")

-- Function to test dengan exact captured args
local function testExactCaptured()
    if not (lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled) then
        warn("⚠️ Must be in reel minigame!")
        return
    end
    
    print("✅ TESTING EXACT CAPTURED: (100, false)")
    ReplicatedStorage.events.reelfinished:FireServer(100, false)
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
    print("Test completed with captured args")
end

-- Function to test variations dengan captured structure
local function testWithCapturedStructure(rate, caught)
    if not (lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled) then
        warn("⚠️ Must be in reel minigame!")
        return
    end
    
    print("🧪 TESTING: (" .. rate .. ", " .. tostring(caught) .. ")")
    ReplicatedStorage.events.reelfinished:FireServer(rate, caught)
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
    print("Test completed")
end

-- Key bindings for different tests
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Space then
        -- Exact captured
        testExactCaptured()
        
    elseif input.KeyCode == Enum.KeyCode.Q then
        -- 80% with false (like captured)
        testWithCapturedStructure(80, false)
        
    elseif input.KeyCode == Enum.KeyCode.W then
        -- 90% with false (like captured)
        testWithCapturedStructure(90, false)
        
    elseif input.KeyCode == Enum.KeyCode.E then
        -- 95% with false (like captured)
        testWithCapturedStructure(95, false)
        
    elseif input.KeyCode == Enum.KeyCode.R then
        -- 100% with true (our assumption)
        testWithCapturedStructure(100, true)
        
    elseif input.KeyCode == Enum.KeyCode.T then
        -- 90% with true (our assumption)
        testWithCapturedStructure(90, true)
        
    elseif input.KeyCode == Enum.KeyCode.Y then
        -- 80% with true (our assumption)
        testWithCapturedStructure(80, true)
        
    elseif input.KeyCode == Enum.KeyCode.F then
        -- Test series: false vs true comparison
        print("🔬 COMPARISON TEST SERIES:")
        print("This will help identify if the issue is the boolean value")
        
    elseif input.KeyCode == Enum.KeyCode.One then
        -- Quick test: random rate with false
        local rate = math.random(70, 95)
        testWithCapturedStructure(rate, false)
        
    elseif input.KeyCode == Enum.KeyCode.Two then
        -- Quick test: random rate with true
        local rate = math.random(70, 95)
        testWithCapturedStructure(rate, true)
    end
end)

-- Auto-show instructions when reel appears
lp.PlayerGui.ChildAdded:Connect(function(gui)
    if gui.Name == "reel" then
        print("🎣 REEL DETECTED! Test based on captured data:")
        print("SPACE = Exact captured (100, false)")
        print("Q/W/E = 80%/90%/95% with FALSE (like captured)")
        print("R/T/Y = 100%/90%/80% with TRUE (our assumption)")
        print("1 = Random% with FALSE")
        print("2 = Random% with TRUE")
        print("")
        print("🔍 KEY INSIGHT:")
        print("Real game used (100, FALSE) not (100, TRUE)!")
        print("This might be why our tests failed!")
    end
end)

print("🎮 Real Arguments Test Ready!")
print("Key insight: Real game uses (rate, FALSE) not (rate, TRUE)")
print("Test different combinations to see which works!")
print("")
print("HYPOTHESIS:")
print("- Maybe FALSE = fish caught successfully") 
print("- Maybe TRUE = fish escaped/failed")
print("- This is opposite of our assumption!")