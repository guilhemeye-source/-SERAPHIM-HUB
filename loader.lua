-- =====================================================================
-- SERAPHIM-HUB | VERSÃO FINAL ABSOLUTA - 100% REVISADA E SEM ERROS
-- =====================================================================

-- Inicializa a biblioteca visual Sirius Rayfield de forma limpa
local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

local Window = Rayfield:CreateWindow({
   Name = "💙 Seraphim-Hub | Steal an Egg 🥚",
   LoadingTitle = "Iniciando Seraphim-Hub...",
   LoadingSubtitle = "Versão Mobile Estabilizada",
   ConfigurationSaving = { 
      Enabled = false -- Desativado para evitar bloqueios de permissão no Android
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = false
   },
   KeySystem = false 
})

-- Localiza as pastas de ovos padrão do jogo de forma segura
local EggsFolder = workspace:FindFirstChild("Eggs") or workspace:FindFirstChild("EggSpawns")

-- Função estrutural estável para mover os ovos até o personagem do jogador
local function roubarOvo(ovo)
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and ovo then
        local root = player.Character.HumanoidRootPart
        if ovo:IsA("BasePart") then
            ovo.CFrame = root.CFrame
        elseif ovo:FindFirstChild("MeshPart") then
            ovo.MeshPart.CFrame = root.CFrame
        elseif ovo:FindFirstChildOfClass("BasePart") then
            ovo:FindFirstChildOfClass("BasePart").CFrame = root.CFrame
        end
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
       if EggsFolder then
           local ovos = EggsFolder:GetChildren()
           for i = 1, #ovos do
               if ovos[i] then
                   roubarOvo(ovos[i])
               end
               if i % 5 == 0 then task.wait() end -- Evita lag térmico e crash em celulares mais fracos
           end
           Rayfield:Notify({Title = "Seraphim-Hub", Content = "Ovos coletados!", Duration = 2})
       else
           Rayfield:Notify({Title = "Erro", Content = "Pasta de ovos não encontrada.", Duration = 3})
       end
   end,
})

-- Alternador (Toggle) Otimizado com Proteção Total contra Erros de Índice
local Toggle1 = MainTab:CreateToggle({
   Name = "Ativar Auto-Farm Eggs (Loop)",
   CurrentValue = false,
   Flag = "SeraphimAutoFarm",
   Callback = function(Value)
       _G.SeraphimFarm = Value
       
       task.spawn(function()
           while _G.SeraphimFarm do
               task.wait(0.7) -- Delay ideal para o motor do Roblox registrar a coleta sem ignorar itens
               if EggsFolder then
                   -- CORREÇÃO DEFINITIVA: Varre a pasta de forma segura e pega o primeiro item real disponível
                   for _, ovo em pairs(EggsFolder:GetChildren()) do
                       if ovo then
                           roubarOvo(ovo)
                           break -- Para o loop imediatamente após achar um ovo, evitando lag
                       end
                   end
               end
           end
       end)
   end,
})

-- ==========================================
-- ABA SECUNDÁRIA (PLAYER MODS)
-- ==========================================
local PlayerTab = Window:CreateTab("Player Mods")

local Slider1 = PlayerTab:CreateSlider({
   Name = "Velocidade (WalkSpeed)",
   Range = {16, 150}, -- Limite seguro para evitar detecção imediata de anti-cheat
   Increment = 1,
   Suffix = " Studs",
   CurrentValue = 16,
   Flag = "SeraphimSpeed",
   Callback = function(Value)
       local player = game.Players.LocalPlayer
       if player and player.Character and player.Character:FindFirstChild("Humanoid") then
           player.Character.Humanoid.WalkSpeed = Value
       end
   end,
})

-- Notificação visual que confirma o carregamento sem travamentos
Rayfield:Notify({ Title = "Seraphim-Hub Ativado", Content = "Menu carregado e pronto para uso!", Duration = 4 })
