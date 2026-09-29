--// 🪽 SERAPHIM-HUB - VERSÃO CORRIGIDA
--// Painel compacto para seu próprio jogo no Roblox Studio

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

local AutoRoubar = false
local Velocidade = 16
local PararRoubo = false

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
Main.Size = UDim2.fromOffset(320, 235)
Main.Position = UDim2.new(0.5, -160, 0.5, -117)
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
Title.Text = "🪽 SERAPHIM-HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

--==================================================
-- BOTÃO X
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
-- ABAS
--==================================================

local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(0, 85, 1, -38)
Tabs.Position = UDim2.fromOffset(0, 38)
Tabs.BackgroundColor3 = Color3.fromRGB(12, 15, 22)
Tabs.BorderSizePixel = 0
Tabs.Parent = Main

local function CreateTabButton(Text, Y)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 34)
    Button.Position = UDim2.fromOffset(5, Y)
    Button.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    Button.BorderSizePixel = 0
    Button.Text = Text
    Button.TextColor3 = Color3.fromRGB(220, 225, 235)
    Button.TextSize = 11
    Button.Font = Enum.Font.GothamSemibold
    Button.Parent = Tabs

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, 6)
    C.Parent = Button

    return Button
end

local MainTabButton = CreateTabButton("Automação", 10)
local TeleportTabButton = CreateTabButton("Teleportes", 50)

--==================================================
-- CONTEÚDO
--==================================================

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -85, 1, -38)
Content.Position = UDim2.fromOffset(85, 38)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Automation = Instance.new("Frame")
Automation.Size = UDim2.fromScale(1, 1)
Automation.BackgroundTransparency = 1
Automation.Parent = Content

local Teleports = Instance.new("Frame")
Teleports.Size = UDim2.fromScale(1, 1)
Teleports.BackgroundTransparency = 1
Teleports.Visible = false
Teleports.Parent = Content

--==================================================
-- CRIAR BOTÃO
--==================================================

local function CreateButton(Parent, Text, Y)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 34)
    Button.Position = UDim2.fromOffset(10, Y)
    Button.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
    Button.BorderSizePixel = 0
    Button.Text = Text
    Button.TextColor3 = Color3.fromRGB(240, 240, 245)
    Button.TextSize = 11
    Button.Font = Enum.Font.GothamSemibold
    Button.Parent = Parent

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, 6)
    C.Parent = Button

    return Button
end

--==================================================
-- AUTO ROUBAR
--==================================================

local AutoButton = CreateButton(Automation, "Auto Roubar Ovos: DESLIGADO", 12)

AutoButton.MouseButton1Click:Connect(function()
    AutoRoubar = not AutoRoubar
    PararRoubo = false

    if AutoRoubar then
        AutoButton.Text = "Auto Roubar Ovos: LIGADO"
        AutoButton.BackgroundColor3 = Color3.fromRGB(0, 100, 210)
        print("SERAPHIM: Auto Roubar ativado")
    else
        AutoButton.Text = "Auto Roubar Ovos: DESLIGADO"
        AutoButton.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
        print("SERAPHIM: Auto Roubar desativado")
    end
end)

--==================================================
-- STOP
--==================================================

local StopButton = CreateButton(Automation, "⛔ STOP", 54)

StopButton.MouseButton1Click:Connect(function()
    AutoRoubar = false
    PararRoubo = true
    AutoButton.Text = "Auto Roubar Ovos: DESLIGADO"
    AutoButton.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
    print("SERAPHIM: automação parada")
end)

--==================================================
-- VELOCIDADE
--==================================================

local SpeedButton = CreateButton(Automation, "Velocidade: 16", 96)

SpeedButton.MouseButton1Click:Connect(function()
    Velocidade += 10
    if Velocidade > 150 then
        Velocidade = 16
    end
    SpeedButton.Text = "Velocidade: " .. Velocidade

    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.WalkSpeed = Velocidade
    end
end)

--==================================================
-- FUNÇÃO PARA ENCONTRAR SPAWN
--==================================================

local function FindBaseSpawn()
    -- 1. Procura uma pasta/objeto chamada Base
    local Base = workspace:FindFirstChild("Base", true)
    if Base then
        if Base:IsA("SpawnLocation") then
            return Base
        end
        if Base:IsA("Model") then
            local Spawn = Base:FindFirstChildWhichIsA("SpawnLocation", true)
            if Spawn then return Spawn end
        end
        if Base:IsA("BasePart") then
            return Base
        end
    end

    -- 2. Procura SpawnLocations no Workspace
    local Spawns = {}
    for _, Object in ipairs(workspace:GetDescendants()) do
        if Object:IsA("SpawnLocation") then
            table.insert(Spawns, Object)
        end
    end

    -- 3. Se houver apenas um SpawnLocation, usa ele automaticamente
    if #Spawns == 1 then
        return Spawns[1]
    end

    -- 4. Tenta encontrar nomes relacionados à base
    for _, Spawn in ipairs(Spawns) do
        local Name = string.lower(Spawn.Name)
        if Name:find("base") or Name:find("spawn") or Name:find("home") then
            return Spawn
        end
    end

    warn("SERAPHIM: Spawn não encontrado! Verifique se há um objeto chamado 'Base' ou 'SpawnLocation' no jogo.")
    return nil
end

--==================================================
-- TELEPORTAR PARA BASE - ✅ CORRIGIDO (NÃO VOLTA)
--==================================================

local function TeleportToBase()
    local Point = FindBaseSpawn()
    if not Point then
        warn("SERAPHIM: Nenhum Spawn encontrado!")
        return
    end

    local Character = Player.Character
    if not Character then return end
    
    local Root = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not Root or not Humanoid then return end

    -- PARA TODO MOVIMENTO ANTES DE TELEPORTAR
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    Humanoid.PlatformStand = true

    -- Posição estável e com altura correta
    local NovaPosicao = Point.CFrame + Vector3.new(0, 4, 0)
    
    -- DUPLA garantia de posição
    Root.CFrame = NovaPosicao
    task.wait()
    Root.CFrame = NovaPosicao

    -- Libera movimento DEPOIS de confirmar
    task.wait(0.15)
    if Humanoid then
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        Humanoid.PlatformStand = false
    end

    print("SERAPHIM: Ficou no lugar! ✅")
end

--==================================================
-- BOTÃO BASE
--==================================================

local TeleportBase = CreateButton(Teleports, "🏠 Teleportar para Base", 12)
TeleportBase.MouseButton1Click:Connect(function()
    TeleportToBase()
end)

--==================================================
-- TELEPORTE PARA CIMA - ✅ CORRIGIDO
--==================================================

local TeleportUp = CreateButton(Teleports, "⬆️ Teleportar para Cima", 54)
TeleportUp.MouseButton1Click:Connect(function()
    local Character = Player.Character
    if not Character then return end
    
    local Root = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not Root or not Humanoid then return end

    Humanoid.Sit = false
    Humanoid.PlatformStand = true

    local NovaPosicao = Root.CFrame + Vector3.new(0, 100, 0)
    Root.CFrame = NovaPosicao

    task.wait(0.1)
    if Humanoid then
        Humanoid.PlatformStand = false
    end

    print("SERAPHIM: Subiu ✅")
end)

--==================================================
-- ABAS
--==================================================

MainTabButton.MouseButton1Click:Connect(function()
    Automation.Visible = true
    Teleports.Visible = false
    MainTabButton.BackgroundColor3 = Color3.fromRGB(0, 100, 210)
    TeleportTabButton.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
end)

TeleportTabButton.MouseButton1Click:Connect(function()
    Automation.Visible = false
    Teleports.Visible = true
    MainTabButton.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    TeleportTabButton.BackgroundColor3 = Color3.fromRGB(0, 100, 210)
end)

--==================================================
-- BOLINHA SERAPHIM
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
-- FECHAR
--==================================================

CloseButton.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenButton.Visible = true
end)

--==================================================
-- ABRIR
--==================================================

OpenButton.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenButton.Visible = false
end)

--==================================================
-- ARRASTAR
--==================================================

local Dragging = false
local DragStart
local StartPosition

Top.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position

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
            StartPosition.X.Scale, StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y
        )
    end
end)

--==================================================
-- INICIALIZAÇÃO
--==================================================

MainTabButton.BackgroundColor3 = Color3.fromRGB(0, 100, 210)
print("🪽 SERAPHIM-HUB carregado!")
