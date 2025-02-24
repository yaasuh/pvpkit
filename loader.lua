-- BANKAI PVP KIT GUI
local player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

-- Color Palette
local COLORS = {
    Background = Color3.fromRGB(20, 20, 30),
    Secondary = Color3.fromRGB(40, 40, 50),
    Text = Color3.fromRGB(255, 255, 255),
    ToggleOn = Color3.fromRGB(85, 170, 127),
    ToggleOff = Color3.fromRGB(170, 85, 127),
    Slider = Color3.fromRGB(85, 85, 255)
}

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BankaiPvpKit"
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
titleBar.Size = UDim2.new(1, 0, 0.15, 0)
titleBar.BackgroundColor3 = COLORS.Secondary
titleBar.Parent = mainFrame

titleBar.Active = true
titleBar.Draggable = true

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mainFrame.Position = UDim2.new(0, input.Position.X, 0, input.Position.Y)
    end
end)

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
minimizeButton.Size = UDim2.new(0.1, 0, 1, 0)
minimizeButton.Position = UDim2.new(0.9, 0, 0, 0)
minimizeButton.Text = "_"
minimizeButton.TextSize = 20
minimizeButton.BackgroundColor3 = COLORS.ToggleOff
minimizeButton.Parent = titleBar

local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    TweenService:Create(mainFrame, TweenInfo.new(0.5), {Size = isMinimized and UDim2.new(0.3, 0, 0.15, 0) or UDim2.new(0.3, 0, 0.4, 0)}):Play()
end)

-- Hitbox Expander Toggle
local hitboxToggle = Instance.new("TextButton")
hitboxToggle.Size = UDim2.new(0.9, 0, 0.12, 0)
hitboxToggle.Position = UDim2.new(0.05, 0, 0.2, 0)
hitboxToggle.Text = "Hitbox Expander"
hitboxToggle.Font = Enum.Font.Gotham
hitboxToggle.TextColor3 = COLORS.Text
hitboxToggle.BackgroundColor3 = COLORS.ToggleOff
hitboxToggle.Parent = mainFrame

local hitboxEnabled = false
hitboxToggle.MouseButton1Click:Connect(function()
    hitboxEnabled = not hitboxEnabled
    hitboxToggle.BackgroundColor3 = hitboxEnabled and COLORS.ToggleOn or COLORS.ToggleOff
end)

-- Hitbox Size Slider
local slider = Instance.new("Frame")
slider.Size = UDim2.new(0.9, 0, 0.1, 0)
slider.Position = UDim2.new(0.05, 0, 0.35, 0)
slider.BackgroundColor3 = COLORS.Secondary
slider.Parent = mainFrame

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0.1, 0, 1, 0)
sliderButton.BackgroundColor3 = COLORS.Slider
sliderButton.Parent = slider

local hitboxSize = 10
sliderButton.MouseButton1Down:Connect(function()
    local connection
    connection = UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            sliderButton.Position = UDim2.new(pos, 0, 0, 0)
            hitboxSize = math.floor(pos * 50)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            connection:Disconnect()
        end
    end)
end)

-- Update Hitbox Size
while true do
    if hitboxEnabled then
        for _, enemy in pairs(game:GetService("Players"):GetPlayers()) do
            if enemy ~= player and enemy.Character then
                for _, part in pairs(enemy.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    end
                end
            end
        end
    end
    wait(0.1) -- Update every 100ms
end
