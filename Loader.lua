-- // PUNK X OFFICIAL LOADER //
-- Version: 16.5 (Global Variable Backup Fix)

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser") 
local LocalPlayer = Players.LocalPlayer

-- [1] CONFIGURATION
local KeyLogic_URL = "https://raw.githubusercontent.com/Silent-Caliber/System-Files/main/Auth.lua?t="..tostring(os.time())
local MainUI_URL   = "https://raw.githubusercontent.com/Silent-Caliber/System-Files/main/Main.lua?t="..tostring(os.time())

local UI_CONFIG = {
    Title = "PUNK X",
    AccentColor = Color3.fromRGB(0, 120, 255),
    BgColor = Color3.fromRGB(20, 20, 23),
    InputColor = Color3.fromRGB(30, 30, 35),
    DiscordColor = Color3.fromRGB(88, 101, 242),
    Font = Enum.Font.GothamBold,
    FontRegular = Enum.Font.GothamMedium,
    DiscordLink = "https://discord.gg/JxEjAtdgWD",
    BackgroundImage = "rbxthumb://type=Asset&id=83372655709716&w=768&h=432",
    IconImage = "rbxthumb://type=Asset&id=128877949924034&w=150&h=150"
}

-- // SOUNDS //
local SOUNDS = { Click = 4590657391, Success = 4590662766, Error = 550209561 }

-- // HELPER FUNCTIONS //
local function GetSecureParent()
    if gethui then return gethui()
    elseif CoreGui:FindFirstChild("RobloxGui") then return CoreGui
    else return LocalPlayer:WaitForChild("PlayerGui") end
end

local function Notify(title, text)
    StarterGui:SetCore("SendNotification", {
        Title = title, Text = text, Duration = 5, Icon = UI_CONFIG.IconImage
    })
end

local function PlaySound(id)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. tostring(id)
    s.Parent = game:GetService("SoundService")
    s.PlayOnRemove = true
    s:Destroy()
end

Notify("Punk X", "Initializing...")

-- // LOAD KEY LIB //
local success, KeyLib = pcall(function() return loadstring(game:HttpGet(KeyLogic_URL))() end)
if not success or not KeyLib then Notify("Punk X Error", "Auth Lib Failed") return end

-- // LAUNCHER FUNCTION //
local function LaunchPunkX(passedKey)
    -- [CRITICAL FIX] Save Key to BOTH environments
    getgenv().PUNK_X_KEY = passedKey
    _G.PUNK_X_KEY = passedKey 
    
    print("Loader: Key Saved ->", passedKey) -- Console Debug

    task.spawn(function()
        local load_success, load_result = pcall(function()
            return loadstring(game:HttpGet(MainUI_URL))()
        end)
        if not load_success then
            PlaySound(SOUNDS.Error)
            Notify("Punk X Error", "Main UI Failed to Load!")
            warn(load_result)
        end
    end)
end

-- // KEY VERIFICATION //
local function OnKeyVerified(data, keyUsed)
    getgenv().PUNK_X_EXPIRY = (data and data.Key_Information and data.Key_Information.expiresAt) or "Active"
    Notify("Punk X", "Access Granted! Loading...", 3)
    LaunchPunkX(keyUsed)
end

-- // UI BUILD & LOGIC (Condensed for stability) //
local savedKey = KeyLib.GetSavedKey()
if savedKey then
    local valid, data = KeyLib.Validate(savedKey)
    if valid then OnKeyVerified(data, savedKey) return end
end

-- [GUI CREATION START]
for _, v in pairs(GetSecureParent():GetChildren()) do if v.Name == "PunkX_ModernUI" then v:Destroy() end end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PunkX_ModernUI"
ScreenGui.Parent = GetSecureParent()
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 250)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = UI_CONFIG.BgColor
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

-- Drag Logic
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
MainFrame.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = UI_CONFIG.Title; Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0.2, 0); Title.Font = UI_CONFIG.Font; Title.TextSize = 24

local KeyBox = Instance.new("TextBox", MainFrame)
KeyBox.Size = UDim2.new(0.8, 0, 0.2, 0); KeyBox.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyBox.BackgroundColor3 = UI_CONFIG.InputColor; KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.PlaceholderText = "Paste Key Here"; KeyBox.Font = UI_CONFIG.FontRegular; KeyBox.TextSize = 14
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

local RedeemBtn = Instance.new("TextButton", MainFrame)
RedeemBtn.Size = UDim2.new(0.4, 0, 0.15, 0); RedeemBtn.Position = UDim2.new(0.5, 0, 0.65, 0)
RedeemBtn.AnchorPoint = Vector2.new(0.5, 0); RedeemBtn.BackgroundColor3 = UI_CONFIG.AccentColor
RedeemBtn.Text = "Redeem"; RedeemBtn.TextColor3 = Color3.new(1,1,1); RedeemBtn.Font = UI_CONFIG.Font
Instance.new("UICorner", RedeemBtn).CornerRadius = UDim.new(0, 8)

local GetKeyBtn = Instance.new("TextButton", MainFrame)
GetKeyBtn.Size = UDim2.new(0.4, 0, 0.15, 0); GetKeyBtn.Position = UDim2.new(0.5, 0, 0.82, 0)
GetKeyBtn.AnchorPoint = Vector2.new(0.5, 0); GetKeyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
GetKeyBtn.Text = "Get Key"; GetKeyBtn.TextColor3 = Color3.new(0.8,0.8,0.8); GetKeyBtn.Font = UI_CONFIG.Font
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 8)

GetKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(KeyLib.GetKeyURL()) Notify("Punk X", "Key Link Copied!") end
end)

local isChecking = false
RedeemBtn.MouseButton1Click:Connect(function()
    if isChecking then return end
    isChecking = true
    RedeemBtn.Text = "Checking..."
    
    local key = KeyBox.Text:gsub("%s+", "")
    local valid, data = KeyLib.Validate(key)
    
    if valid then
        PlaySound(SOUNDS.Success)
        ScreenGui:Destroy()
        OnKeyVerified(data, key)
    else
        PlaySound(SOUNDS.Error)
        RedeemBtn.Text = "Invalid Key"
        task.wait(1)
        RedeemBtn.Text = "Redeem"
        isChecking = false
    end
end)

-- Anti AFK
LocalPlayer.Idled:Connect(function() VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new()) end)
