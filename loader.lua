-- =====================================================================
-- SERAPHIM-HUB | VERSÃO CORRIGIDA
-- =====================================================================

-- Inicializa a biblioteca visual Sirius Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu"))()

local Window = Rayfield:CreateWindow({
    Name = "💙 Seraphim-Hub | Steal an Egg 🥚",
    LoadingTitle = "Iniciando Seraphim-Hub...",
    LoadingSubtitle = "Versão Mobile Estabilizada",

    ConfigurationSaving = {
        Enabled = false
    },

    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = false
    },

    KeySystem = false
})

-- Localiza a pasta de ovos
local EggsFolder =
    workspace:FindFirstChild("Eggs")
    or workspace:FindFirstChild("EggSpawns")

-- Função para localizar uma peça física dentro do objeto
local function getBasePart(obj)
    if not obj then
        return nil
    end

    if obj:IsA("BasePart") then
        return obj
    end

    if obj:IsA("Model") then
        if obj.PrimaryPart then
            return obj.PrimaryPart
        end

        return obj:FindFirstChildWhichIsA("BasePart", true)
    end

    return obj:FindFirstChildWhichIsA("BasePart", true)
end

-- Função estrutural para mover o objeto até o personagem
local function roubarOvo(ovo)
    local player = game.Players.LocalPlayer

    if not player or not ovo then
        return
    end

    local character = player.Character

    if not character then
        return
    end

    local root = character:FindFirstChild("HumanoidRootPart")

    if not root then
        return
    end

    local part = getBasePart(ovo)

    if part then
        part.CFrame = root.CFrame
    end
end

-- ==========================================
-- ABA PRINCIPAL (AUTO FARM)
-- ==========================================

local MainTab = Window:CreateTab("Auto Farm")

-- Botão: Instant Steal
local Button1 = MainTab:CreateButton({
    Name = "Instant Steal (Roubar Todos)",

    Callback = function()
        if not EggsFolder then
            EggsFolder =
                workspace:FindFirstChild("Eggs")
                or workspace:FindFirstChild("EggSpawns")
        end

        if EggsFolder then
            local ovos = EggsFolder:GetChildren()

            for i = 1, #ovos do
                local ovo = ovos[i]

                if ovo then
                    roubarOvo(ovo)
                end

                if i % 5 == 0 then
                    task.wait()
                end
            end

            Rayfield:Notify({
                Title = "Seraphim-Hub",
                Content = "Ovos coletados!",
                Duration = 2
            })
        else
            Rayfield:Notify({
                Title = "Erro",
                Content = "Pasta de ovos não encontrada.",
                Duration = 3
            })
        end
    end,
})

-- Toggle: Auto Farm
local Toggle1 = MainTab:CreateToggle({
    Name = "Ativar Auto-Farm Eggs (Loop)",
    CurrentValue = false,
    Flag = "SeraphimAutoFarm",

    Callback = function(Value)
        _G.SeraphimFarm = Value

        if Value then
            task.spawn(function()
                while _G.SeraphimFarm do
                    task.wait(0.7)

                    if not EggsFolder then
                        EggsFolder =
                            workspace:FindFirstChild("Eggs")
                            or workspace:FindFirstChild("EggSpawns")
                    end

                    if EggsFolder then

                        -- CORREÇÃO:
                        -- Em Lua é "in pairs", não "em pairs".
                        for _, ovo in pairs(EggsFolder:GetChildren()) do
                            if ovo then
                                roubarOvo(ovo)
                                break
                            end
                        end
                    end
                end
            end)
        end
    end,
})

-- ==========================================
-- ABA SECUNDÁRIA (PLAYER MODS)
-- ==========================================

local PlayerTab = Window:CreateTab("Player Mods")

local Slider1 = PlayerTab:CreateSlider({
    Name = "Velocidade (WalkSpeed)",
    Range = {16, 150},
    Increment = 1,
    Suffix = " Studs",
    CurrentValue = 16,
    Flag = "SeraphimSpeed",

    Callback = function(Value)
        local player = game.Players.LocalPlayer

        if not player then
            return
        end

        local character = player.Character

        if not character then
            return
        end

        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end,
})

-- ==========================================
-- NOTIFICAÇÃO DE CARREGAMENTO
-- ==========================================

Rayfield:Notify({
    Title = "Seraphim-Hub Ativado",
    Content = "Menu carregado e pronto para uso!",
    Duration = 4
})



