-- Script Loading Recovery Tool
-- Use this when Universal Cleaner breaks script loading
-- Author: donitono

print("🔄 Script Loading Recovery Tool")
print("===============================")

-- Function to restore critical loading functions
local function restoreLoadingFunctions()
    local restored = 0
    
    print("🔧 Restoring HTTP functions...")
    
    -- Restore HttpService
    pcall(function()
        local HttpService = game:GetService("HttpService")
        HttpService.HttpEnabled = true
        print("✅ HttpService enabled")
        restored = restored + 1
    end)
    
    -- Restore basic request functions
    pcall(function()
        if not _G.request then
            _G.request = request or http_request or syn and syn.request
            if _G.request then
                print("✅ Request function restored")
                restored = restored + 1
            end
        end
    end)
    
    -- Restore HttpGet if missing
    pcall(function()
        if not _G.HttpGet then
            _G.HttpGet = game.HttpGet
            print("✅ HttpGet function restored")
            restored = restored + 1
        end
    end)
    
    -- Restore loadstring if missing
    pcall(function()
        if not _G.loadstring then
            _G.loadstring = loadstring
            print("✅ LoadString function restored")
            restored = restored + 1
        end
    end)
    
    -- Test if we can make HTTP requests
    local httpWorking = false
    pcall(function()
        local test = game:GetService("HttpService"):GetAsync("https://httpbin.org/status/200")
        httpWorking = true
        print("✅ HTTP requests working")
        restored = restored + 1
    end)
    
    if not httpWorking then
        print("⚠️ HTTP requests still not working - may need executor restart")
    end
    
    return restored
end

-- Function to test script loading capability
local function testScriptLoading()
    print("🧪 Testing script loading capability...")
    
    local tests = {
        {
            name = "Basic HTTP Request",
            test = function()
                local HttpService = game:GetService("HttpService")
                local response = HttpService:GetAsync("https://httpbin.org/status/200")
                return response ~= nil
            end
        },
        {
            name = "LoadString Function",
            test = function()
                local code = "return 'test'"
                local func = loadstring(code)
                return func and func() == "test"
            end
        },
        {
            name = "GitHub Access",
            test = function()
                local HttpService = game:GetService("HttpService")
                local response = HttpService:GetAsync("https://raw.githubusercontent.com/DESRIYANDA/SimpleAJA/main/README.md")
                return response and string.len(response) > 0
            end
        },
        {
            name = "Script Execution",
            test = function()
                local code = "print('Recovery test successful')"
                local func = loadstring(code)
                if func then
                    func()
                    return true
                end
                return false
            end
        }
    }
    
    local passed = 0
    local total = #tests
    
    for i, testCase in pairs(tests) do
        local success = pcall(testCase.test)
        if success then
            print("✅ " .. testCase.name .. ": PASSED")
            passed = passed + 1
        else
            print("❌ " .. testCase.name .. ": FAILED")
        end
    end
    
    print("📊 Test Results: " .. passed .. "/" .. total .. " passed")
    
    if passed == total then
        print("🎉 All tests passed! Script loading should work now.")
        return true
    else
        print("⚠️ Some tests failed. May need additional recovery steps.")
        return false
    end
end

-- Function to provide recovery instructions
local function provideInstructions()
    print("")
    print("🔧 RECOVERY INSTRUCTIONS:")
    print("========================")
    print("If script loading still doesn't work:")
    print("")
    print("1. 🔄 RESTART EXECUTOR:")
    print("   - Close your script executor completely")
    print("   - Rejoin the Roblox game")
    print("   - Reopen executor and try again")
    print("")
    print("2. 🧪 TEST WITH SIMPLE SCRIPT:")
    print("   print('Hello World')")
    print("")
    print("3. 🌐 TRY ALTERNATIVE LOADING:")
    print("   local HttpService = game:GetService('HttpService')")
    print("   local code = HttpService:GetAsync('GITHUB_URL')")
    print("   loadstring(code)()")
    print("")
    print("4. 🔧 CHECK EXECUTOR SETTINGS:")
    print("   - Ensure HTTP requests are enabled")
    print("   - Check if executor supports your game")
    print("   - Try different executor if available")
    print("")
    print("5. 🎯 LOAD OUR TOOLS:")
    print("   loadstring(game:HttpGet('https://raw.githubusercontent.com/DESRIYANDA/SimpleAJA/main/main.lua'))()")
end

-- Main recovery function
local function runRecovery()
    print("🚨 STARTING SCRIPT LOADING RECOVERY 🚨")
    print("=====================================")
    
    -- Step 1: Restore functions
    print("🔧 Step 1: Restoring loading functions...")
    local restored = restoreLoadingFunctions()
    print("✅ Restored " .. restored .. " functions")
    
    wait(1)
    
    -- Step 2: Test loading capability
    print("🧪 Step 2: Testing script loading...")
    local testsPassed = testScriptLoading()
    
    wait(1)
    
    -- Step 3: Provide instructions
    print("📋 Step 3: Recovery guidance...")
    provideInstructions()
    
    -- Final status
    print("")
    print("===============================")
    if testsPassed then
        print("✅ RECOVERY SUCCESSFUL!")
        print("🎯 You should now be able to load scripts")
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "🔄 Recovery Complete";
            Text = "Script loading restored!";
            Duration = 5;
        })
    else
        print("⚠️ PARTIAL RECOVERY")
        print("🔄 May need executor restart")
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "⚠️ Partial Recovery";
            Text = "May need executor restart";
            Duration = 5;
        })
    end
    
    print("🔄 Run again: _G.ScriptRecovery()")
end

-- Execute recovery
runRecovery()

-- Provide global function for repeated use
_G.ScriptRecovery = runRecovery

-- Test function to check if loading works
_G.TestScriptLoading = testScriptLoading

print("")
print("🔄 SCRIPT LOADING RECOVERY LOADED!")
print("🔄 Re-run recovery: _G.ScriptRecovery()")
print("🧪 Test loading: _G.TestScriptLoading()")
print("💡 If still not working, restart your executor")