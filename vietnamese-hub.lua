-- Vietnamese Hub for Blox Fruits

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Vietnamese Flag Colors
local VIETNAM_RED = Color3.fromRGB(218, 37, 29)    -- Do
local VIETNAM_YELLOW = Color3.fromRGB(255, 255, 0)  -- Vang
local DARK_RED = Color3.fromRGB(139, 0, 0)

-- Services
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CommF_ = Remotes:WaitForChild("CommF_")

-- State Management
local VietnameseHub = {
    Enabled = false,
    AutoFarm = false,
    AutoAttack = false,
    AutoBuso = false,
    FastAttack = false,
    Noclip = false,
    Flying = false,
    SelectedEnemy = nil,
    CurrentSea = 1
}

-- Sea Detection System
function VietnameseHub:GetCurrentSea()
    local pos = HumanoidRootPart.Position
    
    -- Sea 1: Starter area, Pirate Village, etc. (Y < 1000, specific zones)
    if pos.Y < 1000 then
        -- Check for Sea 1 specific locations
        if Workspace:FindFirstChild("StartIsland") or 
           Workspace:FindFirstChild("PirateVillage") or
           Workspace:FindFirstChild("Jungle") then
            VietnameseHub.CurrentSea = 1
            return 1
        end
    end
    
    -- Sea 2: New World (Y > 1000, Cafe, etc.)
    if Workspace:FindFirstChild("Cafe") or 
       Workspace:FindFirstChild("Dressrosa") or
       Workspace:FindFirstChild("SwanRoom") then
        VietnameseHub.CurrentSea = 2
        return 2
    end
    
    -- Sea 3: Third Sea (Castle, etc.)
    if Workspace:FindFirstChild("Castle") or
       Workspace:FindFirstChild("HydraIsland") or
       Workspace:FindFirstChild("Mansion") then
        VietnameseHub.CurrentSea = 3
        return 3
    end
    
    return VietnameseHub.CurrentSea
end

-- Enemy Detection - Prioritize Pirates in Sea 1
function VietnameseHub:GetNearestEnemy()
    local nearest = nil
    local minDistance = math.huge
    local currentSea = VietnameseHub:GetCurrentSea()
    
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return nil end
    
    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
            local humanoid = enemy.Humanoid
            local rootPart = enemy.HumanoidRootPart
            
            -- Skip dead enemies
            if humanoid.Health <= 0 then continue end
            
            local distance = (rootPart.Position - HumanoidRootPart.Position).Magnitude
            
            -- Prioritize "Pirate" starters in Sea 1
            local isPriority = false
            if currentSea == 1 then
                local name = enemy.Name:lower()
                if name:find("pirate") or name:find("bandit") or name:find("enemy") then
                    isPriority = true
                end
            end
            
            -- Closer distance or priority target
            if distance < minDistance or (isPriority and distance < minDistance * 1.5) then
                minDistance = distance
                nearest = enemy
            end
        end
    end
    
    return nearest
end

-- Flying System using TweenService
function VietnameseHub:FlyToPosition(targetPosition, speed)
    speed = speed or 250
    local distance = (targetPosition - HumanoidRootPart.Position).Magnitude
    local duration = distance / speed
    
    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.InOut
    )
    
    local tween = TweenService:Create(
        HumanoidRootPart,
        tweenInfo,
        {CFrame = CFrame.new(targetPosition)}
    )
    
    tween:Play()
    return tween
end

-- Auto Buso Haki
function VietnameseHub:EnableBuso()
    pcall(function()
        CommF_:InvokeServer("Buso")
    end)
end

-- Fast Attack System
function VietnameseHub:FastAttack()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:Button1Down(Vector2.new(0, 0))
    end)
end

-- Noclip System
function VietnameseHub:EnableNoclip()
    RunService.Stepped:Connect(function()
        if VietnameseHub.Noclip and Character then
            for _, part in ipairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

-- Auto Farm Loop
function VietnameseHub:StartAutoFarm()
    task.spawn(function()
        while VietnameseHub.AutoFarm do
            task.wait(0.1)
            
            if not VietnameseHub.AutoFarm then break end
            
            -- Auto Buso
            if VietnameseHub.AutoBuso then
                VietnameseHub:EnableBuso()
            end
            
            -- Get target
            local enemy = VietnameseHub:GetNearestEnemy()
            if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                VietnameseHub.SelectedEnemy = enemy
                
                -- Fly to enemy
                local targetPos = enemy.HumanoidRootPart.Position + Vector3.new(0, 20, 0)
                VietnameseHub:FlyToPosition(targetPos, 300)
                
                -- Attack
                if VietnameseHub.AutoAttack then
                    VietnameseHub:FastAttack()
                end
            end
        end
    end)
end

-- UI Creation
function VietnameseHub:CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VietnameseHub"
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Main Frame (Vietnam Flag Style)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 400, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    MainFrame.BackgroundColor3 = VIETNAM_RED
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    -- Corner
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = DARK_RED
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar
    
    -- Title Text
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🇻🇳 Vietnamese Hub 🇻🇳"
    Title.TextColor3 = VIETNAM_YELLOW
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.Parent = TitleBar
    
    -- Star Decoration (Vietnam Flag Star)
    local Star = Instance.new("TextLabel")
    Star.Size = UDim2.new(0, 60, 0, 60)
    Star.Position = UDim2.new(0.5, -30, 0.15, 0)
    Star.BackgroundTransparency = 1
    Star.Text = "⭐"
    Star.TextSize = 50
    Star.Parent = MainFrame
    
    -- Button Container
    local ButtonContainer = Instance.new("ScrollingFrame")
    ButtonContainer.Name = "ButtonContainer"
    ButtonContainer.Size = UDim2.new(1, -20, 0.7, 0)
    ButtonContainer.Position = UDim2.new(0, 10, 0.25, 0)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.ScrollBarThickness = 4
    ButtonContainer.Parent = MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = ButtonContainer
    
    -- Create Toggle Button Function
    local function CreateToggleButton(name, callback)
        local Button = Instance.new("TextButton")
        Button.Name = name
        Button.Size = UDim2.new(1, -10, 0, 45)
        Button.BackgroundColor3 = VIETNAM_YELLOW
        Button.TextColor3 = VIETNAM_RED
        Button.TextSize = 18
        Button.Font = Enum.Font.GothamBold
        Button.Text = name .. ": OFF"
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = Button
        
        local enabled = false
        Button.MouseButton1Click:Connect(function()
            enabled = not enabled
            Button.Text = name .. ": " .. (enabled and "ON" or "OFF")
            Button.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or VIETNAM_YELLOW
            callback(enabled)
        end)
        
        return Button
    end
    
    -- Auto Farm Toggle
    CreateToggleButton("Auto Farm", function(enabled)
        VietnameseHub.AutoFarm = enabled
        if enabled then
            VietnameseHub:StartAutoFarm()
        end
    end).Parent = ButtonContainer
    
    -- Auto Attack Toggle
    CreateToggleButton("Auto Attack", function(enabled)
        VietnameseHub.AutoAttack = enabled
    end).Parent = ButtonContainer
    
    -- Auto Buso Toggle
    CreateToggleButton("Auto Buso", function(enabled)
        VietnameseHub.AutoBuso = enabled
    end).Parent = ButtonContainer
    
    -- Fast Attack Toggle
    CreateToggleButton("Fast Attack", function(enabled)
        VietnameseHub.FastAttack = enabled
    end).Parent = ButtonContainer
    
    -- Noclip Toggle
    CreateToggleButton("Noclip", function(enabled)
        VietnameseHub.Noclip = enabled
        if enabled then
            VietnameseHub:EnableNoclip()
        end
    end).Parent = ButtonContainer
    
    -- Sea Info Label
    local SeaInfo = Instance.new("TextLabel")
    SeaInfo.Name = "SeaInfo"
    SeaInfo.Size = UDim2.new(1, -20, 0, 30)
    SeaInfo.BackgroundTransparency = 1
    SeaInfo.TextColor3 = VIETNAM_YELLOW
    SeaInfo.TextSize = 16
    SeaInfo.Font = Enum.Font.Gotham
    SeaInfo.Text = "Current Sea: Detecting..."
    SeaInfo.Parent = ButtonContainer
    
    -- Update Sea Info
    task.spawn(function()
        while task.wait(1) do
            local sea = VietnameseHub:GetCurrentSea()
            SeaInfo.Text = "Current Sea: " .. sea .. " | Enemy: " .. (VietnameseHub.SelectedEnemy and VietnameseHub.SelectedEnemy.Name or "None")
        end
    end)
    
    -- Make Draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = VIETNAM_RED
    CloseButton.TextColor3 = VIETNAM_YELLOW
    CloseButton.Text = "X"
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 4)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        VietnameseHub.AutoFarm = false
        VietnameseHub.AutoAttack = false
    end)
    
    -- Minimize Button
    local MinButton = Instance.new("TextButton")
    MinButton.Size = UDim2.new(0, 30, 0, 30)
    MinButton.Position = UDim2.new(1, -70, 0, 5)
    MinButton.BackgroundColor3 = VIETNAM_YELLOW
    MinButton.TextColor3 = VIETNAM_RED
    MinButton.Text = "-"
    MinButton.TextSize = 24
    MinButton.Font = Enum.Font.GothamBold
    MinButton.Parent = TitleBar
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 4)
    MinCorner.Parent = MinButton
    
    local minimized = false
    MinButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        ButtonContainer.Visible = not minimized
        Star.Visible = not minimized
        MinButton.Text = minimized and "+" or "-"
    end)
    
    return ScreenGui
end

-- Initialize
VietnameseHub.Enabled = true
local UI = VietnameseHub:CreateUI()

-- Character Respawn Handler
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
end)

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🇻🇳 Vietnamese Hub",
    Text = "Loaded successfully! Based on Teddy Hub",
    Duration = 5
})

print("🇻🇳 Vietnamese Hub Loaded | Sea Detection: Active | Auto Farm: Ready")
