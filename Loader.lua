repeat task.wait() until game:IsLoaded()
local plr = game.Players.LocalPlayer

if getgenv().isLoading then
    print("NoName Hub Loader: Script already loading")
    return
end

if getgenv().NoNameHub then
    print("NoName Hub Loader: Script already loaded!")
    return
end

--

local Games = {
    ["Anime Dimension"] = {
        Ids = {6938803436, 6990129309, 6990131029, 6990133340, 7274690025, 7338881230},
        Name = "Anime Dimension",
        Load = "a936b38bc9cc61d0f046f45020d3156a.lua"
    },
    ["Gym League"] = {
        Ids = {17450551531, 17593437943, 17593439780, 17593439630, 17593441072, 17883015202, 18471848155, 18524420267, 128775837101761},
        Name = "Gym League",
        Load = "813c2e324b302a9ab757b961c7d37cfa.lua"
    },
    ["Anime Simulator"] = {
        Ids = {17316900493, 131692389956697},
        Name = "Anime Simulator",
        Load = "2e7742dcc06b0c147eca76483fa85f61.lua"
    },
}

--

function getGame()
    for i,v in pairs(Games) do
        if table.find(v.Ids, game.PlaceId) then
            return v
        end
    end

    return nil
end

function executor()
    if identifyexecutor and typeof(identifyexecutor) == "function" and identifyexecutor() ~= nil then
        return identifyexecutor()
    end

    if getexecutorname and typeof(getexecutorname) == "function" and getexecutorname() ~= nil then
        return getexecutorname()
    end

    return "idk"
end

function security_load(name)
    if not name then return end
    if typeof(name) ~= "string" then return end
    if getgenv().NoNameHub then return end

    local str = "https://api.luarmor.net/files/v3/loaders/"..name

    local a,b = pcall(function()
        loadstring(game:HttpGetAsync(str))()
        getgenv().NoNameHub = true
    end)

    if a then
        print("NoName Hub Loader: Script loaded!")
        return true
    end

    if not a then
        getgenv().NoNameHub = false
        print("NoName Hub Error: "..b)
        return false
    end
end

function time_Sync_Check()
    local serverTime = workspace:GetServerTimeNow()
    local clientTime = os.time()
    local diff = 0

    if clientTime > serverTime then
        diff = clientTime - serverTime
    else
        diff = serverTime - clientTime
    end

    if diff > 20 then
        return false
    end

    return true
end

function banned_executors()
    local exec = executor()

    if exec == "Celery" then
        return "Celery"
    end

    if exec == "Solara" then
        return "Solara"
    end

    return nil
end

function loadScript()
    if not time_Sync_Check() then return end
    if getgenv().NoNameHub then return end

    local scriptData = getGame()
    if not scriptData then return print("NoName Hub doesn't support this game") end

    local load = security_load(scriptData.Load)

    if not load then
        repeat
            print("NoName Hub Loader: Script failed to load, retrying in 10 seconds")
            task.wait(10)
            load = security_load(scriptData.Load)
        until load
    end
end

local a,b = pcall(function()
    getgenv().isLoading = true
    loadScript()
end)

if not a then print("NoName Hub Loader Error: "..b) end

getgenv().isLoading = false
