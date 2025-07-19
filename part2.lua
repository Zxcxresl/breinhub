-- Brein Hub - Parte 2 (Menu flotante + pestañas + carga Parte 3)

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local gui = game:GetService("CoreGui"):FindFirstChild("BreinHub_UI") or Instance.new("ScreenGui", gethui and gethui() or lp:WaitForChild("PlayerGui"))
gui.Name = "BreinHub_UI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

-- Logo animado en pantalla
local logoFrame = Instance.new("TextLabel", gui)
logoFrame.Text = "💠 Brein Hub 💠"
logoFrame.Size = UDim2.new(1, 0, 1, 0)
logoFrame.TextScaled = true
logoFrame.BackgroundTransparency = 1
logoFrame.TextColor3 = Color3.fromRGB(0, 170, 255)
logoFrame.Font = Enum.Font.GothamBlack

game:GetService("TweenService"):Create(logoFrame, TweenInfo.new(1), {TextTransparency = 0}):Play()
task.wait(2)
game:GetService("TweenService"):Create(logoFrame, TweenInfo.new(1), {TextTransparency = 1}):Play()
task.wait(1)
logoFrame:Destroy()

-- Contenedor del menú
local mainUI = Instance.new("Frame", gui)
mainUI.Size = UDim2.new(0, 600, 0, 360)
mainUI.Position = UDim2.new(0.5, -300, 0.5, -180)
mainUI.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainUI.BorderColor3 = Color3.fromRGB(0, 170, 255)
mainUI.BorderSizePixel = 1
mainUI.Active = true
mainUI.Draggable = true
mainUI.Name = "BreinHub_Window"

-- Barra superior
local titleBar = Instance.new("Frame", mainUI)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBar.BorderSizePixel = 0

local titleText = Instance.new("TextLabel", titleBar)
titleText.Text = "🧠 Brein Hub"
titleText.TextColor3 = Color3.fromRGB(0, 170, 255)
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 18
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Position = UDim2.new(0, 10, 0, 0)

-- Botón cerrar/ocultar
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.Text = "×"
closeBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18

closeBtn.MouseButton1Click:Connect(function()
	mainUI.Visible = false
end)

-- Botón flotante (≡)
local showBtn = Instance.new("TextButton", gui)
showBtn.Text = "≡"
showBtn.Size = UDim2.new(0, 40, 0, 40)
showBtn.Position = UDim2.new(0, 10, 0.5, -20)
showBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
showBtn.TextColor3 = Color3.new(0, 0, 0)
showBtn.Font = Enum.Font.GothamBold
showBtn.TextSize = 20

showBtn.MouseButton1Click:Connect(function()
	mainUI.Visible = not mainUI.Visible
end)

-- Submenú lateral
local tabButtons = {}
local tabFrames = {}

local tabHolder = Instance.new("Frame", mainUI)
tabHolder.Size = UDim2.new(0, 110, 1, -30)
tabHolder.Position = UDim2.new(0, 0, 0, 30)
tabHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
tabHolder.BorderColor3 = Color3.fromRGB(0, 170, 255)

local function createTab(name)
	local btn = Instance.new("TextButton", tabHolder)
	btn.Text = name
	btn.Size = UDim2.new(1, 0, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	btn.TextColor3 = Color3.fromRGB(0, 170, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.BorderColor3 = Color3.fromRGB(0, 170, 255)

	local frame = Instance.new("Frame", mainUI)
	frame.Size = UDim2.new(1, -120, 1, -40)
	frame.Position = UDim2.new(0, 120, 0, 40)
	frame.BackgroundTransparency = 1
	frame.Visible = false
	frame.Name = name .. "_Tab"

	btn.MouseButton1Click:Connect(function()
		for _, f in pairs(tabFrames) do f.Visible = false end
		for _, b in pairs(tabButtons) do b.BackgroundColor3 = Color3.fromRGB(15, 15, 15) end
		btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		frame.Visible = true
	end)

	table.insert(tabButtons, btn)
	table.insert(tabFrames, frame)

	return frame
end

-- Crear pestañas principales
_G.BreinTabs = {
	Main = createTab("Main"),
	Combat = createTab("Combat"),
	Motion = createTab("Motion"),
	Info = createTab("Info"),
	Server = createTab("Server"),
}

-- Activar pestaña principal por defecto
tabButtons[1].MouseButton1Click:Fire()

-- Cargar Parte 3 automáticamente
loadstring(game:HttpGet("https://raw.githubusercontent.com/zxcxresl/breinhub/main/part3.lua"))()