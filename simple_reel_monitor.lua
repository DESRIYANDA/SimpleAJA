--// Simple Reel Monitor - Focus on reelfinished only
--// Monitor exact arguments used in successful reel completion

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local lp = Players.LocalPlayer

print("🎯 SIMPLE REEL MONITOR - reelfinished focus")
print("Play minigame normally to capture exact arguments!")
print("==============================================")

local capturedReels = {}

-- Monitor outgoing reelfinished calls
if hookmetamethod then
    print("🔍 Monitoring outgoing reelfinished calls...")
    
    local originalFireServer
    originalFireServer = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "FireServer" and self.Name == "reelfinished" then
            local timestamp = os.date("%H:%M:%S")
            
            print("📤 [" .. timestamp .. "] OUTGOING reelfinished:")
            print("   Remote Path: " .. self:GetFullName())
            
            for i, arg in ipairs(args) do
                print("   Arg " .. i .. ": " .. tostring(arg) .. " (" .. type(arg) .. ")")
            end
            
            -- Store for analysis
            table.insert(capturedReels, {
                type = "OUTGOING",
                time = timestamp,
                remote = self:GetFullName(),
                args = args
            })
            
            print("   ✅ Captured outgoing call #" .. #capturedReels)
            print("")
        end
        
        return originalFireServer(self, ...)
    end)
else
    warn("⚠️ hookmetamethod not available - only incoming events will be monitored")
end

-- Monitor incoming reelfinished events
if ReplicatedStorage:FindFirstChild("events") and ReplicatedStorage.events:FindFirstChild("reelfinished") then
    print("🔍 Monitoring incoming reelfinished events...")
    
    ReplicatedStorage.events.reelfinished.OnClientEvent:Connect(function(...)
        local args = {...}
        local timestamp = os.date("%H:%M:%S")
        
        print("📥 [" .. timestamp .. "] INCOMING reelfinished:")
        
        for i, arg in ipairs(args) do
            print("   Arg " .. i .. ": " .. tostring(arg) .. " (" .. type(arg) .. ")")
        end
        
        -- Store for analysis
        table.insert(capturedReels, {
            type = "INCOMING",
            time = timestamp,
            args = args
        })
        
        print("   ✅ Captured incoming event #" .. #capturedReels)
        print("")
    end)
end

-- Show summary of captured reels
local function showSummary()
    if #capturedReels == 0 then
        print("❌ No reelfinished events captured yet!")
        print("   Cast rod and complete minigame normally first.")
        return
    end
    
    print("📊 REELFINISHED SUMMARY (" .. #capturedReels .. " total):")
    print("===============================================")
    
    for i, reel in ipairs(capturedReels) do
        print("[" .. i .. "] " .. reel.time .. " - " .. reel.type)
        if reel.remote then
            print("     Remote: " .. reel.remote)
        end
        
        if reel.args and #reel.args > 0 then
            print("     Args: " .. table.concat(reel.args, ", "))
            
            -- Extract common pattern
            local arg1 = reel.args[1] -- Usually completion rate
            local arg2 = reel.args[2] -- Usually caught boolean
            
            print("     Rate: " .. tostring(arg1) .. " | Caught: " .. tostring(arg2))
        end
        print("")
    end
    
    -- Show recommended arguments based on captured data
    if #capturedReels > 0 then
        local lastSuccessful = capturedReels[#capturedReels]
        print("🎯 RECOMMENDED ALWAYS CATCH ARGUMENTS:")
        print("Based on your last successful completion:")
        print("   ReplicatedStorage.events.reelfinished:FireServer(" .. table.concat(lastSuccessful.args, ", ") .. ")")
        print("")
    end
end

-- Auto-monitor when reel appears
lp.PlayerGui.ChildAdded:Connect(function(gui)
    if gui.Name == "reel" then
        print("🎣 REEL GUI DETECTED!")
        print("   Complete the minigame normally - events will be captured automatically")
        print("   Type 'summary' in chat or wait for completion")
    end
end)

-- Monitor chat for summary command
if lp.Chatted then
    lp.Chatted:Connect(function(message)
        if message:lower() == "summary" or message:lower() == "/summary" then
            showSummary()
        elseif message:lower() == "clear" or message:lower() == "/clear" then
            capturedReels = {}
            print("🗑️ Captured events cleared!")
        end
    end)
end

-- Auto-show summary when reel GUI is removed (after completion)
lp.PlayerGui.ChildRemoved:Connect(function(gui)
    if gui.Name == "reel" and #capturedReels > 0 then
        task.wait(1) -- Wait a moment for events to process
        print("🏁 REEL COMPLETED! Showing captured data...")
        showSummary()
    end
end)

print("🎮 SIMPLE REEL MONITOR ACTIVE!")
print("Instructions:")
print("1. Cast your fishing rod normally")
print("2. Wait for fish to bite")
print("3. Complete reel minigame normally (don't use any cheats)")
print("4. Monitor will automatically show captured arguments")
print("5. Type 'summary' in chat anytime to see captured data")
print("6. Use the captured arguments in your Always Catch!")
print("")
print("🎯 Ready! Cast your rod and play normally...")