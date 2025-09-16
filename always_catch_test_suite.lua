--// Always Catch Test Suite
--// Script untuk testing berbagai konfigurasi Always Catch secara individual
--// Tekan angka 1-9 untuk test berbagai mode saat dalam minigame reel

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local lp = Players.LocalPlayer

print("=== ALWAYS CATCH TEST SUITE LOADED ===")
print("Tekan angka 1-9 saat dalam minigame reel untuk test berbagai mode:")
print("1 = Test Perfect 100% (Classic)")
print("2 = Test Natural 60-90% Random")
print("3 = Test Medium 70-85%")
print("4 = Test Low Success 50-70%")
print("5 = Test High Success 85-95%")
print("6 = Test Ultra Safe 95-99%")
print("7 = Test Instant Completion")
print("8 = Test Delayed 3 Second")
print("9 = Test Random Everything")
print("0 = Force Complete Current Reel")
print("=======================================")

-- Test configurations
local testConfigs = {
    [Enum.KeyCode.One] = {
        name = "Perfect 100%",
        rate = 100,
        caught = true,
        delay = 0,
        description = "Classic perfect catch (suspicious)"
    },
    [Enum.KeyCode.Two] = {
        name = "Natural Random 60-90%", 
        rate = function() return math.random(60, 90) end,
        caught = true,
        delay = function() return math.random(100, 300) / 100 end,
        description = "Natural looking random completion"
    },
    [Enum.KeyCode.Three] = {
        name = "Medium 70-85%",
        rate = function() return math.random(70, 85) end,
        caught = true,
        delay = function() return math.random(150, 250) / 100 end,
        description = "Medium success rate with natural timing"
    },
    [Enum.KeyCode.Four] = {
        name = "Low Success 50-70%",
        rate = function() return math.random(50, 70) end,
        caught = true,
        delay = function() return math.random(200, 400) / 100 end,
        description = "Lower success rate, longer timing"
    },
    [Enum.KeyCode.Five] = {
        name = "High Success 85-95%",
        rate = function() return math.random(85, 95) end,
        caught = true,
        delay = function() return math.random(80, 150) / 100 end,
        description = "High success but not perfect"
    },
    [Enum.KeyCode.Six] = {
        name = "Ultra Safe 95-99%",
        rate = function() return math.random(95, 99) end,
        caught = true,
        delay = function() return math.random(50, 120) / 100 end,
        description = "Almost perfect but still believable"
    },
    [Enum.KeyCode.Seven] = {
        name = "Instant Completion",
        rate = function() return math.random(80, 95) end,
        caught = true,
        delay = 0,
        description = "No delay, instant completion"
    },
    [Enum.KeyCode.Eight] = {
        name = "Delayed 3 Second",
        rate = function() return math.random(70, 90) end,
        caught = true,
        delay = 3,
        description = "Long 3 second delay before completion"
    },
    [Enum.KeyCode.Nine] = {
        name = "Random Everything",
        rate = function() return math.random(40, 100) end,
        caught = function() return math.random() > 0.15 end, -- 85% catch rate
        delay = function() return math.random(0, 500) / 100 end,
        description = "Completely random rate, catch chance, and timing"
    },
    [Enum.KeyCode.Zero] = {
        name = "Force Complete",
        rate = 100,
        caught = true,
        delay = 0,
        description = "Emergency force complete current reel"
    }
}

-- Function to execute test
local function executeTest(config)
    local rate = type(config.rate) == "function" and config.rate() or config.rate
    local caught = type(config.caught) == "function" and config.caught() or config.caught
    local delay = type(config.delay) == "function" and config.delay() or config.delay
    
    print("🎣 EXECUTING TEST: " .. config.name)
    print("   Rate: " .. rate .. "%")
    print("   Caught: " .. tostring(caught))
    print("   Delay: " .. delay .. " seconds")
    print("   Description: " .. config.description)
    
    if delay > 0 then
        print("   ⏱️ Waiting " .. delay .. " seconds...")
        task.wait(delay)
    end
    
    print("   🚀 Firing reelfinished...")
    ReplicatedStorage.events.reelfinished:FireServer(rate, caught)
    
    -- Try to hide reel GUI
    pcall(function()
        if lp.PlayerGui:FindFirstChild("reel") then
            lp.PlayerGui.reel.Enabled = false
            print("   ✅ Reel GUI hidden")
        end
    end)
    
    print("   ✅ Test completed!")
end

-- Function to check if in reel minigame
local function isInReelMinigame()
    return lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled
end

-- Input handler
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local config = testConfigs[input.KeyCode]
    if config then
        if input.KeyCode == Enum.KeyCode.Zero then
            -- Force complete - no reel check needed
            executeTest(config)
        elseif isInReelMinigame() then
            executeTest(config)
        else
            warn("⚠️ " .. config.name .. " test hanya bisa digunakan saat dalam reel minigame!")
            print("   Masuk ke minigame reel dulu, lalu tekan tombol ini lagi.")
        end
    end
end)

-- Monitor reel GUI status
local reelMonitorConnection
reelMonitorConnection = lp.PlayerGui.ChildAdded:Connect(function(gui)
    if gui.Name == "reel" then
        print("🎣 REEL MINIGAME DETECTED!")
        print("   Sekarang Anda bisa menekan angka 1-9 untuk test Always Catch")
        print("   Reel GUI: " .. tostring(gui.Enabled))
    end
end)

lp.PlayerGui.ChildRemoved:Connect(function(gui)
    if gui.Name == "reel" then
        print("🏁 REEL MINIGAME ENDED")
    end
end)

-- Status checker
task.spawn(function()
    while true do
        task.wait(5)
        if isInReelMinigame() then
            print("📊 STATUS: Dalam reel minigame - siap untuk testing!")
        end
    end
end)

print("🎮 Always Catch Test Suite siap digunakan!")
print("   Cast pancing Anda dan tunggu ikan strike, lalu test berbagai mode!")