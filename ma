local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService") -- [NEW] Dịch vụ để xử lý kéo thả

-- ================= [NEW] HUTAO UI SYSTEM (MENU ẢNH) =================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("ImageLabel")
local StatusLabel = Instance.new("TextLabel")
local GeneralLabel = Instance.new("TextLabel") -- [NEW] Label hiển thị Thời gian chơi thực
local MoneyLabel = Instance.new("TextLabel")
local TimeLabel = Instance.new("TextLabel")
local TitleLabel = Instance.new("TextLabel")

-- [UPDATED] NÚT BẬT TẮT (IMAGE BUTTON + DRAGGABLE)
local ToggleButton = Instance.new("ImageButton") -- Đổi thành ImageButton
local ToggleCorner = Instance.new("UICorner")

-- Cấu hình UI
ScreenGui.Name = "AmethystHubUI"
ScreenGui.Parent = game.CoreGui

-- Cấu hình Nút Bật/Tắt (Icon Ảnh + Di chuyển)
ToggleButton.Name = "ToggleUI"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundTransparency = 0.0 -- Để nền nhẹ hoặc chỉnh thành 1 nếu muốn trong suốt
ToggleButton.Position = UDim2.new(0, 20, 0.4, 0) -- Vị trí mặc định
ToggleButton.Size = UDim2.new(0, 60, 0, 60) -- Kích thước nút (To hơn chút cho dễ bấm)
ToggleButton.Image = "rbxassetid://94506254187483" -- [UPDATED] ID Icon Của Bạn
-- Làm tròn nút
ToggleCorner.CornerRadius = UDim.new(1, 0) -- Bo tròn 100%
ToggleCorner.Parent = ToggleButton

-- [NEW] CODE XỬ LÝ KÉO THẢ NÚT (DRAGGABLE)
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
MainFrame.BackgroundTransparency = 1.000 -- Trong suốt để chỉ hiện ảnh
-- [UPDATED] VỊ TRÍ VÀ KÍCH THƯỚC
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) -- Neo tâm vào giữa
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- Vị trí chính giữa màn hình
MainFrame.Size = UDim2.new(0, 500, 0, 350) -- Kích thước to

-- [UPDATED] ID ẢNH MỚI CỦA BẠN
MainFrame.Image = "rbxassetid://105006398248081" 

-- Tạo khung nền mờ (phòng khi ảnh lỗi thì vẫn nhìn thấy menu)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BackgroundTransparency = 0.2

-- Tiêu đề (AMETHYST HUB)
TitleLabel.Name = "Title"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.BackgroundTransparency = 1.000
TitleLabel.Position = UDim2.new(0, 0, 0.05, 0)
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Font = Enum.Font.FredokaOne
TitleLabel.Text = "AMETHYST HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 85, 255) -- Màu hồng tím
TitleLabel.TextSize = 36.000 
TitleLabel.TextStrokeTransparency = 0.000 -- Viền đen

-- Status (Trạng thái)
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

-- [NEW] General (Tổng thời gian chơi thực tế) - Nằm dưới Status
GeneralLabel.Name = "General"
GeneralLabel.Parent = MainFrame
GeneralLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GeneralLabel.BackgroundTransparency = 1.000
GeneralLabel.Position = UDim2.new(0, 0, 0.45, 0) -- Nằm giữa Status và Money
GeneralLabel.Size = UDim2.new(1, 0, 0, 30)
GeneralLabel.Font = Enum.Font.SourceSansBold
GeneralLabel.Text = "General: Loading..."
GeneralLabel.TextColor3 = Color3.fromRGB(255, 255, 127) -- Màu vàng nhạt
GeneralLabel.TextSize = 24.000
GeneralLabel.TextStrokeTransparency = 0.500

-- Money (Tiền)
MoneyLabel.Name = "Money"
MoneyLabel.Parent = MainFrame
MoneyLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MoneyLabel.BackgroundTransparency = 1.000
MoneyLabel.Position = UDim2.new(0, 0, 0.55, 0)
MoneyLabel.Size = UDim2.new(1, 0, 0, 30)
MoneyLabel.Font = Enum.Font.SourceSansBold
MoneyLabel.Text = "Money: Loading..."
MoneyLabel.TextColor3 = Color3.fromRGB(85, 255, 127) -- Màu xanh lá
MoneyLabel.TextSize = 24.000
MoneyLabel.TextStrokeTransparency = 0.500

-- Time (Thời gian chạy Session)
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

-- [NEW] CHỨC NĂNG BẬT TẮT MENU (Sự kiện Click)
local isMenuVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    isMenuVisible = not isMenuVisible
    MainFrame.Visible = isMenuVisible
end)

-- Hàm cập nhật UI
local StartTime = os.time()
local CurrentStatus = "Dang khoi dong..."

local function UpdateUI()
    -- Cập nhật thời gian
    local Diff = os.time() - StartTime
    local Hours = math.floor(Diff / 3600)
    local Minutes = math.floor((Diff % 3600) / 60)
    local Seconds = Diff % 60
    TimeLabel.Text = string.format("Time: %02d Hours %02d Minutes %02d Second", Hours, Minutes, Seconds)
    
    -- Cập nhật trạng thái
    StatusLabel.Text = "Status: " .. CurrentStatus
    
    -- [UPDATED] Cập nhật General (Từ đường dẫn chính xác: PlayerData.Stats.General.TimePlayed)
    pcall(function()
        local timeData = LocalPlayer:FindFirstChild("PlayerData") 
            and LocalPlayer.PlayerData:FindFirstChild("Stats")
            and LocalPlayer.PlayerData.Stats:FindFirstChild("General")
            and LocalPlayer.PlayerData.Stats.General:FindFirstChild("TimePlayed")
            
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
    
    -- Cập nhật tiền (Giả sử tiền lưu trong Leaderstats, tuỳ game)
    pcall(function()
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        if leaderstats then
            local money = leaderstats:FindFirstChild("Credits") or leaderstats:FindFirstChild("Money") or leaderstats:FindFirstChild("Cash")
            if money then
                MoneyLabel.Text = "Money: " .. tostring(money.Value)
            else
                MoneyLabel.Text = "Money: Not Found"
            end
        else
             -- Một số game để tiền trong PlayerGui hoặc Attributes
            local guiMoney = LocalPlayer.PlayerGui:FindFirstChild("MainGui") and LocalPlayer.PlayerGui.MainGui:FindFirstChild("Money")
             if guiMoney and guiMoney:IsA("TextLabel") then
                 MoneyLabel.Text = "Money: " .. guiMoney.Text
             else
                 MoneyLabel.Text = "Money: ???"
             end
        end
    end)
end

-- Chạy vòng lặp update UI mỗi giây
task.spawn(function()
    while true do
        UpdateUI()
        task.wait(1)
    end
end)

-- Hàm set status từ bên ngoài
local function SetStatus(msg)
    CurrentStatus = msg
    UpdateUI()
end

-- ================= [NEW] HUTAO ANTI-BAN SYSTEM =================
-- 1. Anti-AFK (Chống kick do treo máy)
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- 2. Anti-Error Logging (Chống gửi lỗi về Server)
pcall(function()
    local ScriptContext = game:GetService("ScriptContext")
    ScriptContext.Error:Connect(function(msg, stack, script)
        -- Chặn không làm gì cả
    end)
end)

local function Notify(msg)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Amethyst Fix Glitch",
            Text = msg,
            Duration = 3
        })
    end)
end

Notify("Anti-Ban System (Hutao) Active!")

-- ================= CẤU HÌNH (AUTO RUN) =================
getgenv().AutoFarm = true        
getgenv().Invisible = true       
local MaxSearchDistance = 3000
local IgnoreList = {}
local IsInMatch = false
local IsHopping = false
local SafeDistance = 20 -- [UPDATED] Ha xuong con 20 studs

-- Vị trí sửa: Trước -> Phải -> Trái
local RepairOffsets = {
    CFrame.new(0, 0, -6),
    CFrame.new(6, 0, 0),
    CFrame.new(-6, 0, 0)
}

-- DELAY START 5 GIÂY
SetStatus("Đang khởi động vui lòng chờ⌚")
Notify("Dang khoi dong... (Doi 5s)")
task.wait(5) 
SetStatus("Đang chờ vào trận⏳")
Notify("Script Da Bat! Dang cho Survivor...")

-- ================= [CORE] KIỂM TRA SURVIVOR & KILLER =================
local function isSurvivorModel(char)
    if not char then return false end
    local survivorsFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Survivors")
    if survivorsFolder and survivorsFolder:FindFirstChild(char.Name) then
        return true 
    end
    return false 
end

-- [MOI] Ham kiem tra Killer chinh xac
local function isLocalPlayerKiller(char)
    if not char then return false end
    local killersFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
    if killersFolder and killersFolder:FindFirstChild(char.Name) then
        return true
    end
    return false
end

local function GetKiller()
    local killersFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
    if killersFolder then
        for _, k in pairs(killersFolder:GetChildren()) do
            if k:FindFirstChild("HumanoidRootPart") then
                return k
            end
        end
    end
    return nil
end

-- [FIXED] Thêm check để không trốn vào các máy bị lỗi toạ độ (Spawn)
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
                -- [FIX GLITCH] Bỏ qua nếu máy nằm ở toạ độ 0,0,0 (Lỗi map chưa load)
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

-- ================= 1. LOGIC TÀNG HÌNH & CAM (HUTAO STYLE) =================
local InvisAnimID = "rbxassetid://75804462760596"
local InvisTrack = nil
local InvisLoop = nil

local function StartInvisibleLoop()
    if InvisLoop then return end
    InvisLoop = task.spawn(function()
        while true do
            if not getgenv().Invisible then 
                if InvisTrack then InvisTrack:Stop(); InvisTrack = nil end
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
                end
                break 
            end
            
            local char = LocalPlayer.Character
            
            if IsInMatch and isSurvivorModel(char) then
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
                if InvisTrack then 
                    InvisTrack:Stop() 
                    InvisTrack = nil 
                end
                if char and char:FindFirstChild("Humanoid") then
                    Workspace.CurrentCamera.CameraSubject = char.Humanoid
                end
            end
            task.wait(0.5)
        end
    end)
end

StartInvisibleLoop()

-- ================= 2. LOGIC TÌM MÁY (HUTAO PATH) =================
local function GetProgress(gen)
    local p = gen:FindFirstChild("Progress")
    if p and p:IsA("NumberValue") then return p.Value end
    return nil
end

local function IsSpotBlocked(position)
    for _, plr in pairs(Players:GetPlayers()) do
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

-- [FIXED] Thêm check lỗi toạ độ 0,0,0
local function GetNextGenerator()
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
                                    ChosenSpot = spot
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return target, true, (TotalGens > 0 and Unfinished == 0), ChosenSpot
end

-- ================= [UPDATED] SMART SERVER HOP (TURBO + ANTI-FREEZE) =================
local function SmartServerHop()
    if IsHopping then return end
    IsHopping = true
    
    SetStatus("Hop sv⏳")
    Notify("Tim SV 2-3 (Turbo)...")
    
    local PlaceId = game.PlaceId
    
    local function HandleTeleportFail()
        Notify("Teleport Fail! Thu lai nhanh...")
        IsHopping = false
        task.wait(0.5) 
        SmartServerHop() 
    end

    local connection
    connection = TeleportService.TeleportInitFailed:Connect(function()
        if connection then connection:Disconnect() end
        HandleTeleportFail()
    end)
    
    local function ExecuteHop()
        local Cursor = ""
        local Found = false
        
        for i = 1, 5 do
            local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", PlaceId)
            if Cursor ~= "" then url = url .. "&cursor=" .. Cursor end
            
            local success, response = pcall(function()
                return HttpService:JSONDecode(request({Url = url}).Body)
            end)
            
            if success and response and response.data then
                for _, v in ipairs(response.data) do
                    if type(v) == "table" and v.playing and v.maxPlayers then
                        local freeSlots = v.maxPlayers - v.playing
                        
                        if v.playing >= 2 and v.playing <= 3 and v.id ~= game.JobId and freeSlots >= 2 then
                            Notify("Vao SV " .. v.playing .. " nguoi...")
                            TeleportService:TeleportToPlaceInstance(PlaceId, v.id, LocalPlayer)
                            Found = true
                            return 
                        end
                    end
                end
                
                if response.nextPageCursor then
                    Cursor = response.nextPageCursor
                else
                    break 
                end
            else
                
            end
        end
        
        if not Found then
            Notify("Khong thay. Random SV (Nhanh)...")
            local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100", PlaceId)
            local success, response = pcall(function()
                return HttpService:JSONDecode(request({Url = url}).Body)
            end)
            
            if success and response and response.data then
                local candidates = {}
                for _, v in ipairs(response.data) do
                    if (v.maxPlayers - v.playing) >= 2 and v.id ~= game.JobId then
                        table.insert(candidates, v)
                    end
                end
                
                if #candidates > 0 then
                    local target = candidates[math.random(1, #candidates)]
                    TeleportService:TeleportToPlaceInstance(PlaceId, target.id, LocalPlayer)
                else
                    HandleTeleportFail()
                end
            else
                HandleTeleportFail()
            end
        end
    end
    
    pcall(ExecuteHop)
end

-- ================= 3. VÒNG LẶP CHÍNH (AUTO FARM + RESET LOBBY) =================
task.spawn(function()
    while true do
        if getgenv().AutoFarm then
            pcall(function()
                local gen, mapLoaded, allFinished, targetPos = GetNextGenerator()
                
                if not mapLoaded then
                    if IsInMatch then 
                        IsInMatch = false 
                        SetStatus("Đã về lobby vui lòng chờ⏳")
                        Notify("Ve Sanh -> Tat Auto")
                    end
                else
                    -- [MOI] LOGIC CHECK KILLER (RESET NGAY LAP TUC)
                    if isLocalPlayerKiller(LocalPlayer.Character) then
                        SetStatus("Bạn là killer! Tự động reset 💬")
                        Notify("BAN LA KILLER! Reset de Farm tiep...")
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                            LocalPlayer.Character.Humanoid.Health = 0
                        end
                        task.wait(3) -- Doi respawn
                        return -- Bo qua vong lap nay
                    end

                    -- [NEW FEATURE] DEATH CHECK (Tat Auto Farm -> Hop Server)
                    if IsInMatch and not allFinished then
                        local char = LocalPlayer.Character
                        local hum = char and char:FindFirstChild("Humanoid")
                        -- Nếu máu về 0 (Chết)
                        if hum and hum.Health <= 0 then
                            getgenv().AutoFarm = false -- Tắt AutoFarm để không lỗi
                            SetStatus("Bị giết! Hop sv ngay⏳") -- Status mới
                            Notify("Ban da chet! Dang tim server khac...")
                            SmartServerHop() -- Kích hoạt Hop Server ngay lập tức
                            return -- Dừng xử lý vòng lặp này
                        end
                    end

                    if not isSurvivorModel(LocalPlayer.Character) then
                        return 
                    end
                    
                    if not IsInMatch then
                        SetStatus("Đã vào trận, vui lòng đợi 3.5s⏳")
                        Notify("Survivor Detected -> Doi 3.5s...")
                        task.wait(3.5) 
                        IsInMatch = true
                        SetStatus("Starting‼️")
                        Notify("Kich hoat Tang Hinh + Farm!")
                    end
                    
                    if allFinished then
                        SetStatus("Complete✅✅✅")
                        Notify("Xong Map -> Reset ve Lobby...")
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                            LocalPlayer.Character.Humanoid.Health = 0 
                        end
                        task.wait(3) 
                        Notify("Dang Hop Server...")
                        SmartServerHop()
                    end
                    
                    if gen and targetPos then
                        local root = LocalPlayer.Character.HumanoidRootPart
                        local pivot = gen:GetPivot()
                        
                        -- DROP 2.0 STUDS
                        local dropHeight = 2.0 
                        local dropPos = targetPos + Vector3.new(0, dropHeight, 0)
                        local lookAt = Vector3.new(pivot.Position.X, dropPos.Y, pivot.Position.Z)
                        
                        while getgenv().AutoFarm and (root.Position - dropPos).Magnitude > 3 do
                            SetStatus("Máy kế tiếp🎯")
                            -- CHECK KILLER
                            local killer = GetKiller()
                            if killer and killer:FindFirstChild("HumanoidRootPart") then
                                if (root.Position - killer.HumanoidRootPart.Position).Magnitude < SafeDistance then
                                    SetStatus("killer vẫn đang ở gần😨")
                                    Notify("Killer chan duong! Doi muc tieu...")
                                    break 
                                end
                            end
                            
                            if IsSpotBlocked(targetPos) then break end
                            root.CFrame = CFrame.lookAt(dropPos, lookAt)
                            root.Velocity = Vector3.zero
                            task.wait()
                        end
                        
                        if getgenv().AutoFarm then
                            -- FREEZE 1 GIÂY
                            root.Anchored = false 
                            task.wait(1) 
                            root.Anchored = true 
                            
                            local prompt = gen:FindFirstChild("Main") and gen.Main:FindFirstChild("Prompt")
                            if prompt then fireproximityprompt(prompt) end
                            
                            while getgenv().AutoFarm and GetProgress(gen) < 100 do
                                -- [FIX GLITCH] ANTI-STUCK KHI BỊ HIT (Check Khoảng Cách)
                                -- Nếu bị đánh văng xa quá 4 studs so với máy -> Gỡ Neo để bay lại
                                if (root.Position - dropPos).Magnitude > 4 then
                                     SetStatus("Bị đánh bay! Quay lại...🏃")
                                     root.Anchored = false
                                     break -- Break vòng lặp sửa để script tự bay lại máy
                                end

                                -- [FIX GLITCH] ANTI-RAGDOLL
                                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                                if hum and (hum.PlatformStand or hum.Sit) then
                                    SetStatus("Bị Té! Đang tự đứng dậy🧍")
                                    root.Anchored = false 
                                    hum.PlatformStand = false
                                    hum.Sit = false
                                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                                    task.wait(1.5) 
                                    break 
                                end

                                SetStatus("Đã sửa được " .. math.floor(GetProgress(gen)) .. "%")
                                if LocalPlayer.Character.Humanoid.Jump then
                                    root.Anchored = false; task.wait(1); break
                                end
                                if not root.Anchored then root.Anchored = true end
                                
                                -- [UPDATED] NÉ KILLER LOGIC (TELE TO SAFE GEN + WAIT 6S)
                                local killer = GetKiller()
                                if killer and killer:FindFirstChild("HumanoidRootPart") then
                                    local distToKiller = (root.Position - killer.HumanoidRootPart.Position).Magnitude
                                    
                                    if distToKiller < SafeDistance then
                                        if prompt then pcall(function() prompt:InputHoldEnd() end) end
                                        SetStatus("Killer đang ở gần😱")
                                        Notify("KILLER DEN (<20m)! Chay ngay...")
                                        
                                        -- Tim may phat dien xa nhat (Safe Gen)
                                        local safeGen = GetSafeGenerator(killer.HumanoidRootPart.Position)
                                        if safeGen then
                                            local safePos = safeGen:GetPivot().Position
                                            -- Teleport len noc may Safe Gen (hoac vi tri an toan)
                                            root.CFrame = CFrame.new(safePos + Vector3.new(0, 5, 0))
                                            root.Anchored = true
                                            
                                            SetStatus("Dang tron Killer (6s)...")
                                            Notify("Dang tron... Doi 6 giay")
                                            task.wait(6) -- [UPDATED] Doi 6 giay
                                            
                                            -- Sau 6 giay, check lai vi tri Killer so voi may CU (targetPos)
                                            local oldGenPos = targetPos
                                            repeat
                                                if not getgenv().AutoFarm then break end
                                                local kPosNew = killer.HumanoidRootPart.Position
                                                local distKillerToOldGen = (kPosNew - oldGenPos).Magnitude
                                                
                                                if distKillerToOldGen > (SafeDistance + 10) then
                                                    SetStatus("Killer di roi -> Ve sua")
                                                    Notify("Killer da di xa! Quay lai sua...")
                                                    break -- Thoat vong lap de quay lai sua
                                                else
                                                    SetStatus("Killer van o do! Doi...")
                                                    Notify("Killer van o do! Doi tiep...")
                                                    task.wait(1) -- Doi tiep neu Killer chua di
                                                end
                                            until false
                                            
                                            root.Anchored = false
                                            break -- Break vong lap sua may de thuc hien lai tu dau (Quay ve may)
                                        end
                                    end
                                end
                                
                                -- HOLD E LOGIC
                                if prompt then 
                                    pcall(function() 
                                        prompt:InputHoldBegin()
                                    end) 
                                end
                                
                                if gen:FindFirstChild("Remotes") and gen.Remotes:FindFirstChild("RE") then 
                                    gen.Remotes.RE:FireServer() 
                                end
                                task.wait(1.5)
                            end
                            
                            if prompt then pcall(function() prompt:InputHoldEnd() end) end
                            
                            root.Anchored = false
                            if GetProgress(gen) >= 100 then 
                                IgnoreList[gen] = true 
                                SetStatus("Xong 1 May!")
                                Notify("Xong 1 may!")
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.2)
    end
end)

-- ================= [HUTAO MUSIC SYSTEM V3 - DELAY 10S] =================
task.spawn(function()
    -- [UPDATED] ID NHẠC MỚI
    local MusicID = "rbxassetid://124384558101360" 
    local SoundService = game:GetService("SoundService")
    local SoundName = "AmethystHubMusic_V3"

    local function CreateAndPlayMusic()
        local Music = SoundService:FindFirstChild(SoundName)
        if not Music then
            Music = Instance.new("Sound")
            Music.Name = SoundName
            Music.Parent = SoundService 
            Music.SoundId = MusicID
            Music.Volume = 3
            Music.Looped = false -- [UPDATED] Tắt Looped để tự xử lý Delay
            Music:Play()
            
            -- Sự kiện khi nhạc kết thúc
            Music.Ended:Connect(function()
                task.wait(10) -- [UPDATED] Delay 10 giây
                Music:Play() -- Phát lại
            end)
            
            game.StarterGui:SetCore("SendNotification", {
                Title = "Nhạc nền",
                Text = "Đang phát nhạc...",
                Duration = 5
            })
        else
            if not Music.IsPlaying then
                Music:Play()
            end
        end
    end

    -- Chạy lần đầu
    pcall(CreateAndPlayMusic)
end)
