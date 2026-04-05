-- Anonmy Project | Gamepass Spoofer
-- Este script intercepta chamadas do MarketplaceService para simular a posse de Gamepasses.

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Armazenamos as funções originais caso precisem ser restauradas ou usadas internamente
local oldUserOwnsGamePassAsync
local oldPlayerOwnsAsset

-- Log de Depuração (Opcional)
local function log(msg)
    print("[Gamepass Spoofer] " .. msg)
end

-- Hook para UserOwnsGamePassAsync
-- Esta função é a mais comum para verificar gamepasses.
oldUserOwnsGamePassAsync = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if self == MarketplaceService and (method == "UserOwnsGamePassAsync" or method == "userOwnsGamePassAsync") then
        local userId = args[1]
        local gamepassId = args[2]

        -- Se estiver verificando o LocalPlayer, retornamos true sempre.
        if userId == LocalPlayer.UserId then
            -- log("Interceptado UserOwnsGamePassAsync para Gamepass: " .. tostring(gamepassId))
            return true
        end
    end

    return oldUserOwnsGamePassAsync(self, ...)
end)

-- Hook para PlayerOwnsAsset
-- Usado para itens de catálogo e alguns gamepasses antigos.
oldPlayerOwnsAsset = hookfunction(LocalPlayer.PlayerOwnsAsset, function(self, assetId)
    -- log("Interceptado PlayerOwnsAsset para Asset: " .. tostring(assetId))
    return true
end)

-- Sistema Adicional: Algumas UIs verificam o MarketplaceService diretamente sem Namecall
if MarketplaceService.UserOwnsGamePassAsync then
    local oldFunc = MarketplaceService.UserOwnsGamePassAsync
    MarketplaceService.UserOwnsGamePassAsync = function(self, userId, gamepassId)
        if userId == LocalPlayer.UserId then
            return true
        end
        return oldFunc(self, userId, gamepassId)
    end
end

log("Spoofer Ativado com Sucesso!")

-- Notificação Visual (opcional, requer Rayfield se integrado, mas aqui usamos o padrão)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Gamepass Spoofer",
    Text = "Desbloqueio Local Ativado!",
    Duration = 5
})
