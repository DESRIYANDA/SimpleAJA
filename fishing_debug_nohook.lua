-- No Hook Debug - Absolutely no interference
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

print("NO HOOK DEBUG STARTED - Safest version")

local function debugPrint(message)
    print("[SAFE DEBUG] " .. tostring(message))
end

-- Only GUI monitoring - no hooks, no conflicts
lp.PlayerGui.ChildAdded:Connect(function(gui)
    if gui.Name == "reel" then
        debugPrint("REEL GUI APPEARED!")
        
        -- Wait for GUI to load then check elements
        task.spawn(function()
            task.wait(0.2)
            if gui and gui.Parent then
                debugPrint("GUI still exists after 0.2s")
                debugPrint("GUI Enabled: " .. tostring(gui.Enabled))
                
                -- Check for common reel elements
                for _, child in pairs(gui:GetChildren()) do
                    if child.Name:lower():find("safe") or child.Name:lower():find("zone") or child.Name:lower():find("bar") then
                        debugPrint("Found element: " .. child.Name)
                    end
                end
            end
        end)
    end
end)

lp.PlayerGui.ChildRemoved:Connect(function(gui)
    if gui.Name == "reel" then
        debugPrint("REEL GUI REMOVED!")
    end
end)

debugPrint("Safe debug ready - no hooks, no interference!")
debugPrint("Fish normally and GUI events will be logged")