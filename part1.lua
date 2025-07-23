-- Infinix Cheats Hub | by Lua GOD and Zxcx

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Day = tonumber(os.date("%d"))
local Expired = Day >= 30

if Expired then
	Rayfield:Notify({
		Title = "Key Expirada",
		Content = "La key gratuita ha expirado. Espera próxima actualización.",
		Duration = 8
	})
	return
end

local Window = Rayfield:CreateWindow({
	Name = "Infinix Cheats - Universal",
	LoadingTitle = "Infinix Cheats",
	LoadingSubtitle = "Cargando interfaz...",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "InfinixCheatsHub",
		FileName = "InfinixUI"
	},
	KeySystem = true,
	KeySettings = {
		Title = "Infinix Cheats | Key System",
		Subtitle = "Sistema de acceso gratuito",
		Note = "Tu key gratuita es: infinix (válida hasta el día 29)",
		FileName = "InfinixKeyFile",
		SaveKey = true,
		GrabKeyFromSite = false,
		Key = {"infinix"}
	}
})

local CreditsTab = Window:CreateTab("🧠 Créditos", nil)

CreditsTab:CreateParagraph({Title = "Autores", Content = "Script por Lua GOD 🤖 y Zxcx 🎯"})
CreditsTab:CreateParagraph({
	Title = "Infinix Cheats",
	Content = "Key válida hasta el día 29 del mes actual.\nKey actual: infinix"
})

-- AQUI VA LA PARTE 3 🔽
local MainTab = Window:CreateTab("⚙️ Main", nil)

MainTab:CreateParagraph({Title = "Herramientas principales", Content = "TP vertical, autoclicker, y más."})

-- TP Arriba
local upAmount = 10
MainTab:CreateSlider({
	Name = "Subir (UP)",
	Range = {1, 100},
	Increment = 1,
	Default = 10,
	Callback = function(Value)
		upAmount = Value
	end
})

MainTab:CreateButton({
	Name = "TP ↑ Subir",
	Callback = function()
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char:PivotTo(char:GetPivot() * CFrame.new(0, upAmount, 0))
		end
	end
})

-- TP Abajo
local downAmount = 10
MainTab:CreateSlider({
	Name = "Bajar (DOWN)",
	Range = {1, 100},
	Increment = 1,
	Default = 10,
	Callback = function(Value)
		downAmount = Value
	end
})

MainTab:CreateButton({
	Name = "TP ↓ Bajar",
	Callback = function()
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char:PivotTo(char:GetPivot() * CFrame.new(0, -downAmount, 0))
		end
	end
})

-- Auto Clicker
getgenv().AutoClick = false
MainTab:CreateToggle({
	Name = "AutoClicker",
	CurrentValue = false,
	Callback = function(Value)
		getgenv().AutoClick = Value
		while getgenv().AutoClick do
			task.wait(0.1)
			mouse1click()
		end
	end
})

-- Extra útil: AntiAFK
MainTab:CreateButton({
	Name = "Activar Anti-AFK",
	Callback = function()
		local vu = game:service("VirtualUser")
		game:service("Players").LocalPlayer.Idled:connect(function()
			vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
			task.wait(1)
			vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
		end)
	end
})

-- AQUI VA LA PARTE 4 🔽
local TPSTab = Window:CreateTab("🌀 TPs", nil)

-- TP a Jugador
local selectedPlayer = nil
TPSTab:CreateDropdown({
	Name = "Seleccionar jugador para TP",
	Options = {},
	Callback = function(Value)
		selectedPlayer = Value
	end
})

TPSTab:CreateButton({
	Name = "Teletransportarse al jugador seleccionado",
	Callback = function()
		local char = game.Players.LocalPlayer.Character
		if char and selectedPlayer and game.Players:FindFirstChild(selectedPlayer) then
			local target = game.Players[selectedPlayer].Character
			if target and target:FindFirstChild("HumanoidRootPart") then
				char:PivotTo(target.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0))
			end
		end
	end
})

-- Actualizar lista de jugadores
local function UpdatePlayersList()
	local players = {}
	for i, plr in pairs(game.Players:GetPlayers()) do
		if plr ~= game.Players.LocalPlayer then
			table.insert(players, plr.Name)
		end
	end
	return players
end

-- Actualizar dropdown de jugadores cada 10 segundos
task.spawn(function()
	while true do
		task.wait(10)
		TPSTab:UpdateDropdownOptions("Seleccionar jugador para TP", UpdatePlayersList())
	end
end)

-- Checkpoint
local checkpoint = nil

TPSTab:CreateButton({
	Name = "Guardar checkpoint",
	Callback = function()
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			checkpoint = char.HumanoidRootPart.CFrame
			Rayfield:Notify({
				Title = "Checkpoint",
				Content = "Posición guardada correctamente.",
				Duration = 4
			})
		end
	end
})

TPSTab:CreateButton({
	Name = "Ir a checkpoint",
	Callback = function()
		local char = game.Players.LocalPlayer.Character
		if char and checkpoint then
			char:PivotTo(checkpoint)
		end
	end
})

-- Botón flotante en pantalla para ir a checkpoint
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "CheckpointUI"

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 100, 0, 40)
button.Position = UDim2.new(1, -110, 1, -50)
button.Text = "TP Checkpoint"
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 14
button.Font = Enum.Font.SourceSansBold
button.Parent = screenGui

button.MouseButton1Click:Connect(function()
	if checkpoint then
		local char = game.Players.LocalPlayer.Character
		if char then
			char:PivotTo(checkpoint)
		end
	end
end)

-- TP Kill (manual ejecución)
local playersQueue = {}
local currentTarget = nil
local killing = false

TPSTab:CreateButton({
	Name = "Iniciar TP Kill",
	Callback = function()
		playersQueue = {}
		for _, p in ipairs(game.Players:GetPlayers()) do
			if p ~= game.Players.LocalPlayer then
				table.insert(playersQueue, p)
			end
		end
		killing = true
		Rayfield:Notify({
			Title = "TP Kill",
			Content = "Iniciado. Usa espada manualmente.",
			Duration = 6
		})

		task.spawn(function()
			while killing and #playersQueue > 0 do
				local char = game.Players.LocalPlayer.Character
				currentTarget = table.remove(playersQueue, 1)
				if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
					char:PivotTo(currentTarget.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0))
				end
				wait(2.5)
			end
		end)
	end
})

TPSTab:CreateButton({
	Name = "Saltar jugador actual",
	Callback = function()
		currentTarget = nil
	end
})

TPSTab:CreateButton({
	Name = "Detener TP Kill",
	Callback = function()
		killing = false
		Rayfield:Notify({
			Title = "TP Kill",
			Content = "Detenido correctamente.",
			Duration = 4
		})
	end
})

-- TP al top leaderboard (asume que hay tabla con jugadores ordenados)
TPSTab:CreateButton({
	Name = "TP al jugador top (Primero en lista)",
	Callback = function()
		local players = game.Players:GetPlayers()
		if #players > 1 then
			local target = players[2] -- [1] = LocalPlayer
			if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
				local char = game.Players.LocalPlayer.Character
				char:PivotTo(target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0))
			end
		end
	end
})

-- AQUI VA LA PARTE 5 🔽
-- AQUI VA LA PARTE 5 🔽

local CombatTab = Window:CreateTab("⚔️ Combat", nil)

-- AIMBOT CLÁSICO
local aiming = false
local aimPart = "Head"

CombatTab:CreateToggle({
	Name = "Aimbot (Centro cabeza)",
	CurrentValue = false,
	Callback = function(state)
		aiming = state
	end
})

game:GetService("RunService").RenderStepped:Connect(function()
	if aiming then
		local closest = nil
		local shortestDistance = math.huge
		for _, p in pairs(game.Players:GetPlayers()) do
			if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild(aimPart) then
				local pos = p.Character[aimPart].Position
				local distance = (game.Workspace.CurrentCamera.CFrame.Position - pos).magnitude
				if distance < shortestDistance then
					shortestDistance = distance
					closest = p
				end
			end
		end
		if closest then
			game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.Position, closest.Character[aimPart].Position)
		end
	end
end)

-- Aimbot externo (basado en script externo)
CombatTab:CreateButton({
	Name = "Aimbot Externo (📦 Zxcxresl)",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Zxcxresl/aimbotzxcz/main/aim.lua"))()
	end
})

-- Aimbot al más cercano (usando Distance)
CombatTab:CreateButton({
	Name = "Aimbot al jugador más cercano",
	Callback = function()
		local closest = nil
		local shortestDistance = math.huge
		for _, p in ipairs(game.Players:GetPlayers()) do
			if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
				local distance = (p.Character.Head.Position - game.Players.LocalPlayer.Character.Head.Position).Magnitude
				if distance < shortestDistance then
					shortestDistance = distance
					closest = p
				end
			end
		end
		if closest then
			game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.Position, closest.Character.Head.Position)
			Rayfield:Notify({
				Title = "Aimbot Cercano",
				Content = "Apuntando a " .. closest.Name,
				Duration = 3
			})
		end
	end
})

-- Kill Aura
local auraEnabled = false
local auraRange = 10

CombatTab:CreateToggle({
	Name = "KillAura",
	CurrentValue = false,
	Callback = function(state)
		auraEnabled = state
	end
})

task.spawn(function()
	while true do
		task.wait(0.2)
		if auraEnabled then
			local char = game.Players.LocalPlayer.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				for _, p in pairs(game.Players:GetPlayers()) do
					if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
						local target = p.Character
						if (target.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude <= auraRange then
							for _, tool in ipairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
								if tool:IsA("Tool") then
									tool.Parent = char
									tool:Activate()
								end
							end
						end
					end
				end
			end
		end
	end
end)

-- God Mode básico
CombatTab:CreateButton({
	Name = "God Mode (experimental)",
	Callback = function()
		local char = game.Players.LocalPlayer.Character
		if char:FindFirstChild("Humanoid") then
			char.Humanoid.Name = "God"
			local clone = char.Humanoid:Clone()
			clone.Parent = char
			clone.Name = "Humanoid"
			wait(0.1)
			char:FindFirstChild("God"):Destroy()
			Rayfield:Notify({
				Title = "God Mode",
				Content = "Intento de God Mode aplicado",
				Duration = 4
			})
		end
	end
})

-- AQUI VA LA PARTE 6 🔽
-- AQUI VA LA PARTE 6 🔽

local MovementTab = Window:CreateTab("🏃 Movement", nil)

-- Speed Personalizado
local speedEnabled = false
local speedValue = 50

MovementTab:CreateToggle({
	Name = "Speed",
	CurrentValue = false,
	Callback = function(state)
		speedEnabled = state
	end
})

MovementTab:CreateSlider({
	Name = "Speed Valor",
	Range = {16, 200},
	Increment = 1,
	CurrentValue = 50,
	Callback = function(val)
		speedValue = val
	end
})

game:GetService("RunService").Heartbeat:Connect(function()
	if speedEnabled and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speedValue
	else
		if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
		end
	end
end)

-- Fly Clásico
local flyEnabled = false
MovementTab:CreateToggle({
	Name = "Fly clásico",
	CurrentValue = false,
	Callback = function(state)
		flyEnabled = state
	end
})

task.spawn(function()
	local UIS = game:GetService("UserInputService")
	while true do
		task.wait()
		if flyEnabled then
			local char = game.Players.LocalPlayer.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				char.HumanoidRootPart.Velocity = Vector3.new(0, 100, 0)
			end
		end
	end
end)

-- Flotad (fly mirando dirección)
local floatEnabled = false
MovementTab:CreateToggle({
	Name = "Flotar (mirando dirección)",
	CurrentValue = false,
	Callback = function(state)
		floatEnabled = state
	end
})

task.spawn(function()
	while true do
		task.wait()
		if floatEnabled then
			local char = game.Players.LocalPlayer.Character
			local cam = game.Workspace.CurrentCamera
			if char and cam and char:FindFirstChild("HumanoidRootPart") then
				local dir = cam.CFrame.LookVector * 50
				char.HumanoidRootPart.Velocity = Vector3.new(dir.X, 0, dir.Z)
			end
		end
	end
end)

-- No Clip básico
local noclipEnabled = false
MovementTab:CreateToggle({
	Name = "No Clip",
	CurrentValue = false,
	Callback = function(state)
		noclipEnabled = state
	end
})

game:GetService("RunService").Stepped:Connect(function()
	if noclipEnabled then
		for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BasePart") and v.CanCollide then
				v.CanCollide = false
			end
		end
	end
end)

-- No Clip Bypass (experimental)
local bypassEnabled = false
MovementTab:CreateToggle({
	Name = "Noclip Bypass (experimental)",
	CurrentValue = false,
	Callback = function(state)
		bypassEnabled = state
	end
})

task.spawn(function()
	while true do
		task.wait(0.3)
		if bypassEnabled then
			local lp = game.Players.LocalPlayer
			if lp and lp.Character then
				for _, v in pairs(lp.Character:GetDescendants()) do
					if v:IsA("BasePart") then
						v.Velocity = Vector3.new(0, 0, 0)
						v.CanCollide = false
					end
				end
			end
		end
	end
end)

-- Anti-Fall
MovementTab:CreateButton({
	Name = "Activar Anti-Caídas",
	Callback = function()
		local lp = game.Players.LocalPlayer
		local root = lp.Character:FindFirstChild("HumanoidRootPart")
		if root then
			local antiPart = Instance.new("Part", workspace)
			antiPart.Anchored = true
			antiPart.Size = Vector3.new(1000, 1, 1000)
			antiPart.Position = Vector3.new(0, -10, 0)
			antiPart.Transparency = 1
			antiPart.Name = "AntiFall"
			Rayfield:Notify({
				Title = "Anti-Caída",
				Content = "Se colocó una base invisible",
				Duration = 3
			})
		end
	end
})

-- AQUI VA LA PARTE 7 🔽
-- AQUI VA LA PARTE 7 🔽

local BoostsTab = Window:CreateTab("⚡ Boosts", nil)

-- Boost Jump
local jumpBoostEnabled = false
local jumpPowerValue = 75

BoostsTab:CreateToggle({
	Name = "Boost Jump",
	CurrentValue = false,
	Callback = function(state)
		jumpBoostEnabled = state
		if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
			if state then
				game.Players.LocalPlayer.Character.Humanoid.JumpPower = jumpPowerValue
			else
				game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
			end
		end
	end
})

BoostsTab:CreateSlider({
	Name = "Jump Power",
	Range = {50, 200},
	Increment = 5,
	CurrentValue = 75,
	Callback = function(val)
		jumpPowerValue = val
		if jumpBoostEnabled and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
			game.Players.LocalPlayer.Character.Humanoid.JumpPower = val
		end
	end
})

-- Boost Speed
local boostSpeedEnabled = false
local boostSpeedValue = 35

BoostsTab:CreateToggle({
	Name = "Boost Speed",
	CurrentValue = false,
	Callback = function(state)
		boostSpeedEnabled = state
		if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
			if state then
				game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = boostSpeedValue
			else
				game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
			end
		end
	end
})

BoostsTab:CreateSlider({
	Name = "Speed Boost",
	Range = {16, 100},
	Increment = 2,
	CurrentValue = 35,
	Callback = function(val)
		boostSpeedValue = val
		if boostSpeedEnabled and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
		end
	end
})

-- Turbo Temporal
BoostsTab:CreateButton({
	Name = "Activar Turbo x5s",
	Callback = function()
		local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
		if hum then
			local oldSpeed = hum.WalkSpeed
			local oldJump = hum.JumpPower
			hum.WalkSpeed = 100
			hum.JumpPower = 150
			Rayfield:Notify({
				Title = "TURBO ACTIVADO",
				Content = "Velocidad y salto aumentados por 5 segundos",
				Duration = 5
			})
			task.wait(5)
			hum.WalkSpeed = boostSpeedEnabled and boostSpeedValue or 16
			hum.JumpPower = jumpBoostEnabled and jumpPowerValue or 50
		end
	end
})

-- AQUI VA LA PARTE 8 🔽

local InfoTab = Window:CreateTab("ℹ️ Info", nil)

-- Info básica del jugador
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

InfoTab:CreateParagraph({Title = "Nombre de Usuario", Content = LocalPlayer.Name})
InfoTab:CreateParagraph({Title = "Display Name", Content = LocalPlayer.DisplayName})
InfoTab:CreateParagraph({Title = "UserId", Content = tostring(LocalPlayer.UserId)})
InfoTab:CreateParagraph({Title = "Juego Actual", Content = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name})
InfoTab:CreateParagraph({Title = "ID del Juego", Content = tostring(game.PlaceId)})

-- Copiar nombre del juego
InfoTab:CreateButton({
	Name = "📋 Copiar Nombre del Juego",
	Callback = function()
		local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
		setclipboard(info.Name)
		Rayfield:Notify({
			Title = "Copiado",
			Content = "Nombre del juego copiado al portapapeles.",
			Duration = 4
		})
	end
})

-- SERVER TAB
local ServerTab = Window:CreateTab("🌐 Servidor", nil)
local TeleportService = game:GetService("TeleportService")

-- Server Rejoin
ServerTab:CreateButton({
	Name = "🔁 Reunirse al servidor actual",
	Callback = function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
	end
})

-- Server Hop
ServerTab:CreateButton({
	Name = "🌍 Server Hop (aleatorio)",
	Callback = function()
		local HttpService = game:GetService("HttpService")
		local servers = {}
		local req = syn and syn.request or request
		local response = req({
			Url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
		})
		local data = HttpService:JSONDecode(response.Body)
		for _, v in pairs(data.data) do
			if v.playing < v.maxPlayers and v.id ~= game.JobId then
				table.insert(servers, v.id)
			end
		end
		if #servers > 0 then
			local serverId = servers[math.random(1, #servers)]
			TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, LocalPlayer)
		else
			Rayfield:Notify({
				Title = "Error",
				Content = "No se encontraron servidores disponibles.",
				Duration = 5
			})
		end
	end
})

-- Server ID Copy
ServerTab:CreateButton({
	Name = "📋 Copiar ID del servidor actual",
	Callback = function()
		setclipboard(game.JobId)
		Rayfield:Notify({
			Title = "Copiado",
			Content = "ID del servidor copiado al portapapeles.",
			Duration = 3
		})
	end
})

-- Join por ID
ServerTab:CreateInput({
	Name = "Unirse por ID del servidor",
	PlaceholderText = "Ingresa un JobId válido",
	RemoveTextAfterFocusLost = false,
	Callback = function(serverId)
		TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, LocalPlayer)
	end
})