--// SERAPHIM HUB — MM2 + FUNDO PERSONALIZADO
--// ESP + AIM ASSIST + NOCLIP + INFINITE JUMP + KEY

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local KEY = "Rlltxw"

local ESP_ENABLED = false
local AIM_ENABLED = false
local NOCLIP_ENABLED = false
local INFINITE_JUMP_ENABLED = false

local AIM_FOV = 180

local ESP = {}

--==================================================
-- DETECTAR PAPEL DO JOGADOR
--==================================================

local function getRole(player)
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        if backpack:FindFirstChild("Knife") then return "Murderer" end
        if backpack:FindFirstChild("Gun") then return "Sheriff" end
    end
    local character = player.Character
    if character then
        if character:FindFirstChild("Knife") then return "Murderer" end
        if character:FindFirstChild("Gun") then return "Sheriff" end
    end
    return "Innocent"
end

--==================================================
-- ESP
--==================================================

local function removeESP(player)
    if ESP[player] then
        ESP[player]:Destroy()
        ESP[player] = nil
    end
end

local function updateESP(player)
    if player == LocalPlayer then return end
    local character = player.Character
    if not character then removeESP(player) return end
    if not ESP_ENABLED then
        if ESP[player] then ESP[player].Enabled = false end
        return
    end
    local highlight = ESP[player]
    if not highlight or highlight.Parent ~= character then
        if highlight then highlight:Destroy() end
        highlight = Instance.new("Highlight")
        highlight.Name = "SeraphimESP"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillTransparency = 0.45
        highlight.OutlineTransparency = 0
        highlight.Parent = character
        ESP[player] = highlight
    end
    local role = getRole(player)
    highlight.Enabled = true
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
        for _, player in ipairs(Players:GetPlayers()) do
            updateESP(player)
        end
    end
end)

Players.PlayerRemoving:Connect(removeESP)

local function setupPlayer(player)
    if player == LocalPlayer then return end
    player.CharacterAdded:Connect(function()
        removeESP(player)
        task.wait(0.5)
        updateESP(player)
    end)
    player.CharacterRemoving:Connect(removeESP)
    if player.Character then
        task.spawn(function() task.wait(0.5) updateESP(player) end)
    end
end

for _, p in ipairs(Players:GetPlayers()) do setupPlayer(p) end
Players.PlayerAdded:Connect(setupPlayer)

--==================================================
-- NOCLIP
--==================================================

local function setNoclip(enabled)
    NOCLIP_ENABLED = enabled
    local char = LocalPlayer.Character
    if not char then return end
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("BasePart") then d.CanCollide = not enabled end
    end
end

RunService.Stepped:Connect(function()
    if not NOCLIP_ENABLED then return end
    local char = LocalPlayer.Character
    if char then
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("BasePart") then d.CanCollide = false end
        end
    end
end)

--==================================================
-- INFINITE JUMP
--==================================================

UserInputService.JumpRequest:Connect(function()
    if not INFINITE_JUMP_ENABLED then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

--==================================================
-- AIM ASSIST
--==================================================

local function getClosestTarget()
    local closest, minDist = nil, AIM_FOV
    local center = Camera.ViewportSize / 2
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local head = p.Character:FindFirstChild("Head")
            if hum and hum.Health > 0 and head then
                local sp, vis = Camera:WorldToViewportPoint(head.Position)
                if vis and sp.Z > 0 then
                    local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                    if dist < minDist then minDist = dist closest = head end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if not AIM_ENABLED then return end
    local target = getClosestTarget()
    if target then Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.Position) end
end)

--==================================================
-- CORES — SERAPHIM THEME 🪽
--==================================================

local COLORS = {
    Background    = Color3.fromRGB(8, 5, 15),
    Surface       = Color3.fromRGB(22, 15, 40),
    SurfaceLight  = Color3.fromRGB(50, 25, 90),

    Accent        = Color3.fromRGB(124, 58, 237),   -- Roxo principal
    AccentLight   = Color3.fromRGB(180, 140, 255), -- Roxo brilhante neon
    Glow          = Color3.fromRGB(200, 170, 255),

    Text          = Color3.fromRGB(250, 245, 255),
    Muted         = Color3.fromRGB(160, 140, 200),

    Success       = Color3.fromRGB(34, 197, 94),
    Danger        = Color3.fromRGB(239, 68, 68)
}

--==================================================
-- FUNÇÕES DA INTERFACE
--==================================================

local function addCorner(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = inst
    return c
end

local function addStroke(inst, col, trans, thick)
    local s = Instance.new("UIStroke")
    s.Color = col
    s.Transparency = trans or 0
    s.Thickness = thick or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = inst
    return s
end

local function addGradient(inst, a, b, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(a, b)
    g.Rotation = rot or 0
    g.Parent = inst
    return g
end

local function addShadow(parent, size, pos)
    local s = Instance.new("Frame")
    s.Name = "Shadow"
    s.Size = size s.Position = pos
    s.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    s.BackgroundTransparency = 0.55
    s.ZIndex = 0
    s.Parent = parent
    addCorner(s, 18)
    return s
end

local function addHover(btn, norm, hov)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = hov,
            Size = UDim2.new(btn.Size.X.Scale, btn.Size.X.Offset, 0, btn.Size.Y.Offset + 2)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = norm,
            Size = UDim2.new(btn.Size.X.Scale, btn.Size.X.Offset, 0, btn.Size.Y.Offset - 2)
        }):Play()
    end)
end

local function styleButton(btn, icon, title, desc, enabled)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.BackgroundColor3 = enabled and COLORS.SurfaceLight or COLORS.Surface
    addCorner(btn, 12)
    addStroke(btn, enabled and COLORS.Accent or Color3.fromRGB(70, 55, 115), 0.35, 1)

    local iconL = Instance.new("TextLabel")
    iconL.Size = UDim2.fromOffset(34, 34)
    iconL.Position = UDim2.fromOffset(12, 7)
    iconL.BackgroundColor3 = enabled and COLORS.Accent or Color3.fromRGB(70, 55, 115)
    iconL.Text = icon
    iconL.TextColor3 = COLORS.Text
    iconL.Font = Enum.Font.GothamBold
    iconL.TextSize = 15
    iconL.Parent = btn
    addCorner(iconL, 9)

    local titleL = Instance.new("TextLabel")
    titleL.Size = UDim2.new(1, -118, 0, 22)
    titleL.Position = UDim2.fromOffset(58, 7)
    titleL.BackgroundTransparency = 1
    titleL.Text = title
    titleL.TextColor3 = COLORS.Text
    titleL.Font = Enum.Font.GothamBold
    titleL.TextSize = 14
    titleL.TextXAlignment = Enum.TextXAlignment.Left
    titleL.Parent = btn

    local stateL = Instance.new("TextLabel")
    stateL.Name = "State"
    stateL.Size = UDim2.fromOffset(62, 24)
    stateL.Position = UDim2.new(1, -74, 0.5, -12)
    stateL.BackgroundColor3 = enabled and COLORS.Success or Color3.fromRGB(70, 55, 115)
    stateL.BackgroundTransparency = enabled and 0.75 or 0
    stateL.Text = enabled and "ATIVADO" or "DESLIGADO"
    stateL.TextColor3 = enabled and Color3.fromRGB(134, 239, 172) or COLORS.Muted
    stateL.Font = Enum.Font.GothamBold
    stateL.TextSize = 10
    stateL.Parent = btn
    addCorner(stateL, 7)
    return stateL
end

--==================================================
-- TELA DE KEY
--==================================================

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "SeraphimKey"
KeyGui.ResetOnSpawn = false
KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KeyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local KeyShadow = addShadow(KeyGui, UDim2.fromOffset(342, 240), UDim2.fromScale(0.5, 0.5))
KeyShadow.AnchorPoint = Vector2.new(0.5, 0.5)

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.fromOffset(330, 228)
KeyFrame.Position = UDim2.fromScale(0.5, 0.5)
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.BackgroundColor3 = COLORS.Background
KeyFrame.ZIndex = 1
KeyFrame.Parent = KeyGui
addCorner(KeyFrame, 18)
addStroke(KeyFrame, COLORS.Accent, 0.2, 1.5)

-- Camada de fundo estética
local KeyBg = Instance.new("Frame")
KeyBg.Size = UDim2.fromScale(1, 1)
KeyBg.BackgroundColor3 = Color3.fromRGB(15, 8, 25)
KeyBg.BorderSizePixel = 0
KeyBg.ZIndex = 0
KeyBg.Parent = KeyFrame
addCorner(KeyBg, 18)
addGradient(KeyBg, Color3.fromRGB(50, 15, 95), Color3.fromRGB(8, 5, 15), 135)

local KeyTop = Instance.new("Frame")
KeyTop.Size = UDim2.new(1, 0, 0, 78)
KeyTop.BackgroundColor3 = COLORS.Accent
KeyTop.Parent = KeyFrame
addCorner(KeyTop, 18)
addGradient(KeyTop, COLORS.Accent, COLORS.AccentLight, 25)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, -40, 0, 30)
KeyTitle.Position = UDim2.fromOffset(20, 14)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "SERAPHIM HUB"
KeyTitle.TextColor3 = COLORS.Text
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 24
KeyTitle.TextXAlignment = Enum.TextXAlignment.Left
KeyTitle.Parent = KeyTop

local KeySub = Instance.new("TextLabel")
KeySub.Size = UDim2.new(1, -40, 0, 18)
KeySub.Position = UDim2.fromOffset(20, 46)
KeySub.BackgroundTransparency = 1
KeySub.Text = "Guardião das sombras ✦ MM2"
KeySub.TextColor3 = Color3.fromRGB(233, 223, 255)
KeySub.Font = Enum.Font.Gotham
KeySub.TextSize = 12
KeySub.TextXAlignment = Enum.TextXAlignment.Left
KeySub.Parent = KeyTop

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -40, 0, 44)
KeyBox.Position = UDim2.fromOffset(20, 96)
KeyBox.PlaceholderText = "Insira sua chave..."
KeyBox.Text = ""
KeyBox.ClearTextOnFocus = false
KeyBox.TextColor3 = COLORS.Text
KeyBox.PlaceholderColor3 = COLORS.Muted
KeyBox.BackgroundColor3 = COLORS.Surface
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.Parent = KeyFrame
addCorner(KeyBox, 10)
addStroke(KeyBox, Color3.fromRGB(100, 80, 150), 0.25, 1)

local EnterBtn = Instance.new("TextButton")
EnterBtn.Size = UDim2.new(1, -40, 0, 44)
EnterBtn.Position = UDim2.fromOffset(20, 154)
EnterBtn.Text = "ENTRAR NO SERAPHIM"
EnterBtn.TextColor3 = COLORS.Text
EnterBtn.BackgroundColor3 = COLORS.Accent
EnterBtn.Font = Enum.Font.GothamBold
EnterBtn.TextSize = 13
EnterBtn.AutoButtonColor = false
EnterBtn.Parent = KeyFrame
addCorner(EnterBtn, 10)
addGradient(EnterBtn, COLORS.Accent, COLORS.AccentLight, 25)
addHover(EnterBtn, COLORS.Accent, COLORS.AccentLight)

--==================================================
-- ABRIR HUB PRINCIPAL
--==================================================

EnterBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text ~= KEY then
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Chave inválida. Tente novamente."
        return
    end
    KeyGui:Destroy()

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "SeraphimHub"
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local MainShadow = addShadow(Gui, UDim2.fromOffset(412, 580), UDim2.fromScale(0.5, 0.5))
    MainShadow.AnchorPoint = Vector2.new(0.5, 0.5)

    local Main = Instance.new("Frame")
    Main.Size = UDim2.fromOffset(400, 568)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = COLORS.Background
    Main.ZIndex = 1
    Main.Parent = Gui
    addCorner(Main, 20)
    addStroke(Main, COLORS.Accent, 0.15, 1.5)

    -- ===== FUNDO ESTILO SERAPHIM =====
    -- Camada de fundo escuro com brilho roxo
    local BgLayer = Instance.new("Frame")
    BgLayer.Name = "SeraphimBackground"
    BgLayer.Size = UDim2.fromScale(1, 1)
    BgLayer.BackgroundColor3 = Color3.fromRGB(10, 5, 20)
    BgLayer.BorderSizePixel = 0
    BgLayer.ZIndex = 1
    BgLayer.Parent = Main
    addCorner(BgLayer, 20)

    -- Gradiente roxo celestial
    local BgGradient = Instance.new("UIGradient")
    BgGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 20, 120)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(25, 12, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 3, 12))
    }
    BgGradient.Rotation = 135
    BgGradient.Parent = BgLayer

    -- Brilho suave
    local GlowOverlay = Instance.new("Frame")
    GlowOverlay.Size = UDim2.new(1, 0, 0.65, 0)
    GlowOverlay.Position = UDim2.new(0, 0, -0.1, 0)
    GlowOverlay.BackgroundColor3 = Color3.fromRGB(80, 40, 150)
    GlowOverlay.BackgroundTransparency = 0.85
    GlowOverlay.ZIndex = 2
    GlowOverlay.Parent = BgLayer
    addCorner(GlowOverlay, 0)

    -- Arrastar janela
    local dragging, dragStart, startPos = false, nil, nil
    Main.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = Main.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local delta = inp.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 100)
    Header.BackgroundColor3 = COLORS.Accent
    Header.Parent = Main
    addCorner(Header, 20)
    addGradient(Header, COLORS.Accent, COLORS.AccentLight, 25)

    -- Ícone do cabeçalho
    local HeaderIcon = Instance.new("TextLabel")
    HeaderIcon.Size = UDim2.fromOffset(44, 44)
    HeaderIcon.Position = UDim2.new(0.5, -22, 0, 70)
    HeaderIcon.BackgroundColor3 = COLORS.Surface
    HeaderIcon.Text = "⚔️"
    HeaderIcon.Font = Enum.Font.GothamBold
    HeaderIcon.TextSize = 22
    HeaderIcon.TextColor3 = COLORS.Text
    HeaderIcon.ZIndex = 5
    HeaderIcon.Parent = Main
    addCorner(HeaderIcon, 12)
    addStroke(HeaderIcon, COLORS.AccentLight, 0, 1.5)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -80, 0, 30)
    Title.Position = UDim2.fromOffset(22, 15)
    Title.BackgroundTransparency = 1
    Title.Text = "SERAPHIM HUB"
    Title.TextColor3 = COLORS.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 23
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, -80, 0, 18)
    Subtitle.Position = UDim2.fromOffset(22, 52)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Guardião das sombras • MM2"
    Subtitle.TextColor3 = Color3.fromRGB(233, 223, 255)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextSize = 12
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = Header

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.fromOffset(38, 38)
    CloseBtn.Position = UDim2.new(1, -54, 0, 18)
    CloseBtn.Text = "×"
    CloseBtn.TextSize = 25
    CloseBtn.TextColor3 = COLORS.Text
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.BackgroundTransparency = 0.82
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = Header
    addCorner(CloseBtn, 10)
    addHover(CloseBtn, Color3.fromRGB(255, 255, 255), COLORS.Danger)

    local Section = Instance.new("TextLabel")
    Section.Size = UDim2.new(1, -40, 0, 20)
    Section.Position = UDim2.fromOffset(20, 125)
    Section.BackgroundTransparency = 1
    Section.Text = "CONTROLES"
    Section.TextColor3 = COLORS.Muted
    Section.Font = Enum.Font.GothamBold
    Section.TextSize = 11
    Section.TextXAlignment = Enum.TextXAlignment.Left
    Section.Parent = Main

    local function makeControl(y, icon, title, desc, enabled)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -40, 0, 54)
        btn.Position = UDim2.fromOffset(20, y)
        btn.Parent = Main
        local state = styleButton(btn, icon, title, desc, enabled)
        return btn, state
    end

    local ESPBtn, ESPState = makeControl(150, "E", "ESP DE ROLES", "Identifica o papel de cada jogador", ESP_ENABLED)
    addHover(ESPBth, COLORS.SurfaceLight, Color3.fromRGB(65, 45, 105))
    ESPBtn.MouseButton1Click:Connect(function()
        ESP_ENABLED = not ESP_ENABLED
        ESPState.Text = ESP_ENABLED and "ATIVADO" or "DESLIGADO"
        ESPState.BackgroundColor3 = ESP_ENABLED and COLORS.Success or Color3.fromRGB(70, 55, 115)
        ESPState.BackgroundTransparency = ESP_ENABLED and 0.75 or 0
        ESPState.TextColor3 = ESP_ENABLED and Color3.fromRGB(134, 239, 172) or COLORS.Muted
        if not ESP_ENABLED then
            for _, h in pairs(ESP) do if h then h.Enabled = false end end
        end
    end)

    local AimBtn, AimState = makeControl(214, "A", "AIM ASSIST", "Mira automaticamente no alvo", AIM_ENABLED)
    addHover(AimBtn, COLORS.Surface, Color3.fromRGB(65, 45, 105))
    AimBtn.MouseButton1Click:Connect(function()
        AIM_ENABLED = not AIM_ENABLED
        AimState.Text = AIM_ENABLED and "ATIVADO" or "DESLIGADO"
        AimState.BackgroundColor3 = AIM_ENABLED and COLORS.Success or Color3.fromRGB(70, 55, 115)
        AimState.BackgroundTransparency = AIM_ENABLED and 0.75 or 0
        AimState.TextColor3 = AIM_ENABLED and Color3.fromRGB(134, 239, 172) or COLORS.Muted
    end)

    local NoclipBtn, NoclipState = makeControl(278, "N", "NOCLIP", "Atravessa paredes", NOCLIP_ENABLED)
    addHover(NoclipBtn, COLORS.Surface, Color3.fromRGB(65, 45, 105))
    NoclipBtn.MouseButton1Click:Connect(function()
        setNoclip(not NOCLIP_ENABLED)
        NoclipState.Text = NOCLIP_ENABLED and "ATIVADO" or "DESLIGADO"
        NoclipState.BackgroundColor3 = NOCLIP_ENABLED and COLORS.Success or Color3.fromRGB(70, 55, 115)
        NoclipState.BackgroundTransparency = NOCLIP_ENABLED and 0.75 or 0
        NoclipState.TextColor3 = NOCLIP_ENABLED and Color3.fromRGB(134, 239, 172) or COLORS.Muted
    end)

    local JumpBtn, JumpState = makeControl(342, "J", "INFINITE JUMP", "Pule infinitamente", INFINITE_JUMP_ENABLED)
    addHover(JumpBtn, COLORS.Surface, Color3.fromRGB(65, 45, 105))
    JumpBtn.MouseButton1Click:Connect(function()
        INFINITE_JUMP_ENABLED = not INFINITE_JUMP_ENABLED
        JumpState.Text = INFINITE_JUMP_ENABLED and "ATIVADO" or "DESLIGADO"
        JumpState.BackgroundColor3 = INFINITE_JUMP_ENABLED and COLORS.Success or Color3.fromRGB(70, 55, 115)
        JumpState.BackgroundTransparency = INFINITE_JUMP_ENABLED and 0.75 or 0
        JumpState.TextColor3 = INFINITE_JUMP_ENABLED and Color3.fromRGB(134, 239, 172) or COLORS.Muted
    end)

    local Footer = Instance.new("TextLabel")
    Footer.Size = UDim2.new(1, -40, 0, 20)
    Footer.Position = UDim2.fromOffset(20, 535)
    Footer.BackgroundTransparency = 1
    Footer.Text = "✦ SERAPHIM HUB — Que a luz te guie ✦"
    Footer.TextColor3 = Color3.fromRGB(160, 140, 200)
    Footer.Font = Enum.Font.Gotham
    Footer.TextSize = 10
    Footer.TextXAlignment = Enum.TextXAlignment.Center
    Footer.Parent = Main

    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Size = UDim2.fromOffset(58, 58)
    OpenBtn.Position = UDim2.fromOffset(18, 210)
    OpenBtn.Text = "S"
    OpenBtn.TextSize = 18
    OpenBtn.TextColor3 = COLORS.Text
    OpenBtn.BackgroundColor3 = COLORS.Accent
    OpenBtn.AutoButtonColor = false
    OpenBtn.Visible = false
    OpenBtn.Parent = Gui
    addCorner(OpenBtn, 18)
    addStroke(OpenBtn, COLORS.AccentLight, 0.2, 1.5)
    addGradient(OpenBtn, COLORS.Accent, COLORS.AccentLight, 25)

    CloseBtn.MouseButton1Click:Connect(function()
        Main.Visible = false
        MainShadow.Visible = false
        OpenBtn.Visible = true
    end)
    OpenBtn.MouseButton1Click:Connect(function()
        Main.Visible = true
        MainShadow.Visible = true
        OpenBtn.Visible = false
    end)
end)

--// Fim do SERAPHIM HUB
