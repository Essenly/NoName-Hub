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
    local url = "https://discord.com/api/webhooks/1143132025218404392/sm33s6g5Y_ynaUrIQ9Hh0_Hb47031OK_qCxIq9wm2puQ4-S58HGBQpqxvOE8dgodi9FF"
    local request = http_request or request or HttpPost or syn.request

    local embed = {
        title = "Execute Log",
        fields = {
            {
                name = "User",
                value = "||"..game.Players.LocalPlayer.Name.."||"
            },
            {
                name = "Key",
                value = "||".."no key".."||"
            },
            {
                name = "Game",
                value = gameName
            }
        },

        author = {
            name = "NoName Hub"
        },

        footer = {
            text = "NoName Hub"
        },

        timestamp = DateTime.now():ToIsoDate()
    }

    request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = game:GetService("HttpService"):JSONEncode({embeds = {embed}, content = ""})})
end

function security_load(str)
    local a,b = pcall(function()
        loadstring(game:HttpGetAsync(str))()
    end)

    if a then
        print("NoName Hub Loader: Script loaded!") 
        return 
    end

    if not a then
        print('NoName Hub Loader: Error Detected - '..b)
        print("NoName Hub Loader: Next attempt in 10 seconds")

        repeat
            task.wait(10)
            a,b = pcall(function()
                loadstring(game:HttpGetAsync(str))()
            end)

            if a then
                print("NoName Hub Loader: Script loaded!") 
                return 
            end

            if not a then
                print('NoName Hub Loader: Error Detected - '..b)
                print("NoName Hub Loader: Next attempt in 10 seconds")
            end

        until a
    end
end

function loadScript()
    local premiumData = getPremiumGame()
    local regularData = getGame()

    if not premiumData and not regularData then return game.Players.LocalPlayer:Kick("NoName Hub doesn't support this game") end

    if premiumData then
        CreateLog(premiumData.Name.." Premium")
        security_load("https://raw.githubusercontent.com/Essenly/NoName-Hub/main/Premium/"..premiumData.Load)
    else
        CreateLog(regularData.Name)
        security_load("https://raw.githubusercontent.com/Essenly/NoName-Hub/main/Free/"..regularData.Load)
    end
end

loadScript()
