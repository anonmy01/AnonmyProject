local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Anonmy Project | Roll An Item",
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
      FileName = "RollAnItem"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = false,
})

local MainTab = Window:CreateTab("⚡ Main", 4483362458)
local DiceTab = Window:CreateTab("🎲 Auto Dice", 4483362458)
local PlayerTab = Window:CreateTab("👤 Player", 4483362458)
local ConfigTab = Window:CreateTab("⚙️ Config", 4483362458)

-- Variables
local autoCollect = false
local collectDelay = 0.1
local autoEquip = false
local equipDelay = 5

-- Main Functions
MainTab:CreateSection("Economy")

MainTab:CreateToggle({
   Name = "Auto Collect Money",
   CurrentValue = false,
   Flag = "AutoMoneyToggle",
   Callback = function(Value)
      autoCollect = Value
      if Value then
         Rayfield:Notify({Title = "Auto Collect", Content = "Ativado!", Duration = 3})
         task.spawn(function()
            while autoCollect do
               for i = 1, 10 do
                  if not autoCollect then break end
                  local podiumName = "Podium" .. i
                  local args = {
                     buffer.fromstring("-"),
                     buffer.fromstring("\254\001\000\006\a" .. podiumName)
                  }
                  game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
               end
               task.wait(collectDelay)
            end
         end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "Delay de Coleta",
   Range = {0, 1},
   Increment = 0.05,
   Suffix = "s",
   CurrentValue = 0.1,
   Flag = "CollectDelaySlider",
   Callback = function(Value)
      collectDelay = Value
   end,
})

MainTab:CreateSection("Equipment")

MainTab:CreateToggle({
   Name = "Auto Equip Best",
   CurrentValue = false,
   Flag = "AutoEquipToggle",
   Callback = function(Value)
      autoEquip = Value
      if Value then
         Rayfield:Notify({Title = "Auto Equip", Content = "Iniciado!", Duration = 3})
         task.spawn(function()
            while autoEquip do
               local args = {
                  buffer.fromstring("&"),
                  buffer.fromstring("\254\000\000")
               }
               game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable"):FireServer(unpack(args))
               task.wait(equipDelay)
            end
         end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "Delay de Equip",
   Range = {1, 30},
   Increment = 1,
   Suffix = "s",
   CurrentValue = 5,
   Flag = "EquipDelaySlider",
   Callback = function(Value)
      equipDelay = Value
   end,
})

-- Dice Automation
DiceTab:CreateSection("Dice Automation")

local ReliableRemote = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable")

local function AddDiceToggle(name, bufferHex)
   DiceTab:CreateToggle({
      Name = "Auto " .. name,
      CurrentValue = false,
      Flag = name:gsub("%s+", "") .. "Toggle",
      Callback = function(Value)
         _G["Auto" .. name:gsub("%s+", "")] = Value
         if Value then
            Rayfield:Notify({Title = "Dice", Content = "Auto " .. name .. " ativado!", Duration = 2})
            task.spawn(function()
               while _G["Auto" .. name:gsub("%s+", "")] do
                  local args = {
                     buffer.fromstring("6"),
                     buffer.fromstring(bufferHex)
                  }
                  ReliableRemote:FireServer(unpack(args))
                  task.wait()
               end
            end)
         end
      end,
   })
end

AddDiceToggle("Gold Dice",        "\254\001\000\006\bGoldDice")
AddDiceToggle("Diamond Dice",     "\254\001\000\006\vDiamondDice")
AddDiceToggle("Emerald Dice",     "\254\001\000\006\vEmeraldDice")
AddDiceToggle("Sapphire Dice",    "\254\001\000\006\fSapphireDice")
AddDiceToggle("Rainbow Dice",     "\254\001\000\006\vRainbowDice")
AddDiceToggle("Flaming Dice",     "\254\001\000\006\vFlamingDice")
AddDiceToggle("Dark Matter Dice", "\254\001\000\006\014DarkMatterDice")

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
