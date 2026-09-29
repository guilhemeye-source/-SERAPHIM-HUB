--// 🪽 Seraphim-Hub | PARA BOTS + AUTO ROUBO

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

--==================================================
-- CONFIGURAÇÃO
--==================================================

local IMAGE_ID = "rbxassetid://97885929587100"
local AUTO_ROUBO_SPEED = 100

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SeraphimHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

--==================================================
-- PAINEL
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(260, 200)
Main.Position = UDim2.new(0.5, -130, 0.5, -100)
Main.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 120, 255)
Stroke.Thickness = 1
Stroke.Parent = Main

--==================================================
-- TOPO
--==================================================

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 38)
Top.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
Top.BorderSizePixel = 0
Top.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = Top

--==================================================
-- IMAGEM
--==================================================

local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.fromOffset(28, 28)
Logo.Position = UDim2.fromOffset(7, 5)
Logo.BackgroundTransparency = 1
Logo.Image = IMAGE_ID
Logo.ScaleType = Enum.ScaleType.Fit
Logo.Parent = Top

--==================================================
-- TÍTULO
--==================================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -75, 1, 0)
Title.Position = UDim2.fromOffset(42, 0)
Title.BackgroundTransparency = 1
Title.Text = "Seraphim-Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

--==================================================
-- FECHAR
--==================================================

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "Close"
CloseButton.Size = UDim2.fromOffset(27, 27)
CloseButton.Position = UDim2.new(1, -32, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(35, 40, 52)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Top

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 7)
CloseCorner.Parent = CloseButton

--==================================================
-- STATUS
--==================================================

local Status = Instance.new("TextLabel")
Status.Name = "Status"
Status.Size = UDim2.new(1, -20, 0, 20)
Status.Position = UDim2.fromOffset(10, 174)
Status.BackgroundTransparency = 1
Status.Text = "Conectado"
Status.TextColor3 = Color3.fromRGB(80, 220, 130)
Status.TextSize = 11
Status.Font = Enum.Font.Gotham
Status.Parent = Main

--==================================================
-- FUNÇÃO: ENCONTRAR BASE
--==================================================

local function FindBaseSpawn()

    local Base = workspace:FindFirstChild("Base", true)

    if Base then

        if Base:IsA("SpawnLocation") then
            return Base
        end

        if Base:IsA("Model") then

            local Spawn = Base:FindFirstChildWhichIsA(
                "SpawnLocation",
                true
            )

            if Spawn then
                return Spawn
            end

        end

        if Base:IsA("BasePart") then
            return Base
        end

    end

    local Spawns = {}

    for _, Obj in ipairs(workspace:GetDescendants()) do

        if Obj:IsA("SpawnLocation") then
            table.insert(Spawns, Obj)
        end

    end

    if #Spawns == 1 then
        return Spawns[1]
    end

    for _, Spawn in ipairs(Spawns) do

        local Nome = string.lower(Spawn.Name)

        if Nome:find("base")
        or Nome:find("spawn")
        or Nome:find("home") then

            return Spawn

        end

    end

    warn("Seraphim-Hub: Ponto da Base não encontrado!")

    return nil
end

--==================================================
-- TELEPORTE
--==================================================

local function TeleportToBase()

    local Point = FindBaseSpawn()
    if not Point then return end

    local Character = Player.Character
    if not Character then return end

    local Root = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChild("Humanoid")

    if not Root or not Humanoid then return end

    Humanoid:SetStateEnabled(
        Enum.HumanoidStateType.Running,
        false
    )

    Humanoid:SetStateEnabled(
        Enum.HumanoidStateType.FallingDown,
        false
    )

    Humanoid.PlatformStand = true

    local NovaPosicao =
        Point.CFrame + Vector3.new(0, 4, 0)

    Root.CFrame = NovaPosicao

    task.wait()

    Root.CFrame = NovaPosicao

    task.wait(0.15)

    if Humanoid then

        Humanoid:SetStateEnabled(
            Enum.HumanoidStateType.Running,
            true
        )

        Humanoid.PlatformStand = false

    end

    print("Seraphim-Hub: PARA BOTS — Teleportado ✅")
end

--==================================================
-- AUTO ROUBO
--==================================================

local AutoRouboRunning = false

local function AutoRoubo()

    if AutoRouboRunning then
        return
    end

    local Point = FindBaseSpawn()

    if not Point then
        return
    end

    local Character = Player.Character

    if not Character then
        return
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local Root = Character:FindFirstChild("HumanoidRootPart")

    if not Humanoid or not Root then
        return
    end

    AutoRouboRunning = true

    local OldSpeed = Humanoid.WalkSpeed

    -- Velocidade temporariamente alta
    Humanoid.WalkSpeed = AUTO_ROUBO_SPEED

    local Target = Point.Position + Vector3.new(0, 4, 0)

    Humanoid:MoveTo(Target)

    -- Continua mandando andar até chegar
    while AutoRouboRunning and Character.Parent do

        Root = Character:FindFirstChild("HumanoidRootPart")
        Humanoid = Character:FindFirstChildOfClass("Humanoid")

        if not Root or not Humanoid then
            break
        end

        local Distance = (Root.Position - Target).Magnitude

        if Distance <= 5 then
            break
        end

        Humanoid:MoveTo(Target)

        task.wait(0.05)
    end

    if Humanoid and Humanoid.Parent then
        Humanoid.WalkSpeed = OldSpeed
    end

    AutoRouboRunning = false

    print("Seraphim-Hub: AUTO ROUBO finalizado.")
end

--==================================================
-- BOTÃO PARA BOTS
--==================================================

local BostButton = Instance.new("TextButton")
BostButton.Name = "ParaBots"
BostButton.Size = UDim2.new(1, -20, 0, 45)
BostButton.Position = UDim2.fromOffset(10, 50)
BostButton.BackgroundColor3 = Color3.fromRGB(0, 100, 210)
BostButton.BorderSizePixel = 0
BostButton.Text = "📶 PARA BOTS"
BostButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BostButton.TextSize = 15
BostButton.Font = Enum.Font.GothamBold
BostButton.Parent = Main

local BostCorner = Instance.new("UICorner")
BostCorner.CornerRadius = UDim.new(0, 8)
BostCorner.Parent = BostButton

BostButton.MouseButton1Click:Connect(function()
    TeleportToBase()
end)

--==================================================
-- BOTÃO AUTO ROUBO
--==================================================

local AutoRouboButton = Instance.new("TextButton")
AutoRouboButton.Name = "AutoRoubo"
AutoRouboButton.Size = UDim2.new(1, -20, 0, 45)
AutoRouboButton.Position = UDim2.fromOffset(10, 102)
AutoRouboButton.BackgroundColor3 = Color3.fromRGB(0, 80, 170)
AutoRouboButton.BorderSizePixel = 0
AutoRouboButton.Text = "🏃 AUTO ROUBO"
AutoRouboButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoRouboButton.TextSize = 15
AutoRouboButton.Font = Enum.Font.GothamBold
AutoRouboButton.Parent = Main

local AutoRouboCorner = Instance.new("UICorner")
AutoRouboCorner.CornerRadius = UDim.new(0, 8)
AutoRouboCorner.Parent = AutoRouboButton

AutoRouboButton.MouseButton1Click:Connect(function()
    AutoRoubo()
end)

--==================================================
-- BOTÃO REABRIR
--==================================================

local OpenButton = Instance.new("ImageButton")
OpenButton.Name = "Reabrir"
OpenButton.Size = UDim2.fromOffset(58, 58)
OpenButton.Position = UDim2.fromOffset(18, 200)
OpenButton.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
OpenButton.BorderSizePixel = 0
OpenButton.Image = IMAGE_ID
OpenButton.ScaleType = Enum.ScaleType.Fit
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(0, 120, 255)
OpenStroke.Thickness = 1
OpenStroke.Parent = OpenButton

--==================================================
-- ABRIR / FECHAR
--==================================================

CloseButton.MouseButton1Click:Connect(function()

    Main.Visible = false
    OpenButton.Visible = true

end)

OpenButton.MouseButton1Click:Connect(function()

    Main.Visible = true
    OpenButton.Visible = false

end)

--==================================================
-- ARRASTAR
--==================================================

local Dragging = false
local DragStart
local StartPos

Top.InputBegan:Connect(function(Input)

    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = Input.Position
        StartPos = Main.Position

        Input.Changed:Connect(function()

            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end

        end)

    end

end)

UserInputService.InputChanged:Connect(function(Input)

    if not Dragging then
        return
    end

    if Input.UserInputType == Enum.UserInputType.MouseMovement
    or Input.UserInputType == Enum.UserInputType.Touch then

        local Delta = Input.Position - DragStart

        Main.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + Delta.Y
        )

    end

end)

--==================================================
-- INÍCIO
--==================================================

print("🪽 Seraphim-Hub carregado!")
print("📶 PARA BOTS disponível.")
print("🏃 AUTO ROUBO disponível.")
