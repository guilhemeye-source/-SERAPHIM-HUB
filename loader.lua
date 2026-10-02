--// Seraphim-Hub - Baseado no estilo Linno Hub (Rayfield)
--// Tema roxo | Steal An Egg

--==================================================
-- CARREGAR RAYFIELD
--==================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--==================================================
-- CONFIG
--==================================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local DistanciaDoChao = 3
local TempoEntreAcoes = 0.4
local VidaTravada = 100000

local NomesOvo  = { "Egg", "Ovo", "Nest" }
local NomesPlot = { "Plot", "Base", "CollectZone", "Collect", "Garden", "Pen" }

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
-- FUNÇÕES AUXILIARES
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
-- JANELA RAYFIELD (TEMA ROXO)
--==================================================

local Window = Rayfield:CreateWindow({
    Name = "Seraphim-Hub",
    Icon = 0,
    LoadingTitle = "Seraphim-Hub",
    LoadingSubtitle = "by Seraphim",
    Theme = "Amethyst",  -- tema roxo (mais próximo do Seraphim)
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SeraphimHub",
        FileName = "Config"
    },
    KeySystem = false
})

--==================================================
-- ABA PRINCIPAL: AUTO STEAL
--==================================================

local TabAuto = Window:CreateTab("Auto Steal", 4483362458)

local Rodando = false

local function AutoSteal()
    while Rodando do
        local Char = GetCharacter()
        if not Char then
            task.wait(0.5)
            continue
        end

        local Ovo, PosOvo = EncontrarOvo()
        if not Ovo then
            task.wait(0.5)
            continue
        end

        TeleportarPara(PosOvo + Vector3.new(0, 3, 0), true)
        task.wait(0.1)

        RoubarOvo(Ovo)
        task.wait(0.2)

        local PosPlot = EncontrarMinhaPlot()
        if PosPlot then
            TeleportarPara(PosPlot + Vector3.new(0, 5, 0), true)
            task.wait(0.3)
        end

        task.wait(TempoEntreAcoes)
    end
end

TabAuto:CreateSection("Steal")

TabAuto:CreateToggle({
    Name = "Auto Steal (Roubar + Voltar)",
    CurrentValue = false,
    Flag = "AutoStealToggle",
    Callback = function(Value)
        Rodando = Value
        if Value then
            task.spawn(AutoSteal)
            Rayfield:Notify({
                Title = "Seraphim-Hub",
                Content = "Auto Steal ativado!",
                Duration = 3,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Seraphim-Hub",
                Content = "Auto Steal desativado.",
                Duration = 3,
                Image = 4483362458
            })
        end
    end
})

TabAuto:CreateButton({
    Name = "Voltar para Plot",
    Callback = function()
        local Pos = EncontrarMinhaPlot()
        if Pos then
            TeleportarPara(Pos + Vector3.new(0, 5, 0), true)
            Rayfield:Notify({
                Title = "Seraphim-Hub",
                Content = "Voltou para sua plot!",
                Duration = 2,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Seraphim-Hub",
                Content = "Plot não encontrada!",
                Duration = 2,
                Image = 4483362458
            })
        end
    end
})

TabAuto:CreateButton({
    Name = "Teleportar para Próximo Ovo",
    Callback = function()
        local Ovo, PosOvo = EncontrarOvo()
        if Ovo then
            TeleportarPara(PosOvo + Vector3.new(0, 3, 0), true)
            Rayfield:Notify({
                Title = "Seraphim-Hub",
                Content = "Teleportado para: " .. Ovo.Name,
                Duration = 2,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Seraphim-Hub",
                Content = "Nenhum ovo encontrado!",
                Duration = 2,
                Image = 4483362458
            })
        end
    end
})

--==================================================
-- ABA: PLAYER
--==================================================

local TabPlayer = Window:CreateTab("Player", 4483362458)

TabPlayer:CreateSection("Movimento")

TabPlayer:CreateSlider({
    Name = "WalkSpeed",
    Range = { 16, 200 },
    Increment = 2,
    Suffix = "studs",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        local Char = Player.Character
        if Char then
            local Hum = Char:FindFirstChildOfClass("Humanoid")
            if Hum then Hum.WalkSpeed = Value end
        end
    end
})

TabPlayer:CreateSlider({
    Name = "JumpPower",
    Range = { 50, 300 },
    Increment = 5,
    Suffix = "power",
    CurrentValue = 50,
    Flag = "JumpSlider",
    Callback = function(Value)
        local Char = Player.Character
        if Char then
            local Hum = Char:FindFirstChildOfClass("Humanoid")
            if Hum then Hum.JumpPower = Value end
        end
    end
})

TabPlayer:CreateSection("Vida")

TabPlayer:CreateToggle({
    Name = "God Mode",
    CurrentValue = true,
    Flag = "GodToggle",
    Callback = function(Value)
        if Value then
            AplicarGodMode(Player.Character)
        else
            local Char = Player.Character
            if Char then
                local FF = Char:FindFirstChild("SeraphimGodMode")
                if FF then FF:Destroy() end
            end
        end
    end
})

--==================================================
-- ABA: INFO
--==================================================

local TabInfo = Window:CreateTab("Info", 4483362458)

TabInfo:CreateSection("Sobre")

TabInfo:CreateParagraph({
    Title = "Seraphim-Hub",
    Content = "Hub no estilo Linno, tema roxo.\nAuto Steal + God Mode para Steal An Egg.\n\nFeito por Seraphim."
})

TabInfo:CreateButton({
    Name = "Copiar Discord",
    Callback = function()
        setclipboard("seraphim")
        Rayfield:Notify({
            Title = "Seraphim-Hub",
            Content = "Copiado!",
            Duration = 2,
            Image = 4483362458
        })
    end
})

--==================================================
-- NOTIFY DE INÍCIO
--==================================================

Rayfield:Notify({
    Title = "Seraphim-Hub",
    Content = "Hub carregado com sucesso!",
    Duration = 5,
    Image = 4483362458
})

print("🟣 Seraphim-Hub carregado!")
