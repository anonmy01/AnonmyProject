local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Anonmy Project | Upgrade Tree",
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
      FileName = "UpgradeTree"
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
local autoClickerRemote = false
local clickDelay = 0.01
local autoUpgradeAll = false
local upgradeDelay = 0.5
local autoRoll = false
local rollDelay = 0.1
local autoPrestige = false
local prestigeDelay = 0.1

-- Main Functions
MainTab:CreateSection("Automation")

MainTab:CreateToggle({
   Name = "Auto Clicker",
   CurrentValue = false,
   Flag = "AutoClickerToggle",
   Callback = function(Value)
      autoClickerRemote = Value
      if Value then
         Rayfield:Notify({Title = "Auto Clicker", Content = "Ativado!", Duration = 3})
         task.spawn(function()
            local clickRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Clicker")
            while autoClickerRemote do
               clickRemote:FireServer()
               task.wait(clickDelay)
            end
         end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "Delay de Clique",
   Range = {0, 1},
   Increment = 0.01,
   Suffix = "s",
   CurrentValue = 0.01,
   Flag = "ClickDelaySlider",
   Callback = function(Value)
      clickDelay = Value
   end,
})

MainTab:CreateToggle({
   Name = "Auto Upgrade All (Alt)",
   CurrentValue = false,
   Flag = "AutoUpgradeAllToggle",
   Callback = function(Value)
      autoUpgradeAll = Value
      if Value then
         Rayfield:Notify({Title = "Auto Upgrade", Content = "Ativado!", Duration = 3})
         task.spawn(function()
            local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuyUpg")
            while autoUpgradeAll do
               for i = 1, 150 do
                  if not autoUpgradeAll then break end
                   if i ~= 76 then 
                     remote:FireServer(i)
                  end
               end
               task.wait(upgradeDelay)
            end
         end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "Delay entre Ciclos de Upgrade",
   Range = {0.1, 10},
   Increment = 0.1,
   Suffix = "s",
   CurrentValue = 0.5,
   Flag = "UpgradeDelaySlider",
   Callback = function(Value)
      upgradeDelay = Value
   end,
})

MainTab:CreateSection("Special Functions")

MainTab:CreateToggle({
   Name = "Auto Roll",
   CurrentValue = false,
   Flag = "AutoRollToggle",
   Callback = function(Value)
      autoRoll = Value
      if Value then
         Rayfield:Notify({Title = "Auto Roll", Content = "Ativado!", Duration = 3})
         task.spawn(function()
            local rollRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Roll")
            while autoRoll do
               rollRemote:InvokeServer()
               task.wait(rollDelay)
            end
         end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "Delay de Roll",
   Range = {0, 2},
   Increment = 0.1,
   Suffix = "s",
   CurrentValue = 0.1,
   Flag = "RollDelaySlider",
   Callback = function(Value)
      rollDelay = Value
   end,
})

MainTab:CreateToggle({
   Name = "Auto Prestige",
   CurrentValue = false,
   Flag = "AutoPrestigeToggle",
   Callback = function(Value)
      autoPrestige = Value
      if Value then
         Rayfield:Notify({Title = "Auto Prestige", Content = "Ativado!", Duration = 3})
         task.spawn(function()
            local prestigeRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Prestige")
            while autoPrestige do
               prestigeRemote:FireServer()
               task.wait(prestigeDelay)
            end
         end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "Delay de Prestige",
   Range = {0, 5},
   Increment = 0.1,
   Suffix = "s",
   CurrentValue = 0.1,
   Flag = "PrestigeDelaySlider",
   Callback = function(Value)
      prestigeDelay = Value
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