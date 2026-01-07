-- // PUNK X OFFICIAL LOADER //
-- Version: 17.0 (Dev Menu Selector)

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- [1] CONFIGURATION
local SECRET_DEV_KEY = "PUNK-X-8B29-4F1A-9C3D-7E11"

-- URLs
local KeyLogic_URL = "https://raw.githubusercontent.com/Silent-Caliber/System-Files/main/Auth.lua?t="..tostring(os.time())
local Public_URL   = "https://raw.githubusercontent.com/Silent-Caliber/System-Files/main/Main.lua"
local Dev_URL      = "https://raw.githubusercontent.com/Silent-Caliber/System-Files/main/Main_Dev.lua?t="..tostring(os.time())

local UI_CONFIG = {
    Title = "PUNK X",
    AccentColor = Color3.fromRGB(0, 120, 255),
    BgColor = Color3.fromRGB(20, 20, 23),
    InputColor = Color3.fromRGB(30, 30, 35),
    IconImage = "rbxthumb://type=Asset&id=128877949924034&w=150&h=150",
    Font = Enum.Font.GothamBold
}

local SOUNDS = { Click = 4590657391, Success = 4590662766, Error = 550209561 }

-- // HELPERS //
local function GetSecureParent()
    if gethui then return gethui()
    elseif CoreGui:FindFirstChild("RobloxGui") then return CoreGui
    else return LocalPlayer:WaitForChild("PlayerGui") end
end

local function Notify(title, text)
    StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 5, Icon = UI_CONFIG.IconImage})
end

local function PlaySound(id)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. tostring(id)
    s.Parent = game:GetService("SoundService")
    s.PlayOnRemove = true
    s:Destroy()
end

-- // LOAD AUTH //
local success, KeyLib = pcall(function() return loadstring(game:HttpGet(KeyLogic_URL))() end)
if not success or not KeyLib then Notify("Punk X Error", "Auth Lib Failed") return end

-- // LAUNCHER //
local function LaunchPunkX(passedKey, targetUrl)
    getgenv().PUNK_X_KEY = passedKey
    _G.PUNK_X_KEY = passedKey 
    
    if passedKey == SECRET_DEV_KEY then Notify("Punk X", "🛠️ Dev Access Granted") end

    task.spawn(function()
        local load_success, load_result = pcall(function()
            return loadstring(game:HttpGet(targetUrl))()
        end)
        if not load_success then
            PlaySound(SOUNDS.Error)
            Notify("Punk X Error", "Script Failed to Load!")
            warn(load_result)
        end
    end)
end

-- // UI CONSTRUCTION //
for _, v in pairs(GetSecureParent():GetChildren()) do if v.Name == "PunkX_Loader" then v:Destroy() end end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PunkX_Loader"
ScreenGui.Parent = GetSecureParent()
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 250)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = UI_CONFIG.BgColor
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = UI_CONFIG.Title; Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0.2, 0); Title.Font = UI_CONFIG.Font; Title.TextSize = 24

-- [[ CONTAINER 1: KEY INPUT ]] --
local InputContainer = Instance.new("Frame", MainFrame)
InputContainer.Size = UDim2.new(1, 0, 0.8, 0)
InputContainer.Position = UDim2.new(0, 0, 0.2, 0)
InputContainer.BackgroundTransparency = 1

local KeyBox = Instance.new("TextBox", InputContainer)
KeyBox.Size = UDim2.new(0.8, 0, 0.25, 0); KeyBox.Position = UDim2.new(0.1, 0, 0.2, 0)
KeyBox.BackgroundColor3 = UI_CONFIG.InputColor; KeyBox.TextColor3 = Color3.new(1,1,1)
... (134 lines left)
Collapse
loader finale with dev.lua
10 KB
Owner/Founder

 — 4:04 PM
-- [PART 2: KEY VALIDATION LOGIC]
Owner/Founder

 — 4:24 PM
-- [PART 2: KEY VALIDATION LOGIC]
    do
        print("[PUNK X] Script Loaded. Checking for Key...")
        
        -- CRITICAL: Wait a moment for variables to transfer from Loader
        task.wait(0.5)

        -- Check both Global environments
        local key = getgenv().PUNK_X_KEY or _G.PUNK_X_KEY
        
        -- Debug Print
        if key then print("[PUNK X] Key Found: " .. tostring(key)) else print("[PUNK X] No Key Found in globals.") end

        local success, KeyLib = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/GBMofo/System-Files/main/Auth.lua"))()
        end)

        if not success or not KeyLib then
            warn("[PUNK X] Auth Lib Failed.")
            if script.Parent then script.Parent:Destroy() end
            return
        end

        -- 3. Validate Key (Dev Bypass + Normal)
        if key then
            -- [[ 👇 NEW DEV BYPASS START 👇 ]] --
            if key == "PUNK-X-8B29-4F1A-9C3D-7E11" then
                print("[PUNK X] 🛠️ Dev Override Accepted")
                KeyVailded = true 
                
                -- Clear keys for security
                getgenv().PUNK_X_KEY = nil
                _G.PUNK_X_KEY = nil
                
                loadUI() -- Load the Executor immediately
                
            else
                -- [[ 👇 STANDARD USER VALIDATION 👇 ]] --
                local valid, data = KeyLib.Validate(key)
                if valid then
                    print("[PUNK X] Access Granted.")
                    KeyVailded = true 
                    
                    -- Clear keys for security
                    getgenv().PUNK_X_KEY = nil
                    _G.PUNK_X_KEY = nil
                    
                    loadUI() 
                    
                    -- Update Expiry Date if available
                    if getgenv().PUNK_X_EXPIRY then
                        task.spawn(function()
                            task.wait(1)
                            if Pages and Pages:FindFirstChild("Home") and Pages.Home:FindFirstChild("Key") then
                                Pages.Home.Key.KeyText.Text = 'Keys Active'
                                Pages.Home.Key.Duration.Text = getgenv().PUNK_X_EXPIRY
                            end
                            getgenv().PUNK_X_EXPIRY = nil
                        end)
                    end
                else
                    warn("[PUNK X] Invalid Key.")
                    if script.Parent then script.Parent:Destroy() end
                end
            end
            -- [[ 👆 NEW DEV BYPASS END 👆 ]] --
        else
            warn("⛔ No key provided! Use the Loader.")
            -- Only destroy if not in Studio (for debugging)
            if not game:GetService("RunService"):IsStudio() then
                if script.Parent then script.Parent:Destroy() end
            end
        end
    end
