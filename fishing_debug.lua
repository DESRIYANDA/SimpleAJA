-- Fishing Debug Tool - untuk diagnose Always Catch v2
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer

print("FISHING DEBUG TOOL STARTED")
print("==================================================")

-- Debug Functions
local function debugPrint(message)
    print("[FISHING DEBUG] " .. tostring(message))
end

-- Monitor rod detection
local function FindRod()
    local character = lp.Character or lp.CharacterAdded:Wait()
    for _, child in pairs(character:GetChildren()) do
        if child:IsA("Tool") and child.Name:lower():find("rod") then
            return child
        end
    end
    
    for _, child in pairs(lp.Backpack:GetChildren()) do
        if child:IsA("Tool") and child.Name:lower():find("rod") then
            return child
        end
    end
    return nil
end

-- Monitor reel GUI
local function checkReelGUI()
    local reelGui = lp.PlayerGui:FindFirstChild('reel')
    if reelGui then
        debugPrint("Reel GUI detected: " .. tostring(reelGui.Name))
        debugPrint("   - Enabled: " .. tostring(reelGui.Enabled))
        debugPrint("   - Visible: " .. tostring(reelGui.Visible))
        
        -- Check safezone elements
        local safezone = reelGui:FindFirstChild('safezone')
        local bar = reelGui:FindFirstChild('bar')
        debugPrint("   - Safezone: " .. tostring(safezone and "Found" or "Not Found"))
        debugPrint("   - Bar: " .. tostring(bar and "Found" or "Not Found"))
    else
        debugPrint("Reel GUI not found")
    end
end

-- Monitor rod status
RunService.Heartbeat:Connect(function()
    local rod = FindRod()
    if rod then
        if rod:FindFirstChild('values') and rod.values:FindFirstChild('lure') then
            local lureValue = rod.values.lure.Value
            if lureValue == 100 then
                debugPrint("FISH BITE DETECTED! Lure value: " .. lureValue)
                checkReelGUI()
            end
        end
    end
end)

-- Monitor reel GUI appearance
lp.PlayerGui.ChildAdded:Connect(function(gui)
    if gui.Name == "reel" then
        debugPrint("REEL GUI APPEARED!")
        debugPrint("   - Name: " .. gui.Name)
        debugPrint("   - Enabled: " .. tostring(gui.Enabled))
        debugPrint("   - ClassName: " .. gui.ClassName)
        
        task.wait(0.1) -- Small delay to ensure GUI is fully loaded
        checkReelGUI()
    end
end)

-- Monitor reel GUI removal
lp.PlayerGui.ChildRemoved:Connect(function(gui)
    if gui.Name == "reel" then
        debugPrint("REEL GUI REMOVED!")
    end
end)

-- Hook reelfinished events to see what's being sent
local function setupHook()
    if hookmetamethod then
        local old = hookmetamethod(game, "__namecall", function(self, ...)
            local method, args = getnamecallmethod(), {...}
            
            if method == 'FireServer' and self.Name == 'reelfinished' then
                debugPrint("REELFINISHED EVENT FIRED!")
                debugPrint("   - Args[1] (success rate): " .. tostring(args[1]))
                debugPrint("   - Args[2] (caught): " .. tostring(args[2]))
                debugPrint("   - Args count: " .. #args)
            end
            
            return old(self, ...)
        end)
        debugPrint("Hooked reelfinished events")
    else
        debugPrint("hookmetamethod not available")
    end
end

setupHook()
debugPrint("Debug tool ready! Start fishing to see diagnostics...")