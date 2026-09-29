--// 🪽 Seraphim-Hub | PARA BOTS
--// Tela preta por 2s ao teleportar

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SeraphimHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- TELA PRETA
local TelaPreta = Instance.new("Frame")
TelaPreta.Name = "TelaPreta"
TelaPreta.Size = UDim2.new(1, 0, 1, 0)
TelaPreta.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TelaPreta.Visible = false
TelaPreta.ZIndex = 999
TelaPreta.Parent = ScreenGui

-- Janela
local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(280, 140)
Main.Position = UDim2.new(0.5, -140, 0.5, -70)
Main.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 120, 255)

-- Topo
local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 38)
Top.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
Top.Parent = Main
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.fromOffset(10, 0)
Title.BackgroundTransparency = 1
Title.Text = "🪽 Seraphim-Hub"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

-- Botão PARA BOTS
local Botao = Instance.new("TextButton")
Botao.Size = UDim2.new(1, -20, 0, 45)
Botao.Position = UDim2.fromOffset(10, 50)
Botao.BackgroundColor3 = Color3.fromRGB(135, 206, 235) -- Azul bebê
Botao.Text = "📶 PARA BOTS"
Botao.TextColor3 = Color3.fromRGB(255,255,255)
Botao.TextSize = 15
Botao.Font = Enum.Font.GothamBold
Botao.Parent = Main
Instance.new("UICorner", Botao).CornerRadius = UDim.new(0, 8)

-- Encontrar Base
local function GetBase()
    local Base = workspace:FindFirstChild("Base", true)
    if Base then
        if Base:IsA("SpawnLocation") then return Base end
        local Spawn = Base:FindFirstChildWhichIsA("SpawnLocation", true)
        if Spawn then return Spawn end
        if Base:IsA("BasePart") then return Base end
    end
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("SpawnLocation") then return v end
    end
    return nil
end

-- Teleportar + Tela Preta 2s
local function Teleport()
    local Base = GetBase()
    if not Base then return end

    -- Mostra tela preta
    TelaPreta.Visible = true

    -- Teleporta
    local Char = Player.Character
    if Char then
        local Root = Char:FindFirstChild("HumanoidRootPart")
        if Root then
            Root.CFrame = Base.CFrame + Vector3.new(0, 3, 0)
        end
    end

    -- Espera 2 segundos e tira a tela preta
    task.wait(2)
    TelaPreta.Visible = false
end

Botao.MouseButton1Click:Connect(Teleport)

print("🪽 Seraphim-Hub pronto! ✅")
