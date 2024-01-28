local NoGui = {
	Flags = {},
	PlaceName = "Test"
}

-- variables

local plr = game.Players.LocalPlayer
local Mouse = plr:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HTTPService = game:GetService("HttpService")

-- functions

function p_call(func)
	local a,b = pcall(func)
	
	if not a then
		print("NoName Hub Error: "..b)
	end
end

function getTextSize(text)
	local Params = Instance.new("GetTextBoundsParams") 
	Params.Text = text or "New Tab"
	Params.Size = 18
	Params.Font = Font.fromName("SourceSansPro", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

	local Async = game:GetService("TextService"):GetTextBoundsAsync(Params)

	return Async.X
end


function setDraggable(UI : Frame)	
	local Hovered, Holding, MoveCon = false, false, nil
	local InitialX, InitialY, UIInitialPos
	
	UI.MouseEnter:Connect(function()
		Hovered = true
	end)
	
	UI.MouseLeave:Connect(function()
		Hovered = false
	end)
	
	local ValidInputs = {Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch}
	
	UIS.InputBegan:Connect(function(inp, gpe)
		if gpe then return end
		
		if table.find(ValidInputs, inp.UserInputType) then
			Holding = Hovered
			
			if Holding then
				InitialX, InitialY = Mouse.X, Mouse.Y
				UIInitialPos = UI.Position

				MoveCon = Mouse.Move:Connect(function()
					if Holding == false then MoveCon:Disconnect(); return end
					local distanceMovedX = InitialX - Mouse.X
					local distanceMovedY = InitialY - Mouse.Y

					UI.Position = UIInitialPos - UDim2.new(0, distanceMovedX, 0, distanceMovedY)
				end)
			end
			
		end
		
	end)
	
	UIS.InputEnded:Connect(function(inp, gpe)
		if gpe then return end
		
		if table.find(ValidInputs, inp.UserInputType) then
			Holding = false
		end
	end)
end

function createTween(obj, info, property)
	return TweenService:Create(obj, info, property)
end

function setStringSize(str : string, size : number)
	if string.len(str) <= size then return str end
	
	local newString = ""
	local split = str:split("")
	local deletedSymbols = 0
	
	for i = string.len(str), 1, -1 do
		if #split < size then
			break
		end
		
		split[i] = nil
		deletedSymbols += 1
	end
	
	deletedSymbols = math.clamp(deletedSymbols, 1, 3)
	
	for i,v in pairs(split) do
		newString = newString..v
	end
	
	for i = 1, deletedSymbols do
		newString = newString.."."
	end
	
	return newString
end

function setSecureParent(obj : Instance)
	if game:FindFirstChild("CoreGui") then
		obj.Parent = game.CoreGui
		return
	end
	
	obj.Parent = plr.PlayerGui
	return
end

-- save config

function NoGui:saveFlags()
	local newTable = {}
	
	for i,v in pairs(NoGui.Flags) do
		if v.Value == nil then continue end
		if i == "NoFlag" then continue end

		newTable[i] = v.Value
	end
	
	local Data = HTTPService:JSONEncode(newTable)
	
	if not isfolder("NoNameHub") then
		makefolder("NoNameHub")
	end
	
	writefile("NoNameHub/"..NoGui.PlaceName.."_"..plr.UserId..".txt", tostring(Data))
end

function NoGui:loadFlags()
	if not isfolder("NoNameHub") then return end
	if not isfile("NoNameHub/"..NoGui.PlaceName.."_"..plr.UserId..".txt") then return end
	
	local file = readfile("NoNameHub/"..NoGui.PlaceName.."_"..plr.UserId..".txt")
	local data = HTTPService:JSONDecode(file)
	
	for i,v in pairs(data) do
		if NoGui.Flags[i] then
			NoGui.Flags[i]:Set(v)
		end
	end
end

--

-- ui

function NoGui:CreateWindow(placeName)
	if getgenv().Gui then
		getgenv().Gui:Destroy()
	end
	
	NoGui.PlaceName = placeName or "Test"
	
	local is_hidden = false
	local debounce = false

	local NoNameHub = Instance.new("ScreenGui")
	local Main = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local HubName = Instance.new("TextLabel")
	local Line = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local Tabs = Instance.new("Folder")
	local ScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local Pages = Instance.new("Folder")
	local Stroke = Instance.new("UIStroke")
	local Stroke2 = Instance.new("UIStroke")

	NoNameHub.Name = "NoNameHub"
	
	setSecureParent(NoNameHub)
	
	NoNameHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	NoNameHub.ResetOnSpawn = false
	NoNameHub.IgnoreGuiInset = true
	NoNameHub.DisplayOrder = math.huge

	Main.Name = "Main"
	Main.Parent = NoNameHub
	Main.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Main.BorderSizePixel = 0
	Main.Position = UDim2.new(0.305, 0, 1.266, 0)
	Main.Size = UDim2.new(0.389, 0, 0.468, 0)
	
	Stroke.Thickness = 2
	Stroke.Parent = Main

	UICorner.CornerRadius = UDim.new(0, 4)
	UICorner.Parent = Main

	HubName.Name = "HubName"
	HubName.Parent = Main
	HubName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HubName.BackgroundTransparency = 1.000
	HubName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HubName.BorderSizePixel = 0
	HubName.Position = UDim2.new(0.0113503113, 0, 0.0124610588, 0)
	HubName.Size = UDim2.new(0.189781025, 0, 0.0934579447, 0)
	HubName.Font = Enum.Font.SourceSansBold
	HubName.Text = "NoName Hub"
	HubName.TextColor3 = Color3.fromRGB(255, 255, 255)
	HubName.TextScaled = true
	HubName.TextSize = 14.000
	HubName.TextStrokeTransparency = 0.000
	HubName.TextTransparency = 0.330
	HubName.TextWrapped = true

	Stroke2.Thickness = 1.5
	Stroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	Stroke2.Parent = HubName

	Line.Name = "Line"
	Line.Parent = Main
	Line.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Line.BorderSizePixel = 0
	Line.Position = UDim2.new(0.213503644, 0, 0.021884717, 0)
	Line.Size = UDim2.new(0.00547445239, 0, 0.0685358271, 0)

	UICorner_2.CornerRadius = UDim.new(0, 4)
	UICorner_2.Parent = Line

	Tabs.Name = "Tabs"
	Tabs.Parent = Main

	ScrollingFrame.Parent = Tabs
	ScrollingFrame.Active = false
	ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollingFrame.BackgroundTransparency = 1.000
	ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.Position = UDim2.new(0.235401466, 0, 0.00378148095, 0)
	ScrollingFrame.Size = UDim2.new(0.764598548, 0, 0.105881467, 0)
	ScrollingFrame.CanvasSize = UDim2.new(2, 0, 0, 0)
	ScrollingFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.Always
	ScrollingFrame.ScrollBarThickness = 0

	UIListLayout.Parent = ScrollingFrame
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0, 9)

	Pages.Name = "Pages"
	Pages.Parent = Main
	
	setDraggable(Main)
	getgenv().Gui = NoNameHub
	
	createTween(Main, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {Position = UDim2.new(0.305, 0, 0.266, 0)}):Play()
	
	local function hide()
		if debounce then return end
		
		debounce = true
		
		if is_hidden then
			Main.Position = UDim2.new(0.305, 0, 1.266, 0)
			createTween(Main, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {Position = UDim2.new(0.305, 0, 0.266, 0)}):Play()
			is_hidden = false
		else
			createTween(Main, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {Position = UDim2.new(Main.Position.X.Scale, Main.Position.X.Offset, 1.266, 0)}):Play()
			is_hidden = true
		end
		
		task.wait(.6)
		
		debounce = false
	end
	
	UIS.InputBegan:Connect(function(inp, gpe)
		if inp.KeyCode == Enum.KeyCode.RightControl then
			hide()
		end
	end)

	local Window = {}
	
	function Window:CreateHideButton(onlyMobile : boolean)
		if NoNameHub:FindFirstChild("HideButton") then return end
		if onlyMobile and not UIS.TouchEnabled then print("NoName Hub: No Touch Device") return end
		
		local HideButton = Instance.new("TextButton")
		local Corner = Instance.new("UICorner")
		local Stroke = Instance.new("UIStroke")
		
		HideButton.Name = "HideButton"
		HideButton.BackgroundColor3 = Color3.new()
		HideButton.BackgroundTransparency = 0.35
		HideButton.Position = UDim2.new(0.489, 0, 0.025, 0)
		HideButton.Size = UDim2.new(0.028,0,0.056,0)
		HideButton.Font = Enum.Font.SourceSansBold
		HideButton.Text = "HIDE"
		HideButton.TextColor3 = Color3.new(1,1,1)
		HideButton.TextScaled = true
		
		Corner.CornerRadius = UDim.new(0,25)
		Corner.Parent = HideButton
		
		Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		Stroke.Thickness = 3.1
		Stroke.Transparency = 0.17
		Stroke.Parent = HideButton
		
		HideButton.Parent = NoNameHub
		
		HideButton.MouseButton1Click:Connect(function()
			hide()
		end)
	end
	
	function Window:CreateWatermark(text)	
		if Main:FindFirstChild("Watermark") then
			Main:FindFirstChild("Watermark"):Destroy()
		end
		
		local Watermark = Instance.new("TextLabel")
		Watermark.Text = "Watermark"
		Watermark.Parent = NoNameHub
		Watermark.Position = UDim2.new(0,0,0.96,0)
		Watermark.Size = UDim2.new(1,0,0.039,0)
		Watermark.Font = Enum.Font.SourceSansBold
		Watermark.TextScaled = true
		Watermark.TextXAlignment = Enum.TextXAlignment.Right
		Watermark.BackgroundTransparency = 1
		Watermark.TextColor3 = Color3.new(255,255,255)
		Watermark.TextStrokeTransparency = 0
		
		
		Watermark.Text = text or "NoName Hub"
		
		local Methods = {}
		
		function Methods:Set(text)
			text = text or "NoName Hub"
			
			Watermark.Text = text
		end
		
		return Methods
	end

	function Window:CreateTab(name)
		local Tab = Instance.new("TextButton")
		local Page = Instance.new("ScrollingFrame")
		local UICorner_3 = Instance.new("UICorner")
		local UILayout = Instance.new("UIListLayout")
		local Stroke = Instance.new("UIStroke")
		
		name = name or "New Tab"

		Tab.Name = name
		Tab.Parent = ScrollingFrame
		Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Tab.BackgroundTransparency = 1.000
		Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tab.BorderSizePixel = 0
		Tab.Position = UDim2.new(0, 0, 0.174999788, 0)
		Tab.Size = UDim2.new(0, getTextSize(name) + 2, 0.649999976, 0)
		Tab.Font = Enum.Font.SourceSansBold
		Tab.Text = name
		Tab.TextColor3 = Color3.fromRGB(223, 223, 223)
		Tab.TextScaled = true
		Tab.TextSize = 18.000
		Tab.TextStrokeTransparency = 0.000
		Tab.TextTransparency = 0.380
		Tab.TextWrapped = true
		Tab.TextXAlignment = Enum.TextXAlignment.Left
		
		Stroke.Thickness = 1.5
		Stroke.Transparency = 0.3
		Stroke.Parent = Tab

		Page.Name = "Page"
		Page.Parent = Pages
		Page.Active = true
		Page.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		Page.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Page.BorderSizePixel = 0
		Page.Position = UDim2.new(0, 0, 0.10903427, 0)
		Page.Size = UDim2.new(1, 0, 0.89096576, 0)
		Page.CanvasSize = UDim2.new(0, 0, 1, 0)
		Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Page.ScrollBarThickness = 9
		Page.ScrollBarImageColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)
		
		UILayout.Padding = UDim.new(0.025, 0)
		UILayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UILayout.SortOrder = Enum.SortOrder.LayoutOrder
		UILayout.Parent = Page
			

		UICorner_3.CornerRadius = UDim.new(0, 4)
		UICorner_3.Parent = Page

		if #Pages:GetChildren() > 1 then
			Page.Visible = false
			Page.Active = false
			Tab.TextColor3 = Color3.fromRGB(134, 134, 134)
			Tab.TextTransparency = 0.490
		end

		Tab.MouseButton1Click:Connect(function()
			for i,v in pairs(ScrollingFrame:GetChildren()) do
				if not v:IsA("TextButton") then continue end
				v.TextColor3 = Color3.fromRGB(134, 134, 134)
				v.TextTransparency = 0.490
			end

			for i,v in pairs(Pages:GetChildren()) do
				v.Visible = false
			end

			Tab.TextColor3 = Color3.fromRGB(223, 223, 223)
			Tab.TextTransparency = 0.380
			Page.Visible = true
			Page.Active = true
		end)
		

		local Elements = {}
		
		
		function Elements:CreateSection(text)
			text = text or "Section"
			
			local Section = Instance.new("TextLabel")
			Section.Parent = Page
			Section.BackgroundTransparency = 1
			Section.Size = UDim2.new(0.96,0,0.06,0)
			Section.Font = Enum.Font.SourceSansBold
			Section.TextColor3 = Color3.fromRGB(119,119,119)
			Section.TextScaled = true
			Section.TextStrokeTransparency = 0
			Section.TextXAlignment = Enum.TextXAlignment.Left
			
			Section.Text = text
		end
		
		function Elements:CreateLabel(text)
			text = text or "Label"
			
			local Label = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local TextLabel = Instance.new("TextLabel")
			
			Label.Name = "Label"
			Label.Parent = Page
			Label.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
			Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Label.BorderSizePixel = 0
			Label.Size = UDim2.new(0.9, 0, 0.11, 0)

			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = Label

			TextLabel.Parent = Label
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.BorderSizePixel = 0
			TextLabel.Position = UDim2.new(0.0246639531, 0, 0.229313582, 0)
			TextLabel.Size = UDim2.new(0.975336075, 0, 0.511726737, 0)
			TextLabel.Font = Enum.Font.SourceSansBold
			TextLabel.Text = text
			TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.TextScaled = true
			TextLabel.TextSize = 14.000
			TextLabel.TextStrokeTransparency = 0.000
			TextLabel.TextWrapped = true
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			
			local Methods = {}
			
			function Methods:Set(text)
				text = text or "Label"
				TextLabel.Text = text
			end
			
			return Methods
		end
		
		function Elements:CreateButton(data)		
			local Button = Instance.new("TextButton")
			local TextLabel = Instance.new("TextLabel")
			local UICorner = Instance.new("UICorner")
			
			Button.Name = "Button"
			Button.Parent = Page
			Button.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
			Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Button.BorderSizePixel = 0
			Button.Size = UDim2.new(0.9, 0, 0.11, 0)
			Button.Font = Enum.Font.SourceSans
			Button.Text = ""
			Button.TextColor3 = Color3.fromRGB(0, 0, 0)
			Button.TextSize = 14.000
			
			TextLabel.Parent = Button
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.BorderSizePixel = 0
			TextLabel.Position = UDim2.new(0.0246639531, 0, 0.229313582, 0)
			TextLabel.Size = UDim2.new(0.975336075, 0, 0.511726737, 0)
			TextLabel.Font = Enum.Font.SourceSansBold
			TextLabel.Text = data.Name
			TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.TextScaled = true
			TextLabel.TextSize = 14.000
			TextLabel.TextStrokeTransparency = 0.000
			TextLabel.TextWrapped = true
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = Button
			
			Button.MouseButton1Click:Connect(function()
				data.Callback()
			end)
			
		end
		
		function Elements:CreateToggle(data)
			data = data or {}
			data.Flag = data.Flag or "NoFlag"
			local CanChangedByFlag = data.CanChangedByFlag or true

			local Toggled = false
			
			local Toggle = Instance.new("TextButton")
			local TextLabel = Instance.new("TextLabel")
			local UICorner = Instance.new("UICorner")
			local UIStroke = Instance.new("UIStroke")
			local Frame = Instance.new("Frame")
			local ImageLabel = Instance.new("ImageLabel")
			local TweenToggle = Instance.new("Frame")
			
			
			Toggle.Name = "Toggle"
			Toggle.Parent = Page
			Toggle.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
			Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Toggle.BorderSizePixel = 0
			Toggle.Size = UDim2.new(0.9, 0, 0.11, 0)
			Toggle.Font = Enum.Font.SourceSans
			Toggle.Text = ""
			Toggle.TextColor3 = Color3.fromRGB(0, 0, 0)
			Toggle.TextSize = 14.000

			TextLabel.Parent = Toggle
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.BorderSizePixel = 0
			TextLabel.Position = UDim2.new(0.0246639531, 0, 0.229313582, 0)
			TextLabel.Size = UDim2.new(0.975336075, 0, 0.511726737, 0)
			TextLabel.Font = Enum.Font.SourceSansBold
			TextLabel.Text = data.Name
			TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.TextScaled = true
			TextLabel.TextSize = 14.000
			TextLabel.TextStrokeTransparency = 0.000
			TextLabel.TextWrapped = true
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = Toggle

			Frame.Parent = Toggle
			Frame.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
			Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BorderSizePixel = 0
			Frame.Position = UDim2.new(0.911000013, 0, 0.108000003, 0)
			Frame.Size = UDim2.new(0.055, 0,0.799, 0)

			UIStroke.Color = Color3.fromRGB(30,30,30)
			UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke.Thickness = 1
			UIStroke.Parent = Frame
			UICorner:Clone().Parent = Frame

			ImageLabel.Parent = Frame
			ImageLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			ImageLabel.BackgroundTransparency = 1.000
			ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ImageLabel.BorderSizePixel = 0
			ImageLabel.Position = UDim2.new(0.26, 0, 0.204090253, 0)
			ImageLabel.Size = UDim2.new(0.519,0,0.519,0)
			ImageLabel.Visible = true
			ImageLabel.Image = "rbxassetid://16037454403"
			ImageLabel.ScaleType = Enum.ScaleType.Tile
			
			TweenToggle.Parent = Frame
			UICorner:Clone().Parent = TweenToggle
			UIStroke:Clone().Parent = TweenToggle
			
			
			local function ToggleFunc(status, callback)
				Toggled = status
				
				if status then
					Frame.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
					ImageLabel.Visible = true
				else
					Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
					ImageLabel.Visible = false
				end
				NoGui.Flags[data.Flag].Value = Toggled
				
				if callback then
					data.Callback(Toggled)
				end
			end
			
			Toggle.MouseButton1Click:Connect(function()
				ToggleFunc(not Toggled, true)
			end)
			
			local Methods = {}
			
			function Methods:Set(value, callback)
				callback = callback or true
				if not CanChangedByFlag then return end
				ToggleFunc(value, callback)
			end
			
			NoGui.Flags[data.Flag] = Methods
			NoGui.Flags[data.Flag].Value = Toggled
			
			ToggleFunc(data.CurrentValue)
			
			return Methods
		end
		
		function Elements:CreateSlider(data)
			data = data or {}
			data.Flag = data.Flag or "NoFlag"
			
			local Slider = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local Bar = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local Bar1 = Instance.new("Frame")
			local UICorner_3 = Instance.new("UICorner")
			local TextLabel = Instance.new("TextLabel")
			local Value = Instance.new("TextLabel")
			
			Slider.Name = "Slider"
			Slider.Parent = Page
			Slider.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
			Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Slider.BorderSizePixel = 0
			Slider.Size = UDim2.new(0.899999976, 0, 0.140000001, 0)

			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = Slider

			Bar.Name = "Bar"
			Bar.Parent = Slider
			Bar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			Bar.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Bar.BorderSizePixel = 0
			Bar.Position = UDim2.new(0.0121718617, 0, 0.600000024, 0)
			Bar.Size = UDim2.new(0.973739028, 0, 0.209138677, 0)
			Bar.Active = true

			UICorner_2.CornerRadius = UDim.new(0, 45)
			UICorner_2.Parent = Bar

			Bar1.Name = "Bar1"
			Bar1.Parent = Bar
			Bar1.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
			Bar1.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Bar1.BorderSizePixel = 0
			Bar1.Size = UDim2.new(0.589999974, 0, 1, 0)

			UICorner_3.CornerRadius = UDim.new(0, 45)
			UICorner_3.Parent = Bar1

			TextLabel.Parent = Slider
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.BorderSizePixel = 0
			TextLabel.Position = UDim2.new(0.024663914, 0, 0.100000001, 0)
			TextLabel.Size = UDim2.new(0.975336075, 0, 0.389999986, 0)
			TextLabel.Font = Enum.Font.SourceSansBold
			TextLabel.Text = data.Name
			TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.TextScaled = true
			TextLabel.TextSize = 14.000
			TextLabel.TextStrokeTransparency = 0.000
			TextLabel.TextWrapped = true
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			Value.Name = "Value"
			Value.Parent = Slider
			Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Value.BackgroundTransparency = 1.000
			Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Value.BorderSizePixel = 0
			Value.Position = UDim2.new(0.024663914, 0, 0.0999995396, 0)
			Value.Size = UDim2.new(0.941108465, 0, 0.389999926, 0)
			Value.Font = Enum.Font.SourceSansBold
			Value.Text = "100"
			Value.TextColor3 = Color3.fromRGB(255, 255, 255)
			Value.TextScaled = true
			Value.TextSize = 14.000
			Value.TextStrokeTransparency = 0.000
			Value.TextWrapped = true
			Value.TextXAlignment = Enum.TextXAlignment.Right
			
			local Dragging  = false
			
			Slider.Bar.InputBegan:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
					Dragging = true
				end
			end)
			
			Slider.Bar.InputEnded:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
					Dragging = false
				end
			end)
			
			UIS.InputBegan:Connect(function(inp, gpe)
				local valids = {Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch}
				if not table.find(valids, inp.UserInputType) then return end
				
				local Current = Slider.Bar.Bar1.AbsolutePosition.X + Slider.Bar.Bar1.AbsolutePosition.X
				local Start = Current
				local Location
				
				
				
				while task.wait() and Dragging do
					Location = UIS:GetMouseLocation().X
					
					Current = Current + 0.025 * (Location - Start)

					if Location < Slider.Bar.AbsolutePosition.X then
						Location = Slider.Bar.AbsolutePosition.X
					elseif Location > Slider.Bar.AbsolutePosition.X + Slider.Bar.AbsoluteSize.X then
						Location = Slider.Bar.AbsolutePosition.X + Slider.Bar.AbsoluteSize.X
					end

					if Current < Slider.Bar.AbsolutePosition.X + 5 then
						Current = Slider.Bar.AbsolutePosition.X + 5
					elseif Current > Slider.Bar.AbsolutePosition.X + Slider.Bar.AbsoluteSize.X then
						Current = Slider.Bar.AbsolutePosition.X + Slider.Bar.AbsoluteSize.X
					end

					if Current <= Location and (Location - Start) < 0 then
						Start = Location
					elseif Current >= Location and (Location - Start) > 0 then
						Start = Location
					end
					TweenService:Create(Slider.Bar.Bar1, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, Current - Slider.Bar.AbsolutePosition.X, 1, 0)}):Play()
					local NewValue = data.Range[1] + (Location - Slider.Bar.AbsolutePosition.X) / Slider.Bar.AbsoluteSize.X * (data.Range[2] - data.Range[1])

					NewValue = math.floor(NewValue / data.Increment + 0.5) * (data.Increment * 10000000) / 10000000
					Slider.Value.Text = tostring(NewValue)
					
					NoGui.Flags[data.Flag].Value = NewValue
					
					data.Callback(NewValue)
				end
				
			end)
			
			local Methods = {}
			
			function Methods:Set(NewVal)
				if NewVal < data.Range[1] then NewVal = data.Range[1] end
				if NewVal > data.Range[2] then NewVal = data.Range[2] end
				
				local clamp = math.clamp(NewVal / data.Range[2], 0, 1)
				TweenService:Create(Slider.Bar.Bar1, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(clamp, 0, 1, 0)}):Play()
				
				data.Callback(NewVal)
				
				Slider.Value.Text = NewVal
				NoGui.Flags[data.Flag].Value = NewVal
			end
			
			NoGui.Flags[data.Flag] = Methods
			NoGui.Flags[data.Flag].Value = data.CurrentValue
			
			Methods:Set(data.CurrentValue)
			
			return Methods
		end
		
		function Elements:CreateDropdown(data)
			data.Flag = data.Flag or "NoFlag"
			local Dropdown = Instance.new("Frame")
			local Interact = Instance.new("TextButton")
			local TextLabel = Instance.new("TextLabel")
			local UICorner = Instance.new("UICorner")
			local ImageLabel = Instance.new("ImageLabel")
			local List = Instance.new("ScrollingFrame")
			local UICorner_2 = Instance.new("UICorner")
			local Layout = Instance.new("UIListLayout")
			local Padding = Instance.new("UIPadding")
					
			Dropdown.Name = "Dropdown"
			Dropdown.Parent = Page
			Dropdown.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
			Dropdown.BackgroundTransparency = 1.000
			Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Dropdown.BorderSizePixel = 0
			Dropdown.Size = UDim2.new(0.9,0,0.11,0)

			Interact.Name = "Interact"
			Interact.Parent = Dropdown
			Interact.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
			Interact.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Interact.BorderSizePixel = 0
			Interact.Size = UDim2.new(1, 0, 1, 0)
			Interact.Font = Enum.Font.SourceSans
			Interact.Text = ""
			Interact.TextColor3 = Color3.fromRGB(0, 0, 0)
			Interact.TextSize = 14.000

			TextLabel.Parent = Interact
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.BorderSizePixel = 0
			TextLabel.Position = UDim2.new(0.0246639531, 0, 0.229313582, 0)
			TextLabel.Size = UDim2.new(0.975336075, 0, 0.511726737, 0)
			TextLabel.Font = Enum.Font.SourceSansBold
			TextLabel.Text = data.Name.." - None"
			TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.TextScaled = true
			TextLabel.TextSize = 14.000
			TextLabel.TextStrokeTransparency = 0.000
			TextLabel.TextWrapped = true
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = Interact

			ImageLabel.Parent = Interact
			ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ImageLabel.BackgroundTransparency = 1.000
			ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ImageLabel.BorderSizePixel = 0
			ImageLabel.Position = UDim2.new(0.925052226, 0, 0.170161918, 0)
			ImageLabel.Rotation = -90.000
			ImageLabel.Size = UDim2.new(0.0450987257, 0, 0.600452423, 0)
			ImageLabel.Image = "rbxassetid://16038479715"

			List.Name = "List"
			List.Parent = Dropdown
			List.Active = true
			List.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			List.BorderColor3 = Color3.fromRGB(0, 0, 0)
			List.BorderSizePixel = 0
			List.Size = UDim2.new(1, 0, 1, 0)
			List.Visible = false
			List.ZIndex = 0
			List.ScrollBarThickness = 9
			List.ScrollBarImageColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)

			UICorner_2.CornerRadius = UDim.new(0, 4)
			UICorner_2.Parent = List
			
			Layout.Parent = List
			Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			
			Padding.Parent = List
			Padding.PaddingTop = UDim.new(0.07, 0)
			
			
			local Open = false
			local Selected = {}
			
			Dropdown.Interact.MouseButton1Click:Connect(function()
				Open = not Open
				ImageLabel.Rotation = (Open and 90) or -90
				
				if Open then
					Dropdown.Size = UDim2.new(0.9, 0, 1, 0)
					Interact.Size = UDim2.new(1,0,0.11,0)
				else
					Dropdown.Size = UDim2.new(0.9,0,0.11,0)
					Interact.Size = UDim2.new(1,0,1,0)
				end
				
				List.Visible = Open
			end)

			local CanChangedByFlag = data.CanChangedByFlag or true
			
			local function select(obj)
				local is_toggled = table.find(Selected, obj.Name)
					
				if is_toggled then
					if not data.MultiSelection then Selected = {obj.Name} return end
					
					obj.TextColor3 = Color3.fromRGB(134, 134, 134)
					obj.TextTransparency = 0.490
					table.remove(Selected, is_toggled)
				else
					obj.TextColor3 = Color3.fromRGB(223,223,223)
					obj.TextTransparency = 0.38
					
					if data.MultiSelection then
						table.insert(Selected, obj.Name)
					else
						for _,d in pairs(List:GetChildren()) do
							if not d:IsA("TextButton") then continue end
							d.TextColor3 = Color3.fromRGB(134, 134, 134)
							d.TextTransparency = 0.490
						end
						
						obj.TextColor3 = Color3.fromRGB(223,223,223)
						obj.TextTransparency = 0.38
						
						Selected = {obj.Name}
					end
				end
			end
			
			for i,v in pairs(data.Options) do
				local Option = Instance.new("TextButton")

				Option.Name = v
				Option.Parent = List
				Option.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Option.BackgroundTransparency = 1.000
				Option.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Option.BorderSizePixel = 0
				Option.Size = UDim2.new(1, 0, 0.0425000004, 0)
				Option.Font = Enum.Font.SourceSansBold
				Option.Text = v
				Option.TextColor3 = Color3.fromRGB(134, 134, 134)
				Option.TextScaled = true
				Option.TextSize = 18.000
				Option.TextStrokeTransparency = 0.000
				Option.TextTransparency = 0.490
				Option.TextWrapped = true
				
				Option.MouseButton1Click:Connect(function()
					select(Option)
					
					if #Selected == 0 then
						TextLabel.Text = data.Name.." - None"
					else
						TextLabel.Text = data.Name.." - "..setStringSize(table.concat(Selected, ", "), 40)
					end
									
					NoGui.Flags[data.Flag].Value = Selected
					data.Callback(Selected)
				end)
				
			end
			
			local Methods = {}

			function Methods:Set(d)
				if not CanChangedByFlag then return end
				Selected = {}
				
				for i,v in pairs(List:GetChildren()) do
					if not v:IsA("TextButton") then continue end
					v.TextColor3 = Color3.fromRGB(134, 134, 134)
					v.TextTransparency = 0.490
				end
				
				for i,v in pairs(List:GetChildren()) do
					if not v:IsA("TextButton") then continue end
					if not table.find(d, v.Name) then continue end

					v.TextColor3 = Color3.fromRGB(223,223,223)
					v.TextTransparency = 0.38
					table.insert(Selected, v.Name)
				end
				
				if #Selected == 0 then
					TextLabel.Text = data.Name.." - None"
				else
					TextLabel.Text = data.Name.." - "..setStringSize(table.concat(Selected, ", "), 40)
				end
				
				NoGui.Flags[data.Flag].Value = d
			end

			function Methods:Update(newData)
				for i,v in pairs(List:GetChildren()) do
					if not v:IsA("TextButton") then continue end
					v:Destroy()
				end

				for i,v in pairs(newData) do
					local Option = Instance.new("TextButton")

					Option.Name = v
					Option.Parent = List
					Option.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Option.BackgroundTransparency = 1.000
					Option.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Option.BorderSizePixel = 0
					Option.Size = UDim2.new(1, 0, 0.0425000004, 0)
					Option.Font = Enum.Font.SourceSansBold
					Option.Text = v
					Option.TextColor3 = Color3.fromRGB(134, 134, 134)
					Option.TextScaled = true
					Option.TextSize = 18.000
					Option.TextStrokeTransparency = 0.000
					Option.TextTransparency = 0.490
					Option.TextWrapped = true

					Option.MouseButton1Click:Connect(function()
						select(Option)
						
						if #NoGui.Flags[data.Flag].Value == 0 then
							TextLabel.Text = data.Name.." - None"
						else
							TextLabel.Text = data.Name.." - "..setStringSize(table.concat(Selected, ", "), 40)
						end
										
						data.Callback(Selected)
					end)

					if #Selected == 0 then
						TextLabel.Text = data.Name.." - None"
					else
						TextLabel.Text = data.Name.." - "..setStringSize(table.concat(Selected, ", "), 40)
					end
				end

				Methods:Set(Selected)
			end
			
			NoGui.Flags[data.Flag] = Methods
			NoGui.Flags[data.Flag].Value = Selected
			
			Methods:Set(data.CurrentValue)

			return Methods
		end
		
		function Elements:CreateBox(data)
			data.Flag = data.Flag or "NoFlag"

			local TextBox = Instance.new("Frame")
			local Box = Instance.new("TextBox")
			local TextLabel = Instance.new("TextLabel")
			local UICorner = Instance.new("UICorner")
			local UIStroke = Instance.new("UIStroke")
			
			TextBox.Parent = Page
			TextBox.BackgroundColor3 = Color3.fromRGB(43,43,43)
			TextBox.Size = UDim2.new(0.9,0,0.11,0)
			TextBox.Name = "TextBox"
			
			TextLabel.Parent = TextBox
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.BorderSizePixel = 0
			TextLabel.Position = UDim2.new(0.0246639531, 0, 0.229313582, 0)
			TextLabel.Size = UDim2.new(0.975336075, 0, 0.511726737, 0)
			TextLabel.Font = Enum.Font.SourceSansBold
			TextLabel.Text = data.Name
			TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.TextScaled = true
			TextLabel.TextSize = 14.000
			TextLabel.TextStrokeTransparency = 0.000
			TextLabel.TextWrapped = true
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			
			Box.Parent = TextBox
			Box.BackgroundColor3 = Color3.fromRGB(43,43,43)
			Box.Position = UDim2.new(0.83,0,0.108,0)
			Box.Size = UDim2.new(0.155,0,0.741,0)
			Box.Font = Enum.Font.SourceSansBold
			Box.PlaceholderText = data.Placeholder or "Text Here"
			Box.TextColor3 = Color3.new(1,1,1)
			Box.TextScaled = true
			
			UICorner.Parent = Box
			UICorner.CornerRadius = UDim.new(0,4)
			
			UIStroke.Parent = Box
			UIStroke.Color = Color3.fromRGB(30,30,30)
			UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke.Thickness = 1
			
			local Methods = {}
				
			Box.FocusLost:Connect(function(enterPress, inp)
				if enterPress or inp.UserInputType == Enum.UserInputType.Touch then
					local text = Box.Text
					NoGui.Flags[data.Flag].Value = text

					data.Callback(text)
				end
			end)
			
			function Methods:Set(text)
				NoGui.Flags[data.Flag].Value = text
				Box.Text = ""
				
				data.Callback(text)
			end
			
			NoGui.Flags[data.Flag] = Methods
			NoGui.Flags[data.Flag].Value = data.CurrentValue
			
			Methods:Set(data.CurrentValue)
			
			return Methods
		end
		
		function Elements:CreateColorPicker(data)
			data.Flag = data.Flag or "NoFlag"

			local TextBox = Instance.new("Frame")
			local Box = Instance.new("TextBox")
			local TextLabel = Instance.new("TextLabel")
			local UICorner = Instance.new("UICorner")
			local UIStroke = Instance.new("UIStroke")
			local Color = Instance.new("Frame")

			TextBox.Parent = Page
			TextBox.BackgroundColor3 = Color3.fromRGB(43,43,43)
			TextBox.Size = UDim2.new(0.9,0,0.11,0)
			TextBox.Name = "TextBox"

			TextLabel.Parent = TextBox
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.BorderSizePixel = 0
			TextLabel.Position = UDim2.new(0.0246639531, 0, 0.229313582, 0)
			TextLabel.Size = UDim2.new(0.975336075, 0, 0.511726737, 0)
			TextLabel.Font = Enum.Font.SourceSansBold
			TextLabel.Text = data.Name
			TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.TextScaled = true
			TextLabel.TextSize = 14.000
			TextLabel.TextStrokeTransparency = 0.000
			TextLabel.TextWrapped = true
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			Box.Parent = TextBox
			Box.BackgroundColor3 = Color3.fromRGB(43,43,43)
			Box.Position = UDim2.new(0.83,0,0.108,0)
			Box.Size = UDim2.new(0.155,0,0.741,0)
			Box.Font = Enum.Font.SourceSansBold
			Box.PlaceholderText = "Color Here"
			Box.TextColor3 = Color3.new(1,1,1)
			Box.TextScaled = true
			
			Color.Parent = TextBox
			Color.BackgroundColor3 = Color3.new()
			Color.Position = UDim2.new(0.762,0,0.054,0)
			Color.Size = UDim2.new(0.055,0,0.799,0)
			
			UICorner.Parent = Box
			UICorner.CornerRadius = UDim.new(0,4)

			UIStroke.Parent = Box
			UIStroke.Color = Color3.fromRGB(30,30,30)
			UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke.Thickness = 1
			
			UICorner:Clone().Parent = Color
			UIStroke:Clone().Parent = Color
		
			local Methods = {}

			Box.FocusLost:Connect(function(enterPress, inp)
				if enterPress or inp.UserInputType == Enum.UserInputType.Touch then
					local text = Box.Text
					local str = text:split(" ")
					
					local color = Color3.fromRGB(str[1] or 90, str[2] or 90, str[3] or 90)
					Color.BackgroundColor3 = color
					
					NoGui.Flags[data.Flag].Value = {str[1] or 90, str[2] or 90, str[3] or 90}
					
					data.Callback(color)
				end
			end)

			function Methods:Set(colordata)
				local color = Color3.fromRGB(colordata[1], colordata[2], colordata[3])		
				Color.BackgroundColor3 = color
				NoGui.Flags[data.Flag].Value = {colordata[1], colordata[2], colordata[3]}

				data.Callback(color)
			end

			NoGui.Flags[data.Flag] = Methods
			
			Methods:Set(data.CurrentValue)

			return Methods			
		end

		return Elements
	end
	
	coroutine.resume(coroutine.create(function()
		while task.wait(5) do
			local a,b = pcall(function()
				NoGui:saveFlags()
			end)
			
			if not a then print("NoName Hub Config: "..b) end
		end
	end))

	return Window
end

return NoGui
