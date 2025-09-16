--// Perfect Mode Analyzer & Replicator
--// Script untuk menganalisis mengapa Perfect berhasil dan mereplikasi methodnya

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local lp = Players.LocalPlayer

print("🔍 PERFECT MODE ANALYZER & REPLICATOR")
print("Analyzing why Perfect works and replicating its method")
print("===================================================")

-- Store the exact method Perfect uses
local perfectMethod = nil
local perfectArgs = nil

-- Function to capture Perfect's exact method
local function capturePerfectMethod()
    if hookmetamethod then
        print("📡 Capturing Perfect's method...")
        
        local originalFireServer
        originalFireServer = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if method == "FireServer" and self.Name == "reelfinished" then
                -- Store Perfect's method for replication
                perfectMethod = {
                    self = self,
                    method = method,
                    args = args
                }
                
                print("✅ CAPTURED PERFECT METHOD:")
                print("   Remote: " .. tostring(self))
                print("   Method: " .. method)
                for i, arg in ipairs(args) do
                    print("   Arg " .. i .. ": " .. tostring(arg) .. " (" .. type(arg) .. ")")
                end
                perfectArgs = args
            end
            
            return originalFireServer(self, ...)
        end)
        
        print("🎯 Hook active - use Perfect button to capture its method")
    else
        warn("⚠️ hookmetamethod not available")
    end
end

-- Function to replicate Perfect's exact method with modified rate
local function replicatePerfectMethod(newRate, testName)
    if not perfectMethod or not perfectArgs then
        warn("❌ Perfect method not captured yet! Use Perfect button first.")
        return
    end
    
    if not (lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled) then
        warn("⚠️ Must be in reel minigame!")
        return
    end
    
    print("🔄 REPLICATING PERFECT METHOD: " .. testName)
    print("   Original Rate: " .. tostring(perfectArgs[1]))
    print("   New Rate: " .. tostring(newRate))
    print("   Other Args: " .. tostring(perfectArgs[2]))
    
    -- Create new args with modified rate but same structure
    local newArgs = {}
    for i, arg in ipairs(perfectArgs) do
        if i == 1 then
            newArgs[i] = newRate -- Replace rate
        else
            newArgs[i] = arg -- Keep other args exactly the same
        end
    end
    
    -- Use exact same remote and method as Perfect
    local success, error = pcall(function()
        perfectMethod.self:FireServer(unpack(newArgs))
    end)
    
    if success then
        print("   ✅ Replication successful")
    else
        print("   ❌ Replication failed: " .. tostring(error))
    end
    
    -- Same GUI hiding as Perfect
    task.wait(0.1)
    pcall(function() 
        if lp.PlayerGui:FindFirstChild("reel") then
            lp.PlayerGui.reel.Enabled = false 
        end
    end)
    
    print("   🏁 Replication completed")
end

-- Key bindings
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.P then
        -- Prepare to capture Perfect's method
        capturePerfectMethod()
        print("🎯 Ready to capture! Now use Perfect button in UI test.")
        
    elseif input.KeyCode == Enum.KeyCode.Q then
        -- Replicate with 90%
        replicatePerfectMethod(90, "90% using Perfect's method")
        
    elseif input.KeyCode == Enum.KeyCode.W then
        -- Replicate with 80%
        replicatePerfectMethod(80, "80% using Perfect's method")
        
    elseif input.KeyCode == Enum.KeyCode.E then
        -- Replicate with 85%
        replicatePerfectMethod(85, "85% using Perfect's method")
        
    elseif input.KeyCode == Enum.KeyCode.R then
        -- Replicate with random 70-90%
        local randomRate = math.random(70, 90)
        replicatePerfectMethod(randomRate, randomRate .. "% using Perfect's method")
        
    elseif input.KeyCode == Enum.KeyCode.T then
        -- Show captured method info
        if perfectMethod and perfectArgs then
            print("📋 CAPTURED METHOD INFO:")
            print("   Remote: " .. tostring(perfectMethod.self))
            print("   Full Path: " .. perfectMethod.self:GetFullName())
            for i, arg in ipairs(perfectArgs) do
                print("   Arg " .. i .. ": " .. tostring(arg) .. " (" .. type(arg) .. ")")
            end
        else
            print("❌ No method captured yet")
        end
    end
end)

-- Auto setup when reel appears
lp.PlayerGui.ChildAdded:Connect(function(gui)
    if gui.Name == "reel" then
        print("🎣 REEL DETECTED!")
        print("Instructions:")
        print("P = Prepare to capture Perfect's method")
        print("Q = Test 90% using Perfect's method")
        print("W = Test 80% using Perfect's method") 
        print("E = Test 85% using Perfect's method")
        print("R = Test random% using Perfect's method")
        print("T = Show captured method info")
        print("")
        print("WORKFLOW:")
        print("1. Press P to prepare capture")
        print("2. Use Perfect button in UI test")
        print("3. Press Q/W/E/R to test other rates with Perfect's exact method")
    end
end)

print("🎮 Perfect Analyzer Ready!")
print("This will capture Perfect's exact method and replicate it with different rates")
print("Press P when in reel minigame to start capturing")