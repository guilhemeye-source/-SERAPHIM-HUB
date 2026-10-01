--// 🪽 SERAPHIM HUB
--// Versão para Roblox Studio / seu próprio jogo

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- CONFIGURAÇÃO DOS PETS
--==================================================

local PET_VALUES = {
	["ArchAngel"] = 1000,
	["World Burner"] = 999,
	["World Eater"] = 999,
	["Pegasus"] = 950,
	["Kitsune"] = 900,
	["Cosmic Dragon"] = 850,
	["Unicorn"] = 800,
	["Phoenix"] = 750,
	["Leviathan"] = 700,
	["Kraken"] = 680,
	["Gorilla King"] = 650,
	["Angel Guardian"] = 600,
	["Demon Hound"] = 590,
	["Ice Dragon"] = 580,
	["T-Rex"] = 570,
	["Mosasaurus"] = 560,
	["Titan Golem"] = 550,
	["Night Flame"] = 540,
	["Nightflame"] = 540,
	["Royal Sphinx"] = 500,
	["Cosmic Royal Sphinx"] = 520,
	["Cosmic Skeleton King"] = 510,
	["Skeletal Sabertooth"] = 500,
	["Gargoyle"] = 480,
	["RazorFang"] = 470,
	["Skeleton Horse"] = 460,
	["World Burner"] = 450,
	["Cerberus"] = 440,
	["Sacred Moth"] = 430,
	["Holy Peacock"] = 420,
	["Pure Jellyfish"] = 410,
	["Centaur"] = 400,
	["Toro"] = 390,
	["Imp"] = 380,
	["Flame Sprite"] = 370,
	["Stag"] = 350,
	["Oni Tiger"] = 340,
	["Jaguar"] = 330,
	["Tiger"] = 320,
	["Crocodile"] = 310,
	["King Snake"] = 300,
	["Yeti"] = 290,
	["King Mammoth"] = 280,
	["Polar Bear"] = 270,
	["Seal"] = 260,
	["Penguin"] = 250,
	["Shark"] = 240,
	["Octopus"] = 230,
	["Whale Shark"] = 220,
	["Beluga Whale"] = 210,
	["Alien"] = 200,
	["Raptor"] = 190,
	["Triceratops"] = 180,
	["Sand Spider"] = 170,
	["Scorpion"] = 160,
	["Snake"] = 150,
	["Fennec"] = 140,
	["Camel"] = 130,
	["Jerboa"] = 120,
	["Chimpanzee"] = 110,
	["Monkey"] = 100,
	["Sloth"] = 90,
	["Parrot"] = 80,
	["Turtle"] = 70,
	["Swan"] = 60,
	["Axolotl"] = 55,
	["Frog"] = 50,
	["Duckling"] = 45,
	["Catfish"] = 40,
	["Raccoon"] = 35,
	["Fox"] = 30,
	["Bear"] = 25,
	["Owl"] = 20,
	["Bird"] = 15,
	["Dog"] = 10,
	["Chicken"] = 5,
}

local PET_NAMES = {}

for nome in pairs(PET_VALUES) do
	PET_NAMES[nome] = true
end

--==================================================
-- CHEFES
--==================================================

local Chefes = {
	["ChickenBoss"] = true,
	["AnubisBoss"] = true,
	["SharkBoss"] = true,
	["MagmaGolem"] = true,
	["GummyBear"] = true,
	["DungeonBoss"] = true,
	["DemonGuardian"] = true,
	["AngelGuardian"] = true,
	["DrScrambleBoss"] = true
}

local function verificarSeEChefe(objeto)
	if not objeto then
		return false
	end

	return Chefes[objeto.Name] == true
end

local function pegarPosicaoDoChefe(chefe)
	if not chefe or not chefe.Parent then
		return nil
	end

	if chefe:IsA("BasePart") then
		return chefe.CFrame
	end

	if chefe:IsA("Model") then
		local parte =
			chefe.PrimaryPart
			or chefe:FindFirstChild("HumanoidRootPart", true)
			or chefe:FindFirstChildWhichIsA("BasePart", true)

		if parte then
			return parte.CFrame
		end
	end

	return nil
end

local function encontrarChefes()
	local encontrados = {}
	local nomesEncontrados = {}

	for _, objeto in ipairs(workspace:GetDescendants()) do

		if verificarSeEChefe(objeto) then

			if not nomesEncontrados[objeto.Name] then

				local cframe = pegarPosicaoDoChefe(objeto)

				if cframe then

					nomesEncontrados[objeto.Name] = true

					table.insert(encontrados, {
						Objeto = objeto,
						CFrame = cframe
					})

				end
			end
		end
	end

	return encontrados
end

--==================================================
-- GUI
--==================================================

local antigo = PlayerGui:FindFirstChild("SeraphimHub")

if antigo then
	antigo:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SeraphimHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

--==================================================
-- JANELA PRINCIPAL
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 300, 0, 390)
Main.Position = UDim2.new(0.5, -150, 0.5, -195)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

--==================================================
-- TOPO
--==================================================

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -55, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🪽 SERAPHIM HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

--==================================================
-- BOTÃO X
--==================================================

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.new(0, 35, 0, 35)
Close.Position = UDim2.new(1, -40, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
Close.BorderSizePixel = 0
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 16
Close.Font = Enum.Font.GothamBold
Close.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = Close

--==================================================
-- STATUS
--==================================================

local Status = Instance.new("TextLabel")
Status.Name = "Status"
Status.Size = UDim2.new(1, -20, 0, 35)
Status.Position = UDim2.new(0, 10, 0, 55)
Status.BackgroundTransparency = 1
Status.Text = "🟢 Seraphim Hub pronto"
Status.TextColor3 = Color3.fromRGB(210, 210, 210)
Status.TextSize = 13
Status.Font = Enum.Font.Gotham
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Main

--==================================================
-- BOTÃO PARA BOTS
--==================================================

local ParaBots = Instance.new("TextButton")
ParaBots.Name = "ParaBots"
ParaBots.Size = UDim2.new(1, -20, 0, 45)
ParaBots.Position = UDim2.new(0, 10, 0, 92)
ParaBots.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ParaBots.BorderSizePixel = 0
ParaBots.Text = "📶 PARA BOTS"
ParaBots.TextColor3 = Color3.fromRGB(255, 255, 255)
ParaBots.TextSize = 14
ParaBots.Font = Enum.Font.GothamBold
ParaBots.Parent = Main

local ParaBotsCorner = Instance.new("UICorner")
ParaBotsCorner.CornerRadius = UDim.new(0, 8)
ParaBotsCorner.Parent = ParaBots

--==================================================
-- BOTÃO PETS
--==================================================

local PetsButton = Instance.new("TextButton")
PetsButton.Name = "PetsButton"
PetsButton.Size = UDim2.new(1, -20, 0, 45)
PetsButton.Position = UDim2.new(0, 10, 0, 145)
PetsButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
PetsButton.BorderSizePixel = 0
PetsButton.Text = "🐾 PETS: OFF"
PetsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PetsButton.TextSize = 14
PetsButton.Font = Enum.Font.GothamBold
PetsButton.Parent = Main

local PetsCorner = Instance.new("UICorner")
PetsCorner.CornerRadius = UDim.new(0, 8)
PetsCorner.Parent = PetsButton

--==================================================
-- LISTA DE PETS
--==================================================

local PetList = Instance.new("ScrollingFrame")
PetList.Name = "PetList"
PetList.Size = UDim2.new(1, -20, 0, 190)
PetList.Position = UDim2.new(0, 10, 0, 198)
PetList.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
PetList.BorderSizePixel = 0
PetList.ScrollBarThickness = 5
PetList.CanvasSize = UDim2.new(0, 0, 0, 0)
PetList.Visible = false
PetList.Parent = Main

local PetCorner = Instance.new("UICorner")
PetCorner.CornerRadius = UDim.new(0, 8)
PetCorner.Parent = PetList

local PetLayout = Instance.new("UIListLayout")
PetLayout.Padding = UDim.new(0, 3)
PetLayout.SortOrder = Enum.SortOrder.LayoutOrder
PetLayout.Parent = PetList

--==================================================
-- ARRASTAR JANELA
--==================================================

local Arrastando = false
local InicioMouse
local InicioPos

TopBar.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		Arrastando = true
		InicioMouse = input.Position
		InicioPos = Main.Position

	end
end)

TopBar.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		Arrastando = false

	end
end)

UserInputService.InputChanged:Connect(function(input)

	if not Arrastando then
		return
	end

	if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	local Delta = input.Position - InicioMouse

	Main.Position = UDim2.new(
		InicioPos.X.Scale,
		InicioPos.X.Offset + Delta.X,
		InicioPos.Y.Scale,
		InicioPos.Y.Offset + Delta.Y
	)
end)

--==================================================
-- BOTÃO CIRCULAR PARA REABRIR
--==================================================

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 55, 0, 55)
OpenButton.Position = UDim2.new(0, 20, 0.5, -27)
OpenButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
OpenButton.BorderSizePixel = 0
OpenButton.Text = "🪽"
OpenButton.TextSize = 22
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenButton

Close.MouseButton1Click:Connect(function()
	Main.Visible = false
	OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
	Main.Visible = true
	OpenButton.Visible = false
end)

--==================================================
-- PETS
--==================================================

local function limparListaPets()

	for _, objeto in ipairs(PetList:GetChildren()) do

		if objeto:IsA("TextLabel") then
			objeto:Destroy()
		end

	end
end

local function adicionarPet(nome, ordem)

	local Label = Instance.new("TextLabel")

	Label.Size = UDim2.new(1, -10, 0, 28)
	Label.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
	Label.BorderSizePixel = 0

	Label.Text =
		"🐾 " ..
		nome ..
		"  |  x" ..
		tostring(PET_VALUES[nome] or 0)

	Label.TextColor3 = Color3.fromRGB(235, 235, 235)
	Label.TextSize = 12
	Label.Font = Enum.Font.Gotham
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.LayoutOrder = ordem
	Label.Parent = PetList

	local Padding = Instance.new("UIPadding")
	Padding.PaddingLeft = UDim.new(0, 8)
	Padding.Parent = Label
end

local function atualizarListaPets()

	limparListaPets()

	local Lista = {}

	for nome in pairs(PET_NAMES) do
		table.insert(Lista, nome)
	end

	table.sort(Lista, function(a, b)

		local valorA = PET_VALUES[a] or 0
		local valorB = PET_VALUES[b] or 0

		if valorA == valorB then
			return a < b
		end

		return valorA > valorB
	end)

	for indice, nome in ipairs(Lista) do
		adicionarPet(nome, indice)
	end

	task.wait()

	PetList.CanvasSize = UDim2.new(
		0,
		0,
		0,
		PetLayout.AbsoluteContentSize.Y + 10
	)
end

--==================================================
-- IDENTIFICADOR DE PETS
--==================================================

local function procurarPetsNoObjeto(objeto, encontrados)

	if not objeto then
		return
	end

	for _, filho in ipairs(objeto:GetDescendants()) do

		if PET_NAMES[filho.Name] then
			encontrados[filho.Name] = true
		end

		local atributos = filho:GetAttributes()

		for chave, valor in pairs(atributos) do

			if typeof(valor) == "string" and PET_NAMES[valor] then
				encontrados[valor] = true
			end

			if chave == "Pet"
				and typeof(valor) == "string"
				and PET_NAMES[valor] then

				encontrados[valor] = true
			end

			if chave == "PetName"
				and typeof(valor) == "string"
				and PET_NAMES[valor] then

				encontrados[valor] = true
			end
		end
	end
end

local function identificarPets()

	Status.Text = "🔎 Procurando pets..."

	local encontrados = {}

	-- Workspace
	procurarPetsNoObjeto(workspace, encontrados)

	-- ReplicatedStorage
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	procurarPetsNoObjeto(ReplicatedStorage, encontrados)

	-- Player
	procurarPetsNoObjeto(Player, encontrados)

	if next(encontrados) == nil then

		Status.Text = "⚠️ Nenhum pet identificado"

		return
	end

	Status.Text =
		"🐾 " ..
		tostring(#(function()
			local lista = {}

			for nome in pairs(encontrados) do
				table.insert(lista, nome)
			end

			return lista
		end)()) ..
		" pets identificados"

end

--==================================================
-- BOTÃO PETS
--==================================================

local PetsAtivo = false

PetsButton.MouseButton1Click:Connect(function()

	PetsAtivo = not PetsAtivo

	if PetsAtivo then

		PetsButton.Text = "🐾 PETS: ON"
		PetList.Visible = true

		atualizarListaPets()
		identificarPets()

	else

		PetsButton.Text = "🐾 PETS: OFF"
		PetList.Visible = false

		Status.Text = "🟢 Seraphim Hub pronto"
	end
end)

--==================================================
-- PARA BOTS
--==================================================

local Teleportando = false

local function TeleportarParaBots()

	if Teleportando then
		return
	end

	local Character = Player.Character

	if not Character then
		Status.Text = "❌ Personagem não encontrado"
		return
	end

	local Root = Character:FindFirstChild("HumanoidRootPart")

	if not Root then
		Status.Text = "❌ HumanoidRootPart não encontrado"
		return
	end

	local chefes = encontrarChefes()

	if #chefes == 0 then

		Status.Text = "❌ Nenhum chefe encontrado"

		return
	end

	Teleportando = true

	for indice, dados in ipairs(chefes) do

		if not Teleportando then
			break
		end

		-- Atualiza a posição caso o chefe tenha se movido
		local novaPosicao = pegarPosicaoDoChefe(dados.Objeto)

		if novaPosicao then
			dados.CFrame = novaPosicao
		end

		local distancia =
			(Root.Position - dados.CFrame.Position).Magnitude

		-- Se já estiver nessa área, pula
		if distancia <= 25 then

			Status.Text =
				"⏭️ Já está em: " ..
				dados.Objeto.Name

		else

			Status.Text =
				"📶 Chefe " ..
				tostring(indice) ..
				"/" ..
				tostring(#chefes) ..
				": " ..
				dados.Objeto.Name

			-- TELEPORTE DIRETO
			Root.CFrame =
				dados.CFrame + Vector3.new(0, 5, 0)

		end

		-- Pequena pausa apenas para permitir a atualização da interface.
		-- NÃO é espera de 5 segundos.
		task.wait()

	end

	-- Para completamente no último chefe
	Teleportando = false

	Status.Text = "✅ Último chefe alcançado"

end

ParaBots.MouseButton1Click:Connect(function()

	TeleportarParaBots()

end)

--==================================================
-- FINAL
--==================================================

atualizarListaPets()

print("🪽 SERAPHIM HUB carregado com sucesso.")
