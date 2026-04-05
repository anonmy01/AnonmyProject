-- [[ 
    Anonmy Remote Spy | Script Loader Hub
    Gathers all your favorite Remote Spies in one place.
]]

getgenv().Color = "default" --[[white,black, brown,green,cyan,blue,pink,purple,red,yellow,orange ]]--
getgenv().TextColor = "default" --[[ rgb,white,black, brown,green,cyan,blue,pink,purple,red,yellow,orange ]]--

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Anonmy Project | Remote Spy Hub",
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
      FileName = "RemoteSpyHub"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = false,
})

local SpiesTab = Window:CreateTab("📡 Remote Spies", 4483362458)
local UtilsTab = Window:CreateTab("⚙️ Utilities", 4483362458)

-- Remote Spies Section
SpiesTab:CreateSection("Available Tools")

SpiesTab:CreateButton({
   Name = "Cobalt Hub",
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

-- Utilities Section
UtilsTab:CreateSection("Server List")

UtilsTab:CreateButton({
   Name = "Serverlist (87)",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/rndmq/Serverlist/refs/heads/main/Server87"))()
      Rayfield:Notify({Title = "Serverlist", Content = "Script carregado!", Duration = 3})
   end,
})

UtilsTab:CreateSection("UI Settings")

UtilsTab:CreateButton({
   Name = "Destroy UI",
   Callback = function()
      Rayfield:Destroy()
   end,
})

Rayfield:Notify({
   Title = "Hub de Spies",
   Content = "Pronto para usar!",
   Duration = 5
})
