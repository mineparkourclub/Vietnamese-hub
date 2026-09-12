local P = game:GetService("Players")
local R = game:GetService("ReplicatedStorage")
local W = game:GetService("Workspace")
local V = game:GetService("VirtualUser")
local U = game:GetService("UserInputService")

local p = P.LocalPlayer
local c = p.Character or p.CharacterAdded:Wait()
local h = c:WaitForChild("Humanoid")
local hrp = c:WaitForChild("HumanoidRootPart")

-- Detect Sea
local function GetSea()
    local pos = hrp.Position
    if pos.Z > -2000 and pos.Z < 2000 and pos.X > -4000 and pos.X < 4000 then return 1 end
    if pos.Z > 50000 or pos.Z < -50000 then return 3 end
    return 2
end

local CurrentSea = GetSea()

local C = {
    AF = false, AB = false, AM = false, ASB = false, AR = false,
    ARF = false, ASF = false, AMe = false, AD = false, ASw = false,
    AG = false, AFr = false, AH = false, AQ = false,
    SW = "Melee", FE = false, CE = false
}

-- Get Enemy for specific sea
function G(sea)
    local n, d = nil, math.huge
    for _, e in pairs(W.Enemies:GetChildren()) do
        if e:FindFirstChild("Humanoid") and e:FindFirstChild("HumanoidRootPart") and e.Humanoid.Health > 0 then
            local valid = false
            if sea == 1 then
                valid = e.Name == "Bandit" or e.Name == "Monkey" or e.Name == "Gorilla" or 
                        e.Name == "Pirate" or e.Name == "Brute" or e.Name == "Desert Bandit" or
                        e.Name == "Desert Officer" or e.Name == "Snow Bandit" or e.Name == "Snowman" or
                        e.Name == "Chief Petty Officer" or e.Name == "Vice Admiral"
            elseif sea == 2 then
                valid = e.Name == "Raider" or e.Name == "Mercenary" or e.Name == "Swan Pirate" or
                        e.Name == "Factory Staff" or e.Name == "Marine Lieutenant" or e.Name == "Marine Captain" or
                        e.Name == "Zombie" or e.Name == "Vampire" or e.Name == "Snow Trooper" or
                        e.Name == "Winter Warrior"
            else
                valid = e.Name == "Pirate Millionaire" or e.Name == "Dragon Crew Warrior" or
                        e.Name == "Dragon Crew Archer" or e.Name == "Ghoul" or
                        e.Name == "Reformed Revolutionary" or e.Name == "Cocoa Warrior" or
                        e.Name == "Chocolate Bar Battler" or e.Name == "Sweet Thief"
            end
            
            if valid then
                local D = (hrp.Position - e.HumanoidRootPart.Position).Magnitude
                if D < d then d = D n = e end
            end
        end
    end
    return n
end

-- Get Boss for specific sea
function B(sea)
    local bosses = {}
    if sea == 1 then
        bosses = {"The Gorilla King", "Bobby", "Yeti", "Mob Leader", "Vice Admiral",
                 "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord",
                 "Wysper", "Thunder God", "Cyborg", "Saber Expert", "Darkbeard", "Ice Admiral"}
    elseif sea == 2 then
        bosses = {"Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral",
                 "Awakened Ice Admiral", "Tide Keeper", "Cursed Captain"}
    else
        bosses = {"Cake Queen", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate",
                 "Longma", "Soul Reaper", "rip_indra"}
    end
    
    for _, e in pairs(W.Enemies:GetChildren()) do
        for _, bn in pairs(bosses) do
            if e.Name == bn and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
                return e
            end
        end
    end
    return nil
end

function S()
    for _, v in pairs(W:GetChildren()) do
        if v.Name:lower():find("seabeast") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            return v
        end
    end
    return nil
end

function A()
    pcall(function()
        V:CaptureController()
        V:Button1Down(Vector2.new(1280, 672))
        wait(0.05)
        V:Button1Up(Vector2.new(1280, 672))
    end)
end

-- UI Creation
local Sg = Instance.new("ScreenGui")
Sg.Name = "VH"
Sg.ResetOnSpawn = false
Sg.Parent = game.CoreGui

local M = Instance.new("Frame")
M.Size = UDim2.new(0, 550, 0, 350)
M.Position = UDim2.new(0.5, -275, 0.5, -175)
M.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
M.Parent = Sg
Instance.new("UICorner", M).CornerRadius = UDim.new(0, 6)

local T = Instance.new("Frame")
T.Size = UDim2.new(1, 0, 0, 30)
T.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
T.Parent = M
Instance.new("UICorner", T).CornerRadius = UDim.new(0, 6)

local L = Instance.new("TextLabel")
L.Size = UDim2.new(1, -60, 1, 0)
L.Position = UDim2.new(0, 10, 0, 0)
L.BackgroundTransparency = 1
L.Text = "Vietnamese Hub | Sea " .. CurrentSea
L.TextColor3 = Color3.new(1, 1, 1)
L.TextSize = 14
L.Font = Enum.Font.GothamBold
L.TextXAlignment = Enum.TextXAlignment.Left
L.Parent = T

local X = Instance.new("TextButton")
X.Size = UDim2.new(0, 25, 0, 25)
X.Position = UDim2.new(1, -28, 0, 2)
X.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
X.Text = "X"
X.TextColor3 = Color3.new(1, 1, 1)
X.Parent = T
Instance.new("UICorner", X).CornerRadius = UDim.new(0, 4)

local N = Instance.new("TextButton")
N.Size = UDim2.new(0, 25, 0, 25)
N.Position = UDim2.new(1, -55, 0, 2)
N.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
N.Text = "-"
N.TextColor3 = Color3.new(1, 1, 1)
N.Parent = T
Instance.new("UICorner", N).CornerRadius = UDim.new(0, 4)

local F = Instance.new("Frame")
F.Size = UDim2.new(0, 120, 1, -30)
F.Position = UDim2.new(0, 0, 0, 30)
F.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
F.Parent = M
Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)

local Cn = Instance.new("Frame")
Cn.Size = UDim2.new(1, -120, 1, -30)
Cn.Position = UDim2.new(0, 120, 0, 30)
Cn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Cn.Parent = M

local Ts = Instance.new("ScrollingFrame")
Ts.Size = UDim2.new(1, 0, 1, 0)
Ts.BackgroundTransparency = 1
Ts.ScrollBarThickness = 2
Ts.Parent = F
Instance.new("UIListLayout", Ts).Padding = UDim.new(0, 5)

local Cs = Instance.new("ScrollingFrame")
Cs.Size = UDim2.new(1, -10, 1, -10)
Cs.Position = UDim2.new(0, 5, 0, 5)
Cs.BackgroundTransparency = 1
Cs.ScrollBarThickness = 3
Cs.Parent = Cn
Instance.new("UIListLayout", Cs).Padding = UDim.new(0, 8)

-- UI Functions
local function Ct(n)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 35)
    b.Position = UDim2.new(0, 5, 0, 0)
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    b.Text = n
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 12
    b.Font = Enum.Font.GothamSemibold
    b.Parent = Ts
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    
    local c = Instance.new("Frame")
    c.Size = UDim2.new(1, 0, 0, 0)
    c.BackgroundTransparency = 1
    c.Visible = false
    c.Parent = Cs
    Instance.new("UIListLayout", c).Padding = UDim.new(0, 8)
    
    return b, c
end

local function Tg(p, t, f, cb)
    local g = Instance.new("Frame")
    g.Size = UDim2.new(1, -10, 0, 35)
    g.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    g.Parent = p
    Instance.new("UICorner", g).CornerRadius = UDim.new(0, 4)
    
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -60, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = t
    l.TextColor3 = Color3.new(1, 1, 1)
    l.TextSize = 12
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = g
    
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 40, 0, 20)
    b.Position = UDim2.new(1, -50, 0.5, -10)
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    b.Text = ""
    b.Parent = g
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    
    local o = Instance.new("Frame")
    o.Size = UDim2.new(0, 16, 0, 16)
    o.Position = UDim2.new(0, 2, 0.5, -8)
    o.BackgroundColor3 = Color3.new(1, 1, 1)
    o.Parent = b
    Instance.new("UICorner", o).CornerRadius = UDim.new(1, 0)
    
    local e = false
    b.MouseButton1Click:Connect(function()
        e = not e
        C[f] = e
        if e then
            b.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            o.Position = UDim2.new(0, 22, 0.5, -8)
        else
            b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            o.Position = UDim2.new(0, 2, 0.5, -8)
        end
        if cb then cb(e) end
    end)
    
    return g
end

local function Bt(p, t, cba)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -10, 0, 35)
    f.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    f.Parent = p
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)
    
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 1, 0)
    b.BackgroundTransparency = 1
    b.Text = t
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 12
    b.Font = Enum.Font.GothamSemibold
    b.Parent = f
    
    b.MouseButton1Click:Connect(function()
        game:GetService("TweenService"):Create(f, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play()
        wait(0.1)
        game:GetService("TweenService"):Create(f, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        if cba then cba() end
    end)
    
    return f
end

-- Create Tabs
local M1, M2 = Ct("Main")
local F1, F2 = Ct("Farm")
local S1, S2 = Ct("Stats")
local T1, T2 = Ct("Teleport")
local E1, E2 = Ct("ESP")

local ct = M2
local function sw(b, c)
    ct.Visible = false
    ct = c
    ct.Visible = true
    for _, v in pairs(Ts:GetChildren()) do
        if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(45, 45, 45) end
    end
    b.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
end

M1.MouseButton1Click:Connect(function() sw(M1, M2) end)
F1.MouseButton1Click:Connect(function() sw(F1, F2) end)
S1.MouseButton1Click:Connect(function() sw(S1, S2) end)
T1.MouseButton1Click:Connect(function() sw(T1, T2) end)
E1.MouseButton1Click:Connect(function() sw(E1, E2) end)
M2.Visible = true
M1.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

-- MAIN TAB
Tg(M2, "Auto Random Fruit", "ARF")
spawn(function()
    while wait(1) do
        if C.ARF then
            pcall(function() R.Remotes.CommF_:InvokeServer("Cousin", "Buy") end)
        end
    end
end)

Tg(M2, "Auto Store Fruits", "ASF")
spawn(function()
    while wait(2) do
        if C.ASF then
            pcall(function()
                for _, t in pairs(p.Backpack:GetChildren()) do
                    if t:IsA("Tool") then
                        local fruits = {"Bomb", "Spike", "Chop", "Spring", "Smoke", "Flame", "Ice", "Sand", "Dark", "Light", "Magma", "Quake", "Human: Buddha", "String", "Bird: Falcon", "Phoenix", "Rumble", "Paw", "Gravity", "Dough", "Shadow", "Venom", "Control", "Soul", "Dragon", "Leopard", "Kitsune", "T-Rex", "Mammoth", "Spirit"}
                        for _, f in pairs(fruits) do
                            if t.Name:find(f) then
                                R.remotes.CommF_:InvokeServer("StoreFruit", t.Name, t)
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
end)

Tg(M2, "Auto Buy Abilities", "AQ")
spawn(function()
    while wait(5) do
        if C.AQ then
            pcall(function()
                for _, a in pairs({"Geppo", "Soru", "Tekkai", "Haki", "Kenbunshoku"}) do
                    R.Remotes.CommF_:InvokeServer("Buy" .. a)
                end
            end)
        end
    end
end)

Tg(M2, "Auto Haki", "AH")
spawn(function()
    while wait(3) do
        if C.AH then
            pcall(function() R.Remotes.CommF_:InvokeServer("Buso") end)
        end
    end
end)

-- FARM TAB (Sea Specific)
Tg(F2, "Auto Farm Level (Sea " .. CurrentSea .. ")", "AF", function(e)
    spawn(function()
        while C.AF do
            wait()
            pcall(function()
                local n = G(CurrentSea)
                if n and n:FindFirstChild("HumanoidRootPart") and n.Humanoid.Health > 0 then
                    hrp.CFrame = n.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                    A()
                end
            end)
        end
    end)
end)

Tg(F2, "Auto Farm Boss (Sea " .. CurrentSea .. ")", "AB", function(e)
    spawn(function()
        while C.AB do
            wait()
            pcall(function()
                local b = B(CurrentSea)
                if b and b:FindFirstChild("HumanoidRootPart") then
                    hrp.CFrame = b.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                    A()
                end
            end)
        end
    end)
end)

Tg(F2, "Auto Farm Mastery", "AM", function(e)
    spawn(function()
        while C.AM do
            wait()
            pcall(function()
                local n = G(CurrentSea)
                if n then
                    for _, t in pairs(p.Backpack:GetChildren()) do
                        if t:IsA("Tool") then
                            if C.SW == "Melee" and (t.Name:lower():find("melee") or t.Name:lower():find("combat")) then
                                h:EquipTool(t)
                                break
                            elseif C.SW == "Sword" and (t.Name:lower():find("sword") or t.Name:lower():find("blade")) then
                                h:EquipTool(t)
                                break
                            elseif C.SW == "Gun" and (t.Name:lower():find("gun") or t.Name:lower():find("pistol")) then
                                h:EquipTool(t)
                                break
                            elseif C.SW == "Fruit" and t.Name:lower():find("fruit") then
                                h:EquipTool(t)
                                break
                            end
                        end
                    end
                    if n:FindFirstChild("HumanoidRootPart") then
                        hrp.CFrame = n.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                        A()
                    end
                end
            end)
        end
    end)
end)

-- Weapon Selector
local Dd = Instance.new("TextButton")
Dd.Size = UDim2.new(1, -10, 0, 35)
Dd.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Dd.Text = "Weapon: Melee"
Dd.TextColor3 = Color3.new(1, 1, 1)
Dd.TextSize = 12
Dd.Font = Enum.Font.GothamSemibold
Dd.Parent = F2
Instance.new("UICorner", Dd).CornerRadius = UDim.new(0, 4)

local Dl = {"Melee", "Sword", "Gun", "Fruit"}
local Di = 1
Dd.MouseButton1Click:Connect(function()
    Di = Di % #Dl + 1
    C.SW = Dl[Di]
    Dd.Text = "Weapon: " .. C.SW
end)

Tg(F2, "Auto Sea Beast", "ASB", function(e)
    spawn(function()
        while C.ASB do
            wait()
            pcall(function()
                local s = S()
                if s and s:FindFirstChild("HumanoidRootPart") then
                    hrp.CFrame = s.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)
                    A()
                end
            end)
        end
    end)
end)

Tg(F2, "Auto Raid", "AR", function(e)
    spawn(function()
        while C.AR do
            wait(1)
            pcall(function()
                for _, v in pairs(W:GetDescendants()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                        if v.Name:lower():find("raid") or v.Name:lower():find("enemy") then
                            hrp.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                            A()
                        end
                    end
                end
            end)
        end
    end)
end)

-- STATS TAB
Tg(S2, "Auto Melee", "AMe")
spawn(function()
    while wait(0.5) do
        if C.AMe then
            pcall(function() R.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1) end)
        end
    end
end)

Tg(S2, "Auto Defense", "AD")
spawn(function()
    while wait(0.5) do
        if C.AD then
            pcall(function() R.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1) end)
        end
    end
end)

Tg(S2, "Auto Sword", "ASw")
spawn(function()
    while wait(0.5) do
        if C.ASw then
            pcall(function() R.Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1) end)
        end
    end
end)

Tg(S2, "Auto Gun", "AG")
spawn(function()
    while wait(0.5) do
        if C.AG then
            pcall(function() R.remotes.CommF_:InvokeServer("AddPoint", "Gun", 1) end)
        end
    end
end)

Tg(S2, "Auto Fruit", "AFr")
spawn(function()
    while wait(0.5) do
        if C.AFr then
            pcall(function() R.remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1) end)
        end
    end
end)

-- TELEPORT (Divided by Sea)
local function CreateSeaTabs(parent)
    local S1t, S1c = Ct("1st Sea")
    S1t.Parent = Ts
    S1c.Parent = Cs
    S1c.Visible = false
    
    local S2t, S2c = Ct("2nd Sea")
    S2t.Parent = Ts
    S2c.Parent = Cs
    S2c.Visible = false
    
    local S3t, S3c = Ct("3rd Sea")
    S3t.Parent = Ts
    S3c.Parent = Cs
    S3c.Visible = false
    
    S1t.MouseButton1Click:Connect(function() sw(S1t, S1c) end)
    S2t.MouseButton1Click:Connect(function() sw(S2t, S2c) end)
    S3t.MouseButton1Click:Connect(function() sw(S3t, S3c) end)
    
    -- 1st Sea
    local I1 = {
        ["Starter"] = CFrame.new(1057, 16, 1425),
        ["Marine Start"] = CFrame.new(-2573, 6, -2043),
        ["Middle Town"] = CFrame.new(-655, 8, -1102),
        ["Jungle"] = CFrame.new(-1612, 37, 148),
        ["Pirate Village"] = CFrame.new(-1181, 44, 79),
        ["Desert"] = CFrame.new(897, 7, 4389),
        ["Frozen Village"] = CFrame.new(1198, 27, -1217),
        ["Marine Fortress"] = CFrame.new(-4505, 20, 4265),
        ["Skylands"] = CFrame.new(-4968, 718, -2623),
        ["Prison"] = CFrame.new(4854, 5, 723),
        ["Colosseum"] = CFrame.new(-1427, 7, -3014),
        ["Magma Village"] = CFrame.new(-5248, 9, 8497),
        ["Underwater City"] = CFrame.new(61123, 18, 1569),
        ["Fountain City"] = CFrame.new(6127, 5, 1833)
    }
    for n, cf in pairs(I1) do
        Bt(S1c, "TP to " .. n, function()
            pcall(function() hrp.CFrame = cf end)
        end)
    end
    
    -- 2nd Sea
    local I2 = {
        ["Cafe"] = CFrame.new(-380, 73, 304),
        ["Kingdom of Rose"] = CFrame.new(-388, 73, 326),
        ["Green Zone"] = CFrame.new(-2372, 73, -316),
        ["Graveyard"] = CFrame.new(-5612, 9, 719),
        ["Dark Arena"] = CFrame.new(3780, 14, -3594),
        ["Snow Mountain"] = CFrame.new(561, 401, -5317),
        ["Hot and Cold"] = CFrame.new(-6058, 16, -1534),
        ["Cursed Ship"] = CFrame.new(923, 125, 32818),
        ["Ice Castle"] = CFrame.new(5400, 15, -6026),
        ["Forgotten Island"] = CFrame.new(-3041, 238, -10159),
        ["Usoapp's Island"] = CFrame.new(5745, 9, -481)
    }
    for n, cf in pairs(I2) do
        Bt(S2c, "TP to " .. n, function()
            pcall(function() hrp.CFrame = cf end)
        end)
    end
    
    -- 3rd Sea
    local I3 = {
        ["Mansion"] = CFrame.new(-390, 332, 565),
        ["Hydra Island"] = CFrame.new(5200, 10, 1500),
        ["Great Tree"] = CFrame.new(2200, 30, -6500),
        ["Castle on the Sea"] = CFrame.new(-5000, 50, -3000),
        ["Floating Turtle"] = CFrame.new(-11000, 30, -17000),
        ["Sea of Treats"] = CFrame.new(200, 50, -12000),
        ["Port Town"] = CFrame.new(-200, 50, 4700),
        ["Chocolate Land"] = CFrame.new(200, 50, 12500)
    }
    for n, cf in pairs(I3) do
        Bt(S3c, "TP to " .. n, function()
            pcall(function() hrp.CFrame = cf end)
        end)
    end
end
CreateSeaTabs(T2)

-- ESP TAB
Tg(E2, "Fruit ESP", "FE", function(e)
    spawn(function()
        while C.FE do
            wait(1)
            pcall(function()
                for _, v in pairs(W:GetChildren()) do
                    if v.Name:find("Fruit") and v:FindFirstChild("Handle") then
                        if not v.Handle:FindFirstChild("E") then
                            local b = Instance.new("BillboardGui")
                            b.Name = "E"
                            b.AlwaysOnTop = true
                            b.Size = UDim2.new(0, 200, 0, 50)
                            b.Adornee = v.Handle
                            b.MaxDistance = 999999
                            local t = Instance.new("TextLabel")
                            t.Size = UDim2.new(1, 0, 1, 0)
                            t.BackgroundTransparency = 1
                            t.Text = "🍎 " .. v.Name
                            t.TextColor3 = Color3.fromRGB(255, 0, 0)
                            t.TextSize = 20
                            t.TextStrokeTransparency = 0
                            t.Parent = b
                            b.Parent = v.Handle
                        end
                    end
                end
            end)
        end
        if not e then
            for _, v in pairs(W:GetDescendants()) do
                if v.Name == "E" then v:Destroy() end
            end
        end
    end)
end)

Tg(E2, "Chest ESP", "CE", function(e)
    spawn(function()
        while C.CE do
            wait(1)
            pcall(function()
                for _, v in pairs(W:GetChildren()) do
                    if v.Name:find("Chest") then
                        if not v:FindFirstChild("E") then
                            local b = Instance.new("BillboardGui")
                            b.Name = "E"
                            b.AlwaysOnTop = true
                            b.Size = UDim2.new(0, 100, 0, 50)
                            b.Adornee = v
                            b.MaxDistance = 999999
                            local t = Instance.new("TextLabel")
                            t.Size = UDim2.new(1, 0, 1, 0)
                            t.BackgroundTransparency = 1
                            t.Text = "📦 Chest"
                            t.TextColor3 = Color3.fromRGB(255, 255, 0)
                            t.TextSize = 18
                            t.TextStrokeTransparency = 0
                            t.Parent = b
                            b.Parent = v
                        end
                    end
                end
            end)
        end
        if not e then
            for _, v in pairs(W:GetDescendants()) do
                if v.Name == "E" then v:Destroy() end
            end
        end
    end)
end)

-- UI Controls
local d = false
local di
local sp

T.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        d = true
        di = i.Position
        sp = M.Position
    end
end)

T.InputChanged:Connect(function(i)
    if d and i.UserInputType == Enum.UserInputType.MouseMovement then
        local de = i.Position - di
        M.Position = UDim2.new(sp.X.Scale, sp.X.Offset + de.X, sp.Y.Scale, sp.Y.Offset + de.Y)
    end
end)

T.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        d = false
    end
end)

local m = false
N.MouseButton1Click:Connect(function()
    m = not m
    if m then
        Cn.Visible = false
        F.Visible = false
        M.Size = UDim2.new(0, 550, 0, 30)
        N.Text = "+"
    else
        Cn.Visible = true
        F.Visible = true
        M.Size = UDim2.new(0, 550, 0, 350)
        N.Text = "-"
    end
end)

X.MouseButton1Click:Connect(function()
    Sg:Destroy()
end)

-- Character Handler
p.CharacterAdded:Connect(function(n)
    c = n
    h = n:WaitForChild("Humanoid")
    hrp = n:WaitForChild("HumanoidRootPart")
    CurrentSea = GetSea()
    L.Text = "Vietnamese Hub | Sea " .. CurrentSea
end)

-- Notification
game.StarterGui:SetCore("SendNotification", {
    Title = "Vietnamese Hub",
    Text = "Sea " .. CurrentSea .. " Loaded Successfully!",
    Duration = 3
})

print("Vietnamese Hub Loaded!")