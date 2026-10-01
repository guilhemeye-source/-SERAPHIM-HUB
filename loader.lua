-- Seraphim-Hub | Anti-Lag + Original Restaurado
-- Nomes iguais ao seu + Teleporte Consertado

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- CONFIGURAÇÃO
--==================================================

local TEMPO_NO_FINAL = 7
local ALTURA_DO_TELEPORTE = 3.2
local TEMPO_ENTRE_AREAS = 0.35
local DISTANCIA_DETECCAO = 250

-- Anti-Lag
local TENTATIVAS_TELEPORTE = 3
local ZERA_VELOCIDADE = true

--==================================================
-- ÁREAS E ORDEM — IGUAL AO SEU
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
-- PAINEL
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
Status.Text = "Aguardando..."
Status.TextColor3 = Color3.fromRGB(180, 190, 200)
Status.TextSize = 11
Status.Font = Enum.Font.Gotham
Status.TextXAlignment = Enum.TextXAlignment.Center
Status.Parent = Main

--==================================================
-- BOTÃO STOP BOTS
--==================================================

local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(1, -16, 0, 38)
StopButton.Position = UDim2.fromOffset(8, 78)
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
-- FUNÇÕES — ORIGINAIS
--==================================================

local RotaCache = nil

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

    return Part and Part.CFrame or nil
end

local function CriarRota()

    local Rota = {}

    for ID = 0, 12 do

        local Nome = BiomasDoJogo[ID]
        local Area = EncontrarArea(Nome)

        if Area then

            local Ponto =
                EncontrarPontoDaArea(Area)

            if Ponto then

                Rota[ID + 1] = {
                    ID = ID,
                    Nome = Nome,
                    Area = Area,
                    CFrame = Ponto
                }

            else

                warn(
                    "Seraphim-Hub: Área sem ponto:",
                    Nome
                )

            end

        else

            warn(
                "Seraphim-Hub: Área não encontrada:",
                Nome
            )

        end
    end

    return Rota
end

local function EncontrarAreaAtual(Rota, Root)

    if not Root then
        return nil
    end

    local Posicao = Root.Position

    local MelhorArea
    local MenorDistancia = math.huge

    for _, Destino in ipairs(Rota) do

        if Destino and Destino.CFrame then

            local Distancia =
                (Posicao - Destino.CFrame.Position).Magnitude

            if Distancia < MenorDistancia then

                MenorDistancia = Distancia
                MelhorArea = Destino

            end
        end
    end

    if MenorDistancia <= DISTANCIA_DETECCAO then
        return MelhorArea
    end

    return nil
end

--==================================================
-- TELEPORTE ORIGINAL
--==================================================

local function Teleportar(Root, Posicao)

    if not Root or not Posicao then
        return false
    end

    local Hum =
        Root.Parent:FindFirstChildOfClass(
            "Humanoid"
        )

    for Tentativa = 1, TENTATIVAS_TELEPORTE do

        if not Root or not Root.Parent then
            return false
        end

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

        if ZERA_VELOCIDADE then

            Root.Velocity =
                Vector3.zero

            pcall(function()
                Root.AssemblyLinearVelocity =
                    Vector3.zero
            end)

        end

        Root.CFrame =
            Posicao
            + Vector3.new(
                0,
                ALTURA_DO_TELEPORTE,
                0
            )

        local PosicaoFinal =
            Posicao
            + Vector3.new(
                0,
                ALTURA_DO_TELEPORTE,
                0
            )

        local Dist =
            (
                Root.Position
                - PosicaoFinal.Position
            ).Magnitude

        if Dist < 10 then

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

            return true
        end

        task.wait(0.08)
    end

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

    return false
end

--==================================================
-- LISTA DE TELEPORTE
--==================================================

local TeleportFrame = Instance.new("Frame")
TeleportFrame.Name = "TeleportFrame"
TeleportFrame.Size = UDim2.fromOffset(220, 360)
TeleportFrame.Position = UDim2.new(
    0.5,
    -110,
    0.5,
    75
)
TeleportFrame.BackgroundColor3 =
    Color3.fromRGB(15, 18, 25)
TeleportFrame.BorderSizePixel = 0
TeleportFrame.Visible = false
TeleportFrame.Parent = ScreenGui

local TeleportCorner = Instance.new("UICorner")
TeleportCorner.CornerRadius =
    UDim.new(0, 9)
TeleportCorner.Parent = TeleportFrame

local TeleportStroke = Instance.new("UIStroke")
TeleportStroke.Color =
    Color3.fromRGB(100, 200, 255)
TeleportStroke.Thickness = 2
TeleportStroke.Parent = TeleportFrame

local TeleportTitle = Instance.new("TextLabel")
TeleportTitle.Size =
    UDim2.new(1, -16, 0, 30)
TeleportTitle.Position =
    UDim2.fromOffset(8, 5)
TeleportTitle.BackgroundTransparency = 1
TeleportTitle.Text = "Teleporte"
TeleportTitle.TextColor3 =
    Color3.fromRGB(255, 255, 255)
TeleportTitle.TextSize = 14
TeleportTitle.Font =
    Enum.Font.GothamBold
TeleportTitle.TextXAlignment =
    Enum.TextXAlignment.Left
TeleportTitle.Parent = TeleportFrame

local Lista = Instance.new("ScrollingFrame")
Lista.Name = "Lista"
Lista.Size =
    UDim2.new(1, -16, 1, -45)
Lista.Position =
    UDim2.fromOffset(8, 40)
Lista.BackgroundColor3 =
    Color3.fromRGB(10, 13, 20)
Lista.BorderSizePixel = 0
Lista.ScrollBarThickness = 4
Lista.CanvasSize =
    UDim2.new(0, 0, 0, 0)
Lista.Parent = TeleportFrame

local ListaCorner = Instance.new("UICorner")
ListaCorner.CornerRadius =
    UDim.new(0, 7)
ListaCorner.Parent = Lista

local Layout = Instance.new("UIListLayout")
Layout.Padding =
    UDim.new(0, 5)
Layout.SortOrder =
    Enum.SortOrder.LayoutOrder
Layout.HorizontalAlignment =
    Enum.HorizontalAlignment.Center
Layout.Parent = Lista

--==================================================
-- BOTÕES DA LISTA
--==================================================

for ID = 0, 12 do

    local Nome = BiomasDoJogo[ID]

    local Botao =
        Instance.new("TextButton")

    Botao.Name = Nome
    Botao.Size =
        UDim2.new(1, -10, 0, 32)

    Botao.BackgroundColor3 =
        Color3.fromRGB(20, 24, 32)

    Botao.BorderSizePixel = 0
    Botao.Text = Nome
    Botao.TextColor3 =
        Color3.fromRGB(255, 255, 255)
    Botao.TextSize = 12
    Botao.Font =
        Enum.Font.GothamBold
    Botao.LayoutOrder = ID
    Botao.Parent = Lista

    local BotaoCorner =
        Instance.new("UICorner")

    BotaoCorner.CornerRadius =
        UDim.new(0, 6)

    BotaoCorner.Parent = Botao

    Botao.MouseButton1Click:Connect(function()

        local Area =
            EncontrarArea(Nome)

        if not Area then

            Status.Text =
                "Área não encontrada: "
                .. Nome

            return
        end

        local Ponto =
            EncontrarPontoDaArea(Area)

        if not Ponto then

            Status.Text =
                "Ponto não encontrado: "
                .. Nome

            return
        end

        local Character =
            Player.Character

        if not Character then
            return
        end

        local Root =
            Character:FindFirstChild(
                "HumanoidRootPart"
            )

        if not Root then
            return
        end

        local Sucesso =
            Teleportar(
                Root,
                Ponto
            )

        if Sucesso then

            Status.Text =
                "Teleportado: "
                .. Nome

        else

            Status.Text =
                "Falha ao teleportar"

        end
    end)
end

Layout:GetPropertyChangedSignal(
    "AbsoluteContentSize"
):Connect(function()

    Lista.CanvasSize =
        UDim2.new(
            0,
            0,
            0,
            Layout.AbsoluteContentSize.Y + 10
        )

end)

--==================================================
-- ABRIR / FECHAR LISTA
--==================================================

local ListaButton = Instance.new("TextButton")
ListaButton.Size =
    UDim2.new(1, -16, 0, 28)
ListaButton.Position =
    UDim2.fromOffset(8, 118)
ListaButton.BackgroundColor3 =
    Color3.fromRGB(25, 29, 38)
ListaButton.BorderSizePixel = 0
ListaButton.Text = "📍 Teleporte"
ListaButton.TextColor3 =
    Color3.fromRGB(255, 255, 255)
ListaButton.TextSize = 12
ListaButton.Font =
    Enum.Font.GothamBold
ListaButton.Parent = Main

local ListaCorner =
    Instance.new("UICorner")

ListaCorner.CornerRadius =
    UDim.new(0, 6)

ListaCorner.Parent = ListaButton

ListaButton.MouseButton1Click:Connect(function()

    TeleportFrame.Visible =
        not TeleportFrame.Visible

end)

--==================================================
-- EXECUTAR ROTA — SUA LÓGICA ORIGINAL
--==================================================

local Executando = false

local function ExecutarRota()

    if Executando then
        return
    end

    local Character =
        Player.Character

    if not Character then

        Status.Text =
            "Personagem não encontrado!"

        return
    end

    local Root =
        Character:FindFirstChild(
            "HumanoidRootPart"
        )

    if not Root then

        Status.Text =
            "HumanoidRootPart não encontrado!"

        return
    end

    if not RotaCache then
        RotaCache = CriarRota()
    end

    local Rota = RotaCache

    if #Rota == 0 then

        Status.Text =
            "Nenhuma área encontrada!"

        return
    end

    local AreaAtual =
        EncontrarAreaAtual(
            Rota,
            Root
        )

    local IndiceAtual =
        AreaAtual
        and AreaAtual.ID
        or -1

    if AreaAtual then

        Status.Text =
            "Atual: "
            .. AreaAtual.Nome

        task.wait(0.5)

    else

        IndiceAtual = -1

        Status.Text =
            "Área não detectada"

        task.wait(0.5)
    end

    Executando = true

    --==================================================
    -- ANGELSDEMONS = VOLTA
    --==================================================

    if IndiceAtual == 12 then

        for ID = 11, 0, -1 do

            if not Executando then
                break
            end

            if Player.Character ~= Character then
                break
            end

            local Destino =
                Rota[ID + 1]

            if not Destino then
                continue
            end

            local NovoRoot =
                Character:FindFirstChild(
                    "HumanoidRootPart"
                )

            if not NovoRoot then
                break
            end

            Status.Text =
                Destino.Nome
                .. "  ← voltando"

            Teleportar(
                NovoRoot,
                Destino.CFrame
            )

            task.wait(
                TEMPO_ENTRE_AREAS
            )
        end

    else

        --==================================================
        -- QUALQUER OUTRA ÁREA = AVANÇA
        --==================================================

        local Inicio =
            IndiceAtual + 1

        if Inicio < 0 then
            Inicio = 0
        end

        for ID = Inicio, 12 do

            if not Executando then
                break
            end

            if Player.Character ~= Character then
                break
            end

            local Destino =
                Rota[ID + 1]

            if not Destino then
                continue
            end

            local NovoRoot =
                Character:FindFirstChild(
                    "HumanoidRootPart"
                )

            if not NovoRoot then
                break
            end

            Status.Text =
                Destino.Nome
                .. "  → avançando"

            Teleportar(
                NovoRoot,
                Destino.CFrame
            )

            task.wait(
                TEMPO_ENTRE_AREAS
            )
        end
    end

    --==================================================
    -- FINAL
    --==================================================

    if Executando
    and Player.Character == Character then

        Status.Text =
            "Final da rota: "
            .. TEMPO_NO_FINAL
            .. "s"

        task.wait(
            TEMPO_NO_FINAL
        )
    end

    Status.Text =
        "Aguardando..."

    Executando = false
end

--==================================================
-- BOTÃO STOP BOTS
--==================================================

StopButton.MouseButton1Click:Connect(function()

    if Executando then
        return
    end

    task.spawn(
        ExecutarRota
    )

end)

--==================================================
-- FECHAR
--==================================================

CloseButton.MouseButton1Click:Connect(function()

    Main.Visible = false
    TeleportFrame.Visible = false

end)

--==================================================
-- ARRASTAR PAINEL
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
            Input.Position
            - DragStart

        Main.Position =
            UDim2.new(
                StartPos.X.Scale,
                StartPos.X.Offset
                    + Delta.X,

                StartPos.Y.Scale,
                StartPos.Y.Offset
                    + Delta.Y
            )
    end
end)

--==================================================
-- RESPAWN
--==================================================

Player.CharacterAdded:Connect(function()

    RotaCache = nil

end)

print(
    "Seraphim-Hub carregado!"
)



