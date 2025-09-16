--// Always Catch UI Test Suite
--// Script dengan UI sederhana untuk testing berbagai konfigurasi Always Catch

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService')
local lp = Players.LocalPlayer

print("🎣 Loading Always Catch UI Test Suite...")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AlwaysCatchTestUI"
screenGui.Parent = lp.PlayerGui
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 500)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Add corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.BorderSizePixel = 0
title.Text = "Always Catch Test Suite"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 50)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Waiting for reel minigame..."
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.SourceSans
statusLabel.Parent = mainFrame

-- Scroll Frame for buttons
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, -20, 1, -100)
scrollFrame.Position = UDim2.new(0, 10, 0, 90)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 8
scrollFrame.Parent = mainFrame

-- UI Layout
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollFrame

-- Function to create test button
local function createTestButton(name, description, layoutOrder, testFunction)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(1, 0, 0, 60)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.BorderSizePixel = 0
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSansBold
    button.LayoutOrder = layoutOrder
    button.Parent = scrollFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    -- Description label
    local desc = Instance.new("TextLabel")
    desc.Name = "Description"
    desc.Size = UDim2.new(1, -10, 0, 20)
    desc.Position = UDim2.new(0, 5, 1, -25)
    desc.BackgroundTransparency = 1
    desc.Text = description
    desc.TextColor3 = Color3.fromRGB(200, 200, 200)
    desc.TextScaled = true
    desc.Font = Enum.Font.SourceSans
    desc.Parent = button
    
    -- Button animation and click
    button.MouseButton1Click:Connect(function()
        -- Check if in reel minigame
        if not (lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled) then
            statusLabel.Text = "❌ Error: Must be in reel minigame!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        -- Button press animation
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(70, 120, 70)})
        tween:Play()
        tween.Completed:Connect(function()
            local tween2 = TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
            tween2:Play()
        end)
        
        -- Execute test
        statusLabel.Text = "🚀 Executing: " .. name
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        testFunction()
    end)
    
    return button
end

-- Test Functions
local function testPerfect()
    print("🎯 PERFECT TEST: 100% rate, instant")
    ReplicatedStorage.events.reelfinished:FireServer(100, true)
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
    statusLabel.Text = "✅ Perfect test completed!"
end

local function testNatural()
    local rate = math.random(85, 95) -- Increased success rate
    local delay = math.random(50, 150) / 100 -- Reduced delay (0.5-1.5s)
    print("🌿 NATURAL TEST: " .. rate .. "% rate, " .. delay .. "s delay")
    statusLabel.Text = "⏱️ Natural test: " .. rate .. "% in " .. delay .. "s"
    task.wait(delay)
    ReplicatedStorage.events.reelfinished:FireServer(rate, true)
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
    statusLabel.Text = "✅ Natural test completed!"
end

local function testRealistic()
    local rate = math.random(80, 90) -- Increased success rate
    local delay = math.random(100, 200) / 100 -- Reduced delay (1-2s)
    print("👤 REALISTIC TEST: " .. rate .. "% rate, " .. delay .. "s delay")
    statusLabel.Text = "⏱️ Realistic test: " .. rate .. "% in " .. delay .. "s"
    task.wait(delay)
    ReplicatedStorage.events.reelfinished:FireServer(rate, true)
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
    statusLabel.Text = "✅ Realistic test completed!"
end

local function testRisky()
    local rate = math.random(40, 70)
    local delay = math.random(100, 500) / 100
    local caught = math.random() > 0.2 -- 80% success
    print("⚡ RISKY TEST: " .. rate .. "% rate, " .. delay .. "s delay, caught: " .. tostring(caught))
    statusLabel.Text = "⏱️ Risky test: " .. rate .. "% in " .. delay .. "s"
    task.wait(delay)
    ReplicatedStorage.events.reelfinished:FireServer(rate, caught)
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
    statusLabel.Text = caught and "✅ Risky test: Caught!" or "❌ Risky test: Lost fish!"
end

local function testInstant()
    local rate = math.random(80, 95)
    print("⚡ INSTANT TEST: " .. rate .. "% rate, no delay")
    ReplicatedStorage.events.reelfinished:FireServer(rate, true)
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
    statusLabel.Text = "✅ Instant test completed!"
end

local function testDelayed()
    local rate = math.random(70, 90)
    print("⏰ DELAYED TEST: " .. rate .. "% rate, 3s delay")
    statusLabel.Text = "⏱️ Delayed test: waiting 3 seconds..."
    task.wait(3)
    ReplicatedStorage.events.reelfinished:FireServer(rate, true)
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
    statusLabel.Text = "✅ Delayed test completed!"
end

local function testRandom()
    local rate = math.random(30, 100)
    local delay = math.random(0, 500) / 100
    local caught = math.random() > 0.15 -- 85% success
    print("🎲 RANDOM TEST: " .. rate .. "% rate, " .. delay .. "s delay, caught: " .. tostring(caught))
    statusLabel.Text = "⏱️ Random test: " .. rate .. "% in " .. delay .. "s"
    if delay > 0 then task.wait(delay) end
    ReplicatedStorage.events.reelfinished:FireServer(rate, caught)
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
    statusLabel.Text = caught and "✅ Random test: Caught!" or "❌ Random test: Lost fish!"
end

local function forceComplete()
    print("🆘 FORCE COMPLETE")
    ReplicatedStorage.events.reelfinished:FireServer(100, true)
    pcall(function() lp.PlayerGui.reel.Enabled = false end)
    statusLabel.Text = "✅ Force completed!"
end

-- Create test buttons
createTestButton("Perfect 100%", "Instant 100% completion", 1, testPerfect)
createTestButton("Natural 70-90%", "Natural timing & rate", 2, function() task.spawn(testNatural) end)
createTestButton("Realistic 60-85%", "Human-like behavior", 3, function() task.spawn(testRealistic) end)
createTestButton("Risky 40-70%", "Low rate, random timing", 4, function() task.spawn(testRisky) end)
createTestButton("Instant 80-95%", "No delay, high rate", 5, testInstant)
createTestButton("Delayed 3s", "Fixed 3 second delay", 6, function() task.spawn(testDelayed) end)
createTestButton("Random All", "Everything random", 7, function() task.spawn(testRandom) end)
createTestButton("Force Complete", "Emergency completion", 8, forceComplete)

-- Update scroll frame size
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end)

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 15)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    print("Always Catch Test UI closed")
end)

-- Monitor reel status
local function updateStatus()
    if lp.PlayerGui:FindFirstChild("reel") and lp.PlayerGui.reel.Enabled then
        statusLabel.Text = "✅ Ready: In reel minigame!"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        statusLabel.Text = "⏳ Waiting: Cast and wait for fish..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    end
end

-- Update status every second
task.spawn(function()
    while screenGui.Parent do
        updateStatus()
        task.wait(1)
    end
end)

-- Draggable functionality
local dragging = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("✅ Always Catch UI Test Suite loaded!")
print("   UI window created with test buttons")
print("   Cast your rod and wait for fish, then use test buttons!")