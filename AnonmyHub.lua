-- AnonmyHub | Manual Selection Hub (Versão Estável)
-- Corrigido para evitar falhas de execução e otimizar carregamento.

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local PlaceId = game.PlaceId

-- Carregar Rayfield apenas UMA vez no topo
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
    warn("Falha ao carregar Rayfield. Verifique sua conexão ou executor.")
    return
end

---------------------------------------------------------
-- 2. FUNÇÕES DOS SCRIPTS (Isoladas e Completas)
---------------------------------------------------------

local AllScripts = {}

-- THROWING SIMULATOR (FULL)
AllScripts.Throwing = function()
    local Window = Rayfield:CreateWindow({
       Name = "Anonmy Project | Throwing Simulator",
       Icon = 0,
       LoadingTitle = "Anonmy Project",
       LoadingSubtitle = "By Anonmy",
       Theme = "Default",
       ConfigurationSaving = { Enabled = true, FolderName = "AnonmyScripts", FileName = "ThrowingSimulator" }
    })
    local MainTab = Window:CreateTab("⚡ Main", 4483362458)
    local PlayerTab = Window:CreateTab("👤 Player", 4483362458)
    local ConfigTab = Window:CreateTab("⚙️ Config", 4483362458)

    local autoThrow, throwDelay, autoHatch, hatchDelay, autoRedRebirth, rebirthDelay, autoTeleportEgg = false, 0.1, false, 1, false, 1, false
    local remoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("Paper"):WaitForChild("Remotes"):WaitForChild("__remoteevent")
    local remoteFunction = game:GetService("ReplicatedStorage"):WaitForChild("Paper"):WaitForChild("Remotes"):WaitForChild("__remotefunction")

    MainTab:CreateSection("Farming")
    MainTab:CreateToggle({ Name = "Auto Throw Object", Callback = function(Value)
        autoThrow = Value
        if Value then task.spawn(function() while autoThrow do remoteEvent:FireServer("Throw Object") task.wait(throwDelay) end end) end
    end})
    MainTab:CreateSlider({ Name = "Velocidade de Arremesso", Range = {0, 1}, Increment = 0.05, CurrentValue = 0.1, Callback = function(Value) throwDelay = Value end})
    MainTab:CreateButton({ Name = "Ativar/Desativar AutoTrain (Game Setting)", Callback = function() remoteEvent:FireServer("Toggle Setting", "AutoTrain") end})
    MainTab:CreateSection("Rebirths")
    MainTab:CreateButton({ Name = "Red Rebirth (50Qd)", Callback = function() remoteFunction:InvokeServer("Rebirth", 21) end})
    MainTab:CreateSection("Eggs & Rewards")
    MainTab:CreateToggle({ Name = "Auto Hatch Spy Egg (Max)", Callback = function(Value)
        autoHatch = Value
        if Value then task.spawn(function() while autoHatch do 
            local result = remoteFunction:InvokeServer("Hatch Egg", "Spy Egg", "Max")
            if result and autoTeleportEgg then local hrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame = CFrame.new(88, 4, 14950) end end 
            task.wait(hatchDelay) 
        end end) end
    end})
    MainTab:CreateToggle({ Name = "Teleporte ao Abrir Ovo", Callback = function(V) autoTeleportEgg = V end})
    MainTab:CreateSlider({ Name = "Cooldown de Abertura (Ovos)", Range = {0.1, 10}, Increment = 0.1, CurrentValue = 1, Callback = function(Value) hatchDelay = Value end})
    MainTab:CreateButton({ Name = "Coletar Recompensa Grátis", Callback = function() remoteFunction:InvokeServer("Claim Free Reward") end})

    PlayerTab:CreateSection("Movement")
    PlayerTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(V) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = V end})
    PlayerTab:CreateSlider({ Name = "JumpPower", Range = {50, 500}, Increment = 1, CurrentValue = 50, Callback = function(V) game.Players.LocalPlayer.Character.Humanoid.JumpPower = V end})
    PlayerTab:CreateButton({ Name = "Ativar Anti-AFK", Callback = function() local vu = game:GetService("VirtualUser") game:GetService("Players").LocalPlayer.Idled:Connect(function() vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end) end})

    ConfigTab:CreateSection("Performance")
    ConfigTab:CreateButton({ Name = "Ativar Modo Anti-Lag (FPS Boost)", Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic v.Reflectance = 0 v.CastShadow = false
            elseif v:IsA("Decal") or v:IsA("Texture") then v:Destroy()
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then v.Enabled = false end
        end
        game:GetService("Lighting").GlobalShadows = false
    end})
    ConfigTab:CreateButton({ Name = "Destroy UI", Callback = function() Rayfield:Destroy() end})
end

-- MONEY CLICKER (FULL)
AllScripts.Money = function()
    local Window = Rayfield:CreateWindow({ Name = "AnonmyHub | Money Clicker", Theme = "Default", ConfigurationSaving = { Enabled = true, FolderName = "AnonmyScripts", FileName = "MoneyClicker" } })
    local MainTab = Window:CreateTab("⚡ Main", 4483362458)
    local PlayerTab = Window:CreateTab("👤 Player", 4483362458)
    local ConfigTab = Window:CreateTab("⚙️ Config", 4483362458)
    local autoClickMoney, autoClickGem, clickDelay, autoUpgrade, autoGemUpgrade, upgradeDelay = false, false, 0.05, false, false, 1
    local events = game:GetService("ReplicatedStorage"):WaitForChild("Events")
    
    MainTab:CreateSection("Auto Clicker")
    MainTab:CreateToggle({ Name = "Auto Click Money", Callback = function(Value) 
        autoClickMoney = Value
        if Value then task.spawn(function() while autoClickMoney do events:WaitForChild("ClickMoney"):FireServer() task.wait(clickDelay) end end) end
    end})
    MainTab:CreateToggle({ Name = "Auto Click Gem", Callback = function(Value) 
        autoClickGem = Value
        if Value then task.spawn(function() while autoClickGem do 
            local cm = events:FindFirstChild("ClickMoney")
            if cm and cm:FindFirstChild("ClickGem") then cm.ClickGem:FireServer() end
            task.wait(clickDelay) 
        end end) end
    end})
    MainTab:CreateSlider({ Name = "Velocidade de Clique", Range = {0, 1}, CurrentValue = 0.05, Callback = function(Value) clickDelay = Value end})
    MainTab:CreateSection("Auto Upgrades")
    MainTab:CreateToggle({ Name = "Auto Upgrade Tiers (1, 2, 3)", Callback = function(Value)
        autoUpgrade = Value
        if Value then task.spawn(function() while autoUpgrade do for tier = 1, 3 do if not autoUpgrade then break end events:WaitForChild("Upgrade"):FireServer(tier, true) end task.wait(upgradeDelay) end end) end
    end})
    MainTab:CreateToggle({ Name = "Auto Gem Upgrade (1, 2, 3)", Callback = function(Value)
        autoGemUpgrade = Value
        if Value then task.spawn(function() while autoGemUpgrade do 
            local upg = events:FindFirstChild("Upgrade")
            if upg and upg:FindFirstChild("GemUpgrade") then for i = 1, 3 do if not autoGemUpgrade then break end upg.GemUpgrade:FireServer(i, false) end end
            task.wait(upgradeDelay) 
        end end) end
    end})
    MainTab:CreateSlider({ Name = "Intervalo de Upgrade", Range = {0.1, 5}, CurrentValue = 1, Callback = function(Value) upgradeDelay = Value end})

    PlayerTab:CreateSection("Movement")
    PlayerTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(V) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = V end})
    PlayerTab:CreateSlider({ Name = "JumpPower", Range = {50, 500}, Increment = 1, CurrentValue = 50, Callback = function(V) game.Players.LocalPlayer.Character.Humanoid.JumpPower = V end})
    PlayerTab:CreateButton({ Name = "Ativar Anti-AFK", Callback = function() local vu = game:GetService("VirtualUser") game:GetService("Players").LocalPlayer.Idled:Connect(function() vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end) end})

    ConfigTab:CreateButton({ Name = "Destroy UI", Callback = function() Rayfield:Destroy() end})
end

-- UPGRADE TREE (FULL)
AllScripts.Tree = function()
    local Window = Rayfield:CreateWindow({ Name = "AnonmyHub | Upgrade Tree", Theme = "Default", ConfigurationSaving = { Enabled = true, FolderName = "AnonmyScripts", FileName = "UpgradeTree" } })
    local MainTab = Window:CreateTab("⚡ Main", 4483362458)
    local PlayerTab = Window:CreateTab("👤 Player", 4483362458)
    local ConfigTab = Window:CreateTab("⚙️ Config", 4483362458)
    local autoClickerRemote, clickDelay, autoUpgradeAll, upgradeDelay, autoRoll, rollDelay, autoPrestige, prestigeDelay = false, 0.01, false, 0.5, false, 0.1, false, 0.1
    local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
    
    MainTab:CreateSection("Automation")
    MainTab:CreateToggle({ Name = "Auto Clicker", Callback = function(V) autoClickerRemote = V if V then task.spawn(function() local r = remotes:WaitForChild("Clicker") while autoClickerRemote do r:FireServer() task.wait(clickDelay) end end) end end})
    MainTab:CreateSlider({ Name = "Delay de Clique", Range = {0, 1}, CurrentValue = 0.01, Callback = function(V) clickDelay = V end})
    MainTab:CreateToggle({ Name = "Auto Upgrade All (Alt)", Callback = function(V) autoUpgradeAll = V if V then task.spawn(function() local r = remotes:WaitForChild("BuyUpg") while autoUpgradeAll do for i = 1, 150 do if not autoUpgradeAll then break end if i ~= 76 then r:FireServer(i) end end task.wait(upgradeDelay) end end) end end})
    MainTab:CreateSlider({ Name = "Delay de Upgrade", Range = {0.1, 10}, CurrentValue = 0.5, Callback = function(V) upgradeDelay = V end})
    MainTab:CreateSection("Special Functions")
    MainTab:CreateToggle({ Name = "Auto Roll", Callback = function(V) autoRoll = V if V then task.spawn(function() local r = remotes:WaitForChild("Roll") while autoRoll do r:InvokeServer() task.wait(rollDelay) end end) end end})
    MainTab:CreateToggle({ Name = "Auto Prestige", Callback = function(V) autoPrestige = V if V then task.spawn(function() local r = remotes:WaitForChild("Prestige") while autoPrestige do r:FireServer() task.wait(prestigeDelay) end end) end end})

    PlayerTab:CreateSection("Movement")
    PlayerTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(V) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = V end})
    PlayerTab:CreateSlider({ Name = "JumpPower", Range = {50, 500}, Increment = 1, CurrentValue = 50, Callback = function(V) game.Players.LocalPlayer.Character.Humanoid.JumpPower = V end})
    PlayerTab:CreateButton({ Name = "Ativar Anti-AFK", Callback = function() local vu = game:GetService("VirtualUser") game:GetService("Players").LocalPlayer.Idled:Connect(function() vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end) end})

    ConfigTab:CreateButton({ Name = "Destroy UI", Callback = function() Rayfield:Destroy() end})
end

-- UNBOX A FACTOR (FULL)
AllScripts.Unbox = function()
    local Window = Rayfield:CreateWindow({ Name = "AnonmyHub | Unbox a Factor", Theme = "Default", ConfigurationSaving = { Enabled = true, FolderName = "AnonmyScripts", FileName = "UnboxAFactor" } })
    local MainTab = Window:CreateTab("⚡ Main", 4483362458)
    local PlayerTab = Window:CreateTab("👤 Player", 4483362458)
    local ConfigTab = Window:CreateTab("⚙️ Config", 4483362458)
    local autoClick, autoClickDelay = false, 0.1
    local events = game:GetService("ReplicatedStorage"):WaitForChild("Events")
    
    MainTab:CreateSection("Automation")
    MainTab:CreateToggle({ Name = "Manual XP (Auto)", Callback = function(V) autoClick = V if V then task.spawn(function() while autoClick do events:WaitForChild("MachineClickEvent"):FireServer("ManualMachine") task.wait(autoClickDelay) end end) end end})
    MainTab:CreateSlider({ Name = "Velocidade de Clique", Range = {0, 1}, CurrentValue = 0.1, Callback = function(V) autoClickDelay = V end})
    MainTab:CreateSection("Economy")
    MainTab:CreateButton({ Name = "Vender Fábrica (Sell Factory)", Callback = function() events:WaitForChild("SellBrainrotEvent"):FireServer("all", "Pet") end})
    MainTab:CreateButton({ Name = "Vender Trabalhadores (Sell Workers)", Callback = function() events:WaitForChild("SellBrainrotEvent"):FireServer("all", "Worker") end})

    PlayerTab:CreateSection("Movement")
    PlayerTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(V) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = V end})
    PlayerTab:CreateSlider({ Name = "JumpPower", Range = {50, 500}, Increment = 1, CurrentValue = 50, Callback = function(V) game.Players.LocalPlayer.Character.Humanoid.JumpPower = V end})
    PlayerTab:CreateButton({ Name = "Ativar Anti-AFK", Callback = function() local vu = game:GetService("VirtualUser") game:GetService("Players").LocalPlayer.Idled:Connect(function() vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end) end})

    ConfigTab:CreateButton({ Name = "Destroy UI", Callback = function() Rayfield:Destroy() end})
end

-- ROLL AN ITEM (FULL)
AllScripts.Roll = function()
    local Window = Rayfield:CreateWindow({ Name = "AnonmyHub | Roll An Item", Theme = "Default", ConfigurationSaving = { Enabled = true, FolderName = "AnonmyScripts", FileName = "RollAnItem" } })
    local MainTab = Window:CreateTab("⚡ Main", 4483362458)
    local DiceTab = Window:CreateTab("🎲 Auto Dice", 4483362458)
    local PlayerTab = Window:CreateTab("👤 Player", 4483362458)
    local ConfigTab = Window:CreateTab("⚙️ Config", 4483362458)
    local autoCollect, collectDelay, autoEquip, equipDelay = false, 0.1, false, 5
    local rRemote = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable")
    
    MainTab:CreateSection("Economy")
    MainTab:CreateToggle({ Name = "Auto Collect Money", Callback = function(V) autoCollect = V if V then task.spawn(function() while autoCollect do for i = 1, 10 do if not autoCollect then break end rRemote:FireServer(buffer.fromstring("-"), buffer.fromstring("\254\001\000\006\aPodium" .. i)) end task.wait(collectDelay) end end) end end})
    MainTab:CreateToggle({ Name = "Auto Equip Best", Callback = function(V) autoEquip = V if V then task.spawn(function() while autoEquip do rRemote:FireServer(buffer.fromstring("&"), buffer.fromstring("\254\000\000")) task.wait(equipDelay) end end) end end})
    
    DiceTab:CreateSection("Dice Automation")
    local function AddDice(n, b) 
        local safeName = (n:gsub(" ",""))
        DiceTab:CreateToggle({ Name = "Auto " .. n, Callback = function(V) 
            _G["Auto"..safeName] = V 
            if V then task.spawn(function() while _G["Auto"..safeName] do rRemote:FireServer(buffer.fromstring("6"), buffer.fromstring(b)) task.wait() end end) end 
        end}) 
    end
    AddDice("Gold Dice", "\254\001\000\006\bGoldDice")
    AddDice("Diamond Dice", "\254\001\000\006\vDiamondDice")
    AddDice("Emerald Dice", "\254\001\000\006\vEmeraldDice")
    AddDice("Sapphire Dice", "\254\001\000\006\fSapphireDice")
    AddDice("Rainbow Dice", "\254\001\000\006\vRainbowDice")
    AddDice("Flaming Dice", "\254\001\000\006\vFlamingDice")
    AddDice("Dark Matter Dice", "\254\001\000\006\014DarkMatterDice")

    PlayerTab:CreateSection("Movement")
    PlayerTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(V) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = V end})
    PlayerTab:CreateSlider({ Name = "JumpPower", Range = {50, 500}, Increment = 1, CurrentValue = 50, Callback = function(V) game.Players.LocalPlayer.Character.Humanoid.JumpPower = V end})
    PlayerTab:CreateButton({ Name = "Ativar Anti-AFK", Callback = function() local vu = game:GetService("VirtualUser") game:GetService("Players").LocalPlayer.Idled:Connect(function() vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end) end})

    ConfigTab:CreateButton({ Name = "Destroy UI", Callback = function() Rayfield:Destroy() end})
end

-- SABER SIMULATOR (FULL)
AllScripts.Saber = function()
    local Window = Rayfield:CreateWindow({ Name = "AnonmyHub | Saber Simulator", Theme = "Default", ConfigurationSaving = { Enabled = true, FolderName = "AnonmyScripts", FileName = "SaberSimulator" } })
    local MainTab = Window:CreateTab("⚡ Main", 4483362458)
    local PlayerTab = Window:CreateTab("👤 Player", 4483362458)
    local ConfigTab = Window:CreateTab("⚙️ Config", 4483362458)
    local autoSwing, swingDelay, autoSell, sellDelay, autoBuyWeapons, autoBuyDNA, buyDelay = false, 0.01, false, 2.5, false, false, 2.5
    local events = game:GetService("ReplicatedStorage"):WaitForChild("Events")
    
    MainTab:CreateSection("Automation")
    MainTab:CreateToggle({ Name = "Auto Swing Saber", Callback = function(V) autoSwing = V if V then task.spawn(function() local r = events:WaitForChild("SwingSaber") while autoSwing do r:FireServer() task.wait(swingDelay) end end) end end})
    MainTab:CreateSlider({ Name = "Velocidade de Swing", Range = {0, 1}, CurrentValue = 0.01, Callback = function(V) swingDelay = V end})
    MainTab:CreateToggle({ Name = "Auto Sell Strength", Callback = function(V) autoSell = V if V then task.spawn(function() local r = events:WaitForChild("SellStrength") while autoSell do r:FireServer() task.wait(sellDelay) end end) end end})
    MainTab:CreateSection("Auto Shop")
    MainTab:CreateToggle({ Name = "Auto Buy All Weapons", Callback = function(V) autoBuyWeapons = V if V then task.spawn(function() while autoBuyWeapons do events:WaitForChild("UIAction"):FireServer("BuyAllWeapons") task.wait(buyDelay) end end) end end})
    MainTab:CreateToggle({ Name = "Auto Buy All DNAs", Callback = function(V) autoBuyDNA = V if V then task.spawn(function() while autoBuyDNA do events:WaitForChild("UIAction"):FireServer("BuyAllDNAs") task.wait(buyDelay) end end) end end})

    PlayerTab:CreateSection("Movement")
    PlayerTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(V) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = V end})
    PlayerTab:CreateSlider({ Name = "JumpPower", Range = {50, 500}, Increment = 1, CurrentValue = 50, Callback = function(V) game.Players.LocalPlayer.Character.Humanoid.JumpPower = V end})
    PlayerTab:CreateButton({ Name = "Ativar Anti-AFK", Callback = function() local vu = game:GetService("VirtualUser") game:GetService("Players").LocalPlayer.Idled:Connect(function() vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end) end})

    ConfigTab:CreateButton({ Name = "Destroy UI", Callback = function() Rayfield:Destroy() end})
end

-- GAMEPASS SPOOFER (FULL)
AllScripts.Spoofer = function()
    local MarketplaceService = game:GetService("MarketplaceService")
    local LocalPlayer = game:GetService("Players").LocalPlayer
    
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if self == MarketplaceService and (method == "UserOwnsGamePassAsync" or method == "userOwnsGamePassAsync") then
            if args[1] == LocalPlayer.UserId then return true end
        end
        return oldNamecall(self, ...)
    end)
    
    hookfunction(LocalPlayer.PlayerOwnsAsset, function() return true end)
    
    Rayfield:Notify({Title = "Gamepass Spoofer", Content = "Desbloqueio Local Ativado!", Duration = 5})
end

-- DEBUG / REPAIR TOOL (FULL)
AllScripts.Debug = function()
    Rayfield:Notify({Title = "Debug Mode", Content = "Iniciando diagnósticos de arquivos...", Duration = 5})
    local PathPrefixes = {"", "workspace/", "Workspace/", "scripts/"}
    for _, file in pairs({"money.lua", "saber.lua", "throwing.lua"}) do
        local found = false
        for _, prefix in pairs(PathPrefixes) do
            if pcall(function() return readfile(prefix .. file) end) then
                print("[DEBUG] Encontrado: " .. prefix .. file)
                found = true
                break
            end
        end
        if not found then warn("[DEBUG] Não encontrado: " .. file) end
    end
    Rayfield:Notify({Title = "Debug", Content = "Diagnóstico concluído! Verifique o console (F9).", Duration = 5})
end

---------------------------------------------------------
-- 3. HUB DE SELEÇÃO PRINCIPAL
---------------------------------------------------------

local HubWindow = Rayfield:CreateWindow({
   Name = "AnonmyHub | HUB DE SELEÇÃO",
   LoadingTitle = "Carregando Scripts...",
   LoadingSubtitle = "by Anonmy",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
})

local HomeTab = HubWindow:CreateTab("🏠 Home", 4483362458)
local GamesTab = HubWindow:CreateTab("🎮 Scripts Disponíveis", 4483362458)
local SpiesTab = HubWindow:CreateTab("📡 Remote Spy", 4483362458)

local pInfo = MarketplaceService:GetProductInfo(PlaceId)
local gameName = pInfo and pInfo.Name or "Desconhecido"

HomeTab:CreateSection("Status do Jogo")
HomeTab:CreateLabel("Você está em: " .. gameName)
HomeTab:CreateLabel("Place ID: " .. PlaceId)

local function RunScript(scriptFunc)
    Rayfield:Destroy()
    task.wait(0.1)
    scriptFunc()
end

GamesTab:CreateSection("Simuladores")
GamesTab:CreateButton({ Name = "Throwing Simulator", Callback = function() RunScript(AllScripts.Throwing) end })
GamesTab:CreateButton({ Name = "Money Clicker", Callback = function() RunScript(AllScripts.Money) end })
GamesTab:CreateButton({ Name = "Upgrade Tree", Callback = function() RunScript(AllScripts.Tree) end })
GamesTab:CreateButton({ Name = "Unbox a Factor", Callback = function() RunScript(AllScripts.Unbox) end })
GamesTab:CreateButton({ Name = "Roll An Item", Callback = function() RunScript(AllScripts.Roll) end })
GamesTab:CreateButton({ Name = "Saber Simulator", Callback = function() RunScript(AllScripts.Saber) end })

GamesTab:CreateSection("Utilidades")
GamesTab:CreateButton({ Name = "Gamepass Spoofer", Callback = function() AllScripts.Spoofer() end })
GamesTab:CreateButton({ Name = "Infinite Yield", Callback = function() 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end })
GamesTab:CreateButton({ Name = "Debug & Repair (Loader logic)", Callback = function() AllScripts.Debug() end })

-- [[ REMOTE SPY TAB ]] --
SpiesTab:CreateSection("Available Tools")

SpiesTab:CreateButton({
   Name = "Cobalt Spy",
   Callback = function()
      loadstring(game:HttpGet("https://github.com/notpoiu/cobalt/releases/latest/download/Cobalt.luau"))()
      Rayfield:Notify({Title = "Cobalt", Content = "Script carregado!", Duration = 3})
   end,
})

SpiesTab:CreateButton({
   Name = "Hydroxide",
   Callback = function()
      local owner = "Upbolt"
      local branch = "revision"
      local function webImport(file)
          return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')()
      end
      webImport("init")
      webImport("ui/main")
      Rayfield:Notify({Title = "Hydroxide", Content = "Script carregado!", Duration = 3})
   end,
})

SpiesTab:CreateButton({
   Name = "Utopia Spy",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Klinac/scripts/main/utopia_spy.lua", true))()
      Rayfield:Notify({Title = "Utopia Spy", Content = "Script carregado!", Duration = 3})
   end,
})

SpiesTab:CreateButton({
   Name = "Richie's Remote Spy",
   Callback = function()
      loadstring(game:HttpGetAsync("https://github.com/richie0866/remote-spy/releases/latest/download/RemoteSpy.lua"))()
      Rayfield:Notify({Title = "Remote Spy", Content = "Script carregado!", Duration = 3})
   end,
})

SpiesTab:CreateSection("Utilities")

SpiesTab:CreateButton({
   Name = "Developer Product",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/rndmq/Serverlist/refs/heads/main/Server87"))()
      Rayfield:Notify({Title = "Serverlist", Content = "Script carregado!", Duration = 3})
   end,
})

Rayfield:Notify({ Title = "AnonmyHub", Content = "Hub Unificado Pronto!", Duration = 5, Image = 4483362458 })
