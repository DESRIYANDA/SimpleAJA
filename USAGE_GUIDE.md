# 🎣 Fisch Auto Tools + Performance Optimizers

Complete Fisch automation suite with advanced performance optimization tools.

## 🚀 Quick Load (Main Interface)

```lua
loadstring(game:HttpGet('https://raw.githubusercontent.com/DESRIYANDA/SimpleAJA/main/main.lua'))()
```

## 🛠️ Individual Tools

### 🎯 Fishing Tools
```lua
-- Auto Appraiser (Headless)
loadstring(game:HttpGet('https://raw.githubusercontent.com/DESRIYANDA/SimpleAJA/main/auto_appraiser_headless.lua'))()

-- Auto Reel (Headless)  
loadstring(game:HttpGet('https://raw.githubusercontent.com/DESRIYANDA/SimpleAJA/main/auto_reel_headless.lua'))()
```

### 🧹 Performance & Cleanup Tools

#### 🛑 Emergency Stop (Fisch Tools Only)
```lua
loadstring(game:HttpGet('https://raw.githubusercontent.com/DESRIYANDA/SimpleAJA/main/emergency_stop.lua'))()
```

#### 🧹 Universal Cleaner (Stops ALL Scripts)
```lua
loadstring(game:HttpGet('https://raw.githubusercontent.com/DESRIYANDA/SimpleAJA/main/universal_cleaner.lua'))()
```

#### 🎯 Smart Optimizer (Preserves Useful Scripts)
```lua
loadstring(game:HttpGet('https://raw.githubusercontent.com/DESRIYANDA/SimpleAJA/main/smart_optimizer.lua'))()
```

## 🎮 Features Overview

### 🎣 **Main Interface Features:**
- **Auto Appraiser:** Automatic fish/rod appraisal with mutation filtering
- **Auto Reel Silent:** Ghost mode instant fishing with zero animations
- **Real-time Status:** Live monitoring of all modules
- **Smart Recovery:** Auto-detect and fix script issues
- **Performance Tools:** Built-in optimizer buttons

### 🧹 **Performance Optimization:**

| Tool | Purpose | What It Does | Scripts Preserved |
|------|---------|--------------|-------------------|
| **Emergency Stop** | Fisch tools only | Stops Auto Appraiser/Reel | ❌ Stops Fisch tools |
| **Universal Cleaner** | ALL scripts | Aggressive cleanup | ❌ Stops ALL scripts |
| **Smart Optimizer** | Performance boost | Removes lag sources | ✅ **Keeps useful scripts** |

### 🎯 **Smart Optimizer Benefits:**
- ✅ **Auto farms keep running**
- ✅ **Useful GUIs preserved** 
- ✅ **Tools remain functional**
- ✅ **Game performance improved**
- ✅ **Memory usage optimized**
- ✅ **Lag connections removed**

## 🔧 Manual Functions

After loading any optimizer:
```lua
-- Smart Optimizer functions
_G.SmartOptimize()         -- Run optimization again
_G.CheckActiveScripts()    -- See what scripts are still running

-- Universal Cleaner functions  
_G.UniversalCleanup()      -- Run full cleanup again
_G.UniversalCleanupConfig(aggressive, verbose, forceGC)  -- Configure settings

-- Emergency Stop function
_G.EmergencyStop()         -- Run emergency stop again
```

## 📊 Usage Recommendations

### 🟢 **For Regular Performance Boost:**
1. Use **Smart Optimizer** first
2. Keeps your useful scripts running
3. Only removes lag-causing connections

### 🟡 **For Moderate Issues:**
1. Try **Smart Optimizer** multiple times
2. Check what's still running with `_G.CheckActiveScripts()`
3. Use manual optimization functions

### 🔴 **For Severe Lag/Emergency:**
1. Use **Universal Cleaner** to stop everything
2. Wait for game to normalize
3. Reload your desired scripts

### 🛑 **For Fisch Tools Issues:**
1. Use **Emergency Stop** for Fisch-specific problems
2. Less aggressive than Universal Cleaner
3. Focused on fishing automation tools

## 🎮 Quick Access Through Main UI

The main interface (`main.lua`) includes buttons for all tools:

- **Settings Tab → Emergency Controls**
  - 🛑 Emergency Stop
  - 🧹 Universal Cleaner  
  - 🎯 Smart Optimizer

- **Settings Tab → Performance Optimization**
  - ⚡ Quick Smart Optimize
  - 🔍 Check Active Scripts

## 🔄 Auto-Recovery Features

- **Smart Recovery:** Auto-detect missing modules and reload them
- **Full Reload:** Refresh all modules from GitHub
- **Health Check:** Monitor all systems status

## 💡 Pro Tips

1. **Start with Smart Optimizer** - It's the gentlest and preserves your scripts
2. **Use main UI** for easiest access to all tools
3. **Check Active Scripts** to see what's still running after optimization
4. **Emergency tools** are available when you need them most
5. **All tools auto-load** from GitHub for latest updates

## 📦 Repository Structure

```
SimpleAJA/
├── main.lua                    # 🎮 Main interface with all tools
├── auto_appraiser_headless.lua # 🎯 Auto appraiser (background)
├── auto_reel_headless.lua      # 🤫 Auto reel silent (background)
├── emergency_stop.lua          # 🛑 Emergency stop (Fisch tools)
├── universal_cleaner.lua       # 🧹 Universal cleanup (ALL scripts)
├── smart_optimizer.lua         # 🎯 Smart optimization (preserve useful)
└── kavo.lua                   # 🎨 UI library
```

---

**🎯 One-Click Load Everything:**
```lua
loadstring(game:HttpGet('https://raw.githubusercontent.com/DESRIYANDA/SimpleAJA/main/main.lua'))()
```