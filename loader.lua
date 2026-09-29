--// 🪽 Seraphim-Hub | PARA BOTS
--// Clica para Teleportar

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SeraphimHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

--==================================================
-- PAINEL
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(300, 160)
Main.Position = UDim2.new(0.5, -150, 0.5, -80)
Main.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 120, 255)
Stroke.Thickness = 1
Stroke.Parent = Main

--==================================================
-- TOPO
--==================================================

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 38)
Top.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
Top.BorderSizePixel = 0
Top.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = Top

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -55, 1, 0)
Title.Position = UDim2.fromOffset(10, 0)
Title.BackgroundTransparency = 1
Title.Text = "🪽 Seraphim-Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

--==================================================
-- BOTÃO FECHAR
--==================================================

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(28, 28)
CloseButton.Position = UDim2.new(1, -33, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(35, 40, 52)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 13
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Top

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 7)
CloseCorner.Parent = CloseButton

--==================================================
-- FUNÇÃO: ENCONTRAR BASE
--==================================================

local function FindBaseSpawn()
    local Base = workspace:FindFirstChild("Base", true)
    if Base then
        if Base:IsA("SpawnLocation") then return Base end
        if Base:IsA("Model") then
            local Spawn = Base:FindFirstChildWhichIsA("SpawnLocation", true)
            if Spawn then return Spawn end
        end
        if Base:IsA("BasePart") then return Base end
    end

    local Spawns = {}
    for _, Obj in ipairs(workspace:GetDescendants()) do
        if Obj:IsA("SpawnLocation") then
            table.insert(Spawns, Obj)
        end
    end

    if #Spawns == 1 then return Spawns[1] end

    for _, Spawn in ipairs(Spawns) do
        local Nome = string.lower(Spawn.Name)
        if Nome:find("base") or Nome:find("spawn") or Nome:find("home") then
            return Spawn
        end
    end

    warn("Seraphim-Hub: Ponto da Base não encontrado!")
    return nil
end

--==================================================
-- FUNÇÃO: TELEPORTAR PARA BASE
--==================================================

local function TeleportToBase()
    local Point = FindBaseSpawn()
    if not Point then return end

    local Character = Player.Character
    if not Character then return end
    
    local Root = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not Root or not Humanoid then return end

    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    Humanoid.PlatformStand = true

    local NovaPosicao = Point.CFrame + Vector3.new(0, 4, 0)
    Root.CFrame = NovaPosicao
    task.wait()
    Root.CFrame = NovaPosicao

    task.wait(0.15)
    if Humanoid then
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        Humanoid.PlatformStand = false
    end

    print("Seraphim-Hub: PARA BOTS — Teleportado ✅")
end

--==================================================
-- BOTÃO PARA BOTS
--==================================================

local BostButton = Instance.new("TextButton")
BostButton.Size = UDim2.new(1, -20, 0, 45)
BostButton.Position = UDim2.fromOffset(10, 55)
BostButton.BackgroundColor3 = Color3.fromRGB(0, 100, 210)
BostButton.BorderSizePixel = 0
BostButton.Text = "🏠 PARA BOTS"
BostButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BostButton.TextSize = 15
BostButton.Font = Enum.Font.GothamBold
BostButton.Parent = Main

local BostCorner = Instance.new("UICorner")
BostCorner.CornerRadius = UDim.new(0, 8)
BostCorner.Parent = BostButton

BostButton.MouseButton1Click:Connect(function()
    TeleportToBase()
end)

--==================================================
-- BOTÃO REABRIR
--==================================================

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "Reabrir"
OpenButton.Size = UDim2.fromOffset(60, 60)
OpenButton.Position = UDim2.fromOffset(18, 200)
OpenButton.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
OpenButton.Text = "SH"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 14
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenButton

--==================================================
-- ABRIR / FECHAR
--==================================================

CloseButton.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenButton.Visible = false
end)

--==================================================
-- ARRASTAR JANELA
--==================================================

local Dragging = false
local DragStart, StartPos

Top.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        StartPos = Main.Position
        
        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not Dragging then return end
    if Input.UserInputType == Enum.UserInputType.MouseMovement
    or Input.UserInputType == Enum.UserInputType.Touch then
        local Delta = Input.Position - DragStart
        Main.Position = UDim2.new(
            StartPos.X.Scale, StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
        )
    end
end)

--==================================================
-- INÍCIO
--==================================================

print("🪽 Seraphim-Hub carregado! Clica em PARA BOTS para teleportar!")
