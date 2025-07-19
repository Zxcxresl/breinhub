-- ✅ Parte 3: Funciones + seguridad de carga

-- Esperar pestañas desde parte 2
repeat task.wait() until _G.BreinTabs and _G.BreinTabs.Main

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")

local gui = game:GetService("CoreGui"):FindFirstChild("BreinHub_UI")

-- Notificación visual al cargar
local notif = Instance.new("TextLabel", gui)
notif.Size = UDim2.new(0, 300, 0, 30)
notif.Position = UDim2.new(1, -310, 1, -40)
notif.Text = "✅ BreinHub cargado correctamente"
notif.TextColor3 = Color3.fromRGB(0, 170, 255)
notif.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
notif.Font = Enum.Font.GothamBold
notif.TextScaled = true
notif.BorderSizePixel = 0
task.delay(3, function() notif:Destroy() end)

warn("✅ BreinHub Part 3 cargado con éxito.")

-- Referencias a pestañas
local mainTab = _G.BreinTabs.Main
local combatTab = _G.BreinTabs.Combat
local motionTab = _G.BreinTabs.Motion
local infoTab = _G.BreinTabs.Info
local serverTab = _G.BreinTabs.Server

-- Función rápida para botones
local function createButton(parent, text, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0, 480, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.TextColor3 = Color3.fromRGB(0, 170, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Text = text
	btn.BorderColor3 = Color3.fromRGB(0, 170, 255)
	btn.AutoButtonColor = true
	btn.MouseButton1Click:Connect(callback)
	btn.Parent = parent
end

-- 📍 MAIN
local savedCFrame = nil

createButton(mainTab, "📍 Guardar Checkpoint", function()
	local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if root then
		savedCFrame = root.CFrame
	end
end)

createButton(mainTab, "🚀 Ir al Checkpoint", function()
	if savedCFrame then
		local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
		if root then
			root.CFrame = savedCFrame + Vector3.new(0, 3, 0)
		end
	end
end)

-- Botón "Ir" flotante
local gotoBtn = Instance.new("TextButton", gui)
gotoBtn.Size = UDim2.new(0, 60, 0, 25)
gotoBtn.Position = UDim2.new(1, -70, 0.5, -100)
gotoBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
gotoBtn.TextColor3 = Color3.new(0, 0, 0)
gotoBtn.Text = "📍 Ir"
gotoBtn.Font = Enum.Font.GothamBold
gotoBtn.TextSize = 14
gotoBtn.Visible = true
gotoBtn.MouseButton1Click:Connect(function()
	if savedCFrame then
		local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
		if root then root.CFrame = savedCFrame + Vector3.new(0, 3, 0) end
	end
end)

createButton(mainTab, "🛰️ Teleport a jugador aleatorio", function()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			lp.Character:PivotTo(plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0))
			break
		end
	end
end)

createButton(mainTab, "📋 Copiar nombre del juego", function()
	local info = MarketplaceService:GetProductInfo(game.PlaceId)
	setclipboard(info.Name)
end)

createButton(mainTab, "🔧 Próximamente...", function() end)

-- ⚔️ COMBAT
local espEnabled = false
local espColor = Color3.fromRGB(0, 170, 255)

createButton(combatTab, "👁️ Toggle ESP", function()
	espEnabled = not espEnabled
	if espEnabled then
		RunService:BindToRenderStep("BreinESP", Enum.RenderPriority.Last.Value, function()
			for _, plr in pairs(Players:GetPlayers()) do
				if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					if not gui:FindFirstChild("ESP_" .. plr.Name) then
						local tag = Instance.new("BillboardGui", gui)
						tag.Name = "ESP_" .. plr.Name
						tag.Adornee = plr.Character.HumanoidRootPart
						tag.Size = UDim2.new(0, 100, 0, 20)
						tag.AlwaysOnTop = true
						local lbl = Instance.new("TextLabel", tag)
						lbl.Size = UDim2.new(1, 0, 1, 0)
						lbl.BackgroundTransparency = 1
						lbl.Text = plr.DisplayName
						lbl.TextColor3 = espColor
						lbl.Font = Enum.Font.GothamBold
						lbl.TextScaled = true
					end
				end
			end
		end)
	else
		RunService:UnbindFromRenderStep("BreinESP")
		for _, v in pairs(gui:GetChildren()) do
			if v.Name:match("ESP_") then v:Destroy() end
		end
	end
end)

-- Aimbot externo
createButton(combatTab, "🎯 Activar Aimbot", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Zxcxresl/aimbotzxcz/main/aim.lua"))()
end)

-- TP Kill manual
createButton(combatTab, "💀 TP Kill (golpe manual)", function()
	local index = 1
	local list = {}

	for _, p in pairs(Players:GetPlayers()) do
		if p ~= lp then table.insert(list, p) end
	end

	local function tpToNext()
		if index > #list then
			warn("✅ Todos los jugadores fueron procesados.")
			return
		end
		local plr = list[index]
		index += 1
		if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			lp.Character:PivotTo(plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0))
		end
	end

	tpToNext()
	createButton(combatTab, "⏭ Saltar Jugador", tpToNext)
end)

-- 🕹 MOTION
createButton(motionTab, "🛸 Fly (joystick)", function()
	local flyConn
	local hum = lp.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.PlatformStand = true end
	flyConn = RunService.RenderStepped:Connect(function()
		local root = lp.Character:FindFirstChild("HumanoidRootPart")
		if root then
			local moveDir = lp.Character.Humanoid.MoveDirection
			root.Velocity = moveDir * 50
		end
	end)
	task.delay(10, function() flyConn:Disconnect() end)
end)

createButton(motionTab, "🚪 NoClip", function()
	local toggled = false
	toggled = not toggled
	RunService.Stepped:Connect(function()
		if toggled and lp.Character then
			for _, v in pairs(lp.Character:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end
	end)
end)

createButton(motionTab, "🏃 Toggle Speed", function()
	local hum = lp.Character and lp.Character:FindFirstChild("Humanoid")
	if hum then
		hum.WalkSpeed = hum.WalkSpeed == 16 and 50 or 16
	end
end)

-- ℹ️ INFO
createButton(infoTab, "👤 Usuario: " .. lp.DisplayName, function() end)
createButton(infoTab, "🕹 Juego: " .. MarketplaceService:GetProductInfo(game.PlaceId).Name, function() end)
createButton(infoTab, "🆔 Server ID: " .. game.JobId, function() end)
createButton(infoTab, "❤️ Vida: (en vivo)", function() end)
createButton(infoTab, "🔑 Clave: Infinita", function() end)

-- 🔁 SERVER
createButton(serverTab, "🔄 Rejoin Server", function()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
end)

createButton(serverTab, "🆕 Server Hop", function()
	local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=2&limit=100")).data
	for _, v in pairs(servers) do
		if v.playing < v.maxPlayers then
			TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, lp)
			break
		end
	end
end)

createButton(serverTab, "🔗 Copiar ID del server", function()
	setclipboard(game.JobId)
end)