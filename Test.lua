repeat task.wait() until game:IsLoaded()

local PremiumDataGames = {
    ["Anime Dimension"] = {
        Ids = {6938803436, 6990129309, 6990131029, 6990133340, 7274690025, 7338881230},
        Name = "Anime Dimension",
        Load = "Anime%20Dimension.lua"
    },
}
local RegularDataGames = {
    ["Anime Dimension"] = {
        Ids = {6938803436, 6990129309, 6990131029, 6990133340, 7274690025, 7338881230},
        Name = "Anime Dimension",
        Load = "Anime%20Dimension.lua"
    },
}

local Log = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Essenly/NoName-Hub/main/Log.Lua"))()

function isPremium()
    if not getgenv().PremiumKey then return false end

    if typeof(getgenv().PremiumKey) ~= "string" then return false end
    if string.len(getgenv().PremiumKey) < 32 then return false end

    return true
end

function getPremiumGame()
    if not isPremium() then return false end

    for i,v in pairs(PremiumDataGames) do
        if table.find(v.Ids, game.PlaceId) then
            return v
        end
    end

    return nil
end

function getGame()
    for i,v in pairs(RegularDataGames) do
        if table.find(v.Ids, game.PlaceId) then
            return v
        end
    end

    return nil
end

function CreateLog(gameName)
    for i,v in pairs(Log) do
        print(i,v)
    end
end

function loadScript()
    local premiumData = getPremiumGame()
    local regularData = getGame()

    if not premiumData and not regularData then return game.Players.LocalPlayer:Kick("NoName Hub doesn't support this game") end

    if premiumData then
        CreateLog(premiumData.Name.." Premium")
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Essenly/NoName-Hub/main/Premium/"..premiumData.Load))()
    else
        CreateLog(regularData.Name)
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Essenly/NoName-Hub/main/Free/"..regularData.Load))()
    end
end

loadScript()
