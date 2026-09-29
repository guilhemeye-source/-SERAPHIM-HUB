-- Carrega a biblioteca de UI Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu"))()

-- Cria a janela principal
local Window = Rayfield:CreateWindow({
    Name = "✨ SERAPHIM | Blue Edition",
    LoadingTitle = "Carregando Seraphim...",
    LoadingSubtitle = "by Seraphim Team",

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SeraphimConfig",
        FileName = "Config"
    },

    Discord = {
        Enabled = true,
        Invite = "C6Tm4fVKAR",
        RememberJoins = true
    },

    KeySystem = false,
    Theme = "Default"
})

-- TAB 1: Funções Principais
local MainTab = Window:CreateTab("Principal ⚡", 4483362458)

local ToggleAutoFarm = MainTab:CreateToggle({
    Name = "Auto Roubar / Auto Farm",
    CurrentValue = false,
    Flag = "ToggleFarm",

    Callback = function(Value)
        _G.AutoFarm = Value

        if Value then
            task.spawn(function()
                while _G.AutoFarm do
                    task.wait(0.1)
                    print("Seraphim: função ativada...")
                end
            end)
        end
    end,
})

local ToggleAntiHit = MainTab:CreateToggle({
    Name = "Anti-Hit / Bypass Guardas",
    CurrentValue = false,
    Flag = "ToggleAntiHit",

    Callback = function(Value)
        _G.AntiHit = Value
        print("Anti-Hit alternado:", Value)
    end,
})

-- TAB 2: Configurações do Personagem
local PlayerTab = Window:CreateTab("Jogador 👤", 4483362458)

local SliderSpeed = PlayerTab:CreateSlider({
    Name = "Velocidade de Movimento (Speed)",
    Range = {16, 200},
    Increment = 1,
    Suffix = " Speed",
    CurrentValue = 16,
    Flag = "SliderSpeed",

    Callback = function(Value)
        local Player = game:GetService("Players").LocalPlayer
        local Character = Player.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end,
})

-- TAB 3: Status / Alvos
local InfoTab = Window:CreateTab("Status / Alvos 📊", 4483362458)

local DropdownAlvos = InfoTab:CreateDropdown({
    Name = "Selecionar Alvo Raro",

    Options = {
        "Ovo Comum (R$ 10)",
        "Ovo Raro (R$ 50)",
        "Ovo Lendário (R$ 250)",
        "Ovo Mítico (R$ 1000)"
    },

    CurrentOption = {"Ovo Comum (R$ 10)"},
    MultipleOptions = false,
    Flag = "DropdownAlvos",

    Callback = function(Option)
        print("Alvo selecionado no Seraphim:", Option)
    end,
})

-- Botões de Controle
local LabelInfo = MainTab:CreateLabel("Controles Rápidos:")

local ButtonStart = MainTab:CreateButton({
    Name = "INICIAR SCRIPT (START)",

    Callback = function()
        Rayfield:Notify({
            Title = "Seraphim Blue",
            Content = "Script iniciado com sucesso!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

local ButtonStop = MainTab:CreateButton({
    Name = "PARAR TUDO (STOP)",

    Callback = function()
        _G.AutoFarm = false
        _G.AntiHit = false

        ToggleAutoFarm:Set(false)
        ToggleAntiHit:Set(false)

        Rayfield:Notify({
            Title = "Seraphim Blue",
            Content = "Todas as funções foram paradas.",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})



A correção mais importante: removi o CustomTheme, que era um dos pontos mais prováveis de incompatibilidade, e corrigi o CreateSlider para o formato usado pelas versões atuais do Rayfield.


