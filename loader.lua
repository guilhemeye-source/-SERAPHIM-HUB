--// 🪽 SERAPHIM-HUB - Versão BOST
--// Só Teleporte ao pegar ovo

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local AtivarBost = false
local UltimoOvo = nil

-- Coloque o ID da imagem do SERAPHIM aqui
local SERAPHIM_IMAGE = "rbxassetid://SEU_ID_DA_IMAGEM"

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
Title.Text = "🪽 BOST"
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

    warn("BOST: Ponto da Base não encontrado!")
    return nil
end

--==================================================
-- FUNÇÃO: TELEPORTAR
--==================================================

local function TeleportParaBase()
    local Ponto = FindBaseSpawn()
    if not Ponto then return end

    local Char = Player.Character
    if not Char then return end

    local Root = Char:FindFirstChild("HumanoidRootPart")
    local Humanoid = Char:FindFirstChild("Humanoid")
    if not Root or not Humanoid then return end

    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
    Humanoid.PlatformStand = true

    local PosicaoFinal = Ponto.CFrame + Vector3.new(0, 4, 0)
    Root.CFrame = PosicaoFinal
    task.wait()
    Root.CFrame = PosicaoFinal

    task.wait(0.15)
    if Humanoid then
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        Humanoid.PlatformStand = false
    end

    print("BOST: Teleportado ✅")
end

--==================================================
-- BOTÃO PRINCIPAL
--==================================================

local BotaoBOST = Instance.new("TextButton")
BotaoBOST.Size = UDim2.new(1, -20, 0, 45)
BotaoBOST.Position = UDim2.fromOffset(10, 55)
BotaoBOST.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
BotaoBOST.BorderSizePixel = 0
BotaoBOST.Text = "BOST: DESLIGADO"
BotaoBOST.TextColor3 = Color3.fromRGB(240, 240, 245)
BotaoBOST.TextSize = 13
BotaoBOST.Font = Enum.Font.GothamSemibold
BotaoBOST.Parent = Main

local BotaoCorner = Instance.new("UICorner")
BotaoCorner.CornerRadius = UDim.new(0, 8)
BotaoCorner.Parent = BotaoBOST

BotaoBOST.MouseButton1Click:Connect(function()
    AtivarBost = not AtivarBost
    if AtivarBost then
        BotaoBOST.Text = "BOST: LIGADO ✅"
        BotaoBOST.BackgroundColor3 = Color3.fromRGB(0, 100, 210)
        print("BOST: Ativado — teleporta ao pegar ovo")
    else
        BotaoBOST.Text = "BOST: DESLIGADO"
        BotaoBOST.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
        UltimoOvo = nil
        print("BOST: Desativado")
    end
end)

--==================================================
-- DETECTAR QUANDO PEGAR OVO
--==================================================

RunService.Heartbeat:Connect(function()
    if not AtivarBost then return end

    local Char = Player.Character
    if not Char then return end

    local Pasta = Char:FindFirstChild("HoldItem") or Char:FindFirstChild("EquippedItem") or Char:FindFirstChild("Ovo")
    local TemOvo = Pasta and Pasta:FindFirstChildWhichIsA("BasePart") or Pasta and Pasta:FindFirstChild("Model")

    if TemOvo and TemOvo ~= UltimoOvo then
        UltimoOvo = TemOvo
        task.wait(0.05)
        TeleportParaBase()
    end
end)

--==================================================
-- BOLINHA PARA REABRIR
--==================================================

local OpenButton = Instance.new("ImageButton")
OpenButton.Name = "SeraphimOpen"
OpenButton.Size = UDim2.fromOffset(62, 62)
OpenButton.Position = UDim2.fromOffset(18, 180)
OpenButton.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
OpenButton.BorderSizePixel = 0
OpenButton.Image = SERAPHIM_IMAGE
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(130, 70, 255)
OpenStroke.Thickness = 2
OpenStroke.Parent = OpenButton

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
-- ARRASTAR
--==================================================

local Arrastando = false
local InicioPosicao, InicioTela

Top.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Arrastando = true
        InicioTela = Input.Position
        InicioPosicao = Main.Position
        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Arrastando = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not Arrastando then return end
    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
        local Delta = Input.Position - InicioTela
        Main.Position = UDim2.new(
            InicioPosicao.X.Scale, InicioPosicao.X.Offset + Delta.X,
            InicioPosicao.Y.Scale, InicioPosicao.Y.Offset + Delta.Y
        )
    end
end)

--==================================================
-- INICIO
--==================================================

print("🪽 BOST carregado! Clique para LIGAR")
