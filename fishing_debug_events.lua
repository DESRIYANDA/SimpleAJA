-- Debug with Safe Event Monitoring
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

print("EVENT MONITORING DEBUG STARTED")

local function debugPrint(message)
    print("[EVENT DEBUG] " .. tostring(message))
end

-- Monitor reelfinished event safely (no FireServer override)
local function monitorReelfinishedEvent()
    local reelfinishedEvent = ReplicatedStorage:FindFirstChild("events")
    if reelfinishedEvent then
        reelfinishedEvent = reelfinishedEvent:FindFirstChild("reelfinished")
        if reelfinishedEvent then
            debugPrint("Found reelfinished event in ReplicatedStorage")
            debugPrint("Event type: " .. reelfinishedEvent.ClassName)
            
            -- Safe monitoring approach - just verify event exists
            debugPrint("Event is accessible for firing")
        else
            debugPrint("reelfinished event not found")
        end
    else
        debugPrint("events folder not found in ReplicatedStorage")
    end
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

-- Monitor GUI with event tracking
lp.PlayerGui.ChildAdded:Connect(function(gui)
    if gui.Name == "reel" then
        debugPrint("REEL GUI APPEARED!")
        
        local rod = FindRod()
        if rod and rod:FindFirstChild('values') and rod.values:FindFirstChild('lure') then
            debugPrint("Rod lure value: " .. rod.values.lure.Value)
        end
        
        debugPrint("Waiting to see if Always Catch v2 fires reelfinished event...")
    end
end)

lp.PlayerGui.ChildRemoved:Connect(function(gui)
    if gui.Name == "reel" then
        debugPrint("REEL GUI REMOVED!")
    end
end)

-- Initialize event monitoring
monitorReelfinishedEvent()
debugPrint("Event monitoring ready! Enable Always Catch v2 and fish to see events")