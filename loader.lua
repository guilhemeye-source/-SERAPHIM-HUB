-- =====================================================================
-- SERAPHIM-HUB | CÓDIGO CORRIGIDO
-- =====================================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

local Window = Rayfield:CreateWindow({
   Name = "💙 Seraphim-Hub | Steal an Egg 🥚",
   LoadingTitle = "Iniciando Seraphim-Hub...",
   LoadingSubtitle = "Carregando funções reais",
   ConfigurationSaving = { Enabled = true, FolderName = "SeraphimHubConfig", FileName = "StealAnEgg_Seraphim" },
   KeySystem = false 
})

-- Identifica a pasta de ovos do mapa
local EggsFolder = workspace:FindFirstChild("Eggs") or workspace:FindFirstChild("EggSpawns")

-- Função para trazer o ovo até o jogador
local function roubarOvo(ovo)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and ovo then
        if ovo:IsA("BasePart") then
            ovo.CFrame = player.Character.HumanoidRootPart.CFrame
        elseif ovo:FindFirstChild("MeshPart") then
            ovo.MeshPart.CFrame = player.Character.HumanoidRootPart.CFrame
        elseif ovo:FindFirstChildOfClass("BasePart") then
            ovo:FindFirstChildOfClass("BasePart").CFrame = player.Character.HumanoidRootPart.CFrame
        end
    end
end

-- ABA PRINCIPAL (AUTO FARM)
local MainTab = Window:CreateTab("Auto Farm", 4483362458)

local Button1 = MainTab:CreateButton({
   Name = "Instant Steal (Roubar Todos do Mapa)",
   Callback = function()
       if EggsFolder then
           local ovos = EggsFolder:GetChildren()
           for i = 1, #ovos do
               roubarOvo(ovos[i])
           end
           Rayfield:Notify({Title = "Seraphim-Hub", Content = "Ovos puxados!", Duration = 2})
       else
           Rayfield:Notify({Title = "Erro", Content = "Pasta de ovos não encontrada.", Duration = 3})
       end
   end,
})

local Toggle1 = MainTab:CreateToggle({
   Name = "Ativar Auto-Farm Eggs (Loop)",
   CurrentValue = false,
   Flag = "SeraphimAutoFarm",
   Callback = function(Value)
       _G.SeraphimFarm = Value
       while _G.SeraphimFarm do
           task.wait(0.5)
           if EggsFolder then
               local ovos = EggsFolder:GetChildren()
               if #ovos > 0 then
                   -- CORRIGIDO: Pega o primeiro ovo da lista [1] de forma individual
                   roubarOvo(ovos[1])
               end
           end
       end
   end,
})

-- ABA SECUNDÁRIA (PLAYER MODS)
local PlayerTab = Window:CreateTab("Player Mods", 4483362458)

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

Rayfield:Notify({ Title = "Seraphim-Hub Ativado", Content = "Menu pronto!", Duration = 5 })
