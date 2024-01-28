-- variables

local HttpService = game:GetService("HttpService")

local plr = game.Players.LocalPlayer
local data = {
    AutoFishing = false,
    
    MacroName = "",
    RecordMacro = false,
    SelectedMacro = "",
    PlayMacro = false,
}

local timeout = tick()
local MacroData = {}

-- functions

function Fishing()
    task.spawn(function()
        if data.AutoFishing == false then return end

        while task.wait() do
            if data.AutoFishing == false then return end
    
            local stuff = getrenv()._G.FireNetwork
            local id = plr.UserId
        
            stuff("PlayerCatchFish", id)
        end
    end)
end

function checkBanner()
    return true
end

function checkCoins()
    return 9999
end

function Spin()
    if not data.AutoSpin then return end
    
    task.spawn(function()
        while task.wait() do
            if not checkBanner() then return end
            if not checkCoins() then return end
            if not data.AutoSpin then return end
    
            local unit = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Globalinit"):WaitForChild("RemoteEvent"):WaitForChild("PlayerBuyTower"):FireServer(1)
            print("Spin Unit:", unit)

        end
    end)
end

function upgradeTower(id)
    
end

function placeTower(id, position)
    game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service"):WaitForChild("Network"):WaitForChild("PlayerPlaceTower"):FireServer(id, position)
end



function getWave()
    local Label = plr.PlayerGui.MainGui.MainFrames.Wave.WaveIndex
    local split = string.split(Label.Text, "")

    local number = ""

    for i,v in pairs(split) do
        if tonumber(v) == nil and string.len(number) > 0 then
            break
        end

        if tonumber(v) ~= nil then
            number = number..v
        end
    end

    return tonumber(number) or 0
end

function saveMacroType(info)
    if not data.RecordMacro then return end

    info.Timeout = tick() - timeout
    info.Wave = getWave()

    MacroData[#MacroData+1] = info

    timeout = tick()
end

function saveMacro()
    local macrodata = HttpService:JSONEncode(MacroData)
    MacroData = {}

    if not isfolder("NoNameHub") then
        makefolder("NoNameHub")
    end

    if not isfolder("NoNameHub/NoNameHub_Macros") then
        makefolder("NoNameHub/NoNameHub_Macros")
    end

    writefile("NoNameHub/NoNameHub_Macros/"..data.MacroName..".json", macrodata)
    print("Macro saved!")
end

function getMacros()
    if not isfolder("NoNameHub") or not isfolder("NoNameHub/NoNameHub_Macros") then return {} end

    local Files = listfiles("NoNameHub/NoNameHub_Macros")
    local Macros = {}
    
    for i,v in pairs(Files) do
        local newName = string.gsub(v, "NoNameHub/NoNameHub_Macros/", "")
        newName = newName:gsub(".json", "")
        table.insert(Macros, newName)
    end

    return Macros
end

function readMacro()
    local SelectedMacro = data.SelectedMacro..".json"

    if not isfile("NoNameHub/NoNameHub_Macros/"..SelectedMacro) then print("This macro is empty") return {} end

    local MacroFile = readfile("NoNameHub/NoNameHub_Macros/"..SelectedMacro)


    local DecodedJson = HttpService:JSONDecode(MacroFile)

    return DecodedJson
end

function playMacro()
    if not game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service"):WaitForChild("Network"):WaitForChild("PlayerPlaceTower") then return end
    if string.len(data.SelectedMacro) == 0 then return end

    local selectedMacro = readMacro()

    for i,v in pairs(selectedMacro) do
        if getWave() < v.Wave then
            repeat task.wait() until getWave() >= v.Wave
        end

        local Timeout = tick()

        repeat task.wait() until tick() - Timeout >= v.Timeout

        if v.Action == "PlaceTower" then
            game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service"):WaitForChild("Network"):WaitForChild("PlayerPlaceTower"):FireServer(v.Tower, v.Position)
        end

        if v.Action == "UpgradeTower" then
            game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service"):WaitForChild("Network"):WaitForChild("PlayerUpgradeTower"):FireServer(v.Tower)
        end

        if v.Action == "SetTargetTower" then
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerSetTowerTargetMode"):FireServer(v.Tower, v.Target)
        end

        if v.Action == "SellTower" then
            game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service"):WaitForChild("Network"):WaitForChild("PlayerSellTower"):FireServer(v.Tower)
        end
    end
end

-- hookfunctions

task.spawn(function()
    local placetower = game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service"):WaitForChild("Network"):WaitForChild("PlayerPlaceTower")
    local upgradetower = game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service"):WaitForChild("Network"):WaitForChild("PlayerUpgradeTower")
    local set_target_tower = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerSetTowerTargetMode")
    local sell_tower = game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service"):WaitForChild("Network"):WaitForChild("PlayerSellTower")

    local hook; hook = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod():lower()

        if not checkcaller() and method == "fireserver" then
            
            if self == placetower then
                saveMacroType({
                    Action = "PlaceTower",
                    Tower = args[1],
                    Position = {args[2].X, args[2].Y, args[2].Z}
                })
            end

            if self == upgradetower then
                saveMacroType({
                    Action = "UpgradeTower",
                    Tower = args[1],
                })
            end

            if self == set_target_tower then
                saveMacroType({
                    Action = "SetTargetTower",
                    Tower = args[1],
                    Target = args[2]
                })
            end

            if self == sell_tower then
                saveMacroType({
                    Action = "SellTower",
                    Tower = args[1],
                })
            end
        end

        return hook(self, ...)
    end)
end)

-- coroutine

coroutine.resume(coroutine.create(function()
    while task.wait(5) do
        Fishing()

        if checkCoins() and checkBanner() then
            Spin()
        end

        if game.PlaceId ~= 5902977746 then
            
            if data.PlayMacro then
                playMacro()
            end

        end
    end
end))

-- gui

local UI = loadstring(game:HttpGet('https://raw.githubusercontent.com/Essenly/NoName-Hub/main/UI.lua'))()

local Window = UI:CreateWindow("UTD")
Window:CreateHideButton(true)

-- Tabs

local Lobby = Window:CreateTab("Lobby")
local Game = Window:CreateTab("Game")

-- Lobby

Lobby:CreateToggle({
    Name = "Auto Fishing",
    CurrentValue = false,
    Flag = "Auto Fishing",
    Callback = function(value)
        data.AutoFishing = value
    end
})

-- Game

Game:CreateSection("Macro")

Game:CreateBox({
    Name = "Macro Name",
    Placeholder = "Name here",
    Flag = "MacroName",
    CanChangedByFlag = false,
    CurrentValue = "",

    Callback = function(value)
        data.MacroName = value
    end
})

Game:CreateToggle({
    Name = "Record Macro",
    CurrentValue = false,
    CanChangedByFlag = false,
    Flag = "RecordMacro",

    Callback = function(value)
        if not data.MacroName then return end
        if string.len(data.MacroName) == 0 then
            UI.Flags["RecordMacro"]:Set(false, false)
            MacroData = {}
            return
        end

        if value then
            data.RecordMacro = true
            MacroData = {}
            timeout = tick()
            return
        end

        data.RecordMacro = false
        
        if #MacroData > 0 then
            saveMacro()
        end
    end
})

Game:CreateSection("Play Macro")


local MacroList = Game:CreateDropdown({
    Name = "Macro List",
    Flag = "SelectedMacro",
    MultiSelection = false,
    CanChangedByFlag = false,
    Options = getMacros(),
    CurrentValue = {},

    Callback = function(value)
        data.SelectedMacro = value
    end
})

Game:CreateButton({
    Name = "Update List",
    Callback = function()
        MacroList:Update(getMacros())
    end
})

Game:CreateToggle({
    Name = "Play Macro",
    CurrentValue = false,
    Flag = "Play Macro",
    Callback = function(value)
        data.PlayMacro = value
    end
})




-- load

UI:loadFlags()
