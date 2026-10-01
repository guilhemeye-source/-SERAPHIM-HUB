--// Seraphim-Hub
--// Salvar Posição -> Stop Bots -> 7 segundos -> voltar

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

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
Main.Size = UDim2.fromOffset(220, 135)
Main.Position = UDim2.new(0.5, -110, 0.5, -67)
Main.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 9)
Corner.Parent = Main

-- Borda azul-claro somente no painel
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(100, 200, 255)
Stroke.Thickness = 2
Stroke.Parent = Main

--==================================================
-- TOPO
--==================================================

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 32)
Top.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
Top.BorderSizePixel = 0
Top.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 9)
TopCorner.Parent = Top

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -42, 1, 0)
Title.Position = UDim2.fromOffset(9, 0)
Title.BackgroundTransparency = 1
Title.Text = "Seraphim-Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

--==================================================
-- FECHAR
--==================================================

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(24, 24)
CloseButton.Position = UDim2.new(1, -29, 0, 4)
CloseButton.BackgroundColor3 = Color3.fromRGB(30, 34, 43)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 11
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Top

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

--==================================================
-- VARIÁVEIS
--==================================================

local SavedPosition = nil
local Teleportando = false

--==================================================
-- BOTÃO SALVAR POSIÇÃO
--==================================================

local SaveButton = Instance.new("TextButton")
SaveButton.Size = UDim2.new(1, -16, 0, 36)
SaveButton.Position = UDim2.fromOffset(8, 40)
SaveButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SaveButton.BorderSizePixel = 0
SaveButton.Text = "Salvar Posição"
SaveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveButton.TextSize = 13
SaveButton.Font = Enum.Font.GothamBold
SaveButton.Parent = Main

local SaveCorner = Instance.new("UICorner")
SaveCorner.CornerRadius = UDim.new(0, 7)
SaveCorner.Parent = SaveButton

--==================================================
-- BOTÃO STOP BOTS
--==================================================

local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(1, -16, 0, 36)
StopButton.Position = UDim2.fromOffset(8, 84)
StopButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StopButton.BorderSizePixel = 0
StopButton.Text = "🛑 Stop Bots"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.TextSize = 13
StopButton.Font = Enum.Font.GothamBold
StopButton.Parent = Main

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 7)
StopCorner.Parent = StopButton

--==================================================
-- SALVAR POSIÇÃO
--==================================================

SaveButton.MouseButton1Click:Connect(function()

    local Character = Player.Character
    if not Character then
        return
    end

    local Root = Character:FindFirstChild("HumanoidRootPart")
    if not Root then
        return
    end

    SavedPosition = Root.CFrame

    SaveButton.Text = "Posição Salva!"

    task.delay(1, function()
        if SaveButton then
            SaveButton.Text = "Salvar Posição"
        end
    end)
end)

--==================================================
-- STOP BOTS
--==================================================

StopButton.MouseButton1Click:Connect(function()

    if Teleportando then
        return
    end

    if not SavedPosition then
        StopButton.Text = "Salve uma posição!"

        task.delay(1.5, function()
            if StopButton then
                StopButton.Text = "🛑 Stop Bots"
            end
        end)

        return
    end

    local Character = Player.Character
    if not Character then
        return
    end

    local Root = Character:FindFirstChild("HumanoidRootPart")
    if not Root then
        return
    end

    Teleportando = true

    -- Guarda o local atual
    local ReturnPosition = Root.CFrame

    -- Teleporta para a posição salva
    Root.CFrame = SavedPosition

    StopButton.Text = "🛑 Stop Bots: 7s"

    -- Aguarda 7 segundos
    task.wait(7)

    -- Verifica se o personagem continua existindo
    if Player.Character == Character then

        local NewRoot = Character:FindFirstChild("HumanoidRootPart")

        if NewRoot then
            -- Retorna exatamente ao local anterior
            NewRoot.CFrame = ReturnPosition
        end
    end

    StopButton.Text = "🛑 Stop Bots"
    Teleportando = false
end)

--==================================================
-- FECHAR
--==================================================

CloseButton.MouseButton1Click:Connect(function()
    Main.Visible = false
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

print("Seraphim-Hub carregado!")



