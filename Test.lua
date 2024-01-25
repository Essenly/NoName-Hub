-- variables

local plr = game.Players.LocalPlayer
local data = {
    AutoFishing = false,
    AutoSpin = false,
}

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

Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/Essenly/NoName-Hub/main/RayField'))()

local Window = Rayfield:CreateWindow({
    Name = "NoName Hub",
    LoadingTitle = "Loading Hub..",
    LoadingSubtitle = "by Saber",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "NoName_Hub", -- Create a custom folder for your hub/game
       FileName = "UTD_"..plr.UserId
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

-- HideUi

local HideGui = Instance.new("ScreenGui")
local TextButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

--Properties:

HideGui.Name = "HideGui"
HideGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
HideGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
HideGui.DisplayOrder = 99999999

TextButton.Parent = HideGui
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.01, 0,0.518, 0)
TextButton.Size = UDim2.new(0.028, 0, 0.078, 0)
TextButton.Font = Enum.Font.SourceSansBold
TextButton.Text = "HIDE"
TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton.TextScaled = true
TextButton.TextSize = 14.000
TextButton.TextWrapped = true

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = TextButton

TextButton.MouseButton1Click:Connect(function()
    getgenv().HideFunction()
end)

--

-- Tabs

local Lobby = Window:CreateTab("Lobby")

-- Lobby

Lobby:CreateToggle({
    Name = "Auto Fishing",
    CurrentValue = false,
    Flag = "Auto Fishing",
    Callback = function(value)
        data.AutoFishing = value
    end
})
