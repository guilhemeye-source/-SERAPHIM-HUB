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
-- 🐾 NOMES DOS PETS
--==================================================

local PetRegions = {

    ["🌲 Floresta"] = {
        "Chicken","Dog","Bird","Owl","Raccoon","Fox","Bear","Brr Brr Patapim"
    },

    ["🌊 Lago"] = {
        "Frog","Duckling","Catfish","Turtle","Trulimero Trulicina",
        "Swan","Axolotl","Leviathan"
    },

    ["🏜️ Deserto"] = {
        "Jerboa","Fennec","Camel","Tobi Tobi Tob Tob","Snake",
        "Scorpion","Sand Spider","Royal Sphinx"
    },

    ["🐒 Selva"] = {
        "Chimpanzee","Monkey","Sloth","Parrot","Jaguar",
        "Crocodile","Tiger","King Snake"
    },

    ["❄️ Neve"] = {
        "Penguin","Arctic Fox","Polar Bear","Seal",
        "King Mammoth","Yeti","Ice Dragon"
    },

    ["🌋 Vulcão"] = {
        "Fire Ant","Magma Golem","Lava Dragon","Cerberus","Phoenix"
    },

    ["🌊 Oceano Profundo"] = {
        "Shark","Octopus","Whale Shark","Kraken",
        "Beluga Whale","Abyss Overlord"
    },

    ["🦖 Pré-histórico"] = {
        "Raptor","Triceratops","Mosasaurus",
        "T-Rex","Skeletal Sabertooth"
    },

    ["🌌 Cósmico"] = {
        "Alien","Cosmic Royal Sphinx","Cosmic Dragon",
        "Cosmic Skeleton King","Unicorn"
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

local PetNames = {}

for _, Pets in pairs(PetRegions) do
    for _, PetName in ipairs(Pets) do
        PetNames[string.lower(PetName)] = PetName
    end
end

--==================================================
-- 📶 ENCONTRAR BASE
--==================================================

local function FindBaseSpawn()

    local Base =
        workspace:FindFirstChild("Base", true)

    if Base then

        if Base:IsA("SpawnLocation") then
            return Base
        end

        local Spawn =
            Base:FindFirstChildWhichIsA(
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

    for _, Obj in ipairs(
        workspace:GetDescendants()
    ) do

        if Obj:IsA("SpawnLocation") then

            local Name =
                string.lower(Obj.Name)

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

    local Point =
        FindBaseSpawn()

    if not Point then
        return
    end

    local Character =
        Player.Character

    if not Character then
        return
    end

    local Root =
        Character:FindFirstChild(
            "HumanoidRootPart"
        )

    if not Root then
        return
    end

    local PosicaoOriginal =
        Root.CFrame

    Root.CFrame =
        Point.CFrame +
        Vector3.new(0, 4, 0)

    task.wait(2.5)

    if Root and Root.Parent then
        Root.CFrame =
            PosicaoOriginal
    end
end

--==================================================
-- 🔎 PEGAR VALOR DO PET
--==================================================

local function GetPetValue(Pet)

    local PossibleNames = {
        "Value",
        "value",
        "Price",
        "price",
        "Worth",
        "worth",
        "Cash",
        "cash",
        "Money",
        "money",
        "Income",
        "income",
        "Earnings",
        "earnings",
        "Generation",
        "generation",
        "PerSecond",
        "perSecond",
        "Multiplier",
        "multiplier"
    }

    -- Attributes
    for _, Name in ipairs(PossibleNames) do

        local Value =
            Pet:GetAttribute(Name)

        if Value ~= nil then
            return Value
        end
    end

    -- Values
    for _, Obj in ipairs(
        Pet:GetDescendants()
    ) do

        if Obj:IsA("NumberValue")
        or Obj:IsA("IntValue") then

            local Name =
                string.lower(Obj.Name)

            if Name:find("value")
            or Name:find("price")
            or Name:find("worth")
            or Name:find("cash")
            or Name:find("money")
            or Name:find("income")
            or Name:find("earning")
            or Name:find("generation")
            or Name:find("second")
            or Name:find("multiplier") then

                return Obj.Value
            end
        end
    end

    -- Texto
    for _, Obj in ipairs(
        Pet:GetDescendants()
    ) do

        if Obj:IsA("TextLabel")
        or Obj:IsA("TextButton")
        or Obj:IsA("TextBox") then

            local Text =
                Obj.Text

            if Text ~= "" then

                local Lower =
                    Text:lower()

                if Lower:find("cash")
                or Lower:find("value")
                or Lower:find("sec")
                or Lower:find("generation")
                or Text:find("%$") then

                    return Text
                end
            end
        end
    end

    return 0
end

--==================================================
-- 🔢 CONVERTER VALOR
--==================================================

local function NumberFromValue(Value)

    if typeof(Value) == "number" then
        return Value
    end

    local Text =
        tostring(Value)
            :lower()
            :gsub(",", "")
            :gsub("%$", "")

    local Number =
        tonumber(
            string.match(
                Text,
                "%-?%d+%.?%d*"
            )
        )

    return Number or 0
end

--==================================================
-- 🥚 ENCONTRAR EGGS
--==================================================

local function EncontrarPastaDeOvos()

    local Eggs =
        ReplicatedStorage:FindFirstChild(
            "Eggs",
            true
        )

    if Eggs then
        return Eggs
    end

    Eggs =
        workspace:FindFirstChild(
            "Eggs",
            true
        )

    return Eggs
end

--==================================================
-- 🐾 ENCONTRAR PETS DOS OVOS
--==================================================

local function EncontrarPetsDosOvos()

    local Eggs =
        EncontrarPastaDeOvos()

    if not Eggs then
        return {}
    end

    local Encontrados = {}

    for _, Ovo in ipairs(
        Eggs:GetChildren()
    ) do

        for _, Obj in ipairs(
            Ovo:GetDescendants()
        ) do

            local Nome =
                PetNames[
                    string.lower(Obj.Name)
                ]

            if Nome then

                if not Encontrados[Obj] then

                    local Valor =
                        GetPetValue(Obj)

                    table.insert(
                        Encontrados,
                        {
                            Object = Obj,
                            Name = Nome,
                            Value = Valor,
                            Number =
                                NumberFromValue(
                                    Valor
                                ),
                            Egg = Ovo.Name
                        }
                    )
                end
            end
        end
    end

    -- Maior valor primeiro
    table.sort(
        Encontrados,
        function(A, B)
            return A.Number > B.Number
        end
    )

    return Encontrados
end

--==================================================
-- GUI
--==================================================

local ScreenGui =
    Instance.new("ScreenGui")

ScreenGui.Name =
    "SeraphimHub"

ScreenGui.ResetOnSpawn =
    false

ScreenGui.ZIndexBehavior =
    Enum.ZIndexBehavior.Sibling

ScreenGui.Parent =
    PlayerGui

--==================================================
-- PAINEL
--==================================================

local Main =
    Instance.new("Frame")

Main.Size =
    UDim2.fromOffset(
        270,
        340
    )

Main.Position =
    UDim2.new(
        0.5,
        -135,
        0.5,
        -170
    )

Main.BackgroundColor3 =
    Color3.fromRGB(
        24,
        27,
        34
    )

Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner =
    Instance.new("UICorner")

MainCorner.CornerRadius =
    UDim.new(0, 8)

MainCorner.Parent =
    Main

--==================================================
-- TOPO
--==================================================

local Top =
    Instance.new("Frame")

Top.Size =
    UDim2.new(
        1,
        0,
        0,
        40
    )

Top.BackgroundColor3 =
    Color3.fromRGB(
        30,
        34,
        43
    )

Top.BorderSizePixel = 0
Top.Parent = Main

local TopCorner =
    Instance.new("UICorner")

TopCorner.CornerRadius =
    UDim.new(0, 8)

TopCorner.Parent =
    Top

--==================================================
-- LOGO
--==================================================

local Logo =
    Instance.new("ImageLabel")

Logo.Size =
    UDim2.fromOffset(
        27,
        27
    )

Logo.Position =
    UDim2.fromOffset(
        8,
        6
    )

Logo.BackgroundTransparency = 1
Logo.Image = IMAGE_URL
Logo.Parent = Top

--==================================================
-- TÍTULO
--==================================================

local Title =
    Instance.new("TextLabel")

Title.Size =
    UDim2.new(
        1,
        -75,
        1,
        0
    )

Title.Position =
    UDim2.fromOffset(
        43,
        0
    )

Title.BackgroundTransparency = 1

Title.Text =
    "Seraphim-Hub"

Title.TextColor3 =
    Color3.fromRGB(
        235,
        235,
        235
    )

Title.TextSize = 14

Title.Font =
    Enum.Font.GothamMedium

Title.TextXAlignment =
    Enum.TextXAlignment.Left

Title.Parent =
    Top

--==================================================
-- FECHAR
--==================================================

local Close =
    Instance.new("TextButton")

Close.Size =
    UDim2.fromOffset(
        30,
        30
    )

Close.Position =
    UDim2.new(
        1,
        -35,
        0,
        5
    )

Close.BackgroundTransparency = 1

Close.Text = "×"

Close.TextColor3 =
    Color3.fromRGB(
        210,
        210,
        210
    )

Close.TextSize = 20

Close.Font =
    Enum.Font.Gotham

Close.Parent =
    Top

--==================================================
-- BOTÃO PADRÃO
--==================================================

local function CreateButton(
    Text,
    Position,
    Background
)

    local Button =
        Instance.new("TextButton")

    Button.Size =
        UDim2.new(
            1,
            -20,
            0,
            40
        )

    Button.Position =
        Position

    Button.BackgroundColor3 =
        Background

    Button.BorderSizePixel = 0

    Button.Text =
        Text

    Button.TextColor3 =
        Color3.fromRGB(
            245,
            245,
            245
        )

    Button.TextSize = 13

    Button.Font =
        Enum.Font.GothamMedium

    Button.Parent =
        Main

    local Corner =
        Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(0, 6)

    Corner.Parent =
        Button

    return Button
end

--==================================================
-- BOTÕES
--==================================================

local ParaBots =
    CreateButton(
        "📶 PARA BOTS",
        UDim2.fromOffset(
            10,
            50
        ),
        Color3.fromRGB(
            45,
            105,
            180
        )
    )

local PetsButton =
    CreateButton(
        "🐾 PETS: OFF",
        UDim2.fromOffset(
            10,
            96
        ),
        Color3.fromRGB(
            65,
            85,
            105
        )
    )

--==================================================
-- STATUS
--==================================================

local Status =
    Instance.new("TextLabel")

Status.Size =
    UDim2.new(
        1,
        -20,
        0,
        25
    )

Status.Position =
    UDim2.fromOffset(
        10,
        142
    )

Status.BackgroundTransparency = 1

Status.Text =
    "● Conectado"

Status.TextColor3 =
    Color3.fromRGB(
        75,
        200,
        115
    )

Status.TextSize = 12

Status.Font =
    Enum.Font.Gotham

Status.TextXAlignment =
    Enum.TextXAlignment.Left

Status.Parent =
    Main

--==================================================
-- 📜 LISTA DE PETS
--==================================================

local PetList =
    Instance.new("ScrollingFrame")

PetList.Size =
    UDim2.new(
        1,
        -20,
        0,
        165
    )

PetList.Position =
    UDim2.fromOffset(
        10,
        170
    )

PetList.BackgroundColor3 =
    Color3.fromRGB(
        19,
        22,
        28
    )

PetList.BorderSizePixel = 0

PetList.ScrollBarThickness = 6

PetList.ScrollingDirection =
    Enum.ScrollingDirection.Y

PetList.CanvasSize =
    UDim2.fromOffset(
        0,
        0
    )

PetList.AutomaticCanvasSize =
    Enum.AutomaticSize.Y

PetList.Visible = false

PetList.Parent = Main

local PetCorner =
    Instance.new("UICorner")

PetCorner.CornerRadius =
    UDim.new(0, 6)

PetCorner.Parent =
    PetList

local PetLayout =
    Instance.new("UIListLayout")

PetLayout.Padding =
    UDim.new(0, 2)

PetLayout.SortOrder =
    Enum.SortOrder.LayoutOrder

PetLayout.Parent =
    PetList

--==================================================
-- 🔄 ATUALIZAR LISTA
--==================================================

local function AtualizarListaPets()

    for _, Obj in ipairs(
        PetList:GetChildren()
    ) do

        if Obj:IsA("TextLabel") then
            Obj:Destroy()
        end
    end

    local Pets =
        EncontrarPetsDosOvos()

    if #Pets == 0 then

        local Label =
            Instance.new("TextLabel")

        Label.Size =
            UDim2.new(
                1,
                -10,
                0,
                30
            )

        Label.BackgroundTransparency = 1

        Label.Text =
            "Nenhum pet encontrado nos ovos"

        Label.TextColor3 =
            Color3.fromRGB(
                160,
                160,
                160
            )

        Label.TextSize = 11

        Label.Font =
            Enum.Font.Gotham

        Label.Parent =
            PetList

        return
    end

    for Index, Data in ipairs(Pets) do

        local Label =
            Instance.new("TextLabel")

        Label.Size =
            UDim2.new(
                1,
                -10,
                0,
                30
            )

        Label.BackgroundTransparency = 1

        Label.LayoutOrder =
            Index

        Label.Text =
            "🐾 "
            .. Data.Name
            .. "  •  "
            .. tostring(Data.Value)

        Label.TextColor3 =
            Color3.fromRGB(
                230,
                230,
                230
            )

        Label.TextSize = 11

        Label.Font =
            Enum.Font.Gotham

        Label.TextXAlignment =
            Enum.TextXAlignment.Left

        Label.Parent =
            PetList
    end
end

--==================================================
-- 🔄 ATUALIZAÇÃO AUTOMÁTICA
--==================================================

local PetsEnabled = false

task.spawn(function()

    while ScreenGui.Parent do

        if PetsEnabled then

            AtualizarListaPets()

            Status.Text =
                "● Pets atualizados: "
                .. tostring(
                    #EncontrarPetsDosOvos()
                )
        end

        task.wait(2)
    end
end)

--==================================================
-- BOLINHA
--==================================================

local OpenButton =
    Instance.new("ImageButton")

OpenButton.Size =
    UDim2.fromOffset(
        55,
        55
    )

OpenButton.Position =
    UDim2.fromOffset(
        20,
        200
    )

OpenButton.BackgroundColor3 =
    Color3.fromRGB(
        24,
        27,
        34
    )

OpenButton.BorderSizePixel = 0

OpenButton.Image =
    IMAGE_URL

OpenButton.Visible = false

OpenButton.Parent =
    ScreenGui

local OpenCorner =
    Instance.new("UICorner")

OpenCorner.CornerRadius =
    UDim.new(1, 0)

OpenCorner.Parent =
    OpenButton

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

        DragStart =
            Input.Position

        StartPosition =
            Main.Position

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
            Input.Position -
            DragStart

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

    task.spawn(
        TeleportParaBots
    )

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
            Color3.fromRGB(
                45,
                150,
                90
            )

        PetList.Visible = true

        Status.Text =
            "● Identificando pets..."

        AtualizarListaPets()

    else

        PetsButton.Text =
            "🐾 PETS: OFF"

        PetsButton.BackgroundColor3 =
            Color3.fromRGB(
                65,
                85,
                105
            )

        PetList.Visible = false

        Status.Text =
            "● Conectado"
    end
end)

--==================================================
-- FINAL
--==================================================

print("🪽 Seraphim-Hub carregado")
print("📶 Para Bots: 2.5 segundos")
print("🐾 Identificador de Pets: pronto")
print("🔄 Atualização automática: ativa")
