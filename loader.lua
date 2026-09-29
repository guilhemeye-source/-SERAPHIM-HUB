local Fluent = loadstring(game:HttpGet("https://github.com"))()

-- Configuração da Janela Principal (Tema Azul)
local Window = Fluent:CreateWindow({
    Title = "Seraphim-Hub",
    SubTitle = "by Delta User",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, 
    Theme = "Dark", -- Base escura para destacar o azul
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Modifica as cores da interface nativamente para Azul
Fluent.Options = {
    AccentColor = Color3.fromRGB(0, 120, 255), -- Azul Seraphim
    MainColor = Color3.fromRGB(15, 15, 20),
    TextColor = Color3.fromRGB(255, 255, 255)
}

-- Criando as Abas do Menu
local Tabs = {
    Main = Window:AddTab({ Title = "Automação", Icon = "rbxassetid://4483345998" }),
    Teleport = Window:AddTab({ Title = "Teleportes", Icon = "rbxassetid://4483345998" })
}

local Options = Fluent.Options

-- ========================================================
-- ABA 1: AUTOMAÇÃO (Exemplo de Auto Farm / Auto Click)
-- ========================================================

local AutoFarmToggle = Tabs.Main:AddToggle("AutoFarm", {Title = "Ativar Auto Farm", Default = false })

-- Loop que roda em segundo plano enquanto o botão estiver ativo
task.spawn(function()
    while true do
        task.wait(0.1) -- Evita travar o jogo
        if AutoFarmToggle.Value then
            -- [COLOQUE AQUI A LÓGICA DE AUTO FARM DO JOGO QUE VOCÊ QUER]
            -- Exemplo genérico de clicar/atacar automaticamente:
            local virtualUser = game:GetService("VirtualUser")
            virtualUser:CaptureController()
            virtualUser:ClickButton1(Vector2.new(0, 0))
        end
    end
end)

-- Slider para ajustar a velocidade do jogador (WalkSpeed)
local SpeedSlider = Tabs.Main:AddSlider("Speed", {
    Title = "Velocidade do Personagem",
    Description = "Altera a velocidade de corrida",
    Default = 16,
    Min = 16,
    Max = 150,
    Rounding = 0,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})


-- ========================================================
-- ABA 2: TELEPORTES
-- ========================================================

Tabs.Teleport:AddButton({
    Title = "Teleportar para o Topo/Base",
    Description = "Leva seu personagem para coordenadas seguras",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Altere os números (0, 100, 0) para a posição X, Y, Z desejada do mapa
            player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
            Fluent:Notify({
                Title = "Seraphim-Hub",
                Content = "Teleportado com sucesso!",
                Duration = 3
            })
        end
    end
})

-- Notificação Inicial ao executar
Window:SelectTab(1)
Fluent:Notify({
    Title = "Seraphim-Hub",
    Content = "Script carregado com sucesso no Delta!",
    Duration = 5
})
