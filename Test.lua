_G.key = _G.key or ""

local UI = loadstring(game:HttpGet('https://raw.githubusercontent.com/Essenly/NoName-Hub/main/UI.lua'))()

local KeyLibrary = loadstring(game:HttpGet('https://raw.githubusercontent.com/MaGiXxScripter0/keysystemv2api/master/setup_obf.lua'))()
local KeySystem = KeyLibrary.new("NoNameHub", {authType = "clientid"})

local verify = KeySystem:verifyPremiumKey(_G.key)

if not verify then
    UI:Notify("Key System", "Invalid Key / HWID. You can try recheck your key or reset hwid", 4)
    return
end

-- variables

local HttpService = game:GetService("HttpService")

local plr = game.Players.LocalPlayer
local data = {
    AutoFishing = false,
    
    MacroName = "",
    RecordMacro = false,
    SelectedMacro = "",
    PlayMacro = false,

    AutoSkip = false,
    AutoStartGame = false
}

local timeout = tick()
local MacroData = {}
local MacroStatus = "None"
local startTime = os.time()

-- functions

function convertToMS(Seconds)
    local function Format(Int)
        return string.format("%02i", Int)
    end

    local Minutes = (Seconds - Seconds%60)/60
	Seconds = Seconds - Minutes*60

	return Format(Minutes)..":"..Format(Seconds)
end

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

-- macro

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
    UI:Notify("Record Macro", "Macro saved!", 4)
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

function startGame()
    pcall(function()
        if plr.PlayerGui.MainGui.MainFrames.StartMatch.Visible then
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerVoteToStartMatch"):FireServer()
        end
    end)
end

function skipWave()
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerReadyForNextWave"):FireServer()
    end)
end

function teleport_to_game(map, diff)
    if not workspace:FindFirstChild("Lobby") then return end
    local teleporters = workspace.Lobby.ClassicPartyTeleporters

    for i,v in pairs(teleporters:GetChildren()) do
        local status = v.Teleport.DisplayPart.BillboardGui.Status

        if status.Text == "0/20 Players" then
            local savedCFrame = plr.Character.HumanoidRootPart.CFrame

            plr.Character.HumanoidRootPart.CFrame = v.Top.CFrame

            task.wait(1)

            game.ReplicatedStorage.Modules.GlobalInit.RemoteEvents.PlayerQuickstartTeleport:FireServer(map, diff)

            task.wait(1)

            plr.Character.HumanoidRootPart.CFrame = savedCFrame

            task.wait(4)
        end
    end
end

function getTower(Position)
    local Towers = workspace.EntityModels.Towers

    for i,v in pairs(Towers:GetChildren()) do
        if v.HumanoidRootPart.Position == Position then
            return v
        end
    end

    return nil
end

function playMacro()
    if not game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service"):WaitForChild("Network"):WaitForChild("PlayerPlaceTower") then return end

    local selectedMacro = readMacro()

    UI:Notify("Macro Play", "Macro "..data.SelectedMacro.." started!", 3)

    for i,v in pairs(selectedMacro) do
        if getWave() < v.Wave then
            MacroStatus = "Waiting "..v.Wave.." wave.."
            repeat task.wait() until getWave() >= v.Wave
        end

        local Timeout = tick()

        MacroStatus = "Waiting "..(math.round(v.Timeout * 10^2) / 10^2).."s.."

        repeat task.wait() until tick() - Timeout >= v.Timeout

        if v.Action == "PlaceTower" then
            MacroStatus = "Action ["..i.."] Placing Tower.."
            game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service"):WaitForChild("Network"):WaitForChild("PlayerPlaceTower"):FireServer(v.Tower, Vector3.new(v.Position[1], v.Position[2], v.Position[3]))
        end

        if v.Action == "UpgradeTower" then
            MacroStatus = "Action ["..i.."] Upgrading Towe.."
            local Position = Vector3.new(v.Position[1], v.Position[2], v.Position[3])
            local Tower = getTower(Position)
            if Tower then
                game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service"):WaitForChild("Network"):WaitForChild("PlayerUpgradeTower"):FireServer(Tower.Name)
            end
        end

        if v.Action == "SetTargetTower" then
            MacroStatus = "Action ["..i.."] Change Target Tower.."
            local Position = Vector3.new(v.Position[1], v.Position[2], v.Position[3])
            local Tower = getTower(Position)
            if Tower then
                game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerSetTowerTargetMode"):FireServer(Tower.Name, v.Target)
            end
        end

        if v.Action == "SellTower" then
            MacroStatus = "Action ["..i.."] Selling Tower.."
            local Position = Vector3.new(v.Position[1], v.Position[2], v.Position[3])
            local Tower = getTower(Position)
            if Tower then
                game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service"):WaitForChild("Network"):WaitForChild("PlayerSellTower"):FireServer(Tower.Name)
            end
        end

    end

    UI:Notify("Macro Play", "Macro "..data.SelectedMacro.." done!", 3)
    MacroStatus = "Macro is done"

    if #selectedMacro > 0 then
        task.wait(9e9)
    end
end

-- hookfunctions

task.spawn(function()
    local placetower = game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service"):WaitForChild("Network"):WaitForChild("PlayerPlaceTower")
    local upgradetower = game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service"):WaitForChild("Network"):WaitForChild("PlayerUpgradeTower")
    local set_target_tower = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerSetTowerTargetMode")
    local sell_tower = game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service"):WaitForChild("Network"):WaitForChild("PlayerSellTower")
    local Towers = workspace.EntityModels.Towers

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
                print(args[1])
                local Pos = Towers:FindFirstChild(args[1]).HumanoidRootPart.Position
                saveMacroType({
                    Action = "UpgradeTower",
                    Position = {Pos.X, Pos.Y, Pos.Z},
                })
            end

            if self == set_target_tower then
                local Pos = Towers:FindFirstChild(args[1]).HumanoidRootPart.Position
                saveMacroType({
                    Action = "SetTargetTower",
                    Position = {Pos.X, Pos.Y, Pos.Z},
                    Target = args[2]
                })
            end

            if self == sell_tower then
                local Pos = Towers:FindFirstChild(args[1]).HumanoidRootPart.Position

                saveMacroType({
                    Action = "SellTower",
                    Position = {Pos.X, Pos.Y, Pos.Z},
                })
            end
        end

        return hook(self, ...)
    end)
end)

-- task spawns

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if data.AutoStartGame then
                startGame()
            end

            if data.AutoSkip then
                skipWave()
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(1) do
        local a,b = pcall(function()
            Fishing()
        end)

        if not a then print(b) end
    end
end)

-- coroutine

coroutine.resume(coroutine.create(function()
    while task.wait(5) do
        local succ, err = pcall(function()

            if checkCoins() and checkBanner() then
                Spin()
            end

            if data.AutoJoin then
                teleport_to_game(data.SelectedMap, data.SelectedDiff)
            end
    
            if game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service"):WaitForChild("Network"):WaitForChild("PlayerPlaceTower") then
                
                if data.PlayMacro then
                    playMacro()
                end

            end
        end)

        if not succ then print(err) end
    end
end))

-- gui

local Window = UI:CreateWindow("UTD")
Window:CreateHideButton(true)

-- Tabs

local Lobby = Window:CreateTab("Lobby")
local Game = Window:CreateTab("Game")
local Settings = Window:CreateTab("Settings")

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
            UI:Notify("Record Macro", "Macro name cannot be empty!", 2)
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
    Options = getMacros(),
    CurrentValue = {},

    Callback = function(value)
        data.SelectedMacro = value[1]
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

Game:CreateSection("Settings")

Game:CreateDropdown({
    Name = "Select Map",
    Flag = "SelectedMap",
    MultiSelection = false,
    Options = {"Planet Namek", "Hidden Leaf Village", "Marineford", "Kamii University", "Kami's Lookout", "Space", "Costa Shemaralda", "Skeleton Hell Stone", "Vally of the End", "Ruby Palace", "Ant's Nest", "Trost District", "Karakura Town", "Menos' Garden", "Orange Town", "Shibuya Train Station", "Eishu Detention Center", "Chamber of Agony"},
    CurrentValue = {"Planet Namek"},

    Callback = function(value)
        data.SelectedMap = value[1]
    end
})

Game:CreateDropdown({
    Name = "Select Diff",
    Flag = "SelectedDiff",
    MultiSelection = false,
    Options = {"Classic", "Hard", "Infinite Mode"},
    CurrentValue = {"Classic"},

    Callback = function(value)
        data.SelectedDiff = value[1]
    end
})

Game:CreateToggle({
    Name = "Auto Join",
    CurrentValue = false,
    Flag = "Auto Join",
    Callback = function(value)
        data.AutoJoin = value
    end
})

Game:CreateToggle({
    Name = "Auto Start Match",
    CurrentValue = false,
    Flag = "Auto Start Match",
    Callback = function(value)
        data.AutoStartGame = value
    end
})

Game:CreateToggle({
    Name = "Auto Skip Wave",
    CurrentValue = false,
    Flag = "Auto Skip Wave",
    Callback = function(value)
        data.AutoSkip = value
    end
})

-- Settings

Settings:CreateSection("Script Info")

local Wave = Settings:CreateLabel("Wave: 0")
local Macro = Settings:CreateLabel("Macro: None")
local Status = Settings:CreateLabel("Macro Status: None")
local Time = Settings:CreateLabel("Time: 00:00")

task.spawn(function()
    while task.wait(1) do
        local scriptTime = convertToMS(os.time() - startTime)
        local macroName = ""

        if string.len(data.MacroName) > 0 then
            macroName = data.MacroName
        else
            macroName = "None"
        end

        Wave:Set("Wave: "..getWave())
        Macro:Set("Macro: "..macroName)
        Status:Set("Macro Status: "..MacroStatus)
        Time:Set("Time: "..scriptTime)
    end
end)


-- load

UI:loadFlags()
