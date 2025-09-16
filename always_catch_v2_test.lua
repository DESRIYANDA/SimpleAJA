-- Always Catch v2 Status Checker
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

print("ALWAYS CATCH V2 STATUS CHECKER")

-- Check if simple_fisch.lua is loaded and flags exist
if flags then
    print("[STATUS] simple_fisch.lua flags detected!")
    print("[STATUS] Always Catch v2 flag: " .. tostring(flags.alwayscatchv2))
    
    if flags.alwayscatchv2 then
        print("[STATUS] ✅ Always Catch v2 is ENABLED")
    else
        print("[STATUS] ❌ Always Catch v2 is DISABLED")
        print("[STATUS] Enable it in the GUI first!")
    end
else
    print("[STATUS] ❌ simple_fisch.lua not loaded or flags not available")
    print("[STATUS] Load simple_fisch.lua first!")
end

-- Monitor if Always Catch v2 code actually runs
local originalFindChild = lp.PlayerGui.FindFirstChild
lp.PlayerGui.FindFirstChild = function(self, childName)
    local result = originalFindChild(self, childName)
    if childName == "reel" and result then
        print("[MONITOR] FindChild('reel') called - Always Catch v2 checking for GUI!")
        print("[MONITOR] Result: " .. tostring(result ~= nil))
    end
    return result
end

print("[MONITOR] Monitoring FindChild calls for 'reel'")
print("[MONITOR] Start fishing to see if Always Catch v2 logic runs")

-- Simple test
task.spawn(function()
    while true do
        task.wait(1)
        if flags and flags.alwayscatchv2 then
            local reelGui = lp.PlayerGui:FindFirstChild('reel')
            if reelGui then
                print("[TEST] REEL GUI FOUND! Always Catch v2 should be running...")
            end
        end
    end
end)