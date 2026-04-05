local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Anonmy Project | Saber Simulator",
   Icon = 0,
   LoadingTitle = "Anonmy Project",
   LoadingSubtitle = "By Anonmy",
   ShowText = "Rayfield",
   Theme = "Default",

   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "AnonmyScripts",
      FileName = "SaberSimulator"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = false,
})

local MainTab = Window:CreateTab("⚡ Main", 4483362458)
local PlayerTab = Window:CreateTab("👤 Player", 4483362458)
local ConfigTab = Window:CreateTab("⚙️ Config", 4483362458)

-- Variables
local autoSwing = false
local swingDelay = 0.01
local autoSell = false
local sellDelay = 2.5
local autoBuyWeapons = false
local autoBuyDNA = false
local buyDelay = 2.5

local uiRemote = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UIAction")

-- Main Functions
MainTab:CreateSection("Automation")

MainTab:CreateToggle({
   Name = "Auto Swing Saber",
   CurrentValue = false,
   Flag = "AutoSwingToggle",
   Callback = function(Value)
      autoSwing = Value
      if Value then
         Rayfield:Notify({Title = "Auto Swing", Content = "Ativado!", Duration = 3})
         task.spawn(function()
            local swingRemote = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("SwingSaber")
            while autoSwing do
               swingRemote:FireServer()
               task.wait(swingDelay)
            end
         end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "Velocidade de Swing",
   Range = {0, 1},
   Increment = 0.01,
   Suffix = "s",
   CurrentValue = 0.01,
   Flag = "SwingSpeedSlider",
   Callback = function(Value)
      swingDelay = Value
   end,
})

MainTab:CreateToggle({
   Name = "Auto Sell Strength",
   CurrentValue = false,
   Flag = "AutoSellToggle",
   Callback = function(Value)
      autoSell = Value
      if Value then
         Rayfield:Notify({Title = "Auto Sell", Content = "Ativado!", Duration = 3})
         task.spawn(function()
            local sellRemote = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("SellStrength")
            while autoSell do
               sellRemote:FireServer()
               task.wait(sellDelay)
            end
         end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "Delay de Venda",
   Range = {0.1, 10},
   Increment = 0.1,
   Suffix = "s",
   CurrentValue = 2.5,
   Flag = "SellDelaySlider",
   Callback = function(Value)
      sellDelay = Value
   end,
})

MainTab:CreateSection("Auto Shop")

MainTab:CreateToggle({
   Name = "Auto Buy All Weapons",
   CurrentValue = false,
   Flag = "AutoBuyWeaponsToggle",
   Callback = function(Value)
      autoBuyWeapons = Value
      if Value then
         Rayfield:Notify({Title = "Auto Buy", Content = "Iniciado (Armas)!", Duration = 3})
         task.spawn(function()
            while autoBuyWeapons do
               uiRemote:FireServer("BuyAllWeapons")
               task.wait(buyDelay)
            end
         end)
      end
   end,
})

MainTab:CreateToggle({
   Name = "Auto Buy All DNAs",
   CurrentValue = false,
   Flag = "AutoBuyDNAToggle",
   Callback = function(Value)
      autoBuyDNA = Value
      if Value then
         Rayfield:Notify({Title = "Auto Buy", Content = "Iniciado (DNAs)!", Duration = 3})
         task.spawn(function()
            while autoBuyDNA do
               uiRemote:FireServer("BuyAllDNAs")
               task.wait(buyDelay)
            end
         end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "Delay de Compra",
   Range = {0.5, 10},
   Increment = 0.5,
   Suffix = "s",
   CurrentValue = 2.5,
   Flag = "BuyDelaySlider",
   Callback = function(Value)
      buyDelay = Value
   end,
})

-- Player Functions
PlayerTab:CreateSection("Movement")

PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 250},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 16,
   Flag = "WalkSpeedSlider",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

PlayerTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 500},
   Increment = 1,
   Suffix = " Power",
   CurrentValue = 50,
   Flag = "JumpPowerSlider",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end,
})

PlayerTab:CreateSection("Misc")

PlayerTab:CreateButton({
   Name = "Ativar Anti-AFK",
   Callback = function()
      local vu = game:GetService("VirtualUser")
      game:GetService("Players").LocalPlayer.Idled:Connect(function()
         vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
         task.wait(1)
         vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
      end)
      Rayfield:Notify({Title = "Anti-AFK", Content = "Ativado!", Duration = 5})
   end,
})

-- Config Functions
ConfigTab:CreateSection("Settings")

ConfigTab:CreateButton({
   Name = "Destroy UI",
   Callback = function()
      Rayfield:Destroy()
   end,
})

