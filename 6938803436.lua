task.spawn(function()
    local reason = "You cannot skip whitelist part"
    while task.wait() do
        if getgenv().WL ~= true then
            return game.Players.LocalPlayer:Kick(reason)
        end
        if getgenv().MegaUltraBoy ~= true then
            return game.Players.LocalPlayer:Kick(reason)
        end
        if getgenv().Access ~= false then
            return game.Players.LocalPlayer:Kick(reason)
        end
        if getgenv().Premium ~= false then
            return game.Players.LocalPlayer:Kick(reason)
        end
        if getgenv().NoNameHub ~= true then
            return game.Players.LocalPlayer:Kick(reason)
        end
    end
end)

-- variables

local Dimension
local Difficulty

local ReplicatedStorage = game.ReplicatedStorage
local plr = game.Players.LocalPlayer
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local twn = nil

local Settings = {
    Object = nil,

    AutoDetectLevel = false,
    Dimension = "",
    Difficulty = "",
    Hardcore = false,
    FarmDimension = false,
    FarmSpeedRaid = false,
    FarmBossRush = false,
    TimeChallenge = false,

    FarmRaid = false,
    Raid = "",

    TPDist = 5,

    Dodge = false,

    Punch = false,
    PunchTime = 1.5,


    AutoSkill = false,
    AutoSkillTime = 1.5,

    DailyQuest = false,
    FPSBoost = false,
    WhiteScreen = false,

    ClearWebhook = false

}

-- functions

function getDimensionReward()
    local DimensionReward = {}
    local rewardGridFrame
    local uiVisible = game.Players.LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.ResultUI.Visible or game.Players.LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.RaidResultUI.Visible

    if uiVisible then
        if game.Players.LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.ResultUI.Visible then
            rewardGridFrame = game.Players.LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.ResultUI.RewardFrame.RewardGridFrame
        elseif game.Players.LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.RaidResultUI.Visible then
            for _,c in pairs(game.Players.LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.RaidResultUI.Frame:GetDescendants()) do
                if c.Name == "RaidRewardGridFrame" then
                    rewardGridFrame = c
                    break
                end
            end
        end

        if rewardGridFrame then
            for _,v in pairs(rewardGridFrame:GetChildren()) do
                if v.Name ~= "UIGridLayout" then
                    if DimensionReward[v.Name] then
                        DimensionReward[v.Name] = DimensionReward[v.Name] + 1
                    else
                        DimensionReward[v.Name] = 1
                    end
                end
            end
            local DimensionRewardString = ""
            for k,v in pairs(DimensionReward) do
                if v > 1 then
                    DimensionRewardString = DimensionRewardString .. " - " .. k .. " x" .. v .. ", "
                else
                    DimensionRewardString = DimensionRewardString .. " - " .. k .. ", "
                end
            end
            return DimensionRewardString
        end
    end
end

function getwebhook()
    if isfolder("NoName_Hub") then
        if isfile("NoName_Hub/WebHook.txt") then
            getgenv().webhook = readfile("NoName_Hub/WebHook.txt")
        end
    end
end

getwebhook()

function webhook(_, a0)
    if getgenv().webhook == nil then return end
    local request = http_request or request or HttpPost or syn.request
    request(
        {
            Url = getgenv().webhook,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode({embeds = {_}, content = a0})
        }
    )
end

function setLevelMap(mapname, diff)
    Dimension:Set({mapname})
    Difficulty:Set({diff})

    Settings.Dimension = mapname
    Settings.Difficulty = diff
end

function setLevel()
    if Settings.AutoDetectLevel == false then return end
    local level = game.Players.LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Level").Value

    if level >= 131 then
        setLevelMap("Pirate Dimension", "Nightmare")
        return
    end

    if level >= 121 then
        setLevelMap("Devil Dimension", "Nightmare")
        return
    end

    if level >= 113 then
        setLevelMap("Slime Dimension", "Nightmare")
        return
    end

    if level >= 106 then
        setLevelMap("Slime Dimension", "Easy")
        return
    end

    if level >= 98 then
        setLevelMap("Fate Dimension", "Nightmare")
        return
    end

    if level >= 91 then
        setLevelMap("Fate Dimension", "Easy")
        return
    end

    if level >= 83 then
        setLevelMap("Ghoul Dimension", "Nightmare")
        return
    end

    if level >= 76 then
        setLevelMap("Ghoul Dimension", "Easy")
        return
    end

    if level >= 68 then
        setLevelMap("Sword Dimension", "Nightmare")
        return
    end
    
    if level >= 61 then
        setLevelMap("Sword Dimension", "Easy")
        return
    end

    if level >= 56 then
        setLevelMap("Villain Dimension", "Nightmare")
        return
    end

    if level >= 51 then
        setLevelMap("Villain Dimension", "Hard")
        return
    end

    if level >= 46 then
        setLevelMap("Villain Dimension", "Easy")
        return
    end

    if level >= 41 then
        setLevelMap("Curse Dimension", "Nightmare")
        return
    end

    if level >= 36 then
        setLevelMap("Curse Dimension", "Hard")
        return
    end

    if level >= 31 then
        setLevelMap("Curse Dimension", "Easy")
        return
    end

    if level >= 26 then
        setLevelMap("Demon Dimension", "Nightmare")
        return
    end
    
    if level >= 21 then
        setLevelMap("Demon Dimension", "Hard")
        return
    end

    if level >= 16 then
        setLevelMap("Demon Dimension", "Easy")
        return
    end

    if level >= 11 then
        setLevelMap("Titan Dimension", "Nightmare")
        return
    end

    if level >= 6 then
        setLevelMap("Titan Dimension", "Hard")
        return
    end

    if level >= 1 then
        setLevelMap("Titan Dimension", "Easy")
        return
    end
end

function createRoom(mapname, diff, hard)

    if typeof(mapname) ~= "string" then return end
    if typeof(diff) ~= "string" then return end
    if typeof(hard) ~= "boolean" then return end

    game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom",{["Difficulty"] = diff, ["FriendsOnly"] = true, ["MapName"] = mapname, ["Hardcore"] = hard})
end

function startRoom()
    game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("TeleportPlayers")
end

function checkDist()
    if Settings.Object == nil then
        return false
    end

    local dist = (plr.Character.HumanoidRootPart.Position - Settings.Object.HumanoidRootPart.Position).Magnitude

    if dist < 25 then
        return true
    end
    return false
end

function check()
    if Settings.Object == nil then
        return false
    end

    local obj = Settings.Object

    if not obj:FindFirstChildOfClass("Humanoid") then
        return false
    end

    if obj:FindFirstChildOfClass("Humanoid").Health <= 0 then
        return false
    end

    return true
end


function Tween(obj)
    if twn then return end
    if not obj or not obj:FindFirstChild("HumanoidRootPart") then return end
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end

    if not plr.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
        local BodyVelocity = Instance.new("BodyVelocity", plr.Character.HumanoidRootPart)
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end

    local Dist = (obj.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
    local Info =  TweenInfo.new(Dist / 120, Enum.EasingStyle.Linear)
    twn = TweenService:Create(plr.Character.HumanoidRootPart, Info, {CFrame = obj.HumanoidRootPart.CFrame * CFrame.new(0, 0, Settings.TPDist)})
    twn:Play()
    twn.Completed:Wait()
    twn = nil

    if not getNearestMobs() then
        for _, v in pairs(plr.Character.HumanoidRootPart:GetChildren()) do
            if v:IsA("BodyVelocity") then
                v:Destroy()
            end
        end
    end
end

function join()
    if game.PlaceId ~= 6938803436 and game.PlaceId ~= 7274690025 then return end
    if Settings.FarmDimension then
        pcall(function()
            createRoom(Settings.Dimension, Settings.Difficulty, Settings.Hardcore)
            startRoom()
        end)
    end
end

function farm()
    if game.PlaceId == 6938803436 or game.PlaceId == 7274690025 then return end
    while task.wait() do
        if Settings.FarmRaid == false and Settings.FarmDimension == false then
            break
        end
        Settings.Object = getNearestMobs()
        repeat
            if not Settings.Object then
                repeat Settings.Object = getNearestMobs() task.wait() until Settings.Object
            end
            pcall(function()
                Tween(Settings.Object)
            end)
            task.wait()
        until not Settings.Object:FindFirstChildOfClass("Humanoid") or Settings.Object:FindFirstChildOfClass("Humanoid").Health <= 0
    end
end

function getNearestMobs()
    local TargetDistance = math.huge
    local Target
    pcall(function()
        for i,v in pairs(workspace.Folders.Monsters:GetChildren()) do
            if v.ClassName == "Model" and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health ~= 0 then
                local Mag = (plr.Character.HumanoidRootPart.Position - v:FindFirstChildOfClass("Part").Position).Magnitude
                if Mag < TargetDistance then
                    TargetDistance = Mag
                    Target = v
                end
            end
        end
    end)
    return Target
end

function checkQuest(questName)
    local PlayerGui = Players.PlayerGui.MainGui.CenterUIFrame.QuestFrame.QuestFrames.DailyQuestFrame.DailyQuestScrollingFrame[questName]
    if PlayerGui.QuestComplete:FindFirstChild("ExclamationPoint") then
        ReplicatedStorage.RemoteFunctions.MainRemoteFunction:InvokeServer("CompleteDailyQuest", questName)
    end
end

function getCharacter()
    local CharacterList = {}
    for _,v in pairs(Players.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:GetChildren()) do
        if v.Name ~= "CharacterInventorySlot" and v:IsA("ImageButton") then
            CharacterList[#CharacterList + 1] = v.Name
        end
    end
    return CharacterList
end

-- Extra Functions


game:GetService("UserInputService").WindowFocusReleased:Connect(function()
    if Settings.WhiteScreen then
        game:GetService("RunService"):Set3dRenderingEnabled(false)
        setfpscap(20)
    end
end)

game:GetService("UserInputService").WindowFocused:Connect(function()
    if Settings.WhiteScreen then
        game:GetService("RunService"):Set3dRenderingEnabled(true)
        setfpscap(60)
    end
end)

workspace.Folders.Debris.ChildAdded:Connect(function(debris)
    pcall(function()
        if Settings.Dodge and table.find({"telegraph"}, debris.Name:lower()) and debris.Material ~= Enum.Material.Neon then
            local originalMaterial = debris.Material
            task.wait(Settings.DodgeDelay)
            local clone = debris:Clone()
            local padding = math.clamp(Settings.DodgeSize, 1.5, 8)
            local targetSize = debris.Size + Vector3.new(padding, 100, padding)
            clone.Size = Vector3.new(0, 100, debris.Size.Z)
            if debris.ClassName == "MeshPart" then
                clone.Size = Vector3.new(0, 0, 100)
                targetSize = debris.Size + Vector3.new(padding, padding, 100)
            end
            TweenService:Create(clone, TweenInfo.new(0.07), {Size = targetSize}):Play()
    
            clone.Anchored = true
            clone.Transparency = 1
            clone.CanCollide = true
            clone.Name = "Dodge"
            clone.Parent = debris.Parent
            local startTime = tick()
            repeat task.wait() until tick() - startTime > 100 or not debris.Parent
            clone:Destroy()
        end
    end)
end)



-- task.spawn functions

task.spawn(function()
    while task.wait(1) do
        if Settings.DailyQuest then
            pcall(function()
                checkQuest("DailyQuest_Login")
                checkQuest("DailyQuest_Enemies")
                checkQuest("DailyQuest_DungeonClear")
                checkQuest("DailyQuest_Raid")
                checkQuest("DailyQuest_BossRush")
                checkQuest("DailyQuest_AllQuestClear")
            end)
        end
    end
end)


task.spawn(function()
    local a = false
    while task.wait(1) do
        if a == true then
            break
        end

        pcall(function()
            local rewards = getDimensionReward()
            if rewards and Settings.ClearWebhook then
                local name = plr.Name.."StatDisplay"
                local data = {
                    ["title"] = "Anime Dimensions Simulator",
                    ["type"] = "rich",
                    ["description"] = "Character Info / Session Info:",
                    ["fields"] = {
                        {
                            ["name"] = "💥 My Level",
                            ["value"] = game:GetService("HttpService"):JSONDecode(
                                game.Players.LocalPlayer.leaderstats.Level.Value
                            )
                        },
                        {
                            ["name"] = "Rewards",
                            ["value"] = rewards
                        },
                        {
                            ["name"] = "⚠️ Exploit Detected",
                            ["value"] = game:GetService("HttpService"):JSONDecode(
                                game.ReplicatedStorage[name].ExploitsDetected.Value
                            )
                        },
                        {
                            ["name"] = "💠 Infinite Record",
                            ["value"] = game:GetService("HttpService"):JSONDecode(
                                game.ReplicatedStorage[name].InfiniteRecord.Value
                            )
                        },
                        {
                            ["name"] = "🌌 Dimension Clear",
                            ["value"] = game:GetService("HttpService"):JSONDecode(
                                game.ReplicatedStorage[name].StageClear.Value
                            )
                        },
                    },
                    ["footer"] = {
                        ["text"] = "NoName Hub"
                    },
                    ["timestamp"] = DateTime.now():ToIsoDate()
                }
    
                if game.Players.LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.ResultUI.Visible then
                    webhook(data, "")
                    task.wait(15)
                elseif game.Players.LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.RaidResultUI.Visible then
                    webhook(data, "")
                    task.wait(15)
                end
                a = true
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if (Settings.FarmDimension or Settings.FarmRaid) and game.PlaceId ~= 6938803436 and game.PlaceId ~= 7274690025 then
            farm()
        end
    end
end)

task.spawn(function()
    while task.wait(Settings.PunchTime) do
        pcall(function()
            game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("UseSkill",{["attackNumber"] = 1},"BasicAttack")
            game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("UseSkill",{["attackNumber"] = 2},"BasicAttack")
            game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("UseSkill",{["attackNumber"] = 3},"BasicAttack")
            game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("UseSkill",{["attackNumber"] = 4},"BasicAttack")
        end)
    end
end)

task.spawn(function()
    while task.wait(Settings.AutoSkillTime) do
        if Settings.AutoSkill then
            ReplicatedStorage.RemoteEvents.MainRemoteEvent:FireServer("UseSkill", {}, 1)

            ReplicatedStorage.RemoteEvents.MainRemoteEvent:FireServer("UseSkill", {}, 2)

            ReplicatedStorage.RemoteEvents.MainRemoteEvent:FireServer("UseAssistSkill", {}, 1)

            ReplicatedStorage.RemoteEvents.MainRemoteEvent:FireServer("UseAssistSkill", {}, 2)

            ReplicatedStorage.RemoteEvents.MainRemoteEvent:FireServer("UseSkill", {}, 3)

            ReplicatedStorage.RemoteEvents.MainRemoteEvent:FireServer("UseSkill", {}, 4)

            ReplicatedStorage.RemoteEvents.MainRemoteEvent:FireServer("UseSkill", {}, 5)
        end
    end
end)



-- coroutine

local OnceBoost = false

coroutine.wrap(function()
    while task.wait(10) do

        if Settings.FPSBoost then
            if OnceBoost == false then
                OnceBoost = true
                local decalsyeeted = true -- Leaving this on makes games look shitty but the fps goes up by at least 20.
                local g = game
                local w = g.Workspace
                local l = g.Lighting
                local t = w.Terrain
                t.WaterWaveSize = 0
                t.WaterWaveSpeed = 0
                t.WaterReflectance = 0
                t.WaterTransparency = 0
                l.GlobalShadows = false
                l.FogEnd = 9e9
                l.Brightness = 0
                settings().Rendering.QualityLevel = "Level01"
                for i, v in pairs(g:GetDescendants()) do
                    if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                        v.Material = "Plastic"
                        v.Reflectance = 0
                    elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
                        v.Transparency = 1
                    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                        v.Lifetime = NumberRange.new(0)
                    elseif v:IsA("Explosion") then
                        v.BlastPressure = 1
                        v.BlastRadius = 1
                    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
                        v.Enabled = false
                    elseif v:IsA("MeshPart") then
                        v.Material = "Plastic"
                        v.Reflectance = 0
                        v.TextureID = 10385902758728957
                    end
                end
                for i, e in pairs(l:GetChildren()) do
                    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                        e.Enabled = false
                    end
                end
            end
        end

        local IsTeleport = false
        
        if Settings.AutoDetectLevel then
            setLevel()
        end

        if game.PlaceId == 6938803436 or game.PlaceId == 7274690025 or game.PlaceId == 7338881230 then
            if Settings.FarmRaid then
                if string.match(workspace.InteractionCircles.RaidPortal.RaidTimer.Frame.RaidTimerText.Text, "RAID IS OPEN") then
                    pcall(function()
                        createRoom(Settings.Raid, "Easy", false)
                        startRoom()
                        IsTeleport = true
                    end)
                end
            end

            if Settings.FarmBossRush then
                local Ticket = plr.PlayerGui.MainGui.CenterUIFrame.BossRushFrame.BossRushEntryPassCount.Text
                local Free = plr.PlayerGui.MainGui.CenterUIFrame.BossRushFrame.BossRushFreeEntry.Text
                if tonumber(Ticket) >= 1 or string.match(Free, "1.") then
                    ReplicatedStorage.RemoteFunctions.MainRemoteFunction:InvokeServer("TeleportToBossRush")
                end
            end

            if Settings.TimeChallenge then
                ReplicatedStorage.RemoteFunctions.MainRemoteFunction:InvokeServer("TeleportToTimeChallenge")
            end

            if Settings.FarmSpeedRaid then
                local character = getCharacter()
                local random = math.random(1, #character)
                local final = character[random]
                local LayoutOrder = plr.PlayerGui.MainGui.CenterUIFrame.SpeedRaidCharacterSelector.Shade.SpeedRaidCharacterInventoryScrollingFrame[final].LayoutOrder
                if LayoutOrder ~= 999 then
                    ReplicatedStorage.RemoteFunctions.MainRemoteFunction:InvokeServer("TeleportToShadowRaid", final)
                end
            end

            if Settings.FarmDimension then
                join()
                IsTeleport = true
            end

            
            task.spawn(function()
                task.wait(20)
                if IsTeleport then
                    game:GetService("TeleportService"):Teleport(6938803436, game.Players.LocalPlayer)
                end
            end)
        end

    end
end)()


-- gui

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/Essenly/NoName-Hub/main/RayField'))()

local Window = Rayfield:CreateWindow({
    Name = "NoName Hub",
    LoadingTitle = "Loading Hub..",
    LoadingSubtitle = "by Saber",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "NoName_Hub", -- Create a custom folder for your hub/game
       FileName = "AD_"..plr.UserId
    },
    Discord = {
       Enabled = false,
       Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
       Title = "Untitled",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided",
       FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
})

-- Tabs

local Main = Window:CreateTab("Main")
local Setting = Window:CreateTab("Settings")
local Specific = Window:CreateTab("Specific & Raid")
local Misc = Window:CreateTab("Misc")
local Webhook = Window:CreateTab("Webhook")


-- Main

local ADL = Main:CreateToggle({
    Name = "Auto Detect Level",
    CurrentValue = false,
    Flag = "AutoDetectLevel", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.AutoDetectLevel = Value
    end,
})

local FarmDimension = Main:CreateToggle({
    Name = "Farm Dimension",
    CurrentValue = false,
    Flag = "FarmDimension", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.FarmDimension = Value
    end,
})

local TimeChallenge = Main:CreateToggle({
    Name = "Farm Time Challenge",
    CurrentValue = false,
    Flag = "FarmTimeChallenge", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.TimeChallenge = Value
    end,
})

local BossRush = Main:CreateToggle({
    Name = "Farm Boss Rush",
    CurrentValue = false,
    Flag = "FarmBossRush", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.FarmBossRush = Value
    end,
})

local FarmSpeed = Main:CreateToggle({
    Name = "Farm Speed Raid",
    CurrentValue = false,
    Flag = "FarmSpeedRaid", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.FarmSpeedRaid = Value
    end,
})


local FarmRaid = Main:CreateToggle({
    Name = "Farm Raid",
    CurrentValue = false,
    Flag = "FarmRaid", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.FarmRaid = Value
    end,
})

-- Setting

Setting:CreateSection("Teleport")

local TPDist = Setting:CreateSlider({
    Name = "TP Distance",
    Range = {1, 10},
    Increment = 1,
    Suffix = "m",
    CurrentValue = 5,
    Flag = "TPDist", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.TPDist = Value
    end,
})

Setting:CreateSection("Auto Dodge")

local AutoDodge = Setting:CreateToggle({
    Name = "Auto Dodge",
    CurrentValue = false,
    Flag = "AutoDodge", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.Dodge = Value
    end,
})

local DodgeSize = Setting:CreateSlider({
    Name = "Dodge Size",
    Range = {1.5, 8},
    Increment = .1,
    Suffix = "",
    CurrentValue = 3,
    Flag = "DodgeSize", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.DodgeSize = Value
    end,
})

local DodgeDelay = Setting:CreateSlider({
    Name = "Dodge Delay",
    Range = {0.2, 1},
    Increment = .1,
    Suffix = "s",
    CurrentValue = .5,
    Flag = "DodgeDelay", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.DodgeDelay = Value
    end,
})

Setting:CreateSection("Auto Punch")

local AutoPunch = Setting:CreateToggle({
    Name = "Auto Punch",
    CurrentValue = false,
    Flag = "AutoPunch", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.Punch = Value
    end,
})

local PunchDelay = Setting:CreateSlider({
    Name = "Auto Punch Delay",
    Range = {.5, 5},
    Increment = .1,
    Suffix = "s",
    CurrentValue = 1.5,
    Flag = "AutoPuchDelay", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.PunchTime = Value
    end,
})

Setting:CreateSection("Auto Skill")

local AutoSkill1 = Setting:CreateToggle({
    Name = "Auto Skill",
    CurrentValue = false,
    Flag = "AutoSkill", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.AutoSkill = Value
    end,
})

local AutoSkillTime = Setting:CreateSlider({
    Name = "Auto Skill Delay",
    Range = {.5, 5},
    Increment = .1,
    Suffix = "s",
    CurrentValue = 1.5,
    Flag = "AutoSkillDelay", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.AutoSkillTime = Value
    end,
})


-- Specific

Specific:CreateSection("Dimension Farm")

Dimension = Specific:CreateDropdown({
    Name = "Select Dimension",
    Options = {"Titan Dimension", "Demon Dimension", "Curse Dimension", "Villain Dimension", "Sword Dimension", "Ghoul Dimension", "Fate Dimension", "Slime Dimension", "Devil Dimension", "Pirate Dimension"},
    CurrentOption = "",
    MultiSelection = false, -- If MultiSelections is allowed
    Flag = "Dimension",
    Callback = function(Option)
        Settings.Dimension = Option[1]
    end,
})

Difficulty = Specific:CreateDropdown({
    Name = "Select Difficulty",
    Options = {"Easy", "Hard", "Nightmare"},
    CurrentOption = "",
    MultiSelection = false, -- If MultiSelections is allowed
    Flag = "Difficulty",
    Callback = function(Option)
        Settings.Difficulty = Option[1]
    end,
})

local Hardcore = Specific:CreateToggle({
    Name = "Hardcore",
    CurrentValue = false,
    Flag = "Hardcore", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.Hardcore = Value
    end,
})

Specific:CreateSection("Raid Farm")

local Raid = Specific:CreateDropdown({
    Name = "Select Raid",
    Options = {"Gear 5 Fluffy Raid", "Goddess Madoki Raid", "Joto Raid", "Cosmic Wolfman Raid", "Tengoku Raid", "Hirito Raid", "Titan Raid"},
    CurrentOption = "",
    MultiSelection = false, -- If MultiSelections is allowed
    Flag = "Raid",
    Callback = function(Option)
        Settings.Raid = Option[1]
    end,
})

--Misc

Misc:CreateSection("Auto Daily")

local AutoDailyQUEST = Misc:CreateToggle({
    Name = "Auto Daily Quests",
    CurrentValue = false,
    Flag = "AutoDailyQuest", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.DailyQuest = Value
    end,
})

Misc:CreateSection("Perfomance")

local FPSBoost = Misc:CreateToggle({
    Name = "FPS Boost",
    CurrentValue = false,
    Flag = "FPSBoost", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.FPSBoost = Value
    end,
})

local WhiteScreen = Misc:CreateToggle({
    Name = "White Screen",
    CurrentValue = false,
    Flag = "WhiteScreen", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.WhiteScreen = Value
        if Value == true then
            game:GetService("RunService"):Set3dRenderingEnabled(false)
            setfpscap(20)
        end
    end,
})


Misc:CreateSection("TP to Lobby")

local Button = Misc:CreateButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):Teleport(6938803436, plr)
    end,
})

-- webhook

local InputWebhook = Webhook:CreateInput({
    Name = "Webhook",
    PlaceholderText = "Url here",
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        if isfolder("NoName_Hub") then
            writefile("NoName_Hub/WebHook.txt", Text)
        end
        getwebhook()
    end,
 })

local ClearWebhook = Webhook:CreateToggle({
    Name = "Clear Webhook",
    CurrentValue = false,
    Flag = "Clear Webhook", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Settings.ClearWebhook = Value
    end,
})

local Test = Webhook:CreateButton({
    Name = "Webhook test",
    Callback = function()
        webhook(nil, "Hello World! Saber was here")
    end,
})

getgenv().IsLoaded = true

Rayfield:LoadConfiguration()
