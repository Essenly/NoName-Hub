repeat task.wait() until game:IsLoaded()

local Scripts = {
    13995491879, -- Lisowo
}

if not table.find(Scripts, game.PlaceId) then return game.Players.LocalPlayer:Kick("Not supported place") end

loadstring(game:HttpGet(`https://raw.githubusercontent.com/Essenly/NoName-Hub/main/{game.PlaceId}.lua`, true))()
