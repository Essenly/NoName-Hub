-- variables

local HttpService = game:GetService("HttpService")

local plr = game.Players.LocalPlayer
local data = {
    AutoFishing = false,
    
    MacroName = "",
    RecordMacro = false,
}

local timeout = tick()
local MacroData = {}

-- functions

function Fishing()
    task.spawn(function()
        if data.AutoFishing == false then return end

        while true do
            if data.AutoFishing == false then return end
    
            local stuff = getrenv()._G.FireNetwork
            local id = plr.UserId
        
            stuff("PlayerCatchFish", id)
    
            task.wait()
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
        while true do
            if not checkBanner() then return end
            if not checkCoins() then return end
            if not data.AutoSpin then return end
    
            local unit = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Globalinit"):WaitForChild("RemoteEvent"):WaitForChild("PlayerBuyTower"):FireServer(1)
            print("Spin Unit:", unit)

            task.wait()
        end
    end)
end

function upgradeTower(id)
    
end

function placeTower(id, position)
    game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service"):WaitForChild("Network"):WaitForChild("PlayerPlaceTower"):FireServer(id, position)
end

function saveMacroType(info)
    if not data.RecordMacro then return end

    info.Timeout = tick() - timeout

    MacroData[#MacroData+1] = info

    timeout = tick()
end

function saveMacro()
    local macrodata = HttpService:JSONEncode(MacroData)
    MacroData = {}

    print(macrodata)
end

-- hookfunctions

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
                Position = args[2]
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

    return namecall(self, ...)
end)

-- coroutine

coroutine.resume(coroutine.create(function()
    while task.wait(5) do
        Fishing()

        if checkCoins() and checkBanner() then
            Spin()
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
    Callback = function(value)
        data.MacroName = value
    end
})

Game:CreateToggle({
    Name = "Record Macro",
    CurrentValue = false,
    Flag = "RecordMacro",
    Callback = function(value)
        if string.len(data.MacroName) == 0 then
            UI.Flags["RecordMacro"]:Set(false)
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



-- load

UI:loadFlags()
