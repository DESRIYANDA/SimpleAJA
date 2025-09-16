--// Simple Reel Event Capturer
--// Script sederhana untuk capture event reelfinished saat bermain normal

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local lp = Players.LocalPlayer

print("🎯 SIMPLE REEL EVENT CAPTURER")
print("Play fishing minigame normally to capture real arguments!")
print("========================================================")

local capturedReelData = nil
local isMonitoring = false

-- Simple function to capture reelfinished
local function captureReelFinished()
    if not hookmetamethod then
        warn("❌ hookmetamethod not available")
        return
    end
    
    isMonitoring = true
    print("📡 MONITORING ACTIVE - Complete a reel minigame normally!")
    
    local originalFireServer
    originalFireServer = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "FireServer" and self.Name == "reelfinished" and isMonitoring then
            capturedReelData = {
                args = args,
                remote = self,
                time = os.date("%H:%M:%S")
            }
            
            print("✅ REELFINISHED CAPTURED!")
            print("   Args: " .. #args)
            for i, arg in ipairs(args) do
                print("   [" .. i .. "] " .. tostring(arg) .. " (" .. type(arg) .. ")")
            end
            print("   Time: " .. capturedReelData.time)
            print("   Use SPACE to replay this exact event!")
            
            isMonitoring = false
        end
        
        return originalFireServer(self, ...)
    end)
end

-- Function to replay captured event
local function replayCaptured()
    if not capturedReelData then
        warn("❌ No reelfinished captured yet! Play minigame normally first.")
        return
    end
    
    if not (lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled) then
        warn("⚠️ Must be in reel minigame!")
        return
    end
    
    print("🔄 REPLAYING CAPTURED REELFINISHED:")
    for i, arg in ipairs(capturedReelData.args) do
        print("   [" .. i .. "] " .. tostring(arg))
    end
    
    capturedReelData.remote:FireServer(unpack(capturedReelData.args))
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
    print("✅ Replay completed!")
end

-- Function to test different rates with captured structure
local function testWithRate(rate)
    if not capturedReelData then
        warn("❌ No reelfinished captured yet!")
        return
    end
    
    if not (lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled) then
        warn("⚠️ Must be in reel minigame!")
        return
    end
    
    local newArgs = {}
    for i, arg in ipairs(capturedReelData.args) do
        if i == 1 then
            newArgs[i] = rate
        else
            newArgs[i] = arg
        end
    end
    
    print("🧪 TESTING " .. rate .. "% with captured structure:")
    for i, arg in ipairs(newArgs) do
        print("   [" .. i .. "] " .. tostring(arg))
    end
    
    capturedReelData.remote:FireServer(unpack(newArgs))
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
    print("✅ Test completed!")
end

-- Simple key controls
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        captureReelFinished()
    elseif input.KeyCode == Enum.KeyCode.Space then
        replayCaptured()
    elseif input.KeyCode == Enum.KeyCode.Q then
        testWithRate(80)
    elseif input.KeyCode == Enum.KeyCode.W then
        testWithRate(90)
    elseif input.KeyCode == Enum.KeyCode.E then
        testWithRate(95)
    elseif input.KeyCode == Enum.KeyCode.I then
        if capturedReelData then
            print("📋 CAPTURED DATA:")
            print("   Time: " .. capturedReelData.time)
            print("   Args: " .. #capturedReelData.args)
            for i, arg in ipairs(capturedReelData.args) do
                print("   [" .. i .. "] " .. tostring(arg) .. " (" .. type(arg) .. ")")
            end
        else
            print("❌ No data captured yet")
        end
    end
end)

-- Auto-prompt when reel appears
lp.PlayerGui.ChildAdded:Connect(function(gui)
    if gui.Name == "reel" then
        print("🎣 REEL MINIGAME DETECTED!")
        if not capturedReelData then
            print("   Complete this minigame normally to capture real arguments")
            print("   Or press F to start monitoring")
        else
            print("   SPACE = Replay captured event")
            print("   Q/W/E = Test with 80%/90%/95%")
            print("   I = Show captured info")
        end
    end
end)

-- Auto-capture on first reel
lp.PlayerGui.ChildAdded:Connect(function(gui)
    if gui.Name == "reel" and not capturedReelData and not isMonitoring then
        print("🚀 Auto-starting capture for first reel...")
        captureReelFinished()
    end
end)

print("🎮 Simple Capturer Ready!")
print("F = Start capturing")
print("SPACE = Replay captured") 
print("Q/W/E = Test with different rates")
print("I = Show captured info")
print("")
print("WORKFLOW:")
print("1. Cast rod and complete ONE minigame normally")
print("2. Arguments will be auto-captured")
print("3. Test captured arguments in next reel with SPACE/Q/W/E")