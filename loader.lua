--// Seraphim-Hub
--// Sistema de áreas com lista rolável

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

--==================================================
-- CONFIGURAÇÃO
--==================================================

local Altura = 4
local TempoEntreAreas = 0.25

local Areas = {
    {Nome = "SafeZone",       Display = "SafeZone"},
    {Nome = "Forest",         Display = "Forest"},
    {Nome = "Lake",           Display = "Lake"},
    {Nome = "Desert",         Display = "Desert"},
    {Nome = "Jungle",         Display = "Jungle"},
    {Nome = "Snow",           Display = "Snow"},
    {Nome = "Volcano",        Display = "Volcano"},
    {Nome = "AbyssOcean",     Display = "Abyss Ocean"},
    {Nome = "Prehistoric",    Display = "Prehistoric"},
    {Nome = "Cosmic",         Display = "Cosmic"},
    {Nome = "CherryBlossom",  Display = "Cherry Blossom"},
    {Nome = "TitanTemple",    Display = "Titan Temple"},
    {Nome = "AngelsDemons",   Display = "Angels & Demons"}
}

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SeraphimHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(245, 280)
Main.Position = UDim2.new(0.5, -122, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 9)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(100, 200, 255)
MainStroke.Thickness = 2
MainStroke.Parent = Main

--==================================================
-- TOPO
--==================================================

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 34)
Top.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
Top.BorderSizePixel = 0
Top.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 9)
TopCorner.Parent = Top

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -45, 1, 0)
Title.Position = UDim2.fromOffset(9, 0)
Title.BackgroundTransparency = 1
Title.Text = "Seraphim-Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(24, 24)
CloseButton.Position = UDim2.new(1, -29, 0, 5)
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
Status.Position = UDim2.fromOffset(8, 40)
Status.BackgroundTransparency = 1
Status.Text = "Escolha uma área"
Status.TextColor3 = Color3.fromRGB(180, 190, 200)
Status.TextSize = 11
Status.Font = Enum.Font.Gotham
Status.Parent = Main

--==================================================
-- LISTA ROLÁVEL
--==================================================

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "ListaAreas"
ScrollingFrame.Size = UDim2.new(1, -16, 0, 150)
ScrollingFrame.Position = UDim2.fromOffset(8, 67)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(9, 11, 16)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 5
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.Parent = Main

local ScrollCorner = Instance.new("UICorner")
ScrollCorner.CornerRadius = UDim.new(0, 7)
ScrollCorner.Parent = ScrollingFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 4)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = ScrollingFrame

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollingFrame.CanvasSize = UDim2.new(
        0,
        0,
        0,
        Layout.AbsoluteContentSize.Y + 8
    )
end)

--==================================================
-- BOTÕES DE ÁREA
--==================================================

local AreaSelecionada = nil

local function AtualizarSelecao()

    for _, Button in ipairs(ScrollingFrame:GetChildren()) do

        if Button:IsA("TextButton") then

            if Button:GetAttribute("Area") == AreaSelecionada then
                Button.BackgroundColor3 = Color3.fromRGB(0, 90, 150)
            else
                Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            end

        end
    end
end

for Index, Area in ipairs(Areas) do

    local Button = Instance.new("TextButton")

    Button.Size = UDim2.new(1, -8, 0, 30)
    Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Button.BorderSizePixel = 0
    Button.Text = Area.Display
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 12
    Button.Font = Enum.Font.GothamBold
    Button.LayoutOrder = Index
    Button:SetAttribute("Area", Area.Nome)
    Button.Parent = ScrollingFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button

    Button.MouseButton1Click:Connect(function()

        AreaSelecionada = Area.Nome

        Status.Text = "Destino: " .. Area.Display

        AtualizarSelecao()
    end)
end

--==================================================
-- BOTÃO STOP BOTS
--==================================================

local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(1, -16, 0, 38)
StopButton.Position = UDim2.fromOffset(8, 224)
StopButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StopButton.BorderSizePixel = 0
StopButton.Text = "🛑 Stop Bots"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.TextSize = 13
StopButton.Font = Enum.Font.GothamBold
StopButton.Parent = Main

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 7)
StopCorner.Parent = StopButton

--==================================================
-- ENCONTRAR CONTAINER
--==================================================

local function EncontrarContainer()

    local Zones = workspace:FindFirstChild("Zones")

    if Zones then
        return Zones
    end

    return workspace
end

--==================================================
-- ENCONTRAR ÁREA
--==================================================

local function EncontrarArea(Nome)

    local Container = EncontrarContainer()

    local Area = Container:FindFirstChild(Nome)

    if Area then
        return Area
    end

    for _, Object in ipairs(Container:GetDescendants()) do

        if Object.Name == Nome
        and (Object:IsA("Model") or Object:IsA("Folder")) then

            return Object
        end
    end

    return nil
end

--==================================================
-- PEGAR POSIÇÃO DA ÁREA
--==================================================

local function PegarPosicao(Area)

    if not Area then
        return nil
    end

    if Area:IsA("Model") then

        local Success, Pivot = pcall(function()
            return Area:GetPivot()
        end)

        if Success then
            return Pivot
        end
    end

    if Area:IsA("BasePart") then
        return Area.CFrame
    end

    local Part = Area:FindFirstChildWhichIsA(
        "BasePart",
        true
    )

    if Part then
        return Part.CFrame
    end

    return nil
end

--==================================================
-- DETECTAR ÁREA ATUAL
--==================================================

local function DetectarAreaAtual()

    local Character = Player.Character

    if not Character then
        return nil
    end

    local Root = Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return nil
    end

    local MelhorArea = nil
    local MenorDistancia = math.huge

    for _, AreaInfo in ipairs(Areas) do

        local Area = EncontrarArea(AreaInfo.Nome)

        if Area then

            local Posicao = PegarPosicao(Area)

            if Posicao then

                local Distancia =
                    (Root.Position - Posicao.Position).Magnitude

                if Distancia < MenorDistancia then

                    MenorDistancia = Distancia
                    MelhorArea = AreaInfo.Nome

                end
            end
        end
    end

    return MelhorArea
end

--==================================================
-- CRIAR ROTA
--==================================================

local function CriarRota(Destino)

    local Atual = DetectarAreaAtual()

    local IndiceAtual = nil
    local IndiceDestino = nil

    for Index, Area in ipairs(Areas) do

        if Area.Nome == Atual then
            IndiceAtual = Index
        end

        if Area.Nome == Destino then
            IndiceDestino = Index
        end
    end

    if not IndiceDestino then
        return {}
    end

    -- Se já estiver no destino,
    -- começa pela próxima área.
    if IndiceAtual == IndiceDestino then

        IndiceAtual = IndiceAtual + 1

        if IndiceAtual > #Areas then
            IndiceAtual = 1
        end
    end

    local Rota = {}

    --==================================================
    -- ANGELS DEMONS
    --==================================================

    if Destino == "AngelsDemons" then

        table.insert(Rota, Areas[IndiceDestino])

        return Rota
    end

    --==================================================
    -- CAMINHO NORMAL
    --==================================================

    if IndiceAtual and IndiceAtual < IndiceDestino then

        for I = IndiceAtual + 1, IndiceDestino do
            table.insert(Rota, Areas[I])
        end

    elseif IndiceAtual and IndiceAtual > IndiceDestino then

        for I = IndiceAtual - 1, IndiceDestino, -1 do
            table.insert(Rota, Areas[I])
        end

    else

        for I = 1, IndiceDestino do
            table.insert(Rota, Areas[I])
        end
    end

    return Rota
end

--==================================================
-- TELEPORTE
--==================================================

local Executando = false

local function TeleportarParaArea(AreaInfo)

    local Character = Player.Character

    if not Character then
        return false
    end

    local Root = Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return false
    end

    local Area = EncontrarArea(AreaInfo.Nome)

    if not Area then
        warn("Área não encontrada:", AreaInfo.Nome)
        return false
    end

    local Posicao = PegarPosicao(Area)

    if not Posicao then
        warn("Não foi possível obter posição:", AreaInfo.Nome)
        return false
    end

    Root.CFrame =
        Posicao + Vector3.new(0, Altura, 0)

    return true
end

--==================================================
-- EXECUTAR
--==================================================

local function Executar()

    if Executando then
        return
    end

    if not AreaSelecionada then

        Status.Text = "Escolha uma área!"

        return
    end

    local Rota = CriarRota(AreaSelecionada)

    if #Rota == 0 then

        Status.Text = "Rota vazia!"
        return
    end

    Executando = true

    for Index, AreaInfo in ipairs(Rota) do

        if not Executando then
            break
        end

        Status.Text =
            AreaInfo.Display
            .. "  "
            .. Index
            .. "/"
            .. #Rota

        TeleportarParaArea(AreaInfo)

        task.wait(TempoEntreAreas)
    end

    Status.Text = "Destino alcançado!"
    Executando = false
end

StopButton.MouseButton1Click:Connect(function()

    task.spawn(Executar)

end)

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

    if not Dragging then
        return
    end

    if Input.UserInputType == Enum.UserInputType.MouseMovement
    or Input.UserInputType == Enum.UserInputType.Touch then

        local Delta =
            Input.Position - DragStart

        Main.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + Delta.Y
        )
    end
end)

print("Seraphim-Hub carregado!")
