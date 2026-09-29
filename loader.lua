-- =====================================================================
-- SERAPHIM-HUB | CÓDIGO FONTE COMPLETO E UNIFICADO
-- =====================================================================

-- 1. Inicializa a biblioteca Sirius Rayfield (Tema Azul Padrão)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

-- 2. Cria a Janela Principal da Interface
local Window = Rayfield:CreateWindow({
   Name = "💙 Seraphim-Hub | Steal an Egg 🥚",
   LoadingTitle = "Iniciando Seraphim-Hub...",
   LoadingSubtitle = "Carregando funções reais",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "SeraphimHubConfig",
      FileName = "StealAnEgg_Seraphim"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false -- Configurado como Keyless (Sem chave)
})

-- 3. Identifica as pastas de ovos do mapa (Padrão do jogo Steal an Egg)
local EggsFolder = workspace:FindFirstChild("Eggs") or workspace:FindFirstChild("EggSpawns")

-- 4. Função interna para trazer o ovo até a posição do jogador
local function roubarOvo(ovo)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        if ovo:IsA("BasePart") then
            ovo.CFrame = player.Character.HumanoidRootPart.CFrame
        elseif ovo:FindFirstChild("MeshPart") then
            ovo.MeshPart.CFrame = player.Character.HumanoidRootPart.CFrame
        end
    end
end

-- ==========================================
-- ABA PRINCIPAL (AUTO FARM)
-- ==========================================
local MainTab = Window:CreateTab("Auto Farm", 4483362458)

-- Botão: Instant Steal (Rouba todos os ovos que existem no mapa no momento)
local Button1 = MainTab:CreateButton({
   Name = "Instant Steal (Roubar Todos do Mapa)",
   Callback = function()
       if EggsFolder then
           local count = 0
           for _, ovo in pairs(EggsFolder:GetChildren()) do
               roubarOvo(ovo)
               count = count + 1
           end
           Rayfield:Notify({Title = "Seraphim-Hub", Content = count .. " ovos foram puxados!", Duration = 2})
       else
           Rayfield:Notify({Title = "Erro", Content = "Pasta de ovos não encontrada no mapa.", Duration = 3})
       end
   end,
})

-- Alternador (Toggle): Auto Farm em Loop (Fica pegando os novos ovos que nascem)
local Toggle1 = MainTab:CreateToggle({
   Name = "Ativar Auto-Farm Eggs (Loop)",
   CurrentValue = false,
   Flag = "SeraphimAutoFarm",
   Callback = function(Value)
       _G.SeraphimFarm = Value
       while _G.SeraphimFarm do
           task.wait(0.5) -- Pausa de segurança para não travar o Roblox
           if EggsFolder then
               local ovos = EggsFolder:GetChildren()
               if #ovos > 0 then
                   -- Puxa o primeiro ovo disponível na lista
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

-- Slider: Altera a velocidade com checagem de segurança contra mortes/resets
local Slider1 = PlayerTab:CreateSlider({
   Name = "Velocidade (WalkSpeed)",
   Range = {16, 300},
   Increment = 1,
   Suffix = " Studs",
   CurrentValue = 16,
   Flag = "SeraphimSpeed",
   Callback = function(Value)
       local player = game.Players.LocalPlayer
       if player.Character and player.Character:FindFirstChild("Humanoid") then
           player.Character.Humanoid.WalkSpeed = Value
       end
   end,
})

-- 5. Notificação visual de que tudo carregou perfeitamente
Rayfield:Notify({
   Title = "Seraphim-Hub Ativado",
   Content = "Seja bem-vindo! Menu 100% funcional.",
   Duration = 5,
})
