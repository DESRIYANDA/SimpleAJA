--// Always Catch Argument Testing Tool
--// Script untuk test berbagai variasi argumen reelfinished

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local lp = Players.LocalPlayer

print("🔬 ALWAYS CATCH ARGUMENT TESTING TOOL")
print("Testing different argument combinations for reelfinished")
print("=================================================")

-- Function to safely test reelfinished with different arguments
local function testReelFinished(rate, caught, testName, extraArgs)
    if not (lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled) then
        warn("⚠️ Must be in reel minigame for: " .. testName)
        return
    end
    
    print("🧪 TESTING: " .. testName)
    print("   Rate: " .. tostring(rate))
    print("   Caught: " .. tostring(caught))
    
    if extraArgs then
        print("   Extra Args: " .. table.concat(extraArgs, ", "))
    end
    
    local success, error = pcall(function()
        if extraArgs then
            ReplicatedStorage.events.reelfinished:FireServer(rate, caught, unpack(extraArgs))
        else
            ReplicatedStorage.events.reelfinished:FireServer(rate, caught)
        end
    end)
    
    if success then
        print("   ✅ FireServer successful")
    else
        print("   ❌ FireServer failed: " .. tostring(error))
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

-- Key bindings for different tests
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if not (lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled) then
        if input.KeyCode.Value >= Enum.KeyCode.One.Value and input.KeyCode.Value <= Enum.KeyCode.Nine.Value then
            warn("⚠️ Must be in reel minigame to test!")
        end
        return
    end
    
    if input.KeyCode == Enum.KeyCode.One then
        -- Test 1: Exact same as Perfect (proven working)
        testReelFinished(100, true, "Test 1: Perfect Copy (100, true)")
        
    elseif input.KeyCode == Enum.KeyCode.Two then
        -- Test 2: Lower rate, same structure
        testReelFinished(90, true, "Test 2: High Rate (90, true)")
        
    elseif input.KeyCode == Enum.KeyCode.Three then
        -- Test 3: Even lower rate
        testReelFinished(80, true, "Test 3: Medium Rate (80, true)")
        
    elseif input.KeyCode == Enum.KeyCode.Four then
        -- Test 4: Test with numbers as strings
        testReelFinished("100", "true", "Test 4: String Args ('100', 'true')")
        
    elseif input.KeyCode == Enum.KeyCode.Five then
        -- Test 5: Test with additional nil argument
        testReelFinished(100, true, "Test 5: With Nil", {nil})
        
    elseif input.KeyCode == Enum.KeyCode.Six then
        -- Test 6: Test with false caught
        testReelFinished(100, false, "Test 6: False Caught (100, false)")
        
    elseif input.KeyCode == Enum.KeyCode.Seven then
        -- Test 7: Test with decimal rate
        testReelFinished(95.5, true, "Test 7: Decimal Rate (95.5, true)")
        
    elseif input.KeyCode == Enum.KeyCode.Eight then
        -- Test 8: Test with extra argument (some games need this)
        testReelFinished(100, true, "Test 8: Extra Arg", {1})
        
    elseif input.KeyCode == Enum.KeyCode.Nine then
        -- Test 9: Test with multiple extra arguments
        testReelFinished(100, true, "Test 9: Multiple Args", {1, true, "complete"})
        
    elseif input.KeyCode == Enum.KeyCode.Zero then
        -- Test 0: Emergency perfect
        testReelFinished(100, true, "Emergency Perfect")
    end
end)

-- Monitor reel events to see what arguments are actually used
local function setupEventMonitor()
    print("📡 Setting up event monitor...")
    
    -- Hook into reelfinished to see what arguments other players use
    local originalFireServer
    originalFireServer = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "FireServer" and self.Name == "reelfinished" then
            print("📨 INTERCEPTED reelfinished:")
            for i, arg in ipairs(args) do
                print("   Arg " .. i .. ": " .. tostring(arg) .. " (" .. type(arg) .. ")")
            end
        end
        
        return originalFireServer(self, ...)
    end)
end

-- Setup monitor if hookmetamethod is available
if hookmetamethod then
    setupEventMonitor()
    print("✅ Event monitor active")
else
    warn("⚠️ hookmetamethod not available - cannot monitor events")
end

-- Auto-print instructions when reel appears
lp.PlayerGui.ChildAdded:Connect(function(gui)
    if gui.Name == "reel" then
        print("🎣 REEL DETECTED! Ready for argument testing!")
        print("Press number keys 1-9 to test different argument combinations:")
        print("1 = Perfect Copy (proven working)")
        print("2 = High Rate (90%)")
        print("3 = Medium Rate (80%)")
        print("4 = String Arguments")
        print("5 = With Nil Argument")
        print("6 = False Caught")
        print("7 = Decimal Rate")
        print("8 = Extra Argument")
        print("9 = Multiple Arguments")
        print("0 = Emergency Perfect")
    end
end)

print("🎮 Argument Testing Tool Ready!")
print("Cast rod, wait for reel, then test with number keys 1-9")
print("This will help identify the exact argument format that works")