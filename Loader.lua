-- // PUNK X OFFICIAL LOADER //
-- Version: 6.0 (Final Release)
-- Changes: Removed Debugger, Fixed Expiry Date, Instant UI Load

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- [1] CONFIGURATION
local KeyLogic_URL = "https://raw.githubusercontent.com/Silent-Caliber/System-Files/refs/heads/main/Auth.lua" 
local MainUI_URL   = "https://raw.githubusercontent.com/Silent-Caliber/System-Files/refs/heads/main/Main.lua"

local UI_CONFIG = {
    Title = "PUNK X",
    AccentColor = Color3.fromRGB(0, 120, 255), -- Modern Blue
    BgColor = Color3.fromRGB(20, 20, 23),      -- Deep Dark Grey
    InputColor = Color3.fromRGB(30, 30, 35),   -- Lighter Grey
    DiscordColor = Color3.fromRGB(88, 101, 242), -- Discord Blurple
    Font = Enum.Font.GothamBold,
    FontRegular = Enum.Font.GothamMedium,
    DiscordLink = "https://discord.gg/JxEjAtdgWD"
}

-- // 1. LOAD KEY LIBRARY //
local success, KeyLib = pcall(function()
    return loadstring(game:HttpGet(KeyLogic_URL))()
end)

if not success or not KeyLib then
    local err = Instance.new("ScreenGui", PlayerGui)
    local t = Instance.new("TextLabel", err)
    t.Size = UDim2.new(1,0,0.1,0)
    t.Text = "Error: Failed to load Key System."
    t.TextColor3 = Color3.new(1,0,0)
    task.wait(5)
    err:Destroy()
    return
end

-- // HELPER FUNCTIONS //

local function LaunchPunkX()
    getgenv().PUNK_X_AUTH_TOKEN = "9a2f-punk-x-8812-secure-v2-441b"
    task.spawn(function()
        loadstring(game:HttpGet(MainUI_URL))()
    end)
end

local function OnKeyVerified(data)
    local expiryDate = "Active"
    
    if data then
        -- [[ CHANGED: Prioritize the field seen in your logs ]]
        if data.Key_Information and data.Key_Information.expiresAt then
            expiryDate = data.Key_Information.expiresAt
        elseif data.keyInfo and data.keyInfo.expiresAt then
            expiryDate = data.keyInfo.expiresAt
        elseif data.expiresAt then
            expiryDate = data.expiresAt
        end
    end

    getgenv().PUNK_X_EXPIRY = expiryDate

    StarterGui:SetCore("SendNotification", {
        Title = "Punk X",
        Text = "Key Verified! Launching...",
        Duration = 3
    })
    
    LaunchPunkX()
end

-- // 2. CHECK AUTO-LOGIN //
local savedKey = KeyLib.GetSavedKey()
if savedKey then
    local valid, data = KeyLib.Validate(savedKey)
    if valid then
        OnKeyVerified(data)
        return -- Stop here
    end
end

-- // 3. BUILD UI (The "Perfecto" Aesthetic) //

if PlayerGui:FindFirstChild("PunkX_ModernUI") then
    PlayerGui["PunkX_ModernUI"]:Destroy()
end

-- Helper: Tween
local function TweenObj(obj, props, time)
    local info = TweenInfo.new(time or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(obj, info, props):Play()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PunkX_ModernUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- > Blur Effect
local Blur = Instance.new("BlurEffect", game.Lighting)
Blur.Name = "PunkX_Blur"
Blur.Size = 15

-- > Main Container
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
-- [[ CHANGED: Set full size immediately to prevent glitching ]]
MainFrame.Size = UDim2.new(0.5, 0, 0.45, 0) 
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = UI_CONFIG.BgColor
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim.new(0, 16)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(50, 50, 55)
Stroke.Thickness = 1.5
Stroke.Transparency = 1

-- > Title Header
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = UI_CONFIG.Title
Title.Font = Enum.Font.FredokaOne
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Size = UDim2.new(0.6, 0, 0.25, 0)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.05, 0, 0.05, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left

local SubTitle = Instance.new("TextLabel", MainFrame)
SubTitle.Text = "Authentication Required"
SubTitle.Font = UI_CONFIG.FontRegular
SubTitle.TextColor3 = Color3.fromRGB(150, 150, 160)
SubTitle.TextSize = 14
SubTitle.Size = UDim2.new(1, 0, 0.1, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.new(0.05, 0, 0.22, 0)
SubTitle.TextXAlignment = Enum.TextXAlignment.Left

-- > DISCORD BUTTON (TEXT BUTTON - NO LOGO BUGS)
local DiscordBtn = Instance.new("TextButton", MainFrame)
DiscordBtn.Name = "DiscordBtn"
DiscordBtn.Size = UDim2.new(0, 100, 0, 32)
DiscordBtn.Position = UDim2.new(0.94, 0, 0.08, 0)
DiscordBtn.AnchorPoint = Vector2.new(1, 0)
DiscordBtn.BackgroundColor3 = UI_CONFIG.DiscordColor
DiscordBtn.Text = "Join Discord"
DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.Font = UI_CONFIG.Font
DiscordBtn.TextSize = 12
Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 8)

-- > Input Box
local InputContainer = Instance.new("Frame", MainFrame)
InputContainer.Size = UDim2.new(0.85, 0, 0.22, 0)
InputContainer.Position = UDim2.new(0.5, 0, 0.45, 0)
InputContainer.AnchorPoint = Vector2.new(0.5, 0)
InputContainer.BackgroundColor3 = UI_CONFIG.InputColor
InputContainer.BorderSizePixel = 0
Instance.new("UICorner", InputContainer).CornerRadius = UDim.new(0, 10)

local InputStroke = Instance.new("UIStroke", InputContainer)
InputStroke.Color = UI_CONFIG.AccentColor
InputStroke.Thickness = 1
InputStroke.Transparency = 0.8

local KeyBox = Instance.new("TextBox", InputContainer)
KeyBox.Size = UDim2.new(0.9, 0, 1, 0)
KeyBox.Position = UDim2.new(0.05, 0, 0, 0)
KeyBox.BackgroundTransparency = 1
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderText = "Paste your key here..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
KeyBox.Font = UI_CONFIG.FontRegular
KeyBox.TextSize = 14
KeyBox.TextXAlignment = Enum.TextXAlignment.Left

-- > Buttons
local BtnContainer = Instance.new("Frame", MainFrame)
BtnContainer.Size = UDim2.new(0.85, 0, 0.18, 0)
BtnContainer.Position = UDim2.new(0.5, 0, 0.75, 0)
BtnContainer.AnchorPoint = Vector2.new(0.5, 0)
BtnContainer.BackgroundTransparency = 1

local GetKeyBtn = Instance.new("TextButton", BtnContainer)
GetKeyBtn.Size = UDim2.new(0.47, 0, 1, 0)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
GetKeyBtn.Text = "Get Key"
GetKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
GetKeyBtn.Font = UI_CONFIG.Font
GetKeyBtn.TextSize = 14
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 8)

local RedeemBtn = Instance.new("TextButton", BtnContainer)
RedeemBtn.Size = UDim2.new(0.47, 0, 1, 0)
RedeemBtn.Position = UDim2.new(1, 0, 0, 0)
RedeemBtn.AnchorPoint = Vector2.new(1, 0)
RedeemBtn.BackgroundColor3 = UI_CONFIG.AccentColor
RedeemBtn.Text = "Redeem"
RedeemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RedeemBtn.Font = UI_CONFIG.Font
RedeemBtn.TextSize = 14
Instance.new("UICorner", RedeemBtn).CornerRadius = UDim.new(0, 8)

-- > Status Text
local StatusText = Instance.new("TextLabel", MainFrame)
StatusText.Size = UDim2.new(1, 0, 0.1, 0)
StatusText.Position = UDim2.new(0, 0, 0.92, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Status: Waiting for key"
StatusText.TextColor3 = Color3.fromRGB(100, 100, 100)
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = 11

-- // 4. INTERACTION LOGIC //

local function AddButtonEffects(btn)
    btn.MouseEnter:Connect(function() TweenObj(btn, {BackgroundTransparency = 0.2}) end)
    btn.MouseLeave:Connect(function() TweenObj(btn, {BackgroundTransparency = 0}) end)
    btn.MouseButton1Down:Connect(function() TweenObj(btn, {Size = UDim2.new(btn.Size.X.Scale, -5, btn.Size.Y.Scale, -2)}) end)
    btn.MouseButton1Up:Connect(function() TweenObj(btn, {Size = UDim2.new(btn.Size.X.Scale, 0, btn.Size.Y.Scale, 0)}) end)
end
AddButtonEffects(GetKeyBtn)
AddButtonEffects(RedeemBtn)

DiscordBtn.MouseEnter:Connect(function() TweenObj(DiscordBtn, {BackgroundColor3 = Color3.fromRGB(114, 137, 218)}) end)
DiscordBtn.MouseLeave:Connect(function() TweenObj(DiscordBtn, {BackgroundColor3 = UI_CONFIG.DiscordColor}) end)

KeyBox.Focused:Connect(function()
    TweenObj(InputStroke, {Transparency = 0, Color = UI_CONFIG.AccentColor})
    TweenObj(InputContainer, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)})
end)
KeyBox.FocusLost:Connect(function()
    TweenObj(InputStroke, {Transparency = 0.8})
    TweenObj(InputContainer, {BackgroundColor3 = UI_CONFIG.InputColor})
end)

-- Discord Logic
DiscordBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(UI_CONFIG.DiscordLink)
        StatusText.Text = "Discord Invite Copied!"
        StatusText.TextColor3 = UI_CONFIG.DiscordColor
    else
        print("Discord:", UI_CONFIG.DiscordLink)
        StatusText.Text = "Check Console (F9)"
    end
    TweenObj(DiscordBtn, {Size = UDim2.new(0, 95, 0, 30)}, 0.1)
    task.wait(0.1)
    TweenObj(DiscordBtn, {Size = UDim2.new(0, 100, 0, 32)}, 0.1)
    task.wait(2)
    StatusText.Text = "Status: Waiting for key"
    StatusText.TextColor3 = Color3.fromRGB(100, 100, 100)
end)

-- Get Key Logic
GetKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(KeyLib.GetKeyURL())
        GetKeyBtn.Text = "Copied!"
        StatusText.Text = "Key Link copied!"
        StatusText.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        print("Key URL:", KeyLib.GetKeyURL())
        StatusText.Text = "Check Console (F9)"
    end
    task.wait(1.5)
    GetKeyBtn.Text = "Get Key"
    StatusText.Text = "Status: Waiting for key"
    StatusText.TextColor3 = Color3.fromRGB(100, 100, 100)
end)

-- Redeem Logic
RedeemBtn.MouseButton1Click:Connect(function()
    StatusText.Text = "Checking..."
    StatusText.TextColor3 = Color3.fromRGB(255, 200, 50)
    task.wait(0.5)
    
    local key = KeyBox.Text
    local valid, data = KeyLib.Validate(key)
    
    if valid then
        StatusText.Text = "Success!"
        StatusText.TextColor3 = Color3.fromRGB(50, 255, 100)
        
        -- Close UI
        TweenObj(Blur, {Size = 0}, 0.5)
        TweenObj(MainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.4)
        task.wait(0.5)
        Blur:Destroy()
        ScreenGui:Destroy()
        
        -- Launch
        OnKeyVerified(data)
    else
        StatusText.Text = "Invalid Key"
        StatusText.TextColor3 = Color3.fromRGB(255, 80, 80)
        TweenObj(InputStroke, {Transparency = 0, Color = Color3.fromRGB(255, 80, 80)})
        task.wait(1)
        TweenObj(InputStroke, {Transparency = 0.8, Color = UI_CONFIG.AccentColor})
    end
end)
