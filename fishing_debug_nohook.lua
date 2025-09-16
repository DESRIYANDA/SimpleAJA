-- Enhanced No Hook Debug - Track Always Catch v2 behavior
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

print("ENHANCED NO HOOK DEBUG STARTED - Tracking Always Catch v2")

local function debugPrint(message)
    print("[ENHANCED DEBUG] " .. tostring(message))
end

-- Monitor rod status for lure value
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

-- Monitor GUI events with rod status
lp.PlayerGui.ChildAdded:Connect(function(gui)
    if gui.Name == "reel" then
        debugPrint("REEL GUI APPEARED!")
        
        -- Check rod status when GUI appears
        local rod = FindRod()
        if rod and rod:FindFirstChild('values') and rod.values:FindFirstChild('lure') then
            debugPrint("Rod lure value when GUI appears: " .. rod.values.lure.Value)
        else
            debugPrint("Rod or lure value not found!")
        end
        
        -- Wait for GUI to load then check elements
        task.spawn(function()
            task.wait(0.2)
            if gui and gui.Parent then
                debugPrint("GUI still exists after 0.2s")
                debugPrint("GUI Enabled: " .. tostring(gui.Enabled))
                debugPrint("GUI Visible: " .. tostring(gui.Visible))
                
                -- Check for common reel elements
                for _, child in pairs(gui:GetChildren()) do
                    if child.Name:lower():find("safe") or child.Name:lower():find("zone") or child.Name:lower():find("bar") then
                        debugPrint("Found element: " .. child.Name .. " (Visible: " .. tostring(child.Visible) .. ")")
                    end
                end
                
                -- Monitor for 5 seconds to see if Always Catch v2 triggers
                for i = 1, 5 do
                    task.wait(1)
                    if gui and gui.Parent then
                        debugPrint("GUI still active after " .. i .. " seconds")
                        
                        -- Check if rod lure value changed
                        local currentRod = FindRod()
                        if currentRod and currentRod:FindFirstChild('values') and currentRod.values:FindFirstChild('lure') then
                            debugPrint("Current lure value: " .. currentRod.values.lure.Value)
                        end
                    else
                        debugPrint("GUI disappeared after " .. i .. " seconds")
                        break
                    end
                end
            end
        end)
    end
end)

lp.PlayerGui.ChildRemoved:Connect(function(gui)
    if gui.Name == "reel" then
        debugPrint("REEL GUI REMOVED!")
        
        -- Check final rod status
        local rod = FindRod()
        if rod and rod:FindFirstChild('values') and rod.values:FindFirstChild('lure') then
            debugPrint("Final lure value after GUI removed: " .. rod.values.lure.Value)
        end
    end
end)

debugPrint("Enhanced debug ready - will track GUI and rod status!")
debugPrint("Enable Always Catch v2 and start fishing to see detailed logs")