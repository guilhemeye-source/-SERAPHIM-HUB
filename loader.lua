--// Seraphim-Hub
--// Detecta automaticamente as áreas do mapa
--// Stop Bots -> percorre as áreas -> 7 segundos -> retorna

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

--==================================================
-- CONFIGURAÇÃO
--==================================================

local TEMPO_NO_FINAL = 7
local ALTURA_DO_TELEPORTE = 4
local TEMPO_ENTRE_AREAS = 0.25

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
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

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

-- Borda azul-claro somente no painel
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

    -- Procura recursivamente caso esteja dentro de outra pasta
    for _, Object in ipairs(Container:GetDescendants()) do

        if Object.Name == Nome
        and (Object:IsA("Model") or Object:IsA("Folder")) then

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

    -- Se for Model, tenta usar o Pivot
    if Area:IsA("Model") then

        local Success, Pivot = pcall(function()
            return Area:GetPivot()
        end)

        if Success and Pivot then
            return Pivot
        end
    end

    -- Procura uma BasePart dentro da área
    local Part = Area:FindFirstChildWhichIsA("BasePart", true)

    if Part then
        return Part.CFrame
    end

    -- Se for uma BasePart diretamente
    if Area:IsA("BasePart") then
        return Area.CFrame
    end

    return nil
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

                local Ponto = EncontrarPontoDaArea(Area)

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
-- TELEPORTE
--==================================================

local function Teleportar(Root, Posicao)

    if not Root or not Posicao then
        return false
    end

    Root.CFrame =
        Posicao
        + Vector3.new(0, ALTURA_DO_TELEPORTE, 0)

    return true
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
        return
    end

    local Root = Character:FindFirstChild("HumanoidRootPart")

    if not Root then
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

    -- Guarda o local inicial
    local PosicaoInicial = Root.CFrame

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

        local FinalRoot =
            Character:FindFirstChild("HumanoidRootPart")

        if FinalRoot then

            Status.Text = "Final da rota: 7s"

            task.wait(TEMPO_NO_FINAL)

            --==================================================
            -- RETORNAR
            --==================================================

            if Player.Character == Character then

                local ReturnRoot =
                    Character:FindFirstChild("HumanoidRootPart")

                if ReturnRoot then

                    ReturnRoot.CFrame =
                        PosicaoInicial

                end
            end
        end
    end

    Status.Text = "Aguardando..."
    Executando = false
end

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
-- FECHAR
--==================================================

CloseButton.MouseButton1Click:Connect(function()
    Main.Visible = false
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
