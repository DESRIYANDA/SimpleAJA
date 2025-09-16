-- Ultra Safe Debug - No RemoteEvent modification
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

print("ULTRA SAFE DEBUG STARTED")

local function debugPrint(message)
    print("[ULTRA SAFE] " .. tostring(message))
end

-- Rod finder
local function FindRod()
    local character = lp.Character
    if character then
        for _, child in pairs(character:GetChildren()) do
            if child:IsA("Tool") and child.Name:lower():find("rod") then
                return child
            end
        end
    end
    
    for _, child in pairs(lp.Backpack:GetChildren()) do
        if child:IsA("Tool") and child.Name:lower():find("rod") then
            return child
        end
    end
    return nil
end

-- Check if Always Catch v2 logic would trigger
local function checkAlwaysCatchV2Logic()
    -- Simulate the exact logic from simple_fisch.lua
    local reelGui = lp.PlayerGui:FindFirstChild('reel')
    local rod = FindRod()
    
    debugPrint("=== ALWAYS CATCH V2 LOGIC CHECK ===")
    debugPrint("Reel GUI exists: " .. tostring(reelGui ~= nil))
    
    if reelGui then
        debugPrint("GUI Parent: " .. tostring(reelGui.Parent ~= nil))
        debugPrint("GUI Enabled: " .. tostring(reelGui.Enabled))
        -- Remove .Visible check since ScreenGui doesn't have Visible property
        debugPrint("-> Always Catch v2 SHOULD trigger (GUI detected)")
    elseif rod and rod:FindFirstChild('values') and rod.values:FindFirstChild('lure') and rod.values.lure.Value == 100 then
        debugPrint("Rod exists with lure value 100")
        debugPrint("-> Always Catch v2 SHOULD trigger (Rod backup method)")
    else
        debugPrint("-> Always Catch v2 will NOT trigger (no GUI and no rod condition)")
        if rod then
            debugPrint("Rod exists but checking lure...")
            if rod:FindFirstChild('values') then
                debugPrint("Rod has values")
                if rod.values:FindFirstChild('lure') then
                    debugPrint("Rod has lure, value: " .. rod.values.lure.Value)
                else
                    debugPrint("Rod has no lure child")
                end
            else
                debugPrint("Rod has no values child")
            end
        else
            debugPrint("No rod found at all")
        end
    end
    debugPrint("=====================================")
end

-- Enhanced GUI monitoring
lp.PlayerGui.ChildAdded:Connect(function(gui)
    if gui.Name == "reel" then
        debugPrint("REEL GUI APPEARED!")
        
        task.spawn(function()
            task.wait(0.1) -- Small delay for GUI to fully load
            checkAlwaysCatchV2Logic()
            
            -- Monitor for 6 seconds to see what happens
            for i = 1, 6 do
                task.wait(1)
                if gui and gui.Parent then
                    debugPrint("Second " .. i .. ": GUI still active")
                    
                    local rod = FindRod()
                    if rod and rod:FindFirstChild('values') and rod.values:FindFirstChild('lure') then
                        debugPrint("  - Lure value: " .. rod.values.lure.Value)
                    end
                    
                    if i == 3 then
                        debugPrint("  - 3 seconds passed, Always Catch v2 should have triggered by now")
                    end
                else
                    debugPrint("Second " .. i .. ": GUI disappeared")
                    break
                end
            end
        end)
    end
end)

lp.PlayerGui.ChildRemoved:Connect(function(gui)
    if gui.Name == "reel" then
        debugPrint("REEL GUI REMOVED!")
        checkAlwaysCatchV2Logic()
    end
end)

debugPrint("Ultra safe debug ready!")
debugPrint("This will check if Always Catch v2 logic conditions are met")
debugPrint("Enable Always Catch v2 in simple_fisch.lua then start fishing")