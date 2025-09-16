-- Minimal Fishing Debug - No spam, no lag
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

print("MINIMAL FISHING DEBUG STARTED")

-- Simple debug function
local function debugPrint(message)
    print("[DEBUG] " .. tostring(message))
end

-- Only monitor the most essential events
debugPrint("Monitoring GUI events only...")

-- Monitor reel GUI (safest approach)
lp.PlayerGui.ChildAdded:Connect(function(gui)
    if gui.Name == "reel" then
        debugPrint("REEL GUI APPEARED!")
        task.wait(0.1)
        debugPrint("GUI Enabled: " .. tostring(gui.Enabled))
    end
end)

lp.PlayerGui.ChildRemoved:Connect(function(gui)
    if gui.Name == "reel" then
        debugPrint("REEL GUI REMOVED!")
    end
end)

-- Minimal hook - only if available and safe
pcall(function()
    if hookmetamethod and typeof(hookmetamethod) == "function" then
        local old = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if method == 'FireServer' and self.Name == 'reelfinished' then
                debugPrint("REELFINISHED: " .. tostring(args[1]) .. ", " .. tostring(args[2]))
            end
            
            return old(self, ...)
        end)
        debugPrint("Hook active")
    else
        debugPrint("No hook available")
    end
end)

debugPrint("Ready - fish and watch for GUI events")