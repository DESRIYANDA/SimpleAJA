--// Simple Always Catch Test UI
--// UI sederhana dengan tombol-tombol test utama

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local TweenService = game:GetService('TweenService')
local lp = Players.LocalPlayer

print("🎮 Loading Simple Always Catch Test UI...")

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "SimpleAlwaysCatchTest"
gui.Parent = lp.PlayerGui
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(1, -260, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

-- Corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.BorderSizePixel = 0
title.Text = "Always Catch Test"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -10, 0, 25)
status.Position = UDim2.new(0, 5, 0, 40)
status.BackgroundTransparency = 1
status.Text = "Cast & wait for fish..."
status.TextColor3 = Color3.fromRGB(255, 255, 100)
status.TextScaled = true
status.Font = Enum.Font.SourceSans
status.Parent = frame

-- Button container
local container = Instance.new("Frame")
container.Size = UDim2.new(1, -10, 1, -75)
container.Position = UDim2.new(0, 5, 0, 70)
container.BackgroundTransparency = 1
container.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = container

-- Function to create button
local function btn(text, color, testFunc)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSansBold
    button.Parent = container
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        if not (lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled) then
            status.Text = "❌ Need reel minigame!"
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        -- Button flash
        local flash = TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
        flash:Play()
        flash.Completed:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play()
        end)
        
        testFunc()
    end)
end

-- Test functions
local function testInstant()
    status.Text = "⚡ Instant 100%"
    status.TextColor3 = Color3.fromRGB(100, 255, 100)
    ReplicatedStorage.events.reelfinished:FireServer(100, true)
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
end

local function testNatural()
    local rate = math.random(85, 95)
    status.Text = "🌿 Natural " .. rate .. "%"
    status.TextColor3 = Color3.fromRGB(100, 255, 100)
    -- Use same direct method as testInstant (no task.spawn, no delay)
    ReplicatedStorage.events.reelfinished:FireServer(rate, true)
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
end

local function testRealistic()
    local rate = math.random(80, 90)
    status.Text = "👤 Realistic " .. rate .. "%"
    status.TextColor3 = Color3.fromRGB(100, 255, 100)
    -- Use same direct method as testInstant (no task.spawn, no delay)
    ReplicatedStorage.events.reelfinished:FireServer(rate, true)
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
end

local function testRandom()
    local rate = math.random(40, 95)
    local caught = math.random() > 0.15
    status.Text = "🎲 Random " .. rate .. "%"
    status.TextColor3 = Color3.fromRGB(100, 255, 100)
    -- Use same direct method as testInstant (no task.spawn, no delay)
    ReplicatedStorage.events.reelfinished:FireServer(rate, caught)
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
    if not caught then
        status.Text = "❌ Fish escaped!"
        status.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

local function forceComplete()
    status.Text = "🆘 Force complete"
    status.TextColor3 = Color3.fromRGB(100, 255, 100)
    ReplicatedStorage.events.reelfinished:FireServer(100, true)
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
end

-- Create buttons
btn("⚡ Instant", Color3.fromRGB(255, 100, 100), testInstant)
btn("🌿 Natural", Color3.fromRGB(100, 200, 100), testNatural)
btn("👤 Realistic", Color3.fromRGB(100, 150, 255), testRealistic)
btn("🎲 Random", Color3.fromRGB(200, 100, 255), testRandom)
btn("🆘 Force", Color3.fromRGB(255, 200, 50), forceComplete)

-- Close button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.BorderSizePixel = 0
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.TextScaled = true
close.Font = Enum.Font.SourceSansBold
close.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = close

close.MouseButton1Click:Connect(function()
    gui:Destroy()
    print("Simple Always Catch Test UI closed")
end)

-- Status monitor
task.spawn(function()
    while gui.Parent do
        if lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled then
            if status.Text == "Cast & wait for fish..." or status.Text == "❌ Need reel minigame!" then
                status.Text = "✅ Ready to test!"
                status.TextColor3 = Color3.fromRGB(100, 255, 100)
            end
        else
            if not string.find(status.Text, "⚡") and not string.find(status.Text, "🌿") and 
               not string.find(status.Text, "👤") and not string.find(status.Text, "🎲") and 
               not string.find(status.Text, "🆘") then
                status.Text = "Cast & wait for fish..."
                status.TextColor3 = Color3.fromRGB(255, 255, 100)
            end
        end
        task.wait(1)
    end
end)

-- Make draggable
local dragging = false
local dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("✅ Simple Always Catch Test UI ready!")
print("   5 test buttons available on the right side")
print("   Cast rod → wait for fish → click test buttons")