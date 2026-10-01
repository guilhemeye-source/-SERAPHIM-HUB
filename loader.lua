--// Seraphim-Hub
--// Detecta automaticamente as áreas do mapa
--// Lista de teleporte + Anti-Travamento
--// Sem bypass de executor

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- CONFIGURAÇÃO
--==================================================

local TEMPO_NO_FINAL = 7
local ALTURA_DO_TELEPORTE = 4
local TEMPO_ENTRE_AREAS = 0.25

-- Anti-travamento
local TENTATIVAS_TELEPORTE = 3
local ZERA_VELOCIDADE = true

--==================================================
-- ÁREAS E ORDEM
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
ScreenGui.Parent = PlayerGui

--==================================================
-- PAINEL
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(220, 170)
Main.Position = UDim2.new(0.5, -110, 0.5, -85)
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
-- BOTÃO LISTA
--==================================================

local ListaButton = Instance.new("TextButton")
ListaButton.Size = UDim2.new(1, -16, 0, 38)
ListaButton.Position = UDim2.fromOffset(8, 123)
ListaButton.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
ListaButton.BorderSizePixel = 0
ListaButton.Text = "📍 Lista de Áreas"
ListaButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ListaButton.TextSize = 12
ListaButton.Font = Enum.Font.GothamBold
ListaButton.Parent = Main

local ListaCorner = Instance.new("UICorner")
ListaCorner.CornerRadius = UDim.new(0, 7)
ListaCorner.Parent = ListaButton

--==================================================
-- ENCONTRAR CONTAINER DAS ÁREAS
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

--==================================================
-- ENCONTRAR PONTO DA ÁREA
--==================================================

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
-- TELEPORTE ANTI-TRAVAMENTO
--==================================================

local function Teleportar(Root, Posicao)

    if not Root or not Posicao then
        return false
    end

    local Character = Root.Parent

    if not Character then
        return false
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    -- Desativa estados que podem causar queda durante o teleporte
    if Humanoid then
        Humanoid:SetStateEnabled(
            Enum.HumanoidStateType.FallingDown,
            false
        )

        Humanoid:SetStateEnabled(
            Enum.HumanoidStateType.Falling,
            false
        )
    end

    for Tentativa = 1, TENTATIVAS_TELEPORTE do

        if not Root or not Root.Parent then
            return false
        end

        -- Zera a velocidade para evitar que o personagem
        -- continue se movendo depois do teleporte
        if ZERA_VELOCIDADE then

            Root.Velocity = Vector3.zero

            pcall(function()
                Root.AssemblyLinearVelocity = Vector3.zero
                Root.AssemblyAngularVelocity = Vector3.zero
            end)

        end

        local Destino =
            Posicao
            + Vector3.new(0, ALTURA_DO_TELEPORTE, 0)

        Root.CFrame = Destino

        task.wait(0.08)

        if Root and Root.Parent then

            local Distancia =
                (Root.Position - Destino.Position).Magnitude

            if Distancia < 10 then

                if Humanoid then
                    Humanoid:SetStateEnabled(
                        Enum.HumanoidStateType.FallingDown,
                        true
                    )

                    Humanoid:SetStateEnabled(
                        Enum.HumanoidStateType.Falling,
                        true
                    )
                end

                return true
            end
        end
    end

    if Humanoid then
        Humanoid:SetStateEnabled(
            Enum.HumanoidStateType.FallingDown,
            true
        )

        Humanoid:SetStateEnabled(
            Enum.HumanoidStateType.Falling,
            true
        )
    end

    return false
end

--==================================================
-- MONTAR ROTA
--==================================================

local function CriarRota()

    local Rota = {}

    for ID = 0, 12 do

        local Nome = BiomasDoJogo[ID]

        if Nome then

            local Area = EncontrarArea(Nome)

            if Area then

                local Ponto =
                    EncontrarPontoDaArea(Area)

                if Ponto then

                    table.insert(Rota, {
                        ID = ID,
                        Nome = Nome,
                        Area = Area,
                        CFrame = Ponto
                    })

                else

                    warn(
                        "Seraphim-Hub: Área encontrada, mas sem ponto:",
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
    end

    return Rota
end

--==================================================
-- EXECUTAR ROTA
--==================================================

local Executando = false

local function ExecutarRota()

    if Executando then
        return
    end

    local Character = Player.Character

    if not Character then
        Status.Text = "Personagem não encontrado!"
        return
    end

    local Root =
        Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        Status.Text = "HumanoidRootPart não encontrado!"
        return
    end

    local Rota = CriarRota()

    if #Rota == 0 then

        Status.Text = "Nenhuma área encontrada!"

        warn(
            "Seraphim-Hub: Nenhuma área foi encontrada."
        )

        return
    end

    Executando = true

    --==================================================
    -- PERCORRER ÁREAS
    --==================================================

    for Numero, Destino in ipairs(Rota) do

        if not Executando then
            break
        end

        if Player.Character ~= Character then
            break
        end

        local NovoRoot =
            Character:FindFirstChild("HumanoidRootPart")

        if not NovoRoot then
            break
        end

        Status.Text =
            Destino.Nome
            .. "  "
            .. Numero
            .. "/"
            .. #Rota

        Teleportar(
            NovoRoot,
            Destino.CFrame
        )

        task.wait(TEMPO_ENTRE_AREAS)
    end

    --==================================================
    -- ESPERA NO FINAL
    --==================================================

    if Executando
    and Player.Character == Character then

        Status.Text =
            "Final da rota: "
            .. TEMPO_NO_FINAL
            .. "s"

        task.wait(TEMPO_NO_FINAL)

        -- Não retorna para a posição inicial.
        -- Permanece na última área.
    end

    Status.Text = "Aguardando..."
    Executando = false
end

--==================================================
-- JANELA DA LISTA
--==================================================

local ListaFrame = Instance.new("Frame")
ListaFrame.Name = "ListaFrame"
ListaFrame.Size = UDim2.fromOffset(210, 300)
ListaFrame.Position = UDim2.new(
    0.5,
    120,
    0.5,
    -150
)
ListaFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
ListaFrame.BorderSizePixel = 0
ListaFrame.Visible = false
ListaFrame.Parent = ScreenGui

local ListaStroke = Instance.new("UIStroke")
ListaStroke.Color = Color3.fromRGB(100, 200, 255)
ListaStroke.Thickness = 2
ListaStroke.Parent = ListaFrame

local ListaFrameCorner = Instance.new("UICorner")
ListaFrameCorner.CornerRadius = UDim.new(0, 9)
ListaFrameCorner.Parent = ListaFrame

--==================================================
-- TÍTULO DA LISTA
--==================================================

local ListaTitle = Instance.new("TextLabel")
ListaTitle.Size = UDim2.new(1, -10, 0, 35)
ListaTitle.Position = UDim2.fromOffset(5, 0)
ListaTitle.BackgroundTransparency = 1
ListaTitle.Text = "📍 Áreas"
ListaTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ListaTitle.TextSize = 14
ListaTitle.Font = Enum.Font.GothamBold
ListaTitle.Parent = ListaFrame

--==================================================
-- SCROLL DA LISTA
--==================================================

local Lista = Instance.new("ScrollingFrame")
Lista.Size = UDim2.new(1, -12, 1, -43)
Lista.Position = UDim2.fromOffset(6, 38)
Lista.BackgroundTransparency = 1
Lista.BorderSizePixel = 0
Lista.ScrollBarThickness = 4
Lista.CanvasSize = UDim2.new(0, 0, 0, 0)
Lista.Parent = ListaFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Parent = Lista

--==================================================
-- CRIAR BOTÕES DA LISTA
--==================================================

for ID = 0, 12 do

    local Nome = BiomasDoJogo[ID]

    local Botao = Instance.new("TextButton")

    Botao.Name = Nome
    Botao.Size = UDim2.new(1, -6, 0, 34)
    Botao.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
    Botao.BorderSizePixel = 0
    Botao.Text = Nome
    Botao.TextColor3 = Color3.fromRGB(255, 255, 255)
    Botao.TextSize = 11
    Botao.Font = Enum.Font.GothamBold
    Botao.Parent = Lista

    local BotaoCorner = Instance.new("UICorner")
    BotaoCorner.CornerRadius = UDim.new(0, 6)
    BotaoCorner.Parent = Botao

    Botao.MouseButton1Click:Connect(function()

        local Character = Player.Character

        if not Character then
            return
        end

        local Root =
            Character:FindFirstChild("HumanoidRootPart")

        if not Root then
            return
        end

        local Area = EncontrarArea(Nome)

        if not Area then
            Status.Text = Nome .. " não encontrada!"
            return
        end

        local Ponto =
            EncontrarPontoDaArea(Area)

        if not Ponto then
            Status.Text = Nome .. " sem ponto!"
            return
        end

        Status.Text = "Teleportando: " .. Nome

        Teleportar(
            Root,
            Ponto
        )

        Status.Text = "Área: " .. Nome
    end)
end

Lista.CanvasSize = UDim2.new(
    0,
    0,
    0,
    Layout.AbsoluteContentSize.Y + 5
)

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()

    Lista.CanvasSize = UDim2.new(
        0,
        0,
        0,
        Layout.AbsoluteContentSize.Y + 5
    )
end)

--==================================================
-- ABRIR / FECHAR LISTA
--==================================================

ListaButton.MouseButton1Click:Connect(function()

    ListaFrame.Visible =
        not ListaFrame.Visible
end)

--==================================================
-- BOTÃO
--==================================================

StopButton.MouseButton1Click:Connect(function()

    if Executando then
        return
    end

    task.spawn(function()
        ExecutarRota()
    end)
end)

--==================================================
-- FECHAR PAINEL
--==================================================

CloseButton.MouseButton1Click:Connect(function()

    Main.Visible = false
    ListaFrame.Visible = false
end)

--==================================================
-- ARRASTAR PAINEL
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
