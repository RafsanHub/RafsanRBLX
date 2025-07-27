local allowedGameId = 12137249458  -- Replace with your real FPS Gun Grounds FFA PlaceId
if game.PlaceId ~= allowedGameId then
    return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local function getRainbowColor()
	return Color3.fromHSV(tick() % 5 / 5, 1, 1)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RafsanUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Icon = Instance.new("TextButton", ScreenGui)
Icon.Text = "R"
Icon.Size = UDim2.new(0, 50, 0, 50)
Icon.Position = UDim2.new(0, 20, 0, 220)
Icon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Icon.TextColor3 = Color3.fromRGB(255, 0, 0)
Icon.Font = Enum.Font.SourceSansBold
Icon.TextSize = 28
Icon.BorderSizePixel = 2
Icon.BorderColor3 = Color3.fromRGB(255, 0, 0)
Icon.ZIndex = 10

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 350)
Main.Position = UDim2.new(0.5, -150, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(60, 60, 60)
Main.Visible = false
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 5, 0, 5)
Title.Text = "(FPS)🔫 GUN GROUNDS FFA - MADE BY RAFSAN ZAMI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BorderSizePixel = 0

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 7)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.Font = Enum.Font.SourceSansBold
Close.TextSize = 14
Close.BorderSizePixel = 0
Close.MouseButton1Click:Connect(function()
	Main.Visible = false
end)

local TabNames = {"ESP HACKES", "AIM HACKES", "VISUAL HACKES", "ABOUT"}
local tabButtons = {}

local TabContainer = Instance.new("Frame", Main)
TabContainer.Size = UDim2.new(1, -10, 0, 30)
TabContainer.Position = UDim2.new(0, 5, 0, 50)
TabContainer.BackgroundTransparency = 1

local totalTabWidth = 0
for i, name in ipairs(TabNames) do
	local Tab = Instance.new("TextButton", TabContainer)
	Tab.Size = UDim2.new(0, 70, 1, 0)
	Tab.Position = UDim2.new(0, (i-1)*75, 0, 0)
	Tab.Text = name
	Tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
	Tab.Font = Enum.Font.SourceSans
	Tab.TextSize = 12
	Tab.BorderSizePixel = 0
	tabButtons[name] = Tab
	totalTabWidth = totalTabWidth + 70 + 5
end
local offsetX = (300 - totalTabWidth + 5)/2
TabContainer.Position = UDim2.new(0, offsetX, 0, 50)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -10, 1, -100)
Container.Position = UDim2.new(0, 5, 0, 85)
Container.BackgroundTransparency = 1
Container.ClipsDescendants = true

local function ClearContainer()
	for _, child in pairs(Container:GetChildren()) do
		child:Destroy()
	end
end

local function createToggle(text, yPos, callback)
	local Btn = Instance.new("TextButton", Container)
	Btn.Size = UDim2.new(0.98, 0, 0, 30)
	Btn.Position = UDim2.new(0.01, 0, 0, yPos)
	Btn.Text = text .. " [OFF]"
	Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
	Btn.Font = Enum.Font.SourceSans
	Btn.TextSize = 13
	Btn.BorderSizePixel = 0
	local state = false
	Btn.MouseButton1Click:Connect(function()
		state = not state
		Btn.Text = text .. " [" .. (state and "ON" or "OFF") .. "]"
		if callback then callback(state) end
	end)
	return Btn
end

local espGlow = false
local espLine = false
local espMiddle = false
local espRainbow = false
local espDots = false
local aimbotOn = false

local highlights = {}
local lines = {}
local dots = {}

local function clearHighlights()
	for _, hl in pairs(highlights) do
		if hl and hl.Parent then
			hl:Destroy()
		end
	end
	highlights = {}
end

local function clearLines()
	for _, line in pairs(lines) do
		line:Remove()
	end
	lines = {}
end

local function clearDots()
	for _, dot in pairs(dots) do
		dot:Remove()
	end
	dots = {}
end

local function updateESPGlow()
	clearHighlights()
	if espGlow then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				if not plr.Character:FindFirstChild("ESPHighlight") then
					local hl = Instance.new("Highlight")
					hl.Name = "ESPHighlight"
					hl.FillColor = espRainbow and getRainbowColor() or Color3.new(1, 1, 0)
					hl.OutlineColor = Color3.new(1, 0.85, 0)
					hl.Parent = plr.Character
					table.insert(highlights, hl)
				end
			end
		end
	else
		clearHighlights()
	end
end

local function updateESPLines()
	clearLines()
	if not espLine and not espMiddle then return end
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local root = plr.Character.HumanoidRootPart
			local pos, onScreen = camera:WorldToViewportPoint(root.Position)
			if onScreen then
				local line = Drawing.new("Line")
				line.Thickness = 2
				line.Transparency = 1
				line.Color = espRainbow and getRainbowColor() or Color3.new(1, 1, 0)
				line.Visible = true
				local fromX = camera.ViewportSize.X / 2
				local fromY = espLine and 0 or camera.ViewportSize.Y / 2
				line.From = Vector2.new(fromX, fromY)
				line.To = Vector2.new(pos.X, pos.Y)
				table.insert(lines, line)
			end
		end
	end
end

local function updateESPDots()
	clearDots()
	if not espDots then return end
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local root = plr.Character.HumanoidRootPart
			local pos, onScreen = camera:WorldToViewportPoint(root.Position)
			if onScreen then
				local dot = Drawing.new("Circle")
				dot.Radius = 5
				dot.Thickness = 2
				dot.Filled = true
				dot.Transparency = 1
				dot.Color = espRainbow and getRainbowColor() or Color3.new(1, 1, 0)
				dot.Visible = true
				dot.Position = Vector2.new(pos.X, pos.Y)
				table.insert(dots, dot)
			end
		end
	end
end

RunService.RenderStepped:Connect(function()
	if aimbotOn then
		local nearestHead = nil
		local shortestDist = math.huge
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
				local head = plr.Character.Head
				local dist = (head.Position - camera.CFrame.Position).Magnitude
				if dist < shortestDist then
					shortestDist = dist
					nearestHead = head
				end
			end
		end
		if nearestHead then
			camera.CFrame = CFrame.new(camera.CFrame.Position, nearestHead.Position)
		end
	end
	updateESPGlow()
	updateESPLines()
	updateESPDots()
end)

local function ShowESPTab()
	ClearContainer()
	local features = {
		{name = "ESP Glow", callback = function(state)
			espGlow = state
			updateESPGlow()
		end},
		{name = "ESP Line", callback = function(state)
			espLine = state
			updateESPLines()
		end},
		{name = "ESP Middle", callback = function(state)
			espMiddle = state
			updateESPLines()
		end},
		{name = "ESP Rainbow", callback = function(state)
			espRainbow = state
			updateESPGlow()
			updateESPLines()
			updateESPDots()
		end},
		{name = "ESP Dots (Balls)", callback = function(state)
			espDots = state
			updateESPDots()
		end},
	}
	for i, feat in ipairs(features) do
		createToggle(feat.name, (i-1)*35, feat.callback)
	end
end

local function ShowAIMTab()
	ClearContainer()
	createToggle("Aimbot", 0, function(state)
		aimbotOn = state
	end)
end

local function ShowVisualTab()
	ClearContainer()
	local Label = Instance.new("TextLabel", Container)
	Label.Size = UDim2.new(1, 0, 0, 30)
	Label.Position = UDim2.new(0, 0, 0, 10)
	Label.Text = "THIS HACK IS NO LONGER AVAILABLE"
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.SourceSansBold
	Label.TextSize = 14
end

local aboutActive = false

for name, btn in pairs(tabButtons) do
	btn.MouseButton1Click:Connect(function()
		if name == "ABOUT" then
			if not aboutActive then
				for _, tab in pairs(tabButtons) do
					if tab.Text ~= "ABOUT" then
						tab.Visible = false
					end
				end
				btn.Text = "BACK"
				ClearContainer()
				aboutActive = true
			else
				btn.Text = "ABOUT"
				for _, tab in pairs(tabButtons) do
					tab.Visible = true
				end
				ClearContainer()
				aboutActive = false
			end
		else
			for _, tab in pairs(tabButtons) do
				tab.BackgroundColor3 = Color3.fromRGB(40,40,40)
			end
			btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
			aboutActive = false
			tabButtons["ABOUT"].Text = "ABOUT"
			for _, tab in pairs(tabButtons) do
				if tab.Text ~= "ABOUT" then
					tab.Visible = true
				end
			end

			if name == "ESP HACKES" then
				ShowESPTab()
			elseif name == "AIM HACKES" then
				ShowAIMTab()
			elseif name == "VISUAL HACKES" then
				ShowVisualTab()
			end
		end
	end)
end

tabButtons["ESP HACKES"].BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ShowESPTab()

Icon.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)
