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
flags.ragebobberDistance = -250 -- Default close distance for instant bobber (negative = close to character)

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

mainSection:NewSlider("Rage Bobber Distance", "Distance for Rage mode bobber (-500 = very close)", 2, -500, function(value)
    flags.ragebobberDistance = value
end)

mainSection:NewToggle("Auto Shake", "Automatically shake when fish bites", function(state)
    flags.autoshake = state
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

-- Auto Shake (Simple implementation like coba.lua)
RunService.Heartbeat:Connect(function()
    if flags.autoshake then
        if lp.PlayerGui:FindFirstChild('shakeui') and 
           lp.PlayerGui.shakeui:FindFirstChild('safezone') and 
           lp.PlayerGui.shakeui.safezone:FindFirstChild('button') then
            GuiService.SelectedObject = lp.PlayerGui.shakeui.safezone.button
            if GuiService.SelectedObject == lp.PlayerGui.shakeui.safezone.button then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end
        end
    end
end)

-- Enhanced AutoCast Event Listeners
local autoCastConnection1, autoCastConnection2

local function setupAutoCastListeners()
    -- Connection 1: When tool is equipped
    autoCastConnection1 = getchar().ChildAdded:Connect(function(child)
        if child:IsA("Tool") and child:FindFirstChild("events") and child.events:FindFirstChild("cast") and flags.autocast then
            task.wait(flags.autocastdelay or 1) -- Use configurable delay
            
            if flags.autocastmode == "Legit" then
                -- Legit Mode: Exact same as king.lua for maximum speed
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
                -- Rage Mode: Hold mouse briefly then instant cast
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, lp, 0)
                task.wait(0.5) -- Hold mouse for 0.5 seconds
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, lp, 0)
                task.wait(0.1) -- Small delay before cast
                child.events.cast:FireServer(100, flags.ragebobberDistance or -250)
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
                    -- Legit Mode: Exact same as king.lua for maximum speed
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
                    -- Rage Mode: Hold mouse briefly then instant cast
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, lp, 0)
                    task.wait(0.1) -- Hold mouse for 0.5 seconds
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, lp, 0)
                    task.wait(0.1) -- Small delay before cast
                    tool.events.cast:FireServer(100, flags.ragebobberDistance or -250)
                end
            end
        end
    end)
end

-- Setup AutoCast listeners
task.spawn(setupAutoCastListeners)

RunService.Heartbeat:Connect(function()
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