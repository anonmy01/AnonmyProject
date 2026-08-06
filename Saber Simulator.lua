-- AnonmyHub | SABER SIMULATOR (Ultimate Farmer + Flag Capturer 5s)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "AnonmyHub | Saber Simulator",
   LoadingTitle = "Saber Simulator",
   LoadingSubtitle = "By Anonmy",
   Theme = "Default",
   ConfigurationSaving = { Enabled = true, FolderName = "AnonmyScripts", FileName = "SaberSimulator" }
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local MainTab = Window:CreateTab("⚡ Main", 4483362458)
local PlayerTab = Window:CreateTab("👤 Player", 4483362458)
local ConfigTab = Window:CreateTab("⚙️ Config", 4483362458)

-- Pega os RemoteEvents do jogo
local SwingSaberEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("SwingSaber")
local SellStrengthEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("SellStrength")
local UIActionEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("UIAction")
local CurrencyHolder = Workspace:WaitForChild("Gameplay"):WaitForChild("CurrencyPickup"):WaitForChild("CurrencyHolder")
local FlagsFolder = Workspace:WaitForChild("Gameplay"):WaitForChild("Flags")

-- Pega os módulos do jogo
local ItemInfo = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ItemInfo"))
local InfiniteMath = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("InfiniteMath"))
local ClientDataManager = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("MainClient"):WaitForChild("ClientDataManager"))

local autoSwing = false
local autoSell = false
local autoBuyWeapons = false
local autoBuyDNA = false
local autoEquipPets = false
local autoBuyAuras = false
local autoBuyPetAuras = false
local autoCollectCoins = false
local autoEquipBestClass = false
local autoBuyNextClass = false

local swingDelay = 0.01
local sellDelay = 2.5

---------------------------------------------------------
-- AUTO SWING & SELL
---------------------------------------------------------
task.spawn(function()
    while task.wait(swingDelay) do
        if autoSwing then
            pcall(function() SwingSaberEvent:FireServer() end)
        end
    end
end)

task.spawn(function()
    while task.wait(sellDelay) do
        if autoSell then
            pcall(function() SellStrengthEvent:FireServer() end)
        end
    end
end)

---------------------------------------------------------
-- AUTO BUY, EQUIP PETS, AURAS & EQUIP BEST CLASS
---------------------------------------------------------
task.spawn(function()
    while task.wait(2.5) do
        if autoBuyWeapons then pcall(function() UIActionEvent:FireServer("BuyAllWeapons") end) end
        if autoBuyDNA then pcall(function() UIActionEvent:FireServer("BuyAllDNAs") end) end
        if autoEquipPets then pcall(function() UIActionEvent:FireServer("EquipBestPets") end) end
        if autoBuyAuras then pcall(function() UIActionEvent:FireServer("BuyAllAuras") end) end
        if autoBuyPetAuras then pcall(function() UIActionEvent:FireServer("BuyAllPetAuras") end) end
        
        if autoEquipBestClass then
            local bestClassIndex = ClientDataManager.Data.Best_Class_Index
            local bestClassName = ItemInfo.Classes_Order[bestClassIndex]
            if bestClassName and ClientDataManager.Data.Class ~= bestClassName then
                pcall(function() UIActionEvent:FireServer("EquipClass", bestClassName) end)
            end
        end
    end
end)

---------------------------------------------------------
-- AUTO BUY NEXT CLASS
---------------------------------------------------------
task.spawn(function()
    while task.wait(1) do
        if autoBuyNextClass then
            local nextIndex = ClientDataManager.Data.Best_Class_Index + 1
            local nextClassName = ItemInfo.Classes_Order[nextIndex]
            
            if nextClassName then
                local classInfo = ItemInfo.Classes[nextClassName]
                if classInfo then
                    local currencyType = classInfo.Currency or "Coins"
                    local playerMoney = ClientDataManager.Data[currencyType]
                    
                    if playerMoney and InfiniteMath.new(playerMoney) >= InfiniteMath.new(classInfo.Price) then
                        pcall(function()
                            UIActionEvent:FireServer("BuyClass", nextClassName)
                        end)
                        task.wait(3) 
                    end
                end
            end
        end
    end
end)

---------------------------------------------------------
-- AUTO COLLECT COINS
---------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if autoCollectCoins then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and CurrencyHolder then
                for _, coin in pairs(CurrencyHolder:GetChildren()) do
                    if coin:IsA("BasePart") then
                        pcall(function()
                            coin.CFrame = hrp.CFrame
                        end)
                    end
                end
            end
        end
    end
end)

---------------------------------------------------------
-- UI Main Tab
---------------------------------------------------------
MainTab:CreateSection("Farming")
MainTab:CreateToggle({ Name = "Auto Swing Saber", CurrentValue = false, Callback = function(V) autoSwing = V end })
MainTab:CreateSlider({ Name = "Swing Delay", Range = {0.01, 1}, Increment = 0.01, Suffix = "s", CurrentValue = 0.01, Callback = function(V) swingDelay = V end })
MainTab:CreateToggle({ Name = "Auto Sell Strength", CurrentValue = false, Callback = function(V) autoSell = V end })
MainTab:CreateSlider({ Name = "Sell Delay", Range = {0.5, 10}, Increment = 0.5, Suffix = "s", CurrentValue = 2.5, Callback = function(V) sellDelay = V end })
MainTab:CreateToggle({ Name = "Auto Collect Coins", CurrentValue = false, Callback = function(V) autoCollectCoins = V end })

MainTab:CreateSection("Flags & Crowns")
MainTab:CreateButton({ 
    Name = "Capturar Todas as Flags (5s cada)", 
    Callback = function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp or not FlagsFolder then return end
        
        local originalPos = hrp.CFrame
        Rayfield:Notify({Title = "Flags", Content = "Iniciando captura de flags. Aguarde 5s em cada...", Duration = 5})
        
        for _, flagModel in pairs(FlagsFolder:GetChildren()) do
            if flagModel:IsA("Model") then
                local base = flagModel:FindFirstChild("Base")
                if base and base:IsA("BasePart") then
                    -- Teleporta para a base da flag
                    hrp.CFrame = base.CFrame + Vector3.new(0, 3, 0)
                    -- Avisa qual flag está capturando
                    Rayfield:Notify({Title = "Capturando Flag", Content = "Capturando: " .. flagModel.Name, Duration = 4})
                    -- Espera 5 segundos para o jogo registrar a captura
                    task.wait(5) 
                end
            end
        end
        
        -- Volta para onde o jogador estava
        hrp.CFrame = originalPos
        Rayfield:Notify({Title = "Flags", Content = "Todas as flags foram capturadas!", Duration = 3})
    end 
})

MainTab:CreateSection("Auto Shop & Pets")
MainTab:CreateToggle({ Name = "Auto Buy All Weapons", CurrentValue = false, Callback = function(V) autoBuyWeapons = V end })
MainTab:CreateToggle({ Name = "Auto Buy All DNAs", CurrentValue = false, Callback = function(V) autoBuyDNA = V end })
MainTab:CreateToggle({ Name = "Auto Equip Best Pets", CurrentValue = false, Callback = function(V) autoEquipPets = V end })
MainTab:CreateToggle({ Name = "Auto Buy All Auras", CurrentValue = false, Callback = function(V) autoBuyAuras = V end })
MainTab:CreateToggle({ Name = "Auto Buy All Pet Auras", CurrentValue = false, Callback = function(V) autoBuyPetAuras = V end })

MainTab:CreateSection("Classes (Auto Prestige Loop)")
MainTab:CreateToggle({ 
    Name = "Auto Buy Next Class (Zera o Progresso)", 
    CurrentValue = false, 
    Callback = function(V) 
        autoBuyNextClass = V 
        if V then
            Rayfield:Notify({Title = "Auto Class", Content = "Loop de compra ativado! Vai resetar quando tiver dinheiro.", Duration = 5})
        end
    end 
})
MainTab:CreateToggle({ Name = "Auto Equip Best Class Owned", CurrentValue = false, Callback = function(V) autoEquipBestClass = V end })

---------------------------------------------------------
-- UI Player Tab
---------------------------------------------------------
PlayerTab:CreateSection("Movement")
PlayerTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(V) local c = LocalPlayer.Character if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed = V end end })
PlayerTab:CreateSlider({ Name = "JumpPower", Range = {50, 500}, Increment = 1, CurrentValue = 50, Callback = function(V) local c = LocalPlayer.Character if c and c:FindFirstChild("Humanoid") then c.Humanoid.JumpPower = V end end })
PlayerTab:CreateButton({ Name = "Ativar Anti-AFK", Callback = function() local vu = game:GetService("VirtualUser") LocalPlayer.Idled:Connect(function() vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame) end) Rayfield:Notify({Title = "Anti-AFK", Content = "Ativado!", Duration = 3}) end })

---------------------------------------------------------
-- UI Config Tab
---------------------------------------------------------
ConfigTab:CreateButton({ Name = "Destroy UI", Callback = function() Rayfield:Destroy() end})

Rayfield:Notify({ Title = "AnonmyHub", Content = "Saber Simulator Carregado!", Duration = 5 })