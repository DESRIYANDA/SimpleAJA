--// Quick Always Catch Tester
--// Script sederhana untuk test cepat Always Catch saat fishing

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local lp = Players.LocalPlayer

print("=== QUICK ALWAYS CATCH TESTER ===")
print("F1 = Test Instant Perfect (100%, no delay)")
print("F2 = Test Natural (70-90%, 1-3s delay)")
print("F3 = Test Realistic (60-85%, 2-4s delay)")
print("F4 = Test Risky (40-70%, 1-5s delay)")
print("==================================")

-- Quick test functions
local function testInstantPerfect()
    print("🚀 INSTANT PERFECT TEST")
    ReplicatedStorage.events.reelfinished:FireServer(100, true)
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
    print("✅ Completed: 100% instant")
end

local function testNatural()
    print("🌿 NATURAL TEST")
    local rate = math.random(70, 90)
    local delay = math.random(100, 300) / 100
    print("   Rate: " .. rate .. "%, Delay: " .. delay .. "s")
    task.wait(delay)
    ReplicatedStorage.events.reelfinished:FireServer(rate, true)
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
    print("✅ Completed naturally")
end

local function testRealistic()
    print("👤 REALISTIC TEST")
    local rate = math.random(60, 85)
    local delay = math.random(200, 400) / 100
    print("   Rate: " .. rate .. "%, Delay: " .. delay .. "s")
    task.wait(delay)
    ReplicatedStorage.events.reelfinished:FireServer(rate, true)
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
    print("✅ Completed realistically")
end

local function testRisky()
    print("⚡ RISKY TEST")
    local rate = math.random(40, 70)
    local delay = math.random(100, 500) / 100
    local caught = math.random() > 0.2 -- 80% success rate
    print("   Rate: " .. rate .. "%, Delay: " .. delay .. "s, Caught: " .. tostring(caught))
    task.wait(delay)
    ReplicatedStorage.events.reelfinished:FireServer(rate, caught)
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
    print("✅ Completed with risk")
end

-- Key bindings
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled then
        if input.KeyCode == Enum.KeyCode.F1 then
            task.spawn(testInstantPerfect)
        elseif input.KeyCode == Enum.KeyCode.F2 then
            task.spawn(testNatural)
        elseif input.KeyCode == Enum.KeyCode.F3 then
            task.spawn(testRealistic)
        elseif input.KeyCode == Enum.KeyCode.F4 then
            task.spawn(testRisky)
        end
    else
        if input.KeyCode == Enum.KeyCode.F1 or input.KeyCode == Enum.KeyCode.F2 or 
           input.KeyCode == Enum.KeyCode.F3 or input.KeyCode == Enum.KeyCode.F4 then
            warn("⚠️ Harus dalam reel minigame untuk menggunakan test!")
        end
    end
end)

print("🎮 Quick Tester loaded! Cast dan tunggu ikan strike, lalu tekan F1-F4")