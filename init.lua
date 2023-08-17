local Scripts = {
    [6938803436]  = {Name = "Anime Dimensions."},
}

repeat task.wait() until game:IsLoaded()

local PromptLib = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/AlexR32/Roblox/main/Useful/PromptLibrary.lua"))()
local MarketplaceService = game:GetService("MarketplaceService")
local QueueOnTeleport = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport)

local Loaded = false

if getgenv().NoNameHub then return end

local success, info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, game.PlaceId)
if not success then
    PromptLib("Error", "Failed to retrieve product info. \n(Error Code: 117)", {
        {Text = "OK", LayoutOrder = 0, Primary = true, Callback = function() end}
    })
    return
end

for i,v in pairs(Scripts) do
    if game.PlaceId == i or string.match(info.Name, v.Name) then
        print("Found supported game:", v.Name)
        loadstring(game:HttpGet(`https://raw.githubusercontent.com/Essenly/NoName-Hub/main/{i}.lua`, true))()
        Loaded = true
        getgenv().NoNameHub = true
    end
end

if Loaded == false then
    return game.Players.LocalPlayer:Kick("NoName Hub does not support this game")
end

game.Players.LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.InProgress then
        QueueOnTeleport("loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Essenly/NoName-Hub/main/init.lua')()")
    end
end)
