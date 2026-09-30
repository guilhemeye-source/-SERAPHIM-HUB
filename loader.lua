--==================================================
-- 🪽 SERAPHIM HUB
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local IMAGE_URL =
    "https://i.ibb.co/4wbF9PG0/211d12a0-a94f-11f1-b316-2d99c2fb1ccd.png"

--==================================================
-- 🐾 LISTA DE PETS
--==================================================

local PetRegions = {

    ["🌲 Floresta"] = {
        "Chicken","Dog","Bird","Owl","Raccoon","Fox","Bear","Brr Brr Patapim"
    },

    ["🌊 Lago"] = {
        "Frog","Duckling","Catfish","Turtle","Trulimero Trulicina","Swan","Axolotl","Leviathan"
    },

    ["🏜️ Deserto"] = {
        "Jerboa","Fennec","Camel","Tobi Tobi Tob Tob","Snake","Scorpion","Sand Spider","Royal Sphinx"
    },

    ["🐒 Selva"] = {
        "Chimpanzee","Monkey","Sloth","Parrot","Jaguar","Crocodile","Tiger","King Snake"
    },

    ["❄️ Neve"] = {
        "Penguin","Arctic Fox","Polar Bear","Seal","King Mammoth","Yeti","Ice Dragon"
    },

    ["🌋 Vulcão"] = {
        "Fire Ant","Magma Golem","Lava Dragon","Cerberus","Phoenix"
    },

    ["🌊 Oceano Profundo"] = {
        "Shark","Octopus","Whale Shark","Kraken","Beluga Whale","Abyss Overlord"
    },

    ["🦖 Pré-histórico"] = {
        "Raptor","Triceratops","Mosasaurus","T-Rex","Skeletal Sabertooth"
    },

    ["🌌 Cósmico"] = {
        "Alien","Cosmic Royal Sphinx","Cosmic Dragon","Cosmic Skeleton King","Unicorn"
    },

    ["🌸 Cerejeiras"] = {
        "Stag","Oni Tiger","Kitsune"
    },

    ["🗿 Templo Titã"] = {
        "Titan Golem","Night Flame","Nightflame","Gorilla King"
    },

    ["😇 Anjos e Demônios"] = {
        "Light Dove","Winged Lamb","Sacred Moth","Holy Peacock",
        "Pure Jellyfish","Centaur","Pegasus","ArchAngel",
        "Flame Sprite","Toro","Imp","Demon Hound","Gargoyle",
        "RazorFang","Skeleton Horse","World Burner","World Eater"
    }
}

--==================================================
-- 🛡️ PROTEÇÃO LOCAL
--==================================================

local ProtectionEnabled = true

local function AtivarProtecao(Character)

    local Humanoid = Character:WaitForChild("Humanoid")
    local Root = Character:WaitForChild("HumanoidRootPart")

    Humanoid.Health = Humanoid.MaxHealth

    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)

    Humanoid.HealthChanged:Connect(function()

        if ProtectionEnabled
        and Humanoid.Parent
        and Humanoid.Health > 0 then

            Humanoid.Health = Humanoid.MaxHealth
        end
    end)

    task.spawn(function()

        while ProtectionEnabled
        and Character.Parent
        and Humanoid.Parent do

            Root.AssemblyAngularVelocity = Vector3.zero

            task.wait(0.05)
        end
    end)
end

if Player.Character then
    task.spawn(AtivarProtecao, Player.Character)
end

Player.CharacterAdded:Connect(function(Character)

    task.wait(0.5)

    if ProtectionEnabled then
        task.spawn(AtivarProtecao, Character)
    end
end)

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

    local Root = Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return
    end

    local PosicaoOriginal = Root.CFrame

    Root.CFrame =
        Point.CFrame +
        Vector3.new(0, 4, 0)

    -- 2.5 SEGUNDOS
    task.wait(2.5)

    if Root and Root.Parent then
        Root.CFrame = PosicaoOriginal
    end
end

--==================================================
-- 🐾 SISTEMA DE PETS
--==================================================

local PetsEnabled = false

local PetNames = {}

for _, Pets in pairs(PetRegions) do

    for _, PetName in ipairs(Pets) do
        PetNames[string.lower(PetName)] = PetName
    end
end

--==================================================
-- 🔎 DESCOBRIR VALOR
--==================================================

local function GetPetValue(Pet)

    local Attributes = Pet:GetAttributes()

    local PossibleNames = {
        "Value","value",
        "Price","price",
        "Worth","worth",
        "Cash","cash",
        "Money","money",
        "Income","income",
        "Earnings","earnings",
        "Generation","generation",
        "PerSecond","perSecond"
    }

    for _, Name in ipairs(PossibleNames) do

        local Value = Attributes[Name]

        if Value ~= nil then
            return tostring(Value)
        end
    end

    for _, Obj in ipairs(Pet:GetDescendants()) do

        if Obj:IsA("NumberValue")
        or Obj:IsA("IntValue") then

            local Name = string.lower(Obj.Name)

            if Name:find("value")
            or Name:find("price")
            or Name:find("worth")
            or Name:find("cash")
            or Name:find("money")
            or Name:find("income")
            or Name:find("generation")
            or Name:find("second") then

                return tostring(Obj.Value)
            end
        end
    end

    for _, Obj in ipairs(Pet:GetDescendants()) do

        if Obj:IsA("TextLabel")
        or Obj:IsA("TextButton")
        or Obj:IsA("TextBox") then

            local Text = Obj.Text

            if Text ~= "" then

                if Text:find("%$")
                or Text:lower():find("cash")
                or Text:lower():find("value")
                or Text:lower():find("sec") then

                    return Text
                end
            end
        end
    end

    return "Valor não identificado"
end

--==================================================
-- 🔎 ENCONTRAR PETS
--==================================================

local function EncontrarPets()

    local Encontrados = {}

    for _, Obj in ipairs(workspace:GetDescendants()) do

        local NomeOriginal = Obj.Name
        local NomeLower = string.lower(NomeOriginal)
        local NomeConhecido = PetNames[NomeLower]

        if NomeConhecido then

            if not Encontrados[Obj] then

                Encontrados[Obj] = {
                    Name = NomeConhecido,
                    Value = GetPetValue(Obj)
                }
            end
        end
    end

    return Encontrados
end

--==================================================
-- 🥚 AUTO ROUBO
--==================================================

local AutoRouboEnabled = false

local function NumeroDoValor(Value)

    if typeof(Value) == "number" then
        return Value
    end

    local Text = tostring(Value)
        :gsub(",", "")
        :gsub("%$", "")

    local Number = tonumber(
        string.match(Text, "%-?%d+%.?%d*")
    )

    return Number or 0
end

local function EncontrarOvos()

    local Eggs =
        ReplicatedStorage:FindFirstChild("Eggs", true)

    if not Eggs then
        Eggs = workspace:FindFirstChild("Eggs", true)
    end

    if not Eggs then
        return {}
    end

    local Result = {}

    for _, Obj in ipairs(Eggs:GetDescendants()) do

        if Obj:IsA("Model")
        or Obj:IsA("Folder")
        or Obj:IsA("BasePart") then

            table.insert(Result, Obj)
        end
    end

    return Result
end

local function EncontrarMelhorOvo()

    local MelhorOvo = nil
    local MelhorValor = -math.huge

    for _, Ovo in ipairs(EncontrarOvos()) do

        local Valor = NumeroDoValor(
            GetPetValue(Ovo)
        )

        if Valor > MelhorValor then

            MelhorValor = Valor
            MelhorOvo = Ovo
        end
    end

    return MelhorOvo, MelhorValor
end

local function IniciarAutoRoubo()

    task.spawn(function()

        while AutoRouboEnabled do

            local MelhorOvo, Valor =
                EncontrarMelhorOvo()

            if MelhorOvo then

                Status.Text =
                    "🥚 Melhor: "
                    .. MelhorOvo.Name
                    .. " • "
                    .. tostring(Valor)

                print(
                    "🥚 Melhor ovo encontrado:",
                    MelhorOvo:GetFullName(),
                    "Valor:",
                    Valor
                )

            else

                Status.Text =
                    "🥚 Nenhum ovo encontrado"
            end

            task.wait(1)
        end
    end)
end

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "SeraphimHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")

Main.Size = UDim2.fromOffset(270, 340)

Main.Position =
    UDim2.new(
        0.5,
        -135,
        0.5,
        -170
    )

Main.BackgroundColor3 =
    Color3.fromRGB(24, 27, 34)

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

Top.BackgroundColor3 =
    Color3.fromRGB(30, 34, 43)

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
Logo.Image = IMAGE_URL
Logo.Parent = Top

--==================================================
-- TÍTULO
--==================================================

local Title = Instance.new("TextLabel")

Title.Size =
    UDim2.new(1, -75, 1, 0)

Title.Position =
    UDim2.fromOffset(43, 0)

Title.BackgroundTransparency = 1

Title.Text = "Seraphim-Hub"

Title.TextColor3 =
    Color3.fromRGB(235, 235, 235)

Title.TextSize = 14
Title.Font = Enum.Font.GothamMedium

Title.TextXAlignment =
    Enum.TextXAlignment.Left

Title.Parent = Top

--==================================================
-- FECHAR
--==================================================

local Close = Instance.new("TextButton")

Close.Size = UDim2.fromOffset(30, 30)

Close.Position =
    UDim2.new(1, -35, 0, 5)

Close.BackgroundTransparency = 1

Close.Text = "×"

Close.TextColor3 =
    Color3.fromRGB(210, 210, 210)

Close.TextSize = 20
Close.Font = Enum.Font.Gotham

Close.Parent = Top

--==================================================
-- BOTÃO
--==================================================

local function CreateButton(
    Text,
    Position,
    Background
)

    local Button = Instance.new("TextButton")

    Button.Size =
        UDim2.new(1, -20, 0, 40)

    Button.Position = Position

    Button.BackgroundColor3 = Background
    Button.BorderSizePixel = 0

    Button.Text = Text

    Button.TextColor3 =
        Color3.fromRGB(245, 245, 245)

    Button.TextSize = 13
    Button.Font = Enum.Font.GothamMedium

    Button.Parent = Main

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button

    return Button
end

--==================================================
-- BOTÕES
--==================================================

local ParaBots =
    CreateButton(
        "📶 PARA BOTS",
        UDim2.fromOffset(10, 50),
        Color3.fromRGB(45, 105, 180)
    )

local AutoRoubo =
    CreateButton(
        "🥚 AUTO ROUBO: OFF",
        UDim2.fromOffset(10, 96),
        Color3.fromRGB(65, 85, 105)
    )

local PetsButton =
    CreateButton(
        "🐾 PETS: OFF",
        UDim2.fromOffset(10, 142),
        Color3.fromRGB(65, 85, 105)
    )

--==================================================
-- STATUS
--==================================================

local Status =
    Instance.new("TextLabel")

Status.Size =
    UDim2.new(1, -20, 0, 25)

Status.Position =
    UDim2.fromOffset(10, 188)

Status.BackgroundTransparency = 1

Status.Text = "● Conectado"

Status.TextColor3 =
    Color3.fromRGB(75, 200, 115)

Status.TextSize = 12
Status.Font = Enum.Font.Gotham

Status.TextXAlignment =
    Enum.TextXAlignment.Left

Status.Parent = Main

--==================================================
-- LISTA
--==================================================

local PetList =
    Instance.new("ScrollingFrame")

PetList.Size =
    UDim2.new(1, -20, 0, 125)

PetList.Position =
    UDim2.fromOffset(10, 215)

PetList.BackgroundColor3 =
    Color3.fromRGB(19, 22, 28)

PetList.BorderSizePixel = 0
PetList.ScrollBarThickness = 4

PetList.CanvasSize =
    UDim2.fromOffset(0, 0)

PetList.Visible = false
PetList.Parent = Main

local PetCorner =
    Instance.new("UICorner")

PetCorner.CornerRadius =
    UDim.new(0, 6)

PetCorner.Parent = PetList

local PetLayout =
    Instance.new("UIListLayout")

PetLayout.Padding =
    UDim.new(0, 3)

PetLayout.Parent = PetList

--==================================================
-- ATUALIZAR PETS
--==================================================

local function AtualizarListaPets()

    for _, Obj in ipairs(PetList:GetChildren()) do

        if Obj:IsA("TextLabel") then
            Obj:Destroy()
        end
    end

    local Pets = EncontrarPets()
    local Count = 0

    for _, Data in pairs(Pets) do

        Count += 1

        local Label =
            Instance.new("TextLabel")

        Label.Size =
            UDim2.new(1, -8, 0, 25)

        Label.BackgroundTransparency = 1

        Label.Text =
            "🐾 "
            .. Data.Name
            .. " • "
            .. Data.Value

        Label.TextColor3 =
            Color3.fromRGB(230, 230, 230)

        Label.TextSize = 11
        Label.Font = Enum.Font.Gotham

        Label.TextXAlignment =
            Enum.TextXAlignment.Left

        Label.Parent = PetList
    end

    if Count == 0 then

        local Label =
            Instance.new("TextLabel")

        Label.Size =
            UDim2.new(1, -8, 0, 30)

        Label.BackgroundTransparency = 1

        Label.Text =
            "Nenhum pet encontrado"

        Label.TextColor3 =
            Color3.fromRGB(160, 160, 160)

        Label.TextSize = 11
        Label.Font = Enum.Font.Gotham

        Label.Parent = PetList
    end

    PetList.CanvasSize =
        UDim2.fromOffset(
            0,
            PetLayout.AbsoluteContentSize.Y + 8
        )
end

--==================================================
-- BOLINHA
--==================================================

local OpenButton =
    Instance.new("ImageButton")

OpenButton.Size =
    UDim2.fromOffset(55, 55)

OpenButton.Position =
    UDim2.fromOffset(20, 200)

OpenButton.BackgroundColor3 =
    Color3.fromRGB(24, 27, 34)

OpenButton.BorderSizePixel = 0
OpenButton.Image = IMAGE_URL

OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local OpenCorner =
    Instance.new("UICorner")

OpenCorner.CornerRadius =
    UDim.new(1, 0)

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

    if Input.UserInputType ==
        Enum.UserInputType.MouseButton1
    or Input.UserInputType ==
        Enum.UserInputType.Touch then

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

        Main.Position =
            UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,

                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
    end
end)

--==================================================
-- 📶 PARA BOTS
--==================================================

ParaBots.MouseButton1Click:Connect(function()

    task.spawn(TeleportParaBots)

end)

--==================================================
-- 🥚 AUTO ROUBO
--==================================================

AutoRoubo.MouseButton1Click:Connect(function()

    AutoRouboEnabled =
        not AutoRouboEnabled

    if AutoRouboEnabled then

        AutoRoubo.Text =
            "🥚 AUTO ROUBO: ON"

        AutoRoubo.BackgroundColor3 =
            Color3.fromRGB(45, 150, 90)

        Status.Text =
            "🥚 Procurando melhor ovo..."

        IniciarAutoRoubo()

    else

        AutoRoubo.Text =
            "🥚 AUTO ROUBO: OFF"

        AutoRoubo.BackgroundColor3 =
            Color3.fromRGB(65, 85, 105)

        Status.Text =
            "● Conectado"
    end
end)

--==================================================
-- 🐾 PETS
--==================================================

PetsButton.MouseButton1Click:Connect(function()

    PetsEnabled =
        not PetsEnabled

    if PetsEnabled then

        PetsButton.Text =
            "🐾 PETS: ON"

        PetsButton.BackgroundColor3 =
            Color3.fromRGB(45, 150, 90)

        PetList.Visible = true

        Status.Text =
            "● Identificando pets..."

        AtualizarListaPets()

        Status.Text =
            "● Pets identificados"

    else

        PetsButton.Text =
            "🐾 PETS: OFF"

        PetsButton.BackgroundColor3 =
            Color3.fromRGB(65, 85, 105)

        PetList.Visible = false

        Status.Text =
            "● Conectado"
    end
end)

--==================================================
-- 🔄 ATUALIZAÇÃO
--==================================================

task.spawn(function()

    while ScreenGui.Parent do

        if PetsEnabled then
            AtualizarListaPets()
        end

        task.wait(2)
    end
end)

--==================================================
-- FINAL
--==================================================

print("🪽 Seraphim-Hub carregado")
print("📶 Para Bots: 2.5 segundos")
print("🥚 Auto Roubo: leitura do melhor ovo ativa")
print("🐾 Identificador de Pets: pronto")
