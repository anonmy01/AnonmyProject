local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Anonmy Project | Money Clicker",
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
      FileName = "MoneyClicker"
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
local autoClickMoney = false
local autoClickGem = false
local clickDelay = 0.05
local autoUpgrade = false
local autoGemUpgrade = false
local upgradeDelay = 1

-- Main Functions
MainTab:CreateSection("Auto Clicker")

MainTab:CreateToggle({
   Name = "Auto Click Money",
   CurrentValue = false,
   Flag = "AutoClickMoneyToggle",
   Callback = function(Value)
      autoClickMoney = Value
      if Value then
         Rayfield:Notify({Title = "Auto Click Money", Content = "Iniciado!", Duration = 3})
         task.spawn(function()
            while autoClickMoney do
               game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ClickMoney"):FireServer()
               task.wait(clickDelay)
            end
         end)
      else
         Rayfield:Notify({Title = "Auto Click Money", Content = "Parado.", Duration = 3})
      end
   end,
})

MainTab:CreateToggle({
   Name = "Auto Click Gem",
   CurrentValue = false,
   Flag = "AutoClickGemToggle",
   Callback = function(Value)
      autoClickGem = Value
      if Value then
         Rayfield:Notify({Title = "Auto Click Gem", Content = "Iniciado!", Duration = 3})
         task.spawn(function()
            while autoClickGem do
               game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ClickMoney"):WaitForChild("ClickGem"):FireServer()
               task.wait(clickDelay)
            end
         end)
      else
         Rayfield:Notify({Title = "Auto Click Gem", Content = "Parado.", Duration = 3})
      end
   end,
})

MainTab:CreateSlider({
   Name = "Velocidade de Clique",
   Range = {0, 1},
   Increment = 0.05,
   Suffix = "s",
   CurrentValue = 0.05,
   Flag = "ClickSpeedSlider",
   Callback = function(Value)
      clickDelay = Value
   end,
})

MainTab:CreateSection("Auto Upgrades")

MainTab:CreateToggle({
   Name = "Auto Upgrade Tiers (1, 2, 3)",
   CurrentValue = false,
   Flag = "AutoUpgradeAllToggle",
   Callback = function(Value)
      autoUpgrade = Value
      if Value then
         Rayfield:Notify({Title = "Auto Upgrade", Content = "Ativado!", Duration = 3})
         task.spawn(function()
            while autoUpgrade do
               for tier = 1, 3 do
                  if not autoUpgrade then break end
                  game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Upgrade"):FireServer(tier, true)
               end
               task.wait(upgradeDelay)
            end
         end)
      end
   end,
})

MainTab:CreateToggle({
   Name = "Auto Gem Upgrade (1, 2, 3)",
   CurrentValue = false,
   Flag = "AutoGemUpgradeToggle",
   Callback = function(Value)
      autoGemUpgrade = Value
      if Value then
         Rayfield:Notify({Title = "Gem Upgrade", Content = "Ativado!", Duration = 3})
         task.spawn(function()
            while autoGemUpgrade do
               for i = 1, 3 do
                  if not autoGemUpgrade then break end
                  game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Upgrade"):WaitForChild("GemUpgrade"):FireServer(i, false)
               end
               task.wait(upgradeDelay)
            end
         end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "Intervalo de Upgrade",
   Range = {0.1, 5},
   Increment = 0.1,
   Suffix = "s",
   CurrentValue = 1,
   Flag = "UpgradeDelaySlider",
   Callback = function(Value)
      upgradeDelay = Value
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