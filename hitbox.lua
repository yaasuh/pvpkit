local player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")

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
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.25, 0, 0.4, 0)
mainFrame.Position = UDim2.new(0.72, 0, 0.3, 0)
mainFrame.BackgroundColor3 = COLORS.Background
mainFrame.Parent = screenGui

-- ========== TOGGLE BUTTON FUNCTION ==========
local function CreateToggle(name, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0.9, 0, 0.12, 0)
    toggleFrame.BackgroundColor3 = COLORS.Secondary
    toggleFrame.Parent = mainFrame

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

    local toggled = false

    toggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        toggleButton.BackgroundColor3 = toggled and COLORS.ToggleOn or COLORS.ToggleOff
        callback(toggled)
    end)
end

-- ========== SLIDER COMPONENT ==========
local sliderContainer = Instance.new("Frame")
sliderContainer.Size = UDim2.new(0.9, 0, 0.15, 0)
sliderContainer.Parent = mainFrame

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Text = "HITBOX SIZE: 10"
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextColor3 = COLORS.Text
sliderLabel.TextSize = 14
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

local dragging = false
local hitboxSize = 10

local function updateSlider(input)
    local relativePosition = input.Position.X - sliderTrack.AbsolutePosition.X
    local percentage = math.clamp(relativePosition / sliderTrack.AbsoluteSize.X, 0, 1)
    sliderFill.Size = UDim2.new(percentage, 0, 1, 0)

    hitboxSize = math.floor(10 + (percentage * 40)) -- 10 = 50, max size
    sliderLabel.Text = "HITBOX SIZE: " .. hitboxSize

    -- Communicate with hitbox.lua
    getgenv().UpdateHitboxSize(hitboxSize)
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

-- ========== CREATE TOGGLES ==========
CreateToggle("HITBOX EXPANDER", function(enabled)
    getgenv().HitboxEnabled = enabled
    getgenv().ToggleHitbox()
end)

-- ========== LOAD HITBOX SCRIPT ==========
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR-USERNAME/YOUR-REPO/main/hitbox.lua"))()

print("Loader GUI Loaded!")
