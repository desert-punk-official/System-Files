-- // PUNK X OFFICIAL LOADER //
-- Version: 22.2 (Strict Stealth / BAC-7205 + 82010 Fixed)
-- Deployment stamp.  Every deployed file prints this tag, so one log
-- line answers "is the file I uploaded the file that ran?".
print("[PunkX] release 2026-11-19r loader")

-- ⚠️ CRITICAL: Wait for game to fully load
-- No pre-build wait.  on_game_loaded already means the game is loaded,
-- and every task.wait here costs a full scheduler round-trip: on this
-- build a resumed continuation can take seconds, so the old 8 x 0.25 s
-- landscape poll turned into 15-35 seconds with no window on screen
-- (device 2026-11-20: 33 s between `release ... loader` and the Auth
-- fetch in the portrait game, 15 s in Blox Fruits).  The window adapts
-- its own geometry, so build it immediately.

-- ==========================================
-- 🛡️ FIX #1: SILENT CONSOLE
-- ==========================================
--local _original_print = print
--local _original_warn = warn
--print = function(...) end
--warn = function(...) end

--if getgenv then
   -- getgenv()._debug_print = _original_print
  --  getgenv()._debug_warn = _original_warn
--end

-- ✅ ADD THESE 2 LINES: Store for console to use
--_G._original_print = _original_print
--_G._original_warn = _original_warn
-- ==========================================

-- ==========================================
-- 🛡️ FIX #2: CLONEREF SERVICES
-- ==========================================
local cloneref = cloneref or function(obj) return obj end

local Players = cloneref(game:GetService("Players"))
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local LocalPlayer = Players.LocalPlayer
-- ==========================================

-- [1] CONFIGURATION
local SECRET_DEV_KEY = "PUNK-X-8B29-4F1A-9C3D-7E11" 
local KEY_FILE_NAME = "Punk-X-Files/punk-x-key.txt"
local ENV_FILE_NAME = "Punk-X-Files/punk-x-env.txt"

-- URLs
local KeyLogic_URL = "https://raw.githubusercontent.com/Silent-Caliber/System-Files/main/Auth.lua?t="..tostring(os.time())
local Main_URL     = "https://raw.githubusercontent.com/Silent-Caliber/System-Files/main/Main.lua?t="..tostring(os.time())
local New_URL      = "https://raw.githubusercontent.com/Silent-Caliber/System-Files/refs/heads/main/New.lua?t="..tostring(os.time())
local Beta_URL     = "https://raw.githubusercontent.com/GBMofo/System-Files/main/Beta.lua?t="..tostring(os.time())

local UI_CONFIG = {
    Title = "PUNK X",
    Version = "v22.2",
    AccentColor = Color3.fromRGB(0, 120, 255),
    BgColor = Color3.fromRGB(20, 20, 23),
    InputColor = Color3.fromRGB(30, 30, 35),
    DiscordColor = Color3.fromRGB(88, 101, 242),
    Font = Enum.Font.GothamBold,
    FontRegular = Enum.Font.GothamMedium,
    DiscordLink = "https://discord.gg/JxEjAtdgWD",
    BackgroundImage = "rbxthumb://type=Asset&id=83372655709716&w=768&h=432"
}

local SOUNDS = { Click = 4590657391, Success = 4590662766, Error = 550209561 }
local CURRENT_KEY = "" 
-- 🛡️ RANDOMIZE NAME: Prevents name-based detection
local GUI_RANDOM_NAME = "Px_" .. tostring(math.random(10000, 99999)) 

-- // SECURE PARENTING //
local function GetSecureParent()
    -- 🛡️ FIX: Prefer gethui() to hide from CoreGui scans
    if gethui then return gethui() end
    if syn and syn.protect_gui then 
        local gui = Instance.new("ScreenGui")
        syn.protect_gui(gui)
        gui.Parent = CoreGui
        return gui
    end
    return CoreGui
end

-- // 🛡️ CUSTOM NOTIFICATION (Stealth Mode) //
-- Replaces StarterGui:SetCore to avoid BAC-82010
local function Notify(title, text, duration)
    task.spawn(function()
        local parent = GetSecureParent()
        local gui = parent:FindFirstChild(GUI_RANDOM_NAME)
        if not gui then return end
        
        local notifFrame = Instance.new("Frame")
        notifFrame.Name = "N_" ..  tostring(math.random(1,1000))
        notifFrame.Size = UDim2.new(0, 250, 0, 60)
        notifFrame.Position = UDim2.new(1, 20, 0.85, 0)
        notifFrame.BackgroundColor3 = UI_CONFIG.BgColor
        notifFrame.BorderSizePixel = 0
        notifFrame.Parent = gui
        
        local uic = Instance.new("UICorner", notifFrame)
        uic.CornerRadius = UDim.new(0, 8)
        
        local stroke = Instance.new("UIStroke", notifFrame)
        stroke.Color = UI_CONFIG.AccentColor
        stroke.Thickness = 1.5
        
        local tLabel = Instance.new("TextLabel", notifFrame)
        tLabel.Text = title
        tLabel.Font = UI_CONFIG.Font
        tLabel.TextColor3 = UI_CONFIG.AccentColor
        tLabel.TextSize = 14
        tLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
        tLabel.Size = UDim2.new(0.9, 0, 0.3, 0)
        tLabel.BackgroundTransparency = 1
        tLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local mLabel = Instance.new("TextLabel", notifFrame)
        mLabel.Text = text
        mLabel.Font = UI_CONFIG.FontRegular
        mLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        mLabel.TextSize = 12
        mLabel.Position = UDim2.new(0.05, 0, 0.45, 0)
        mLabel.Size = UDim2.new(0.9, 0, 0.45, 0)
        mLabel.BackgroundTransparency = 1
        mLabel.TextXAlignment = Enum.TextXAlignment.Left
        mLabel.TextWrapped = true

        TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -270, 0.85, 0)
        }):Play()
        
        task.wait(duration or 3)
        
        local outTween = TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, 0.85, 0)
        })
        outTween:Play()
        outTween.Completed:Wait()
        notifFrame:Destroy()
    end)
end

-- // SOUND HELPER //
local function PlaySound(id, volume)
    task.spawn(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://" .. tostring(id)
        s.Volume = volume or 1
        s.Parent = cloneref(game:GetService("SoundService"))
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

-- [[ ✅ ENSURE FOLDER EXISTS ]] --
if isfolder and not isfolder("Punk-X-Files") then
    makefolder("Punk-X-Files")
end

-- // 1. LOAD KEY LIBRARY //
local success, KeyLib = false, nil
local authLoaded = false

task.spawn(function()
    local ok, result = pcall(function()
        return loadstring(game:HttpGet(KeyLogic_URL))()
    end)
    if ok and result then
        success, KeyLib = true, result
    end
    authLoaded = true
end)

local waited = 0
while not authLoaded and waited < 15 do
    task.wait(0.5)
    waited = waited + 0.5
end

if not success or not KeyLib then
    warn("[PUNK X] Auth library failed to load; the key window cannot start. "
        .. "See the HttpGet / loadstring error above.")
    return
end

-- Hand the loaded library to the UI.  Without this the UI downloaded and
-- loaded a second copy of Auth.lua on the game thread, and when that copy
-- came back empty the UI destroyed its own ScreenGui ("Auth Lib Failed."
-- and a window that appears for a frame and vanishes).
if getgenv then getgenv().PUNK_X_AUTH = KeyLib end
_G.PUNK_X_AUTH = KeyLib

-- // HELPER FUNCTIONS //

local function LaunchPunkX(passedKey, targetUrl)
    -- Unlock the executor for this session.  The loader only reaches here
    -- after Panda auth accepted a key (or the dev key), so this is the one
    -- moment autoexec may start running.  __punk_authorize is native; if it
    -- is missing the call is skipped rather than erroring.
    if __punk_authorize then pcall(__punk_authorize) end
    if getgenv then getgenv().PUNK_X_KEY = passedKey end
    _G.PUNK_X_KEY = passedKey 
    
    Notify("Punk X", "Launching Script...") 

    task.spawn(function()
        local content = nil
        local downloadDone = false
        
        task.spawn(function()
            local success_dl, result = pcall(function() return game:HttpGet(targetUrl) end)
            if success_dl then
                task.wait(0.05)
                content = result
                task.wait(0.05)
            end
            downloadDone = true
        end)
        
        local waited = 0
        while not downloadDone and waited < 60 do
            task.wait(0.5)
            waited = waited + 0.5
        end
        
        if not content then
            warn("[PUNK X] UI download failed for " .. tostring(targetUrl))
            PlaySound(SOUNDS.Error)
            Notify("Punk X Error", "Download failed.")
            return
        end
        
        local func, syntax_error = loadstring(content)
        if not func then
            warn("[PUNK X] UI syntax error: " .. tostring(syntax_error))
            Notify("Punk X", "Syntax Error in Script")
            return
        end
        
        local run_success, run_err = pcall(func)
        if not run_success then
            warn("[PUNK X] UI execution failed: " .. tostring(run_err))
            Notify("Punk X", "Execution Failed")
        end
    end)
end

local function SetExpiryData(data)
    local expiryText = "Active"
    local isPremium = false
    
    if data and type(data) == "table" then
        if data.expireDate then expiryText = data.expireDate end
        if data.isPremium then isPremium = data.isPremium end
        if data.Key_Information and data.Key_Information.expiresAt then expiryText = data.Key_Information.expiresAt end
    end
    
    if getgenv then 
        getgenv().PUNK_X_EXPIRY = expiryText
        getgenv().PUNK_X_PREMIUM = isPremium 
    end
    _G.PUNK_X_EXPIRY = expiryText
    _G.PUNK_X_PREMIUM = isPremium 
    
    if isPremium then
        Notify("Punk X", "🌟 Premium Active!")
    end
end

local function SaveEnvironmentPreference(envType)
    if writefile then
        pcall(function() writefile(ENV_FILE_NAME, envType) end)
    end
end

-- // 3. BUILD UI //

-- Cleanup old
local parent = GetSecureParent()
-- Milestone: if the key window never appears, this line says where it was
-- meant to go.  A GUI parented to a container that does not render is the
-- failure mode that produces no error anywhere (build d249221 parented to
-- CoreGui and drew nothing).
print("[PunkX] loader: key window parent = "
    .. tostring(parent and parent:GetFullName()))
for _, v in pairs(parent:GetChildren()) do
    -- Name matching alone missed the executor UI: its ScreenGui is named
    -- with a random hex string, so after a rejoin or a place change the
    -- previous UI stayed on screen and the next one stacked on top.  The
    -- attribute travels with the instance, so it survives the VM rebuild
    -- that clears getgenv().
    local owned = false
    pcall(function() owned = v:GetAttribute("PunkX") ~= nil end)
    if owned or v.Name:match("Px_") or v.Name == "PunkX_ModernUI" then
        v:Destroy()
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GUI_RANDOM_NAME -- Randomized Name
-- Properties first, parent last.  Roblox's respawn reset only spares a
-- ScreenGui whose ResetOnSpawn is already false when it enters PlayerGui,
-- and a window created a few milliseconds before the character spawns is
-- otherwise cleared without a trace (the "no UI at all" report).
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
-- Ask the engine for landscape while this container is visible.  In the
-- failing games the window surface is already landscape while the
-- engine's GUI space is portrait; this is the one orientation lever a
-- script owns, and it is applied to our own ScreenGui only - never to
-- the game's, which would fight the game's own layout.
pcall(function()
    ScreenGui.ScreenOrientation = Enum.ScreenOrientation.LandscapeSensor
end)
ScreenGui.Enabled = true
-- Above the game's own ScreenGuis: a full-screen loading/menu GUI at a
-- higher DisplayOrder would otherwise draw on top of the window, which
-- looks identical to the window not existing.  DisplayOrder only orders
-- PlayerGui layers; the CoreGui topbar is a separate layer.
ScreenGui.DisplayOrder = 999999
ScreenGui.Parent = parent
print("[PunkX] loader: key window attached under "
    .. tostring(ScreenGui.Parent and ScreenGui.Parent:GetFullName()))
-- Ownership marker the next session can see even though getgenv() is
-- rebuilt with the VM.
pcall(function() ScreenGui:SetAttribute("PunkX", "loader") end)

-- ⚠️ REMOVED BLUR EFFECT (BAC-7205/82010 Fix) ⚠️
-- Do not add Instance.new("BlurEffect") anywhere

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
SelectionContainer.Size = UDim2.new(0.85, 0, 0.5, 0) 
SelectionContainer.Position = UDim2.new(1.5, 0, 0.38, 0) 
SelectionContainer.AnchorPoint = Vector2.new(0.5, 0)
SelectionContainer.BackgroundTransparency = 1
SelectionContainer.ZIndex = 5

local OldUIBtn = Instance.new("TextButton", SelectionContainer)
OldUIBtn.Name = "OldUIBtn"
OldUIBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 80) -- Green
OldUIBtn.Text = "Load Old UI"
OldUIBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OldUIBtn.Font = UI_CONFIG.Font
OldUIBtn.TextSize = 14
Instance.new("UICorner", OldUIBtn).CornerRadius = UDim.new(0, 8)

local NewUIBtn = Instance.new("TextButton", SelectionContainer)
NewUIBtn.Name = "NewUIBtn"
NewUIBtn.BackgroundColor3 = Color3.fromRGB(80, 140, 255) -- Blue
NewUIBtn.Text = "Load New UI"
NewUIBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NewUIBtn.Font = UI_CONFIG.Font
NewUIBtn.TextSize = 14
Instance.new("UICorner", NewUIBtn).CornerRadius = UDim.new(0, 8)

local BetaBtn = Instance.new("TextButton", SelectionContainer)
BetaBtn.Name = "BetaBtn"
BetaBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 40) -- Orange
BetaBtn.Text = "Load Beta (Dev)"
BetaBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BetaBtn.Font = UI_CONFIG.Font
BetaBtn.TextSize = 14
Instance.new("UICorner", BetaBtn).CornerRadius = UDim.new(0, 8)

-- // 4. ANIMATIONS //
local function TweenObj(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local function OpenLoader()
    ScreenGui.Enabled = true
    print("[PunkX] loader: OpenLoader ran")
    Notify("Punk X", "Welcome Back!")
    MainFrame.Visible = true
    -- REMOVED BLUR TWEEN
    -- Apply the size first: on device the tween alone left the window at
    -- UDim2.new(0,0,0,0) for the whole session (probe: ScreenGui 335x834,
    -- MainFrame absSize 0,0), i.e. an enabled, visible, 0x0 window.
    MainFrame.Size = UDim2.new(0.5, 0, 0.45, 0)
    pcall(function() TweenObj(MainFrame, {Size = UDim2.new(0.5, 0, 0.45, 0)}, 0.4) end) 
    TweenObj(Stroke, {Transparency = 0.5}, 0.8) 
end

local function CloseLoader()
    -- REMOVED BLUR TWEEN
    TweenObj(MainFrame, {Position = UDim2.new(0.5, 0, 1.5, 0)}, 0.6)
    task.wait(0.6)
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
AddButtonEffects(OldUIBtn)
AddButtonEffects(NewUIBtn)
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

-- // LOGIC //
local function ShowLauncherMenu(isDev)
    SubTitle.Text = "Select Environment"
    StatusText.Text = "Status: Ready to Launch"
    StatusText.TextColor3 = Color3.fromRGB(50, 255, 100)
    
    TweenObj(InputContainer, {Position = UDim2.new(-0.5, 0, 0.45, 0)}, 0.5)
    TweenObj(BtnContainer, {Position = UDim2.new(-0.5, 0, 0.75, 0)}, 0.5)
    
    if isDev then
        BetaBtn.Visible = true
        NewUIBtn.Visible = true
        OldUIBtn.Visible = true
        
        OldUIBtn.Size = UDim2.new(1, 0, 0.28, 0)
        OldUIBtn.Position = UDim2.new(0, 0, 0, 0)
        NewUIBtn.Size = UDim2.new(1, 0, 0.28, 0)
        NewUIBtn.Position = UDim2.new(0, 0, 0.36, 0)
        BetaBtn.Size = UDim2.new(1, 0, 0.28, 0)
        BetaBtn.Position = UDim2.new(0, 0, 0.72, 0)
    else
        BetaBtn.Visible = false
        NewUIBtn.Visible = true
        OldUIBtn.Visible = true
        
        OldUIBtn.Size = UDim2.new(1, 0, 0.40, 0)
        OldUIBtn.Position = UDim2.new(0, 0, 0.05, 0)
        NewUIBtn.Size = UDim2.new(1, 0, 0.40, 0)
        NewUIBtn.Position = UDim2.new(0, 0, 0.55, 0)
    end
    
    TweenObj(SelectionContainer, {Position = UDim2.new(0.5, 0, 0.38, 0)}, 0.5) 
end

PasteBtn.MouseButton1Click:Connect(function()
    if getclipboard then
        local clip = getclipboard()
        if clip and clip ~= "" then
            clip = clip:gsub("%s+", "")
            KeyBox.Text = clip
            KeyBox:ReleaseFocus() 
            PlaySound(SOUNDS.Click)
            StatusText.Text = "Key pasted! Click Redeem."
            StatusText.TextColor3 = Color3.fromRGB(100, 200, 255)
        else
            StatusText.Text = "Clipboard Empty!"
            StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
            PlaySound(SOUNDS.Error)
            ShakeUI(InputContainer)
        end
    end
end)

DiscordBtn.MouseButton1Click:Connect(function()
    PlaySound(SOUNDS.Click) 
    if setclipboard then
        setclipboard(UI_CONFIG.DiscordLink)
        Notify("Punk X", "Discord Copied!")
    end
end)

GetKeyBtn.MouseButton1Click:Connect(function()
    PlaySound(SOUNDS.Click)
    if setclipboard then
        setclipboard(KeyLib.GetKeyURL())
        GetKeyBtn.Text = "Copied!"
        Notify("Punk X", "Key Link Copied!")
    end
    task.wait(1.5)
    GetKeyBtn.Text = "Get Key"
end)

OldUIBtn.MouseButton1Click:Connect(function()
    PlaySound(SOUNDS.Success)
    SaveEnvironmentPreference("OLD")
    CloseLoader()
    LaunchPunkX(CURRENT_KEY, Main_URL)
end)

NewUIBtn.MouseButton1Click:Connect(function()
    PlaySound(SOUNDS.Success)
    SaveEnvironmentPreference("NEW")
    CloseLoader()
    LaunchPunkX(CURRENT_KEY, New_URL)
end)

BetaBtn.MouseButton1Click:Connect(function()
    PlaySound(SOUNDS.Success)
    SaveEnvironmentPreference("BETA")
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
    
    if key == SECRET_DEV_KEY then
        PlaySound(SOUNDS.Success)
        StatusText.Text = "Developer Mode"
        StatusText.TextColor3 = Color3.fromRGB(0, 200, 255)
        if writefile then pcall(function() writefile(KEY_FILE_NAME, key) end) end
        CURRENT_KEY = key
        ShowLauncherMenu(true)
        isChecking = false
        return 
    end

    local success, valid, data = pcall(function() return KeyLib.Validate(key) end)
    
    if success and valid then
        PlaySound(SOUNDS.Success)
        if writefile then pcall(function() writefile(KEY_FILE_NAME, key) end) end
        SetExpiryData(data)
        Notify("Punk X", "Access Granted!", 2)
        CURRENT_KEY = key
        ShowLauncherMenu(false)
    else
        PlaySound(SOUNDS.Error)
        StatusText.Text = (success and "Invalid Key" or "Connection Error")
        StatusText.TextColor3 = Color3.fromRGB(255, 80, 80)
        KeyBox.Text = "" 
        ShakeUI(InputContainer) 
    end
    isChecking = false
    RedeemBtn.Text = "Redeem"
end)

-- // AUTO-LOGIN //
local autoLogged = false
local saved = KeyLib.GetSavedKey()
local env_preference = nil

if isfile and isfile(ENV_FILE_NAME) then
    -- Trim and upper-case before comparing.  An env file written with a
    -- trailing newline matched neither branch below, so the loader fell
    -- through to the key window and the saved environment looked
    -- forgotten - indistinguishable from no UI on rejoin.
    local raw_env = readfile(ENV_FILE_NAME)
    if type(raw_env) == "string" then
        env_preference = raw_env:gsub("%s+", ""):upper()
    end
end

-- Which auto-login branch is about to run.  A saved key is invisible
-- otherwise: the key window is built, then destroyed by the branch
-- below, which looks identical to "the window never appeared".
print("[PunkX] auto-login: saved=" .. (saved and "yes" or "no")
    .. " env=" .. tostring(env_preference))

if saved then
    if saved == SECRET_DEV_KEY then
        CURRENT_KEY = saved
        if env_preference == "BETA" then LaunchPunkX(SECRET_DEV_KEY, Beta_URL) ScreenGui:Destroy() return
        elseif env_preference == "OLD" or env_preference == "STABLE" then LaunchPunkX(SECRET_DEV_KEY, Main_URL) ScreenGui:Destroy() return
        elseif env_preference == "NEW" then LaunchPunkX(SECRET_DEV_KEY, New_URL) ScreenGui:Destroy() return end
        OpenLoader()
        KeyBox.Text = saved
        ShowLauncherMenu(true)
        autoLogged = true
    else
        local success, valid, data = pcall(function() return KeyLib.Validate(saved, false, true) end)
        if success and valid then 
            CURRENT_KEY = saved
            SetExpiryData(data)
            if env_preference == "OLD" or env_preference == "STABLE" then LaunchPunkX(saved, Main_URL) ScreenGui:Destroy() return
            elseif env_preference == "NEW" then LaunchPunkX(saved, New_URL) ScreenGui:Destroy() return end
            OpenLoader()
            KeyBox.Text = saved
            ShowLauncherMenu(false)
            autoLogged = true
        end
    end
end

if not autoLogged then OpenLoader() end

-- Geometry watchdog.  It never rebuilds the container (device: three fresh
-- ScreenGuis in a row reported the same stale AbsoluteSize, and each
-- rebuild destroys whatever the user is typing into).  It only re-places
-- the frame.
--
-- When the GUI viewport and the camera disagree, the GUI space cannot be
-- trusted, so the window is anchored top-left at a size that fits inside
-- the smaller of the two rectangles.  That is visible whichever one is
-- the real one.  When they agree, the normal centred layout is restored.
--
-- Decisive device evidence, from three runs of the same release:
--   drawn     gui=375.38x794.46  view=375.38x747.46
--   not drawn gui=375.38x834.46  view=375.38x747.46
--   not drawn gui=335.38x834.46  view=375.38x747.46
-- and drawn again wherever gui == view (754.46x375.38).  The window is
-- 351x336 at 12,12 in every one of them, so the frame, the parent and the
-- anchoring are not what differs - the ScreenGui's own rectangle is.
-- 794 = 747 + the topbar; 834 = the full screen including the navigation
-- inset.  When the client hands out the full-screen rectangle the layer
-- is laid out for a screen the renderer is not compositing, and nothing
-- inside it is ever drawn.
--
-- So the container rectangle is the thing that decides it, and the user's
-- logs give the rule without any device constant: every session that
-- drew had gui == view, and every session that drew nothing had
-- gui != view (794.46 against 747.46 - the topbar inset applied twice).
-- _punkMatchViewport therefore tries every ScreenInsets value the build
-- supports and keeps the one closest to the camera viewport, which is
-- the target on any screen.  Writing ScreenInsets blindly (release f)
-- moved a working 794.46 to 834.46, which is why the original value is
-- restored whenever no candidate measures better.
--
-- _punkTopLayer covers the other failure class: a ScreenGui is only
-- ordered against its siblings, so a game HUD at an equal or higher
-- DisplayOrder draws over the window no matter where the frame is.  It
-- raises the order only when something actually outranks us.

-- Make the container the top sibling in PlayerGui.  A ScreenGui is only
-- ordered against its siblings, so this is the only thing that decides
-- whether a game's HUD can draw over the window.  A tie is settled by
-- child order, which is why the last-resort branch re-parents.
local _punkTopOrder = nil

function _punkTopLayer()
    local own_parent = ScreenGui.Parent
    if not own_parent then return nil end

    local best = nil

    for _, v in ipairs(own_parent:GetChildren()) do
        if v ~= ScreenGui then
            local is_gui, order = pcall(function()
                if v:IsA("ScreenGui") then return v.DisplayOrder end
                return nil
            end)

            if is_gui and order and (best == nil or order > best) then
                best = order
            end
        end
    end

    if best == nil or best < ScreenGui.DisplayOrder then return nil end

    local target = best + 1

    if target > 2147483647 then
        target = 2147483647
        pcall(function()
            ScreenGui.Parent = nil
            ScreenGui.Parent = own_parent
        end)
    end

    local changed = target ~= ScreenGui.DisplayOrder
    pcall(function() ScreenGui.DisplayOrder = target end)

    if changed and _punkTopOrder ~= target then
        _punkTopOrder = target
        return "display " .. tostring(target)
            .. " (a game ScreenGui used " .. tostring(best) .. ")"
    end

    return nil
end

-- PlayerGui.CurrentScreenOrientation is what the engine is actually
-- using; it is the readback that says whether the landscape request
-- above took effect, so both state lines report it.
function _punkOrientationText()
    local value = "?"
    pcall(function()
        local pg = ScreenGui.Parent
        if pg then value = tostring(pg.CurrentScreenOrientation) end
    end)
    return value
end

-- The window draws only when the container's rectangle is the camera's
-- rectangle.  ScreenInsets decides it, so every value this build
-- supports is tried and the one closest to the viewport kept; nothing
-- is applied unless it beats the current rectangle, and the original
-- is restored otherwise.
local _punkInsetsTried = false
local _punkFlips = 0
local _punkFlipAt = 0
local _punkApplied = nil

-- Retried orientation flip.  A single flip is unreliable on this client:
-- the window rotates (nativeResize 1220x2712 then 2712x1220) but the
-- engine sometimes keeps the old GUI viewport, so one attempt per
-- session looked like "works sometimes, not others".  Up to three
-- attempts, three seconds apart, and only while the container still
-- does not match the camera.
function _punkWatchFlip()
    if not force_landscape then return end
    if _punkFlips >= 3 then return end

    local g = ScreenGui.AbsoluteSize
    if g.X < 1 or g.Y < 1 then return end

    local cam = nil
    pcall(function()
        local ws = game:GetService("Workspace")
        cam = ws and ws.CurrentCamera
    end)

    if not cam then return end

    local vx, vy = cam.ViewportSize.X, cam.ViewportSize.Y

    if math.abs(g.X - vx) <= 2 and math.abs(g.Y - vy) <= 2 then return end

    local now = os.clock()

    if now - _punkFlipAt < 3 then return end

    _punkFlips = _punkFlips + 1
    _punkFlipAt = now

    local ok, status = pcall(force_landscape)
    print("[PunkX] loader: orientation flip " .. tostring(_punkFlips)
        .. " status=" .. tostring(ok and status or "call failed"))
end

function _punkMatchViewport(vx, vy)
    if _punkInsetsTried then return nil end
    _punkInsetsTried = true

    local size = ScreenGui.AbsoluteSize
    local best, best_name = nil, nil
    local best_score = math.abs(size.X - vx) + math.abs(size.Y - vy)
    local original = nil

    pcall(function() original = ScreenGui.ScreenInsets end)

    local function attempt(name, value)
        if not pcall(function() ScreenGui.ScreenInsets = value end) then
            return
        end

        local now = ScreenGui.AbsoluteSize
        local score = math.abs(now.X - vx) + math.abs(now.Y - vy)

        if score < best_score then
            best, best_score, best_name = value, score, name
        end
    end

    pcall(function()
        attempt("DeviceSafeInsets", Enum.ScreenInsets.DeviceSafeInsets)
    end)
    pcall(function()
        attempt("CoreUISafeInsets", Enum.ScreenInsets.CoreUISafeInsets)
    end)
    pcall(function()
        attempt("TopbarSafeInsets", Enum.ScreenInsets.TopbarSafeInsets)
    end)
    pcall(function() attempt("None", Enum.ScreenInsets.None) end)

    if best then
        pcall(function() ScreenGui.ScreenInsets = best end)
    elseif original ~= nil then
        pcall(function() ScreenGui.ScreenInsets = original end)
    end

    local after = ScreenGui.AbsoluteSize

    if after.X == size.X and after.Y == size.Y then
        return nil
    end

    _punkLayoutMode = nil

    return "insets " .. tostring(size.X) .. "x" .. tostring(size.Y)
        .. " -> " .. tostring(after.X) .. "x" .. tostring(after.Y)
        .. " (" .. tostring(best_name) .. ")"
end

function _punkApplyLayout()
    -- Fixed layout, as the v22.2 loader had.  The auto-fit / auto-flip
    -- experiments moved a working window and, worse, fired three flips in
    -- one second (os.clock is CPU time here, so the spacing gate never
    -- held) and left the client in a mixed rectangle.  Nothing in this
    -- function writes geometry any more; OpenLoader's centred tween owns
    -- the placement and the user can drag it.
    do return nil, "fixed layout" end

    local g = ScreenGui.AbsoluteSize

    -- AbsoluteSize is only meaningful once the container has been laid
    -- out; measuring 0x0 would size the window from zero and then lock the
    -- mode in, so report nothing and let the next tick retry.
    if g.X < 1 or g.Y < 1 then
        return nil, "not laid out yet"
    end

    local vx, vy = nil, nil

    pcall(function()
        local ws = game:GetService("Workspace")
        local cam = ws and ws.CurrentCamera
        if cam then vx, vy = cam.ViewportSize.X, cam.ViewportSize.Y end
    end)

    if vx == nil then
        return "scale", "no-camera"
    end

    -- Anything but an exact match is the safe layout: the container is not
    -- the camera's rectangle, so the frame is anchored top-left inside the
    -- smaller of the two and cannot land outside either one.
    local width_match = math.abs(g.X - vx) <= 8
    local height_match = math.abs(g.Y - vy) <= 8
    local consistent = width_match and height_match

    local mode = consistent and "scale" or "safe"

    -- Re-place when the mode OR the two rectangles changed.  Keying on the
    -- mode alone missed the re-layout that follows the orientation flip:
    -- the mode stayed "safe" while the container went from 375x834 to
    -- 834x375, so the window kept the geometry measured mid-transition
    -- (device: frame=351x168 at=180,28).
    local same_rect = _punkApplied ~= nil
        and _punkApplied[1] == g.X and _punkApplied[2] == g.Y
        and _punkApplied[3] == vx and _punkApplied[4] == vy

    if _punkLayoutMode == mode and same_rect then
        return mode, "unchanged"
    end

    _punkLayoutMode = mode
    _punkApplied = { g.X, g.Y, vx, vy }

    if consistent then
        MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        MainFrame.Size = UDim2.new(0.5, 0, 0.45, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        return "scale", "gui=" .. tostring(g.X) .. "x" .. tostring(g.Y)
    end

    -- The window is composited only when the container's rectangle is the
    -- camera's rectangle.  Every session that drew had gui == view (the
    -- portrait one was 375.38x794.46 on both sides), and every session
    -- that drew nothing had gui != view (794.46 against 747.46).  The
    -- difference is the topbar inset applied twice.
    --
    -- ScreenInsets decides that rectangle, so try every value this build
    -- supports and keep the one closest to the viewport.  The target is
    -- the viewport itself - no topbar constant, no device number.
    local inset = _punkMatchViewport(vx, vy)

    g = ScreenGui.AbsoluteSize

    -- Tier 1 failed if the rectangle still is not the viewport: no
    -- ScreenInsets value can reach it on this client (device: the best
    -- candidate was 375.38x834.46 against a 375.38x747.46 viewport).  The
    -- orientation flip belongs to the watchdog, not here: it has to be
    -- retried, because the engine does not always pick the re-layout up.

    local width = math.max(220, math.min(g.X, vx) - 24)
    local height = math.max(140, math.min(g.Y, vy) * 0.45)

    -- Centred, not pinned to the corner.  After the orientation flip the
    -- container can be larger than the render viewport (device: 834x375
    -- against 754x375) and the layer still composites, so the window
    -- belongs in the middle of the rectangle the player can actually see.
    -- AnchorPoint keeps that true for any container size.
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Size = UDim2.new(0, width, 0, height)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

    return "safe", "gui=" .. tostring(g.X) .. "x" .. tostring(g.Y)
        .. " view=" .. tostring(vx) .. "x" .. tostring(vy)
        .. (inset and (" " .. inset) or "")
end

-- Re-place immediately when the camera viewport changes (rotation or a
-- late surface resize) instead of waiting for the next poll.  The mode
-- latch is cleared so the same mode name is applied again against the
-- new rectangle.
pcall(function()
    local cam = game:GetService("Workspace").CurrentCamera
    if cam then
        cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            _punkLayoutMode = nil
            _punkApplyLayout()
        end)
    end
end)

-- Watchdog on RunService.Heartbeat rather than task.wait: a generation
-- that is joined instantly can leave task.wait continuations late, and a
-- frame that is never placed looks exactly like a window that is drawn
-- nowhere.  Heartbeat is driven by the engine's own step, and the
-- accumulator keeps the work at once per second.
local _punkLastTick = 0
local _punkWatchMode = nil

game:GetService("RunService").Heartbeat:Connect(function()
    local now = os.clock()

    if now - _punkLastTick < 1 then return end
    _punkLastTick = now

    -- CloseLoader() destroys the container when the UI takes over, so
    -- this is a normal end of life, not an error.
    if ScreenGui.Parent == nil then return end

    local top = _punkTopLayer()

    if top then
        print("[PunkX] loader: window layer " .. tostring(top))
    end

    -- automatic flip removed

    local new_mode, detail = _punkApplyLayout()

    if new_mode and new_mode ~= _punkWatchMode then
        _punkWatchMode = new_mode
        print("[PunkX] loader: layout mode " .. tostring(new_mode)
            .. " (" .. tostring(detail) .. ")")
    end
end)

-- Place the window now instead of waiting for the first beat.  If the
-- container has not been laid out yet this reports nothing and the
-- watchdog retries a second later.
do
    local top = _punkTopLayer()

    if top then
        print("[PunkX] loader: window layer " .. tostring(top))
    end

    -- automatic flip removed

    local mode, detail = _punkApplyLayout()

    if mode then
        _punkWatchMode = mode
        print("[PunkX] loader: layout mode " .. tostring(mode)
            .. " (" .. tostring(detail) .. ")")
    end
end

-- One late report, fifteen seconds in: if the window is ever still not
-- visible after the game has settled, this line carries the whole state
-- instead of leaving it to another round of guessing.
task.delay(15, function()
    if _punkApplyLayout then _punkApplyLayout() end
    local ok, state = pcall(function()
        local g = ScreenGui.AbsoluteSize
        local vx, vy = -1, -1
        pcall(function()
            local ws = game:GetService("Workspace")
            local cam = ws and ws.CurrentCamera
            if cam then vx, vy = cam.ViewportSize.X, cam.ViewportSize.Y end
        end)
        local siblings, top_order = 0, -1
        pcall(function()
            local own_parent = ScreenGui.Parent
            if not own_parent then return end
            for _, v in ipairs(own_parent:GetChildren()) do
                if v ~= ScreenGui and v:IsA("ScreenGui") then
                    siblings = siblings + 1
                    if v.DisplayOrder > top_order then top_order = v.DisplayOrder end
                end
            end
        end)
        return "parent=" .. tostring(ScreenGui.Parent and ScreenGui.Parent:GetFullName())
            .. " enabled=" .. tostring(ScreenGui.Enabled)
            .. " display=" .. tostring(ScreenGui.DisplayOrder)
            .. " siblings=" .. tostring(siblings) .. "/" .. tostring(top_order)
            .. " orient=" .. _punkOrientationText()
            .. " gui=" .. tostring(g.X) .. "x" .. tostring(g.Y)
            .. " view=" .. tostring(vx) .. "x" .. tostring(vy)
            .. " frame=" .. tostring(MainFrame.AbsoluteSize.X) .. "x"
                .. tostring(MainFrame.AbsoluteSize.Y)
            .. " at=" .. tostring(MainFrame.AbsolutePosition.X) .. ","
                .. tostring(MainFrame.AbsolutePosition.Y)
            .. " visible=" .. tostring(MainFrame.Visible)
    end)
    print("[PunkX] loader: window state (15s) "
        .. (ok and state or ("probe failed: " .. tostring(state))))
end)

-- One-shot state report.  If the window is ever invisible again this
-- line names the reason instead of leaving it to guesswork: a nil parent
-- means the container dropped it, enabled=false means the key-failure
-- guard fired, size=0x0 means the geometry was cleared, gui/view tells
-- whether the GUI viewport matches the renderer, and a healthy report
-- means the frame exists but is drawn elsewhere (z-order).
task.delay(1, function()
    local ok, state = pcall(function()
        -- Rebuilding the container does not help: on device three fresh
        -- ScreenGuis in a row all reported the same stale AbsoluteSize while
        -- the camera reported a different viewport, so the mismatch lives in
        -- the client's GUI viewport.  The watcher below only reports it.

        if MainFrame.AbsoluteSize.X == 0 or MainFrame.AbsoluteSize.Y == 0 then
            MainFrame.Visible = true
            ScreenGui.Enabled = true
            -- Ask the watchdog to place it again instead of forcing a
            -- scale size here: this frame may belong in the safe layout.
            _punkLayoutMode = nil
        end

        local view_x, view_y = -1, -1
        pcall(function()
            local ws = game:GetService("Workspace")
            local cam = ws and ws.CurrentCamera
            if cam then
                view_x, view_y = cam.ViewportSize.X, cam.ViewportSize.Y
            end
        end)

        return "parent=" .. tostring(ScreenGui.Parent and ScreenGui.Parent:GetFullName())
            .. " enabled=" .. tostring(ScreenGui.Enabled)
            .. " display=" .. tostring(ScreenGui.DisplayOrder)
            .. " orient=" .. _punkOrientationText()
            .. " gui=" .. tostring(ScreenGui.AbsoluteSize.X) .. "x" .. tostring(ScreenGui.AbsoluteSize.Y)
            .. " view=" .. tostring(view_x) .. "x" .. tostring(view_y)
            .. " frame=" .. tostring(MainFrame.AbsoluteSize.X) .. "x" .. tostring(MainFrame.AbsoluteSize.Y)
            .. " at=" .. tostring(MainFrame.AbsolutePosition.X) .. "," .. tostring(MainFrame.AbsolutePosition.Y)
            .. " visible=" .. tostring(MainFrame.Visible)
    end)

    print("[PunkX] loader: window state "
        .. (ok and state or ("probe failed: " .. tostring(state))))
end)

-- // 🛡️ SAFE ANTI-AFK (Passive Mode) //
-- Replaces "VirtualUser" to bypass BAC-7205
task.spawn(function()
    if getconnections then
        for _, conn in pairs(getconnections(LocalPlayer.Idled)) do
            conn:Disable()
        end
    else
        -- Fallback: Just sit there (safest)
        LocalPlayer.Idled:Connect(function() end)
    end
end)
