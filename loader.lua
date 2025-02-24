local player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ========== COLOR PALETTE ==========
local COLORS = {
    Background = Color3.fromRGB(30, 30, 40),
    Secondary = Color3.fromRGB(45, 45, 60),
    Text = Color3.fromRGB(240, 240, 240),
    SliderTrack = Color3.fromRGB(50, 50, 60),
    SliderFill = Color3.fromRGB(85, 170, 255),
    SliderKnob = Color3.fromRGB(230, 230, 230),
    ToggleOn = Color3.fromRGB(85, 170, 127),
    ToggleOff = Color3.fromRGB(170, 85, 127),
}

-- ========== CREATE MAIN FRAME ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PremiumMenu"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.25, 0, 0.4, 0)
mainFrame.Position = UDim2.new(0.72, 0, 0.3, 0)
mainFrame.BackgroundColor3 = COLORS.Background
mainFrame.Parent = screenGui

-- ========== HITBOX TOGGLE BUTTON ==========
local hitboxToggle = Instance.new("TextButton")
hitboxToggle.Size = UDim2.new(0.9, 0, 0.12, 0)
hitboxToggle.Position = UDim2.new(0.05, 0, 0.1, 0)
hitboxToggle.BackgroundColor3 = COLORS.ToggleOff
hitboxToggle.Text = "Hitbox: OFF"
hitboxToggle.TextColor3 = COLORS.Text
hitboxToggle.TextSize = 14
hitboxToggle.Parent = mainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = hitboxToggle

-- ========== SLIDER COMPONENT ==========
local sliderContainer = Instance.new("Frame")
sliderContainer.Size = UDim2.new(0.9, 0, 0.15, 0)
sliderContainer.Position = UDim2.new(0.05, 0, 0.3, 0)
sliderContainer.Parent = mainFrame

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Text = "Hitbox Size: 10"
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextColor3 = COLORS.Text
sliderLabel.TextSize = 14
sliderLabel.Size = UDim2.new(0.3, 0, 1, 0)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Parent = sliderContainer

local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(0.65, 0, 0.3, 0)
sliderTrack.Position = UDim2.new(0.35, 0, 0.5, 0)
sliderTrack.BackgroundColor3 = COLORS.SliderTrack
sliderTrack.Parent = sliderContainer

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0, 0, 1, 0)
sliderFill.BackgroundColor3 = COLORS.SliderFill
sliderFill.Parent = sliderTrack

local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.new(0, 12, 1.5, 0)
sliderKnob.Position = UDim2.new(0, -6, -0.25, 0)
sliderKnob.BackgroundColor3 = COLORS.SliderKnob
sliderKnob.Parent = sliderFill

local UICornerKnob = Instance.new("UICorner")
UICornerKnob.CornerRadius = UDim.new(1, 0)
UICornerKnob.Parent = sliderKnob

local dragging = false
local hitboxSize = 10
local hitboxEnabled = false

-- ========== HITBOX EXPANDER FUNCTION ==========
local function updateHitbox()
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if hitboxEnabled then
                v.Character.HumanoidRootPart.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                v.Character.HumanoidRootPart.Transparency = 0.5
                v.Character.HumanoidRootPart.CanCollide = false
            else
                v.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                v.Character.HumanoidRootPart.Transparency = 0
                v.Character.HumanoidRootPart.CanCollide = true
            end
        end
    end
end

-- Auto-Update Every 100ms (0.1s)
task.spawn(function()
    while true do
        if hitboxEnabled then
            updateHitbox()
        end
        task.wait(0.1) -- 100ms update rate
    end
end)

-- ========== TOGGLE BUTTON FUNCTIONALITY ==========
hitboxToggle.MouseButton1Click:Connect(function()
    hitboxEnabled = not hitboxEnabled
    if hitboxEnabled then
        hitboxToggle.Text = "Hitbox: ON"
        hitboxToggle.BackgroundColor3 = COLORS.ToggleOn
    else
        hitboxToggle.Text = "Hitbox: OFF"
        hitboxToggle.BackgroundColor3 = COLORS.ToggleOff
    end
end)

-- ========== SLIDER FUNCTIONALITY ==========
local function updateSlider(input)
    local relativePosition = input.Position.X - sliderTrack.AbsolutePosition.X
    local percentage = math.clamp(relativePosition / sliderTrack.AbsoluteSize.X, 0, 1)
    sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    sliderKnob.Position = UDim2.new(percentage, -6, -0.25, 0)

    hitboxSize = math.floor(10 + (percentage * 40)) -- 10 = 50 scaling
    sliderLabel.Text = "Hitbox Size: " .. hitboxSize
end

sliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
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

print("Updated Loader GUI with Hitbox Expander, Toggle & Working Slider Loaded!")
