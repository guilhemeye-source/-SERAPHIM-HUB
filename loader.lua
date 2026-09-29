-- ============================================================
-- 💙 SERAPHIM-HUB | DIAGNÓSTICO
-- ============================================================

print("SERAPHIM-HUB: iniciando...")

-- ============================================================
-- CARREGAMENTO DO RAYFIELD
-- ============================================================

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu"))()
end)

if not success or not Rayfield then
    warn("SERAPHIM-HUB: não foi possível carregar o Rayfield.")
    warn("Erro:", Rayfield)
    return
end

print("SERAPHIM-HUB: Rayfield carregado.")

-- ============================================================
-- JANELA
-- ============================================================

local Window

local windowSuccess, windowError = pcall(function()
    Window = Rayfield:CreateWindow({
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
end)

if not windowSuccess or not Window then
    warn("SERAPHIM-HUB: erro ao criar a janela.")
    warn("Erro:", windowError)
    return
end

print("SERAPHIM-HUB: janela criada.")

-- ============================================================
-- ABA PRINCIPAL
-- ============================================================

local MainTab = Window:CreateTab("Auto Farm")

print("SERAPHIM-HUB: aba Auto Farm criada.")

-- Botão
MainTab:CreateButton({
    Name = "Instant Steal (Roubar Todos)",

    Callback = function()
        Rayfield:Notify({
            Title = "Seraphim-Hub",
            Content = "Botão funcionando corretamente!",
            Duration = 3
        })

        print("SERAPHIM-HUB: botão pressionado.")
    end
})

-- Toggle
MainTab:CreateToggle({
    Name = "Ativar Auto-Farm Eggs (Loop)",
    CurrentValue = false,
    Flag = "SeraphimAutoFarm",

    Callback = function(Value)
        print("SERAPHIM-HUB: Auto-Farm =", Value)

        Rayfield:Notify({
            Title = "Seraphim-Hub",
            Content = Value and "Auto-Farm ativado." or "Auto-Farm desativado.",
            Duration = 2
        })
    end
})

-- ============================================================
-- ABA PLAYER MODS
-- ============================================================

local PlayerTab = Window:CreateTab("Player Mods")

print("SERAPHIM-HUB: aba Player Mods criada.")

-- Slider
PlayerTab:CreateSlider({
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
            print("SERAPHIM-HUB: velocidade =", Value)
        end
    end
})

-- ============================================================
-- FINAL
-- ============================================================

Rayfield:Notify({
    Title = "Seraphim-Hub",
    Content = "Menu carregado com sucesso!",
    Duration = 5
})

print("================================")
print("SERAPHIM-HUB: CARREGADO")
print("================================")



