--// 🪽 SERAPHIM-HUB
--// Painel compacto

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

local AutoRoubar = false
local Velocidade = 16
local PararRoubo = false

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SeraphimHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(420, 300)
Main.Position = UDim2.new(0.5, -210, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 120, 255)
Stroke.Thickness = 1
Stroke.Parent = Main

--==================================================
-- TOPO
--==================================================

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 42)
Top.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
Top.BorderSizePixel = 0
Top.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = Top

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.fromOffset(10, 0)
Title.BackgroundTransparency = 1
Title.Text = "🪽 SERAPHIM-HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

--==================================================
-- ABAS
--==================================================

local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(0, 105, 1, -42)
Tabs.Position = UDim2.fromOffset(0, 42)
Tabs.BackgroundColor3 = Color3.fromRGB(12, 15, 22)
Tabs.BorderSizePixel = 0
Tabs.Parent = Main

local function CreateTabButton(text, y)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -12, 0, 38)
    Button.Position = UDim2.fromOffset(6, y)
    Button.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(220, 225, 235)
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamSemibold
    Button.Parent = Tabs

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, 6)
    C.Parent = Button

    return Button
end

local MainTabButton = CreateTabButton("Automação", 10)
local TeleportTabButton = CreateTabButton("Teleportes", 55)

--==================================================
-- CONTEÚDO
--==================================================

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -105, 1, -42)
Content.Position = UDim2.fromOffset(105, 42)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Automation = Instance.new("Frame")
Automation.Size = UDim2.new(1, 0, 1, 0)
Automation.BackgroundTransparency = 1
Automation.Parent = Content

local Teleports = Instance.new("Frame")
Teleports.Size = UDim2.new(1, 0, 1, 0)
Teleports.BackgroundTransparency = 1
Teleports.Visible = false
Teleports.Parent = Content

--==================================================
-- BOTÃO
--==================================================

local function CreateButton(parent, text, y)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -24, 0, 38)
    Button.Position = UDim2.fromOffset(12, y)
    Button.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(240, 240, 245)
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamSemibold
    Button.Parent = parent

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, 6)
    C.Parent = Button

    return Button
end

--==================================================
-- AUTO ROUBAR — CONTROLE
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
        AutoButton.Text = "Auto Roubar Ovos: LIGADO"
        AutoButton.BackgroundColor3 = Color3.fromRGB(0, 100, 210)
    else
        AutoButton.Text = "Auto Roubar Ovos: DESLIGADO"
        AutoButton.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
    end
end)

--==================================================
-- STOP
--==================================================

local StopButton = CreateButton(
    Automation,
    "⛔ STOP",
    58
)

StopButton.MouseButton1Click:Connect(function()
    AutoRoubar = false
    PararRoubo = true

    AutoButton.Text = "Auto Roubar Ovos: DESLIGADO"
    AutoButton.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
end)

--==================================================
-- VELOCIDADE
--==================================================

local SpeedButton = CreateButton(
    Automation,
    "Velocidade: 16",
    104
)

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
-- TELEPORTES
--==================================================

local TeleportSpawn = CreateButton(
    Teleports,
    "Teleportar para Spawn",
    12
)

TeleportSpawn.MouseButton1Click:Connect(function()
    local Character = Player.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")

    if Root then
        Root.CFrame = CFrame.new(0, 5, 0)
    end
end)

local TeleportUp = CreateButton(
    Teleports,
    "Teleportar para Cima",
    58
)

TeleportUp.MouseButton1Click:Connect(function()
    local Character = Player.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")

    if Root then
        Root.CFrame = Root.CFrame + Vector3.new(0, 100, 0)
    end
end)

--==================================================
-- ABAS
--==================================================

MainTabButton.MouseButton1Click:Connect(function()
    Automation.Visible = true
    Teleports.Visible = false
end)

TeleportTabButton.MouseButton1Click:Connect(function()
    Automation.Visible = false
    Teleports.Visible = true
end)

--==================================================
-- ARRASTAR PAINEL
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
    if not Dragging then
        return
    end

    if Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch then

        local Delta = Input.Position - DragStart

        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

print("🪽 SERAPHIM-HUB carregado!")
