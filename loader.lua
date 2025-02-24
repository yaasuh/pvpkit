local player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")

-- ========== COLOR PALETTE ==========
local COLORS = {
    Background = Color3.fromRGB(30, 30, 40),
    Secondary = Color3.fromRGB(45, 45, 60),
    Text = Color3.fromRGB(240, 240, 240),
    ToggleOn = Color3.fromRGB(85, 170, 127),
    ToggleOff = Color3.fromRGB(170, 85, 127),
    Slider = Color3.fromRGB(100, 150, 200)
}

-- ========== CREATE MAIN FRAME ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PremiumMenu"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.25, 0, 0.4, 0)
mainFrame.Position = UDim2.new(0.72, 0, 0.3, 0)
mainFrame.BackgroundColor3 = COLORS.Background
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- ========== TITLE BAR ==========
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0.12, 0)
titleBar.BackgroundColor3 = COLORS.Secondary
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.Text = "PREMIUM HACK v2.1"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = COLORS.Text
titleLabel.TextSize = 18
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = titleBar

-- ========== CONTENT FRAME ==========
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 0.88, 0)
contentFrame.Position = UDim2.new(0, 0, 0.12, 0)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = contentFrame

-- ========== TOGGLE BUTTON TEMPLATE ==========
local function CreateToggle(name)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0.9, 0, 0.12, 0)
    toggleFrame.BackgroundColor3 = COLORS.Secondary
    toggleFrame.Parent = contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = toggleFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextColor3 = COLORS.Text
    label.TextSize = 14
    label.BackgroundTransparency = 1
    label.Parent = toggleFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.2, 0, 0.6, 0)
    toggleButton.Position = UDim2.new(0.75, 0, 0.2, 0)
    toggleButton.Text = ""
    toggleButton.BackgroundColor3 = COLORS.ToggleOff
    toggleButton.Parent = toggleFrame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleButton

    return toggleButton
end

-- ========== CREATE TOGGLES ==========
local aimbotToggle = CreateToggle("AIMBOT")
local espToggle = CreateToggle("ESP")
local hitboxToggle = CreateToggle("HITBOX EXPANDER")

-- ========== SLIDER COMPONENT ==========
local sliderContainer = Instance.new("Frame")
sliderContainer.Size = UDim2.new(0.9, 0, 0.15, 0)
sliderContainer.BackgroundTransparency = 1
sliderContainer.Parent = contentFrame

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Text = "HITBOX SIZE: 1"
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextColor3 = COLORS.Text
sliderLabel.TextSize = 14
sliderLabel.BackgroundTransparency = 1
sliderLabel.Size = UDim2.new(1, 0, 0.4, 0)
sliderLabel.Parent = sliderContainer

local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(1, 0, 0.3, 0)
sliderTrack.Position = UDim2.new(0, 0, 0.5, 0)
sliderTrack.BackgroundColor3 = COLORS.Secondary
sliderTrack.Parent = sliderContainer

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0, 0, 1, 0)
sliderFill.BackgroundColor3 = COLORS.Slider
sliderFill.Parent = sliderTrack

local UIS = game:GetService("UserInputService")
local dragging = false

local function updateSlider(input)
    local relativePosition = input.Position.X - sliderTrack.AbsolutePosition.X
    local percentage = math.clamp(relativePosition / sliderTrack.AbsoluteSize.X, 0, 1)
    sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    sliderLabel.Text = "HITBOX SIZE: " .. math.floor(percentage * 10)
end

sliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        updateSlider(input)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateSlider(input)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
