--// 🪽 SERAPHIM-HUB
--// Painel compacto para uso no seu próprio jogo Roblox

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

local function CreateTabButton(Text, Y)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -12, 0, 38)
    Button.Position = UDim2.fromOffset(6, Y)
    Button.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    Button.BorderSizePixel = 0
    Button.Text = Text
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
-- BOTÕES
--==================================================

local function CreateButton(Parent, Text, Y)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -24, 0, 38)
    Button.Position = UDim2.fromOffset(12, Y)
    Button.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
    Button.BorderSizePixel = 0
    Button.Text = Text
    Button.TextColor3 = Color3.fromRGB(240, 240, 245)
    Button.TextSize = 13
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
        AutoButton.Text = "Auto Roubar Ovos: LIGADO"
        AutoButton.BackgroundColor3 = Color3.fromRGB(0, 100, 210)

        -- Coloque aqui a função da mecânica do seu próprio jogo.
        print("SERAPHIM: automação ativada")
    else
        AutoButton.Text = "Auto Roubar Ovos: DESLIGADO"
        AutoButton.BackgroundColor3 = Color3.fromRGB(25, 30, 42)

        print("SERAPHIM: automação desativada")
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

    print("SERAPHIM: todas as automações paradas")
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
    local Humanoid =
        Character and Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        Humanoid.WalkSpeed = Velocidade
    end
end)

--==================================================
-- TELEPORTE: SPAWN
--==================================================

local TeleportSpawn = CreateButton(
    Teleports,
    "Teleportar para Spawn",
    12
)

TeleportSpawn.MouseButton1Click:Connect(function()
    local Character = Player.Character
    local Root =
        Character and Character:FindFirstChild("HumanoidRootPart")

    if Root then
        Root.CFrame = CFrame.new(0, 5, 0)
    end
end)

--==================================================
-- TELEPORTE: CIMA
--==================================================

local TeleportUp = CreateButton(
    Teleports,
    "Teleportar para Cima",
    58
)

TeleportUp.MouseButton1Click:Connect(function()
    local Character = Player.Character
    local Root =
        Character and Character:FindFirstChild("HumanoidRootPart")

    if Root then
        Root.CFrame =
            Root.CFrame + Vector3.new(0, 100, 0)
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



-- Carrega a biblioteca de UI Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu"))()

-- Cria a janela principal
local Window = Rayfield:CreateWindow({
    Name = "✨ SERAPHIM | Blue Edition",
    LoadingTitle = "Carregando Seraphim...",
    LoadingSubtitle = "by Seraphim Team",

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SeraphimConfig",
        FileName = "Config"
    },

    Discord = {
        Enabled = true,
        Invite = "C6Tm4fVKAR",
        RememberJoins = true
    },

    KeySystem = false,
    Theme = "Default"
})

-- TAB 1: Funções Principais
local MainTab = Window:CreateTab("Principal ⚡", 4483362458)

local ToggleAutoFarm = MainTab:CreateToggle({
    Name = "Auto Roubar / Auto Farm",
    CurrentValue = false,
    Flag = "ToggleFarm",

    Callback = function(Value)
        _G.AutoFarm = Value

        if Value then
            task.spawn(function()
                while _G.AutoFarm do
                    task.wait(0.1)
                    print("Seraphim: função ativada...")
                end
            end)
        end
    end,
})

local ToggleAntiHit = MainTab:CreateToggle({
    Name = "Anti-Hit / Bypass Guardas",
    CurrentValue = false,
    Flag = "ToggleAntiHit",

    Callback = function(Value)
        _G.AntiHit = Value
        print("Anti-Hit alternado:", Value)
    end,
})

-- TAB 2: Configurações do Personagem
local PlayerTab = Window:CreateTab("Jogador 👤", 4483362458)

local SliderSpeed = PlayerTab:CreateSlider({
    Name = "Velocidade de Movimento (Speed)",
    Range = {16, 200},
    Increment = 1,
    Suffix = " Speed",
    CurrentValue = 16,
    Flag = "SliderSpeed",

    Callback = function(Value)
        local Player = game:GetService("Players").LocalPlayer
        local Character = Player.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end,
})

-- TAB 3: Status / Alvos
local InfoTab = Window:CreateTab("Status / Alvos 📊", 4483362458)

local DropdownAlvos = InfoTab:CreateDropdown({
    Name = "Selecionar Alvo Raro",

    Options = {
        "Ovo Comum (R$ 10)",
        "Ovo Raro (R$ 50)",
        "Ovo Lendário (R$ 250)",
        "Ovo Mítico (R$ 1000)"
    },

    CurrentOption = {"Ovo Comum (R$ 10)"},
    MultipleOptions = false,
    Flag = "DropdownAlvos",

    Callback = function(Option)
        print("Alvo selecionado no Seraphim:", Option)
    end,
})

-- Botões de Controle
local LabelInfo = MainTab:CreateLabel("Controles Rápidos:")

local ButtonStart = MainTab:CreateButton({
    Name = "INICIAR SCRIPT (START)",

    Callback = function()
        Rayfield:Notify({
            Title = "Seraphim Blue",
            Content = "Script iniciado com sucesso!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

local ButtonStop = MainTab:CreateButton({
    Name = "PARAR TUDO (STOP)",

    Callback = function()
        _G.AutoFarm = false
        _G.AntiHit = false

        ToggleAutoFarm:Set(false)
        ToggleAntiHit:Set(false)

        Rayfield:Notify({
            Title = "Seraphim Blue",
            Content = "Todas as funções foram paradas.",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})



A correção mais importante: removi o CustomTheme, que era um dos pontos mais prováveis de incompatibilidade, e corrigi o CreateSlider para o formato usado pelas versões atuais do Rayfield.


