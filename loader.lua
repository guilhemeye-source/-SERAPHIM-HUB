-- Auto Rota | Anti-Lag + Anti-Travamento + Bypass
-- Teleporte estável sem cair, travar ou morrer

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui", 10)
if not PlayerGui then return end

-- ==============================================
-- CONFIGURAÇÕES
-- ==============================================
local Config = {
    TempoFinal = 7,
    AlturaTeleporte = 2.8,
    TempoEntreAreas = 0.35,
    DistanciaDetect = 250,
    -- ↓ ANTI-LAG / AJUSTES DE ESTABILIDADE ↓
    LimiteTentativas = 3,        -- Tenta teletransportar até 3x se falhar
    TempoEsperaRecupera = 0.15,   -- Tempo entre tentativas
    ZeraVelocidadeTotal = true,   -- Corta qualquer movimento residual
    AntiTremer = true,            -- Evita piscar/tremer na tela
    LimpaCacheRespawn = true,     -- Limpa lixo ao renascer
    UsaRenderStepped = false      -- Deixe false = mais estável
}

local Biomas = {
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

-- ==============================================
-- GUI DISCRETA
-- ==============================================
local Gui = Instance.new("ScreenGui")
Gui.Name = tostring(math.random(100000, 999999))
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if gethui then Gui.Parent = gethui() else Gui.Parent = PlayerGui end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "UI"
MainFrame.Size = UDim2.fromOffset(230, 150)
MainFrame.Position = UDim2.new(0.02, 0, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 15, 22)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = Gui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(80, 180, 240)
Stroke.Thickness = 1.5

-- Cabeçalho
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 34)
TopBar.BackgroundColor3 = Color3.fromRGB(8, 11, 18)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -45, 1, 0)
Title.Position = UDim2.fromOffset(10, 0)
Title.BackgroundTransparency = 1
Title.Text = "Auto Rota"
Title.TextColor3 = Color3.fromRGB(240, 240, 245)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(24, 24)
CloseBtn.Position = UDim2.new(1, -28, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(28, 32, 42)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

-- Status
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -20, 0, 28)
StatusText.Position = UDim2.fromOffset(10, 45)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Pronto"
StatusText.TextColor3 = Color3.fromRGB(160, 170, 185)
StatusText.TextSize = 11
StatusText.Font = Enum.Font.Gotham
StatusText.Parent = MainFrame

-- Botão Principal
local MainBtn = Instance.new("TextButton")
MainBtn.Size = UDim2.new(1, -20, 0, 40)
MainBtn.Position = UDim2.fromOffset(10, 95)
MainBtn.BackgroundColor3 = Color3.fromRGB(20, 140, 90)
MainBtn.Text = "▶ Iniciar"
MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MainBtn.TextSize = 13
MainBtn.Font = Enum.Font.GothamBold
MainBtn.Parent = MainFrame
Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(0, 7)

-- ==============================================
-- FUNÇÕES AUXILIARES + ANTI-LAG
-- ==============================================
local Rota = {}
local UltimoTeleporte = 0

local function LimpaMemoria()
    -- Limpa referências antigas = sem vazamento de memória
    table.clear(Rota)
    collectgarbage("collect")
end

local function GetContainer()
    return workspace:FindFirstChild("Zones") or workspace
end

local function FindArea(name)
    local container = GetContainer()
    if not container then return nil end
    local obj = container:FindFirstChild(name)
    if obj then return obj end
    -- Busca otimizada — para na primeira correspondência
    local resultado = nil
    for _, v in ipairs(container:GetDescendants()) do
        if v.Name == name and (v:IsA("BasePart") or v:IsA("Model") or v:IsA("Folder")) then
            resultado = v
            break
        end
    end
    return resultado
end

local function GetPoint(area)
    if not area then return nil end
    if area:IsA("BasePart") then return area.CFrame end
    if area:IsA("Model") then
        local ok, res = pcall(function() return area:GetPivot() end)
        if ok and res then return res end
    end
    local part = area:FindFirstChildWhichIsA("BasePart", true)
    return part and part.CFrame or nil
end

local function BuildRoute()
    LimpaMemoria()
    for id, name in pairs(Biomas) do
        local area = FindArea(name)
        if area then
            local point = GetPoint(area)
            if point then
                table.insert(Rota, {ID = id, Nome = name, CFrame = point})
            end
        end
    end
    table.sort(Rota, function(a, b) return a.ID < b.ID end)
end

local function GetCurrentArea(pos)
    local best, minDist = nil, Config.DistanciaDetect
    for _, v in ipairs(Rota) do
        local dist = (pos - v.CFrame.Position).Magnitude
        if dist < minDist then
            minDist = dist
            best = v
        end
    end
    return best
end

-- ✅ TELEPORTE À PROVA DE FALHA — NÃO TRAVA
local function SafeTeleport(root, cframe)
    if not root or not cframe then return false end
    
    -- ANTI-TREMER: Evita piscar tela
    if Config.AntiTremer then
        RunService.RenderStepped:Wait()
    end

    local hum = root.Parent:FindFirstChildOfClass("Humanoid")
    local Sucesso = false

    -- Tenta várias vezes se falhar
    for tentativa = 1, Config.LimiteTentativas do
        if not root or not root.Parent then break end

        -- Bloqueia estados de queda
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Falling, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        end

        -- Zera TODA velocidade e força
        if Config.ZeraVelocidadeTotal then
            root.Velocity = Vector3.zero
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end

        -- Faz o teleporte
        root.CFrame = cframe + Vector3.new(0, Config.AlturaTeleporte, 0)

        -- Zera de novo para garantir
        root.Velocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero

        -- Verifica se chegou no destino
        local DistanciaChegada = (root.Position - (cframe + Vector3.new(0, Config.AlturaTeleporte, 0)).Position).Magnitude
        if DistanciaChegada < 5 then
            Sucesso = true
            break
        end

        task.wait(Config.TempoEsperaRecupera)
    end

    -- Restaura estados
    if hum then
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Falling, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
    end

    UltimoTeleporte = os.clock()
    return Sucesso
end

-- ==============================================
-- LÓGICA PRINCIPAL
-- ==============================================
local Running = false

local function StopLoop()
    Running = false
    MainBtn.Text = "▶ Iniciar"
    MainBtn.BackgroundColor3 = Color3.fromRGB(20, 140, 90)
    StatusText.Text = "Pronto"
end

local function StartLoop()
    if Running then return StopLoop() end
    Running = true
    MainBtn.Text = "⏹ Parar"
    MainBtn.BackgroundColor3 = Color3.fromRGB(170, 30, 30)

    local Char = Player.Character
    if not Char then 
        StatusText.Text = "Personagem não carregado"
        task.wait(0.5)
        Char = Player.Character
        if not Char then return StopLoop() end
    end

    local Root = Char:FindFirstChild("HumanoidRootPart")
    if not Root then 
        StatusText.Text = "Root não encontrado"
        return StopLoop() 
    end

    if #Rota == 0 then BuildRoute() end
    if #Rota == 0 then 
        StatusText.Text = "Nenhuma área detectada"
        return StopLoop() 
    end

    local Atual = GetCurrentArea(Root.Position)
    local IdAtual = Atual and Atual.ID or -1

    StatusText.Text = Atual and "Em: "..Atual.Nome or "Iniciando..."
    task.wait(0.5)

    -- Se está no final → volta até o início
    if IdAtual == 12 then
        StatusText.Text = "Voltando do final..."
        for i = #Rota - 1, 1, -1 do
            if not Running then break end
            local dest = Rota[i]
            if not dest then continue end
            
            local c = Player.Character
            if not c then 
                StatusText.Text = "Personagem perdido — reiniciando..."
                task.wait(1)
                c = Player.Character
                if not c then break end
            end
            
            local r = c:FindFirstChild("HumanoidRootPart")
            if not r then break end

            StatusText.Text = "← "..dest.Nome
            local DeuCerto = SafeTeleport(r, dest.CFrame)
            if not DeuCerto then
                StatusText.Text = "⚠ "..dest.Nome.." — tentando novamente"
            end
            task.wait(Config.TempoEntreAreas)
        end
    else
        -- Avança da posição atual até o fim
        for _, dest in ipairs(Rota) do
            if not Running then break end
            if dest.ID <= IdAtual then continue end
            
            local c = Player.Character
            if not c then 
                StatusText.Text = "Reconectando personagem..."
                task.wait(1)
                c = Player.Character
                if not c then break end
            end
            
            local r = c:FindFirstChild("HumanoidRootPart")
            if not r then break end

            StatusText.Text = "→ "..dest.Nome
            local DeuCerto = SafeTeleport(r, dest.CFrame)
            if not DeuCerto then
                StatusText.Text = "⚠ "..dest.Nome.." — sem resposta"
            end
            task.wait(Config.TempoEntreAreas)
        end
    end

    if Running then
        StatusText.Text = "Concluído! "..Config.TempoFinal.."s"
        task.wait(Config.TempoFinal)
    end

    StopLoop()
end

-- ==============================================
-- EVENTOS
-- ==============================================
MainBtn.MouseButton1Click:Connect(StartLoop)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Arrastar
local Drag, StartPos, StartOffset
TopBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        Drag = true
        StartPos = i.Position
        StartOffset = MainFrame.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then Drag = false end
        end)
    end
end)

UIS.InputChanged:Connect(function(i)
    if not Drag then return end
    if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
        local d = i.Position - StartPos
        MainFrame.Position = UDim2.new(
            StartOffset.X.Scale, StartOffset.X.Offset + d.X,
            StartOffset.Y.Scale, StartOffset.Y.Offset + d.Y
        )
    end
end)

-- Recarrega ao renascer + limpa lixo
Player.CharacterAdded:Connect(function()
    if Config.LimpaCacheRespawn then
        task.wait(0.2)
        BuildRoute()
    end
end)

print("[Auto Rota] Carregado com Anti-Lag ✅")
