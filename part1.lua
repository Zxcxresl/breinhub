-- BreinHub V2 - Rayfield Edition
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")

-- Cargar Rayfield
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Rayfield:CreateWindow({
   Name = "Brein Hub V2",
   LoadingTitle = "Brein Hub V2",
   LoadingSubtitle = "Cargando herramientas...",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BreinHub",
      FileName = "Settings"
   },
   Discord = {
      Enabled = false
   },
   KeySystem = true,
   KeySettings = {
      Title = "Brein Hub V2",
      Subtitle = "Sistema de Acceso",
      Note = "Free Key: breinhub",
      FileName = "BreinKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"breinhub"}
   }
})

-- Pestañas
local MainTab = Window:CreateTab("Main", 4483362458)
local CombatTab = Window:CreateTab("Combat", 4483362458)
local MotionTab = Window:CreateTab("Motion", 4483362458)
local InfoTab = Window:CreateTab("Info", 4483362458)
local ServerTab = Window:CreateTab("Server", 4483362458)

-- MAIN
local savedCFrame = nil

MainTab:CreateButton({
   Name = "📍 Guardar Checkpoint",
   Callback = function()
      local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
      if root then savedCFrame = root.CFrame end
   end,
})

MainTab:CreateButton({
   Name = "🚀 Ir al Checkpoint",
   Callback = function()
      if savedCFrame then
         local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
         if root then root.CFrame = savedCFrame + Vector3.new(0, 3, 0) end
      end
   end,
})

MainTab:CreateButton({
   Name = "🛰️ TP a jugador aleatorio",
   Callback = function()
      for _, plr in pairs(Players:GetPlayers()) do
         if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character:PivotTo(plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0))
            break
         end
      end
   end,
})

MainTab:CreateButton({
   Name = "📋 Copiar nombre del juego",
   Callback = function()
      local info = MarketplaceService:GetProductInfo(game.PlaceId)
      setclipboard(info.Name)
      Rayfield:Notify({
         Title = "Copiado",
         Content = "Nombre del juego copiado al portapapeles.",
         Duration = 3
      })
   end,
})

MainTab:CreateParagraph({Title = "🔧 Próximamente...", Content = "Más funciones serán añadidas aquí."})

-- COMBAT
local espEnabled = false

CombatTab:CreateToggle({
   Name = "👁️ Activar ESP",
   CurrentValue = false,
   Callback = function(Value)
      espEnabled = Value
      if espEnabled then
         RunService:BindToRenderStep("BreinESP", Enum.RenderPriority.Last.Value, function()
            for _, plr in pairs(Players:GetPlayers()) do
               if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                  if not plr.Character:FindFirstChild("ESP_TAG") then
                     local tag = Instance.new("BillboardGui", plr.Character)
                     tag.Name = "ESP_TAG"
                     tag.Adornee = plr.Character.HumanoidRootPart
                     tag.Size = UDim2.new(0, 100, 0, 20)
                     tag.AlwaysOnTop = true
                     local lbl = Instance.new("TextLabel", tag)
                     lbl.Size = UDim2.new(1, 0, 1, 0)
                     lbl.BackgroundTransparency = 1
                     lbl.Text = plr.DisplayName
                     lbl.TextColor3 = Color3.fromRGB(0, 170, 255)
                     lbl.Font = Enum.Font.GothamBold
                     lbl.TextScaled = true
                  end
               end
            end
         end)
      else
         RunService:UnbindFromRenderStep("BreinESP")
         for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("ESP_TAG") then
               plr.Character:FindFirstChild("ESP_TAG"):Destroy()
            end
         end
      end
   end,
})

CombatTab:CreateButton({
   Name = "🎯 Activar Aimbot (externo)",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Zxcxresl/aimbotzxcz/main/aim.lua"))()
   end,
})

CombatTab:CreateButton({
   Name = "💀 TP Kill Manual",
   Callback = function()
      local index = 1
      local list = {}

      for _, p in pairs(Players:GetPlayers()) do
         if p ~= lp then table.insert(list, p) end
      end

      local function tpToNext()
         if index > #list then
            Rayfield:Notify({
               Title = "TP Kill",
               Content = "Todos los jugadores fueron procesados.",
               Duration = 3
            })
            return
         end
         local plr = list[index]
         index += 1
         if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character:PivotTo(plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0))
         end
      end

      tpToNext()

      CombatTab:CreateButton({
         Name = "⏭ Saltar jugador",
         Callback = tpToNext
      })
   end,
})

-- MOTION
MotionTab:CreateButton({
   Name = "🛸 Fly (joystick)",
   Callback = function()
      local flyConn
      local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
      if hum then hum.PlatformStand = true end
      flyConn = RunService.RenderStepped:Connect(function()
         local root = lp.Character:FindFirstChild("HumanoidRootPart")
         if root then
            local moveDir = lp.Character.Humanoid.MoveDirection
            root.Velocity = moveDir * 50
         end
      end)
      task.delay(10, function()
         if flyConn then flyConn:Disconnect() end
      end)
   end,
})

MotionTab:CreateToggle({
   Name = "🚪 NoClip",
   CurrentValue = false,
   Callback = function(enabled)
      RunService.Stepped:Connect(function()
         if enabled and lp.Character then
            for _, v in pairs(lp.Character:GetDescendants()) do
               if v:IsA("BasePart") then v.CanCollide = false end
            end
         end
      end)
   end,
})

MotionTab:CreateButton({
   Name = "🏃 Toggle Speed",
   Callback = function()
      local hum = lp.Character and lp.Character:FindFirstChild("Humanoid")
      if hum then
         hum.WalkSpeed = hum.WalkSpeed == 16 and 50 or 16
      end
   end,
})

-- INFO
InfoTab:CreateParagraph({
   Title = "👤 Usuario", Content = lp.DisplayName
})

InfoTab:CreateParagraph({
   Title = "🕹 Juego",
   Content = MarketplaceService:GetProductInfo(game.PlaceId).Name
})

InfoTab:CreateParagraph({
   Title = "🆔 Server ID",
   Content = game.JobId
})

InfoTab:CreateParagraph({
   Title = "🔑 Clave",
   Content = "breinhub (acceso libre)"
})

-- SERVER
ServerTab:CreateButton({
   Name = "🔄 Rejoin",
   Callback = function()
      TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
   end,
})

ServerTab:CreateButton({
   Name = "🆕 Server Hop",
   Callback = function()
      local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=2&limit=100")).data
      for _, v in pairs(servers) do
         if v.playing < v.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, lp)
            break
         end
      end
   end,
})

ServerTab:CreateButton({
   Name = "📋 Copiar Server ID",
   Callback = function()
      setclipboard(game.JobId)
   end,
})