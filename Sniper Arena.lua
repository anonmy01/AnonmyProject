-- AnonmyHub | SNIPER ARENA (Silent Aim + Headshot)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = workspace.CurrentCamera
end)

local AimbotConfig = { Enabled = false, FOVRadius = 180, HeadshotMode = true }

---------------------------------------------------------
-- 1. CRIAR A INTERFACE
---------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnonmyHubSniper"
local okUI = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not okUI then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 240)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "AnonmyHub | Silent Aim"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = MainFrame

local SilentBtn = Instance.new("TextButton")
SilentBtn.Size = UDim2.new(1, -20, 0, 30)
SilentBtn.Position = UDim2.new(0, 10, 0, 40)
SilentBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SilentBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SilentBtn.Text = "Silent Aim: OFF"
SilentBtn.Font = Enum.Font.SourceSans
SilentBtn.TextSize = 14
SilentBtn.Parent = MainFrame
SilentBtn.MouseButton1Click:Connect(function()
    AimbotConfig.Enabled = not AimbotConfig.Enabled
    SilentBtn.Text = "Silent Aim: " .. (AimbotConfig.Enabled and "ON" or "OFF")
    SilentBtn.BackgroundColor3 = AimbotConfig.Enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
end)

local HeadshotBtn = Instance.new("TextButton")
HeadshotBtn.Size = UDim2.new(1, -20, 0, 30)
HeadshotBtn.Position = UDim2.new(0, 10, 0, 80)
HeadshotBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
HeadshotBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HeadshotBtn.Text = "Headshot Mode: ON"
HeadshotBtn.Font = Enum.Font.SourceSans
HeadshotBtn.TextSize = 14
HeadshotBtn.Parent = MainFrame
HeadshotBtn.MouseButton1Click:Connect(function()
    AimbotConfig.HeadshotMode = not AimbotConfig.HeadshotMode
    HeadshotBtn.Text = "Headshot Mode: " .. (AimbotConfig.HeadshotMode and "ON" or "OFF")
    HeadshotBtn.BackgroundColor3 = AimbotConfig.HeadshotMode and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
end)

local FovLabel = Instance.new("TextLabel")
FovLabel.Size = UDim2.new(0.5, -10, 0, 30)
FovLabel.Position = UDim2.new(0, 10, 0, 120)
FovLabel.BackgroundTransparency = 1
FovLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
FovLabel.Text = "Tamanho do FOV:"
FovLabel.Font = Enum.Font.SourceSans
FovLabel.TextSize = 14
FovLabel.TextXAlignment = Enum.TextXAlignment.Left
FovLabel.Parent = MainFrame

local FovBox = Instance.new("TextBox")
FovBox.Size = UDim2.new(0.5, -10, 0, 30)
FovBox.Position = UDim2.new(0.5, 0, 0, 120)
FovBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FovBox.TextColor3 = Color3.fromRGB(255, 255, 255)
FovBox.Text = "180"
FovBox.Font = Enum.Font.SourceSans
FovBox.TextSize = 14
FovBox.Parent = MainFrame
FovBox.FocusLost:Connect(function()
    local val = tonumber(FovBox.Text)
    if val then AimbotConfig.FOVRadius = val end
end)

local WsLabel = Instance.new("TextLabel")
WsLabel.Size = UDim2.new(0.5, -10, 0, 30)
WsLabel.Position = UDim2.new(0, 10, 0, 160)
WsLabel.BackgroundTransparency = 1
WsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
WsLabel.Text = "WalkSpeed:"
WsLabel.Font = Enum.Font.SourceSans
WsLabel.TextSize = 14
WsLabel.TextXAlignment = Enum.TextXAlignment.Left
WsLabel.Parent = MainFrame

local WsBox = Instance.new("TextBox")
WsBox.Size = UDim2.new(0.5, -10, 0, 30)
WsBox.Position = UDim2.new(0.5, 0, 0, 160)
WsBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
WsBox.TextColor3 = Color3.fromRGB(255, 255, 255)
WsBox.Text = "16"
WsBox.Font = Enum.Font.SourceSans
WsBox.TextSize = 14
WsBox.Parent = MainFrame
WsBox.FocusLost:Connect(function()
    local val = tonumber(WsBox.Text)
    if val then local c = LocalPlayer.Character if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed = val end end
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(1, -20, 0, 30)
CloseBtn.Position = UDim2.new(0, 10, 0, 200)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "Fechar Script"
CloseBtn.Font = Enum.Font.SourceSans
CloseBtn.TextSize = 14
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("Interface do AnonmyHub carregada com sucesso!")

---------------------------------------------------------
-- 2. SILENT AIM EM UMA THREAD SEPARADA (Isolado)
---------------------------------------------------------
task.spawn(function()
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = false
    FOVCircle.Thickness = 1
    FOVCircle.Transparency = 0.7
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.Filled = false
    FOVCircle.NumSides = 64

    RunService.RenderStepped:Connect(function()
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Radius = AimbotConfig.FOVRadius
        FOVCircle.Visible = AimbotConfig.Enabled
    end)

    local ok1, EntityService = pcall(function() return require(ReplicatedStorage.Remote.EntityService) end)
    local ok2, ClientShootableComponent = pcall(function() return require(ReplicatedStorage.Client.CombatController.ClientComponent.ClientShootableComponent) end)

    if not (ok1 and ok2) then
        warn("Sniper Arena: Serviços de combate não encontrados.")
        return
    end

    -- MECÂNICA DE HEADSHOT
    local function GetTargetPart(Character, PreferHeadshot)
        if not Character then return nil end
        if PreferHeadshot then
            local Head = Character:FindFirstChild("Head")
            if Head and Head:IsA("BasePart") then return Head end
        end
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then return HumanoidRootPart end
        for _, Part in pairs(Character:GetChildren()) do
            if Part:IsA("BasePart") then return Part end
        end
        return nil
    end

    local function GetEntityPosition(EntityModel, PreferHeadshot)
        if not EntityModel then return nil, nil end
        local TargetPart = GetTargetPart(EntityModel, PreferHeadshot)
        if TargetPart then return TargetPart, TargetPart.Position end
        return nil, nil
    end

    local function IsInFOV(WorldPosition)
        if not Camera then return false, math.huge end
        local ScreenPos, OnScreen = Camera:WorldToViewportPoint(WorldPosition)
        if not OnScreen then return false, math.huge end
        local MousePos = UserInputService:GetMouseLocation()
        local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
        return Distance <= AimbotConfig.FOVRadius, Distance
    end

    local function GetClosestEnemyInFOV()
        local LocalEntity = EntityService.GetLocalEntity()
        if not LocalEntity or not LocalEntity.World or not LocalEntity.World.EntitiesByTeam then return nil end
        local ClosestTarget, ClosestDistance = nil, math.huge
        for _, TeamDict in pairs(LocalEntity.World.EntitiesByTeam) do
            local Items = TeamDict._items or TeamDict
            for _, Entity in pairs(Items) do
                if not EntityService.IsLocalEntity(Entity) and Entity:IsAlive() then
                    local Inst = Entity.Instance
                    local Character = (Inst and Inst:IsA("Player")) and Inst.Character or Inst
                    if Character then
                        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                        if Humanoid and Humanoid.Health > 0 then
                            local Part, Position = GetEntityPosition(Character, AimbotConfig.HeadshotMode)
                            if Position then
                                local InFOV, Distance = IsInFOV(Position)
                                if InFOV and Distance < ClosestDistance then
                                    ClosestTarget = { Part = Part, Position = Position }
                                    ClosestDistance = Distance
                                end
                            end
                        end
                    end
                end
            end
        end
        return ClosestTarget
    end

    local SilentTarget = nil
    local OrigLocalShoot = ClientShootableComponent.LocalShoot
    local OrigOriginFn, OrigTargetFn
    for i = 1, 20 do
        local success, val = pcall(debug.getupvalue, OrigLocalShoot, i)
        if success and type(val) == "function" then
            local testSuccess, ret1, ret2, ret3 = pcall(val)
            if testSuccess then
                if typeof(ret1) == "CFrame" and typeof(ret3) == "table" then OrigOriginFn = val
                elseif typeof(ret1) == "Vector3" and typeof(ret2) == "Instance" then OrigTargetFn = val end
            end
        end
    end

    local hookOk = pcall(function()
        if OrigOriginFn then
            local OldOriginFn; OldOriginFn = hookfunction(OrigOriginFn, function(...)
                local cf, pos, meta = OldOriginFn(...)
                if SilentTarget and AimbotConfig.Enabled then return CFrame.lookAt(cf.Position, SilentTarget.Position), pos, meta end
                return cf, pos, meta
            end)
        end
        if OrigTargetFn then
            local OldTargetFn; OldTargetFn = hookfunction(OrigTargetFn, function(...)
                if SilentTarget and AimbotConfig.Enabled then return SilentTarget.Position, SilentTarget.Part end
                return OldTargetFn(...)
            end)
        end
        local OldLocalShoot; OldLocalShoot = hookfunction(ClientShootableComponent.LocalShoot, function(Self, ...)
            if AimbotConfig.Enabled then SilentTarget = GetClosestEnemyInFOV() end
            if type(OldLocalShoot) == "function" then
                local Result = OldLocalShoot(Self, ...)
                SilentTarget = nil
                return Result
            end
        end)
    end)

    if not hookOk then
        warn("ERRO: Seu executor não suporta 'hookfunction'. O Silent Aim não vai funcionar.")
    end
end)