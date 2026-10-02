--==========================================================
-- MEU HUB + ANALISADOR DE OVOS
-- Para uso no seu próprio jogo no Roblox Studio
--==========================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==========================================================
-- CONFIGURAÇÃO
--==========================================================

local Config = {
    NomeHub = "MEU HUB EXCLUSIVO",
    Versao = "v1.0.0",

    CorPrincipal = Color3.fromRGB(0, 170, 255),
    CorFundo = Color3.fromRGB(25, 25, 25),
    CorMenu = Color3.fromRGB(18, 18, 18),

    JanelaLargura = 520,
    JanelaAltura = 360
}

--==========================================================
-- REMOVER INTERFACE ANTIGA
--==========================================================

local antigo = PlayerGui:FindFirstChild("MeuHubCustomizado")

if antigo then
    antigo:Destroy()
end

--==========================================================
-- GUI PRINCIPAL
--==========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MeuHubCustomizado"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(
    Config.JanelaLargura,
    Config.JanelaAltura
)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = Config.CorFundo
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

--==========================================================
-- BARRA LATERAL
--==========================================================

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Config.CorMenu
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 8)
SideCorner.Parent = Sidebar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 35)
Title.Position = UDim2.fromOffset(10, 10)
Title.BackgroundTransparency = 1
Title.Text = Config.NomeHub
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Sidebar

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(1, -20, 0, 20)
Version.Position = UDim2.fromOffset(10, 38)
Version.BackgroundTransparency = 1
Version.Text = Config.Versao
Version.TextColor3 = Config.CorPrincipal
Version.TextSize = 12
Version.Font = Enum.Font.SourceSansItalic
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.Parent = Sidebar

--==========================================================
-- BOTÃO ANALISAR
--==========================================================

local AnalyzeButton = Instance.new("TextButton")
AnalyzeButton.Size = UDim2.new(1, -20, 0, 42)
AnalyzeButton.Position = UDim2.fromOffset(10, 80)
AnalyzeButton.BackgroundColor3 = Config.CorPrincipal
AnalyzeButton.BorderSizePixel = 0
AnalyzeButton.Text = "🔎 ANALISAR OVOS"
AnalyzeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AnalyzeButton.TextSize = 14
AnalyzeButton.Font = Enum.Font.SourceSansBold
AnalyzeButton.Parent = Sidebar

local AnalyzeCorner = Instance.new("UICorner")
AnalyzeCorner.CornerRadius = UDim.new(0, 6)
AnalyzeCorner.Parent = AnalyzeButton

--==========================================================
-- BOTÃO FECHAR
--==========================================================

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(30, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(220, 70, 70)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

--==========================================================
-- ÁREA DE RESULTADOS
--==========================================================

local Results = Instance.new("ScrollingFrame")
Results.Name = "Results"
Results.Size = UDim2.new(1, -160, 1, -55)
Results.Position = UDim2.fromOffset(150, 45)
Results.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Results.BorderSizePixel = 0
Results.ScrollBarThickness = 5
Results.CanvasSize = UDim2.new(0, 0, 0, 0)
Results.Parent = MainFrame

local ResultsCorner = Instance.new("UICorner")
ResultsCorner.CornerRadius = UDim.new(0, 6)
ResultsCorner.Parent = Results

local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0, 4)
List.SortOrder = Enum.SortOrder.LayoutOrder
List.Parent = Results

--==========================================================
-- FUNÇÃO: CAMINHO COMPLETO
--==========================================================

local function obterCaminho(objeto)
    local partes = {}
    local atual = objeto

    while atual and atual ~= game do
        table.insert(partes, 1, atual.Name)
        atual = atual.Parent
    end

    return table.concat(partes, ".")
end

--==========================================================
-- FUNÇÃO: ADICIONAR TEXTO AO PAINEL
--==========================================================

local function adicionarResultado(texto, destaque)
    local Label = Instance.new("TextLabel")

    Label.Size = UDim2.new(1, -10, 0, 22)
    Label.BackgroundTransparency = 1
    Label.Text = texto
    Label.TextColor3 = destaque
        and Config.CorPrincipal
        or Color3.fromRGB(210, 210, 210)

    Label.TextSize = 12
    Label.Font = destaque
        and Enum.Font.SourceSansBold
        or Enum.Font.SourceSans

    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextWrapped = true
    Label.AutomaticSize = Enum.AutomaticSize.Y
    Label.Parent = Results

    return Label
end

--==========================================================
-- FUNÇÃO: LIMPAR RESULTADOS
--==========================================================

local function limparResultados()
    for _, item in ipairs(Results:GetChildren()) do
        if item:IsA("TextLabel") then
            item:Destroy()
        end
    end
end

--==========================================================
-- FUNÇÃO: IDENTIFICAR OVO
--==========================================================

local function pareceSerOvo(objeto)

    local nome = string.lower(objeto.Name)

    if string.find(nome, "egg", 1, true) then
        return true
    end

    if CollectionService:HasTag(objeto, "Egg") then
        return true
    end

    if CollectionService:HasTag(objeto, "egg") then
        return true
    end

    return false
end

--==========================================================
-- ANALISAR UM OVO
--==========================================================

local function analisarOvo(ovo)

    adicionarResultado(
        "🥚 OVO: " .. ovo.Name,
        true
    )

    adicionarResultado(
        "Classe: " .. ovo.ClassName
    )

    adicionarResultado(
        "Caminho: " .. obterCaminho(ovo)
    )

    -- ATRIBUTOS

    local atributos = ovo:GetAttributes()

    if next(atributos) then

        adicionarResultado("  [ATRIBUTOS]", true)

        for nome, valor in pairs(atributos) do
            adicionarResultado(
                "  • " ..
                nome ..
                " = " ..
                tostring(valor)
            )
        end

    else

        adicionarResultado(
            "  [ATRIBUTOS] Nenhum"
        )

    end

    -- TAGS

    local tags = CollectionService:GetTags(ovo)

    if #tags > 0 then

        adicionarResultado(
            "  [TAGS]",
            true
        )

        for _, tag in ipairs(tags) do
            adicionarResultado(
                "  • " .. tag
            )
        end

    else

        adicionarResultado(
            "  [TAGS] Nenhuma"
        )

    end

    -- VALUES

    local encontrouValue = false

    for _, item in ipairs(ovo:GetDescendants()) do

        if item:IsA("ValueBase") then

            if not encontrouValue then
                adicionarResultado(
                    "  [VALUES]",
                    true
                )

                encontrouValue = true
            end

            local valor = "?"

            pcall(function()
                valor = tostring(item.Value)
            end)

            adicionarResultado(
                "  • " ..
                obterCaminho(item) ..
                " = " ..
                valor
            )
        end
    end

    if not encontrouValue then
        adicionarResultado(
            "  [VALUES] Nenhum"
        )
    end

    -- BASEPARTS

    local encontrouPart = false

    for _, item in ipairs(ovo:GetDescendants()) do

        if item:IsA("BasePart") then

            if not encontrouPart then

                adicionarResultado(
                    "  [BASEPARTS]",
                    true
                )

                encontrouPart = true
            end

            adicionarResultado(
                "  • " ..
                obterCaminho(item) ..
                " [" ..
                item.ClassName ..
                "]"
            )

            adicionarResultado(
                "    Size: " ..
                tostring(item.Size)
            )

            adicionarResultado(
                "    Position: " ..
                tostring(item.Position)
            )

            adicionarResultado(
                "    CanCollide: " ..
                tostring(item.CanCollide)
            )

            adicionarResultado(
                "    CanTouch: " ..
                tostring(item.CanTouch)
            )
        end
    end

    if not encontrouPart then
        adicionarResultado(
            "  [BASEPARTS] Nenhuma"
        )
    end

    adicionarResultado(
        "----------------------------------------"
    )
end

--==========================================================
-- ANALISAR WORKSPACE INTEIRA
--==========================================================

local function analisarWorkspace()

    limparResultados()

    local quantidade = 0

    adicionarResultado(
        "🔎 INICIANDO ANÁLISE...",
        true
    )

    for _, objeto in ipairs(
        Workspace:GetDescendants()
    ) do

        if pareceSerOvo(objeto) then

            quantidade += 1

            analisarOvo(objeto)

        end
    end

    adicionarResultado(
        "✅ ANÁLISE CONCLUÍDA",
        true
    )

    adicionarResultado(
        "Objetos identificados: " ..
        tostring(quantidade)
    )

    task.wait()

    Results.CanvasSize = UDim2.new(
        0,
        0,
        0,
        List.AbsoluteContentSize.Y + 10
    )
end

--==========================================================
-- BOTÃO ANALISAR
--==========================================================

AnalyzeButton.MouseButton1Click:Connect(
    analisarWorkspace
)

--==========================================================
-- ATUALIZAR SCROLL AUTOMATICAMENTE
--==========================================================

List:GetPropertyChangedSignal(
    "AbsoluteContentSize"
):Connect(function()

    Results.CanvasSize = UDim2.new(
        0,
        0,
        0,
        List.AbsoluteContentSize.Y + 10
    )

end)

print(
    "[MEU HUB] Painel + analisador carregados."
)



