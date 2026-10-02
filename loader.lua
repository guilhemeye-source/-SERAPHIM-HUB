--// Seraphim-Hub - Estilo Linno (Steal An Egg)
--// Tema roxo/violeta baseado na arte

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

local DistanciaDoChao = 3
local TempoEntreAcoes = 0.4
local VidaTravada = 100000

local NomesOvo   = { "Egg", "Ovo", "Nest" }
local NomesPlot  = { "Plot", "Base", "CollectZone", "Collect", "Garden", "Pen" }

-- Cores tema Seraphim (roxo/violeta)
local COR_FUNDO       = Color3.fromRGB(14, 10, 22)
local COR_PAINEL      = Color3.fromRGB(22, 16, 38)
local COR_SIDEBAR     = Color3.fromRGB(18, 12, 30)
local COR_BOTAO       = Color3.fromRGB(35, 24, 60)
local COR_BOTAO_HOVER = Color3.fromRGB(55, 35, 100)
local COR_ATIVO       = Color3.fromRGB(130, 80, 255)
local COR_ROXO_CLARO  = Color3.fromRGB(180, 130, 255)
local COR_TEXTO       = Color3.fromRGB(240, 235, 255)
local COR_TEXTO_FRACO = Color3.fromRGB(170, 160, 200)
local COR_VERDE       = Color3.fromRGB(90, 220, 140)
local COR_VERMELHO    = Color3.fromRGB(220, 70, 90)

--==================================================
-- GOD MODE
--==================================================

local function AplicarGodMode(Character)
    if not Character then return end
    local Antigo = Character:FindFirstChild("SeraphimGodMode")
    if Antigo then Antigo:Destroy() end

    local FF = Instance.new("ForceField")
    FF.Name = "SeraphimGodMode"
    FF.Visible = false
    FF.Parent = Character

    local Hum = Character:FindFirstChildOfClass("Humanoid")
    if Hum then
        Hum.MaxHealth = math.max(Hum.MaxHealth, VidaTravada)
        Hum.Health = Hum.MaxHealth
    end
end

if Player.Character then AplicarGodMode(Player.Character) end
Player.CharacterAdded:Connect(function(Char)
    task.wait(0.2)
    AplicarGodMode(Char)
end)

task.spawn(function()
    while true do
        task.wait(0.03)
        local Char = Player.Character
        if Char then
            local Hum = Char:FindFirstChildOfClass("Humanoid")
            if Hum then
                if Hum.MaxHealth < VidaTravada then Hum.MaxHealth = VidaTravada end
                if Hum.Health < Hum.MaxHealth then Hum.Health = Hum.MaxHealth end
            end
            if not Char:FindFirstChild("SeraphimGodMode") then
                AplicarGodMode(Char)
            end
        end
    end
end)

--==================================================
-- GUI PRINCIPAL
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SeraphimHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Container principal
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(560, 340)
Main.Position = UDim2.new(0.5, -280, 0.5, -170)
Main.BackgroundColor3 = COR_FUNDO
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = COR_ATIVO
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.3
MainStroke.Parent = Main

-- Glow externo (2 strokes pra dar brilho)
local OuterGlow = Instance.new("UIStroke")
OuterGlow.Color = COR_ATIVO
OuterGlow.Thickness = 6
OuterGlow.Transparency = 0.85
OuterGlow.Parent = Main

--==================================================
-- SIDEBAR (esquerda)
--==================================================

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = COR_SIDEBAR
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 12)
SidebarCorner.Parent = Sidebar

-- Cobre o canto direito arredondado da sidebar
local SidebarFix = Instance.new("Frame")
SidebarFix.Size = UDim2.new(0, 12, 1, 0)
SidebarFix.Position = UDim2.new(1, -12, 0, 0)
SidebarFix.BackgroundColor3 = COR_SIDEBAR
SidebarFix.BorderSizePixel = 0
SidebarFix.Parent = Sidebar

-- Logo "SERAPHIM HUB"
local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, -20, 0, 60)
Logo.Position = UDim2.fromOffset(10, 12)
Logo.BackgroundTransparency = 1
Logo.Text = "SERAPHIM\nHUB"
Logo.TextColor3 = COR_ROXO_CLARO
Logo.TextSize = 22
Logo.Font = Enum.Font.GothamBlack
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.TextYAlignment = Enum.TextYAlignment.Top
Logo.Parent = Sidebar

local LogoGlow = Instance.new("UIStroke")
LogoGlow.Color = COR_ATIVO
LogoGlow.Thickness = 1
LogoGlow.Transparency = 0.6
LogoGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
LogoGlow.Parent = Logo

-- Linha decorativa abaixo do logo
local LogoLine = Instance.new("Frame")
LogoLine.Size = UDim2.new(0, 60, 0, 2)
LogoLine.Position = UDim2.fromOffset(10, 76)
LogoLine.BackgroundColor3 = COR_ATIVO
LogoLine.BorderSizePixel = 0
LogoLine.Parent = Sidebar

--==================================================
-- BOTÕES DA SIDEBAR (abas)
--==================================================

local AbasContainer = Instance.new("Frame")
AbasContainer.Size = UDim2.new(1, -20, 0, 200)
AbasContainer.Position = UDim2.fromOffset(10, 92)
AbasContainer.BackgroundTransparency = 1
AbasContainer.Parent = Sidebar

local AbasLayout = Instance.new("UIListLayout")
AbasLayout.Padding = UDim.new(0, 6)
AbasLayout.SortOrder = Enum.SortOrder.LayoutOrder
AbasLayout.Parent = AbasContainer

local AbaAtual = nil

local function CriarAba(Nome, Ordem, Callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = COR_BOTAO
    Btn.BorderSizePixel = 0
    Btn.Text = "  " .. Nome
    Btn.TextColor3 = COR_TEXTO
    Btn.TextSize = 12
    Btn.Font = Enum.Font.GothamBold
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.LayoutOrder = Ordem
    Btn.AutoButtonColor = false
    Btn.Parent = AbasContainer

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Btn

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = COR_ATIVO
    Stroke.Thickness = 1
    Stroke.Transparency = 1
    Stroke.Parent = Btn

    Btn.MouseEnter:Connect(function()
        if AbaAtual ~= Nome then
            TweenService:Create(Btn, TweenInfo.new(0.15), {
                BackgroundColor3 = COR_BOTAO_HOVER
            }):Play()
        end
    end)

    Btn.MouseLeave:Connect(function()
        if AbaAtual ~= Nome then
            TweenService:Create(Btn, TweenInfo.new(0.15), {
                BackgroundColor3 = COR_BOTAO
            }):Play()
        end
    end)

    Btn.MouseButton1Click:Connect(function()
        AbaAtual = Nome
        -- Atualiza visual
        for _, Outro in ipairs(AbasContainer:GetChildren()) do
            if Outro:IsA("TextButton") then
                if Outro == Btn then
                    TweenService:Create(Outro, TweenInfo.new(0.15), {
                        BackgroundColor3 = COR_ATIVO
                    }):Play()
                    TweenService:Create(Outro:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.15), {
                        Transparency = 0
                    }):Play()
                else
                    TweenService:Create(Outro, TweenInfo.new(0.15), {
                        BackgroundColor3 = COR_BOTAO
                    }):Play()
                    TweenService:Create(Outro:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.15), {
                        Transparency = 1
                    }):Play()
                end
            end
        end
        if Callback then Callback() end
    end)

    return Btn
end

--==================================================
-- ÁREA DE CONTEÚDO (direita)
--==================================================

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -150, 1, 0)
Content.Position = UDim2.new(0, 150, 0, 0)
Content.BackgroundColor3 = COR_PAINEL
Content.BorderSizePixel = 0
Content.Parent = Main

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 12)
ContentCorner.Parent = Content

-- Cobre a borda esquerda arredondada
local ContentFix = Instance.new("Frame")
ContentFix.Size = UDim2.new(0, 12, 1, 0)
ContentFix.BackgroundColor3 = COR_PAINEL
ContentFix.BorderSizePixel = 0
ContentFix.Parent = Content

-- Título da página
local TituloPagina = Instance.new("TextLabel")
TituloPagina.Size = UDim2.new(1, -30, 0, 30)
TituloPagina.Position = UDim2.fromOffset(20, 15)
TituloPagina.BackgroundTransparency = 1
TituloPagina.Text = "Auto Steal"
TituloPagina.TextColor3 = COR_ROXO_CLARO
TituloPagina.TextSize = 16
TituloPagina.Font = Enum.Font.GothamBlack
TituloPagina.TextXAlignment = Enum.TextXAlignment.Left
TituloPagina.Parent = Content

-- Linha decorativa
local TituloLinha = Instance.new("Frame")
TituloLinha.Size = UDim2.new(1, -40, 0, 1)
TituloLinha.Position = UDim2.fromOffset(20, 48)
TituloLinha.BackgroundColor3 = COR_ATIVO
TituloLinha.BorderSizePixel = 0
TituloLinha.BackgroundTransparency = 0.7
TituloLinha.Parent = Content

--==================================================
-- ÁREA DINÂMICA (onde as páginas aparecem)
--==================================================

local PaginaContainer = Instance.new("Frame")
PaginaContainer.Name = "Paginas"
PaginaContainer.Size = UDim2.new(1, -40, 1, -70)
PaginaContainer.Position = UDim2.fromOffset(20, 60)
PaginaContainer.BackgroundTransparency = 1
PaginaContainer.Parent = Content

local function LimparPagina()
    for _, Filho in ipairs(PaginaContainer:GetChildren()) do
        Filho:Destroy()
    end
end

--==================================================
-- FUNÇÕES DO JOGO
--==================================================

local function GetCharacter()
    local Char = Player.Character
    if not Char then return nil end
    local Root = Char:FindFirstChild("HumanoidRootPart")
    local Hum = Char:FindFirstChildOfClass("Humanoid")
    if Root and Hum and Hum.Health > 0 then
        return Char, Root, Hum
    end
    return nil
end

local function TeleportarPara(Posicao, TravarHum)
    local Char, Root, Hum = GetCharacter()
    if not Char or not Root then return false end

    if TravarHum and Hum then
        Hum.WalkSpeed = 0
        Hum.JumpPower = 0
    end

    Root.AssemblyLinearVelocity = Vector3.zero
    Root.AssemblyAngularVelocity = Vector3.zero

    pcall(function()
        Char:PivotTo(CFrame.new(Posicao))
    end)

    Root.AssemblyLinearVelocity = Vector3.zero
    Root.AssemblyAngularVelocity = Vector3.zero

    if TravarHum and Hum then
        task.wait(0.1)
        Hum.WalkSpeed = 16
        Hum.JumpPower = 50
    end

    return true
end

local function EncontrarMinhaPlot()
    local Char, Root = GetCharacter()
    if not Char or not Root then return nil end
    local MinhaPos = Root.Position
    local Melhor, MenorDist = nil, math.huge

    for _, Obj in ipairs(workspace:GetDescendants()) do
        if Obj:IsA("Model") or Obj:IsA("BasePart") then
            local NomeLower = Obj.Name:lower()
            for _, N in ipairs(NomesPlot) do
                if string.find(NomeLower, N:lower()) then
                    local Pos
                    if Obj:IsA("Model") then
                        local ok, pivot = pcall(function() return Obj:GetPivot() end)
                        if ok then Pos = pivot.Position end
                    else
                        Pos = Obj.Position
                    end
                    if Pos then
                        local Dist = (MinhaPos - Pos).Magnitude
                        if Dist < MenorDist then
                            MenorDist = Dist
                            Melhor = Pos
                        end
                    end
                end
            end
        end
    end
    return Melhor
end

local function EncontrarOvo()
    local Char, Root = GetCharacter()
    if not Char or not Root then return nil, nil end
    local MinhaPos = Root.Position
    local Melhor, MelhorPos, MenorDist = nil, nil, math.huge

    for _, Obj in ipairs(workspace:GetDescendants()) do
        if Obj:IsA("Model") or Obj:IsA("BasePart") then
            local NomeLower = Obj.Name:lower()
            for _, N in ipairs(NomesOvo) do
                if string.find(NomeLower, N:lower()) then
                    local Pos
                    if Obj:IsA("Model") then
                        local ok, pivot = pcall(function() return Obj:GetPivot() end)
                        if ok then Pos = pivot.Position end
                    else
                        Pos = Obj.Position
                    end
                    if Pos then
                        local Dist = (MinhaPos - Pos).Magnitude
                        if Dist < MenorDist then
                            MenorDist = Dist
                            Melhor = Obj
                            MelhorPos = Pos
                        end
                    end
                end
            end
        end
    end
    return Melhor, MelhorPos
end

local function RoubarOvo(Objeto)
    if not Objeto then return false end
    local Prompt = Objeto:FindFirstChildOfClass("ProximityPrompt")
    if not Prompt then Prompt = Objeto:FindFirstChildWhichIsA("ProximityPrompt", true) end
    if Prompt then
        pcall(function() fireproximityprompt(Prompt) end)
        return true
    end
    local Click = Objeto:FindFirstChildOfClass("ClickDetector")
    if not Click then Click = Objeto:FindFirstChildWhichIsA("ClickDetector", true) end
    if Click then
        pcall(function() fireclickdetector(Click) end)
        return true
    end
    if Objeto:IsA("BasePart") and firetouchinterest then
        local Char, Root = GetCharacter()
        if Root then
            pcall(function()
                firetouchinterest(Root, Objeto, 0)
                task.wait(0.05)
                firetouchinterest(Root, Objeto, 1)
            end)
            return true
        end
    end
    return false
end

--==================================================
-- UI HELPERS
--==================================================

local function CriarBotaoAcao(Texto, PosY, CorFundo, Callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.Position = UDim2.fromOffset(0, PosY)
    Btn.BackgroundColor3 = CorFundo or COR_BOTAO
    Btn.BorderSizePixel = 0
    Btn.Text = Texto
    Btn.TextColor3 = COR_TEXTO
    Btn.TextSize = 13
    Btn.Font = Enum.Font.GothamBold
    Btn.AutoButtonColor = false
    Btn.Parent = PaginaContainer

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Btn

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = COR_ATIVO
    Stroke.Thickness = 1
    Stroke.Transparency = 0.5
    Stroke.Parent = Btn

    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), {
            BackgroundColor3 = COR_BOTAO_HOVER
        }):Play()
    end)

    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), {
            BackgroundColor3 = CorFundo or COR_BOTAO
        }):Play()
    end)

    Btn.MouseButton1Click:Connect(Callback)
    return Btn
end

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.fromOffset(0, 250)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Pronto."
StatusLabel.TextColor3 = COR_TEXTO_FRACO
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = PaginaContainer

--==================================================
-- LOOP AUTO STEAL
--==================================================

local Rodando = false

local function AutoSteal()
    while Rodando do
        local Char = GetCharacter()
        if not Char then
            StatusLabel.Text = "Sem personagem..."
            task.wait(0.5)
            continue
        end

        local Ovo, PosOvo = EncontrarOvo()
        if not Ovo then
            StatusLabel.Text = "Procurando ovos..."
            task.wait(0.5)
            continue
        end

        StatusLabel.Text = "🎯 Roubando: " .. Ovo.Name

        TeleportarPara(PosOvo + Vector3.new(0, 3, 0), true)
        task.wait(0.1)

        RoubarOvo(Ovo)
        task.wait(0.2)

        local PosPlot = EncontrarMinhaPlot()
        if PosPlot then
            StatusLabel.Text = "🏠 Voltando pra plot..."
            TeleportarPara(PosPlot + Vector3.new(0, 5, 0), true)
            task.wait(0.3)
        else
            StatusLabel.Text = "⚠️ Plot não encontrada"
        end

        task.wait(TempoEntreAcoes)
    end
end

--==================================================
-- PÁGINAS
--==================================================

local BtnToggleRef = nil

local function PaginaAutoSteal()
    LimparPagina()
    TituloPagina.Text = "Auto Steal"

    BtnToggleRef = CriarBotaoAcao("▶  Iniciar Auto Steal", 0, COR_ATIVO, function()
        Rodando = not Rodando
        if Rodando then
            BtnToggleRef.Text = "⏹  Parar Auto Steal"
            TweenService:Create(BtnToggleRef, TweenInfo.new(0.15), {
                BackgroundColor3 = COR_VERMELHO
            }):Play()
            task.spawn(AutoSteal)
        else
            BtnToggleRef.Text = "▶  Iniciar Auto Steal"
            TweenService:Create(BtnToggleRef, TweenInfo.new(0.15), {
                BackgroundColor3 = COR_ATIVO
            }):Play()
            StatusLabel.Text = "Parado."
        end
    end)

    CriarBotaoAcao("🏠  Voltar para Plot", 50, COR_BOTAO, function()
        local Pos = EncontrarMinhaPlot()
        if Pos then
            TeleportarPara(Pos + Vector3.new(0, 5, 0), true)
            StatusLabel.Text = "🏠 Voltou pra plot!"
        else
            StatusLabel.Text = "⚠️ Plot não encontrada"
        end
    end)

    CriarBotaoAcao("🔄  Resetar Status", 100, COR_BOTAO, function()
        StatusLabel.Text = "Pronto."
    end)
end

local function PaginaInfo()
    LimparPagina()
    TituloPagina.Text = "Informações"

    local Info = Instance.new("TextLabel")
    Info.Size = UDim2.new(1, 0, 0, 200)
    Info.BackgroundTransparency = 1
    Info.Text = "SERAPHIM-HUB\n\n"
        .. "✔ God Mode sempre ativo\n"
        .. "✔ Auto Steal de ovos\n"
        .. "✔ Retorno automático pra plot\n"
        .. "✔ Tema roxo Seraphim\n\n"
        .. "Versão: 1.0\n"
        .. "Estilo: Linno"
    Info.TextColor3 = COR_TEXTO
    Info.TextSize = 12
    Info.Font = Enum.Font.Gotham
    Info.TextXAlignment = Enum.TextXAlignment.Left
    Info.TextYAlignment = Enum.TextYAlignment.Top
    Info.RichText = true
    Info.Parent = PaginaContainer
end

--==================================================
-- CRIA AS ABAS
--==================================================

CriarAba("Auto Steal", 1, PaginaAutoSteal)
CriarAba("Info", 2, PaginaInfo)

-- Abre primeira aba
task.defer(function()
    AbaAtual = "Auto Steal"
    PaginaAutoSteal()
    -- Marca visual
    for _, Outro in ipairs(AbasContainer:GetChildren()) do
        if Outro:IsA("TextButton") and Outro.Text:find("Auto Steal") then
            Outro.BackgroundColor3 = COR_ATIVO
            local s = Outro:FindFirstChildOfClass("UIStroke")
            if s then s.Transparency = 0 end
        end
    end
end)

--==================================================
-- BOTÃO FECHAR
--==================================================

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(28, 28)
CloseBtn.Position = UDim2.new(1, -38, 0, 10)
CloseBtn.BackgroundColor3 = COR_BOTAO
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = COR_TEXTO
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Content

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = COR_VERMELHO
    }):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = COR_BOTAO
    }):Play()
end)

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

--==================================================
-- ARRASTAR
--==================================================

local Dragging = false
local DragStart, InicioPos

Sidebar.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        InicioPos = Main.Position

        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not Dragging then return end
    if Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch then
        local Delta = Input.Position - DragStart
        Main.Position = UDim2.new(
            InicioPos.X.Scale, InicioPos.X.Offset + Delta.X,
            InicioPos.Y.Scale, InicioPos.Y.Offset + Delta.Y
        )
    end
end)

--==================================================
-- INÍCIO
--==================================================

print("🟣 Seraphim-Hub carregado! (Estilo Linno)")
