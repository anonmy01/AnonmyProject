local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Anonmy Project | Unbox a Factor",
   Icon = 0,
   LoadingTitle = "Anonmy Interface Suite",
   LoadingSubtitle = "by Anonmy",
   ShowText = "Rayfield",
   Theme = "Default",

   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "AnonmyScripts",
      FileName = "UnboxAFactor"
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
local autoClick = false
local autoClickDelay = 0.1

-- Main Functions
MainTab:CreateSection("Automation")

MainTab:CreateToggle({
   Name = "Manual XP (Auto)",
   CurrentValue = false,
   Flag = "ManualXPToggle",
   Callback = function(Value)
      autoClick = Value
      if Value then
         Rayfield:Notify({Title = "Manual XP", Content = "Auto-clique ativado!", Duration = 3})
         task.spawn(function()
            while autoClick do
               local args = { "ManualMachine" }
               game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("MachineClickEvent"):FireServer(unpack(args))
               task.wait(autoClickDelay)
            end
         end)
      else
         Rayfield:Notify({Title = "Manual XP", Content = "Auto-clique desativado.", Duration = 3})
      end
   end,
})

MainTab:CreateSlider({
   Name = "Velocidade de Clique",
   Range = {0, 1},
   Increment = 0.05,
   Suffix = "s",
   CurrentValue = 0.1,
   Flag = "ClickDelaySlider",
   Callback = function(Value)
      autoClickDelay = Value
   end,
})

MainTab:CreateSection("Economy")

MainTab:CreateButton({
   Name = "Vender Fábrica (Sell Factory)",
   Callback = function()
      local args = { "all", "Pet" }
      game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("SellBrainrotEvent"):FireServer(unpack(args))
      Rayfield:Notify({Title = "Action", Content = "Sua fábrica foi vendida!", Duration = 3})
   end,
})

MainTab:CreateButton({
   Name = "Vender Trabalhadores (Sell Workers)",
   Callback = function()
      local args = { "all", "Worker" }
      game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("SellBrainrotEvent"):FireServer(unpack(args))
      Rayfield:Notify({Title = "Action", Content = "Seus trabalhadores foram vendidos!", Duration = 3})
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
      Rayfield:Notify({Title = "Anti-AFK", Content = "Anti-AFK ativado com sucesso!", Duration = 5})
   end,
})

-- Config Functions
ConfigTab:CreateSection("UI Settings")

ConfigTab:CreateButton({
   Name = "Destruir Interface (Destroy UI)",
   Callback = function()
      Rayfield:Destroy()
   end,
})

