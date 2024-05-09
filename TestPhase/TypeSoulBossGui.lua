local plr = game.Players.LocalPlayer

function round(n)
    return math.round(n * 10 ^ 2) / 10 ^ 2
end

function getReiPercentage()
    local scale = plr.PlayerGui.DisplayUI.Collage.MainFrame.Rei.Slider.ReiBack.ImageLabel.Size.X.Scale

    return scale * 100
end

function getHealthPercentage()
    local scale = plr.PlayerGui.DisplayUI.Collage.MainFrame.Health.HealthBack.ImageLabel.Size.X.Scale

    return scale * 100
end

function createGui()
    local BlackScreen = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local ScriptName = Instance.new("TextLabel")
    local Discord = Instance.new("TextLabel")
    local ScriptStatus = Instance.new("TextLabel")
    local PlayerHealth = Instance.new("TextLabel")
    local PlayerRei = Instance.new("TextLabel")
    local BossHealth = Instance.new("TextLabel")
    local ServerTime = Instance.new("TextLabel")

    BlackScreen.Name = "BlackScreen"
    BlackScreen.Parent = game.CoreGui
    BlackScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    BlackScreen.IgnoreGuiInset = true
    BlackScreen.DisplayOrder = 999

    Frame.Parent = BlackScreen
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.new(1, 0, 1, 0)

    if getgenv().Debug then
        Frame.BackgroundTransparency = 1
    else
        Frame.BackgroundTransparency = 0
    end

    ScriptName.Name = "ScriptName"
    ScriptName.Parent = Frame
    ScriptName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ScriptName.BackgroundTransparency = 1.000
    ScriptName.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ScriptName.BorderSizePixel = 0
    ScriptName.Position = UDim2.new(0.315852582, 0, 0.143269092, 0)
    ScriptName.Size = UDim2.new(0.368669033, 0, 0.0948814005, 0)
    ScriptName.Font = Enum.Font.SourceSansBold
    ScriptName.Text = "NoName Hub"
    ScriptName.TextColor3 = Color3.fromRGB(255, 255, 255)
    ScriptName.TextScaled = true
    ScriptName.TextSize = 14.000
    ScriptName.TextWrapped = true

    Discord.Name = "Discord"
    Discord.Parent = Frame
    Discord.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Discord.BackgroundTransparency = 1.000
    Discord.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Discord.BorderSizePixel = 0
    Discord.Position = UDim2.new(0.31518051, 0, 0.230366051, 0)
    Discord.Size = UDim2.new(0.368669033, 0, 0.0399500616, 0)
    Discord.Font = Enum.Font.SourceSansBold
    Discord.Text = "discord.gg/MArf5n46gA"
    Discord.TextColor3 = Color3.fromRGB(255, 255, 255)
    Discord.TextScaled = true
    Discord.TextSize = 14.000
    Discord.TextWrapped = true

    ScriptStatus.Name = "ScriptStatus"
    ScriptStatus.Parent = Frame
    ScriptStatus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ScriptStatus.BackgroundTransparency = 1.000
    ScriptStatus.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ScriptStatus.BorderSizePixel = 0
    ScriptStatus.Position = UDim2.new(0.338044763, 0, 0.534030616, 0)
    ScriptStatus.Size = UDim2.new(0.323321551, 0, 0.0761548057, 0)
    ScriptStatus.Font = Enum.Font.SourceSansBold
    ScriptStatus.Text = "Script Status: None"
    ScriptStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
    ScriptStatus.TextScaled = true
    ScriptStatus.TextSize = 14.000
    ScriptStatus.TextWrapped = true

    PlayerHealth.Name = "PlayerHealth"
    PlayerHealth.Parent = Frame
    PlayerHealth.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PlayerHealth.BackgroundTransparency = 1.000
    PlayerHealth.BorderColor3 = Color3.fromRGB(0, 0, 0)
    PlayerHealth.BorderSizePixel = 0
    PlayerHealth.Position = UDim2.new(0.338044763, 0, 0.610185444, 0)
    PlayerHealth.Size = UDim2.new(0.323321551, 0, 0.0486891381, 0)
    PlayerHealth.Font = Enum.Font.SourceSansBold
    PlayerHealth.Text = "Player Health: 100%"
    PlayerHealth.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerHealth.TextScaled = true
    PlayerHealth.TextSize = 14.000
    PlayerHealth.TextWrapped = true

    PlayerRei.Name = "PlayerRei"
    PlayerRei.Parent = Frame
    PlayerRei.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PlayerRei.BackgroundTransparency = 1.000
    PlayerRei.BorderColor3 = Color3.fromRGB(0, 0, 0)
    PlayerRei.BorderSizePixel = 0
    PlayerRei.Position = UDim2.new(0.338044763, 0, 0.659498811, 0)
    PlayerRei.Size = UDim2.new(0.323321551, 0, 0.0486891381, 0)
    PlayerRei.Font = Enum.Font.SourceSansBold
    PlayerRei.Text = "Player Rei: 100%"
    PlayerRei.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerRei.TextScaled = true
    PlayerRei.TextSize = 14.000
    PlayerRei.TextWrapped = true

    BossHealth.Name = "BossHealth"
    BossHealth.Parent = Frame
    BossHealth.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BossHealth.BackgroundTransparency = 1.000
    BossHealth.BorderColor3 = Color3.fromRGB(0, 0, 0)
    BossHealth.BorderSizePixel = 0
    BossHealth.Position = UDim2.new(0.338044763, 0, 0.708187938, 0)
    BossHealth.Size = UDim2.new(0.323321551, 0, 0.0486891381, 0)
    BossHealth.Font = Enum.Font.SourceSansBold
    BossHealth.Text = "Boss Health: 100%"
    BossHealth.TextColor3 = Color3.fromRGB(255, 255, 255)
    BossHealth.TextScaled = true
    BossHealth.TextSize = 14.000
    BossHealth.TextWrapped = true

    ServerTime.Name = "ServerTime"
    ServerTime.Parent = Frame
    ServerTime.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ServerTime.BackgroundTransparency = 1.000
    ServerTime.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ServerTime.BorderSizePixel = 0
    ServerTime.Position = UDim2.new(0.338044763, 0, 0.376727223, 0)
    ServerTime.Size = UDim2.new(0.323321551, 0, 0.0649188533, 0)
    ServerTime.Font = Enum.Font.SourceSansBold
    ServerTime.Text = "Server Time: 00:00"
    ServerTime.TextColor3 = Color3.fromRGB(255, 255, 255)
    ServerTime.TextScaled = true
    ServerTime.TextSize = 14.000
    ServerTime.TextWrapped = true

    coroutine.wrap(function()
        while task.wait() do
            if not BlackScreen.Parent or not Frame.Parent then
                createGui()
                return
            end

            local a,b = pcall(function()
                ScriptStatus.Text = "Script Status: "..(getgenv().ScriptStatus or "None")
                PlayerHealth.Text = "Player Health: "..round(getHealthPercentage()).."%"
                PlayerRei.Text = "Player Rei: "..round(getReiPercentage()).."%"
                BossHealth.Text = "Boss Health: "..round(getgenv().BossHp or 100).."%"
                ServerTime.Text = plr.PlayerGui.Settings.Frame.ServerTime.Text
            end)

            if not a then print(b) end
        end
    end)()
end

createGui()
