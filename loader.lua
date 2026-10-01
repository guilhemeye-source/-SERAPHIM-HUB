--==================================================
-- 🪽 SERAPHIM HUB
-- Roblox Studio • Celular
-- Monitor de RemoteEvents para o seu próprio jogo
--==================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- CONFIGURAÇÃO
--==================================================

local MAX_DEPTH = 5
local MAX_ITEMS = 100
local MonitorEnabled = true

--==================================================
-- LEITOR DE TABELAS
--==================================================

local function lerValor(valor, nivel, linhas, contador)
    nivel = nivel or 1
    contador = contador or {Value = 0}

    if contador.Value >= MAX_ITEMS then
        return
    end

    local espacos = string.rep("   ", nivel)

    if type(valor) ~= "table" then
        table.insert(
            linhas,
            espacos .. "🔸 " .. tostring(valor)
        )

        contador.Value += 1
        return
    end

    if nivel > MAX_DEPTH then
        table.insert(
            linhas,
            espacos .. "🔹 [profundidade máxima]"
        )
        return
    end

    for chave, conteudo in pairs(valor) do
        if contador.Value >= MAX_ITEMS then
            break
        end

        if type(conteudo) == "table" then
            table.insert(
                linhas,
                espacos .. "🔹 " .. tostring(chave) .. ":"
            )

            contador.Value += 1

            lerTabela(
                conteudo,
                nivel + 1,
                linhas,
                contador
            )
        else
            table.insert(
                linhas,
                espacos
                    .. "🔸 "
                    .. tostring(chave)
                    .. " = "
                    .. tostring(conteudo)
            )

            contador.Value += 1
        end
    end
end

function lerTabela(tabela, nivel, linhas, contador)
    lerValor(tabela, nivel, linhas, contador)
end

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SeraphimRemoteMonitor"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(300, 360)
Main.Position = UDim2.new(0.5, -150, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(22, 25, 32)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 9)
Corner.Parent = Main

-- Borda azul fraca
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(70, 130, 210)
Stroke.Transparency = 0.65
Stroke.Thickness = 1
Stroke.Parent = Main

--==================================================
-- TOPO
--==================================================

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 42)
Top.BackgroundColor3 = Color3.fromRGB(28, 32, 41)
Top.BorderSizePixel = 0
Top.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 9)
TopCorner.Parent = Top

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.fromOffset(12, 0)
Title.BackgroundTransparency = 1
Title.Text = "🪽 Seraphim Hub"
Title.TextColor3 = Color3.fromRGB(235, 235, 235)
Title.TextSize = 14
Title.Font = Enum.Font.GothamMedium
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(35, 35)
Close.Position = UDim2.new(1, -40, 0, 3)
Close.BackgroundTransparency = 1
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(220, 220, 220)
Close.TextSize = 22
Close.Font = Enum.Font.Gotham
Close.Parent = Top

--==================================================
-- STATUS
--==================================================

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 28)
Status.Position = UDim2.fromOffset(10, 48)
Status.BackgroundTransparency = 1
Status.Text = "● Monitorando"
Status.TextColor3 = Color3.fromRGB(80, 200, 120)
Status.TextSize = 12
Status.Font = Enum.Font.Gotham
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Main

--==================================================
-- BOTÃO MONITOR
--==================================================

local MonitorButton = Instance.new("TextButton")
MonitorButton.Size = UDim2.new(1, -20, 0, 38)
MonitorButton.Position = UDim2.fromOffset(10, 78)
MonitorButton.BackgroundColor3 = Color3.fromRGB(45, 105, 180)
MonitorButton.BorderSizePixel = 0
MonitorButton.Text = "📡 MONITOR: ON"
MonitorButton.TextColor3 = Color3.fromRGB(245, 245, 245)
MonitorButton.TextSize = 13
MonitorButton.Font = Enum.Font.GothamMedium
MonitorButton.Parent = Main

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = MonitorButton

--==================================================
-- LIMPAR
--==================================================

local ClearButton = Instance.new("TextButton")
ClearButton.Size = UDim2.new(1, -20, 0, 38)
ClearButton.Position = UDim2.fromOffset(10, 122)
ClearButton.BackgroundColor3 = Color3.fromRGB(65, 75, 90)
ClearButton.BorderSizePixel = 0
ClearButton.Text = "🗑️ LIMPAR"
ClearButton.TextColor3 = Color3.fromRGB(245, 245, 245)
ClearButton.TextSize = 13
ClearButton.Font = Enum.Font.GothamMedium
ClearButton.Parent = Main

local ClearCorner = Instance.new("UICorner")
ClearCorner.CornerRadius = UDim.new(0, 6)
ClearCorner.Parent = ClearButton

--==================================================
-- LISTA
--==================================================

local List = Instance.new("ScrollingFrame")
List.Size = UDim2.new(1, -20, 0, 185)
List.Position = UDim2.fromOffset(10, 166)
List.BackgroundColor3 = Color3.fromRGB(17, 20, 26)
List.BorderSizePixel = 0
List.ScrollBarThickness = 5
List.CanvasSize = UDim2.fromOffset(0, 0)
List.Parent = Main

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 6)
ListCorner.Parent = List

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 2)
Layout.Parent = List

--==================================================
-- ADICIONAR LOG
--==================================================

local function adicionarLog(nome, argumentos)

    if not MonitorEnabled then
        return
    end

    local linhas = {}

    table.insert(
        linhas,
        "━━━━━━━━━━━━━━━━━━━━"
    )

    table.insert(
        linhas,
        "📡 " .. nome
    )

    local contador = {
        Value = 0
    }

    for indice, argumento in ipairs(argumentos) do

        if contador.Value >= MAX_ITEMS then
            break
        end

        table.insert(
            linhas,
            "📦 Argumento " .. indice
        )

        if type(argumento) == "table" then
            lerTabela(
                argumento,
                1,
                linhas,
                contador
            )
        else
            table.insert(
                linhas,
                "   🔸 " .. tostring(argumento)
            )

            contador.Value += 1
        end
    end

    for _, texto in ipairs(linhas) do

        local Label = Instance.new("TextLabel")

        Label.Size = UDim2.new(1, -8, 0, 22)
        Label.AutomaticSize = Enum.AutomaticSize.Y
        Label.BackgroundTransparency = 1
        Label.Text = texto
        Label.TextColor3 = Color3.fromRGB(225, 225, 225)
        Label.TextSize = 10
        Label.Font = Enum.Font.Code
        Label.TextWrapped = true
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = List
    end

    task.defer(function()
        List.CanvasSize = UDim2.fromOffset(
            0,
            Layout.AbsoluteContentSize.Y + 8
        )

        List.CanvasPosition = Vector2.new(
            0,
            math.max(
                0,
                Layout.AbsoluteContentSize.Y
            )
        )
    end)
end

--==================================================
-- REMOTE EVENTS
--==================================================

local function conectarRemoteEvent(Remote)

    Remote.OnClientEvent:Connect(function(...)

        if not MonitorEnabled then
            return
        end

        Status.Text =
            "● Evento: " .. Remote.Name

        adicionarLog(
            "RemoteEvent: " .. Remote.Name,
            {...}
        )
    end)
end

--==================================================
-- REMOTE FUNCTIONS
--==================================================

-- No Studio não usamos hookfunction.
-- RemoteFunction precisa ser observado no código
-- que chama InvokeServer.

for _, Remote in ipairs(
    ReplicatedStorage:GetDescendants()
) do

    if Remote:IsA("RemoteEvent") then

        conectarRemoteEvent(Remote)

    end
end

-- Detecta RemoteEvents criados posteriormente
ReplicatedStorage.DescendantAdded:Connect(
    function(Object)

        if Object:IsA("RemoteEvent") then
            conectarRemoteEvent(Object)
        end
    end
)

--==================================================
-- MONITOR ON/OFF
--==================================================

MonitorButton.MouseButton1Click:Connect(
    function()

        MonitorEnabled = not MonitorEnabled

        if MonitorEnabled then

            MonitorButton.Text =
                "📡 MONITOR: ON"

            MonitorButton.BackgroundColor3 =
                Color3.fromRGB(45, 150, 90)

            Status.Text =
                "● Monitorando"

        else

            MonitorButton.Text =
                "📡 MONITOR: OFF"

            MonitorButton.BackgroundColor3 =
                Color3.fromRGB(65, 75, 90)

            Status.Text =
                "● Monitor desligado"
        end
    end
)

--==================================================
-- LIMPAR
--==================================================

ClearButton.MouseButton1Click:Connect(
    function()

        for _, Object in ipairs(
            List:GetChildren()
        ) do

            if Object:IsA("TextLabel") then
                Object:Destroy()
            end
        end

        List.CanvasSize =
            UDim2.fromOffset(0, 0)

        Status.Text =
            "● Lista limpa"
    end
)

--==================================================
-- FECHAR
--==================================================

Close.MouseButton1Click:Connect(
    function()

        Main.Visible = false
        OpenButton.Visible = true
    end
)

--==================================================
-- BOLINHA PARA REABRIR
--==================================================

local OpenButton = Instance.new("ImageButton")
OpenButton.Size = UDim2.fromOffset(55, 55)
OpenButton.Position = UDim2.fromOffset(20, 200)
OpenButton.BackgroundColor3 = Color3.fromRGB(22, 25, 32)
OpenButton.BorderSizePixel = 0
OpenButton.Image = ""
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(70, 130, 210)
OpenStroke.Transparency = 0.65
OpenStroke.Thickness = 1
OpenStroke.Parent = OpenButton

local OpenText = Instance.new("TextLabel")
OpenText.Size = UDim2.fromScale(1, 1)
OpenText.BackgroundTransparency = 1
OpenText.Text = "🪽"
OpenText.TextSize = 24
OpenText.Parent = OpenButton

OpenButton.MouseButton1Click:Connect(
    function()

        Main.Visible = true
        OpenButton.Visible = false
    end
)

--==================================================
-- ARRASTAR NO CELULAR
--==================================================

local Dragging = false
local DragStart = nil
local StartPosition = nil

Top.InputBegan:Connect(
    function(Input)

        if Input.UserInputType ==
            Enum.UserInputType.Touch
        or Input.UserInputType ==
            Enum.UserInputType.MouseButton1 then

            Dragging = true
            DragStart = Input.Position
            StartPosition = Main.Position
        end
    end
)

Top.InputEnded:Connect(
    function(Input)

        if Input.UserInputType ==
            Enum.UserInputType.Touch
        or Input.UserInputType ==
            Enum.UserInputType.MouseButton1 then

            Dragging = false
        end
    end
)

UserInputService.InputChanged:Connect(
    function(Input)

        if not Dragging then
            return
        end

        if Input.UserInputType ==
            Enum.UserInputType.Touch
        or Input.UserInputType ==
            Enum.UserInputType.MouseMovement then

            local Delta =
                Input.Position - DragStart

            Main.Position =
                UDim2.new(
                    StartPosition.X.Scale,
                    StartPosition.X.Offset + Delta.X,
                    StartPosition.Y.Scale,
                    StartPosition.Y.Offset + Delta.Y
                )
        end
    end
)

print("🪽 Seraphim Hub — monitor Studio/celular carregado")
