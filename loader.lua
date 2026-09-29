-- Inicializa a biblioteca Sirius Rayfield (Tema Azul)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

-- Cria a Janela Principal
local Window = Rayfield:CreateWindow({
   Name = "💙 Seraphim-Hub | Steal an Egg 🥚",
   LoadingTitle = "Iniciando Seraphim-Hub...",
   LoadingSubtitle = "Carregando funções reais",
   ConfigurationSaving = { Enabled = true, FolderName = "SeraphimHubConfig", FileName = "StealAnEgg_Seraphim" },
   KeySystem = false 
})

-- Localiza onde os ovos ficam guardados no mapa (Padrão do jogo Steal an Egg)
local EggsFolder = workspace:FindFirstChild("Eggs") or workspace:FindFirstChild("EggSpawns")

-- Função Real para Roubar um Ovo (Traz o ovo até o jogador)
local function roubarOvo(ovo)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and ovo:IsA("BasePart") then
        -- Teleporta o ovo exatamente para a posição do jogador para coletar instantaneamente
        ovo.CFrame = player.Character.HumanoidRootPart.CFrame
    elseif player.Character and player.Character:FindFirstChild("HumanoidRootPart") and ovo:FindFirstChild("MeshPart") then
        ovo.MeshPart.CFrame = player.Character.HumanoidRootPart.CFrame
    end
end

-- ==========================================
-- ABA PRINCIPAL (AUTO FARM)
-- ==========================================
local MainTab = Window:CreateTab("Auto Farm", 4483362458)

-- Botão: Instant Steal (Puxa todos os ovos do mapa de uma vez só)
local Button1 = MainTab:CreateButton({
   Name = "Instant Steal (Roubar Todos do Mapa)",
   Callback = function()
       if EggsFolder then
           for _, ovo in pairs(EggsFolder:GetChildren()) do
               roubarOvo(ovo)
           end
           Rayfield:Notify({Title = "Seraphim-Hub", Content = "Todos os ovos foram puxados!", Duration = 2})
       else
           Rayfield:Notify({Title = "Erro", Content = "Pasta de ovos não encontrada no mapa.", Duration = 3})
       end
   end,
})

-- Alternador (Toggle): Auto Farm em Loop
local Toggle1 = MainTab:CreateToggle({
   Name = "Ativar Auto-Farm Eggs (Loop)",
   CurrentValue = false,
   Flag = "SeraphimAutoFarm",
   Callback = function(Value)
       _G.SeraphimFarm = Value
       while _G.SeraphimFarm do
           task.wait(0.5) -- Espera meio segundo entre os farms para o Roblox não crashar
           if EggsFolder then
               local ovos = EggsFolder:GetChildren()
               if #ovos > 0 then
                   -- Pega o primeiro ovo que aparecer na lista e puxa
                   roubarOvo(ovos[1])
               end
           end
       end
   end,
})

-- ==========================================
-- ABA SECUNDÁRIA (PLAYER MODS)
-- ==========================================
local PlayerTab = Window:CreateTab("Player Mods", 4483362458)

-- Slider: Velocidade com checagem de segurança (Resolve o erro do Humanoid)
local Slider1 = PlayerTab:CreateSlider({
   Name = "Velocidade (WalkSpeed)",
   Range = {16, 300},
   Increment = 1,
   Suffix = " Studs",
   CurrentValue = 16,
   Flag = "SeraphimSpeed",
   Callback = function(Value)
       local player = game.Players.LocalPlayer
       -- Só altera a velocidade se o personagem e o humanoid existirem vivos na tela
       if player.Character and player.Character:FindFirstChild("Humanoid") then
           player.Character.Humanoid.WalkSpeed = Value
       end
   end,
})

-- Notificação de Sucesso
Rayfield:Notify({
   Title = "Seraphim-Hub Ativado",
   Content = "Menu funcional e pronto para uso!",
   Duration = 5,
})
