-- Services
local player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Color Palette
local COLORS = {
    Background = Color3.fromRGB(20, 20, 30),
    Secondary = Color3.fromRGB(40, 40, 55),
    Text = Color3.fromRGB(255, 255, 255),
    Slider = Color3.fromRGB(80, 140, 200),
    Button = Color3.fromRGB(100, 180, 140),
    Minimize = Color3.fromRGB(200, 100, 100)
}

-- UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.3, 0, 0.4, 0)
mainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
mainFrame.BackgroundColor3 = COLORS.Background
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0.12, 0)
titleBar.BackgroundColor3 = COLORS.Secondary
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.Text = "BANKAI PVP KIT"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = COLORS.Text
titleLabel.TextSize = 18
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = titleBar

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0.12, 0, 0.8, 0)
minimizeButton.Position = UDim2.new(0.88, 0, 0.1, 0)
minimizeButton.BackgroundColor3 = COLORS.Minimize
minimizeButton.Text = "-"
minimizeButton.TextColor3 = COLORS.Text
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 16
minimizeButton.Parent = titleBar

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(1, 0)
buttonCorner.Parent = minimizeButton

-- Draggable Feature
local dragging, dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Minimize Animation
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    local goalSize = minimized and UDim2.new(0.3, 0, 0.12, 0) or UDim2.new(0.3, 0, 0.4, 0)
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = goalSize}):Play()
end)

-- Hitbox Expander Logic
local function updateHitboxSize(size)
    for _, enemy in pairs(game:GetService("Players"):GetPlayers()) do
        if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
            enemy.Character.HumanoidRootPart.Size = Vector3.new(size, size, size)
        end
    end
end

-- Slider UI
local sliderContainer = Instance.new("Frame")
sliderContainer.Size = UDim2.new(0.9, 0, 0.15, 0)
sliderContainer.Position = UDim2.new(0.05, 0, 0.2, 0)
sliderContainer.BackgroundColor3 = COLORS.Secondary
sliderContainer.Parent = mainFrame

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(1, 0, 0.4, 0)
sliderLabel.Text = "Hitbox Size: 10"
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextColor3 = COLORS.Text
sliderLabel.TextSize = 14
sliderLabel.BackgroundTransparency = 1
sliderLabel.Parent = sliderContainer

local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(1, 0, 0.3, 0)
sliderTrack.Position = UDim2.new(0, 0, 0.5, 0)
sliderTrack.BackgroundColor3 = COLORS.Slider
sliderTrack.Parent = sliderContainer

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.2, 0, 1, 0)
sliderFill.BackgroundColor3 = COLORS.Button
sliderFill.Parent = sliderTrack

local draggingSlider = false
sliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = true
    end
end)

UIS.InputChanged:Connect(function(input)
    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        local hitboxSize = math.floor(pos * 50)
        sliderLabel.Text = "Hitbox Size: " .. hitboxSize
        updateHitboxSize(hitboxSize)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = false
    end
end)

-- Update Hitbox Every 100ms
task.spawn(function()
    while true do
        updateHitboxSize(10)
        task.wait(0.1)
    end
end)
