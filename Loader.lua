-- [[ PUNK X: REMASTERED ]] --

local G2L = {};

-- // 🛡️ SECURITY: PARENTING //
local function GetSafeParent()
	if gethui then return gethui() end
	local CoreGui = game:GetService("CoreGui")
	if CoreGui:FindFirstChild("RobloxGui") then return CoreGui end
	return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

local randomName = game:GetService("HttpService"):GenerateGUID(false):sub(1, 8)

-- // 1. VISUALS (UI CREATION) //
G2L["1"] = Instance.new("ScreenGui", GetSafeParent())
G2L["1"].Name = randomName
G2L["1"]["IgnoreGuiInset"] = true
G2L["1"]["ResetOnSpawn"] = false
G2L["1"].Enabled = false -- Start Hidden (Loader will enable it)

G2L["2"] = Instance.new("LocalScript", G2L["1"]);

-- [SEARCH CARD TEMPLATE]
G2L["a"] = Instance.new("CanvasGroup", G2L["2"])
G2L["a"]["BackgroundColor3"] = Color3.fromRGB(20, 20, 25)
G2L["a"]["Size"] = UDim2.new(1, 0, 0, 60)
G2L["a"]["Name"] = "SearchTemplate"
G2L["a"]["BorderSizePixel"] = 0
Instance.new("UICorner", G2L["a"]).CornerRadius = UDim.new(0, 10)
local s1 = Instance.new("UIStroke", G2L["a"])
s1.Transparency = 0.5
s1.Color = Color3.fromRGB(60, 60, 80)

local t1 = Instance.new("TextLabel", G2L["a"])
t1.TextSize = 16
t1.TextXAlignment = Enum.TextXAlignment.Left
t1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
t1.TextColor3 = Color3.fromRGB(255, 255, 255)
t1.BackgroundTransparency = 1
t1.Size = UDim2.new(1, -60, 0, 25)
t1.Position = UDim2.new(0, 60, 0, 5)
t1.Text = "Script Title"
t1.Name = "Title"

local f1 = Instance.new("Frame", G2L["a"])
f1.Name = "Tags"
f1.BackgroundTransparency = 1
f1.Position = UDim2.new(0, 60, 0, 30)
f1.Size = UDim2.new(1, -200, 0, 25)
local l1 = Instance.new("UIListLayout", f1)
l1.Padding = UDim.new(0, 5)
l1.FillDirection = Enum.FillDirection.Horizontal
l1.SortOrder = Enum.SortOrder.LayoutOrder

for _, name in pairs({"Key", "Paid", "Patched", "Universal"}) do
	local tag = Instance.new("TextLabel", f1)
	tag.Name = name
	tag.Text = name
	tag.BackgroundColor3 = Color3.fromRGB(40,40,50)
	tag.TextColor3 = Color3.fromRGB(200,200,200)
	tag.Size = UDim2.new(0,0,1,0)
	tag.AutomaticSize = Enum.AutomaticSize.X
	tag.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
	tag.TextSize = 12
	local p = Instance.new("UIPadding", tag)
	p.PaddingLeft = UDim.new(0,8)
	p.PaddingRight = UDim.new(0,8)
	Instance.new("UICorner", tag).CornerRadius = UDim.new(0,6)
end

local fold1 = Instance.new("Folder", G2L["a"])
fold1.Name = "Misc"
local img1 = Instance.new("ImageLabel", fold1)
img1.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
img1.Image = "rbxassetid://109798560145884"
img1.Size = UDim2.new(0, 48, 0, 48)
img1.Position = UDim2.new(0, 6, 0, 6)
img1.Name = "Thumbnail"
Instance.new("UICorner", img1).CornerRadius = UDim.new(0, 8)

local cg1 = Instance.new("CanvasGroup", fold1)
cg1.BackgroundTransparency = 1
cg1.AnchorPoint = Vector2.new(1, 0.5)
cg1.Size = UDim2.new(0, 80, 1, 0)
cg1.Position = UDim2.new(1, -5, 0.5, 0)
cg1.Name = "Panel"
local l2 = Instance.new("UIListLayout", cg1)
l2.Padding = UDim.new(0, 5)
l2.FillDirection = Enum.FillDirection.Horizontal
l2.HorizontalAlignment = Enum.HorizontalAlignment.Right
l2.VerticalAlignment = Enum.VerticalAlignment.Center

local btnExec = Instance.new("TextButton", cg1)
btnExec.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
btnExec.Size = UDim2.new(0, 35, 0, 35)
btnExec.Text = ""
btnExec.Name = "Execute"
Instance.new("UICorner", btnExec).CornerRadius = UDim.new(0, 8)
local iconExec = Instance.new("ImageLabel", btnExec)
iconExec.BackgroundTransparency = 1
iconExec.Image = "rbxassetid://95804011254392"
iconExec.Size = UDim2.new(0.6,0,0.6,0)
iconExec.Position = UDim2.new(0.2,0,0.2,0)
iconExec.ImageColor3 = Color3.fromRGB(20,20,20)

local btnSave = Instance.new("TextButton", cg1)
btnSave.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
btnSave.Size = UDim2.new(0, 35, 0, 35)
btnSave.Text = ""
btnSave.Name = "Save"
Instance.new("UICorner", btnSave).CornerRadius = UDim.new(0, 8)
local iconSave = Instance.new("ImageLabel", btnSave)
iconSave.BackgroundTransparency = 1
iconSave.Image = "rbxassetid://81882572588470"
iconSave.Size = UDim2.new(0.6,0,0.6,0)
iconSave.Position = UDim2.new(0.2,0,0.2,0)

-- [SAVED TEMPLATE]
G2L["20"] = Instance.new("CanvasGroup", G2L["2"])
G2L["20"]["BorderSizePixel"] = 0
G2L["20"]["BackgroundColor3"] = Color3.fromRGB(20, 20, 25)
G2L["20"]["Size"] = UDim2.new(1, 0, 0, 50)
G2L["20"]["Name"] = "SaveTemplate"
Instance.new("UICorner", G2L["20"]).CornerRadius = UDim.new(0, 10)
local s2 = Instance.new("UIStroke", G2L["20"])
s2.Transparency = 0.5
s2.Color = Color3.fromRGB(60, 60, 80)

local t2 = Instance.new("TextBox", G2L["20"])
t2.TextSize = 14
t2.TextXAlignment = Enum.TextXAlignment.Left
t2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t2.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
t2.TextColor3 = Color3.fromRGB(255, 255, 255)
t2.BackgroundTransparency = 1
t2.Size = UDim2.new(0.6, 0, 1, 0)
t2.Position = UDim2.new(0, 15, 0, 0)
t2.Text = "Saved Script Name"
t2.Name = "Title"
t2.ClearTextOnFocus = false

local fold2 = Instance.new("Folder", G2L["20"])
fold2.Name = "Misc"
local cg2 = Instance.new("CanvasGroup", fold2)
cg2.BackgroundTransparency = 1
cg2.AnchorPoint = Vector2.new(1, 0.5)
cg2.Size = UDim2.new(0, 160, 1, 0)
cg2.Position = UDim2.new(1, -5, 0.5, 0)
cg2.Name = "Panel"
local l3 = Instance.new("UIListLayout", cg2)
l3.Padding = UDim.new(0, 5)
l3.FillDirection = Enum.FillDirection.Horizontal
l3.HorizontalAlignment = Enum.HorizontalAlignment.Right
l3.VerticalAlignment = Enum.VerticalAlignment.Center

local function createBtn(parent, name, iconId, color)
	local btn = Instance.new("TextButton", parent)
	btn.Name = name
	btn.Text = ""
	btn.BackgroundColor3 = Color3.fromRGB(40,40,50)
	btn.Size = UDim2.new(0,32,0,32)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
	local i = Instance.new("ImageLabel", btn)
	i.Name = "Icon"
	i.BackgroundTransparency = 1
	i.Image = iconId
	i.ImageColor3 = color or Color3.fromRGB(200,200,200)
	i.Size = UDim2.new(0.6,0,0.6,0)
	i.Position = UDim2.new(0.2,0,0.2,0)
	return btn
end
createBtn(cg2, "Delete", "rbxassetid://87426080563358", Color3.fromRGB(255, 80, 80))
createBtn(cg2, "AutoExec", "rbxassetid://11419714821", Color3.fromRGB(255, 50, 50))
createBtn(cg2, "Edit", "rbxassetid://129234394319564", Color3.fromRGB(100, 200, 255))
local ex2 = createBtn(cg2, "Execute", "rbxassetid://95804011254392", Color3.fromRGB(0, 255, 170))
ex2.BackgroundColor3 = Color3.fromRGB(40, 60, 50)

-- [TAB TEMPLATE]
G2L["30"] = Instance.new("TextButton", G2L["2"])
G2L["30"]["Name"] = "Yo"
G2L["30"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 35)
G2L["30"]["Size"] = UDim2.new(0, 100, 1, 0)
G2L["30"]["Text"] = ""
G2L["30"]["AutoButtonColor"] = false
Instance.new("UICorner", G2L["30"]).CornerRadius = UDim.new(0, 6)
local t3 = Instance.new("TextLabel", G2L["30"])
t3.Name = "Title"
t3.BackgroundTransparency = 1
t3.Size = UDim2.new(1,-25,1,0)
t3.Position = UDim2.new(0,5,0,0)
t3.TextXAlignment = Enum.TextXAlignment.Left
t3.TextColor3 = Color3.fromRGB(200,200,200)
t3.Font = Enum.Font.GothamMedium
t3.TextSize = 12
t3.Text = "Script 1"
local d3 = Instance.new("ImageButton", G2L["30"])
d3.Name = "Delete"
d3.BackgroundTransparency = 1
d3.Size = UDim2.new(0,16,0,16)
d3.AnchorPoint = Vector2.new(1,0.5)
d3.Position = UDim2.new(1,-5,0.5,0)
d3.Image = "rbxassetid://122962777517764"
d3.ImageColor3 = Color3.fromRGB(150,150,150)

-- [MAIN FRAME]
G2L["40"] = Instance.new("Frame", G2L["1"])
G2L["40"]["Name"] = "Main"
G2L["40"]["Size"] = UDim2.new(0, 750, 0, 450)
G2L["40"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
G2L["40"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
G2L["40"]["BackgroundColor3"] = Color3.fromRGB(15, 15, 20)
G2L["40"]["Visible"] = false
Instance.new("UICorner", G2L["40"]).CornerRadius = UDim.new(0, 16)
local s3 = Instance.new("UIStroke", G2L["40"])
s3.Color = Color3.fromRGB(0, 255, 255)
s3.Thickness = 1.5
s3.Transparency = 0.6

local ef = Instance.new("Frame", G2L["40"])
ef.Name = "EnableFrame"
ef.Visible = false
ef.Size = UDim2.new(1,0,1,0)
ef.BackgroundColor3 = Color3.fromRGB(0,0,0)
ef.BackgroundTransparency = 0.5
Instance.new("UICorner", ef).CornerRadius = UDim.new(0,16)

-- [SIDEBAR]
local left = Instance.new("Frame", G2L["40"])
left.Name = "Leftside"
left.BackgroundTransparency = 1
left.Size = UDim2.new(0, 60, 1, 0)
left.Position = UDim2.new(0, 0, 0, 0)

local nav = Instance.new("Frame", left)
nav.Name = "Nav"
nav.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
nav.Size = UDim2.new(0, 50, 0, 300)
nav.AnchorPoint = Vector2.new(0.5, 0.5)
nav.Position = UDim2.new(0.5, 0, 0.5, 0)
Instance.new("UICorner", nav).CornerRadius = UDim.new(1, 0)
local s4 = Instance.new("UIStroke", nav)
s4.Color = Color3.fromRGB(60, 60, 80)
s4.Thickness = 1

local pl = Instance.new("UIPageLayout", nav)
pl.SortOrder = Enum.SortOrder.LayoutOrder
pl.FillDirection = Enum.FillDirection.Vertical

local p1 = Instance.new("Frame", nav)
p1.Name = "Page1"
p1.BackgroundTransparency = 1
p1.Size = UDim2.new(1,0,1,0)
local l4 = Instance.new("UIListLayout", p1)
l4.HorizontalAlignment = Enum.HorizontalAlignment.Center
l4.VerticalAlignment = Enum.VerticalAlignment.Center
l4.Padding = UDim.new(0, 15)

local function createNavBtn(name, icon, order)
	local btn = Instance.new("TextButton", p1)
	btn.Name = name
	btn.LayoutOrder = order
	btn.Size = UDim2.new(0, 32, 0, 32)
	btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	local ico = Instance.new("ImageLabel", btn)
	ico.Name = "Icon"
	ico.Size = UDim2.new(1,0,1,0)
	ico.BackgroundTransparency = 1
	ico.Image = icon
	ico.ImageColor3 = Color3.fromRGB(150,150,150)
	return btn
end
createNavBtn("Home", "rbxassetid://83248619918383", 1)
createNavBtn("Editor", "rbxassetid://129234394319564", 2)
createNavBtn("Saved", "rbxassetid://97513260941879", 3)
createNavBtn("Search", "rbxassetid://127191938354199", 4)
createNavBtn("Settings", "rbxassetid://91653586592354", 5)

local closeBtn = Instance.new("TextButton", left)
closeBtn.Name = "Close"
closeBtn.Size = UDim2.new(0, 14, 0, 14)
closeBtn.Position = UDim2.new(0, 23, 0, 15)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Text = ""
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)

-- [PAGES]
local pages = Instance.new("Frame", G2L["40"])
pages.Name = "Pages"
pages.Size = UDim2.new(1, -70, 1, -20)
pages.Position = UDim2.new(0, 65, 0, 10)
pages.BackgroundTransparency = 1
local pp = Instance.new("UIPageLayout", pages)
pp.EasingStyle = Enum.EasingStyle.Circular
pp.EasingDirection = Enum.EasingDirection.Out
pp.TweenTime = 0.4
pp.SortOrder = Enum.SortOrder.LayoutOrder
pp.ScrollWheelInputEnabled = false

-- Home Page
local home = Instance.new("Frame", pages)
home.Name = "Home"
home.BackgroundTransparency = 1
home.LayoutOrder = 1
Instance.new("UIListLayout", home).Padding = UDim.new(0,10)
local titleF = Instance.new("Frame", G2L["40"])
titleF.Name = "Title"
titleF.BackgroundTransparency = 1
titleF.Size = UDim2.new(0, 200, 0, 30)
titleF.Position = UDim2.new(0, 70, 0, 15)
local hello = Instance.new("TextLabel", titleF)
hello.Name = "TextLabel"
hello.Size = UDim2.new(1,0,1,0)
hello.BackgroundTransparency = 1
hello.TextXAlignment = Enum.TextXAlignment.Left
hello.TextColor3 = Color3.fromRGB(0, 255, 255)
hello.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
hello.TextSize = 20
hello.Text = "Hello, User!"

local keyF = Instance.new("Frame", home)
keyF.Name = "Key"
keyF.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
keyF.Size = UDim2.new(1, 0, 0, 80)
Instance.new("UICorner", keyF).CornerRadius = UDim.new(0, 12)
local sk = Instance.new("UIStroke", keyF)
sk.Color = Color3.fromRGB(0, 255, 100)
sk.Transparency = 0.5
local kt = Instance.new("TextLabel", keyF)
kt.Name = "KeyText"
kt.Size = UDim2.new(1, -20, 0, 30)
kt.Position = UDim2.new(0, 15, 0, 10)
kt.BackgroundTransparency = 1
kt.TextColor3 = Color3.fromRGB(255,255,255)
kt.TextXAlignment = Enum.TextXAlignment.Left
kt.TextSize = 14
kt.RichText = true
kt.Text = "Checking key status..."
kt.Font = Enum.Font.GothamMedium
local dur = Instance.new("TextLabel", keyF)
dur.Name = "Duration"
dur.Size = UDim2.new(1, -20, 0, 20)
dur.Position = UDim2.new(0, 15, 0, 45)
dur.BackgroundTransparency = 1
dur.TextColor3 = Color3.fromRGB(150,150,150)
dur.TextXAlignment = Enum.TextXAlignment.Left
dur.Text = "Loading..."
dur.Font = Enum.Font.Gotham

-- Editor Page
local edP = Instance.new("Frame", pages)
edP.Name = "Editor"
edP.BackgroundTransparency = 1
edP.LayoutOrder = 2
local tabS = Instance.new("ScrollingFrame", edP)
tabS.Name = "Tabs"
tabS.Size = UDim2.new(1, 0, 0, 35)
tabS.BackgroundTransparency = 1
tabS.ScrollBarThickness = 0
tabS.ScrollingDirection = Enum.ScrollingDirection.X
tabS.AutomaticCanvasSize = Enum.AutomaticSize.X
local tl = Instance.new("UIListLayout", tabS)
tl.FillDirection = Enum.FillDirection.Horizontal
tl.Padding = UDim.new(0,5)
local crTab = Instance.new("TextButton", tabS)
crTab.Name = "Create"
crTab.LayoutOrder = 999
crTab.Size = UDim2.new(0, 30, 1, 0)
crTab.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
crTab.Text = "+"
crTab.TextColor3 = Color3.fromRGB(0,0,0)
crTab.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
Instance.new("UICorner", crTab).CornerRadius = UDim.new(0, 6)

local edBox = Instance.new("ScrollingFrame", edP)
edBox.Name = "Editor"
edBox.Size = UDim2.new(1, 0, 1, -85)
edBox.Position = UDim2.new(0, 0, 0, 45)
edBox.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
edBox.ScrollBarThickness = 4
edBox.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
Instance.new("UICorner", edBox).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", edBox).Color = Color3.fromRGB(40,40,50)
local inp = Instance.new("TextBox", edBox)
inp.Name = "Input"
inp.MultiLine = true
inp.Size = UDim2.new(1, -25, 1, 0)
inp.Position = UDim2.new(0, 25, 0, 0)
inp.BackgroundTransparency = 1
inp.TextColor3 = Color3.fromRGB(220, 220, 220)
inp.TextSize = 14
inp.FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
inp.TextXAlignment = Enum.TextXAlignment.Left
inp.TextYAlignment = Enum.TextYAlignment.Top
inp.ClearTextOnFocus = false
inp.Text = "-- Welcome"
local lines = Instance.new("TextLabel", edBox)
lines.Name = "Lines"
lines.Size = UDim2.new(0, 20, 1, 0)
lines.BackgroundTransparency = 1
lines.TextColor3 = Color3.fromRGB(80, 80, 80)
lines.TextSize = 14
lines.FontFace = inp.FontFace
lines.TextYAlignment = Enum.TextYAlignment.Top
lines.Text = "1"

local pan = Instance.new("CanvasGroup", edP)
pan.Name = "Panel"
pan.Size = UDim2.new(1, 0, 0, 35)
pan.AnchorPoint = Vector2.new(0, 1)
pan.Position = UDim2.new(0, 0, 1, 0)
pan.BackgroundTransparency = 1
local pl2 = Instance.new("UIListLayout", pan)
pl2.FillDirection = Enum.FillDirection.Horizontal
pl2.HorizontalAlignment = Enum.HorizontalAlignment.Right
pl2.Padding = UDim.new(0, 8)

local function mkEdBtn(name, icon, color)
	local b = Instance.new("TextButton", pan)
	b.Name = name
	b.Text = ""
	b.BackgroundColor3 = Color3.fromRGB(30,30,35)
	b.Size = UDim2.new(0,35,0,35)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	local i = Instance.new("ImageLabel", b)
	i.Name = "Icon"
	i.BackgroundTransparency = 1
	i.Image = icon
	i.ImageColor3 = color
	i.Size = UDim2.new(0.6,0,0.6,0)
	i.Position = UDim2.new(0.2,0,0.2,0)
	return b
end
mkEdBtn("Execute", "rbxassetid://95804011254392", Color3.fromRGB(0,255,180))
mkEdBtn("ExecuteClipboard", "rbxassetid://74812558983299", Color3.fromRGB(255,255,255))
mkEdBtn("Save", "rbxassetid://81882572588470", Color3.fromRGB(100,200,255))
mkEdBtn("Paste", "rbxassetid://88661060655687", Color3.fromRGB(200,200,200))
mkEdBtn("Rename", "rbxassetid://80861536658698", Color3.fromRGB(255,200,100))
mkEdBtn("Delete", "rbxassetid://98690572665832", Color3.fromRGB(255,80,80))

-- Saved & Search & Settings
local svP = Instance.new("Frame", pages)
svP.Name = "Saved"
svP.BackgroundTransparency = 1
svP.LayoutOrder = 3
local sbox = Instance.new("TextBox", svP)
sbox.Name = "TextBox"
sbox.Size = UDim2.new(1, 0, 0, 35)
sbox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
sbox.TextColor3 = Color3.fromRGB(255,255,255)
sbox.PlaceholderText = "Search saved scripts..."
sbox.Text = ""
Instance.new("UICorner", sbox).CornerRadius = UDim.new(0, 8)
local svSc = Instance.new("ScrollingFrame", svP)
svSc.Name = "Scripts"
svSc.Size = UDim2.new(1, 0, 1, -45)
svSc.Position = UDim2.new(0, 0, 0, 45)
svSc.BackgroundTransparency = 1
svSc.ScrollBarThickness = 2
Instance.new("UIListLayout", svSc).Padding = UDim.new(0, 5)

local srP = Instance.new("Frame", pages)
srP.Name = "Search"
srP.BackgroundTransparency = 1
srP.LayoutOrder = 4
local cBox = Instance.new("TextBox", srP)
cBox.Name = "TextBox"
cBox.Size = UDim2.new(1, 0, 0, 35)
cBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
cBox.TextColor3 = Color3.fromRGB(255,255,255)
cBox.PlaceholderText = "Search ScriptBlox..."
cBox.Text = ""
Instance.new("UICorner", cBox).CornerRadius = UDim.new(0, 8)
local cSc = Instance.new("ScrollingFrame", srP)
cSc.Name = "Scripts"
cSc.Size = UDim2.new(1, 0, 1, -45)
cSc.Position = UDim2.new(0, 0, 0, 45)
cSc.BackgroundTransparency = 1
cSc.ScrollBarThickness = 2
Instance.new("UIListLayout", cSc).Padding = UDim.new(0, 5)

local setP = Instance.new("Frame", pages)
setP.Name = "Settings"
setP.BackgroundTransparency = 1
setP.LayoutOrder = 5
local setSc = Instance.new("ScrollingFrame", setP)
setSc.Name = "Scripts"
setSc.Size = UDim2.new(1, 0, 1, 0)
setSc.BackgroundTransparency = 1
setSc.ScrollBarThickness = 2
Instance.new("UIListLayout", setSc).Padding = UDim.new(0, 8)

-- Popups & Open Button
local pop = Instance.new("Frame", G2L["1"])
pop.Name = "Popups"
pop.Size = UDim2.new(1, 0, 1, 0)
pop.BackgroundColor3 = Color3.fromRGB(0,0,0)
pop.BackgroundTransparency = 0.4
pop.Visible = false
pop.ZIndex = 999

local pm = Instance.new("Frame", pop)
pm.Name = "Main"
pm.Size = UDim2.new(0, 300, 0, 160)
pm.Position = UDim2.new(0.5, 0, 0.5, 0)
pm.AnchorPoint = Vector2.new(0.5, 0.5)
pm.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", pm).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", pm).Color = Color3.fromRGB(100, 100, 255)

local pt = Instance.new("TextLabel", pm)
pt.Text = "Enter Name"
pt.TextColor3 = Color3.fromRGB(255,255,255)
pt.BackgroundTransparency = 1
pt.Size = UDim2.new(1, 0, 0, 40)
pt.Font = Enum.Font.GothamBold
pt.TextSize = 16

local pi = Instance.new("TextBox", pm)
pi.Name = "Input"
pi.Size = UDim2.new(0.8, 0, 0, 35)
pi.Position = UDim2.new(0.1, 0, 0.3, 0)
pi.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
pi.TextColor3 = Color3.fromRGB(255,255,255)
pi.Text = ""
Instance.new("UICorner", pi).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", pi).Color = Color3.fromRGB(60,60,80)

local pbtns = Instance.new("Frame", pm)
pbtns.Name = "Button"
pbtns.BackgroundTransparency = 1
pbtns.Size = UDim2.new(1, 0, 0, 40)
pbtns.Position = UDim2.new(0, 0, 0.7, 0)

local pconf = Instance.new("TextButton", pbtns)
pconf.Name = "Confirm"
pconf.Text = "Confirm"
pconf.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
pconf.TextColor3 = Color3.fromRGB(255,255,255)
pconf.Size = UDim2.new(0, 100, 0, 30)
pconf.Position = UDim2.new(0.5, 10, 0, 0)
Instance.new("UICorner", pconf).CornerRadius = UDim.new(0, 6)

local pcanc = Instance.new("TextButton", pbtns)
pcanc.Name = "Cancel"
pcanc.Text = "Cancel"
pcanc.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
pcanc.TextColor3 = Color3.fromRGB(255,255,255)
pcanc.Size = UDim2.new(0, 100, 0, 30)
pcanc.Position = UDim2.new(0.5, -110, 0, 0)
Instance.new("UICorner", pcanc).CornerRadius = UDim.new(0, 6)

local open = Instance.new("ImageButton", G2L["1"])
open.Name = "Open"
open.Size = UDim2.new(0, 50, 0, 50)
open.Position = UDim2.new(0.5, -25, 0, 10)
open.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
open.Image = "rbxassetid://109798560145884"
open.ImageColor3 = Color3.fromRGB(0, 255, 255)
open.Visible = false
Instance.new("UICorner", open).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", open).Color = Color3.fromRGB(0, 255, 255)


-- // 2. LOGIC HANDLER //
local function C_2()
	local script = G2L["2"];
	if not game:IsLoaded() then game.Loaded:Wait() end
	local ps = pcall(function() script.Parent.Parent = gethui and gethui() or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end)

	-- [[ EMBEDDED KEY SYSTEM MODULE (Panda V2.5) ]] --
	local KeyLib = {}
	local CONFIG = { serviceId = "punk-x-release-key", fileName = "punk-x-key.txt", autoSave = true }
	local HttpService = game:GetService("HttpService")
	local RbxAnalytics = game:GetService("RbxAnalyticsService")
	local httpRequest = (syn and syn.request) or (http and http.request) or request or http_request
	local function getHWID() if gethwid then return gethwid() end return RbxAnalytics:GetClientId() end
	function KeyLib.GetKeyURL() return "https://pandadevelopment.net/getkey?service=" .. CONFIG.serviceId .. "&hwid=" .. getHWID() end
	function KeyLib.Validate(key)
		if not httpRequest then return false, "Executor missing HTTP" end
		if not key then return false, "No key provided" end
		key = key:gsub(" ", ""):gsub("\n", "")
		local url = "https://pandadevelopment.net/v2_validation?service=" .. CONFIG.serviceId .. "&key=" .. key .. "&hwid=" .. getHWID()
		local success, response = pcall(function() return httpRequest({Url = url, Method = "GET", Headers = { ["User-Agent"] = "PunkX-Loader" }}) end)
		if not success or not response then return false, "Connection Error" end
		local data = nil; pcall(function() data = HttpService:JSONDecode(response.Body) end)
		if not data then return false, "Invalid JSON" end
		if data.V2_Authentication == "success" then
			if CONFIG.autoSave and writefile then pcall(function() writefile(CONFIG.fileName, key) end) end
			return true, data
		else
			return false, data.V2_Authentication
		end
	end
	function KeyLib.GetSavedKey()
		if isfile and readfile and isfile(CONFIG.fileName) then local success, content = pcall(function() return readfile(CONFIG.fileName) end) if success and #content > 1 then return content end end return nil
	end

	-- [[ CORE LOGIC ]] --
	local function deepCopy(tbl) if (type(tbl) ~= "table") then return tbl; end local copy = {}; for key, value in pairs(tbl) do copy[key] = deepCopy(value); end return copy; end
	local Services = setmetatable({}, { __index = function(self, name) local success, cache = pcall(function() return cloneref(game:GetService(name)) end) if success then rawset(self, name, cache) return cache else error("Invalid Service: " .. tostring(name)) end end })
	local clonefunction = clonefunction or function(func) return func end
	local InvisTriggerOpen = false
	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")
	local Main = script.Parent:WaitForChild("Main")
	local Leftside = Main:WaitForChild("Leftside")
	local Nav = Leftside:WaitForChild("Nav")
	local Pages = Main:WaitForChild("Pages")
	local EnableFrame = Main:WaitForChild("EnableFrame")
	local KeyVailded = false
	local highlighter = nil
	
	local function hideUI(bool, forKey)
		if (not bool and InvisTriggerOpen) then script.Parent.Enabled = false end
		for _, v in ipairs(script.Parent:GetChildren()) do
			if v.Name == "Popups" then v.Visible = false return end
			if (v.Name == "EnableFrame") then continue end
			if (v:IsA("Frame") or v:IsA("ImageLabel")) then v.Visible = bool
			elseif v:IsA("ImageButton") then v.Visible = not bool end
		end
	end
	hideUI(false) -- Hide Executor initially

	pcall(function() getgenv()._PULL_INT() end)
	local CLONED_Detectedly = deepCopy(Detectedly or {})
	Detectedly = nil
	local print = function(...) end
	for i, v in pairs({'pushautoexec','runcode','open_url','toast','writefile','appendfile','readfile','isfile','listfiles','delfile','deldir','isfolder','makedir'}) do
		if not CLONED_Detectedly[v] then CLONED_Detectedly[v] = function(...) print(v,"|", ...) end end
	end
	
	local load_highlighter = function()
		local utility = {}; utility.sanitizeRichText = function(s) return string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(s, "&", "&amp;"), "<", "&lt;"), ">", "&gt;"), '"', "&quot;"), "'", "&apos;"); end;
		utility.convertTabsToSpaces = function(s) return string.gsub(s, "\t", "    "); end; utility.removeControlChars = function(s) return string.gsub(s, "[\0\1\2\3\4\5\6\7\8\11\12\13\14\15\16\17\18\19\20\21\22\23\24\25\26\27\28\29\30\31]+", ""); end;
		local theme = { tokenColors = {background=Color3.fromRGB(18,18,22), iden=Color3.fromRGB(220,220,220), keyword=Color3.fromRGB(255,100,255), builtin=Color3.fromRGB(0,255,255), string=Color3.fromRGB(0,255,150), number=Color3.fromRGB(255,180,0), comment=Color3.fromRGB(100,100,120), operator=Color3.fromRGB(255,255,255)}, getColor=function(self, t) return self.tokenColors[t] end };
		local Highlighter = { highlight = function(props) return function() end end }; return Highlighter;
	end;
	
	local function getDuplicatedName(baseName, existingNames) if not existingNames[baseName] then return baseName; end local counter = 1; local newName; repeat newName = baseName .. " " .. counter; counter = counter + 1; until not existingNames[newName] return newName; end
	local function createNotification(text, type, dur) game:GetService("StarterGui"):SetCore("SendNotification", { Title = type, Text = text, Duration = dur or 3 }) end
	local update_lines = function(editor, linesFrame) local lines = editor.Text:split("\n"); linesFrame.Text = ""; for i in lines do linesFrame.Text = linesFrame.Text .. i .. "\n"; end end;
	local Data = { Editor = { CurrentTab = nil, CurrentOrder = 0, Tabs = {} }, Saves = { Scripts = {} } };
	local InitTabs = {};
	local UIEvents = {};
	
	-- [[ EXECUTOR UI EVENTS ]] --
	UIEvents = {
		EditorTabs = {
			getHighestOrder = function() local HighestOrder = - 1; for _, v in pairs(Data.Editor.Tabs) do if (v[2] > HighestOrder) then HighestOrder = v[2]; end end return HighestOrder; end,
			createTab = function(TabName, Content, isTemp) local HighestOrder = UIEvents.EditorTabs.getHighestOrder(); Content = Content or ""; if not isTemp then TabName = getDuplicatedName(TabName, Data.Editor.Tabs or {}); CLONED_Detectedly.writefile("scripts/" .. TabName .. ".lua", game.HttpService:JSONEncode({ Name = TabName, Content = Content, Order = (HighestOrder + 1) })); end if Data.Editor.Tabs then Data.Editor.Tabs[TabName] = { Content, (HighestOrder + 1) }; end UIEvents.EditorTabs.switchTab(TabName); UIEvents.EditorTabs.updateUI(); end,
			saveTab = function(tabName, Content, isExplicitSave) tabName = tabName or Data.Editor.CurrentTab; if not tabName then return end if Data.Editor.EditingSavedFile == tabName then if isExplicitSave then UIEvents.Saved.SaveFile(tabName, Content, true) createNotification("Saved File Overwritten", "Success", 3) CLONED_Detectedly.delfile("scripts/" .. tabName .. ".lua") Data.Editor.Tabs[tabName] = nil Data.Editor.EditingSavedFile = nil Data.Editor.CurrentTab = nil UIEvents.EditorTabs.updateUI() UIEvents.Nav.goTo("Saved") else local TabData = Data.Editor.Tabs[tabName]; if TabData then CLONED_Detectedly.writefile("scripts/" .. tabName .. ".lua", game.HttpService:JSONEncode({ Name = tabName, Content = Content, Order = TabData[2] })); Data.Editor.Tabs[tabName] = { Content, TabData[2] }; end end return end if isExplicitSave then UIEvents.Saved.SaveFile(tabName, Content, false) else local TabData = Data.Editor.Tabs[tabName]; if (TabData) then CLONED_Detectedly.writefile("scripts/" .. tabName .. ".lua", game.HttpService:JSONEncode({ Name = tabName, Content = Content, Order = TabData[2] })); Data.Editor.Tabs[tabName] = { Content, TabData[2] }; end end end,
			switchTab = function(ToTab) if Data.Editor.EditingSavedFile and Data.Editor.EditingSavedFile ~= ToTab then local editingName = Data.Editor.EditingSavedFile; createNotification("Editing Cancelled", "Warn", 3); CLONED_Detectedly.delfile("scripts/" .. editingName .. ".lua"); Data.Editor.Tabs[editingName] = nil; Data.Editor.EditingSavedFile = nil; UIEvents.EditorTabs.updateUI() end if (Data.Editor.Tabs[ToTab] and not Data.Editor.IsSwitching) then Data.Editor.IsSwitching = true; local Editor = Pages:WaitForChild("Editor"); local EditorFrame = Editor:WaitForChild("Editor").Input; local OldTab = Data.Editor.CurrentTab; if (OldTab and Data.Editor.Tabs[OldTab] and OldTab ~= Data.Editor.EditingSavedFile) then local CurrentContent = EditorFrame.Text; UIEvents.EditorTabs.saveTab(OldTab, CurrentContent, false); end Data.Editor.CurrentTab = ToTab; local TabContent = Data.Editor.Tabs[ToTab][1] or ""; EditorFrame.Text = TabContent; Data.Editor.IsSwitching = false; UIEvents.EditorTabs.updateUI(); end end,
			delTab = function(Name) local total = 0; for i, v in pairs(Data.Editor.Tabs) do total = total + 1; end local isEditing = (Data.Editor.EditingSavedFile == Name); if ((total - 1) <= 0) and not isEditing then createNotification("Cannot delete last tab!", "Error", 5) return; end local HighestOrder = UIEvents.EditorTabs.getHighestOrder(); for i, v in pairs(Data.Editor.Tabs) do if (i ~= Name) then UIEvents.EditorTabs.switchTab(i); end end if not isEditing then CLONED_Detectedly.delfile("scripts/" .. Name .. ".lua"); end Data.Editor.Tabs[Name] = nil; if isEditing then createNotification("Editing Cancelled", "Warn", 3) Data.Editor.EditingSavedFile = nil UIEvents.Nav.goTo("Saved") end UIEvents.EditorTabs.updateUI(); end,
			updateUI = function() for _, v in pairs(Pages.Editor.Tabs:GetChildren()) do if v:IsA("TextButton") and v.Name ~= "Create" then v:Destroy() end end if Pages.Editor.Tabs:FindFirstChild("Create") then Pages.Editor.Tabs.Create.Visible = (Data.Editor.EditingSavedFile == nil) end for i, v in pairs(Data.Editor.Tabs) do if Data.Editor.EditingSavedFile and i ~= Data.Editor.EditingSavedFile then continue end local new = script.Yo:Clone(); new.Parent = Pages.Editor.Tabs; new.Title.Text = i; new.Name = i; new.MouseButton1Click:Connect(function() UIEvents.EditorTabs.switchTab(i); end); new.Delete.MouseButton1Click:Connect(function() UIEvents.EditorTabs.delTab(i); end); new.LayoutOrder = v[2]; if (Data.Editor.CurrentTab == i) then new.BackgroundColor3 = Color3.fromRGB(0, 180, 200); else new.BackgroundColor3 = Color3.fromRGB(40,40,50) end end end,
			RenameFile = function(NewName, TargetTab) if Data.Editor.EditingSavedFile == TargetTab then NewName = getDuplicatedName(NewName, Data.Saves.Scripts or {}); if not Data.Saves.Scripts[NewName] then UIEvents.Saved.SaveFile(NewName, Data.Editor.Tabs[TargetTab][1], false); UIEvents.Saved.DelFile(TargetTab); Data.Editor.EditingSavedFile = NewName; Data.Editor.Tabs[NewName] = Data.Editor.Tabs[TargetTab]; Data.Editor.Tabs[TargetTab] = nil; Data.Editor.CurrentTab = NewName; UIEvents.EditorTabs.updateUI(); createNotification("Saved Script Renamed", "Success", 3) end return end NewName = getDuplicatedName(NewName, Data.Editor.Tabs or {}); if not Data.Editor.Tabs[NewName] then if Data.Editor.Tabs then Data.Editor.Tabs[NewName] = Data.Editor.Tabs[TargetTab] end CLONED_Detectedly.writefile("scripts/" .. NewName .. ".lua", game.HttpService:JSONEncode({ Name = NewName, Content = Data.Editor.Tabs[TargetTab][1], Order = Data.Editor.Tabs[TargetTab][2] })); CLONED_Detectedly.delfile("scripts/" .. TargetTab .. ".lua"); Data.Editor.Tabs[TargetTab] = nil; Data.Editor.CurrentTab = NewName; UIEvents.EditorTabs.updateUI(); end end
		},
		Saved = {
			SaveFile = function(Name, Content, Overwrite) if not Overwrite then Name = getDuplicatedName(Name, Data.Saves.Scripts or {}); end CLONED_Detectedly.writefile("saves/" .. Name .. ".lua", game.HttpService:JSONEncode({ Name = Name, Content = Content })); Data.Saves.Scripts[Name] = Content; UIEvents.Saved.UpdateUI(); if not Overwrite then createNotification("Saved to: " .. Name, "Success", 3) end end,
			DelFile = function(Name) CLONED_Detectedly.delfile("saves/" .. Name .. ".lua"); Data.Saves.Scripts[Name] = nil; UIEvents.Saved.UpdateUI(); end,
			UpdateUI = function() for _, v in pairs(Pages.Saved.Scripts:GetChildren()) do if v:IsA("CanvasGroup") then v:Destroy() end end for i, v in pairs(Data.Saves.Scripts) do local new = script.SaveTemplate:Clone(); new.Parent = Pages.Saved.Scripts; new.Name = i; new.Title.Text = i; new.Misc.Panel.Execute.MouseButton1Click:Connect(function() UIEvents.Executor.RunCode(v)(); end); new.Misc.Panel.Delete.MouseButton1Click:Connect(function() UIEvents.Saved.DelFile(i); end); new.Misc.Panel.Edit.MouseButton1Click:Connect(function() if Data.Editor.EditingSavedFile == i then UIEvents.Nav.goTo("Editor") return end if Data.Editor.EditingSavedFile then local old = Data.Editor.EditingSavedFile; CLONED_Detectedly.delfile("scripts/" .. old .. ".lua"); Data.Editor.Tabs[old] = nil; Data.Editor.EditingSavedFile = nil end Data.Editor.EditingSavedFile = i; UIEvents.EditorTabs.createTab(i, v, true); UIEvents.Nav.goTo("Editor"); createNotification("Editing: " .. i, "Info", 3) end); local autoExecPath = "autoexec/" .. i .. ".lua"; local isAutoOn = CLONED_Detectedly.isfile(autoExecPath); if isAutoOn then new.Misc.Panel.AutoExec.Icon.ImageColor3 = Color3.fromRGB(0, 255, 170) else new.Misc.Panel.AutoExec.Icon.ImageColor3 = Color3.fromRGB(255, 50, 50) end new.Misc.Panel.AutoExec.MouseButton1Click:Connect(function() if CLONED_Detectedly.isfile(autoExecPath) then CLONED_Detectedly.delfile(autoExecPath); new.Misc.Panel.AutoExec.Icon.ImageColor3 = Color3.fromRGB(255, 50, 50); createNotification("AutoExec Deactivated", "Error", 3) else CLONED_Detectedly.writefile(autoExecPath, v); new.Misc.Panel.AutoExec.Icon.ImageColor3 = Color3.fromRGB(0, 255, 170); createNotification("AutoExec Activated", "Success", 3) end end); new.Title.FocusLost:Connect(function(press) local newName = new.Title.Text; local isEmpty = # (string.gsub(newName, "[%s]", "")) <= 0; if (not press or isEmpty or (newName == i)) then new.Title.Text = i; return; end UIEvents.Saved.RenameFile(newName, i); end); end end,
			RenameFile = function(NewName, TargetTab) NewName = getDuplicatedName(NewName, Data.Saves.Scripts or {}); if not Data.Saves.Scripts[NewName] then UIEvents.Saved.SaveFile(NewName, Data.Saves.Scripts[TargetTab], false); UIEvents.Saved.DelFile(TargetTab); UIEvents.Saved.UpdateUI(); end end
		},
		Executor = {
			RunCode = function(content)
				createNotification("Executed!", "Success", 5);
				local func, x = loadstring(content);
				if not func then task.spawn(function() error(x) end); else return func; end
				return function() end;
			end
		},
		Nav = {
			goTo = function(Name) if Pages:FindFirstChild(Name) then Pages.UIPageLayout:JumpTo(Pages[Name]); end local Button = nil; for _, frame in ipairs(Nav:GetChildren()) do if frame:IsA("Frame") then for _, btn in ipairs(frame:GetChildren()) do if btn.Name == Name then Button = btn break end end end end if Button then EnableFrame.Visible = true; Pages.Visible = true; local TargetSize = UDim2.new(0, Button.AbsoluteSize.X, 0, Button.AbsoluteSize.Y); local TargetPosition = Button.AbsolutePosition - EnableFrame.Parent.AbsolutePosition; local TargetPos = UDim2.new(0, TargetPosition.X, 0, TargetPosition.Y); if (f or isInstantNext) then EnableFrame.Position = TargetPos; EnableFrame.Size = TargetSize; if isInstantNext then isInstantNext = false; end return; end TweenService:Create(EnableFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = TargetPos, Size = TargetSize, BackgroundTransparency = 0 }):Play(); end end
		}
	};

	InitTabs.TabsData = function()
		if not CLONED_Detectedly.isfolder("scripts") then CLONED_Detectedly.makedir("scripts") end
		local scripts = CLONED_Detectedly.listfiles("scripts") or {};
		for index, Nextpath in ipairs(scripts) do if (Nextpath == "/recently.data") then continue; end local success, Loadedscript = pcall(function() return game.HttpService:JSONDecode(CLONED_Detectedly.readfile("scripts" .. Nextpath)); end) if success and Loadedscript and Loadedscript.Name then Data.Editor.Tabs[Loadedscript.Name] = { Loadedscript.Content, Loadedscript.Order }; end end
		if (# scripts == 0) then UIEvents.EditorTabs.createTab("Script", ""); end UIEvents.EditorTabs.updateUI();
	end;
	InitTabs.Saved = function()
		if not CLONED_Detectedly.isfolder("saves") then CLONED_Detectedly.makedir("saves"); end
		if not CLONED_Detectedly.isfolder("autoexec") then CLONED_Detectedly.makedir("autoexec"); end
		local saves = CLONED_Detectedly.listfiles("saves") or {};
		for index, Nextpath in ipairs(saves) do local filename = Nextpath:match("([^/\\]+)$"); if not filename:match("%.lua$") then continue; end local Loadedscript = game.HttpService:JSONDecode(CLONED_Detectedly.readfile("saves/" .. filename)); Data.Saves.Scripts[Loadedscript.Name] = Loadedscript.Content; end
		UIEvents.Saved.UpdateUI(); Pages.Saved.TextBox:GetPropertyChangedSignal("Text"):Connect(function() local hi = Pages.Saved.TextBox.Text; local isEmpty = #hi:gsub("[%s]","") <= 0; if isEmpty then for _, v in pairs(Pages.Saved.Scripts:GetChildren()) do if v:IsA("CanvasGroup") and v:FindFirstChild("Title") then v.Visible = true; end end return end for _, v in pairs(Pages.Saved.Scripts:GetChildren()) do if v:IsA("CanvasGroup") and v:FindFirstChild("Title") then v.Visible = v.Title.Text:lower():match("^" .. hi:lower()) ~= nil; end end end)
	end;
	InitTabs.Editor = function()
		local Editor = Pages:WaitForChild("Editor"); local Panel = Editor:WaitForChild("Panel"); local EditorFrame = Editor:WaitForChild("Editor"); local Method = "Activated";
		Panel.Execute[Method]:Connect(function() UIEvents.Executor.RunCode(EditorFrame.Input.Text)(); end); Panel.Paste[Method]:Connect(function() EditorFrame.Input.Text = (getclipboard and getclipboard()) or ""; end); Panel.ExecuteClipboard[Method]:Connect(function() UIEvents.Executor.RunCode((getclipboard and getclipboard()) or "")(); end); Panel.Delete[Method]:Connect(function() EditorFrame.Input.Text = ""; end); Panel.Save[Method]:Connect(function() UIEvents.EditorTabs.saveTab(nil, EditorFrame.Input.Text, true); end); Panel.Rename[Method]:Connect(function() script.Parent.Popups.Visible = true; script.Parent.Popups.Main.Input.Text = Data.Editor.CurrentTab or "" end);
		if not highlighter then highlighter = load_highlighter(); end
		EditorFrame.Input:GetPropertyChangedSignal("Text"):Connect(function() update_lines(EditorFrame.Input, EditorFrame.Lines); if not Data.Editor.EditingSavedFile then UIEvents.EditorTabs.saveTab(nil, EditorFrame.Input.Text, false); end end); update_lines(EditorFrame.Input, EditorFrame.Lines); highlighter.highlight({ textObject = EditorFrame.Input });
		Editor.Tabs.Create.Activated:Connect(function() UIEvents.EditorTabs.createTab("Script", ""); end);
		local Buttons = script.Parent.Popups.Main.Button; Buttons["Confirm"][Method]:Connect(function() local newName = script.Parent.Popups.Main.Input.Text; local isEmpty = # (string.gsub(newName, "[%s]", "")) <= 0; if (isEmpty or (newName == Data.Editor.CurrentTab)) then return; end UIEvents.EditorTabs.RenameFile(newName, Data.Editor.CurrentTab); script.Parent.Popups.Visible = false; end); Buttons["Cancel"][Method]:Connect(function() script.Parent.Popups.Visible = false; end)
	end;
	InitTabs.Search = function()
		local Search = Pages:WaitForChild("Search"); local TagsValid = { Key = function(sData) return sData.key; end, Universal = function(sData) return sData.isUniversal; end, Patched = function(sData) return sData.isPatched; end, Paid = function(sData) return sData.scriptType == "paid"; end }; local verifyicon = utf8.char(57344); local Trending = game:HttpGet("https://scriptblox.com/api/script/fetch");
		local function Update()
			for _, v in pairs(Search.Scripts:GetChildren()) do if v:IsA("CanvasGroup") then v:Destroy(); end end
			local text = Search.TextBox.Text; local isEmpty = # (string.gsub(text, "[%s]", "")) <= 0; local search = game.HttpService:UrlEncode(text); local scriptJson; if isEmpty then scriptJson = Trending; else scriptJson = game:HttpGet("https://scriptblox.com/api/script/search?strict=true&q=" .. search .. "&max=20"); end
			local success, scripts = pcall(function() return game:GetService("HttpService"):JSONDecode(scriptJson); end); if (not success or not scripts.result or (# scripts.result.scripts <= 0)) then Search.TextBox.Text = "No results found."; return; end
			for i, scriptData in pairs(scripts.result.scripts) do task.spawn(function() local new = script.SearchTemplate:Clone(); new.Parent = Search.Scripts; new.Name = scriptData.title; new.Title.Text = scriptData.title .. ((scriptData.verified and verifyicon) or ""); new.Misc.Thumbnail.Image = scriptData.imageUrl or "rbxassetid://109798560145884"; for _, tag in pairs(new.Tags:GetChildren()) do if tag:IsA("TextLabel") then tag.Visible = (TagsValid[tag.Name] and TagsValid[tag.Name](scriptData)) or false; end end new.Misc.Panel.Execute.MouseButton1Click:Connect(function() UIEvents.Executor.RunCode(scriptData.script)(); end); new.Misc.Panel.Save.MouseButton1Click:Connect(function() UIEvents.Saved.SaveFile(scriptData.title, scriptData.script); end); end); end
		end
		Search.TextBox.FocusLost:Connect(function() Update(); end);
	end;
	InitTabs.Nav = function()
		local isInstantNext = false; local function findButton(Name) for _, frame in ipairs(Nav:GetChildren()) do if not frame:IsA("Frame") then continue; end for _, button in ipairs(frame:GetChildren()) do if not button:IsA("TextButton") then continue; end if (button.Name == Name) then return button; end end end end return nil; end
		local function goTo(Name, f) if Data.Editor.EditingSavedFile and Name ~= "Editor" then local editingName = Data.Editor.EditingSavedFile; createNotification("Editing Cancelled", "Warn", 3); CLONED_Detectedly.delfile("scripts/" .. editingName .. ".lua"); Data.Editor.Tabs[editingName] = nil; Data.Editor.EditingSavedFile = nil; UIEvents.EditorTabs.updateUI(); if Name ~= "Saved" then Name = "Saved" end end if Pages:FindFirstChild(Name) then Pages.UIPageLayout:JumpTo(Pages[Name]); end local Button = findButton(Name); if not Button then return; end Pages.Visible = true; EnableFrame.Visible = true; local TargetSize = UDim2.new(0, Button.AbsoluteSize.X, 0, Button.AbsoluteSize.Y); local TargetPosition = Button.AbsolutePosition - EnableFrame.Parent.AbsolutePosition; local TargetPos = UDim2.new(0, TargetPosition.X, 0, TargetPosition.Y); if (f or isInstantNext) then EnableFrame.Position = TargetPos; EnableFrame.Size = TargetSize; if isInstantNext then isInstantNext = false; end return; end TweenService:Create(EnableFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = TargetPos, Size = TargetSize, BackgroundTransparency = 0 }):Play(); end
		for _, frame in ipairs(Nav:GetChildren()) do if frame:IsA("Frame") then for _, button in ipairs(frame:GetChildren()) do if button:IsA("TextButton") then button.MouseButton1Click:Connect(function() goTo(button.Name); end); end end end end task.wait(1); goTo("Home", true);
	end;
	
	-- [[ EXECUTE ON LOAD ]]
	local Loaded = false; 
	local function loadUI() 
		if Loaded then return; end 
		script.Parent.Enabled = true -- SHOW MAIN GUI
		Main.Visible = true
		for _, f in pairs(InitTabs) do task.spawn(f); end 
		Loaded = true; 
	end
	
	local function closeUI() Main.EnableFrame.Visible = false; hideUI(false); script.Parent.Open.Visible = true end
	local function openUI() hideUI(true); Main.EnableFrame.Visible = true; script.Parent.Open.Visible = false end
	Leftside.Close.MouseButton1Click:Connect(closeUI); script.Parent.Open.Activated:Connect(openUI);
	local function dragify(Frame) local dragToggle, dragStart, startPos, dragInput; local function updateInput(input) local Delta = input.Position - dragStart; Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y); end Frame.InputBegan:Connect(function(input) if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then dragToggle = true; dragStart = input.Position; startPos = Frame.Position; input.Changed:Connect(function() if (input.UserInputState == Enum.UserInputState.End) then dragToggle = false end end) end end); Frame.InputChanged:Connect(function(input) if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then dragInput = input end end); UserInputService.InputChanged:Connect(function(input) if (input == dragInput and dragToggle) then updateInput(input) end end); end
	dragify(Main); dragify(script.Parent.Open);

	-- =========================================================================
	-- [[ MERGED KEY SYSTEM & LOADER LOGIC ]]
	-- =========================================================================
	task.spawn(function()
		local Players = game:GetService("Players")
		local TweenService = game:GetService("TweenService")
		local StarterGui = game:GetService("StarterGui")
		local UserInputService = game:GetService("UserInputService")
		local CoreGui = game:GetService("CoreGui")
		local ContentProvider = game:GetService("ContentProvider")
		local VirtualUser = game:GetService("VirtualUser") 
		local LocalPlayer = Players.LocalPlayer
		local HttpService = game:GetService("HttpService")
		local RbxAnalytics = game:GetService("RbxAnalyticsService")

		local SECRET_DEV_KEY = "PUNK-X-8B29-4F1A-9C3D-7E11" 
		local KEY_FILE_NAME = "punk-x-key.txt"
		local UI_CONFIG = { Title = "PUNK X", Version = "v21.4", AccentColor = Color3.fromRGB(0, 120, 255), BgColor = Color3.fromRGB(20, 20, 23), InputColor = Color3.fromRGB(30, 30, 35), DiscordColor = Color3.fromRGB(88, 101, 242), Font = Enum.Font.GothamBold, FontRegular = Enum.Font.GothamMedium, DiscordLink = "https://discord.gg/JxEjAtdgWD", BackgroundImage = "rbxthumb://type=Asset&id=83372655709716&w=768&h=432", IconImage = "rbxthumb://type=Asset&id=128877949924034&w=150&h=150" }
		local SOUNDS = { Click = 4590657391, Success = 4590662766, Error = 550209561 }
		local CURRENT_KEY = "" 

		local function GetSecureParent() if gethui then return gethui() elseif CoreGui:FindFirstChild("RobloxGui") then return CoreGui else return LocalPlayer:WaitForChild("PlayerGui") end end
		local function Notify(title, text, duration) StarterGui:SetCore("SendNotification", { Title = title, Text = text, Duration = duration or 3, Icon = UI_CONFIG.IconImage }) end
		local function PlaySound(id, volume) task.spawn(function() local s = Instance.new("Sound"); s.SoundId = "rbxassetid://" .. tostring(id); s.Volume = volume or 1; s.Parent = game:GetService("SoundService"); s.PlayOnRemove = true; s:Destroy() end) end
		local function ShakeUI(guiObject) local originalPos = guiObject.Position; local duration = 0.05; local intensity = 5; for i = 1, 6 do local offset = (i % 2 == 0 and -intensity or intensity); TweenService:Create(guiObject, TweenInfo.new(duration), { Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + offset, originalPos.Y.Scale, originalPos.Y.Offset) }):Play(); task.wait(duration) end TweenService:Create(guiObject, TweenInfo.new(duration), {Position = originalPos}):Play() end
		
		-- // INTEGRATED KEY SYSTEM //
		local KeyLib = {}
		local CONFIG = { serviceId = "punk-x-release-key", fileName = KEY_FILE_NAME, autoSave = true } 
		local httpRequest = (syn and syn.request) or (http and http.request) or request or http_request
		local function getHWID() if gethwid then return gethwid() end return RbxAnalytics:GetClientId() end
		function KeyLib.GetKeyURL() return "https://pandadevelopment.net/getkey?service=" .. CONFIG.serviceId .. "&hwid=" .. getHWID() end
		function KeyLib.Validate(key)
			if not httpRequest then return false, "Executor missing HTTP" end
			if not key then return false, "No key provided" end
			key = key:gsub(" ", ""):gsub("\n", "")
			local url = "https://pandadevelopment.net/v2_validation?service=" .. CONFIG.serviceId .. "&key=" .. key .. "&hwid=" .. getHWID()
			local success, response = pcall(function() return httpRequest({ Url = url, Method = "GET", Headers = { ["User-Agent"] = "PunkX-Loader" } }) end)
			if not success or not response then return false, "Connection Error" end
			local data = nil; pcall(function() data = HttpService:JSONDecode(response.Body) end)
			if not data then return false, "Invalid JSON" end
			if data.V2_Authentication == "success" then if CONFIG.autoSave and writefile then pcall(function() writefile(CONFIG.fileName, key) end) end return true, data else return false, data.V2_Authentication end
		end
		function KeyLib.GetSavedKey() if isfile and readfile and isfile(CONFIG.fileName) then local success, content = pcall(function() return readfile(CONFIG.fileName) end) if success and #content > 1 then return content end end return nil end

		-- // HELPER FUNCTIONS //
		local function SetExpiryData(data)
			local expiryText = "Active"
			if data and type(data) == "table" then if data.Key_Information and data.Key_Information.expiresAt then expiryText = data.Key_Information.expiresAt elseif data.expiresAt then expiryText = data.expiresAt end end
			if getgenv then getgenv().PUNK_X_EXPIRY = expiryText end; _G.PUNK_X_EXPIRY = expiryText
			-- Update UI
			if Pages and Pages:FindFirstChild("Home") and Pages.Home:FindFirstChild("Key") then Pages.Home.Key.KeyText.Text = 'Your key is <font color="rgb(125, 255, 125)">ACTIVE</font>.'; Pages.Home.Key.Duration.Text = expiryText; end
		end

		local function LaunchPunkX(passedKey)
			if getgenv then getgenv().PUNK_X_KEY = passedKey end; _G.PUNK_X_KEY = passedKey 
			-- [[ ACTIVATE MAIN UI HERE ]]
			KeyVailded = true
			loadUI()
		end

		-- // BUILD LOADER UI //
		local LoaderGui = Instance.new("ScreenGui"); LoaderGui.Name = "PunkX_Loader"; LoaderGui.Parent = GetSecureParent(); LoaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; LoaderGui.ResetOnSpawn = false; LoaderGui.IgnoreGuiInset = true 
		local Blur = Instance.new("BlurEffect", game.Lighting); Blur.Name = "PunkX_Blur"; Blur.Size = 0 
		local MainFrame = Instance.new("Frame", LoaderGui); MainFrame.Size = UDim2.new(0, 0, 0, 0); MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); MainFrame.AnchorPoint = Vector2.new(0.5, 0.5); MainFrame.BackgroundColor3 = UI_CONFIG.BgColor; MainFrame.ClipsDescendants = true; Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16); local Stroke = Instance.new("UIStroke", MainFrame); Stroke.Color = UI_CONFIG.AccentColor; Stroke.Thickness = 1.5; Stroke.Transparency = 1;
		local BgImage = Instance.new("ImageLabel", MainFrame); BgImage.Size = UDim2.new(1, 0, 1, 0); BgImage.BackgroundTransparency = 1; BgImage.Image = UI_CONFIG.BackgroundImage; BgImage.ScaleType = Enum.ScaleType.Crop; BgImage.ImageColor3 = Color3.fromRGB(150, 150, 150); BgImage.ZIndex = 1; Instance.new("UICorner", BgImage).CornerRadius = UDim.new(0, 16);
		local Title = Instance.new("TextLabel", MainFrame); Title.Text = UI_CONFIG.Title; Title.Font = UI_CONFIG.Font; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.TextSize = 24; Title.Size = UDim2.new(0.6, 0, 0.25, 0); Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0.05, 0, 0.05, 0); Title.TextXAlignment = Enum.TextXAlignment.Left; Title.ZIndex = 2 
		local InputContainer = Instance.new("Frame", MainFrame); InputContainer.Size = UDim2.new(0.85, 0, 0.22, 0); InputContainer.Position = UDim2.new(0.5, 0, 0.45, 0); InputContainer.AnchorPoint = Vector2.new(0.5, 0); InputContainer.BackgroundColor3 = UI_CONFIG.InputColor; InputContainer.BackgroundTransparency = 0.2; InputContainer.ZIndex = 2; Instance.new("UICorner", InputContainer).CornerRadius = UDim.new(0, 10);
		local KeyBox = Instance.new("TextBox", InputContainer); KeyBox.Size = UDim2.new(0.8, 0, 1, 0); KeyBox.Position = UDim2.new(0.05, 0, 0, 0); KeyBox.BackgroundTransparency = 1; KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255); KeyBox.PlaceholderText = "Paste your key here..."; KeyBox.Font = UI_CONFIG.FontRegular; KeyBox.TextSize = 14; KeyBox.TextXAlignment = Enum.TextXAlignment.Left; KeyBox.ZIndex = 3; KeyBox.ClearTextOnFocus = false; KeyBox.Text = "" 
		local PasteBtn = Instance.new("TextButton", InputContainer); PasteBtn.Size = UDim2.new(0.15, 0, 0.8, 0); PasteBtn.Position = UDim2.new(0.98, 0, 0.5, 0); PasteBtn.AnchorPoint = Vector2.new(1, 0.5); PasteBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55); PasteBtn.Text = "PASTE"; PasteBtn.TextColor3 = UI_CONFIG.AccentColor; PasteBtn.Font = UI_CONFIG.Font; PasteBtn.TextSize = 9; PasteBtn.ZIndex = 4; Instance.new("UICorner", PasteBtn).CornerRadius = UDim.new(0, 6);
		local BtnContainer = Instance.new("Frame", MainFrame); BtnContainer.Size = UDim2.new(0.85, 0, 0.18, 0); BtnContainer.Position = UDim2.new(0.5, 0, 0.75, 0); BtnContainer.AnchorPoint = Vector2.new(0.5, 0); BtnContainer.BackgroundTransparency = 1; BtnContainer.ZIndex = 2;
		local GetKeyBtn = Instance.new("TextButton", BtnContainer); GetKeyBtn.Size = UDim2.new(0.47, 0, 1, 0); GetKeyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45); GetKeyBtn.Text = "Get Key"; GetKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200); GetKeyBtn.Font = UI_CONFIG.Font; GetKeyBtn.TextSize = 14; GetKeyBtn.ZIndex = 3; Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 8);
		local RedeemBtn = Instance.new("TextButton", BtnContainer); RedeemBtn.Size = UDim2.new(0.47, 0, 1, 0); RedeemBtn.Position = UDim2.new(1, 0, 0, 0); RedeemBtn.AnchorPoint = Vector2.new(1, 0); RedeemBtn.BackgroundColor3 = UI_CONFIG.AccentColor; RedeemBtn.Text = "Redeem"; RedeemBtn.TextColor3 = Color3.fromRGB(255, 255, 255); RedeemBtn.Font = UI_CONFIG.Font; RedeemBtn.TextSize = 14; RedeemBtn.ZIndex = 3; Instance.new("UICorner", RedeemBtn).CornerRadius = UDim.new(0, 8);
		local StatusText = Instance.new("TextLabel", MainFrame); StatusText.Size = UDim2.new(1, 0, 0.1, 0); StatusText.Position = UDim2.new(0, 0, 0.92, 0); StatusText.BackgroundTransparency = 1; StatusText.Text = "Status: Waiting for key"; StatusText.TextColor3 = Color3.fromRGB(200, 200, 200); StatusText.Font = Enum.Font.Gotham; StatusText.TextSize = 11; StatusText.ZIndex = 2;

		local function TweenObj(obj, props, time) TweenService:Create(obj, TweenInfo.new(time or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play() end
		local function OpenLoader() MainFrame.Visible = true; TweenObj(Blur, {Size = 15}, 0.5); TweenObj(MainFrame, {Size = UDim2.new(0.5, 0, 0.45, 0)}, 0.4); TweenObj(Stroke, {Transparency = 0.5}, 0.8) end
		local function CloseLoader() TweenObj(Blur, {Size = 0}, 0.5); TweenObj(MainFrame, {Position = UDim2.new(0.5, 0, 1.5, 0)}, 0.6); task.wait(0.6); Blur:Destroy(); LoaderGui:Destroy() end

		-- LOGIC
		PasteBtn.MouseButton1Click:Connect(function() if getclipboard then local clip = getclipboard() if clip and clip ~= "" then KeyBox.Text = clip; KeyBox:ReleaseFocus(); PlaySound(SOUNDS.Click) else StatusText.Text = "Clipboard Empty!"; PlaySound(SOUNDS.Error) end else StatusText.Text = "Not Supported!"; PlaySound(SOUNDS.Error) end end)
		GetKeyBtn.MouseButton1Click:Connect(function() PlaySound(SOUNDS.Click); if setclipboard then setclipboard(KeyLib.GetKeyURL()); GetKeyBtn.Text = "Copied!"; Notify("Punk X", "Key Link Copied!", 3) else print("Key URL:", KeyLib.GetKeyURL()) end task.wait(1.5); GetKeyBtn.Text = "Get Key" end)
		
		local isChecking = false
		RedeemBtn.MouseButton1Click:Connect(function()
			if isChecking then return end
			isChecking = true
			StatusText.Text = "Checking..."
			StatusText.TextColor3 = Color3.fromRGB(255, 200, 50)
			local key = KeyBox.Text:gsub("%s+", "") 
			-- DEV
			if key == SECRET_DEV_KEY then PlaySound(SOUNDS.Success); StatusText.Text = "Developer Mode"; if writefile then pcall(function() writefile(KEY_FILE_NAME, key) end) end CURRENT_KEY = key; CloseLoader(); LaunchPunkX(key); return end
			-- NORMAL
			local success, valid, data = pcall(function() return KeyLib.Validate(key) end)
			if success and valid then PlaySound(SOUNDS.Success); if writefile then pcall(function() writefile(KEY_FILE_NAME, key) end) end SetExpiryData(data); Notify("Punk X", "Access Granted!", 2); CURRENT_KEY = key; CloseLoader(); LaunchPunkX(key); else PlaySound(SOUNDS.Error); StatusText.Text = (success and "Invalid Key" or "Connection Error"); StatusText.TextColor3 = Color3.fromRGB(255, 80, 80); KeyBox.Text = ""; isChecking = false; RedeemBtn.Text = "Redeem" end
		end)

		-- AUTO LOGIN
		local autoLogged = false
		local saved = KeyLib.GetSavedKey()
		if saved then
			if saved == SECRET_DEV_KEY then CURRENT_KEY = saved; LaunchPunkX(saved); LoaderGui:Destroy(); Blur:Destroy(); autoLogged = true; return end
			local success, valid, data = pcall(function() return KeyLib.Validate(saved) end)
			if success and valid then CURRENT_KEY = saved; SetExpiryData(data); LaunchPunkX(saved); LoaderGui:Destroy(); Blur:Destroy(); autoLogged = true; return end
		end

		if not autoLogged then OpenLoader() end
	end)
end
C_2()
