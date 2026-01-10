-- // PUNK X OFFICIAL LOADER //
-- Version: 21.1 (Final Polished & Secured)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local ContentProvider = game:GetService("ContentProvider")
local VirtualUser = game:GetService("VirtualUser") 
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- [1] CONFIGURATION
local SECRET_DEV_KEY = "PUNK-X-8B29-4F1A-9C3D-7E11" -- [[ MATCHES EXECUTOR LOGIC ]]
local KEY_FILE_NAME = "punk-x-key.txt" -- [[ MATCHES AUTH LOGIC ]]

-- URLs (Cache Busted)
local KeyLogic_URL = "https://raw.githubusercontent.com/Silent-Caliber/System-Files/main/Auth.lua?t="..tostring(os.time())
local Main_URL     = "https://raw.githubusercontent.com/Silent-Caliber/System-Files/main/Main.lua?t="..tostring(os.time())
local Beta_URL     = "https://raw.githubusercontent.com/GBMofo/System-Files/main/Beta.lua?t="..tostring(os.time())

local UI_CONFIG = {
    Title = "PUNK X",
    Version = "v21.1",
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

-- [SOUND CONFIG]
local SOUNDS = {
    Click   = 4590657391,
    Success = 4590662766,
    Error   = 550209561
}

local CURRENT_KEY = "" 

-- // SECURE PARENTING //
local function GetSecureParent()
    if gethui then return gethui()
    elseif CoreGui:FindFirstChild("RobloxGui") then return CoreGui
    else return LocalPlayer:WaitForChild("PlayerGui") end
end

-- // HELPER: BRANDED NOTIFICATION //
local function Notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 3,
        Icon = UI_CONFIG.IconImage
    })
end

-- // SOUND HELPER //
local function PlaySound(id, volume)
    task.spawn(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://" .. tostring(id)
        s.Volume = volume or 1
        s.Parent = game:GetService("SoundService")
        s.PlayOnRemove = true
        s:Destroy()
    end)
end

-- // SHAKE ANIMATION //
local function ShakeUI(guiObject)
    local originalPos = guiObject.Position
    local duration = 0.05
    local intensity = 5
    for i = 1, 6 do
        local offset = (i % 2 == 0 and -intensity or intensity)
        TweenService:Create(guiObject, TweenInfo.new(duration), {
            Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + offset, originalPos.Y.Scale, originalPos.Y.Offset)
        }):Play()
        task.wait(duration)
    end
    TweenService:Create(guiObject, TweenInfo.new(duration), {Position = originalPos}):Play()
end

Notify("Punk X", "Initializing... Checking Resources")

-- // 1. LOAD KEY LIBRARY //
local success, KeyLib = pcall(function()
    return loadstring(game:HttpGet(KeyLogic_URL))()
end)

if not success or not KeyLib then
    Notify("Punk X Error", "Connection Error. (Auth Lib)")
    return
end

-- // HELPER FUNCTIONS //

local function LaunchPunkX(passedKey, targetUrl)
    -- [[ FIXED: SAFE VARIABLE HANDOFF ]] --
    -- Checks if getgenv exists to prevent crashes on bad executors
    if getgenv then
        getgenv().PUNK_X_KEY = passedKey
    end
    -- Always set _G as a backup (Your executor checks both)
    _G.PUNK_X_KEY = passedKey 
    
    if passedKey == SECRET_DEV_KEY then 
        local env = (targetUrl == Beta_URL) and "BETA" or "STABLE"
        Notify("Punk X", "🛠️ Environment: " .. env) 
    end

    task.spawn(function()
        local success_dl, content = pcall(function() return game:HttpGet(targetUrl) end)

        if not success_dl then
            PlaySound(SOUNDS.Error)
            Notify("Punk X Error", "Cloud Sync Failed (Network Error)")
            return
        end

        local func, syntax_error = loadstring(content)
        if not func then
            PlaySound(SOUNDS.Error)
            Notify("Punk X", "Update Corrupted (Syntax Error)")
            warn("🚨 PUNK X CLOUD ERROR: " .. tostring(syntax_error))
            return
        end

        local run_success, run_err = pcall(func)
        if not run_success then
            warn("[PUNK X EXCEPTION]:", run_err)
            Notify("Punk X", "Launch Failed (Internal Error)")
        end
    end)
end

local function SetExpiryData(data)
    local expiryText = "Active"
    
    if data and type(data) == "table" then
        if data.Key_Information and data.Key_Information.expiresAt then
             expiryText = data.Key_Information.expiresAt
        elseif data.expiresAt then
             expiryText = data.expiresAt
        end
    end
    
    -- [[ SAFE HANDOFF FOR EXPIRY ]]
    if getgenv then getgenv().PUNK_X_EXPIRY = expiryText end
    _G.PUNK_X_EXPIRY = expiryText
end

-- // 3. BUILD UI //

for _, v in pairs(GetSecureParent():GetChildren()) do
    if v.Name == "PunkX_ModernUI" then v:Destroy() end
end

local function TweenObj(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PunkX_ModernUI"
ScreenGui.Parent = GetSecureParent()
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 2147483647 
ScreenGui.IgnoreGuiInset = true 

local Blur = Instance.new("BlurEffect", game.Lighting)
Blur.Name = "PunkX_Blur"
Blur.Size = 0 

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Visible = false 
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = UI_CONFIG.BgColor
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true 
MainFrame.Active = true 

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = UI_CONFIG.AccentColor 
Stroke.Thickness = 1.5
Stroke.Transparency = 1

-- Background
local BgImage = Instance.new("ImageLabel", MainFrame)
BgImage.Name = "Background"
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.BackgroundTransparency = 1
BgImage.Image = UI_CONFIG.BackgroundImage
BgImage.ScaleType = Enum.ScaleType.Crop 
BgImage.ImageColor3 = Color3.fromRGB(150, 150, 150) 
BgImage.ZIndex = 1 
Instance.new("UICorner", BgImage).CornerRadius = UDim.new(0, 16)

task.spawn(function()
    pcall(function() ContentProvider:PreloadAsync({BgImage}) end)
end)

-- UI ELEMENTS
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = UI_CONFIG.Title
Title.Font = UI_CONFIG.Font
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Size = UDim2.new(0.6, 0, 0.25, 0)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.05, 0, 0.05, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 2 

local VerLabel = Instance.new("TextLabel", MainFrame)
VerLabel.Text = UI_CONFIG.Version
VerLabel.Font = UI_CONFIG.FontRegular
VerLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
VerLabel.TextSize = 10
VerLabel.Size = UDim2.new(0, 50, 0, 20)
VerLabel.BackgroundTransparency = 1
VerLabel.Position = UDim2.new(0.95, 0, 0.95, 0)
VerLabel.AnchorPoint = Vector2.new(1, 1)
VerLabel.TextXAlignment = Enum.TextXAlignment.Right
VerLabel.ZIndex = 2

local SubTitle = Instance.new("TextLabel", MainFrame)
SubTitle.Text = "Authentication Required"
SubTitle.Font = UI_CONFIG.FontRegular
SubTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
SubTitle.TextSize = 14
SubTitle.Size = UDim2.new(1, 0, 0.1, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.new(0.05, 0, 0.22, 0)
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.ZIndex = 2

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
DiscordBtn.ZIndex = 2
Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 8)

-- INPUT GROUP
local InputContainer = Instance.new("Frame", MainFrame)
InputContainer.Size = UDim2.new(0.85, 0, 0.22, 0)
InputContainer.Position = UDim2.new(0.5, 0, 0.45, 0)
InputContainer.AnchorPoint = Vector2.new(0.5, 0)
InputContainer.BackgroundColor3 = UI_CONFIG.InputColor
InputContainer.BackgroundTransparency = 0.2 
InputContainer.BorderSizePixel = 0
InputContainer.ZIndex = 2
Instance.new("UICorner", InputContainer).CornerRadius = UDim.new(0, 10)

local InputStroke = Instance.new("UIStroke", InputContainer)
InputStroke.Color = UI_CONFIG.AccentColor
InputStroke.Thickness = 1
InputStroke.Transparency = 0.8

local KeyBox = Instance.new("TextBox", InputContainer)
KeyBox.Size = UDim2.new(0.8, 0, 1, 0)
KeyBox.Position = UDim2.new(0.05, 0, 0, 0)
KeyBox.BackgroundTransparency = 1
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderText = "Paste your key here..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
KeyBox.Font = UI_CONFIG.FontRegular
KeyBox.TextSize = 14
KeyBox.TextXAlignment = Enum.TextXAlignment.Left
KeyBox.ZIndex = 3
KeyBox.ClearTextOnFocus = false
KeyBox.Text = "" 

local PasteBtn = Instance.new("TextButton", InputContainer)
PasteBtn.Size = UDim2.new(0.15, 0, 0.8, 0)
PasteBtn.Position = UDim2.new(0.98, 0, 0.5, 0)
PasteBtn.AnchorPoint = Vector2.new(1, 0.5)
PasteBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
PasteBtn.Text = "PASTE"
PasteBtn.TextColor3 = UI_CONFIG.AccentColor
PasteBtn.Font = UI_CONFIG.Font
PasteBtn.TextSize = 9
PasteBtn.ZIndex = 4
Instance.new("UICorner", PasteBtn).CornerRadius = UDim.new(0, 6)

local BtnContainer = Instance.new("Frame", MainFrame)
BtnContainer.Size = UDim2.new(0.85, 0, 0.18, 0)
BtnContainer.Position = UDim2.new(0.5, 0, 0.75, 0)
BtnContainer.AnchorPoint = Vector2.new(0.5, 0)
BtnContainer.BackgroundTransparency = 1
BtnContainer.ZIndex = 2

local GetKeyBtn = Instance.new("TextButton", BtnContainer)
GetKeyBtn.Size = UDim2.new(0.47, 0, 1, 0)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
GetKeyBtn.Text = "Get Key"
GetKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
GetKeyBtn.Font = UI_CONFIG.Font
GetKeyBtn.TextSize = 14
GetKeyBtn.ZIndex = 3
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
RedeemBtn.ZIndex = 3
Instance.new("UICorner", RedeemBtn).CornerRadius = UDim.new(0, 8)

local StatusText = Instance.new("TextLabel", MainFrame)
StatusText.Size = UDim2.new(1, 0, 0.1, 0)
StatusText.Position = UDim2.new(0, 0, 0.92, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Status: Waiting for key"
StatusText.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = 11
StatusText.ZIndex = 2

-- [[ SELECTION MENU ]] --
local SelectionContainer = Instance.new("Frame", MainFrame)
SelectionContainer.Size = UDim2.new(0.85, 0, 0.4, 0)
SelectionContainer.Position = UDim2.new(1.5, 0, 0.45, 0) -- Hidden off screen
SelectionContainer.AnchorPoint = Vector2.new(0.5, 0)
SelectionContainer.BackgroundTransparency = 1
SelectionContainer.ZIndex = 5

local StableBtn = Instance.new("TextButton", SelectionContainer)
StableBtn.Size = UDim2.new(1, 0, 0.45, 0)
StableBtn.Position = UDim2.new(0, 0, 0, 0)
StableBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 80) -- Green
StableBtn.Text = "Load Main (Public)"
StableBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StableBtn.Font = UI_CONFIG.Font
StableBtn.TextSize = 14
Instance.new("UICorner", StableBtn).CornerRadius = UDim.new(0, 8)

local BetaBtn = Instance.new("TextButton", SelectionContainer)
BetaBtn.Size = UDim2.new(1, 0, 0.45, 0)
BetaBtn.Position = UDim2.new(0, 0, 0.55, 0)
BetaBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 40) -- Orange
BetaBtn.Text = "Load Beta (Dev)"
BetaBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BetaBtn.Font = UI_CONFIG.Font
BetaBtn.TextSize = 14
Instance.new("UICorner", BetaBtn).CornerRadius = UDim.new(0, 8)

-- // 4. ANIMATIONS //
local function OpenLoader()
    MainFrame.Visible = true
    TweenObj(Blur, {Size = 15}, 0.5)
    TweenObj(MainFrame, {Size = UDim2.new(0.5, 0, 0.45, 0)}, 0.4) 
    TweenObj(Stroke, {Transparency = 0.5}, 0.8) 
end

local function CloseLoader()
    TweenObj(Blur, {Size = 0}, 0.5)
    TweenObj(MainFrame, {Position = UDim2.new(0.5, 0, 1.5, 0)}, 0.6)
    task.wait(0.6)
    Blur:Destroy()
    ScreenGui:Destroy()
end

local function AddButtonEffects(btn)
    btn.MouseEnter:Connect(function() TweenObj(btn, {BackgroundTransparency = 0.2}) end)
    btn.MouseLeave:Connect(function() TweenObj(btn, {BackgroundTransparency = 0}) end)
    btn.MouseButton1Down:Connect(function() TweenObj(btn, {Size = UDim2.new(btn.Size.X.Scale, -5, btn.Size.Y.Scale, -2)}) end)
    btn.MouseButton1Up:Connect(function() TweenObj(btn, {Size = UDim2.new(btn.Size.X.Scale, 0, btn.Size.Y.Scale, 0)}) end)
end
AddButtonEffects(GetKeyBtn)
AddButtonEffects(RedeemBtn)
AddButtonEffects(PasteBtn)
AddButtonEffects(DiscordBtn)
AddButtonEffects(StableBtn)
AddButtonEffects(BetaBtn)

KeyBox.Focused:Connect(function()
    TweenObj(InputStroke, {Transparency = 0, Color = UI_CONFIG.AccentColor})
    TweenObj(InputContainer, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)})
end)
KeyBox.FocusLost:Connect(function()
    TweenObj(InputStroke, {Transparency = 0.8})
    TweenObj(InputContainer, {BackgroundColor3 = UI_CONFIG.InputColor})
end)

-- // DRAGGABLE //
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
end
MakeDraggable(MainFrame)

-- // FUNCTIONS //

-- [[ LOGIC: Show appropriate buttons based on user type ]]
local function ShowLauncherMenu(isDev)
    SubTitle.Text = "Select Environment"
    
    -- Hide Key Input System
    TweenObj(InputContainer, {Position = UDim2.new(-0.5, 0, 0.45, 0)}, 0.5)
    TweenObj(BtnContainer, {Position = UDim2.new(-0.5, 0, 0.75, 0)}, 0.5)
    
    -- Configure Selection Menu based on Key Type
    if isDev then
        -- Developer: Show Both Buttons
        BetaBtn.Visible = true
        StableBtn.Size = UDim2.new(1, 0, 0.45, 0)
        StableBtn.Position = UDim2.new(0, 0, 0, 0)
    else
        -- Normal User: Hide Beta, Center Stable Button
        BetaBtn.Visible = false
        StableBtn.Size = UDim2.new(1, 0, 0.6, 0) -- Bigger, centered button
        StableBtn.Position = UDim2.new(0, 0, 0.2, 0)
    end
    
    -- Bring in Selection Menu
    TweenObj(SelectionContainer, {Position = UDim2.new(0.5, 0, 0.45, 0)}, 0.5)
end

-- Button Logic
PasteBtn.MouseButton1Click:Connect(function()
    if getclipboard then
        local clip = getclipboard()
        if clip and clip ~= "" then
            KeyBox.Text = clip
            KeyBox:ReleaseFocus() 
            PlaySound(SOUNDS.Click)
        else
            StatusText.Text = "Clipboard Empty!"
            StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
            PlaySound(SOUNDS.Error)
            ShakeUI(InputContainer)
        end
    else
        StatusText.Text = "Not Supported!"
        PlaySound(SOUNDS.Error)
    end
end)

DiscordBtn.MouseButton1Click:Connect(function()
    PlaySound(SOUNDS.Click) 
    if setclipboard then
        setclipboard(UI_CONFIG.DiscordLink)
        Notify("Punk X", "Discord Invite Copied!", 3)
    else
        print("Discord:", UI_CONFIG.DiscordLink)
    end
end)

GetKeyBtn.MouseButton1Click:Connect(function()
    PlaySound(SOUNDS.Click)
    if setclipboard then
        setclipboard(KeyLib.GetKeyURL())
        GetKeyBtn.Text = "Copied!"
        Notify("Punk X", "Key Link Copied!", 3)
    else
        print("Key URL:", KeyLib.GetKeyURL())
    end
    task.wait(1.5)
    GetKeyBtn.Text = "Get Key"
end)

StableBtn.MouseButton1Click:Connect(function()
    PlaySound(SOUNDS.Success)
    CloseLoader()
    -- Launch using the key validation (Dev or Public)
    LaunchPunkX(CURRENT_KEY, Main_URL)
end)

BetaBtn.MouseButton1Click:Connect(function()
    PlaySound(SOUNDS.Success)
    CloseLoader()
    LaunchPunkX(SECRET_DEV_KEY, Beta_URL)
end)

local isChecking = false
RedeemBtn.MouseButton1Click:Connect(function()
    if isChecking then return end
    isChecking = true
    
    StatusText.Text = "Checking..."
    StatusText.TextColor3 = Color3.fromRGB(255, 200, 50)
    
    local key = KeyBox.Text:gsub("%s+", "") 
    
    -- [DEV BYPASS]
    if key == SECRET_DEV_KEY then
        PlaySound(SOUNDS.Success)
        StatusText.Text = "Developer Mode"
        StatusText.TextColor3 = Color3.fromRGB(0, 200, 255)
        
        -- Manual save for Dev Key
        if writefile then pcall(function() writefile(KEY_FILE_NAME, key) end) end
        
        CURRENT_KEY = key
        ShowLauncherMenu(true) -- True = Dev Menu (Show Beta)
        return 
    end

    -- [NORMAL USERS]
    -- Safe call to prevent freezing if Panda is down
    local success, valid, data = pcall(function() return KeyLib.Validate(key) end)
    
    if success and valid then
        PlaySound(SOUNDS.Success)
        StatusText.Text = "Success!"
        StatusText.TextColor3 = Color3.fromRGB(50, 255, 100)
        
        SetExpiryData(data)
        Notify("Punk X", "Access Granted!", 2)
        
        CURRENT_KEY = key
        ShowLauncherMenu(false) -- False = Public Menu (Hide Beta)
    else
        PlaySound(SOUNDS.Error)
        StatusText.Text = (success and "Invalid Key" or "Connection Error")
        StatusText.TextColor3 = Color3.fromRGB(255, 80, 80)
        KeyBox.Text = "" 
        ShakeUI(InputContainer) 
        isChecking = false
        RedeemBtn.Text = "Redeem"
    end
end)

-- // 6. AUTO-LOGIN CHECK //
local autoLogged = false
local saved = KeyLib.GetSavedKey()

if saved then
    if saved == SECRET_DEV_KEY then
        OpenLoader() -- Must open to show dev menu
        KeyBox.Text = saved
        CURRENT_KEY = saved
        ShowLauncherMenu(true)
        autoLogged = true
    else
        local success, valid, data = pcall(function() return KeyLib.Validate(saved) end)
        if success and valid then 
            OpenLoader() -- Show Loader
            KeyBox.Text = saved
            SetExpiryData(data)
            CURRENT_KEY = saved
            ShowLauncherMenu(false) -- Show Public Menu
            autoLogged = true
        end
    end
end

-- Only Show Loader if Auto-Login Failed/Skipped
if not autoLogged then
    OpenLoader()
end

-- // 7. ANTI-AFK //
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
