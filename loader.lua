-- SERAPHIM HUB | Versão Delta/GitHub
-- MM2: ESP • AIM ASSIST • NOCLIP • INFINITE JUMP
-- Chave: Rlltxw

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Tween = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ========== CONFIGURAÇÕES ==========
local KEY = "Rlltxw"
local AIM_FOV = 180

-- ========== ESTADO ==========
local ESP_ENABLED = false
local AIM_ENABLED = false
local NOCLIP_ENABLED = false
local JUMP_ENABLED = false
local ESP_CACHE = {}

-- ========== DETECTAR FUNÇÕES ==========
local function getRole(player)
    local char = player.Character
    if not char then return "Innocent" end
    if char:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife") then
        return "Murderer"
    end
    if char:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Gun") then
        return "Sheriff"
    end
    return "Innocent"
end

-- ========== ESP ==========
local function applyESP(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    local highlight = char:FindFirstChild("SeraphimESP")
    if not ESP_ENABLED then
        if highlight then highlight.Enabled = false end
        return
    end
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "SeraphimESP"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillTransparency = 0.45
        highlight.OutlineTransparency = 0
        highlight.Parent = char
    end
    highlight.Enabled = true
    local role = getRole(player)
    if role == "Murderer" then
        highlight.FillColor = Color3.fromRGB(239, 68, 68)
        highlight.OutlineColor = Color3.fromRGB(248, 113, 113)
    elseif role == "Sheriff" then
        highlight.FillColor = Color3.fromRGB(59, 130, 246)
        highlight.OutlineColor = Color3.fromRGB(96, 165, 250)
    else
        highlight.FillColor = Color3.fromRGB(34, 197, 94)
        highlight.OutlineColor = Color3.fromRGB(74, 222, 128)
    end
end

task.spawn(function()
    while task.wait(0.2) do
        for _, p in ipairs(Players:GetPlayers()) do
            applyESP(p)
        end
    end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.5)
        applyESP(p)
    end)
end)

-- ========== NOCLIP ==========
RS.Stepped:Connect(function()
    if not NOCLIP_ENABLED then return end
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
end)

-- ========== PULAR SEM LIMITE ==========
UIS.JumpRequest:Connect(function()
    if not JUMP_ENABLED then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- ========== MIRAR AUTOMÁTICO ==========
RS.RenderStepped:Connect(function()
    if not AIM_ENABLED then return end
    local center = Camera.ViewportSize / 2
    local target, minDist = nil, AIM_FOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local head = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if head and hum and hum.Health > 0 then
                local scrPos, visible = Camera:WorldToViewportPoint(head.Position)
                if visible and scrPos.Z > 0 then
                    local dist = (Vector2.new(scrPos.X, scrPos.Y) - center).Magnitude
                    if dist < minDist then
                        minDist = dist
                        target = head
                    end
                end
            end
        end
    end
    if target then
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.Position)
    end
end)

-- ========== ESTILO DO PAINEL ==========
local C = {
    RoxoEscuro = Color3.fromHex("#120825"),
    RoxoMedio = Color3.fromHex("#2A1055"),
    RoxoClaro = Color3.fromHex("#7B2FFE"),
    RoxoBrilho = Color3.fromHex("#A884FF"),
    Card = Color3.fromHex("#1E1040"),
    Texto = Color3.fromHex("#FFFFFF"),
    Desligado = Color3.fromHex("#443377"),
    Ativado = Color3.fromHex("#38E060")
}

local function cantos(inst, raio)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, raio)
    c.Parent = inst
end

local function gradiente(inst, cor1, cor2, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(cor1, cor2)
    g.Rotation = rot or 135
    g.Parent = inst
end

local function botaoAlternar(btn, texto, ativo)
    local st = btn:FindFirstChild("StatusLabel")
    if not st then return end
    st.Text = ativo and "ATIVADO" or "DESLIGADO"
    st.BackgroundColor3 = ativo and C.Ativado or C.Desligado
    btn.BackgroundColor3 = ativo and C.RoxoClaro or C.Card
end

-- ========== TELA DE ACESSO ==========
local TelaChave = Instance.new("ScreenGui")
TelaChave.Name = "SeraphimAcesso"
TelaChave.ResetOnSpawn = false
TelaChave.Parent = LocalPlayer.PlayerGui

local QuadroChave = Instance.new("Frame")
QuadroChave.Size = UDim2.fromOffset(340, 260)
QuadroChave.Position = UDim2.fromScale(0.5, 0.5)
QuadroChave.AnchorPoint = Vector2.new(0.5, 0.5)
QuadroChave.BackgroundColor3 = C.RoxoEscuro
QuadroChave.Parent = TelaChave
cantos(QuadroChave, 20)

-- FUNDO ESTILO ARTE (sem imagem externa!)
local FundoChave = Instance.new("Frame")
FundoChave.Size = UDim2.fromScale(1, 1)
FundoChave.BackgroundColor3 = C.RoxoMedio
FundoChave.ZIndex = 0
FundoChave.Parent = QuadroChave
cantos(FundoChave, 20)
gradiente(FundoChave, C.RoxoClaro, C.RoxoEscuro, 135)

-- Brilho suave no topo
local BrilhoTopo = Instance.new("Frame")
BrilhoTopo.Size = UDim2.new(1, 0, 0.5, 0)
BrilhoTopo.Position = UDim2.new(0, 0, -0.1, 0)
BrilhoTopo.BackgroundColor3 = C.RoxoClaro
BrilhoTopo.BackgroundTransparency = 0.85
BrilhoTopo.ZIndex = 1
BrilhoTopo.Parent = FundoChave
cantos(BrilhoTopo, 0)

local Cabecalho = Instance.new("Frame")
Cabecalho.Size = UDim2.new(1, 0, 0, 90)
Cabecalho.BackgroundColor3 = C.RoxoClaro
Cabecalho.BackgroundTransparency = 0.2
Cabecalho.ZIndex = 2
Cabecalho.Parent = QuadroChave
cantos(Cabecalho, 20)

local Titulo = Instance.new("TextLabel")
Titulo.Size = UDim2.new(1, -40, 0, 32)
Titulo.Position = UDim2.fromOffset(20, 15)
Titulo.BackgroundTransparency = 1
Titulo.Text = "SERAPHIM HUB"
Titulo.TextColor3 = C.Texto
Titulo.Font = Enum.Font.GothamBold
Titulo.TextSize = 26
Titulo.TextXAlignment = Enum.TextXAlignment.Left
Titulo.ZIndex = 3
Titulo.Parent = QuadroChave

local SubTitulo = Instance.new("TextLabel")
SubTitulo.Size = UDim2.new(1, -40, 0, 18)
SubTitulo.Position = UDim2.fromOffset(20, 52)
SubTitulo.BackgroundTransparency = 1
SubTitulo.Text = "Guardião das sombras • MM2"
SubTitulo.TextColor3 = Color3.fromRGB(210, 200, 255)
SubTitulo.Font = Enum.Font.Gotham
SubTitulo.TextSize = 12
SubTitulo.TextXAlignment = Enum.TextXAlignment.Left
SubTitulo.ZIndex = 3
SubTitulo.Parent = QuadroChave

local CaixaChave = Instance.new("TextBox")
CaixaChave.Size = UDim2.new(1, -40, 0, 46)
CaixaChave.Position = UDim2.fromOffset(20, 115)
CaixaChave.PlaceholderText = "Digite sua chave..."
CaixaChave.Text = ""
CaixaChave.TextColor3 = C.Texto
CaixaChave.BackgroundColor3 = Color3.fromRGB(40, 25, 80)
CaixaChave.BackgroundTransparency = 0.4
CaixaChave.Font = Enum.Font.Gotham
CaixaChave.TextSize = 14
CaixaChave.ZIndex = 3
CaixaChave.Parent = QuadroChave
cantos(CaixaChave, 12)

local BotaoEntrar = Instance.new("TextButton")
BotaoEntrar.Size = UDim2.new(1, -40, 0, 46)
BotaoEntrar.Position = UDim2.fromOffset(20, 180)
BotaoEntrar.Text = "ENTRAR"
BotaoEntrar.TextColor3 = C.Texto
BotaoEntrar.BackgroundColor3 = C.RoxoClaro
BotaoEntrar.Font = Enum.Font.GothamBold
BotaoEntrar.TextSize = 15
BotaoEntrar.AutoButtonColor = false
BotaoEntrar.ZIndex = 3
BotaoEntrar.Parent = QuadroChave
cantos(BotaoEntrar, 12)
gradiente(BotaoEntrar, C.RoxoClaro, C.RoxoBrilho, 20)

-- ========== PAINEL PRINCIPAL ==========
local function abrirPainel()
    TelaChave:Destroy()
    local Painel = Instance.new("ScreenGui")
    Painel.Name = "SeraphimPainel"
    Painel.ResetOnSpawn = false
    Painel.Parent = LocalPlayer.PlayerGui

    local Janela = Instance.new("Frame")
    Janela.Size = UDim2.fromOffset(390, 560)
    Janela.Position = UDim2.fromScale(0.5, 0.5)
    Janela.AnchorPoint = Vector2.new(0.5, 0.5)
    Janela.BackgroundColor3 = C.RoxoEscuro
    Janela.Parent = Painel
    cantos(Janela, 20)

    -- FUNDO ESTILO IMAGEM (gradientes sobrepostos)
    local Fundo = Instance.new("Frame")
    Fundo.Size = UDim2.fromScale(1, 1)
    Fundo.BackgroundColor3 = C.RoxoMedio
    Fundo.ZIndex = 0
    Fundo.Parent = Janela
    cantos(Fundo, 20)
    gradiente(Fundo, Color3.fromHex("#5018A0"), C.RoxoEscuro, 135)

    -- Camada de brilho
    local Luz = Instance.new("Frame")
    Luz.Size = UDim2.new(1, 0, 0.7, 0)
    Luz.Position = UDim2.new(0, 0, -0.15, 0)
    Luz.BackgroundColor3 = C.RoxoClaro
    Luz.BackgroundTransparency = 0.88
    Luz.ZIndex = 1
    Luz.Parent = Fundo

    -- Escurece um pouco pra ler texto
    local Sobrepor = Instance.new("Frame")
    Sobrepor.Size = UDim2.fromScale(1, 1)
    Sobrepor.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Sobrepor.BackgroundTransparency = 0.5
    Sobrepor.ZIndex = 2
    Sobrepor.Parent = Fundo
    cantos(Sobrepor, 20)

    -- Cabeçalho
    local Topo = Instance.new("Frame")
    Topo.Size = UDim2.new(1, 0, 0, 105)
    Topo.BackgroundColor3 = C.RoxoClaro
    Topo.BackgroundTransparency = 0.15
    Topo.ZIndex = 3
    Topo.Parent = Janela
    cantos(Topo, 20)
    gradiente(Topo, C.RoxoClaro, C.RoxoBrilho, 25)

    local TituloP = Instance.new("TextLabel")
    TituloP.Size = UDim2.new(1, -80, 0, 32)
    TituloP.Position = UDim2.fromOffset(25, 20)
    TituloP.BackgroundTransparency = 1
    TituloP.Text = "SERAPHIM HUB"
    TituloP.TextColor3 = C.Texto
    TituloP.Font = Enum.Font.GothamBold
    TituloP.TextSize = 26
    TituloP.TextXAlignment = Enum.TextXAlignment.Left
    TituloP.ZIndex = 4
    TituloP.Parent = Janela

    local SubP = Instance.new("TextLabel")
    SubP.Size = UDim2.new(1, -80, 0, 18)
    SubP.Position = UDim2.fromOffset(25, 58)
    SubP.BackgroundTransparency = 1
    SubP.Text = "Guardião das sombras • MM2"
    SubP.TextColor3 = Color3.fromRGB(210, 200, 255)
    SubP.Font = Enum.Font.Gotham
    SubP.TextSize = 12
    SubP.TextXAlignment = Enum.TextXAlignment.Left
    SubP.ZIndex = 4
    SubP.Parent = Janela

    local Fechar = Instance.new("TextButton")
    Fechar.Size = UDim2.fromOffset(38, 38)
    Fechar.Position = UDim2.new(1, -55, 0, 20)
    Fechar.Text = "×"
    Fechar.TextSize = 26
    Fechar.TextColor3 = C.Texto
    Fechar.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
    Fechar.BackgroundTransparency = 0.4
    Fechar.AutoButtonColor = false
    Fechar.ZIndex = 4
    Fechar.Parent = Janela
    cantos(Fechar, 12)

    local Secao = Instance.new("TextLabel")
    Secao.Size = UDim2.new(1, -50, 0, 20)
    Secao.Position = UDim2.fromOffset(25, 130)
    Secao.BackgroundTransparency = 1
    Secao.Text = "CONTROLES"
    Secao.TextColor3 = Color3.fromRGB(180, 170, 200)
    Secao.Font = Enum.Font.GothamBold
    Secao.TextSize = 11
    Secao.TextXAlignment = Enum.TextXAlignment.Left
    Secao.ZIndex = 4
    Secao.Parent = Janela

    -- Criar botão
    local function criarBotao(y, icone, nome, ref)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -40, 0, 56)
        btn.Position = UDim2.fromOffset(20, y)
        btn.BackgroundColor3 = ref and C.RoxoClaro or C.Card
        btn.BackgroundTransparency = 0.3
        btn.AutoButtonColor = false
        btn.ZIndex = 4
        btn.Parent = Janela
        cantos(btn, 14)

        local ico = Instance.new("TextLabel")
        ico.Size = UDim2.fromOffset(36, 36)
        ico.Position = UDim2.fromOffset(12, 10)
        ico.BackgroundColor3 = Color3.fromRGB(90, 60, 160)
        ico.BackgroundTransparency = 0.4
        ico.Text = icone
        ico.TextColor3 = C.Texto
        ico.Font = Enum.Font.GothamBold
        ico.TextSize = 16
        ico.ZIndex = 5
        ico.Parent = btn
        cantos(ico, 10)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -130, 0, 22)
        lbl.Position = UDim2.fromOffset(62, 17)
        lbl.BackgroundTransparency = 1
        lbl.Text = nome
        lbl.TextColor3 = C.Texto
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 15
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 5
        lbl.Parent = btn

        local st = Instance.new("TextLabel")
        st.Name = "StatusLabel"
        st.Size = UDim2.fromOffset(70, 28)
        st.Position = UDim2.new(1, -82, 0.5, -14)
        st.BackgroundColor3 = ref and C.Ativado or C.Desligado
        st.Text = ref and "ATIVADO" or "DESLIGADO"
        st.TextColor3 = Color3.fromRGB(230, 230, 230)
        st.Font = Enum.Font.GothamBold
        st.TextSize = 11
        st.ZIndex = 5
        st.Parent = btn
        cantos(st, 8)

        return btn, st
    end

    -- Botões
    local btnESP, stESP = criarBotao(160, "E", "ESP DE ROLES", ESP_ENABLED)
    btnESP.MouseButton1Click:Connect(function()
        ESP_ENABLED = not ESP_ENABLED
        botaoAlternar(btnESP, stESP, ESP_ENABLED)
    end)

    local btnAIM, stAIM = criarBotao(228, "A", "AIM ASSIST", AIM_ENABLED)
    btnAIM.MouseButton1Click:Connect(function()
        AIM_ENABLED = not AIM_ENABLED
        botaoAlternar(btnAIM, stAIM, AIM_ENABLED)
    end)

    local btnNOC, stNOC = criarBotao(296, "N", "NOCLIP", NOCLIP_ENABLED)
    btnNOC.MouseButton1Click:Connect(function()
        NOCLIP_ENABLED = not NOCLIP_ENABLED
        botaoAlternar(btnNOC, stNOC, NOCLIP_ENABLED)
    end)

    local btnJMP, stJMP = criarBotao(364, "J", "INFINITE JUMP", JUMP_ENABLED)
    btnJMP.MouseButton1Click:Connect(function()
        JUMP_ENABLED = not JUMP_ENABLED
        botaoAlternar(btnJMP, stJMP, JUMP_ENABLED)
    end)

    local Rodape = Instance.new("TextLabel")
    Rodape.Size = UDim2.new(1, -40, 0, 18)
    Rodape.Position = UDim2.fromOffset(20, 525)
    Rodape.BackgroundTransparency = 1
    Rodape.Text = "✦ SERAPHIM HUB ✦"
    Rodape.TextColor3 = Color3.fromRGB(160, 140, 200)
    Rodape.Font = Enum.Font.Gotham
    Rodape.TextSize = 10
    Rodape.ZIndex = 4
    Rodape.Parent = Janela

    Fechar.MouseButton1Click:Connect(function() Painel:Destroy() end)
end

BotaoEntrar.MouseButton1Click:Connect(function()
    if CaixaChave.Text == KEY then
        abrirPainel()
    else
        CaixaChave.Text = ""
        CaixaChave.PlaceholderText = "❌ Chave inválida!"
    end
end)

-- FIM
