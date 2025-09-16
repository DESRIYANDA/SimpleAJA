--// Services
local Players = cloneref(game:GetService('Players'))
local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local RunService = cloneref(game:GetService('RunService'))
local GuiService = cloneref(game:GetService('GuiService'))
local VirtualInputManager = game:GetService("VirtualInputManager")

--// Variables
local flags = {}
local lp = Players.LocalPlayer
flags.autocastmode = "Legit" -- Default mode
flags.autocastdelay = 1 -- Default delay in seconds
flags.ragebobberDistance = 0.1 -- Default close distance for instant bobber

--// Functions
FindChildOfClass = function(parent, classname)
    return parent:FindFirstChildOfClass(classname)
end
FindChild = function(parent, child)
    return parent:FindFirstChild(child)
end
FindChildOfType = function(parent, childname, classname)
    child = parent:FindFirstChild(childname)
    if child and child.ClassName == classname then
        return child
    end
end
CheckFunc = function(func)
    return typeof(func) == 'function'
end

--// Custom Functions
getchar = function()
    return lp.Character or lp.CharacterAdded:Wait()
end
gethrp = function()
    return getchar():WaitForChild('HumanoidRootPart')
end
gethum = function()
    return getchar():WaitForChild('Humanoid')
end
FindRod = function()
    if FindChildOfClass(getchar(), 'Tool') and FindChild(FindChildOfClass(getchar(), 'Tool'), 'values') then
        return FindChildOfClass(getchar(), 'Tool')
    else
        return nil
    end
end

--// Load Kavo UI Library from GitHub
local Kavo
local success, result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/DESRIYANDA/SimpleAJA/main/kavo.lua"))()
end)

if success then
    Kavo = result
else
    -- Fallback jika gagal load dari GitHub
    warn("Failed to load Kavo from GitHub, using fallback...")
    Kavo = loadstring(game:HttpGet("https://pastebin.com/raw/vff1bQ9F"))()
end

--// UI Creation
local window = Kavo.CreateLib("Simple Fisch")
local mainTab = window:NewTab("Main Features")
local mainSection = mainTab:NewSection("Fishing Automation")

-- Create toggles for the main features
mainSection:NewToggle("Auto Cast", "Automatically cast your fishing rod", function(state)
    flags.autocast = state
end)

mainSection:NewDropdown("Auto Cast Mode", "Choose between Legit and Rage mode", {"Legit", "Rage"}, function(mode)
    flags.autocastmode = mode
end)

mainSection:NewSlider("Auto Cast Delay", "Delay before auto casting (seconds)", 10, 0, function(value)
    flags.autocastdelay = value
end)

mainSection:NewSlider("Rage Bobber Distance", "Distance for Rage mode bobber (0.1 = closest)", 2, 0.1, function(value)
    flags.ragebobberDistance = value
end)

mainSection:NewToggle("Auto Shake", "Automatically shake when fish bites", function(state)
    flags.autoshake = state
    -- Re-setup shake listener when toggled
    if state then
        task.spawn(setupShakeListener)
    end
end)

mainSection:NewToggle("Auto Reel", "Automatically reel in your catch", function(state)
    flags.autoreel = state
end)

mainSection:NewToggle("Perfect Cast", "Always cast with 100% power", function(state)
    flags.perfectcast = state
end)

mainSection:NewToggle("Always Catch", "Never lose a fish when reeling", function(state)
    flags.alwayscatch = state
end)

mainSection:NewToggle("Super Instant Reel", "Skip reel animation and instantly catch fish", function(state)
    flags.superinstantreel = state
end)

--// Main Logic Loops
local lastShakeTime = 0
local shakeConnection

-- Enhanced Auto Shake System (Fixed and Faster)
local function setupShakeListener()
    -- Clean up existing connection
    if shakeConnection then
        shakeConnection:Disconnect()
    end
    
    -- Monitor PlayerGui for shake UI
    shakeConnection = lp.PlayerGui.ChildAdded:Connect(function(gui)
        if gui.Name == "shakeui" and flags.autoshake then
            -- Wait for safezone to be added
            gui.ChildAdded:Connect(function(child)
                if child.Name == "safezone" then
                    -- Wait for button to be added
                    child.ChildAdded:Connect(function(button)
                        if button.Name == "button" and button:IsA("ImageButton") then
                            -- Instant shake response
                            task.spawn(function()
                                local attempts = 0
                                while button.Parent and flags.autoshake and attempts < 10 do
                                    attempts = attempts + 1
                                    
                                    -- Multiple methods for maximum reliability
                                    pcall(function()
                                        -- Method 1: Mouse click at button center
                                        local pos = button.AbsolutePosition
                                        local size = button.AbsoluteSize
                                        VirtualInputManager:SendMouseButtonEvent(
                                            pos.X + size.X / 2, 
                                            pos.Y + size.Y / 2, 
                                            0, true, lp, 0
                                        )
                                        VirtualInputManager:SendMouseButtonEvent(
                                            pos.X + size.X / 2, 
                                            pos.Y + size.Y / 2, 
                                            0, false, lp, 0
                                        )
                                    end)
                                    
                                    pcall(function()
                                        -- Method 2: GuiService selection + Enter key
                                        GuiService.SelectedObject = button
                                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                                    end)
                                    
                                    pcall(function()
                                        -- Method 3: Direct button activation
                                        button.Activated:Fire()
                                    end)
                                    
                                    task.wait(0.001) -- Very fast attempts
                                    
                                    -- Check if shake UI is gone (success)
                                    if not button.Parent or not lp.PlayerGui:FindFirstChild("shakeui") then
                                        break
                                    end
                                end
                            end)
                        end
                    end)
                end
            end)
        end
    end)
end

-- Setup the enhanced shake listener
task.spawn(setupShakeListener)

-- Enhanced AutoCast Event Listeners
local autoCastConnection1, autoCastConnection2

local function setupAutoCastListeners()
    -- Connection 1: When tool is equipped
    autoCastConnection1 = getchar().ChildAdded:Connect(function(child)
        if child:IsA("Tool") and child:FindFirstChild("events") and child.events:FindFirstChild("cast") and flags.autocast then
            task.wait(flags.autocastdelay or 1) -- Use configurable delay
            
            if flags.autocastmode == "Legit" then
                -- Legit Mode: Simulate real player behavior (like king.lua)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, lp, 0)
                gethrp().ChildAdded:Connect(function()
                    if gethrp():FindFirstChild("power") and gethrp().power.powerbar.bar then
                        gethrp().power.powerbar.bar.Changed:Connect(function(property)
                            if property == "Size" and gethrp().power.powerbar.bar.Size == UDim2.new(1, 0, 1, 0) then
                                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, lp, 0)
                            end
                        end)
                    end
                end)
            elseif flags.autocastmode == "Rage" then
                -- Rage Mode: Instant bobber with configurable distance
                child.events.cast:FireServer(100, flags.ragebobberDistance or 0.1)
            end
        end
    end)
    
    -- Connection 2: When reel GUI is removed (for continuous casting)
    autoCastConnection2 = lp.PlayerGui.ChildRemoved:Connect(function(gui)
        if gui.Name == "reel" and flags.autocast then
            local tool = FindRod()
            if tool and tool:FindFirstChild("events") and tool.events:FindFirstChild("cast") then
                task.wait(flags.autocastdelay or 1) -- Use configurable delay
                
                if flags.autocastmode == "Legit" then
                    -- Legit Mode (like king.lua)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, lp, 0)
                    gethrp().ChildAdded:Connect(function()
                        if gethrp():FindFirstChild("power") and gethrp().power.powerbar.bar then
                            gethrp().power.powerbar.bar.Changed:Connect(function(property)
                                if property == "Size" and gethrp().power.powerbar.bar.Size == UDim2.new(1, 0, 1, 0) then
                                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, lp, 0)
                                end
                            end)
                        end
                    end)
                elseif flags.autocastmode == "Rage" then
                    -- Rage Mode: Instant bobber with configurable distance
                    tool.events.cast:FireServer(100, flags.ragebobberDistance or 0.1)
                end
            end
        end
    end)
end

-- Setup AutoCast listeners
task.spawn(setupAutoCastListeners)

RunService.Heartbeat:Connect(function()
    -- Auto Cast (Legit & Rage Mode)
    if flags.autocast then
        local rod = FindRod()
        if rod ~= nil and rod['values']['lure'].Value <= .001 then
            if flags.autocastmode == "Legit" then
                -- Legit Mode: Simulate real player behavior with power bar
                task.spawn(function()
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, lp, 0)
                    
                    -- Wait for power bar to appear and monitor it
                    local hrp = gethrp()
                    local powerBarFound = false
                    
                    -- Monitor for power bar appearance
                    local connection
                    connection = hrp.ChildAdded:Connect(function(child)
                        if child.Name == "power" and child:FindFirstChild("powerbar") then
                            powerBarFound = true
                            local powerBar = child.powerbar.bar
                            
                            -- Monitor power bar size changes
                            local sizeConnection
                            sizeConnection = powerBar.Changed:Connect(function(property)
                                if property == "Size" then
                                    -- Release when power bar reaches 100%
                                    if powerBar.Size == UDim2.new(1, 0, 1, 0) then
                                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, lp, 0)
                                        sizeConnection:Disconnect()
                                        connection:Disconnect()
                                    end
                                end
                            end)
                        end
                    end)
                    
                    -- Failsafe: Auto release after 5 seconds if power bar not found
                    task.wait(5)
                    if not powerBarFound then
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, lp, 0)
                        connection:Disconnect()
                    end
                end)
            elseif flags.autocastmode == "Rage" then
                -- Rage Mode: Instant bobber with configurable distance
                rod.events.cast:FireServer(100, flags.ragebobberDistance or 0.1)
            end
        end
    end
    
    -- Auto Reel
    if flags.autoreel then
        local rod = FindRod()
        if rod ~= nil and rod['values']['lure'].Value == 100 and task.wait(.5) then
            ReplicatedStorage.events.reelfinished:FireServer(100, true)
        end
    end
    
    -- Super Instant Reel
    if flags.superinstantreel then
        local rod = FindRod()
        if rod ~= nil and rod['values']['lure'].Value == 100 then
            -- Instantly complete the reel without animation
            task.spawn(function()
                ReplicatedStorage.events.reelfinished:FireServer(100, true)
                -- Force reset lure value to prepare for next cast
                task.wait(0.1)
                if rod and rod['values'] and rod['values']['lure'] then
                    rod['values']['lure'].Value = 0
                end
            end)
        end
        
        -- Skip reel UI if it appears
        if FindChild(lp.PlayerGui, 'reel') then
            local reelGui = lp.PlayerGui['reel']
            if reelGui.Enabled then
                reelGui.Enabled = false
                ReplicatedStorage.events.reelfinished:FireServer(100, true)
            end
        end
    end
end)

--// Hooks for Perfect Cast and Always Catch
if CheckFunc(hookmetamethod) then
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        local method, args = getnamecallmethod(), {...}
        
        -- Perfect Cast Hook
        if method == 'FireServer' and self.Name == 'cast' and flags.perfectcast then
            args[1] = 100
            return old(self, unpack(args))
        -- Always Catch Hook
        elseif method == 'FireServer' and self.Name == 'reelfinished' and flags.alwayscatch then
            args[1] = 100
            args[2] = true
            return old(self, unpack(args))
        -- Super Instant Reel Hook
        elseif method == 'FireServer' and self.Name == 'reelfinished' and flags.superinstantreel then
            args[1] = 100
            args[2] = true
            return old(self, unpack(args))
        end
        return old(self, ...)
    end)
end