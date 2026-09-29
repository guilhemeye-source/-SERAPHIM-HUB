--==================================================
-- SERAPHIM HUB
-- Interface autossuficiente para Roblox Studio
-- Sem Fluent / sem GitHub / sem loadstring
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- CONFIGURAÇÕES
--==================================================

local BLUE = Color3.fromRGB(0, 120, 255)
local DARK = Color3.fromRGB(10, 12, 18)
local SURFACE = Color3.fromRGB(20, 24, 34)
local SURFACE2 = Color3.fromRGB(27, 32, 45)
local WHITE = Color3.fromRGB(255, 255, 255)
local MUTED = Color3.fromRGB(170, 180, 195)

local AutoFarmEnabled = false
local SpeedValue = 16

--==================================================
-- GUI PRINCIPAL
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SeraphimHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

--==================================================
-- FUNÇÕES DA INTERFACE
--==================================================

local function Corner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = object
    return corner
end

local function Stroke(object, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Transparency = transparency or 0
    stroke.Thickness = 1
    stroke.Parent = object
    return stroke
end

local function Label(parent, text, size, position, fontSize)
    local label = Instance.new("TextLabel")

    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = WHITE
    label.Font = Enum.Font.Gotham
    label.TextSize = fontSize
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    return label
end

--==================================================
-- JANELA
--==================================================

local Window = Instance.new("Frame")

Window.Name = "Window"
Window.Size = UDim2.fromOffset(580, 460)
Window.Position = UDim2.fromScale(0.5, 0.5)
Window.AnchorPoint = Vector2.new(0.5, 0.5)
Window.BackgroundColor3 = DARK
Window.Parent = ScreenGui

Corner(Window, 14)
Stroke(Window, BLUE, 0.25)

--==================================================
-- CABEÇALHO
--==================================================

local Header = Instance.new("Frame")

Header.Size = UDim2.new(1, 0, 0, 65)
Header.BackgroundColor3 = SURFACE
Header.BorderSizePixel = 0
Header.Parent = Window

Corner(Header, 14)

local Title = Label(
    Header,
    "Seraphim-Hub",
    UDim2.new(1, -30, 0, 30),
    UDim2.fromOffset(18, 10),
    21
)

Title.Font = Enum.Font.GothamBold

local SubTitle = Label(
    Header,
    "by Delta User",
    UDim2.new(1, -30, 0, 18),
    UDim2.fromOffset(19, 38),
    11
)

SubTitle.TextColor3 = MUTED

--==================================================
-- ÁREA DAS ABAS
--==================================================

local TabBar = Instance.new("Frame")

TabBar.Size = UDim2.new(0, 150, 1, -65)
TabBar.Position = UDim2.fromOffset(0, 65)
TabBar.BackgroundColor3 = SURFACE
TabBar.BorderSizePixel = 0
TabBar.Parent = Window

--==================================================
-- ÁREA DE CONTEÚDO
--==================================================

local Content = Instance.new("Frame")

Content.Size = UDim2.new(1, -150, 1, -65)
Content.Position = UDim2.fromOffset(150, 65)
Content.BackgroundColor3 = DARK
Content.BorderSizePixel = 0
Content.Parent = Window

--==================================================
-- CRIAÇÃO DAS ABAS
--==================================================

local MainTab = Instance.new("TextButton")

MainTab.Size = UDim2.new(1, -20, 0, 45)
MainTab.Position = UDim2.fromOffset(10, 15)
MainTab.BackgroundColor3 = BLUE
MainTab.Text = "⚙  Automação"
MainTab.TextColor3 = WHITE
MainTab.Font = Enum.Font.GothamBold
MainTab.TextSize = 13
MainTab.AutoButtonColor = false
MainTab.Parent = TabBar

Corner(MainTab, 9)

local TeleportTab = Instance.new("TextButton")

TeleportTab.Size = UDim2.new(1, -20, 0, 45)
TeleportTab.Position = UDim2.fromOffset(10, 70)
TeleportTab.BackgroundColor3 = SURFACE2
TeleportTab.Text = "◆  Teleportes"
TeleportTab.TextColor3 = MUTED
TeleportTab.Font = Enum.Font.GothamBold
TeleportTab.TextSize = 13
TeleportTab.AutoButtonColor = false
TeleportTab.Parent = TabBar

Corner(TeleportTab, 9)

--==================================================
-- PÁGINA AUTOMACÃO
--==================================================

local MainPage = Instance.new("Frame")

MainPage.Size = UDim2.fromScale(1, 1)
MainPage.BackgroundTransparency = 1
MainPage.Parent = Content

Label(
    MainPage,
    "AUTOMAÇÃO",
    UDim2.new(1, -40, 0, 25),
    UDim2.fromOffset(20, 18),
    17
).Font = Enum.Font.GothamBold

local Info = Label(
    MainPage,
    "Controles principais do Seraphim-Hub",
    UDim2.new(1, -40, 0, 20),
    UDim2.fromOffset(20, 45),
    11
)

Info.TextColor3 = MUTED

--==================================================
-- TOGGLE AUTO FARM
--==================================================

local AutoFarmButton = Instance.new("TextButton")

AutoFarmButton.Size = UDim2.new(1, -40, 0, 55)
AutoFarmButton.Position = UDim2.fromOffset(20, 80)
AutoFarmButton.BackgroundColor3 = SURFACE
AutoFarmButton.Text = ""
AutoFarmButton.AutoButtonColor = false
AutoFarmButton.Parent = MainPage

Corner(AutoFarmButton, 10)
Stroke(AutoFarmButton, Color3.fromRGB(55, 65, 80), 0.25)

Label(
    AutoFarmButton,
    "Ativar Auto Farm",
    UDim2.new(1, -100, 0, 23),
    UDim2.fromOffset(15, 7),
    14
).Font = Enum.Font.GothamBold

local AutoDescription = Label(
    AutoFarmButton,
    "Ativa ou desativa o sistema de automação",
    UDim2.new(1, -100, 0, 18),
    UDim2.fromOffset(15, 30),
    10
)

AutoDescription.TextColor3 = MUTED

local AutoState = Instance.new("TextLabel")

AutoState.Size = UDim2.fromOffset(55, 27)
AutoState.Position = UDim2.new(1, -70, 0.5, -13)
AutoState.BackgroundColor3 = Color3.fromRGB(50, 60, 75)
AutoState.Text = "OFF"
AutoState.TextColor3 = MUTED
AutoState.Font = Enum.Font.GothamBold
AutoState.TextSize = 11
AutoState.Parent = AutoFarmButton

Corner(AutoState, 7)

AutoFarmButton.MouseButton1Click:Connect(function()

    AutoFarmEnabled = not AutoFarmEnabled

    if AutoFarmEnabled then
        AutoState.Text = "ON"
        AutoState.BackgroundColor3 = BLUE
        AutoState.TextColor3 = WHITE
    else
        AutoState.Text = "OFF"
        AutoState.BackgroundColor3 = Color3.fromRGB(50, 60, 75)
        AutoState.TextColor3 = MUTED
    end

end)

--==================================================
-- SLIDER DE VELOCIDADE
--==================================================

Label(
    MainPage,
    "VELOCIDADE DO PERSONAGEM",
    UDim2.new(1, -40, 0, 20),
    UDim2.fromOffset(20, 155),
    12
).Font = Enum.Font.GothamBold

local SpeedValueLabel = Label(
    MainPage,
    "16",
    UDim2.fromOffset(50, 20),
    UDim2.new(1, -70, 0, 153),
    12
)

SpeedValueLabel.TextXAlignment = Enum.TextXAlignment.Right
SpeedValueLabel.TextColor3 = BLUE

local SliderBackground = Instance.new("Frame")

SliderBackground.Size = UDim2.new(1, -40, 0, 8)
SliderBackground.Position = UDim2.fromOffset(20, 190)
SliderBackground.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
SliderBackground.BorderSizePixel = 0
SliderBackground.Parent = MainPage

Corner(SliderBackground, 5)

local SliderFill = Instance.new("Frame")

SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = BLUE
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBackground

Corner(SliderFill, 5)

local SliderButton = Instance.new("TextButton")

SliderButton.Size = UDim2.fromOffset(18, 18)
SliderButton.Position = UDim2.new(0, -9, 0.5, -9)
SliderButton.BackgroundColor3 = WHITE
SliderButton.Text = ""
SliderButton.AutoButtonColor = false
SliderButton.Parent = SliderBackground

Corner(SliderButton, 50)

local draggingSlider = false

local function SetSpeedFromMouse(mouseX)

    local relative =
        math.clamp(
            (mouseX - SliderBackground.AbsolutePosition.X)
            / SliderBackground.AbsoluteSize.X,
            0,
            1
        )

    SpeedValue = math.floor(16 + (150 - 16) * relative)

    SpeedValueLabel.Text = tostring(SpeedValue)

    SliderFill.Size =
        UDim2.new(relative, 0, 1, 0)

    SliderButton.Position =
        UDim2.new(relative, -9, 0.5, -9)

    local character = Player.Character
    local humanoid =
        character and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.WalkSpeed = SpeedValue
    end
end

SliderButton.MouseButton1Down:Connect(function()
    draggingSlider = true
end)

UserInputService.InputEnded:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        draggingSlider = false
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not draggingSlider then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        SetSpeedFromMouse(input.Position.X)
    end
end)

--==================================================
-- LOOP DO AUTO FARM
--==================================================

task.spawn(function()

    while ScreenGui.Parent do

        task.wait(0.1)

        if AutoFarmEnabled then

            -- Coloque aqui a lógica específica
            -- do seu sistema de automação.

        end
    end

end)

--==================================================
-- PÁGINA TELEPORTES
--==================================================

local TeleportPage = Instance.new("Frame")

TeleportPage.Size = UDim2.fromScale(1, 1)
TeleportPage.BackgroundTransparency = 1
TeleportPage.Visible = false
TeleportPage.Parent = Content

Label(
    TeleportPage,
    "TELEPORTES",
    UDim2.new(1, -40, 0, 25),
    UDim2.fromOffset(20, 18),
    17
).Font = Enum.Font.GothamBold

local TeleportInfo = Label(
    TeleportPage,
    "Escolha um local para teleportar",
    UDim2.new(1, -40, 0, 20),
    UDim2.fromOffset(20, 45),
    11
)

TeleportInfo.TextColor3 = MUTED

--==================================================
-- BOTÃO DE TELEPORTE
--==================================================

local TeleportButton = Instance.new("TextButton")

TeleportButton.Size = UDim2.new(1, -40, 0, 65)
TeleportButton.Position = UDim2.fromOffset(20, 85)
TeleportButton.BackgroundColor3 = SURFACE
TeleportButton.Text = ""
TeleportButton.AutoButtonColor = false
TeleportButton.Parent = TeleportPage

Corner(TeleportButton, 10)
Stroke(TeleportButton, Color3.fromRGB(55, 65, 80), 0.25)

local TeleportTitle = Label(
    TeleportButton,
    "Teleportar para o Topo/Base",
    UDim2.new(1, -30, 0, 25),
    UDim2.fromOffset(15, 8),
    14
)

TeleportTitle.Font = Enum.Font.GothamBold

local TeleportDescription = Label(
    TeleportButton,
    "Ir para a posição configurada",
    UDim2.new(1, -30, 0, 18),
    UDim2.fromOffset(15, 35),
    10
)

TeleportDescription.TextColor3 = MUTED

TeleportButton.MouseButton1Click:Connect(function()

    local Character = Player.Character

    if not Character then
        return
    end

    local RootPart =
        Character:FindFirstChild("HumanoidRootPart")

    if not RootPart then
        return
    end

    -- Mude estas coordenadas para o local desejado.
    RootPart.CFrame =
        CFrame.new(0, 100, 0)

    ShowNotification(
        "Seraphim-Hub",
        "Teleportado com sucesso!"
    )

end)

--==================================================
-- NOTIFICAÇÃO
--==================================================

function ShowNotification(title, message)

    local Notification = Instance.new("Frame")

    Notification.Size =
        UDim2.fromOffset(300, 75)

    Notification.Position =
        UDim2.new(1, -320, 1, -95)

    Notification.BackgroundColor3 =
        SURFACE2

    Notification.Parent = ScreenGui

    Corner(Notification, 10)
    Stroke(Notification, BLUE, 0.2)

    local NotificationTitle = Label(
        Notification,
        title,
        UDim2.new(1, -30, 0, 23),
        UDim2.fromOffset(15, 9),
        14
    )

    NotificationTitle.Font =
        Enum.Font.GothamBold

    local NotificationMessage = Label(
        Notification,
        message,
        UDim2.new(1, -30, 0, 25),
        UDim2.fromOffset(15, 35),
        10
    )

    NotificationMessage.TextColor3 = MUTED

    task.delay(3, function()

        if Notification then
            Notification:Destroy()
        end

    end)

end

--==================================================
-- TROCA DE ABA
--==================================================

MainTab.MouseButton1Click:Connect(function()

    MainPage.Visible = true
    TeleportPage.Visible = false

    MainTab.BackgroundColor3 = BLUE
    MainTab.TextColor3 = WHITE

    TeleportTab.BackgroundColor3 = SURFACE2
    TeleportTab.TextColor3 = MUTED

end)

TeleportTab.MouseButton1Click:Connect(function()

    MainPage.Visible = false
    TeleportPage.Visible = true

    TeleportTab.BackgroundColor3 = BLUE
    TeleportTab.TextColor3 = WHITE

    MainTab.BackgroundColor3 = SURFACE2
    MainTab.TextColor3 = MUTED

end)

--==================================================
-- ARRASTAR A JANELA
--==================================================

local draggingWindow = false
local dragStart = nil
local startPosition = nil

Header.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        draggingWindow = true
        dragStart = input.Position
        startPosition = Window.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not draggingWindow then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        local delta =
            input.Position - dragStart

        Window.Position =
            UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
    end
end)

UserInputService.InputEnded:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        draggingWindow = false
    end
end)

--==================================================
-- NOTIFICAÇÃO INICIAL
--==================================================

ShowNotification(
    "Seraphim-Hub",
    "Interface carregada com sucesso!"
)



