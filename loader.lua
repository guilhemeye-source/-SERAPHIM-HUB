--==================================================
-- 🪽 SERAPHIM HUB - VERSÃO PARA ROBLOX STUDIO
-- Ovos + Pets + Chefes + Para Bots
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local IMAGE_URL =
    "https://i.ibb.co/4wbF9PG0/211d12a0-a94f-11f1-b316-2d99c2fb1ccd.png"

local TELEPORT_TIME = 2.5

--==================================================
-- CONFIGURAÇÃO
--==================================================

local PetsEnabled = false
local BossEnabled = false

local BossList = {}
local EggList = {}
local PetListData = {}

--==================================================
-- FUNÇÕES AUXILIARES
--==================================================

local function getRoot()
    local Character = Player.Character
    if not Character then
        return nil
    end

    return Character:FindFirstChild("HumanoidRootPart")
end

local function getValue(Object, Names)
    for _, Name in ipairs(Names) do

        local Attribute = Object:GetAttribute(Name)

        if Attribute ~= nil then
            return Attribute
        end

        local Child = Object:FindFirstChild(Name, true)

        if Child then

            if Child:IsA("NumberValue")
            or Child:IsA("IntValue")
            or Child:IsA("StringValue")
            or Child:IsA("BoolValue") then

                return Child.Value
            end
        end
    end

    return nil
end

local function getPosition(Object)

    if Object:IsA("BasePart") then
        return Object.Position
    end

    if Object:IsA("Model") then
        local Root = Object.PrimaryPart

        if Root then
            return Root.Position
        end

        local Part =
            Object:FindFirstChildWhichIsA(
                "BasePart",
                true
            )

        if Part then
            return Part.Position
        end
    end

    return nil
end

--==================================================
-- 🥚 DETECTAR OVOS
--==================================================

local function IsEgg(Object)

    local Name =
        string.lower(Object.Name)

    if Object:GetAttribute("IsEgg") == true then
        return true
    end

    if Name:find("egg")
    or Name:find("ovo") then
        return true
    end

    return false
end

local function ScanEggs()

    local Result = {}

    for _, Object in ipairs(
        workspace:GetDescendants()
    ) do

        if Object:IsA("Model")
        or Object:IsA("BasePart") then

            if IsEgg(Object) then

                local Position =
                    getPosition(Object)

                if Position then

                    local Value =
                        getValue(
                            Object,
                            {
                                "Value",
                                "Multiplier",
                                "Price",
                                "Cash",
                                "Worth"
                            }
                        )

                    local Rarity =
                        getValue(
                            Object,
                            {
                                "Rarity",
                                "Tier"
                            }
                        )

                    table.insert(
                        Result,
                        {
                            Object = Object,
                            Name = Object.Name,
                            Value = Value or "?",
                            Rarity = Rarity or "Normal",
                            Position = Position
                        }
                    )
                end
            end
        end
    end

    return Result
end

--==================================================
-- 🐾 DETECTAR PETS
--==================================================

local function IsPet(Object)

    if Object:GetAttribute("IsPet") == true then
        return true
    end

    local Name =
        string.lower(Object.Name)

    if Object:GetAttribute("Pet") == true then
        return true
    end

    if Name:find("pet") then
        return true
    end

    return false
end

local function ScanPets()

    local Result = {}

    for _, Object in ipairs(
        workspace:GetDescendants()
    ) do

        if Object:IsA("Model")
        or Object:IsA("BasePart") then

            if IsPet(Object) then

                local Position =
                    getPosition(Object)

                if Position then

                    local Value =
                        getValue(
                            Object,
                            {
                                "Value",
                                "Worth",
                                "Income",
                                "Generation",
                                "PerSecond",
                                "Cash"
                            }
                        )

                    table.insert(
                        Result,
                        {
                            Object = Object,
                            Name = Object.Name,
                            Value = Value or "?",
                            Position = Position
                        }
                    )
                end
            end
        end
    end

    return Result
end

--==================================================
-- 👑 DETECTAR CHEFES
--==================================================

local function IsBoss(Object)

    if not Object:IsA("Model") then
        return false
    end

    if not Object:FindFirstChildOfClass(
        "Humanoid"
    ) then
        return false
    end

    if Players:GetPlayerFromCharacter(Object) then
        return false
    end

    if Object:GetAttribute("IsBoss") == true then
        return true
    end

    local Name =
        string.lower(Object.Name)

    local Keywords = {
        "boss",
        "chefe",
        "guardian",
        "guardião",
        "guardian",
        "king",
        "queen",
        "lord",
        "overlord"
    }

    for _, Keyword in ipairs(Keywords) do

        if Name:find(Keyword) then
            return true
        end
    end

    return false
end

local function ScanBosses()

    local Result = {}

    for _, Object in ipairs(
        workspace:GetDescendants()
    ) do

        if IsBoss(Object) then

            local Position =
                getPosition(Object)

            if Position then

                local Humanoid =
                    Object:FindFirstChildOfClass(
                        "Humanoid"
                    )

                local Health = 0

                if Humanoid then
                    Health = Humanoid.Health
                end

                table.insert(
                    Result,
                    {
                        Object = Object,
                        Name = Object.Name,
                        Health = Health,
                        Position = Position
                    }
                )
            end
        end
    end

    return Result
end

--==================================================
-- 🔎 ATUALIZAR DADOS
--==================================================

local function UpdateData()

    EggList = ScanEggs()
    PetListData = ScanPets()
    BossList = ScanBosses()

    table.sort(
        BossList,
        function(A, B)

            return A.Name < B.Name
        end
    )

    table.sort(
        EggList,
        function(A, B)

            return A.Name < B.Name
        end
    )

    table.sort(
        PetListData,
        function(A, B)

            return A.Name < B.Name
        end
    )
end

--==================================================
-- 📍 TELEPORTE
--==================================================

local function TeleportTo(Position)

    local Root = getRoot()

    if not Root then
        return false
    end

    Root.CFrame =
        CFrame.new(
            Position + Vector3.new(0, 4, 0)
        )

    return true
end

--==================================================
-- 📶 PARA BOTS
-- Passa pelos chefes encontrados
--==================================================

local BossRunning = false

local function StartBossRoute()

    if BossRunning then
        return
    end

    BossRunning = true

    while BossRunning do

        UpdateData()

        if #BossList == 0 then
            task.wait(1)
            continue
        end

        for _, BossData in ipairs(BossList) do

            if not BossRunning then
                break
            end

            local Boss =
                BossData.Object

            if Boss
            and Boss.Parent then

                local Position =
                    getPosition(Boss)

                if Position then

                    local Root = getRoot()

                    if Root then

                        local Distance =
                            (
                                Root.Position -
                                Position
                            ).Magnitude

                        -- Se já estiver na área,
                        -- não teleporta novamente.
                        if Distance > 20 then

                            TeleportTo(
                                Position
                            )

                            task.wait(
                                TELEPORT_TIME
                            )
                        end
                    end
                end
            end
        end
    end
end

local function StopBossRoute()

    BossRunning = false
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
        290,
        390
    )

Main.Position =
    UDim2.new(
        0.5,
        -145,
        0.5,
        -195
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
Title.Text = "Seraphim-Hub"

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

Title.Parent = Top

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

Close.Parent = Top

--==================================================
-- BOTÃO
--==================================================

local function CreateButton(
    Text,
    Y,
    Background
)

    local Button =
        Instance.new("TextButton")

    Button.Size =
        UDim2.new(
            1,
            -20,
            0,
            38
        )

    Button.Position =
        UDim2.fromOffset(
            10,
            Y
        )

    Button.BackgroundColor3 =
        Background

    Button.BorderSizePixel = 0

    Button.Text = Text

    Button.TextColor3 =
        Color3.fromRGB(
            245,
            245,
            245
        )

    Button.TextSize = 13

    Button.Font =
        Enum.Font.GothamMedium

    Button.Parent = Main

    local Corner =
        Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(0, 6)

    Corner.Parent = Button

    return Button
end

--==================================================
-- BOTÕES
--==================================================

local BossButton =
    CreateButton(
        "📶 PARA BOTS: OFF",
        50,
        Color3.fromRGB(
            45,
            105,
            180
        )
    )

local ScanButton =
    CreateButton(
        "🔄 ATUALIZAR MAPA",
        94,
        Color3.fromRGB(
            70,
            80,
            100
        )
    )

local PetsButton =
    CreateButton(
        "🐾 PETS: OFF",
        138,
        Color3.fromRGB(
            65,
            85,
            105
        )
    )

local EggsButton =
    CreateButton(
        "🥚 OVOS: OFF",
        182,
        Color3.fromRGB(
            90,
            75,
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
        226
    )

Status.BackgroundTransparency = 1

Status.Text =
    "● Inicializando..."

Status.TextColor3 =
    Color3.fromRGB(
        75,
        200,
        115
    )

Status.TextSize = 12
Status.Font = Enum.Font.Gotham

Status.TextXAlignment =
    Enum.TextXAlignment.Left

Status.Parent = Main

--==================================================
-- LISTA
--==================================================

local List =
    Instance.new("ScrollingFrame")

List.Size =
    UDim2.new(
        1,
        -20,
        0,
        125
    )

List.Position =
    UDim2.fromOffset(
        10,
        255
    )

List.BackgroundColor3 =
    Color3.fromRGB(
        19,
        22,
        28
    )

List.BorderSizePixel = 0

List.ScrollBarThickness = 5

List.CanvasSize =
    UDim2.fromOffset(
        0,
        0
    )

List.Parent = Main

local Layout =
    Instance.new("UIListLayout")

Layout.Padding =
    UDim.new(
        0,
        2
    )

Layout.Parent = List

--==================================================
-- MOSTRAR DADOS
--==================================================

local function ClearList()

    for _, Object in ipairs(
        List:GetChildren()
    ) do

        if Object:IsA("TextLabel") then
            Object:Destroy()
        end
    end
end

local function AddLabel(Text)

    local Label =
        Instance.new("TextLabel")

    Label.Size =
        UDim2.new(
            1,
            -8,
            0,
            24
        )

    Label.BackgroundTransparency = 1

    Label.Text =
        Text

    Label.TextColor3 =
        Color3.fromRGB(
            230,
            230,
            230
        )

    Label.TextSize = 11
    Label.Font = Enum.Font.Gotham

    Label.TextXAlignment =
        Enum.TextXAlignment.Left

    Label.Parent = List
end

local function RefreshList()

    ClearList()

    if PetsEnabled then

        for _, Pet in ipairs(
            PetListData
        ) do

            AddLabel(
                "🐾 "
                .. Pet.Name
                .. " • "
                .. tostring(Pet.Value)
            )
        end

    elseif EggsButton:GetAttribute("Enabled") then

        for _, Egg in ipairs(
            EggList
        ) do

            AddLabel(
                "🥚 "
                .. Egg.Name
                .. " • "
                .. tostring(Egg.Rarity)
                .. " • "
                .. tostring(Egg.Value)
            )
        end

    elseif BossEnabled then

        for _, Boss in ipairs(
            BossList
        ) do

            AddLabel(
                "👑 "
                .. Boss.Name
                .. " • HP: "
                .. tostring(
                    math.floor(Boss.Health)
                )
            )
        end

    else

        AddLabel(
            "Ative uma opção para visualizar."
        )
    end

    List.CanvasSize =
        UDim2.fromOffset(
            0,
            Layout.AbsoluteContentSize.Y
                + 8
        )
end

--==================================================
-- FECHAR
--==================================================

Close.MouseButton1Click:Connect(
    function()

        Main.Visible = false
    end
)

--==================================================
-- BOTÃO PARA BOTS
--==================================================

BossButton.MouseButton1Click:Connect(
    function()

        BossEnabled =
            not BossEnabled

        if BossEnabled then

            BossButton.Text =
                "📶 PARA BOTS: ON"

            BossButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    150,
                    90
                )

            Status.Text =
                "● Rota dos chefes ativada"

            task.spawn(
                StartBossRoute
            )

        else

            BossButton.Text =
                "📶 PARA BOTS: OFF"

            BossButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    105,
                    180
                )

            StopBossRoute()

            Status.Text =
                "● Para Bots desligado"
        end

        RefreshList()
    end
)

--==================================================
-- ATUALIZAR MAPA
--==================================================

ScanButton.MouseButton1Click:Connect(
    function()

        Status.Text =
            "● Escaneando mapa..."

        UpdateData()

        Status.Text =
            "● Mapa atualizado"

        RefreshList()
    end
)

--==================================================
-- PETS
--==================================================

PetsButton.MouseButton1Click:Connect(
    function()

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

            Status.Text =
                "● Pets detectados"

        else

            PetsButton.Text =
                "🐾 PETS: OFF"

            PetsButton.BackgroundColor3 =
                Color3.fromRGB(
                    65,
                    85,
                    105
                )

            Status.Text =
                "● Conectado"
        end

        RefreshList()
    end
)

--==================================================
-- OVOS
--==================================================

EggsButton.MouseButton1Click:Connect(
    function()

        local Enabled =
            not EggsButton:GetAttribute(
                "Enabled"
            )

        EggsButton:SetAttribute(
            "Enabled",
            Enabled
        )

        if Enabled then

            EggsButton.Text =
                "🥚 OVOS: ON"

            EggsButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    150,
                    90
                )

            Status.Text =
                "● Ovos detectados"

        else

            EggsButton.Text =
                "🥚 OVOS: OFF"

            EggsButton.BackgroundColor3 =
                Color3.fromRGB(
                    90,
                    75,
                    105
                )

            Status.Text =
                "● Conectado"
        end

        RefreshList()
    end
)

--==================================================
-- ARRASTAR PAINEL
--==================================================

local Dragging = false
local DragStart
local StartPosition

Top.InputBegan:Connect(
    function(Input)

        if Input.UserInputType ==
            Enum.UserInputType.MouseButton1
        or Input.UserInputType ==
            Enum.UserInputType.Touch then

            Dragging = true

            DragStart =
                Input.Position

            StartPosition =
                Main.Position

            Input.Changed:Connect(
                function()

                    if Input.UserInputState ==
                        Enum.UserInputState.End then

                        Dragging = false
                    end
                end
            )
        end
    end
)

UserInputService.InputChanged:Connect(
    function(Input)

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
                    StartPosition.X.Offset
                        + Delta.X,

                    StartPosition.Y.Scale,
                    StartPosition.Y.Offset
                        + Delta.Y
                )
        end
    end
)

--==================================================
-- ATUALIZAÇÃO AUTOMÁTICA
--==================================================

task.spawn(
    function()

        while ScreenGui.Parent do

            UpdateData()

            if PetsEnabled
            or EggsButton:GetAttribute(
                "Enabled"
            )
            or BossEnabled then

                RefreshList()
            end

            task.wait(2)
        end
    end
)

--==================================================
-- INICIALIZAÇÃO
--==================================================

UpdateData()

Status.Text =
    "● Mapa detectado"

print("🪽 Seraphim-Hub carregado")
print(
    "🥚 Ovos encontrados: "
    .. #EggList
)

print(
    "🐾 Pets encontrados: "
    .. #PetListData
)

print(
    "👑 Chefes encontrados: "
    .. #BossList
)

print(
    "📶 Para Bots: "
    .. tostring(TELEPORT_TIME)
    .. " segundos"
)
