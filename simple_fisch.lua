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
local shakeDebounce = false

-- Enhanced Auto Shake Event Listener (Faster Response)
local function setupShakeListener()
    if flags.autoshake then
        local playerGui = lp.PlayerGui
        
        -- Monitor for shake UI appearance
        local function onShakeUIAdded()
            if FindChild(playerGui, 'shakeui') then
                local shakeUI = playerGui.shakeui
                if FindChild(shakeUI, 'safezone') and FindChild(shakeUI.safezone, 'button') then
                    local shakeButton = shakeUI.safezone.button
                    
                    -- Instant response when shake UI appears
                    task.spawn(function()
                        -- Wait for button to be fully loaded
                        task.wait(0.01)
                        
                        -- Triple activation for maximum speed and reliability
                        for attempt = 1, 5 do
                            pcall(function()
                                -- Method 1: Virtual Key Press
                                GuiService.SelectedObject = shakeButton
                                game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                                
                                -- Method 2: Direct Fire
                                shakeButton.Activated:Fire()
                                
                                -- Method 3: Mouse Click Simulation
                                local VirtualInputManager = game:GetService('VirtualInputManager')
                                local buttonPos = shakeButton.AbsolutePosition + shakeButton.AbsoluteSize/2
                                VirtualInputManager:SendMouseButtonEvent(buttonPos.X, buttonPos.Y, 0, true, game, 1)
                                VirtualInputManager:SendMouseButtonEvent(buttonPos.X, buttonPos.Y, 0, false, game, 1)
                            end)
                            task.wait(0.01) -- Very small delay between attempts
                        end
                    end)
                end
            end
        end
        
        -- Connect to PlayerGui changes for instant detection
        playerGui.ChildAdded:Connect(function(child)
            if child.Name == "shakeui" and flags.autoshake then
                onShakeUIAdded()
            end
        end)
        
        -- Also check existing shake UI
        if FindChild(playerGui, 'shakeui') then
            onShakeUIAdded()
        end
    end
end

-- Setup the enhanced shake listener
task.spawn(setupShakeListener)

RunService.Heartbeat:Connect(function()
    -- Backup Auto Shake (In case event listener misses)
    if flags.autoshake then
        if FindChild(lp.PlayerGui, 'shakeui') and FindChild(lp.PlayerGui['shakeui'], 'safezone') and FindChild(lp.PlayerGui['shakeui']['safezone'], 'button') then
            local shakeButton = lp.PlayerGui['shakeui']['safezone']['button']
            local currentTime = tick()
            
            -- Prevent spam but allow rapid response
            if not shakeDebounce or (currentTime - lastShakeTime) > 0.05 then
                shakeDebounce = true
                lastShakeTime = currentTime
                
                -- Multiple rapid fire methods for faster response
                task.spawn(function()
                    -- Method 1: GuiService selection + VirtualInput (fastest)
                    GuiService.SelectedObject = shakeButton
                    if GuiService.SelectedObject == shakeButton then
                        game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                        game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    end
                    
                    -- Method 2: Direct button activation
                    pcall(function()
                        for i = 1, 3 do -- Multiple attempts for reliability
                            shakeButton.Activated:Fire()
                            task.wait()
                        end
                    end)
                    
                    -- Method 3: Mouse simulation
                    pcall(function()
                        local VirtualInputManager = game:GetService('VirtualInputManager')
                        local camera = workspace.CurrentCamera
                        local buttonPos = shakeButton.AbsolutePosition + shakeButton.AbsoluteSize/2
                        
                        VirtualInputManager:SendMouseButtonEvent(buttonPos.X, buttonPos.Y, 0, true, game, 1)
                        VirtualInputManager:SendMouseButtonEvent(buttonPos.X, buttonPos.Y, 0, false, game, 1)
                    end)
                    
                    -- Reset debounce after short delay
                    task.wait(0.1)
                    shakeDebounce = false
                end)
            end
        else
            shakeDebounce = false
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