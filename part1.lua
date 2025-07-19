if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

local gui = Instance.new("ScreenGui", gethui and gethui() or lp:WaitForChild("PlayerGui"))
gui.Name = "BreinHub_UI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

-- Animación de texto inicial "Brein Hub"
local introText = Instance.new("TextLabel", gui)
introText.Size = UDim2.new(1, 0, 1, 0)
introText.Text = "💠 Brein Hub 💠"
introText.TextColor3 = Color3.fromRGB(0, 170, 255)
introText.Font = Enum.Font.GothamBlack
introText.TextScaled = true
introText.BackgroundTransparency = 1

TweenService:Create(introText, TweenInfo.new(1), {TextTransparency = 0}):Play()
wait(1.2)
TweenService:Create(introText, TweenInfo.new(1), {TextTransparency = 1}):Play()
wait(1.2)
introText:Destroy()

-- Panel de clave
local keyFrame = Instance.new("Frame", gui)
keyFrame.Size = UDim2.new(0, 400, 0, 220)
keyFrame.Position = UDim2.new(0.5, -200, 0.5, -110)
keyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
keyFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", keyFrame)
title.Text = "🔐 Bienvenido a Brein Hub"
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local input = Instance.new("TextBox", keyFrame)
input.PlaceholderText = "Introduce tu key aquí"
input.Text = ""
input.Size = UDim2.new(0.8, 0, 0, 35)
input.Position = UDim2.new(0.1, 0, 0.5, -15)
input.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
input.TextColor3 = Color3.fromRGB(0, 170, 255)
input.Font = Enum.Font.Gotham
input.TextScaled = true
Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)

local submit = Instance.new("TextButton", keyFrame)
submit.Text = "Entrar"
submit.Size = UDim2.new(0.4, 0, 0, 30)
submit.Position = UDim2.new(0.3, 0, 0.7, 0)
submit.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
submit.TextColor3 = Color3.new(0, 0, 0)
submit.Font = Enum.Font.GothamBold
submit.TextScaled = true
Instance.new("UICorner", submit).CornerRadius = UDim.new(0, 6)

local freeKeyLabel = Instance.new("TextLabel", keyFrame)
freeKeyLabel.Text = '🔑 Free key: "breinhub"'
freeKeyLabel.Size = UDim2.new(1, -10, 0, 20)
freeKeyLabel.Position = UDim2.new(0, 5, 1, -25)
freeKeyLabel.BackgroundTransparency = 1
freeKeyLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
freeKeyLabel.Font = Enum.Font.Gotham
freeKeyLabel.TextScaled = true

-- Acción al ingresar clave
submit.MouseButton1Click:Connect(function()
	if input.Text:lower() == "breinhub" then
		keyFrame:Destroy()

		-- Mensaje automático en chat
		local remote = lp:FindFirstChild("SayMessageRequest", true)
		if remote then
			remote:FireServer("free key by breinrotggr", "All")
		end

		-- Continuar a Parte 2 (logo + menú)
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Zxcxresl/breinhub/main/part2.lua"))()
	else
		submit.Text = "❌ Incorrecta"
		wait(1)
		submit.Text = "Entrar"
	end
end)