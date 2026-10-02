--// Seraphim-Hub
--// Sistema de áreas + linha branca + teleporte direto
--// Para uso no seu próprio jogo no Roblox Studio

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

--==================================================
-- CONFIGURAÇÃO
--==================================================

local DistanciaDoChao = 0.05
local TempoEntreAreas = 0.8

local Areas = {
    {Nome = "SafeZone",      Display = "SafeZone"},
    {Nome = "Forest",        Display = "Forest"},
    {Nome = "Lake",          Display = "Lake"},
    {Nome = "Desert",        Display = "Desert"},
    {Nome = "Jungle",        Display = "Jungle"},
    {Nome = "Snow",          Display = "Snow"},
    {Nome = "Volcano",       Display = "Volcano"},
    {Nome = "AbyssOcean",    Display = "Abyss Ocean"},
    {Nome = "Prehistoric",   Display = "Prehistoric"},
    {Nome = "Cosmic",        Display = "Cosmic"},
    {Nome = "CherryBlossom", Display = "Cherry Blossom"},
    {Nome = "TitanTemple",   Display = "Titan Temple"},
    {Nome = "AngelsDemons",  Display = "Angels & Demons"}
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
Main.Name = "Main"
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
-- LISTA
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
StopButton.Text = "⛔ Stop Bots"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.TextSize = 13
StopButton.Font = Enum.Font.GothamBold
StopButton.Parent = Main

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 7)
StopCorner.Parent = StopButton

--==================================================
-- ENCONTRAR ÁREA
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

    for _, Obj in ipairs(Container:GetDescendants()) do
        if Obj.Name == Nome
            and (Obj:IsA("Model") or Obj:IsA("Folder")) then

            return Obj
        end
    end

    return nil
end

--==================================================
-- POSIÇÃO DA ÁREA
--==================================================

local function ObterCFrameDaArea(Area)

    if not Area then
        return nil
    end

    if Area:IsA("Model") then
        local Ok, Pivot = pcall(function()
            return Area:GetPivot()
        end)

        if Ok then
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
-- POSIÇÃO DIRETAMENTE NO CHÃO
--==================================================

local function PegarPosicaoSegura(Area)

    local BaseCFrame = ObterCFrameDaArea(Area)

    if not BaseCFrame then
        return nil
    end

    local Params = RaycastParams.new()

    Params.FilterType = Enum.RaycastFilterType.Exclude

    Params.FilterDescendantsInstances = {
        Player.Character,
        Area
    }

    local Posicao = BaseCFrame.Position

    -- Começa bem acima e procura o chão
    local Origem = Posicao + Vector3.new(0, 100, 0)

    local Resultado = workspace:Raycast(
        Origem,
        Vector3.new(0, -200, 0),
        Params
    )

    if Resultado then

        return CFrame.new(
            Posicao.X,
            Resultado.Position.Y + DistanciaDoChao,
            Posicao.Z
        )
    end

    -- Fallback
    return CFrame.new(
        Posicao.X,
        Posicao.Y + DistanciaDoChao,
        Posicao.Z
    )
end

--==================================================
-- DETECTAR ÁREA ATUAL
--==================================================

local function DetectarAreaAtual()

    local Character = Player.Character

    if not Character then
        return nil
    end

    local Root = Character:FindFirstChild(
        "HumanoidRootPart"
    )

    if not Root then
        return nil
    end

    local Melhor = nil
    local MenorDistancia = math.huge

    for _, Info in ipairs(Areas) do

        local Area = EncontrarArea(Info.Nome)

        if Area then

            local Posicao = PegarPosicaoSegura(Area)

            if Posicao then

                local Distancia =
                    (Root.Position - Posicao.Position).Magnitude

                if Distancia < MenorDistancia then

                    MenorDistancia = Distancia
                    Melhor = Info.Nome

                end
            end
        end
    end

    return Melhor
end

--==================================================
-- CRIAR ROTA
--==================================================

local function CriarRota(Destino)

    local Atual = DetectarAreaAtual()

    local IndiceAtual = nil
    local IndiceDestino = nil

    for I, Area in ipairs(Areas) do

        if Area.Nome == Atual then
            IndiceAtual = I
        end

        if Area.Nome == Destino then
            IndiceDestino = I
        end
    end

    if not IndiceDestino then
        return {}
    end

    -- Se já está no destino, vai para a próxima área
    if IndiceAtual == IndiceDestino then

        IndiceAtual += 1

        if IndiceAtual > #Areas then
            IndiceAtual = 1
        end
    end

    local Rota = {}

    -- Indo para AngelsDemons:
    -- não passa pela SafeZone
    if Destino == "AngelsDemons" then

        if IndiceAtual and IndiceAtual < IndiceDestino then

            for I = IndiceAtual + 1, IndiceDestino do
                table.insert(Rota, Areas[I])
            end

        else

            table.insert(Rota, Areas[IndiceDestino])

        end

        return Rota
    end

    -- Frente
    if IndiceAtual and IndiceAtual < IndiceDestino then

        for I = IndiceAtual + 1, IndiceDestino do
            table.insert(Rota, Areas[I])
        end

    -- Trás
    elseif IndiceAtual and IndiceAtual > IndiceDestino then

        for I = IndiceAtual - 1, IndiceDestino, -1 do
            table.insert(Rota, Areas[I])
        end

    -- Sem área detectada
    else

        for I = 1, IndiceDestino do
            table.insert(Rota, Areas[I])
        end
    end

    return Rota
end

--==================================================
-- LINHA BRANCA
--==================================================

local PastaLinha = Instance.new("Folder")
PastaLinha.Name = "SeraphimLinhaDestino"
PastaLinha.Parent = workspace

local LinhaAtual = nil

local function RemoverLinha()

    if LinhaAtual then
        LinhaAtual:Destroy()
        LinhaAtual = nil
    end
end

local function MostrarLinha(AreaInfo)

    RemoverLinha()

    local Character = Player.Character

    if not Character then
        return
    end

    local Root = Character:FindFirstChild(
        "HumanoidRootPart"
    )

    if not Root then
        return
    end

    local Area = EncontrarArea(AreaInfo.Nome)

    if not Area then
        return
    end

    local Posicao = PegarPosicaoSegura(Area)

    if not Posicao then
        return
    end

    local Folder = Instance.new("Folder")
    Folder.Name = "Linha"

    local Inicio = Instance.new("Attachment")
    Inicio.Name = "Inicio"
    Inicio.Parent = Root

    local Fim = Instance.new("Attachment")
    Fim.Name = "Destino"
    Fim.WorldPosition = Posicao.Position
    Fim.Parent = workspace.Terrain

    local Beam = Instance.new("Beam")

    Beam.Name = "LinhaBranca"

    Beam.Attachment0 = Inicio
    Beam.Attachment1 = Fim

    Beam.Color = ColorSequence.new(
        Color3.fromRGB(255, 255, 255)
    )

    Beam.Width0 = 0.08
    Beam.Width1 = 0.08

    Beam.FaceCamera = true
    Beam.LightEmission = 1

    Beam.Parent = Folder

    Inicio.Parent = Folder
    Fim.Parent = Folder

    Folder.Parent = PastaLinha

    LinhaAtual = Folder
end

--==================================================
-- TELEPORTE
--==================================================

local function TeleportarParaArea(AreaInfo)

    local Character = Player.Character

    if not Character then
        return false
    end

    local Root = Character:FindFirstChild(
        "HumanoidRootPart"
    )

    if not Root then
        return false
    end

    local Area = EncontrarArea(AreaInfo.Nome)

    if not Area then

        warn(
            "Seraphim-Hub: área não encontrada:",
            AreaInfo.Nome
        )

        return false
    end

    local Posicao = PegarPosicaoSegura(Area)

    if not Posicao then
        return false
    end

    -- Teleporte direto para o chão.
    Root.CFrame = Posicao

    -- Remove impulso do teleporte.
    Root.AssemblyLinearVelocity = Vector3.zero
    Root.AssemblyAngularVelocity = Vector3.zero

    return true
end

--==================================================
-- EXECUÇÃO
--==================================================

local Executando = false

local function Executar()

    if Executando then

        Executando = false

        RemoverLinha()

        Status.Text = "Parado"
        StopButton.Text = "⛔ Stop Bots"

        return
    end

    if not AreaSelecionada then

        Status.Text = "Escolha uma área!"

        return
    end

    local Rota = CriarRota(
        AreaSelecionada
    )

    if #Rota == 0 then

        Status.Text = "Rota vazia!"

        return
    end

    Executando = true

    StopButton.Text = "⛔ Parar"

    for I, Info in ipairs(Rota) do

        if not Executando then
            break
        end

        Status.Text =
            Info.Display ..
            "  " ..
            I ..
            "/" ..
            #Rota

        -- Mostra primeiro para onde vai
        MostrarLinha(Info)

        task.wait(0.4)

        if not Executando then
            break
        end

        -- Teleporta diretamente para o chão
        TeleportarParaArea(Info)

        task.wait(TempoEntreAreas)
    end

    RemoverLinha()

    if Executando then
        Status.Text = "Destino alcançado!"
    else
        Status.Text = "Parado"
    end

    Executando = false

    StopButton.Text = "⛔ Stop Bots"
end

--==================================================
-- BOTÃO
--==================================================

StopButton.MouseButton1Click:Connect(function()
    Executar()
end)

--==================================================
-- FECHAR
--==================================================

CloseButton.MouseButton1Click:Connect(function()

    Main.Visible = not Main.Visible

    if not Main.Visible then
        RemoverLinha()
    end
end)

--==================================================
-- ARRASTAR PAINEL
--==================================================

local Dragging = false
local DragStart = Vector2.zero
local InicioPos = UDim2.new()

Top.InputBegan:Connect(function(Input)

    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true

        DragStart = Input.Position
        InicioPos = Main.Position

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
            InicioPos.X.Scale,
            InicioPos.X.Offset + Delta.X,

            InicioPos.Y.Scale,
            InicioPos.Y.Offset + Delta.Y
        )
    end
end)

--==================================================
-- INÍCIO
--==================================================

print("Seraphim-Hub carregado!")
