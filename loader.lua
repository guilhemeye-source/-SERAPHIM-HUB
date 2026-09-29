--// 🪽 SERAPHIM HUB

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local IMAGE_ID = "rbxassetid://97885929587100"
local AUTO_ROUBO_SPEED = 750

--==================================================
-- ENCONTRAR BASE
--==================================================

local function FindBaseSpawn()

    local Base = workspace:FindFirstChild("Base", true)

    if Base then

        if Base:IsA("SpawnLocation") then
            return Base
        end

        local Spawn = Base:FindFirstChildWhichIsA(
            "SpawnLocation",
            true
        )

        if Spawn then
            return Spawn
        end

        if Base:IsA("BasePart") then
            return Base
        end
    end

    for _, Obj in ipairs(workspace:GetDescendants()) do

        if Obj:IsA("SpawnLocation") then

            local Name = string.lower(Obj.Name)

            if Name:find("base")
            or Name:find("spawn")
            or Name:find("home") then

                return Obj
            end
        end
    end

    return nil
end

--==================================================
-- 📶 PARA BOTS
--==================================================

local function TeleportParaBots()

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

    if not Root then
        return
    end

    local PosicaoOriginal = Root.CFrame

    Root.CFrame =
        Point.CFrame + Vector3.new(0, 4, 0)

    task.wait(0.5)

    if Root and Root.Parent then
        Root.CFrame = PosicaoOriginal
    end
end

--==================================================
-- 🏃 AUTO ROUBO / FLY
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
        Point.Position + Vector3.new(0, 5, 0)

    while AutoRouboRunning
    and Character.Parent
    and Root.Parent
    and Humanoid.Health > 0 do

        local Distance =
            (Target - Root.Position).Magnitude

        if Distance <= 5 then
            break
        end

        local Direction =
            (Target - Root.Position).Unit

        local DeltaTime =
            RunService.Heartbeat:Wait()

        local Step =
            AUTO_ROUBO_SPEED * DeltaTime

        local NewPosition =
            Root.Position + Direction * Step

        Root.CFrame =
            CFrame.lookAt(
                NewPosition,
                Target
            )
    end

    AutoRouboRunning = false
end

--==================================================
-- ⛔ STOP
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
        Root.AssemblyAngularVelocity = Vector3.zero
    end
end

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
Main.Size = UDim2.fromOffset(250, 230)
Main.Position = UDim2.new(0.5, -125, 0.5, -115)
Main.BackgroundColor3 = Color3.fromRGB(24, 27, 34)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = Main

--==================================================
-- TOPO
--==================================================

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 40)
Top.BackgroundColor3 = Color3.fromRGB(30, 34, 43)
Top.BorderSizePixel = 0
Top.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = Top

--==================================================
-- LOGO
--==================================================

local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.fromOffset(27, 27)
Logo.Position = UDim2.fromOffset(8, 6)
Logo.BackgroundTransparency = 1
Logo.Image = IMAGE_ID
Logo.Parent = Top

--==================================================
-- TÍTULO
--==================================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -75, 1, 0)
Title.Position = UDim2.fromOffset(43, 0)
Title.BackgroundTransparency = 1
Title.Text = "Seraphim-Hub"
Title.TextColor3 = Color3.fromRGB(235, 235, 235)
Title.TextSize = 14
Title.Font = Enum.Font.GothamMedium
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

--==================================================
-- FECHAR
--==================================================

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(30, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.BackgroundTransparency = 1
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(210, 210, 210)
Close.TextSize = 20
Close.Font = Enum.Font.Gotham
Close.Parent = Top

--==================================================
-- CRIAR BOTÕES
--==================================================

local function CreateButton(Text, Position, Background)

    local Button = Instance.new("TextButton")

    Button.Size = UDim2.new(1, -20, 0, 40)
    Button.Position = Position
    Button.BackgroundColor3 = Background
    Button.BorderSizePixel = 0
    Button.Text = Text
    Button.TextColor3 = Color3.fromRGB(245, 245, 245)
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamMedium
    Button.AutoButtonColor = true
    Button.Parent = Main

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button

    return Button
end

--==================================================
-- BOTÕES
--==================================================

local ParaBots = CreateButton(
    "📶 PARA BOTS",
    UDim2.fromOffset(10, 50),
    Color3.fromRGB(45, 105, 180)
)

local Auto = CreateButton(
    "🏃 AUTO ROUBO",
    UDim2.fromOffset(10, 96),
    Color3.fromRGB(45, 135, 90)
)

local Stop = CreateButton(
    "⛔ STOP",
    UDim2.fromOffset(10, 142),
    Color3.fromRGB(150, 55, 60)
)

--==================================================
-- STATUS
--==================================================

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 25)
Status.Position = UDim2.fromOffset(10, 190)
Status.BackgroundTransparency = 1
Status.Text = "●  Conectado"
Status.TextColor3 = Color3.fromRGB(75, 200, 115)
Status.TextSize = 12
Status.Font = Enum.Font.Gotham
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Main

--==================================================
-- BOTÃO REABRIR
--==================================================

local OpenButton = Instance.new("ImageButton")
OpenButton.Size = UDim2.fromOffset(52, 52)
OpenButton.Position = UDim2.fromOffset(15, 180)
OpenButton.BackgroundColor3 = Color3.fromRGB(24, 27, 34)
OpenButton.BorderSizePixel = 0
OpenButton.Image = IMAGE_ID
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenButton

--==================================================
-- ABRIR / FECHAR
--==================================================

Close.MouseButton1Click:Connect(function()
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
local StartPosition

Top.InputBegan:Connect(function(Input)

    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position

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
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,

            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

--==================================================
-- CLIQUES
--==================================================

ParaBots.MouseButton1Click:Connect(function()
    task.spawn(TeleportParaBots)
end)

Auto.MouseButton1Click:Connect(function()
    task.spawn(AutoRoubo)
end)

Stop.MouseButton1Click:Connect(function()
    StopAutoRoubo()
end)

print("🪽 Seraphim-Hub carregado")
print("🏃 Auto Roubo Fly: 750")
