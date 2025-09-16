-- Ultra Light Fishing Debug Tool - No lag version
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer

print("ULTRA LIGHT FISHING DEBUG STARTED")
print("==================================================")

local function debugPrint(message)
    print("[FISHING DEBUG] " .. tostring(message))
end

-- Simple rod finder (only when called)
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

-- Only monitor GUI events (no continuous checking)
lp.PlayerGui.ChildAdded:Connect(function(gui)
    if gui.Name == "reel" then
        debugPrint("REEL GUI APPEARED!")
        debugPrint("   - Enabled: " .. tostring(gui.Enabled))
        
        -- Check elements
        task.wait(0.1)
        local safezone = gui:FindFirstChild('safezone')
        local bar = gui:FindFirstChild('bar')
        debugPrint("   - Safezone: " .. tostring(safezone and "Found" or "Not Found"))
        debugPrint("   - Bar: " .. tostring(bar and "Found" or "Not Found"))
        
        -- Check rod status when GUI appears
        local rod = FindRod()
        if rod and rod:FindFirstChild('values') and rod.values:FindFirstChild('lure') then
            debugPrint("   - Rod lure value: " .. rod.values.lure.Value)
        end
    end
end)

lp.PlayerGui.ChildRemoved:Connect(function(gui)
    if gui.Name == "reel" then
        debugPrint("REEL GUI REMOVED!")
    end
end)

-- Hook reelfinished events
local function setupHook()
    if hookmetamethod then
        local old = hookmetamethod(game, "__namecall", function(self, ...)
            local method, args = getnamecallmethod(), {...}
            
            if method == 'FireServer' and self.Name == 'reelfinished' then
                debugPrint("REELFINISHED EVENT FIRED!")
                debugPrint("   - Success rate: " .. tostring(args[1]))
                debugPrint("   - Caught: " .. tostring(args[2]))
                debugPrint("   - Total args: " .. #args)
            end
            
            return old(self, ...)
        end)
        debugPrint("Hooked reelfinished events")
    else
        debugPrint("hookmetamethod not available")
    end
end

setupHook()
debugPrint("Ultra light debug ready! No continuous monitoring = No lag!")
debugPrint("Just fish normally and watch the events")