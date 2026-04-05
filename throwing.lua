local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Anonmy Project | Throwing Simulator",
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
      FileName = "ThrowingSimulator"
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
local autoThrow = false
local throwDelay = 0.1
local autoHatch = false
local hatchDelay = 1
local autoRedRebirth = false
local rebirthDelay = 1
local autoTeleportEgg = false
local remoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("Paper"):WaitForChild("Remotes"):WaitForChild("__remoteevent")
local remoteFunction = game:GetService("ReplicatedStorage"):WaitForChild("Paper"):WaitForChild("Remotes"):WaitForChild("__remotefunction")

-- Main Functions
MainTab:CreateSection("Farming")

MainTab:CreateToggle({
   Name = "Auto Throw Object",
   CurrentValue = false,
   Flag = "AutoThrowToggle",
   Callback = function(Value)
      autoThrow = Value
      if Value then
         Rayfield:Notify({Title = "Auto Throw", Content = "Iniciado!", Duration = 3})
         task.spawn(function()
            while autoThrow do
               remoteEvent:FireServer("Throw Object")
               task.wait(throwDelay)
            end
         end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "Velocidade de Arremesso",
   Range = {0, 1},
   Increment = 0.05,
   Suffix = "s",
   CurrentValue = 0.1,
   Flag = "ThrowDelaySlider",
   Callback = function(Value)
      throwDelay = Value
   end,
})

MainTab:CreateButton({
   Name = "Ativar/Desativar AutoTrain (Game Setting)",
   Callback = function()
      remoteEvent:FireServer("Toggle Setting", "AutoTrain")
      Rayfield:Notify({Title = "Settings", Content = "AutoTrain alternado!", Duration = 3})
   end,
})

MainTab:CreateSection("Rebirths")

MainTab:CreateButton({
   Name = "Red Rebirth (50Qd)",
   Callback = function()
      remoteFunction:InvokeServer("Rebirth", 21)
      Rayfield:Notify({Title = "Rebirth", Content = "Red Rebirth (50Qd) executado!", Duration = 2})
   end,
})

MainTab:CreateSection("Eggs & Rewards")

MainTab:CreateToggle({
   Name = "Auto Hatch Spy Egg (Max)",
   CurrentValue = false,
   Flag = "AutoHatchEggToggle",
   Callback = function(Value)
      autoHatch = Value
      if Value then
         Rayfield:Notify({Title = "Auto Hatch", Content = "Iniciado!", Duration = 3})
         task.spawn(function()
            while autoHatch do
               local result = remoteFunction:InvokeServer("Hatch Egg", "Spy Egg", "Max")
               
               if result then
                  -- Teletransporte para o Ovo
                  if autoTeleportEgg then
                     local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                     if hrp then
                        hrp.CFrame = CFrame.new(88, 4, 14950)
                     end
                  end

                  local petContent = ""
                  if type(result) == "table" then
                     for i, v in pairs(result) do
                        local name = (type(v) == "table" and (v.Name or v.PetName)) or tostring(v)
                        petContent = petContent .. name .. (i < #result and ", " or "")
                     end
                  else
                     petContent = tostring(result)
                  end
                  
                  Rayfield:Notify({
                     Title = "🥚 Ovo Aberto!",
                     Content = "Você ganhou" .. petContent,
                     Duration = 4,
                     Image = 4483362458
                  })
               end
               
               task.wait(hatchDelay)
            end
         end)
      end
   end,
})

MainTab:CreateToggle({
   Name = "Teleporte ao Abrir Ovo",
   CurrentValue = false,
   Flag = "TeleportOnHatchToggle",
   Callback = function(Value)
      autoTeleportEgg = Value
   end,
})

MainTab:CreateSlider({
   Name = "Cooldown de Abertura (Ovos)",
   Range = {0.1, 10},
   Increment = 0.1,
   Suffix = "s",
   CurrentValue = 1,
   Flag = "HatchCooldownSlider",
   Callback = function(Value)
      hatchDelay = Value
   end,
})

MainTab:CreateButton({
   Name = "Coletar Recompensa Grátis",
   Callback = function()
      local success = remoteFunction:InvokeServer("Claim Free Reward")
      if success then
         Rayfield:Notify({Title = "Rewards", Content = "Recompensa coletada!", Duration = 3})
      else
         Rayfield:Notify({Title = "Rewards", Content = "Sem recompensas disponíveis ou falha.", Duration = 3})
      end
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
ConfigTab:CreateSection("Performance")

ConfigTab:CreateButton({
   Name = "Ativar Modo Anti-Lag (FPS Boost)",
   Callback = function()
      Rayfield:Notify({Title = "Performance", Content = "Otimizando o jogo... (Isso pode travar um pouco)", Duration = 5})
      
      -- FPS Boost Logic
      for _, v in pairs(game:GetDescendants()) do
         if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            v.CastShadow = false
         elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
         elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
         elseif v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v.Enabled = false
         elseif v:IsA("PostEffect") then
            v.Enabled = false
         end
      end
      
      game:GetService("Lighting").GlobalShadows = false
      sethiddenproperty(game:GetService("Lighting"), "Technology", Enum.Technology.Compatibility)
      sethiddenproperty(game:GetService("Lighting"), "ShadowPatherRendering", false)
      
      Rayfield:Notify({Title = "Performance", Content = "Jogo otimizado com sucesso!", Duration = 5})
   end,
})

ConfigTab:CreateSection("UI Settings")

ConfigTab:CreateButton({
   Name = "Destroy UI",
   Callback = function()
      Rayfield:Destroy()
   end,
})
