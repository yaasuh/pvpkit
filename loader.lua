-- Advanced ESP for Roblox
-- Works with Synapse X, Script-Ware, etc.

local ESP = {
    Enabled = true,
    Tracers = true,
    Boxes = true,
    Names = true,
    HealthBars = true,
    FOVCircle = true,
    Chams = true,
    Color = Color3.fromRGB(255, 0, 0), -- Default color: Red
    FOVRadius = 100
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = game:GetService("Workspace").CurrentCamera
local LocalPlayer = Players.LocalPlayer

local function DrawESP(player)
    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        local head = player.Character:FindFirstChild("Head")
        local humanoid = player.Character:FindFirstChild("Humanoid")

        if rootPart and head and humanoid then
            local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            if onScreen then
                -- Box ESP
                if ESP.Boxes then
                    local boxSize = Vector2.new(50, 100) -- Box dimensions
                    local boxPosition = Vector2.new(rootPos.X - boxSize.X / 2, rootPos.Y - boxSize.Y / 2)
                    local box = Drawing.new("Square")
                    box.Size = boxSize
                    box.Position = boxPosition
                    box.Color = ESP.Color
                    box.Thickness = 2
                    box.Visible = true
                end
                
                -- Tracers
                if ESP.Tracers then
                    local tracer = Drawing.new("Line")
                    tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                    tracer.Color = ESP.Color
                    tracer.Thickness = 1
                    tracer.Visible = true
                end
                
                -- Name ESP
                if ESP.Names then
                    local nameTag = Drawing.new("Text")
                    nameTag.Text = player.Name
                    nameTag.Position = Vector2.new(rootPos.X, rootPos.Y - 50)
                    nameTag.Size = 16
                    nameTag.Color = ESP.Color
                    nameTag.Visible = true
                end
                
                -- Health Bar
                if ESP.HealthBars then
                    local healthBar = Drawing.new("Line")
                    healthBar.From = Vector2.new(rootPos.X - 30, rootPos.Y - 50)
                    healthBar.To = Vector2.new(rootPos.X - 30, rootPos.Y - 50 + (100 - humanoid.Health / humanoid.MaxHealth * 100))
                    healthBar.Color = Color3.fromRGB(0, 255, 0) -- Green
                    healthBar.Thickness = 2
                    healthBar.Visible = true
                end
            end
        end
    end
end

-- Update ESP Every Frame
RunService.RenderStepped:Connect(function()
    if ESP.Enabled then
        for _, player in pairs(Players:GetPlayers()) do
            DrawESP(player)
        end
    end
end)

print("Advanced ESP Loaded!")
