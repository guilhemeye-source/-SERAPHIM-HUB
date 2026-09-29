--// 🪽 Seraphim-Hub | PARA BOTS
--// Auto Roubo 500 + STOP

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local IMAGE_ID = "rbxassetid://97885929587100"

-- VELOCIDADE DO AUTO ROUBO
local AUTO_ROUBO_SPEED = 500

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SeraphimHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

--==================================================
-- PAINEL
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(270, 255)
Main.Position = UDim2.new(0.5, -135, 0.5, -127)
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
Top.Size = UDim2.new(1, 0, 0, 42)
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
Logo.Size = UDim2.fromOffset(30, 30)
Logo.Position = UDim2.fromOffset(7, 6)
Logo.BackgroundTransparency = 1
Logo.Image = IMAGE_ID
Logo.Parent = Top

--==================================================
-- TITULO
--==================================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.fromOffset(44, 0)
Title.BackgroundTransparency = 1
Title.Text = "🪽 Seraphim-Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

--==================================================
-- FECHAR
--==================================================

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(28, 28)
CloseButton.Position = UDim2.new(1, -34, 0, 7)
CloseButton.BackgroundColor3 = Color3.fromRGB(35, 40, 52)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Top

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 7)
CloseCorner.Parent = CloseButton

--==================================================
-- ENCONTRAR BASE
--==================================================

local function FindBaseSpawn()

    local Base = workspace:FindFirstChild("Base", true)

    if Base then

        if Base:IsA("SpawnLocation") then
            return Base
        end

        if Base:IsA("Model") then
            local Spawn =
                Base:FindFirstChildWhichIsA(
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
-- TELEPORTE PARA BASE
--==================================================

local function TeleportToBase()

    local Point = FindBaseSpawn()

    if not Point then
        return
    end

    local Character = Player.Character

    if not Character then
        return
    end

    local Root =
        Character:FindFirstChild("HumanoidRootPart")

    local Humanoid =
        Character:FindFirstChild("Humanoid")

    if not Root or not Humanoid then
        return
    end

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
end

--==================================================
-- AUTO ROUBO
--==================================================

local AutoRouboRunning = false

local function AutoRoubo()

    if AutoRouboRunning then
        return
    end

    AutoRouboRunning = true

    local Point = FindBaseSpawn()

    if not Point then
        AutoRouboRunning = false
        return
    end

    local Character = Player.Character

    if not Character then
        AutoRouboRunning = false
        return
    end

    local Root =
        Character:FindFirstChild("HumanoidRootPart")

    local Humanoid =
        Character:FindFirstChild("Humanoid")

    if not Root or not Humanoid then
        AutoRouboRunning = false
        return
    end

    local Target =
        Point.Position + Vector3.new(0, 4, 0)

    while AutoRouboRunning
    and Character
    and Root
    and Humanoid
    and Humanoid.Health > 0 do

        local Distance =
            (Target - Root.Position).Magnitude

        if Distance <= 6 then
            break
        end

        local Direction =
            (Target - Root.Position).Unit

        Root.AssemblyLinearVelocity =
            Direction * AUTO_ROUBO_SPEED

        task.wait()
    end

    if Root then
        Root.AssemblyLinearVelocity = Vector3.zero
    end

    AutoRouboRunning = false
end

--==================================================
-- STOP
--==================================================

local function StopAutoRoubo()

    AutoRouboRunning = false

    local Character = Player.Character

    if not Character then
        return
    end

    local Root =
        Character:FindFirstChild("HumanoidRootPart")

    if Root then
        Root.AssemblyLinearVelocity = Vector3.zero
    end
end

--==================================================
-- BOTÃO PARA BOTS
--==================================================

local BostButton = Instance.new("TextButton")
BostButton.Size = UDim2.new(1, -20, 0, 42)
BostButton.Position = UDim2.fromOffset(10, 52)
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
-- AUTO ROUBO
--==================================================

local AutoButton = Instance.new("TextButton")
AutoButton.Size = UDim2.new(1, -20, 0, 42)
AutoButton.Position = UDim2.fromOffset(10, 101)
AutoButton.BackgroundColor3 = Color3.fromRGB(0, 145, 90)
AutoButton.BorderSizePixel = 0
AutoButton.Text = "🏃 AUTO ROUBO"
AutoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoButton.TextSize = 15
AutoButton.Font = Enum.Font.GothamBold
AutoButton.Parent = Main

local AutoCorner = Instance.new("UICorner")
AutoCorner.CornerRadius = UDim.new(0, 8)
AutoCorner.Parent = AutoButton

AutoButton.MouseButton1Click:Connect(function()
    task.spawn(AutoRoubo)
end)

--==================================================
-- STOP
--==================================================

local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(1, -20, 0, 42)
StopButton.Position = UDim2.fromOffset(10, 150)
StopButton.BackgroundColor3 = Color3.fromRGB(190, 45, 55)
StopButton.BorderSizePixel = 0
StopButton.Text = "⛔ STOP"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.TextSize = 15
StopButton.Font = Enum.Font.GothamBold
StopButton.Parent = Main

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 8)
StopCorner.Parent = StopButton

StopButton.MouseButton1Click:Connect(function()
    StopAutoRoubo()
end)

--==================================================
-- STATUS
--==================================================

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 30)
Status.Position = UDim2.fromOffset(10, 200)
Status.BackgroundTransparency = 1
Status.Text = "Conectado"
Status.TextColor3 = Color3.fromRGB(50, 220, 120)
Status.TextSize = 13
Status.Font = Enum.Font.GothamBold
Status.Parent = Main

--==================================================
-- BOTÃO REABRIR
--==================================================

local OpenButton = Instance.new("ImageButton")
OpenButton.Name = "Reabrir"
OpenButton.Size = UDim2.fromOffset(60, 60)
OpenButton.Position = UDim2.fromOffset(18, 200)
OpenButton.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
OpenButton.BorderSizePixel = 0
OpenButton.Image = IMAGE_ID
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
-- ARRASTAR PAINEL
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

            if Input.UserInputState ==
                Enum.UserInputState.End then

                Dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(Input)

    if not Dragging then
        return
    end

    if Input.UserInputType ==
        Enum.UserInputType.MouseMovement
    or Input.UserInputType ==
        Enum.UserInputType.Touch then

        local Delta =
            Input.Position - DragStart

        Main.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + Delta.X,

            StartPos.Y.Scale,
            StartPos.Y.Offset + Delta.Y
        )
    end
end)

print("🪽 Seraphim-Hub carregado!")
print("🏃 AUTO ROUBO: 500")
print("⛔ STOP: ativado")
