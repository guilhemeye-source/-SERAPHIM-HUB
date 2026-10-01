-- Seraphim-Hub | Anti-Lag + Lista de Teleporte
-- Lista clicável + Teleporte consertado

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- CONFIGURAÇÃO
--==================================================

local TEMPO_NO_FINAL = 7
local ALTURA_DO_TELEPORTE = 3.2
local TEMPO_ENTRE_AREAS = 0.35
local DISTANCIA_DETECCAO = 250

local TENTATIVAS_TELEPORTE = 3
local ZERA_VELOCIDADE = true

--==================================================
-- ÁREAS
--==================================================

local BiomasDoJogo = {
    [0] = "SafeZone",
    [1] = "Forest",
    [2] = "Lake",
    [3] = "Desert",
    [4] = "Jungle",
    [5] = "Snow",
    [6] = "Volcano",
    [7] = "AbyssOcean",
    [8] = "Prehistoric",
    [9] = "Cosmic",
    [10] = "CherryBlossom",
    [11] = "TitanTemple",
    [12] = "AngelsDemons"
}

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SeraphimHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = PlayerGui
end

--==================================================
-- PAINEL PRINCIPAL
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(220, 135)
Main.Position = UDim2.new(0.5, -110, 0.5, -67)
Main.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 9)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(100, 200, 255)
Stroke.Thickness = 2
Stroke.Parent = Main

--==================================================
-- TOPO
--==================================================

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 32)
Top.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
Top.BorderSizePixel = 0
Top.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 9)
TopCorner.Parent = Top

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -42, 1, 0)
Title.Position = UDim2.fromOffset(9, 0)
Title.BackgroundTransparency = 1
Title.Text = "Seraphim-Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

--==================================================
-- FECHAR
--==================================================

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(24, 24)
CloseButton.Position = UDim2.new(1, -29, 0, 4)
CloseButton.BackgroundColor3 = Color3.fromRGB(30, 34, 43)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 11
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Top

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

--==================================================
-- STATUS
--==================================================

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -16, 0, 25)
Status.Position = UDim2.fromOffset(8, 42)
Status.BackgroundTransparency = 1
Status.Text = "Escolha uma área"
Status.TextColor3 = Color3.fromRGB(180, 190, 200)
Status.TextSize = 11
Status.Font = Enum.Font.Gotham
Status.TextXAlignment = Enum.TextXAlignment.Center
Status.Parent = Main

--==================================================
-- ÁREA DA LISTA
--==================================================

local ListFrame = Instance.new("ScrollingFrame")
ListFrame.Name = "ListaDeAreas"
ListFrame.Size = UDim2.new(1, -16, 0, 250)
ListFrame.Position = UDim2.fromOffset(8, 72)
ListFrame.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
ListFrame.BorderSizePixel = 0
ListFrame.ScrollBarThickness = 4
ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ListFrame.Parent = Main

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 7)
ListCorner.Parent = ListFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = ListFrame

--==================================================
-- FUNÇÕES
--==================================================

local function EncontrarContainer()
    return workspace:FindFirstChild("Zones") or workspace
end

local function EncontrarArea(Nome)

    local Container = EncontrarContainer()

    local Area = Container:FindFirstChild(Nome)

    if Area then
        return Area
    end

    for _, Object in ipairs(Container:GetDescendants()) do

        if Object.Name == Nome
        and (
            Object:IsA("Model")
            or Object:IsA("Folder")
            or Object:IsA("BasePart")
        ) then

            return Object
        end
    end

    return nil
end

local function EncontrarPontoDaArea(Area)

    if not Area then
        return nil
    end

    if Area:IsA("BasePart") then
        return Area.CFrame
    end

    if Area:IsA("Model") then

        local Success, Pivot = pcall(function()
            return Area:GetPivot()
        end)

        if Success and Pivot then
            return Pivot
        end
    end

    local Part =
        Area:FindFirstChildWhichIsA(
            "BasePart",
            true
        )

    if Part then
        return Part.CFrame
    end

    return nil
end

--==================================================
-- TELEPORTE
--==================================================

local function Teleportar(Nome)

    local Character = Player.Character

    if not Character then
        Status.Text = "Personagem não encontrado!"
        return
    end

    local Root =
        Character:FindFirstChild(
            "HumanoidRootPart"
        )

    if not Root then
        Status.Text = "HumanoidRootPart não encontrado!"
        return
    end

    local Area = EncontrarArea(Nome)

    if not Area then
        Status.Text = "Área não encontrada!"
        warn("Seraphim-Hub: Área não encontrada:", Nome)
        return
    end

    local Posicao =
        EncontrarPontoDaArea(Area)

    if not Posicao then
        Status.Text = "Ponto não encontrado!"
        return
    end

    local Hum =
        Character:FindFirstChildOfClass(
            "Humanoid"
        )

    if Hum then
        Hum:SetStateEnabled(
            Enum.HumanoidStateType.FallingDown,
            false
        )

        Hum:SetStateEnabled(
            Enum.HumanoidStateType.Falling,
            false
        )
    end

    Root.AssemblyLinearVelocity =
        Vector3.zero

    Root.AssemblyAngularVelocity =
        Vector3.zero

    Root.CFrame =
        Posicao
        + Vector3.new(
            0,
            ALTURA_DO_TELEPORTE,
            0
        )

    Status.Text =
        "Teleportado: " .. Nome

    task.wait(0.1)

    if Hum then
        Hum:SetStateEnabled(
            Enum.HumanoidStateType.FallingDown,
            true
        )

        Hum:SetStateEnabled(
            Enum.HumanoidStateType.Falling,
            true
        )
    end
end

--==================================================
-- CRIAR LISTA CLICÁVEL
--==================================================

for ID = 0, 12 do

    local Nome = BiomasDoJogo[ID]

    if Nome then

        local Button =
            Instance.new("TextButton")

        Button.Name = Nome
        Button.Size =
            UDim2.new(1, -10, 0, 34)

        Button.BackgroundColor3 =
            Color3.fromRGB(20, 24, 32)

        Button.BorderSizePixel = 0

        Button.Text = Nome

        Button.TextColor3 =
            Color3.fromRGB(255, 255, 255)

        Button.TextSize = 12

        Button.Font =
            Enum.Font.GothamBold

        Button.LayoutOrder = ID

        Button.Parent = ListFrame

        local ButtonCorner =
            Instance.new("UICorner")

        ButtonCorner.CornerRadius =
            UDim.new(0, 6)

        ButtonCorner.Parent = Button

        Button.MouseButton1Click:Connect(function()

            Teleportar(Nome)

        end)
    end
end

-- Atualiza o tamanho da lista

Layout:GetPropertyChangedSignal(
    "AbsoluteContentSize"
):Connect(function()

    ListFrame.CanvasSize =
        UDim2.new(
            0,
            0,
            0,
            Layout.AbsoluteContentSize.Y + 8
        )

end)

--==================================================
-- TAMANHO DO PAINEL
--==================================================

Main.Size =
    UDim2.fromOffset(
        220,
        350
    )

Main.Position =
    UDim2.new(
        0.5,
        -110,
        0.5,
        -175
    )

--==================================================
-- FECHAR
--==================================================

CloseButton.MouseButton1Click:Connect(function()

    Main.Visible = false

end)

--==================================================
-- ARRASTAR
--==================================================

local Dragging = false
local DragStart
local StartPos

Top.InputBegan:Connect(function(Input)

    if Input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or Input.UserInputType ==
        Enum.UserInputType.Touch then

        Dragging = true
        DragStart = Input.Position
        StartPos = Main.Position

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

        Main.Position =
            UDim2.new(
                StartPos.X.Scale,
                StartPos.X.Offset + Delta.X,
                StartPos.Y.Scale,
                StartPos.Y.Offset + Delta.Y
            )
    end
end)

print("Seraphim-Hub carregado!")



