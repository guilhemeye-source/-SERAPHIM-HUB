--// 🪽 SERAPHIM-HUB
--// Painel compacto

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

local AutoRoubar = false
local Velocidade = 16
local PararRoubo = false

-- COLOQUE AQUI O ID DA IMAGEM ENVIADA AO ROBLOX
local SERAPHIM_IMAGE = "rbxassetid://SEU_ID_DA_IMAGEM"

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SeraphimHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

--==================================================
-- PAINEL PRINCIPAL MENOR
--==================================================

local Main = Instance.new("Frame")
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

    Button.BackgroundColor3 =
        Color3.fromRGB(20, 25, 35)

    Button.BorderSizePixel = 0
    Button.Text = Text
    Button.TextColor3 =
        Color3.fromRGB(220, 225, 235)

    Button.TextSize = 11
    Button.Font = Enum.Font.GothamSemibold
    Button.Parent = Tabs

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, 6)
    C.Parent = Button

    return Button
end

local MainTabButton =
    CreateTabButton("Automação", 10)

local TeleportTabButton =
    CreateTabButton("Teleportes", 50)

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
-- BOTÕES
--==================================================

local function CreateButton(Parent, Text, Y)

    local Button = Instance.new("TextButton")

    Button.Size = UDim2.new(1, -20, 0, 34)
    Button.Position = UDim2.fromOffset(10, Y)

    Button.BackgroundColor3 =
        Color3.fromRGB(25, 30, 42)

    Button.BorderSizePixel = 0
    Button.Text = Text
    Button.TextColor3 =
        Color3.fromRGB(240, 240, 245)

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

local AutoButton = CreateButton(
    Automation,
    "Auto Roubar Ovos: DESLIGADO",
    12
)

AutoButton.MouseButton1Click:Connect(function()

    AutoRoubar = not AutoRoubar
    PararRoubo = false

    if AutoRoubar then

        AutoButton.Text =
            "Auto Roubar Ovos: LIGADO"

        AutoButton.BackgroundColor3 =
            Color3.fromRGB(0, 100, 210)

    else

        AutoButton.Text =
            "Auto Roubar Ovos: DESLIGADO"

        AutoButton.BackgroundColor3 =
            Color3.fromRGB(25, 30, 42)
    end
end)

--==================================================
-- STOP
--==================================================

local StopButton = CreateButton(
    Automation,
    "⛔ STOP",
    54
)

StopButton.MouseButton1Click:Connect(function()

    AutoRoubar = false
    PararRoubo = true

    AutoButton.Text =
        "Auto Roubar Ovos: DESLIGADO"

    AutoButton.BackgroundColor3 =
        Color3.fromRGB(25, 30, 42)
end)

--==================================================
-- VELOCIDADE
--==================================================

local SpeedButton = CreateButton(
    Automation,
    "Velocidade: 16",
    96
)

SpeedButton.MouseButton1Click:Connect(function()

    Velocidade += 10

    if Velocidade > 150 then
        Velocidade = 16
    end

    SpeedButton.Text =
        "Velocidade: " .. Velocidade

    local Character = Player.Character

    local Humanoid =
        Character and
        Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        Humanoid.WalkSpeed = Velocidade
    end
end)

--==================================================
-- TELEPORTES
--==================================================

local TeleportPoints =
    workspace:FindFirstChild("TeleportPoints")

local function TeleportTo(Name)

    if not TeleportPoints then
        warn("Crie Workspace > TeleportPoints")
        return
    end

    local Point =
        TeleportPoints:FindFirstChild(Name)

    if not Point then
        warn("Ponto não encontrado: " .. Name)
        return
    end

    local Character = Player.Character

    local Root =
        Character and
        Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return
    end

    if Point:IsA("BasePart") then

        Root.CFrame =
            Point.CFrame +
            Vector3.new(0, 3, 0)

    elseif Point:IsA("Model") then

        local TargetPart =
            Point.PrimaryPart or
            Point:FindFirstChildWhichIsA("BasePart")

        if TargetPart then
            Root.CFrame =
                TargetPart.CFrame +
                Vector3.new(0, 3, 0)
        end
    end
end

local TeleportBase = CreateButton(
    Teleports,
    "🏠 Teleportar para Base",
    12
)

TeleportBase.MouseButton1Click:Connect(function()
    TeleportTo("Base")
end)

local TeleportUp = CreateButton(
    Teleports,
    "⬆️ Teleportar para Cima",
    54
)

TeleportUp.MouseButton1Click:Connect(function()

    local Character = Player.Character

    local Root =
        Character and
        Character:FindFirstChild("HumanoidRootPart")

    if Root then
        Root.CFrame =
            Root.CFrame +
            Vector3.new(0, 100, 0)
    end
end)

--==================================================
-- ABAS
--==================================================

MainTabButton.MouseButton1Click:Connect(function()

    Automation.Visible = true
    Teleports.Visible = false

    MainTabButton.BackgroundColor3 =
        Color3.fromRGB(0, 100, 210)

    TeleportTabButton.BackgroundColor3 =
        Color3.fromRGB(20, 25, 35)
end)

TeleportTabButton.MouseButton1Click:Connect(function()

    Automation.Visible = false
    Teleports.Visible = true

    MainTabButton.BackgroundColor3 =
        Color3.fromRGB(20, 25, 35)

    TeleportTabButton.BackgroundColor3 =
        Color3.fromRGB(0, 100, 210)
end)

--==================================================
-- BOLINHA COM A IMAGEM
--==================================================

local OpenButton = Instance.new("ImageButton")

OpenButton.Size = UDim2.fromOffset(62, 62)
OpenButton.Position = UDim2.fromOffset(18, 180)

OpenButton.BackgroundColor3 =
    Color3.fromRGB(10, 10, 18)

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
-- ABRIR NOVAMENTE
--==================================================

OpenButton.MouseButton1Click:Connect(function()

    Main.Visible = true
    OpenButton.Visible = false
end)

--==================================================
-- ARRASTAR PAINEL
--==================================================

local Dragging = false
local DragStart
local StartPosition

Top.InputBegan:Connect(function(Input)

    if Input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or Input.UserInputType ==
        Enum.UserInputType.Touch then

        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position

        Input.Changed:Connect(function()

            if Input.UserInputState ==
                Enum.UserInputState.End then

                Dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(Input)

    if not Dragging then
        return
    end

    if Input.UserInputType ==
        Enum.UserInputType.MouseMovement
        or Input.UserInputType ==
        Enum.UserInputType.Touch then

        local Delta =
            Input.Position - DragStart

        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

MainTabButton.BackgroundColor3 =
    Color3.fromRGB(0, 100, 210)

print("🪽 SERAPHIM-HUB carregado!")
