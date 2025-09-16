--// Services
local Players = cloneref(game:GetService('Players'))
local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local RunService = cloneref(game:GetService('RunService'))
local GuiService = cloneref(game:GetService('GuiService'))

--// Variables
local flags = {}
local lp = Players.LocalPlayer

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
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
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
RunService.Heartbeat:Connect(function()
    -- Auto Shake
    if flags.autoshake then
        if FindChild(lp.PlayerGui, 'shakeui') and FindChild(lp.PlayerGui['shakeui'], 'safezone') and FindChild(lp.PlayerGui['shakeui']['safezone'], 'button') then
            GuiService.SelectedObject = lp.PlayerGui['shakeui']['safezone']['button']
            if GuiService.SelectedObject == lp.PlayerGui['shakeui']['safezone']['button'] then
                game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end
        end
    end
    
    -- Auto Cast
    if flags.autocast then
        local rod = FindRod()
        if rod ~= nil and rod['values']['lure'].Value <= .001 and task.wait(.5) then
            rod.events.cast:FireServer(100, 1)
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