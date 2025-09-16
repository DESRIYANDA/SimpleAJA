--// Captured Arguments Tester
--// Test arguments yang sudah di-capture dari normal gameplay

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local lp = Players.LocalPlayer

print("🧪 CAPTURED ARGUMENTS TESTER")
print("Test exact arguments from your normal gameplay")
print("==========================================")

-- Store your captured arguments here (will be filled from monitor)
local capturedArguments = {
    -- Example: {rate, caught, ...otherArgs}
    -- Will be populated when you use the monitor
}

-- Function to test specific arguments
local function testArguments(args, testName)
    if not (lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled) then
        warn("⚠️ Must be in reel minigame for: " .. testName)
        return
    end
    
    print("🧪 TESTING: " .. testName)
    print("   Arguments: " .. table.concat(args, ", "))
    
    local success, error = pcall(function()
        ReplicatedStorage.events.reelfinished:FireServer(unpack(args))
    end)
    
    if success then
        print("   ✅ Test successful!")
    else
        print("   ❌ Test failed: " .. tostring(error))
    end
    
    -- Try to hide GUI
    task.wait(0.1)
    pcall(function() 
        if lp.PlayerGui:FindFirstChild("reel") then
            lp.PlayerGui.reel.Enabled = false 
        end
    end)
    
    print("   🏁 Test completed")
    print("")
end

-- Function to add captured arguments manually
local function addCapturedArgs(...)
    local args = {...}
    table.insert(capturedArguments, args)
    print("✅ Added arguments: " .. table.concat(args, ", "))
    print("   Total captured: " .. #capturedArguments)
end

-- Pre-defined test cases based on common patterns
local testCases = {
    {100, true}, -- Standard perfect
    {90, true}, -- High success
    {80, true}, -- Medium success
    {100, true, nil}, -- With nil
    {100, true, 1}, -- With extra number
    {100, true, true}, -- With extra boolean
}

-- Key bindings for testing
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if not (lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled) then
        if input.KeyCode.Value >= Enum.KeyCode.One.Value and input.KeyCode.Value <= Enum.KeyCode.Six.Value then
            warn("⚠️ Must be in reel minigame to test!")
        end
        return
    end
    
    if input.KeyCode == Enum.KeyCode.One then
        testArguments(testCases[1], "Standard Perfect (100, true)")
    elseif input.KeyCode == Enum.KeyCode.Two then
        testArguments(testCases[2], "High Success (90, true)")
    elseif input.KeyCode == Enum.KeyCode.Three then
        testArguments(testCases[3], "Medium Success (80, true)")
    elseif input.KeyCode == Enum.KeyCode.Four then
        testArguments(testCases[4], "With Nil (100, true, nil)")
    elseif input.KeyCode == Enum.KeyCode.Five then
        testArguments(testCases[5], "With Number (100, true, 1)")
    elseif input.KeyCode == Enum.KeyCode.Six then
        testArguments(testCases[6], "With Boolean (100, true, true)")
    elseif input.KeyCode == Enum.KeyCode.Seven then
        -- Test first captured argument if available
        if #capturedArguments > 0 then
            testArguments(capturedArguments[1], "Captured Args #1")
        else
            warn("❌ No captured arguments available!")
        end
    elseif input.KeyCode == Enum.KeyCode.Eight then
        -- Test last captured argument if available
        if #capturedArguments > 0 then
            testArguments(capturedArguments[#capturedArguments], "Captured Args #" .. #capturedArguments)
        else
            warn("❌ No captured arguments available!")
        end
    end
end)

-- Auto-instructions when reel appears
lp.PlayerGui.ChildAdded:Connect(function(gui)
    if gui.Name == "reel" then
        print("🎣 REEL DETECTED! Ready for testing!")
        print("Press number keys to test different argument combinations:")
        print("1 = Standard Perfect (100, true)")
        print("2 = High Success (90, true)")
        print("3 = Medium Success (80, true)")
        print("4 = With Nil (100, true, nil)")
        print("5 = With Number (100, true, 1)")
        print("6 = With Boolean (100, true, true)")
        print("7 = Test first captured args")
        print("8 = Test last captured args")
        print("")
        print("Captured arguments available: " .. #capturedArguments)
    end
end)

-- Function to import arguments from monitor
function importFromMonitor(args)
    addCapturedArgs(unpack(args))
end

print("🎮 CAPTURED ARGUMENTS TESTER READY!")
print("")
print("📋 WORKFLOW:")
print("1. First use simple_reel_monitor.lua to capture real arguments")
print("2. Copy the captured arguments")
print("3. Use this script to test those exact arguments")
print("4. Find which combination works reliably")
print("")
print("🧪 Available test cases: " .. #testCases)
print("📊 Captured arguments: " .. #capturedArguments)
print("")
print("Ready for testing! Cast rod and use number keys 1-8 in reel minigame")