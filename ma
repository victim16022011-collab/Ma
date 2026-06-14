-- ==================================================
-- Phien ban: Amethyst Hub Toi Thuong (BAN TREO DEM SIEU GON)
-- Ban Quyen: HUYKOGIAUVN
-- Cap nhat: Server Hop quet cuc ky, Tu lat trang neu server day.
-- Cap nhat: Bang Settings Sieu VIP (Glassmorphism, Am thanh, Tween Hover)
-- Cap nhat: FIX LAG Auto Ne V2 (Bo nho dem Cache Spawns) + Fix Loi Khong Tele
-- Cap nhat: Them Muc Setting (Tu dong LUU CAU HINH NO LAG + Chuyen Ngon Ngu VN/EN)
-- Cap nhat: FIX LOI DELAY TELEPORT CUA AUTO NE V2 + THEM 7 BAI NHAC MOI
-- Cap nhat: GHIM MUOT KILLER V1 (Bam dinh lung deo ca giut) + Bo Tu Dien UI Skill Sat Nhan
-- Cap nhat: Auto Farm Level V1 (Tu dong doi tuong chua max khi con dang xai da lv100)
-- Cap nhat: Bat san Auto Level V1, Xoa UI Collection, CHI CHO PHEP DOI O LOBBY
-- Cap nhat: Them dan ID Nhac Custom (Tu de nhac mac dinh khi phat)
-- Cap nhat: BO LOC CHONG LAG SMART COOLDOWN V2 (Theo doi hoi chieu)
-- Cap nhat: Tra lai AUTO FARM KILLER V1 (Dung 1 chieu co ban) nam chung voi V2
-- Cap nhat: SUA LOI LAG V1 & V2 (Tach luong quet UI 4Hz giam 95% tai CPU)
-- Cap nhat: Them muc AUTO SERVER HOP (V1 Mac Dinh / V2 Sieu muot Ping <120)
-- Cap nhat: Bo sung "Hop Sau 10 Phut" vao he thong Auto Hop
-- Cap nhat BAN FREE: Them Fix Lag (Xoa do hoa) va Anti-Ban V4
-- Cap nhat MOI NHAT: AUTO FARM V2.5 (Delay roi 0.75s, Sua vach 0.75s, Xoa dong cung)
-- Cap nhat FIX TELEPORT: Su dung PivotTo va xoa sach van toc de chong server ket noi nguoc (rubberbanding).
-- ==================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ================= [HE THONG AM THANH UI] =================
local CoreGui = game:GetService("CoreGui")
local SFXFolder = Instance.new("Folder")
SFXFolder.Name = "AmethystSFX"
SFXFolder.Parent = CoreGui

local HoverSound = Instance.new("Sound")
HoverSound.SoundId = "rbxassetid://876939830"
HoverSound.Volume = 0.5
HoverSound.Parent = SFXFolder

local ToggleOnSound = Instance.new("Sound")
ToggleOnSound.SoundId = "rbxassetid://6042053626"
ToggleOnSound.Volume = 1
ToggleOnSound.PlaybackSpeed = 1
ToggleOnSound.Parent = SFXFolder

local ToggleOffSound = Instance.new("Sound")ToggleOffSound.SoundId = "rbxassetid://6042053626"
ToggleOffSound.Volume = 1
ToggleOffSound.PlaybackSpeed = 0.8
ToggleOffSound.Parent = SFXFolder

local PopupSound = Instance.new("Sound")
PopupSound.SoundId = "rbxassetid://6895079853"
PopupSound.Volume = 0.8
PopupSound.Parent = SFXFolder

local function PlaySound(snd)
    pcall(function()
        local s = snd:Clone()
        s.Parent = SFXFolder
        s:Play()
        s.Ended:Connect(function() s:Destroy() end)
    end)
end

-- ======================================================================
-- BANG 1: HUTAO UI SYSTEM (MAIN HUB TOI THUONG)
-- ======================================================================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("ImageLabel")
local StatusLabel = Instance.new("TextLabel")
local GeneralLabel = Instance.new("TextLabel")
local MoneyLabel = Instance.new("TextLabel")
local TimeLabel = Instance.new("TextLabel")
local TitleLabel = Instance.new("TextLabel")
local ToggleButton = Instance.new("ImageButton")
local ToggleCorner = Instance.new("UICorner")

ScreenGui.Name = "AmethystHubUI"
ScreenGui.Parent = CoreGui

ToggleButton.Name = "ToggleUI"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundTransparency = 0.0
ToggleButton.Position = UDim2.new(0, 20, 0.4, 0)
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Image = "rbxassetid://94506254187483"
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    ToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BackgroundTransparency = 1.000
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Image = "rbxassetid://105006398248081"
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BackgroundTransparency = 0.2

local GearIcon = Instance.new("ImageLabel")
GearIcon.Name = "SettingsGear"
GearIcon.Parent = MainFrame
GearIcon.BackgroundTransparency = 1.0
GearIcon.Position = UDim2.new(1, -90, 0, 0)
GearIcon.Size = UDim2.new(0, 90, 0, 90)
GearIcon.Image = "rbxassetid://112198540696715"

local GearButton = Instance.new("ImageButton")
GearButton.Name = "GearActButton"
GearButton.Parent = GearIcon
GearButton.BackgroundTransparency = 1.0
GearButton.Size = UDim2.new(1, 0, 1, 0)GearButton.ZIndex = 2

TitleLabel.Name = "Title"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.BackgroundTransparency = 1.000
TitleLabel.Position = UDim2.new(0, 0, 0.05, 0)
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Font = Enum.Font.FredokaOne
TitleLabel.Text = "AMETHYST HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 85, 255)
TitleLabel.TextSize = 36.000
TitleLabel.TextStrokeTransparency = 0.000

StatusLabel.Name = "Status"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.BackgroundTransparency = 1.000
StatusLabel.Position = UDim2.new(0, 0, 0.35, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Font = Enum.Font.SourceSansBold
StatusLabel.Text = "Status: Dang khoi dong..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 24.000
StatusLabel.TextStrokeTransparency = 0.500

GeneralLabel.Name = "General"
GeneralLabel.Parent = MainFrame
GeneralLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GeneralLabel.BackgroundTransparency = 1.000
GeneralLabel.Position = UDim2.new(0, 0, 0.45, 0)
GeneralLabel.Size = UDim2.new(1, 0, 0, 30)
GeneralLabel.Font = Enum.Font.SourceSansBold
GeneralLabel.Text = "General: Loading..."
GeneralLabel.TextColor3 = Color3.fromRGB(255, 255, 127)
GeneralLabel.TextSize = 24.000
GeneralLabel.TextStrokeTransparency = 0.500

MoneyLabel.Name = "Money"
MoneyLabel.Parent = MainFrame
MoneyLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MoneyLabel.BackgroundTransparency = 1.000
MoneyLabel.Position = UDim2.new(0, 0, 0.55, 0)
MoneyLabel.Size = UDim2.new(1, 0, 0, 30)
MoneyLabel.Font = Enum.Font.SourceSansBold
MoneyLabel.Text = "Money: Loading..."
MoneyLabel.TextColor3 = Color3.fromRGB(85, 255, 127)
MoneyLabel.TextSize = 24.000
MoneyLabel.TextStrokeTransparency = 0.500
TimeLabel.Name = "Time"
TimeLabel.Parent = MainFrame
TimeLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TimeLabel.BackgroundTransparency = 1.000
TimeLabel.Position = UDim2.new(0, 0, 0.75, 0)
TimeLabel.Size = UDim2.new(1, 0, 0, 30)
TimeLabel.Font = Enum.Font.SourceSansBold
TimeLabel.Text = "Time: 00:00:00"
TimeLabel.TextColor3 = Color3.fromRGB(255, 170, 255)
TimeLabel.TextSize = 24.000
TimeLabel.TextStrokeTransparency = 0.500

-- ======================================================================
-- [VIP SYSTEM] MENU SETTINGS MAIN HUB
-- ======================================================================
getgenv().AutoFarm_V1 = true
getgenv().AutoFarm_V2 = false
getgenv().AutoEvade_V1 = true
getgenv().AutoEvade_V2 = false
getgenv().AutoFarm_Killer_V1 = false
getgenv().AutoFarm_Killer_V2 = false
getgenv().AutoFarm_Level_V1 = true
getgenv().AutoHop_V1 = true
getgenv().AutoHop_V2 = false
getgenv().AutoHop_TimeLimit = false
getgenv().FixLagEnabled = false
getgenv().MusicEnabled = true
getgenv().MusicVolumePercent = 60
getgenv().CurrentSongIndex = 1
getgenv().AutoSave = true
getgenv().LanguageIndex = 1

-- [NEW STATE CHO CUSTOM NHAC]
getgenv().IsUsingCustomMusic = false
getgenv().CustomMusicID = ""
getgenv().SongList = {
    {Name = "Cau ca van can", ID = "rbxassetid://124384558101360"},
    {Name = "Ai dua em ve", ID = "rbxassetid://110919391228823"},
    {Name = "Kho ga", ID = "rbxassetid://99152674992699"},
    {Name = "Bad Ending Funk", ID = "rbxassetid://135526249310486"},
    {Name = "KMI O KOTO M2", ID = "rbxassetid://131532883177579"},
    {Name = "MTGUAG DAN5", ID = "rbxassetid://80197259053353"},
    {Name = "Mot bai hat rat hay", ID = "rbxassetid://80442979651569"},
    {Name = "EMAPLAY NES5", ID = "rbxassetid://137973644565139"},
    {Name = "Rose love Siluo", ID = "rbxassetid://134140709844049"},
    {Name = "Rock that body", ID = "rbxassetid://75918642768991"},
    {Name = "BDOWYOU", ID = "rbxassetid://117061993775129"}
}

getgenv().LangList = {    {Name = "Tieng Viet (VN)", ID = "VN"},
    {Name = "English (EN)", ID = "EN"}
}

local SaveFileName = "AmethystHub_SavedSettings.json"

local function LoadSettings()
    if readfile and isfile and isfile(SaveFileName) then
        pcall(function()
            local data = HttpService:JSONDecode(readfile(SaveFileName))
            if data then
                if data.AutoFarm_V1 ~= nil then getgenv().AutoFarm_V1 = data.AutoFarm_V1 end
                if data.AutoFarm_V2 ~= nil then getgenv().AutoFarm_V2 = data.AutoFarm_V2 end
                if data.AutoEvade_V1 ~= nil then getgenv().AutoEvade_V1 = data.AutoEvade_V1 end
                if data.AutoEvade_V2 ~= nil then getgenv().AutoEvade_V2 = data.AutoEvade_V2 end
                if data.AutoFarm_Killer_V1 ~= nil then getgenv().AutoFarm_Killer_V1 = data.AutoFarm_Killer_V1 end
                if data.AutoFarm_Killer_V2 ~= nil then getgenv().AutoFarm_Killer_V2 = data.AutoFarm_Killer_V2 end
                if data.AutoFarm_Level_V1 ~= nil then getgenv().AutoFarm_Level_V1 = data.AutoFarm_Level_V1 end
                if data.AutoHop_V1 ~= nil then getgenv().AutoHop_V1 = data.AutoHop_V1 end
                if data.AutoHop_V2 ~= nil then getgenv().AutoHop_V2 = data.AutoHop_V2 end
                if data.AutoHop_TimeLimit ~= nil then getgenv().AutoHop_TimeLimit = data.AutoHop_TimeLimit end
                if data.FixLagEnabled ~= nil then getgenv().FixLagEnabled = data.FixLagEnabled end
                if data.MusicEnabled ~= nil then getgenv().MusicEnabled = data.MusicEnabled end
                if data.MusicVolumePercent ~= nil then getgenv().MusicVolumePercent = data.MusicVolumePercent end
                if data.CurrentSongIndex ~= nil then getgenv().CurrentSongIndex = data.CurrentSongIndex end
                if data.AutoSave ~= nil then getgenv().AutoSave = data.AutoSave end
                if data.LanguageIndex ~= nil then getgenv().LanguageIndex = data.LanguageIndex end
            end
        end)
    end
end

LoadSettings()

task.spawn(function()
    local lastSave = ""
    while task.wait(3) do
        if getgenv().AutoSave then
            pcall(function()
                local currentData = HttpService:JSONEncode({
                    AutoFarm_V1 = getgenv().AutoFarm_V1,
                    AutoFarm_V2 = getgenv().AutoFarm_V2,
                    AutoEvade_V1 = getgenv().AutoEvade_V1,
                    AutoEvade_V2 = getgenv().AutoEvade_V2,
                    AutoFarm_Killer_V1 = getgenv().AutoFarm_Killer_V1,
                    AutoFarm_Killer_V2 = getgenv().AutoFarm_Killer_V2,
                    AutoFarm_Level_V1 = getgenv().AutoFarm_Level_V1,
                    AutoHop_V1 = getgenv().AutoHop_V1,
                    AutoHop_V2 = getgenv().AutoHop_V2,
                    AutoHop_TimeLimit = getgenv().AutoHop_TimeLimit,                    FixLagEnabled = getgenv().FixLagEnabled,
                    MusicEnabled = getgenv().MusicEnabled,
                    MusicVolumePercent = getgenv().MusicVolumePercent,
                    CurrentSongIndex = getgenv().CurrentSongIndex,
                    AutoSave = getgenv().AutoSave,
                    LanguageIndex = getgenv().LanguageIndex
                })
                if currentData ~= lastSave then
                    if writefile then writefile(SaveFileName, currentData) end
                    lastSave = currentData
                end
            end)
        end
    end
end)

local SettingsFrame = Instance.new("Frame")
local SettingsCorner = Instance.new("UICorner")
local SettingsStroke = Instance.new("UIStroke")
local SettingsTitle = Instance.new("TextLabel")
local SettingsTitleGradient = Instance.new("UIGradient")
local CloseButton = Instance.new("TextButton")
local CloseCorner = Instance.new("UICorner")
local CloseStroke = Instance.new("UIStroke")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local UIPadding = Instance.new("UIPadding")

SettingsFrame.Name = "AmethystUltraSettingsUI"
SettingsFrame.Parent = ScreenGui
SettingsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
SettingsFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
SettingsFrame.Size = UDim2.new(0, 0, 0, 0)
SettingsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
SettingsFrame.BackgroundTransparency = 0.15
SettingsFrame.BorderSizePixel = 0
SettingsFrame.ClipsDescendants = true
SettingsFrame.Visible = false
SettingsFrame.ZIndex = 10

SettingsCorner.CornerRadius = UDim.new(0, 16)
SettingsCorner.Parent = SettingsFrame

SettingsStroke.Color = Color3.fromRGB(150, 0, 255)
SettingsStroke.Thickness = 2.5
SettingsStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SettingsStroke.Transparency = 0.2
SettingsStroke.Parent = SettingsFrame

task.spawn(function()    local hue = 0
    while task.wait(0.02) do
        if SettingsFrame.Visible then
            hue = hue + 0.005
            if hue > 1 then hue = 0 end
            SettingsStroke.Color = Color3.fromHSV(hue, 0.8, 1)
        end
    end
end)

SettingsTitle.Name = "SettingTitle"
SettingsTitle.Parent = SettingsFrame
SettingsTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SettingsTitle.BackgroundTransparency = 1.000
SettingsTitle.Position = UDim2.new(0, 0, 0, 15)
SettingsTitle.Size = UDim2.new(1, 0, 0, 40)
SettingsTitle.Font = Enum.Font.GothamBlack
SettingsTitle.Text = "AMETHYST QUAN LY TOI THUONG"
SettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsTitle.TextSize = 24.000
SettingsTitle.ZIndex = 11

SettingsTitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(170, 0, 255)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(170, 0, 255))
}
SettingsTitleGradient.Parent = SettingsTitle

CloseButton.Name = "CloseSettings"
CloseButton.Parent = SettingsFrame
CloseButton.AnchorPoint = Vector2.new(1, 0)
CloseButton.Position = UDim2.new(1, -15, 0, 15)
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.BackgroundColor3 = Color3.fromRGB(30, 20, 25)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.TextSize = 20.000
CloseButton.ZIndex = 12

CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseButton

CloseStroke.Color = Color3.fromRGB(255, 100, 100)
CloseStroke.Thickness = 1.5
CloseStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
CloseStroke.Transparency = 0.3
CloseStroke.Parent = CloseButton
CloseButton.MouseEnter:Connect(function()
    PlaySound(HoverSound)
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 50, 50), TextColor3 = Color3.fromRGB(255,255,255)}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 20, 25), TextColor3 = Color3.fromRGB(255, 100, 100)}):Play()
end)

ScrollingFrame.Name = "ContentScroll"
ScrollingFrame.Parent = SettingsFrame
ScrollingFrame.Active = true
ScrollingFrame.BackgroundTransparency = 1.000
ScrollingFrame.Position = UDim2.new(0, 0, 0, 70)
ScrollingFrame.Size = UDim2.new(1, 0, 1, -80)
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 0, 255)
ScrollingFrame.ZIndex = 11
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 12)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

UIPadding.Parent = ScrollingFrame
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 20)

local function ToggleSettings(show)
    if show then
        PlaySound(PopupSound)
        SettingsFrame.Visible = true
        local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
        local tween = TweenService:Create(SettingsFrame, tweenInfo, {Size = UDim2.new(0, 580, 0.85, 0)})
        tween:Play()
    else
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local tween = TweenService:Create(SettingsFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)})
        tween:Play()
        tween.Completed:Connect(function()
            SettingsFrame.Visible = false
        end)
    end
end

local function CreateSectionHeader(id, text)
    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Name = "Header_" .. id
    HeaderFrame.Parent = ScrollingFrame    HeaderFrame.BackgroundTransparency = 1
    HeaderFrame.Size = UDim2.new(0.92, 0, 0, 35)
    HeaderFrame.ZIndex = 11

    local HeaderText = Instance.new("TextLabel")
    HeaderText.Parent = HeaderFrame
    HeaderText.BackgroundTransparency = 1
    HeaderText.Size = UDim2.new(1, 0, 1, -5)
    HeaderText.Font = Enum.Font.GothamBlack
    HeaderText.Text = text
    HeaderText.TextColor3 = Color3.fromRGB(0, 255, 255)
    HeaderText.TextSize = 16
    HeaderText.TextXAlignment = Enum.TextXAlignment.Left
    HeaderText.ZIndex = 12

    local Line = Instance.new("Frame")
    Line.Parent = HeaderFrame
    Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Line.BorderSizePixel = 0
    Line.Position = UDim2.new(0, 0, 1, -2)
    Line.Size = UDim2.new(1, 0, 0, 2)
    Line.ZIndex = 12

    local LineGradient = Instance.new("UIGradient")
    LineGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(150, 0, 255))
    }
    LineGradient.Parent = Line
end

local function CreateCyberpunkSettingRow(id, titleText, descText, initialState, callback)
    local RowFrame = Instance.new("Frame")
    local RowCorner = Instance.new("UICorner")
    local RowStroke = Instance.new("UIStroke")
    local RowScale = Instance.new("UIScale")
    local IconLabel = Instance.new("TextLabel")
    local Title = Instance.new("TextLabel")
    local Desc = Instance.new("TextLabel")
    local ClickButton = Instance.new("TextButton")
    local SliderBg = Instance.new("Frame")
    local SliderCorner = Instance.new("UICorner")
    local SliderGlow = Instance.new("UIStroke")
    local Knob = Instance.new("Frame")
    local KnobCorner = Instance.new("UICorner")

    RowFrame.Name = "Row_" .. id
    RowFrame.Parent = ScrollingFrame
    RowFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    RowFrame.BackgroundTransparency = 0.4    RowFrame.Size = UDim2.new(0.92, 0, 0, 75)
    RowFrame.ZIndex = 11

    RowCorner.CornerRadius = UDim.new(0, 12)
    RowCorner.Parent = RowFrame

    RowStroke.Color = Color3.fromRGB(80, 80, 120)
    RowStroke.Thickness = 1
    RowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    RowStroke.Transparency = 0.5
    RowStroke.Parent = RowFrame

    RowScale.Scale = 1
    RowScale.Parent = RowFrame

    IconLabel.Parent = RowFrame
    IconLabel.BackgroundTransparency = 1
    IconLabel.Position = UDim2.new(0, 15, 0.5, -20)
    IconLabel.Size = UDim2.new(0, 40, 0, 40)
    IconLabel.Font = Enum.Font.GothamBlack
    IconLabel.Text = id
    IconLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
    IconLabel.TextSize = 28
    IconLabel.ZIndex = 12

    Title.Parent = RowFrame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 65, 0, 15)
    Title.Size = UDim2.new(0, 300, 0, 25)
    Title.Font = Enum.Font.GothamBold
    Title.Text = titleText
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 12

    Desc.Parent = RowFrame
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 65, 0, 40)
    Desc.Size = UDim2.new(0, 350, 0, 20)
    Desc.Font = Enum.Font.GothamMedium
    Desc.Text = descText
    Desc.TextColor3 = Color3.fromRGB(180, 180, 200)
    Desc.TextSize = 13
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.ZIndex = 12

    SliderBg.Parent = RowFrame
    SliderBg.AnchorPoint = Vector2.new(1, 0.5)
    SliderBg.Position = UDim2.new(1, -20, 0.5, 0)    SliderBg.Size = UDim2.new(0, 60, 0, 30)
    SliderBg.ZIndex = 12

    SliderCorner.CornerRadius = UDim.new(1, 0)
    SliderCorner.Parent = SliderBg

    SliderGlow.Thickness = 2
    SliderGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SliderGlow.Parent = SliderBg

    Knob.Parent = SliderBg
    Knob.AnchorPoint = Vector2.new(0, 0.5)
    Knob.Size = UDim2.new(0, 24, 0, 24)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.ZIndex = 13

    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    ClickButton.Parent = RowFrame
    ClickButton.Size = UDim2.new(1, 0, 1, 0)
    ClickButton.BackgroundTransparency = 1
    ClickButton.Text = ""
    ClickButton.ZIndex = 15

    local currentState = initialState

    local function UpdateVisuals(animate)
        local targetBgColor = currentState and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 50, 60)
        local targetGlowColor = currentState and Color3.fromRGB(50, 255, 150) or Color3.fromRGB(80, 80, 100)
        local targetGlowTrans = currentState and 0.2 or 0.8
        local targetKnobPos = currentState and UDim2.new(1, -27, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        local targetTitleColor = currentState and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)

        if animate then
            TweenService:Create(SliderBg, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = targetBgColor}):Play()
            TweenService:Create(SliderGlow, TweenInfo.new(0.3), {Color = targetGlowColor, Transparency = targetGlowTrans}):Play()
            TweenService:Create(Knob, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetKnobPos}):Play()
            TweenService:Create(Title, TweenInfo.new(0.2), {TextColor3 = targetTitleColor}):Play()
        else
            SliderBg.BackgroundColor3 = targetBgColor
            SliderGlow.Color = targetGlowColor
            SliderGlow.Transparency = targetGlowTrans
            Knob.Position = targetKnobPos
            Title.TextColor3 = targetTitleColor
        end
    end

    UpdateVisuals(false)
    ClickButton.MouseEnter:Connect(function()
        PlaySound(HoverSound)
        TweenService:Create(RowScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Scale = 1.02}):Play()
        TweenService:Create(RowStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(150, 100, 255), Transparency = 0}):Play()
        TweenService:Create(RowFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
    end)

    ClickButton.MouseLeave:Connect(function()
        TweenService:Create(RowScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Scale = 1}):Play()
        TweenService:Create(RowStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80, 80, 120), Transparency = 0.5}):Play()
        TweenService:Create(RowFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
    end)

    ClickButton.MouseButton1Click:Connect(function()
        currentState = not currentState
        if currentState then PlaySound(ToggleOnSound) else PlaySound(ToggleOffSound) end
        UpdateVisuals(true)
        if callback then callback(currentState, UpdateVisuals) end
    end)

    return {ForceUpdate = function(state) currentState = state; UpdateVisuals(true) end}
end

local function CreateCyberpunkVolumeRow(id, titleText, descText, initialPercent, callback)
    local RowFrame = Instance.new("Frame")
    local RowCorner = Instance.new("UICorner")
    local RowStroke = Instance.new("UIStroke")
    local IconLabel = Instance.new("TextLabel")
    local Title = Instance.new("TextLabel")
    local Desc = Instance.new("TextLabel")

    RowFrame.Name = "Row_" .. id
    RowFrame.Parent = ScrollingFrame
    RowFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    RowFrame.BackgroundTransparency = 0.4
    RowFrame.Size = UDim2.new(0.92, 0, 0, 75)
    RowFrame.ZIndex = 11

    RowCorner.CornerRadius = UDim.new(0, 12)
    RowCorner.Parent = RowFrame

    RowStroke.Color = Color3.fromRGB(80, 80, 120)
    RowStroke.Thickness = 1
    RowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    RowStroke.Transparency = 0.5
    RowStroke.Parent = RowFrame

    IconLabel.Parent = RowFrame
    IconLabel.BackgroundTransparency = 1
    IconLabel.Position = UDim2.new(0, 15, 0.5, -20)    IconLabel.Size = UDim2.new(0, 40, 0, 40)
    IconLabel.Font = Enum.Font.GothamBlack
    IconLabel.Text = id
    IconLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
    IconLabel.TextSize = 28
    IconLabel.ZIndex = 12

    Title.Parent = RowFrame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 65, 0, 15)
    Title.Size = UDim2.new(0, 300, 0, 25)
    Title.Font = Enum.Font.GothamBold
    Title.Text = titleText
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 12

    Desc.Parent = RowFrame
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 65, 0, 40)
    Desc.Size = UDim2.new(0, 350, 0, 20)
    Desc.Font = Enum.Font.GothamMedium
    Desc.Text = descText
    Desc.TextColor3 = Color3.fromRGB(180, 180, 200)
    Desc.TextSize = 13
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.ZIndex = 12

    local ControlBg = Instance.new("Frame")
    ControlBg.Parent = RowFrame
    ControlBg.AnchorPoint = Vector2.new(1, 0.5)
    ControlBg.Position = UDim2.new(1, -15, 0.5, 0)
    ControlBg.Size = UDim2.new(0, 110, 0, 30)
    ControlBg.BackgroundTransparency = 1
    ControlBg.ZIndex = 12

    local MinusBtn = Instance.new("TextButton")
    MinusBtn.Parent = ControlBg
    MinusBtn.Size = UDim2.new(0, 30, 0, 30)
    MinusBtn.Position = UDim2.new(0, 0, 0, 0)
    MinusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    MinusBtn.Text = "-"
    MinusBtn.Font = Enum.Font.GothamBlack
    MinusBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    MinusBtn.TextSize = 20
    MinusBtn.ZIndex = 13
    Instance.new("UICorner", MinusBtn).CornerRadius = UDim.new(0, 8)
    local MStroke = Instance.new("UIStroke", MinusBtn)
    MStroke.Color = Color3.fromRGB(255, 100, 100)
    local ValLabel = Instance.new("TextLabel")
    ValLabel.Parent = ControlBg
    ValLabel.Size = UDim2.new(0, 50, 0, 30)
    ValLabel.Position = UDim2.new(0, 30, 0, 0)
    ValLabel.BackgroundTransparency = 1
    ValLabel.Text = initialPercent .. "%"
    ValLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    ValLabel.Font = Enum.Font.GothamBold
    ValLabel.TextSize = 14
    ValLabel.ZIndex = 13

    local PlusBtn = Instance.new("TextButton")
    PlusBtn.Parent = ControlBg
    PlusBtn.Size = UDim2.new(0, 30, 0, 30)
    PlusBtn.Position = UDim2.new(0, 80, 0, 0)
    PlusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    PlusBtn.Text = "+"
    PlusBtn.Font = Enum.Font.GothamBlack
    PlusBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    PlusBtn.TextSize = 20
    PlusBtn.ZIndex = 13
    Instance.new("UICorner", PlusBtn).CornerRadius = UDim.new(0, 8)
    local PStroke = Instance.new("UIStroke", PlusBtn)
    PStroke.Color = Color3.fromRGB(100, 255, 100)

    local currentVal = initialPercent

    local function BtnAnim(btn, color)
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = color}):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
    end

    MinusBtn.MouseButton1Click:Connect(function()
        PlaySound(HoverSound)
        task.spawn(BtnAnim, MinusBtn, Color3.fromRGB(255, 100, 100))
        currentVal = math.max(0, currentVal - 10)
        ValLabel.Text = currentVal .. "%"
        if callback then callback(currentVal) end
    end)

    PlusBtn.MouseButton1Click:Connect(function()
        PlaySound(HoverSound)
        task.spawn(BtnAnim, PlusBtn, Color3.fromRGB(100, 255, 100))
        currentVal = math.min(100, currentVal + 10)
        ValLabel.Text = currentVal .. "%"
        if callback then callback(currentVal) end
    end)
end
local function CreateCyberpunkCycleRow(id, titleText, descText, list, initialIndex, callback)
    local RowFrame = Instance.new("Frame")
    local RowCorner = Instance.new("UICorner")
    local RowStroke = Instance.new("UIStroke")
    local IconLabel = Instance.new("TextLabel")
    local Title = Instance.new("TextLabel")
    local Desc = Instance.new("TextLabel")

    RowFrame.Name = "Row_" .. id
    RowFrame.Parent = ScrollingFrame
    RowFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    RowFrame.BackgroundTransparency = 0.4
    RowFrame.Size = UDim2.new(0.92, 0, 0, 75)
    RowFrame.ZIndex = 11

    RowCorner.CornerRadius = UDim.new(0, 12)
    RowCorner.Parent = RowFrame

    RowStroke.Color = Color3.fromRGB(80, 80, 120)
    RowStroke.Thickness = 1
    RowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    RowStroke.Transparency = 0.5
    RowStroke.Parent = RowFrame

    IconLabel.Parent = RowFrame
    IconLabel.BackgroundTransparency = 1
    IconLabel.Position = UDim2.new(0, 15, 0.5, -20)
    IconLabel.Size = UDim2.new(0, 40, 0, 40)
    IconLabel.Font = Enum.Font.GothamBlack
    IconLabel.Text = id
    IconLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
    IconLabel.TextSize = 28
    IconLabel.ZIndex = 12

    Title.Parent = RowFrame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 65, 0, 15)
    Title.Size = UDim2.new(0, 300, 0, 25)
    Title.Font = Enum.Font.GothamBold
    Title.Text = titleText
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 12

    Desc.Parent = RowFrame
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 65, 0, 40)
    Desc.Size = UDim2.new(0, 350, 0, 20)    Desc.Font = Enum.Font.GothamMedium
    Desc.Text = descText
    Desc.TextColor3 = Color3.fromRGB(180, 180, 200)
    Desc.TextSize = 13
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.ZIndex = 12

    local CycleBtn = Instance.new("TextButton")
    CycleBtn.Parent = RowFrame
    CycleBtn.AnchorPoint = Vector2.new(1, 0.5)
    CycleBtn.Position = UDim2.new(1, -15, 0.5, 0)
    CycleBtn.Size = UDim2.new(0, 150, 0, 35)
    CycleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    CycleBtn.Text = " " .. list[initialIndex].Name
    CycleBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
    CycleBtn.Font = Enum.Font.GothamBold
    CycleBtn.TextSize = 13
    CycleBtn.ZIndex = 13
    Instance.new("UICorner", CycleBtn).CornerRadius = UDim.new(0, 8)
    local CStroke = Instance.new("UIStroke", CycleBtn)
    CStroke.Color = Color3.fromRGB(150, 0, 255)
    CStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    CStroke.Thickness = 1.5

    local currentIndex = initialIndex

    CycleBtn.MouseButton1Click:Connect(function()
        PlaySound(HoverSound)
        TweenService:Create(CycleBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(100, 50, 200), TextSize = 11}):Play()
        currentIndex = currentIndex + 1
        if currentIndex > #list then currentIndex = 1 end
        CycleBtn.Text = " " .. list[currentIndex].Name
        if callback then callback(currentIndex) end
        task.wait(0.1)
        TweenService:Create(CycleBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 50), TextSize = 13}):Play()
    end)
end

local function CreateCyberpunkInputRow(id, titleText, descText, placeholder, callback)
    local RowFrame = Instance.new("Frame")
    local RowCorner = Instance.new("UICorner")
    local RowStroke = Instance.new("UIStroke")
    local IconLabel = Instance.new("TextLabel")
    local Title = Instance.new("TextLabel")
    local Desc = Instance.new("TextLabel")

    RowFrame.Name = "Row_" .. id
    RowFrame.Parent = ScrollingFrame
    RowFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    RowFrame.BackgroundTransparency = 0.4    RowFrame.Size = UDim2.new(0.92, 0, 0, 75)
    RowFrame.ZIndex = 11

    RowCorner.CornerRadius = UDim.new(0, 12)
    RowCorner.Parent = RowFrame

    RowStroke.Color = Color3.fromRGB(80, 80, 120)
    RowStroke.Thickness = 1
    RowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    RowStroke.Transparency = 0.5
    RowStroke.Parent = RowFrame

    IconLabel.Parent = RowFrame
    IconLabel.BackgroundTransparency = 1
    IconLabel.Position = UDim2.new(0, 15, 0.5, -20)
    IconLabel.Size = UDim2.new(0, 40, 0, 40)
    IconLabel.Font = Enum.Font.GothamBlack
    IconLabel.Text = id
    IconLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
    IconLabel.TextSize = 28
    IconLabel.ZIndex = 12

    Title.Parent = RowFrame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 65, 0, 15)
    Title.Size = UDim2.new(0, 300, 0, 25)
    Title.Font = Enum.Font.GothamBold
    Title.Text = titleText
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 12

    Desc.Parent = RowFrame
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 65, 0, 40)
    Desc.Size = UDim2.new(0, 350, 0, 20)
    Desc.Font = Enum.Font.GothamMedium
    Desc.Text = descText
    Desc.TextColor3 = Color3.fromRGB(180, 180, 200)
    Desc.TextSize = 13
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.ZIndex = 12

    local InputBg = Instance.new("Frame")
    InputBg.Parent = RowFrame
    InputBg.AnchorPoint = Vector2.new(1, 0.5)
    InputBg.Position = UDim2.new(1, -65, 0.5, 0)
    InputBg.Size = UDim2.new(0, 100, 0, 30)
    InputBg.BackgroundColor3 = Color3.fromRGB(15, 15, 20)    InputBg.ZIndex = 12
    Instance.new("UICorner", InputBg).CornerRadius = UDim.new(0, 6)
    local IStroke = Instance.new("UIStroke", InputBg)
    IStroke.Color = Color3.fromRGB(100, 100, 150)
    IStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local TextBox = Instance.new("TextBox")
    TextBox.Parent = InputBg
    TextBox.Size = UDim2.new(1, 0, 1, 0)
    TextBox.BackgroundTransparency = 1
    TextBox.Font = Enum.Font.GothamMedium
    TextBox.Text = ""
    TextBox.PlaceholderText = placeholder
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.TextSize = 13
    TextBox.ZIndex = 13
    TextBox.ClearTextOnFocus = false

    local PlayBtn = Instance.new("TextButton")
    PlayBtn.Parent = RowFrame
    PlayBtn.AnchorPoint = Vector2.new(1, 0.5)
    PlayBtn.Position = UDim2.new(1, -15, 0.5, 0)
    PlayBtn.Size = UDim2.new(0, 40, 0, 30)
    PlayBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    PlayBtn.Text = ">"
    PlayBtn.Font = Enum.Font.GothamBlack
    PlayBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    PlayBtn.TextSize = 16
    PlayBtn.ZIndex = 13
    Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0, 6)
    local PStroke = Instance.new("UIStroke", PlayBtn)
    PStroke.Color = Color3.fromRGB(100, 255, 100)
    PStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    PlayBtn.MouseButton1Click:Connect(function()
        PlaySound(HoverSound)
        TweenService:Create(PlayBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(100, 255, 100), TextColor3 = Color3.fromRGB(0,0,0)}):Play()
        if callback then callback(TextBox.Text) end
        task.wait(0.1)
        TweenService:Create(PlayBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 50), TextColor3 = Color3.fromRGB(100, 255, 100)}):Play()
    end)

    return TextBox
end

local SliderFarmV1, SliderFarmV2, SliderEvadeV1, SliderEvadeV2, SliderKillerV1, SliderKillerV2, SliderFarmLevelV1
local SliderHopV1, SliderHopV2, SliderHopTime, SliderFixLag

CreateSectionHeader("Sec1", "I: Auto Farm")
SliderFarmV1 = CreateCyberpunkSettingRow("1", "Auto Farm Gen V1", "Om may toi 100%. An toan, truyen thong.", getgenv().AutoFarm_V1, function(state)    getgenv().AutoFarm_V1 = state
    if state then
        getgenv().AutoFarm_V2 = false
        SliderFarmV2.ForceUpdate(false)
    end
end)

SliderFarmV2 = CreateCyberpunkSettingRow("2", "Auto Farm Gen V2.5", "Hit & Run: Sua dong loat cac may, nich tung vach.", getgenv().AutoFarm_V2, function(state)
    getgenv().AutoFarm_V2 = state
    if state then
        getgenv().AutoFarm_V1 = false
        SliderFarmV1.ForceUpdate(false)
    end
end)

CreateSectionHeader("Sec2", "II: Auto Ne Killer")
SliderEvadeV1 = CreateCyberpunkSettingRow("3", "Auto Ne V1 (Can Than)", "Killer vao 20m -> Let tron 6s an toan.", getgenv().AutoEvade_V1, function(state)
    getgenv().AutoEvade_V1 = state
    if state then
        getgenv().AutoEvade_V2 = false
        SliderEvadeV2.ForceUpdate(false)
    end
end)

SliderEvadeV2 = CreateCyberpunkSettingRow("4", "Auto Ne V2 (Ghim May)", "Ap sat 10m -> Tele Spawn xa nhat -> Doi ra 5m ve sua.", getgenv().AutoEvade_V2, function(state)
    getgenv().AutoEvade_V2 = state
    if state then
        getgenv().AutoEvade_V1 = false
        SliderEvadeV1.ForceUpdate(false)
    end
end)

CreateSectionHeader("Sec3", "III: Music")
CreateCyberpunkSettingRow("5", "Bat/Tat Nhac Nen", "Nghe nhac cuc chill.", getgenv().MusicEnabled, function(state)
    getgenv().MusicEnabled = state
    if getgenv().ApplyMusicSettings then getgenv().ApplyMusicSettings() end
end)

CreateCyberpunkVolumeRow("6", "Am Luong Nhac", "Dieu chinh to nho cho phu hop.", getgenv().MusicVolumePercent, function(val)
    getgenv().MusicVolumePercent = val
    if getgenv().ApplyMusicSettings then getgenv().ApplyMusicSettings() end
end)

CreateCyberpunkCycleRow("7", "Chon Bai Hat", "Doi bai hat yeu thich cua ban.", getgenv().SongList, getgenv().CurrentSongIndex, function(index)
    getgenv().CurrentSongIndex = index
    getgenv().IsUsingCustomMusic = false
    if getgenv().ApplyMusicSettings then getgenv().ApplyMusicSettings() end
end)

CreateCyberpunkInputRow("8", "Nhac Custom (ID)", "Dan ID nhac va nhan nut > de phat de len nhac co san.", "Nhap ID...", function(text)    local id = text:gsub("%D", "")
    if id ~= "" then
        getgenv().IsUsingCustomMusic = true
        getgenv().CustomMusicID = "rbxassetid://" .. id
        if getgenv().ApplyMusicSettings then getgenv().ApplyMusicSettings() end
        pcall(function()
            game.StarterGui:SetCore("SendNotification", {Title = "Nhac Custom", Text = "Dang phat ID: " .. id, Duration = 5})
        end)
    else
        pcall(function()
            game.StarterGui:SetCore("SendNotification", {Title = "Loi", Text = "Vui long nhap ID hop le!", Duration = 3})
        end)
    end
end)

CreateSectionHeader("Sec4", "IV: Auto Farm Killer")
SliderKillerV1 = CreateCyberpunkSettingRow("9", "Auto Farm Killer V1", "Doi 3s tang hinh, spam chieu co ban, quet sach.", getgenv().AutoFarm_Killer_V1, function(state)
    getgenv().AutoFarm_Killer_V1 = state
    if state then
        getgenv().AutoFarm_Killer_V2 = false
        SliderKillerV2.ForceUpdate(false)
    end
end)

SliderKillerV2 = CreateCyberpunkSettingRow("10", "Auto Farm Killer V2", "Cho 3s tang hinh, xa tron bo Skill VIP, quet sach.", getgenv().AutoFarm_Killer_V2, function(state)
    getgenv().AutoFarm_Killer_V2 = state
    if state then
        getgenv().AutoFarm_Killer_V1 = false
        SliderKillerV1.ForceUpdate(false)
    end
end)

CreateSectionHeader("Sec5", "V: Auto Farm Level")
SliderFarmLevelV1 = CreateCyberpunkSettingRow("11", "Auto Farm Level V1", "Tu doi tuong < Lv100 khi con dang xai da max.", getgenv().AutoFarm_Level_V1, function(state)
    getgenv().AutoFarm_Level_V1 = state
end)

CreateSectionHeader("Sec6", "VI: Auto Server Hop")
SliderHopV1 = CreateCyberpunkSettingRow("12", "Auto Hop V1 (Mac Dinh)", "Tim server it nguoi, ping on dinh (<150ms).", getgenv().AutoHop_V1, function(state)
    getgenv().AutoHop_V1 = state
    if state then
        getgenv().AutoHop_V2 = false
        SliderHopV2.ForceUpdate(false)
    end
end)

SliderHopV2 = CreateCyberpunkSettingRow("13", "Auto Hop V2 (Sieu Muot)", "Tim server it nguoi va ping thap khat khe (<120ms).", getgenv().AutoHop_V2, function(state)
    getgenv().AutoHop_V2 = state
    if state then
        getgenv().AutoHop_V1 = false        SliderHopV1.ForceUpdate(false)
    end
end)

SliderHopTime = CreateCyberpunkSettingRow("14", "Hop Sau 10 Phut", "Tu dong doi Server sau moi 10 phut choi.", getgenv().AutoHop_TimeLimit, function(state)
    getgenv().AutoHop_TimeLimit = state
end)

CreateSectionHeader("Sec7", "VII: Setting")
SliderFixLag = CreateCyberpunkSettingRow("15", "Fix Lag (Xoa Do Hoa)", "Xoa toan bo texture, vat lieu giam lag toi da.", getgenv().FixLagEnabled, function(state)
    getgenv().FixLagEnabled = state
    if state then
        pcall(function()
            game.Lighting.GlobalShadows = false
            game.Lighting.FogEnd = 9e9
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                    v.Material = Enum.Material.SmoothPlastic
                    if v:IsA("Texture") or v:IsA("Decal") then
                        v:Destroy()
                    end
                end
            end
        end)
        Notify("Da don dep do hoa thanh cong!")
    end
end)

CreateCyberpunkSettingRow("16", "Luu Cai Dat (Save)", "Tu dong luu trang thai bat/tat (No Lag).", getgenv().AutoSave, function(state)
    getgenv().AutoSave = state
end)

CreateCyberpunkCycleRow("17", "Ngon Ngu (Language)", "Chuyen doi ngon ngu hien thi UI.", getgenv().LangList, getgenv().LanguageIndex, function(index)
    getgenv().LanguageIndex = index
    if getgenv().ApplyLanguageUI then getgenv().ApplyLanguageUI(index) end
end)

local NoteLabel = Instance.new("TextLabel")
NoteLabel.Name = "NoteLabel"
NoteLabel.Parent = SettingsFrame
NoteLabel.AnchorPoint = Vector2.new(0.5, 1)
NoteLabel.Position = UDim2.new(0.5, 0, 0.98, 0)
NoteLabel.Size = UDim2.new(0.8, 0, 0, 30)
NoteLabel.Font = Enum.Font.SourceSansItalic
NoteLabel.Text = "Bat V2 se tu dong tat V1 de chong xung dot he thong."
NoteLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
NoteLabel.TextSize = 16
NoteLabel.ZIndex = 6

-- ================= [HE THONG TU DIEN DA NGON NGU VN/EN] =================local Translations = {
    [1] = {
        Sec1 = "I: Auto Farm", Sec2 = "II: Auto Ne Killer", Sec3 = "III: Music", Sec4 = "IV: Auto Farm Killer", Sec5 = "V: Auto Farm Level", Sec6 = "VI: Auto Server Hop", Sec7 = "VII: Setting",
        T1 = "Auto Farm Gen V1", D1 = "Om may toi 100%. An toan, truyen thong.",
        T2 = "Auto Farm Gen V2.5", D2 = "Hit & Run: Sua dong loat cac may, nich tung vach.",
        T3 = "Auto Ne V1 (Can Than)", D3 = "Killer vao 20m -> Let tron 6s an toan.",
        T4 = "Auto Ne V2 (Ghim May)", D4 = "Ap sat 10m -> Tele Spawn xa nhat -> Doi ra 5m ve sua.",
        T5 = "Bat/Tat Nhac Nen", D5 = "Nghe nhac cuc chill.",
        T6 = "Am Luong Nhac", D6 = "Dieu chinh to nho cho phu hop.",
        T7 = "Chon Bai Hat", D7 = "Doi bai hat yeu thich cua ban.",
        T8 = "Nhac Custom (ID)", D8 = "Dan ID nhac va nhan nut > de phat de len nhac co san.",
        T9 = "Auto Farm Killer V1", D9 = "Cho 3s tang hinh, spam 1 chieu co ban, quet sach.",
        T10 = "Auto Farm Killer V2", D10 = "Cho 3s tang hinh, xa 100% Skill VIP, diet sach tu Hop.",
        T11 = "Auto Farm Level V1", D11 = "Tu doi tuong < Lv100 khi con dang xai da max.",
        T12 = "Auto Hop V1 (Mac Dinh)", D12 = "Tim server it nguoi, ping on dinh (<150ms).",
        T13 = "Auto Hop V2 (Sieu Muot)", D13 = "Tim server it nguoi va ping thap khat khe (<120ms).",
        T14 = "Hop Sau 10 Phut", D14 = "Tu dong doi Server sau moi 10 phut choi.",
        T15 = "Fix Lag (Xoa Do Hoa)", D15 = "Xoa toan bo texture, vat lieu giam lag toi da.",
        T16 = "Luu Cai Dat (Save)", D16 = "Tu dong luu trang thai bat/tat (No Lag).",
        T17 = "Ngon Ngu (Language)", D17 = "Chuyen doi Tieng Viet / English.",
        Title = "AMETHYST QUAN LY TOI THUONG",
        Note = "Bat V2 se tu dong tat V1 de chong xung dot he thong."
    },
    [2] = {
        Sec1 = "I: Auto Farm", Sec2 = "II: Auto Evade Killer", Sec3 = "III: Music", Sec4 = "IV: Auto Farm Killer", Sec5 = "V: Auto Farm Level", Sec6 = "VI: Auto Server Hop", Sec7 = "VII: Settings",
        T1 = "Auto Farm Gen V1", D1 = "Repair to 100%. Safe and traditional.",
        T2 = "Auto Farm Gen V2.5", D2 = "Hit & Run: Repair all gens bar by bar.",
        T3 = "Auto Evade V1 (Safe)", D3 = "Killer within 20m -> Hide for 6s.",
        T4 = "Auto Evade V2 (Pin)", D4 = "Killer 10m -> Teleport away -> Wait 5m to return.",
        T5 = "Toggle BGM", D5 = "Listen to chill music.",
        T6 = "Music Volume", D6 = "Adjust the volume level.",
        T7 = "Select Song", D7 = "Change your background music.",
        T8 = "Play Custom Music", D8 = "Paste Sound ID and press Play to override defaults.",
        T9 = "Auto Farm Killer V1", D9 = "Wait 3s invis, spam basic skill, hop when cleared.",
        T10 = "Auto Farm Killer V2", D10 = "Wait 3s invis, spam all VIP skills, hop when cleared.",
        T11 = "Auto Farm Level V1", D11 = "Auto equip < Lv100 char when current is maxed.",
        T12 = "Auto Hop V1 (Default)", D12 = "Find low player server, ping <150ms.",
        T13 = "Auto Hop V2 (Ultra Smooth)", D13 = "Find low player server, strict ping <120ms.",
        T14 = "Hop After 10 Mins", D14 = "Automatically hop server after 10 minutes.",
        T15 = "Fix Lag (Delete Textures)", D15 = "Delete all materials/textures to boost FPS.",
        T16 = "Save Settings", D16 = "Auto save configurations (No Lag).",
        T17 = "UI Language", D17 = "Switch UI language (VN / EN).",
        Title = "AMETHYST SUPREME MANAGER",
        Note = "Enabling V2 automatically disables V1 to prevent conflicts."
    }
}

getgenv().ApplyLanguageUI = function(idx)
    local t = Translations[idx] or Translations[1]
    pcall(function()        SettingsTitle.Text = t.Title
        if NoteLabel then NoteLabel.Text = t.Note end
        local function UpdateRowText(id, newTitle, newDesc)
            local r = ScrollingFrame:FindFirstChild("Row_" .. id)
            if r then
                for _, child in ipairs(r:GetChildren()) do
                    if child:IsA("TextLabel") and child.TextSize == 20 then child.Text = newTitle end
                    if child:IsA("TextLabel") and child.TextSize == 13 then child.Text = newDesc end
                end
            end
        end
        local function UpdateHeader(name, newText)
            local h = ScrollingFrame:FindFirstChild("Header_" .. name)
            if h then
                for _, child in ipairs(h:GetChildren()) do
                    if child:IsA("TextLabel") and child.TextSize == 16 then child.Text = newText end
                end
            end
        end
        UpdateHeader("Sec1", t.Sec1)
        UpdateHeader("Sec2", t.Sec2)
        UpdateHeader("Sec3", t.Sec3)
        UpdateHeader("Sec4", t.Sec4)
        UpdateHeader("Sec5", t.Sec5)
        UpdateHeader("Sec6", t.Sec6)
        UpdateHeader("Sec7", t.Sec7)
        UpdateRowText("1", t.T1, t.D1)
        UpdateRowText("2", t.T2, t.D2)
        UpdateRowText("3", t.T3, t.D3)
        UpdateRowText("4", t.T4, t.D4)
        UpdateRowText("5", t.T5, t.D5)
        UpdateRowText("6", t.T6, t.D6)
        UpdateRowText("7", t.T7, t.D7)
        UpdateRowText("8", t.T8, t.D8)
        UpdateRowText("9", t.T9, t.D9)
        UpdateRowText("10", t.T10, t.D10)
        UpdateRowText("11", t.T11, t.D11)
        UpdateRowText("12", t.T12, t.D12)
        UpdateRowText("13", t.T13, t.D13)
        UpdateRowText("14", t.T14, t.D14)
        UpdateRowText("15", t.T15, t.D15)
        UpdateRowText("16", t.T16, t.D16)
        UpdateRowText("17", t.T17, t.D17)
    end)
end

task.spawn(function()
    task.wait(1)
    if getgenv().ApplyLanguageUI then getgenv().ApplyLanguageUI(getgenv().LanguageIndex) end
end)
-- ======================================================================
-- [SU KIEN NUT BAM MENU MAIN HUB]
-- ======================================================================
local isMenuVisible = true

ToggleButton.MouseButton1Click:Connect(function()
    PlaySound(HoverSound)
    isMenuVisible = not isMenuVisible
    MainFrame.Visible = isMenuVisible
    if not isMenuVisible then ToggleSettings(false) end
end)

GearButton.MouseEnter:Connect(function() PlaySound(HoverSound) end)

GearButton.MouseButton1Click:Connect(function()
    if isMenuVisible then
        if SettingsFrame.Visible then ToggleSettings(false) else ToggleSettings(true) end
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    PlaySound(ToggleOffSound)
    ToggleSettings(false)
end)

local StartTime = os.time()
local CurrentStatus = "Dang khoi dong..."

local function UpdateUI()
    local Diff = os.time() - StartTime
    local Hours = math.floor(Diff / 3600)
    local Minutes = math.floor((Diff % 3600) / 60)
    local Seconds = Diff % 60
    TimeLabel.Text = string.format("Time: %02d Hours %02d Minutes %02d Second", Hours, Minutes, Seconds)
    StatusLabel.Text = "Status: " .. CurrentStatus

    pcall(function()
        local timeData = LocalPlayer:FindFirstChild("PlayerData") and LocalPlayer.PlayerData:FindFirstChild("Stats") and LocalPlayer.PlayerData.Stats:FindFirstChild("General") and LocalPlayer.PlayerData.Stats.General:FindFirstChild("TimePlayed")
        if timeData then
            local totalSec = timeData.Value
            local gDays = math.floor(totalSec / 86400)
            local gHours = math.floor((totalSec % 86400) / 3600)
            local gMinutes = math.floor((totalSec % 3600) / 60)
            local gSeconds = math.floor(totalSec % 60)
            GeneralLabel.Text = string.format("General: %02ddays %02d hours %02d minutes %02d Seconds", gDays, gHours, gMinutes, gSeconds)
        else
            GeneralLabel.Text = "General: Not Found"
        end
    end)
    pcall(function()
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        if leaderstats then
            local money = leaderstats:FindFirstChild("Credits") or leaderstats:FindFirstChild("Money") or leaderstats:FindFirstChild("Cash")
            if money then MoneyLabel.Text = "Money: " .. tostring(money.Value) else MoneyLabel.Text = "Money: Not Found" end
        else
            local guiMoney = LocalPlayer.PlayerGui:FindFirstChild("MainGui") and LocalPlayer.PlayerGui.MainGui:FindFirstChild("Money")
            if guiMoney and guiMoney:IsA("TextLabel") then MoneyLabel.Text = "Money: " .. guiMoney.Text else MoneyLabel.Text = "Money: ???" end
        end
    end)
end

task.spawn(function()
    while true do 
        UpdateUI()
        task.wait(1) 
    end
end)

local function SetStatus(msg)
    CurrentStatus = msg
    UpdateUI()
end

-- ================= [HUTAO ANTI-BAN SYSTEM V4] =================
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

pcall(function()
    local ScriptContext = game:GetService("ScriptContext")
    ScriptContext.Error:Connect(function(msg, stack, script) end)
end)

-- [NEW: ANTI-BAN V4 CHO BAN FREE - Chan lenh Kick tu may chu]
pcall(function()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if self == LocalPlayer and (method == "Kick" or method == "kick") then
            return
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end)
local function Notify(msg)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", { Title = "Amethyst Hub", Text = msg, Duration = 3 })
    end)
end

Notify("Anti-Ban System V4 Active!")

-- ================= CAU HINH (AUTO RUN CORE) =================
getgenv().AutoFarm = true
getgenv().Invisible = true
local MaxSearchDistance = 3000
local IgnoreList = {}
local HitCycle = {}
local LastGenerator = nil
local IsInMatch = false
local IsHopping = false
local SafeDistance = 20
getgenv().KillerFinishedMatch = false
local SkillCooldownTracker = {}

local RepairOffsets = {
    CFrame.new(0, 0, -6),
    CFrame.new(6, 0, 0),
    CFrame.new(-6, 0, 0)
}

SetStatus("Dang khoi dong vui long cho")
Notify("Dang khoi dong... (Doi 5s)")
task.wait(5)
SetStatus("Dang cho vao tran")
Notify("Script Da Bat! Dang cho Survivor...")

-- ================= [ HAM AUTO QUAN LY CAP DO V1 ] =================
local function CheckAndEquipUnmaxed()
    local ingameCheck = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Ingame")
    if ingameCheck then return end

    local pd = LocalPlayer:FindFirstChild("PlayerData")
    if not pd then return end

    local curKiller = pd:FindFirstChild("EquippedKiller") and pd.EquippedKiller.Value or ""
    local curSurvivor = pd:FindFirstChild("EquippedSurvivor") and pd.EquippedSurvivor.Value or ""
    local achievements = pd:FindFirstChild("Achievements")
    if not achievements then return end

    local function ProcessRole(roleName, curEquipped, folderName)
        local folder = achievements:FindFirstChild(folderName)
        if folder and curEquipped ~= "" then            local curVal = folder:FindFirstChild(curEquipped .. "Milestone")
            if curVal and curVal.Value >= 100 then
                local available = {}
                for _, v in pairs(folder:GetChildren()) do
                    local lvl = v.Value
                    if lvl > 0 and lvl < 100 then
                        table.insert(available, string.gsub(v.Name, "Milestone", ""))
                    end
                end
                if #available > 0 then
                    local randomChar = available[math.random(1, #available)]
                    local rs = game:GetService("ReplicatedStorage")
                    local assets = rs:FindFirstChild("Assets")
                    if assets then
                        local roleFolder = (roleName == "Killer") and assets:FindFirstChild("Killers") or assets:FindFirstChild("Survivors")
                        if roleFolder then
                            local charModel = roleFolder:FindFirstChild(randomChar)
                            if charModel then
                                local remote = rs:FindFirstChild("Modules")
                                and rs.Modules:FindFirstChild("Network")
                                and rs.Modules.Network:FindFirstChild("Network")
                                and rs.Modules.Network.Network:FindFirstChild("RemoteEvent")
                                if remote then
                                    pcall(function()
                                        local args = { "EquipState", { charModel, buffer.fromstring("\001\001") } }
                                        remote:FireServer(unpack(args))
                                    end)
                                    pcall(function()
                                        game.StarterGui:SetCore("SendNotification", {Title = "Auto Level V1", Text = roleName .. " da MAX! Tu doi sang: " .. randomChar, Duration = 5})
                                    end)
                                end
                            end
                        end
                    end
                end
            else
                pcall(function()
                    game.StarterGui:SetCore("SendNotification", {Title = "Auto Level V1", Text = "Canh bao: Toan bo " .. roleName .. " da Max Lv100!", Duration = 5})
                end)
            end
        end
    end

    ProcessRole("Killer", curKiller, "KillersMilestones")
    ProcessRole("Survivor", curSurvivor, "SurvivorsMilestones")
end

-- ================= [CORE] KIEM TRA =================
local function isSurvivorModel(char)
    if not char then return false end    local survivorsFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Survivors")
    if survivorsFolder and survivorsFolder:FindFirstChild(char.Name) then return true end
    return false
end

local function isLocalPlayerKiller(char)
    if not char then return false end
    local killersFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
    if killersFolder and killersFolder:FindFirstChild(char.Name) then return true end
    return false
end

local function GetKiller()
    local killersFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
    if killersFolder then
        for _, k in pairs(killersFolder:GetChildren()) do
            if k:FindFirstChild("HumanoidRootPart") then return k end
        end
    end
    return nil
end

local function GetSafeGenerator(killerPos)
    if not Workspace:FindFirstChild("Map") then return nil end
    local ingame = Workspace.Map:FindFirstChild("Ingame")
    if not ingame then return nil end
    local GameMap = ingame:FindFirstChild("Map")
    if not GameMap then return nil end

    local bestGen = nil
    local maxDist = 0

    for _, obj in ipairs(GameMap:GetChildren()) do
        if obj.Name == "Generator" and obj:IsA("Model") then
            local main = obj.PrimaryPart or obj:FindFirstChild("Main")
            if main then
                if main.Position.Magnitude < 20 then continue end
                local dist = (main.Position - killerPos).Magnitude
                if dist > maxDist then
                    maxDist = dist
                    bestGen = obj
                end
            end
        end
    end
    return bestGen
end

-- ================= [TIM DIEM SPAWN XA NHAT CHO NE V2 + CHONG LAG] =================
local CachedSpawns = {}local CachedMap = nil

local function GetFurthestSpawnPoint(killerPos)
    if not Workspace:FindFirstChild("Map") then return nil end
    local ingame = Workspace.Map:FindFirstChild("Ingame")
    if not ingame then return nil end
    local GameMap = ingame:FindFirstChild("Map")
    if not GameMap then return nil end

    if CachedMap ~= GameMap then
        CachedMap = GameMap
        table.clear(CachedSpawns)
        for _, obj in ipairs(GameMap:GetDescendants()) do
            if obj:IsA("SpawnLocation") or string.find(string.lower(obj.Name), "spawn") then
                local pos = nil
                if obj:IsA("BasePart") then
                    pos = obj.Position
                elseif obj:IsA("Model") and obj.PrimaryPart then
                    pos = obj.PrimaryPart.Position
                end
                if pos then
                    table.insert(CachedSpawns, pos)
                end
            end
        end
    end

    local bestSpot = nil
    local maxDist = 0

    for _, pos in ipairs(CachedSpawns) do
        local dist = (pos - killerPos).Magnitude
        if dist > maxDist then
            maxDist = dist
            bestSpot = pos
        end
    end
    return bestSpot
end

-- ================= 1. LOGIC TANG HINH & CAM =================
local InvisAnimID = "rbxassetid://75804462760596"
local InvisTrack = nil
local InvisLoop = nil

local function StartInvisibleLoop()
    if InvisLoop then return end
    InvisLoop = task.spawn(function()
        while true do
            if not getgenv().Invisible then                if InvisTrack then InvisTrack:Stop(); InvisTrack = nil end
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
                end
                break
            end

            local char = LocalPlayer.Character
            local isSurv = isSurvivorModel(char)
            local isKill = isLocalPlayerKiller(char)

            if IsInMatch and (isSurv or ((getgenv().AutoFarm_Killer_V1 or getgenv().AutoFarm_Killer_V2) and isKill)) then
                pcall(function()
                    local hum = char and char:FindFirstChild("Humanoid")
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if hum and root then
                        local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
                        if not InvisTrack or not InvisTrack.IsPlaying then
                            local anim = Instance.new("Animation")
                            anim.AnimationId = InvisAnimID
                            InvisTrack = animator:LoadAnimation(anim)
                            InvisTrack.Looped = true
                            InvisTrack:Play()
                            InvisTrack:AdjustSpeed(0)
                        end
                        if Workspace.CurrentCamera.CameraSubject ~= hum then
                            Workspace.CurrentCamera.CameraSubject = hum
                        end
                    end
                end)
            else
                if InvisTrack then InvisTrack:Stop(); InvisTrack = nil end
                if char and char:FindFirstChild("Humanoid") then
                    Workspace.CurrentCamera.CameraSubject = char.Humanoid
                end
            end
            task.wait(0.5)
        end
    end)
end

StartInvisibleLoop()

local function GetProgress(gen)
    local p = gen:FindFirstChild("Progress")
    if p and p:IsA("NumberValue") then return p.Value end
    return nil
end

local function IsSpotBlocked(position)    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if (plr.Character.HumanoidRootPart.Position - position).Magnitude < 3.5 then return true end
        end
    end
    return false
end

local function GetBestRepairSpot(gen)
    local pivot = gen:GetPivot()
    for _, offset in ipairs(RepairOffsets) do
        local spotPos = (pivot * offset).Position
        if not IsSpotBlocked(spotPos) then return spotPos end
    end
    return nil
end

-- ================= [LOGIC TIM MAY V1 (CO DIEN)] =================
local function GetNextGenerator_V1()
    if not Workspace:FindFirstChild("Map") then return nil, false, false end
    local ingame = Workspace.Map:FindFirstChild("Ingame")
    if not ingame then return nil, false, false end
    local GameMap = ingame:FindFirstChild("Map")
    if not GameMap then return nil, false, false end

    local closest, target = 99999, nil
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil, true, false end

    local TotalGens, Unfinished = 0, 0
    local ChosenSpot = nil

    for _, obj in ipairs(GameMap:GetChildren()) do
        if obj.Name == "Generator" and obj:IsA("Model") then
            local progress = GetProgress(obj)
            if progress ~= nil then
                TotalGens = TotalGens + 1
                if progress < 100 then
                    Unfinished = Unfinished + 1
                    local main = obj.PrimaryPart or obj:FindFirstChild("Main")
                    if main then
                        if main.Position.Magnitude < 20 then
                        else
                            local dist = (root.Position - main.Position).Magnitude
                            if dist <= MaxSearchDistance and not IgnoreList[obj] then
                                local spot = GetBestRepairSpot(obj)
                                if spot and dist < closest then
                                    closest = dist
                                    target = obj
                                    ChosenSpot = spot                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return target, true, (TotalGens > 0 and Unfinished == 0), ChosenSpot
end

-- ================= [LOGIC TIM MAY V2 (DONG LOAT VACH)] =================
local function GetNextGenerator_V2()
    if not Workspace:FindFirstChild("Map") then return nil, false, false end
    local ingame = Workspace.Map:FindFirstChild("Ingame")
    if not ingame then return nil, false, false end
    local GameMap = ingame:FindFirstChild("Map")
    if not GameMap then return nil, false, false end

    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil, true, false end

    local TotalGens = 0
    local Unfinished = 0
    local ValidGens = {}

    for _, obj in ipairs(GameMap:GetChildren()) do
        if obj.Name == "Generator" and obj:IsA("Model") then
            local progress = GetProgress(obj)
            if progress ~= nil then
                TotalGens = TotalGens + 1
                if progress < 100 and not IgnoreList[obj] then
                    Unfinished = Unfinished + 1
                    local main = obj.PrimaryPart or obj:FindFirstChild("Main")
                    local pos = main and main.Position or obj:GetPivot().Position
                    local dist = (root.Position - pos).Magnitude
                    table.insert(ValidGens, {obj = obj, progress = progress, dist = dist})
                end
            end
        end
    end

    if Unfinished == 0 then return nil, true, (TotalGens > 0), nil end

    local minBar = 4
    for _, data in ipairs(ValidGens) do
        local bar = math.floor(data.progress / 25)
        if bar < minBar then minBar = bar end
    end
    local closest = 99999
    local target = nil
    local ChosenSpot = nil
    local CountInMinBar = 0
    local ValidForCycle = 0

    for _, data in ipairs(ValidGens) do
        local bar = math.floor(data.progress / 25)
        if bar == minBar then
            CountInMinBar = CountInMinBar + 1
            if not HitCycle[data.obj] then
                ValidForCycle = ValidForCycle + 1
                if data.dist <= MaxSearchDistance then
                    local spot = GetBestRepairSpot(data.obj)
                    if spot and data.dist < closest then
                        closest = data.dist
                        target = data.obj
                        ChosenSpot = spot
                    end
                end
            end
        end
    end

    if CountInMinBar > 0 and ValidForCycle == 0 then
        table.clear(HitCycle)
        if CountInMinBar > 1 and LastGenerator then HitCycle[LastGenerator] = true end
        return GetNextGenerator_V2()
    end

    return target, true, false, ChosenSpot
end

-- ================= [SMART SERVER HOP - LOC PING THEO LENH SEP V1/V2] =================
local function SmartServerHop()
    if IsHopping then return end
    IsHopping = true

    local PlaceId = game.PlaceId
    local TeleportConnection
    TeleportConnection = TeleportService.TeleportInitFailed:Connect(function()
        if TeleportConnection then TeleportConnection:Disconnect() end
        IsHopping = false
        Notify("Loi mang Roblox! Thu lai ngay...")
        task.wait(1)
        SmartServerHop()
    end)

    task.spawn(function()
        local targetServer = nil        local cursor = ""

        while not targetServer do
            SetStatus("Hop sv sieu toc")
            Notify("Dang soi Server cuc ky...")
            local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", PlaceId)
            if cursor and cursor ~= "" then
                url = url .. "&cursor=" .. cursor
            end

            local success, response = pcall(function() return HttpService:JSONDecode(request({Url = url, Method = "GET"}).Body) end)

            if success and response and response.data then
                local bestServers = {}
                local backupServers = {}

                for _, v in ipairs(response.data) do
                    if type(v) == "table" and v.playing and v.maxPlayers and v.id ~= game.JobId then
                        local isPingOK = true
                        if getgenv().AutoHop_V2 then
                            if v.ping and v.ping >= 120 then isPingOK = false end
                        else
                            if v.ping and v.ping > 150 then isPingOK = false end
                        end

                        if v.playing < v.maxPlayers and isPingOK then
                            local freeSlots = v.maxPlayers - v.playing
                            if v.playing >= 1 and v.playing <= 3 then
                                table.insert(bestServers, v)
                            elseif freeSlots >= 2 then
                                table.insert(backupServers, v)
                            end
                        end
                    end
                end

                if #bestServers > 0 then
                    targetServer = bestServers[math.random(1, #bestServers)]
                elseif #backupServers > 0 then
                    targetServer = backupServers[math.random(1, #backupServers)]
                end

                if not targetServer and response.nextPageCursor then
                    cursor = response.nextPageCursor
                    SetStatus("Trang nay day! Lat trang...")
                    task.wait(0.5)
                elseif not targetServer and not response.nextPageCursor then
                    cursor = ""
                    SetStatus("Quet lai tu dau...")
                    task.wait(2)                end
            else
                SetStatus("Loi API! Cho 2s...")
                task.wait(2)
            end

            if targetServer then
                Notify("Vao SV (" .. targetServer.playing .. "/" .. targetServer.maxPlayers .. " nguoi)!")
                TeleportService:TeleportToPlaceInstance(PlaceId, targetServer.id, LocalPlayer)
                return
            end
        end
    end)
end

-- ================= 3. VONG LAP CHINH (AUTO FARM + RESET LOBBY) =================
local lastEquipCheck = 0

task.spawn(function()
    while true do
        if getgenv().AutoFarm and (getgenv().AutoFarm_V1 or getgenv().AutoFarm_V2 or getgenv().AutoFarm_Killer_V1 or getgenv().AutoFarm_Killer_V2 or getgenv().AutoFarm_Level_V1) then
            pcall(function()
                local gen, mapLoaded, allFinished, targetPos
                if getgenv().AutoFarm_V2 then
                    gen, mapLoaded, allFinished, targetPos = GetNextGenerator_V2()
                else
                    gen, mapLoaded, allFinished, targetPos = GetNextGenerator_V1()
                end

                if not mapLoaded then
                    if getgenv().AutoFarm_Level_V1 then
                        local ingameCheck = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Ingame")
                        if not ingameCheck and tick() - lastEquipCheck >= 5 then
                            CheckAndEquipUnmaxed()
                            lastEquipCheck = tick()
                        end
                    end

                    if (getgenv().AutoFarm_Killer_V1 or getgenv().AutoFarm_Killer_V2) and getgenv().KillerFinishedMatch then
                        SetStatus("Da ve sanh sau khi win! Hop SV...")
                        Notify("Diet sach phong! Auto Server Hop...")
                        getgenv().KillerFinishedMatch = false
                        SmartServerHop()
                        return
                    end

                    if IsInMatch then
                        IsInMatch = false
                        SetStatus("Da ve lobby vui long cho")
                        Notify("Ve Sanh -> Cho tran moi")                        table.clear(IgnoreList)
                        table.clear(HitCycle)
                    end
                else
                    if isLocalPlayerKiller(LocalPlayer.Character) then
                        if getgenv().AutoFarm_Killer_V1 or getgenv().AutoFarm_Killer_V2 then
                            if not IsInMatch then
                                SetStatus("Dang cho 3s (Killer)...")
                                task.wait(3)
                                IsInMatch = true
                                Notify("Bat dau tang hinh & San Survivor!")
                            end

                            local survivorsFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Survivors")
                            local targetPart = nil
                            local targetName = ""
                            local aliveCount = 0

                            if survivorsFolder then
                                for _, surv in ipairs(survivorsFolder:GetChildren()) do
                                    if surv:IsA("Model") then
                                        local hrp = surv:FindFirstChild("HumanoidRootPart")
                                        local hum = surv:FindFirstChild("Humanoid")
                                        if hrp and hum and hum.Health > 0 then
                                            aliveCount = aliveCount + 1
                                            if not targetPart then
                                                targetPart = hrp
                                                targetName = surv.Name
                                            end
                                        end
                                    end
                                end
                            end

                            if aliveCount > 0 and targetPart then
                                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                if root then
                                    SetStatus("Dang san: " .. targetName)
                                    local targetHum = targetPart.Parent:FindFirstChild("Humanoid")
                                    local lastSkillScan = 0

                                    while (getgenv().AutoFarm_Killer_V1 or getgenv().AutoFarm_Killer_V2) and targetHum and targetHum.Health > 0 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
                                        local currentRoot = LocalPlayer.Character.HumanoidRootPart
                                        currentRoot.Velocity = Vector3.zero
                                        local behindPos = (targetPart.CFrame * CFrame.new(0, 0, 2)).Position
                                        currentRoot.CFrame = CFrame.lookAt(behindPos, targetPart.Position)

                                        if tick() - lastSkillScan >= 0.25 then
                                            lastSkillScan = tick()
                                            if getgenv().AutoFarm_Killer_V1 then                                                pcall(function()
                                                    local gui = LocalPlayer:FindFirstChild("PlayerGui")
                                                    if gui then
                                                        for _, v in pairs(gui:GetDescendants()) do
                                                            if v:IsA("ImageButton") or v:IsA("TextButton") then
                                                                local n = string.lower(v.Name)
                                                                if string.find(n, "slash") or string.find(n, "punch") or string.find(n, "carving") or string.find(n, "stab") or string.find(n, "lacerate") then
                                                                    if v.Visible and v.Active and firesignal then
                                                                        firesignal(v.MouseButton1Down)
                                                                        firesignal(v.MouseButton1Click)
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end)
                                            elseif getgenv().AutoFarm_Killer_V2 then
                                                pcall(function()
                                                    local gui = LocalPlayer:FindFirstChild("PlayerGui")
                                                    if gui then
                                                        for _, v in pairs(gui:GetDescendants()) do
                                                            if v:IsA("ImageButton") or v:IsA("TextButton") then
                                                                local n = string.lower(v.Name)
                                                                local t = ""
                                                                if v:IsA("TextButton") then t = string.lower(v.Text) end
                                                                local keywords = {
                                                                    "slash", "punch", "carving", "stab", "lacerate", "attack",
                                                                    "behead", "gashing", "corrupt", "walkspeed", "digital",
                                                                    "footprint", "void", "nova", "mass", "infection",
                                                                    "entanglement", "eviscerate", "demonic", "pursuit",
                                                                    "bloodhook", "hunter", "feast", "ability", "skill"
                                                                }
                                                                local isSkill = false
                                                                for _, kw in ipairs(keywords) do
                                                                    if string.find(n, kw) or string.find(t, kw) then
                                                                        isSkill = true
                                                                        break
                                                                    end
                                                                end

                                                                if isSkill and v.Visible and v.Active and firesignal then
                                                                    local currentTime = tick()
                                                                    if not SkillCooldownTracker[n] or (currentTime - SkillCooldownTracker[n] > 1) then
                                                                        local isOnCooldown = false
                                                                        for _, child in pairs(v:GetDescendants()) do
                                                                            if child:IsA("TextLabel") then
                                                                                local txt = child.Text
                                                                                if tonumber(txt) ~= nil and tonumber(txt) > 0 then
                                                                                    isOnCooldown = true
                                                                                    break                                                                                end
                                                                            end
                                                                        end

                                                                        if not isOnCooldown then
                                                                            firesignal(v.MouseButton1Down)
                                                                            firesignal(v.MouseButton1Click)
                                                                            SkillCooldownTracker[n] = currentTime
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end)
                                            end
                                        end
                                        task.wait()
                                    end
                                end
                            else
                                if Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Ingame") then
                                    SetStatus("Da giet sach! Cho ve Lobby...")
                                    getgenv().KillerFinishedMatch = true
                                end
                            end
                            task.wait(0.1)
                            return
                        else
                            SetStatus("Ban la killer! Tu dong reset")
                            Notify("BAN LA KILLER! Reset de Farm tiep...")
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                                LocalPlayer.Character.Humanoid.Health = 0
                            end
                            task.wait(3); return
                        end
                    end

                    if IsInMatch and not allFinished then
                        local char = LocalPlayer.Character
                        local hum = char and char:FindFirstChild("Humanoid")
                        if hum and hum.Health <= 0 then
                            SetStatus("Bi giet! Hop sv ngay")
                            Notify("Ban da chet! Dang tim server khac...")
                            SmartServerHop(); return
                        end
                    end

                    if not isSurvivorModel(LocalPlayer.Character) then return end
                    if not IsInMatch then
                        SetStatus("Da vao tran, vui long doi 3.5s")
                        Notify("Survivor Detected -> Doi 3.5s...")
                        task.wait(3.5)
                        IsInMatch = true
                        SetStatus("Starting")
                    end

                    if allFinished then
                        SetStatus("Complete")
                        Notify("Xong Map -> Reset ve Lobby...")
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                            LocalPlayer.Character.Humanoid.Health = 0
                        end
                        task.wait(3); SmartServerHop()
                    end

                    if gen and targetPos then
                        local root = LocalPlayer.Character.HumanoidRootPart
                        local pivot = gen:GetPivot()
                        local dropHeight = 2.0
                        local dropPos = targetPos + Vector3.new(0, dropHeight, 0)
                        local lookAt = Vector3.new(pivot.Position.X, dropPos.Y, pivot.Position.Z)

                        while getgenv().AutoFarm and (getgenv().AutoFarm_V1 or getgenv().AutoFarm_V2) and (root.Position - dropPos).Magnitude > 3 do
                            SetStatus(getgenv().AutoFarm_V2 and "V2.5: Dang xoay tua may" or "V1: Dang toi may")
                            local killer = GetKiller()
                            if killer and killer:FindFirstChild("HumanoidRootPart") then
                                if (root.Position - killer.HumanoidRootPart.Position).Magnitude < SafeDistance then
                                    SetStatus("killer van dang o gan")
                                    Notify("Killer chan duong! Doi muc tieu...")
                                    break
                                end
                            end
                            if IsSpotBlocked(targetPos) then break end
                            root.CFrame = CFrame.lookAt(dropPos, lookAt)
                            root.Velocity = Vector3.zero
                            task.wait()
                        end

                        if getgenv().AutoFarm and (getgenv().AutoFarm_V1 or getgenv().AutoFarm_V2) then
                            root.Anchored = false
                            if getgenv().AutoFarm_V2 then
                                task.wait(0.75)
                            else
                                task.wait(1)
                                root.Anchored = true
                            end

                            local prompt = gen:FindFirstChild("Main") and gen.Main:FindFirstChild("Prompt")                            if prompt then fireproximityprompt(prompt) end
                            if getgenv().AutoFarm_V2 then task.wait(1.2) end

                            local startProgress = GetProgress(gen)
                            local checkProgress = 100
                            if getgenv().AutoFarm_V2 then
                                local currentBar = math.floor(startProgress / 25)
                                local targetProgress = (currentBar + 1) * 25
                                if targetProgress > 100 then targetProgress = 100 end
                                checkProgress = targetProgress - 1
                            end

                            local lastInteract = 0
                            while getgenv().AutoFarm and (getgenv().AutoFarm_V1 or getgenv().AutoFarm_V2) and GetProgress(gen) < 100 do
                                if (root.Position - dropPos).Magnitude > 4 then
                                    SetStatus("Bi danh bay! Quay lai...")
                                    root.Anchored = false; break
                                end

                                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                                if hum and (hum.PlatformStand or hum.Sit) then
                                    SetStatus("Bi Te! Dang tu dung day")
                                    root.Anchored = false; hum.PlatformStand = false; hum.Sit = false
                                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                                    task.wait(1.5); break
                                end

                                SetStatus("Da sua duoc " .. math.floor(GetProgress(gen)) .. "%")

                                if getgenv().AutoFarm_V1 then
                                    if LocalPlayer.Character.Humanoid.Jump then root.Anchored = false; task.wait(1); break end
                                    if not root.Anchored then root.Anchored = true end
                                else
                                    if LocalPlayer.Character.Humanoid.Jump then break end
                                end

                                local killer = GetKiller()
                                if killer and killer:FindFirstChild("HumanoidRootPart") then
                                    local distToKiller = (root.Position - killer.HumanoidRootPart.Position).Magnitude

                                    if getgenv().AutoEvade_V1 then
                                        if distToKiller < SafeDistance then
                                            if prompt then pcall(function() prompt:InputHoldEnd() end) end
                                            SetStatus("Killer dang o gan (V1)")
                                            Notify("KILLER DEN (<20m)! Chay tron...")
                                            
                                            local safeGen = GetSafeGenerator(killer.HumanoidRootPart.Position)
                                            if safeGen then
                                                local safePos = safeGen:GetPivot().Position
                                                                                                local char = LocalPlayer.Character
                                                if char then
                                                    local evadeRoot = char:FindFirstChild("HumanoidRootPart")
                                                    if evadeRoot then
                                                        evadeRoot.Anchored = false
                                                        task.wait()
                                                        char:PivotTo(CFrame.new(safePos + Vector3.new(0, 5, 0)))
                                                        evadeRoot.Velocity = Vector3.zero
                                                        evadeRoot.AssemblyLinearVelocity = Vector3.zero
                                                        evadeRoot.AssemblyAngularVelocity = Vector3.zero
                                                        task.wait(0.1)
                                                        evadeRoot.Anchored = true
                                                    end
                                                end

                                                SetStatus("Dang tron Killer (6s)...")
                                                local isDeadWhileHiding = false
                                                for i = 1, 60 do
                                                    local curHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                                                    if curHum and curHum.Health <= 0 then isDeadWhileHiding = true; break end
                                                    
                                                    local curChar = LocalPlayer.Character
                                                    if curChar then
                                                        local curRoot = curChar:FindFirstChild("HumanoidRootPart")
                                                        if curRoot then
                                                            curRoot.Anchored = true
                                                            curRoot.CFrame = CFrame.new(safePos + Vector3.new(0, 5, 0))
                                                            curRoot.Velocity = Vector3.zero
                                                            curRoot.AssemblyLinearVelocity = Vector3.zero
                                                            curRoot.AssemblyAngularVelocity = Vector3.zero
                                                        end
                                                    end
                                                    task.wait(0.1)
                                                end

                                                if isDeadWhileHiding then SmartServerHop(); return end

                                                local oldGenPos = targetPos
                                                repeat
                                                    if not getgenv().AutoFarm then break end
                                                    local curHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                                                    if curHum and curHum.Health <= 0 then SmartServerHop(); return end

                                                    local currentKiller = GetKiller()
                                                    if not currentKiller or not currentKiller:FindFirstChild("HumanoidRootPart") then break end
                                                    if not isSurvivorModel(LocalPlayer.Character) then IsInMatch = false; break end

                                                    local kPosNew = currentKiller.HumanoidRootPart.Position
                                                    local distKillerToOldGen = (kPosNew - oldGenPos).Magnitude
                                                    local waitChar = LocalPlayer.Character
                                                    if waitChar then
                                                        local waitRoot = waitChar:FindFirstChild("HumanoidRootPart")
                                                        if waitRoot then
                                                            waitRoot.Anchored = true
                                                            waitRoot.CFrame = CFrame.new(safePos + Vector3.new(0, 5, 0))
                                                            waitRoot.Velocity = Vector3.zero
                                                            waitRoot.AssemblyLinearVelocity = Vector3.zero
                                                            waitRoot.AssemblyAngularVelocity = Vector3.zero
                                                        end
                                                    end

                                                    if distKillerToOldGen > (SafeDistance + 10) then break else task.wait(0.2) end
                                                until false

                                                if getgenv().AutoFarm and IsInMatch then
                                                    local retChar = LocalPlayer.Character
                                                    if retChar then
                                                        local retRoot = retChar:FindFirstChild("HumanoidRootPart")
                                                        if retRoot then
                                                            retRoot.Anchored = false
                                                            task.wait()
                                                            retChar:PivotTo(CFrame.lookAt(dropPos, lookAt))
                                                            retRoot.Velocity = Vector3.zero
                                                            retRoot.AssemblyLinearVelocity = Vector3.zero
                                                            retRoot.AssemblyAngularVelocity = Vector3.zero
                                                            task.wait(0.1)
                                                            if getgenv().AutoFarm_V1 then retRoot.Anchored = true end
                                                        end
                                                    end
                                                    SetStatus("Da quay ve may cu (V1)...")
                                                    task.wait(0.2)
                                                end
                                            end
                                        end
                                    elseif getgenv().AutoEvade_V2 then
                                        if distToKiller <= 10 then
                                            if prompt then pcall(function() prompt:InputHoldEnd() end) end
                                            SetStatus("Killer ap sat 10m! Toc bien (V2)")
                                            Notify("KILLER DEN GAN! TOC BIEN!")
                                            
                                            local furthestSpawnPos = GetFurthestSpawnPoint(killer.HumanoidRootPart.Position)
                                            if furthestSpawnPos then
                                                local char = LocalPlayer.Character
                                                if char then
                                                    local evadeRoot = char:FindFirstChild("HumanoidRootPart")
                                                    if evadeRoot then
                                                        evadeRoot.Anchored = false
                                                        task.wait()
                                                        char:PivotTo(CFrame.new(furthestSpawnPos + Vector3.new(0, 5, 0)))                                                        evadeRoot.Velocity = Vector3.zero
                                                        evadeRoot.AssemblyLinearVelocity = Vector3.zero
                                                        evadeRoot.AssemblyAngularVelocity = Vector3.zero
                                                        task.wait(0.1)
                                                        evadeRoot.Anchored = true
                                                    end
                                                end

                                                SetStatus("Da ghim may! Cho Killer roi di 5m...")
                                                local oldGenPos = targetPos
                                                repeat
                                                    if not getgenv().AutoFarm then break end
                                                    local curHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                                                    if curHum and curHum.Health <= 0 then SmartServerHop(); return end

                                                    local waitChar = LocalPlayer.Character
                                                    if waitChar then
                                                        local waitRoot = waitChar:FindFirstChild("HumanoidRootPart")
                                                        if waitRoot then
                                                            waitRoot.Anchored = true
                                                            waitRoot.CFrame = CFrame.new(furthestSpawnPos + Vector3.new(0, 5, 0))
                                                            waitRoot.Velocity = Vector3.zero
                                                            waitRoot.AssemblyLinearVelocity = Vector3.zero
                                                            waitRoot.AssemblyAngularVelocity = Vector3.zero
                                                        end
                                                    end

                                                    local currentKiller = GetKiller()
                                                    if not currentKiller or not currentKiller:FindFirstChild("HumanoidRootPart") then break end
                                                    if not isSurvivorModel(LocalPlayer.Character) then IsInMatch = false; break end

                                                    local kPosNew = currentKiller.HumanoidRootPart.Position
                                                    local distKillerToOldGen = (kPosNew - oldGenPos).Magnitude

                                                    if distKillerToOldGen > 5 then
                                                        break
                                                    else
                                                        task.wait(0.1)
                                                    end
                                                until false

                                                if getgenv().AutoFarm and IsInMatch then
                                                    local retChar = LocalPlayer.Character
                                                    if retChar then
                                                        local retRoot = retChar:FindFirstChild("HumanoidRootPart")
                                                        if retRoot then
                                                            retRoot.Anchored = false
                                                            task.wait()
                                                            retChar:PivotTo(CFrame.lookAt(dropPos, lookAt))
                                                            retRoot.Velocity = Vector3.zero                                                            retRoot.AssemblyLinearVelocity = Vector3.zero
                                                            retRoot.AssemblyAngularVelocity = Vector3.zero
                                                            task.wait(0.1)
                                                            if getgenv().AutoFarm_V1 then retRoot.Anchored = true end
                                                        end
                                                    end
                                                    SetStatus("Killer da di! Ve lai may ghim...")
                                                    task.wait(0.2)
                                                end
                                            end
                                        end
                                    end
                                end

                                local interactDelay = getgenv().AutoFarm_V2 and 0.75 or 1.1
                                if tick() - lastInteract >= interactDelay then
                                    if prompt then pcall(function() prompt:InputHoldBegin() end) end
                                    if gen:FindFirstChild("Remotes") and gen.Remotes:FindFirstChild("RE") then gen.Remotes.RE:FireServer() end
                                    lastInteract = tick()
                                end

                                task.wait(0.1)

                                if getgenv().AutoFarm_V2 and GetProgress(gen) >= checkProgress then
                                    if prompt then pcall(function() prompt:InputHoldEnd() end) end
                                    HitCycle[gen] = true
                                    LastGenerator = gen
                                    break
                                end
                            end

                            if prompt then pcall(function() prompt:InputHoldEnd() end) end
                            root.Anchored = false
                            if GetProgress(gen) >= 100 then IgnoreList[gen] = true end
                        end
                    end
                end
            end)
        end
        task.wait(0.2)
    end
end)

-- ================= [ HE THONG AUTO HOP 10 PHUT ] =================
local ScriptSessionTime = tick()

task.spawn(function()
    while task.wait(5) do
        if getgenv().AutoHop_TimeLimit and not IsHopping then
            local elapsed = tick() - ScriptSessionTime            if elapsed >= 600 then
                SetStatus("Da online 10 phut! Auto Hop...")
                Notify("Da dat moc 10 phut! Dang tim Server moi...")
                SmartServerHop()
                break
            end
        end
    end
end)

-- ================= [HUTAO MUSIC SYSTEM V4 - TICH HOP UI VIP] =================
local SoundService = game:GetService("SoundService")
local AmethystMusic = SoundService:FindFirstChild("AmethystHubMusic_V4") or Instance.new("Sound")
AmethystMusic.Name = "AmethystHubMusic_V4"
AmethystMusic.Parent = SoundService
AmethystMusic.Looped = false

AmethystMusic.Ended:Connect(function()
    task.wait(10)
    if getgenv().MusicEnabled then
        AmethystMusic:Play()
    end
end)

getgenv().ApplyMusicSettings = function()
    local targetID = ""
    local targetName = ""

    if getgenv().IsUsingCustomMusic and getgenv().CustomMusicID ~= "" then
        targetID = getgenv().CustomMusicID
        targetName = "Custom ID"
    else
        local songData = getgenv().SongList[getgenv().CurrentSongIndex]
        targetID = songData.ID
        targetName = songData.Name
    end

    AmethystMusic.Volume = (getgenv().MusicVolumePercent / 100) * 5

    if AmethystMusic.SoundId ~= targetID then
        AmethystMusic.SoundId = targetID
        if getgenv().MusicEnabled then
            AmethystMusic:Play()
            if not getgenv().IsUsingCustomMusic then
                pcall(function()
                    game.StarterGui:SetCore("SendNotification", {Title = "Nhac nen", Text = "Dang phat: " .. targetName, Duration = 5})
                end)
            end
        end
    else        if getgenv().MusicEnabled and not AmethystMusic.IsPlaying then
            AmethystMusic:Play()
        elseif not getgenv().MusicEnabled and AmethystMusic.IsPlaying then
            AmethystMusic:Stop()
        end
    end
end

task.spawn(function()
    task.wait(1)
    getgenv().ApplyMusicSettings()
end)
