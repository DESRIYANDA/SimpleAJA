--// Captured Args Tester
--// Script untuk test berbagai variasi dengan arguments yang sudah dicapture

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local lp = Players.LocalPlayer

print("🔬 CAPTURED ARGS TESTER")
print("Test different variations of captured arguments")
print("============================================")

-- Common argument patterns found in fishing games
local commonPatterns = {
    {100, true}, -- Basic: rate, caught
    {100, true, nil}, -- With nil
    {100, true, 1}, -- With number
    {100, true, "complete"}, -- With string
    {100, true, {}}, -- With table
    {100, 1}, -- Number instead of boolean
    {"100", "true"}, -- String versions
}

-- Function to test different argument patterns
local function testPattern(pattern, patternName)
    if not (lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled) then
        warn("⚠️ Must be in reel minigame for: " .. patternName)
        return
    end
    
    print("🧪 TESTING PATTERN: " .. patternName)
    print("   Args: " .. #pattern)
    for i, arg in ipairs(pattern) do
        print("   [" .. i .. "] " .. tostring(arg) .. " (" .. type(arg) .. ")")
    end
    
    local success, error = pcall(function()
        ReplicatedStorage.events.reelfinished:FireServer(unpack(pattern))
    end)
    
    if success then
        print("   ✅ Pattern successful!")
        pcall(function() lp.PlayerGui.reel.Enabled = false end)
    else
        print("   ❌ Pattern failed: " .. tostring(error))
    end
    print("")
end

-- Key bindings for different patterns
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.One then
        testPattern({100, true}, "Basic (100, true)")
        
    elseif input.KeyCode == Enum.KeyCode.Two then
        testPattern({100, true, nil}, "With Nil (100, true, nil)")
        
    elseif input.KeyCode == Enum.KeyCode.Three then
        testPattern({100, true, 1}, "With Number (100, true, 1)")
        
    elseif input.KeyCode == Enum.KeyCode.Four then
        testPattern({100, true, "complete"}, "With String (100, true, 'complete')")
        
    elseif input.KeyCode == Enum.KeyCode.Five then
        testPattern({100, 1}, "Number Boolean (100, 1)")
        
    elseif input.KeyCode == Enum.KeyCode.Six then
        testPattern({"100", "true"}, "String Args ('100', 'true')")
        
    elseif input.KeyCode == Enum.KeyCode.Seven then
        testPattern({100, true, true}, "Double Boolean (100, true, true)")
        
    elseif input.KeyCode == Enum.KeyCode.Eight then
        testPattern({100, true, 1, true}, "Multiple Args (100, true, 1, true)")
        
    elseif input.KeyCode == Enum.KeyCode.Nine then
        testPattern({100}, "Single Arg (100)")
        
    elseif input.KeyCode == Enum.KeyCode.Zero then
        -- Test all patterns quickly
        print("🚀 TESTING ALL PATTERNS:")
        for i, pattern in ipairs(commonPatterns) do
            print("Pattern " .. i .. ": " .. table.concat(pattern, ", "))
        end
    end
end)

-- Auto-show instructions when reel appears
lp.PlayerGui.ChildAdded:Connect(function(gui)
    if gui.Name == "reel" then
        print("🎣 REEL DETECTED! Test different argument patterns:")
        print("1 = Basic (100, true)")
        print("2 = With Nil (100, true, nil)")
        print("3 = With Number (100, true, 1)")
        print("4 = With String (100, true, 'complete')")
        print("5 = Number Boolean (100, 1)")
        print("6 = String Args ('100', 'true')")
        print("7 = Double Boolean (100, true, true)")
        print("8 = Multiple Args (100, true, 1, true)")
        print("9 = Single Arg (100)")
        print("0 = Show all patterns")
    end
end)

-- Function to test with different rates using basic pattern
local function testBasicWithRate(rate)
    if not (lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled) then
        warn("⚠️ Must be in reel minigame!")
        return
    end
    
    print("🎯 TESTING BASIC PATTERN with " .. rate .. "%")
    testPattern({rate, true}, "Basic with " .. rate .. "%")
end

-- Additional key bindings for rate testing
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        testBasicWithRate(50)
    elseif input.KeyCode == Enum.KeyCode.F2 then
        testBasicWithRate(75)
    elseif input.KeyCode == Enum.KeyCode.F3 then
        testBasicWithRate(90)
    elseif input.KeyCode == Enum.KeyCode.F4 then
        testBasicWithRate(95)
    elseif input.KeyCode == Enum.KeyCode.F5 then
        testBasicWithRate(99)
    end
end)

print("🎮 Captured Args Tester Ready!")
print("Use number keys 1-9 to test different argument patterns")
print("Use F1-F5 to test basic pattern with different rates")
print("This will help identify which argument structure works best")