-- Vietnamese Hub
-- Original Script - Vietnam Flag Theme
-- https://github.com/mineparkourclub/Vietnamese-hub

local function LoadHub()
    if not game:IsLoaded() then game.Loaded:Wait() end
    
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local VirtualUser = game:GetService("VirtualUser")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local HttpService = game:GetService("HttpService")
    
    local Player = Players.LocalPlayer
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Vietnam Flag Colors
    local VN_RED = Color3.fromRGB(218, 37, 29)
    local VN_YELLOW = Color3.fromRGB(255, 222, 0)
    local DARK_BG = Color3.fromRGB(20, 20, 20)
    local PANEL_BG = Color3.fromRGB(30, 30, 30)
    local BUTTON_BG = Color3.fromRGB(40, 40, 40)
    
    -- Detect Sea
    local function GetSea()
        local pos = HumanoidRootPart.Position
        if pos.Z > -2000 and pos.Z < 2000 and pos.X > -4000 and pos.X < 4000 then return 1 end
        if pos.Z > 50000 or pos.Z < -50000 then return 3 end
        return 2
    end
    
    local CurrentSea = GetSea()
    
    -- Config
    local Config = {
        AutoFarm = false,
        AutoBoss = false,
        AutoMastery = false,
        AutoSeaBeast = false,
        AutoRaid = false,
        AutoFruit = false,
        AutoStats = {Melee = false, Defense = false, Sword = false, Gun = false, Fruit = false},
        Weapon = "Melee",
        SelectedStats = "Melee"
    }
    
    -- Get Enemy
    function GetEnemy(sea)
        local nearest, dist = nil, math.huge
        for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
                local valid = false
                if sea == 1 then
                    valid = table.find({"Bandit","Monkey","Gorilla","Pirate","Brute","Desert Bandit","Desert Officer","Snow Bandit","Snowman","Chief Petty Officer","Vice Admiral"}, enemy.Name)
                elseif sea == 2 then
                    valid = table.find({"Raider","Mercenary","Swan Pirate","Factory Staff","Marine Lieutenant","Marine Captain","Zombie","Vampire","Snow Trooper","Winter Warrior"}, enemy.Name)
                else
                    valid = table.find({"Pirate Millionaire","Dragon Crew Warrior","Dragon Crew Archer","Ghoul","Reformed Revolutionary","Cocoa Warrior","Chocolate Bar Battler","Sweet Thief"}, enemy.Name)
                end
                
                if valid then
                    local d = (HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d nearest = enemy end
                end
            end
        end
        return nearest
    end
    
    -- Get Boss
    function GetBoss(sea)
        local bosses = sea == 1 and {"The Gorilla King","Bobby","Yeti","Mob Leader","Vice Admiral","Warden","Chief Warden","Swan","Magma Admiral","Fishman Lord","Wysper","Thunder God","Cyborg","Saber Expert","Darkbeard","Ice Admiral"}
            or sea == 2 and {"Diamond","Jeremy","Fajita","Don Swan","Smoke Admiral","Awakened Ice Admiral","Tide Keeper","Cursed Captain"}
            or {"Cake Queen","Kilo Admiral","Captain Elephant","Beautiful Pirate","Longma","Soul Reaper","rip_indra"}
        
        for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
            for _, bossName in pairs(bosses) do
                if enemy.Name == bossName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    return enemy
                end
            end
        end
        return nil
    end
    
    -- Get Sea Beast
    function GetSeaBeast()
        for _, v in pairs(Workspace:GetChildren()) do
            if v.Name:lower():find("seabeast") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                return v
            end
        end
        return nil
    end
    
    -- Auto Click
    function AutoClick()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:Button1Down(Vector2.new(1280, 672))
            wait(0.05)
            VirtualUser:Button1Up(Vector2.new(1280, 672))
        end)
    end
    
    -- UI LIBRARY (Redz-style)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VietnameseHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = DARK_BG
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    TitleBar.BackgroundColor3 = VN_RED
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar
    
    -- Vietnam Star Icon
    local IconFrame = Instance.new("Frame")
    IconFrame.Size = UDim2.new(0, 30, 0, 30)
    IconFrame.Position = UDim2.new(0, 10, 0, 7)
    IconFrame.BackgroundColor3 = VN_YELLOW
    IconFrame.Parent = TitleBar
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(1, 0)
    IconCorner.Parent = IconFrame
    
    -- Star shape using text
    local StarLabel = Instance.new("TextLabel")
    StarLabel.Size = UDim2.new(1, 0, 1, 0)
    StarLabel.BackgroundTransparency = 1
    StarLabel.Text = "★"
    StarLabel.TextColor3 = VN_RED
    StarLabel.TextSize = 20
    StarLabel.Font = Enum.Font.GothamBold
    StarLabel.Parent = IconFrame
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -150, 1, 0)
    Title.Position = UDim2.new(0, 50, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "VIETNAMESE HUB"
    Title.TextColor3 = VN_YELLOW
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    -- Sea Indicator
    local SeaLabel = Instance.new("TextLabel")
    SeaLabel.Size = UDim2.new(0, 80, 0, 25)
    SeaLabel.Position = UDim2.new(1, -180, 0, 10)
    SeaLabel.BackgroundColor3 = DARK_BG
    SeaLabel.Text = "Sea " .. CurrentSea
    SeaLabel.TextColor3 = VN_YELLOW
    SeaLabel.TextSize = 12
    SeaLabel.Font = Enum.Font.GothamBold
    SeaLabel.Parent = TitleBar
    
    local SeaCorner = Instance.new("UICorner")
    SeaCorner.CornerRadius = UDim.new(0, 4)
    SeaCorner.Parent = SeaLabel
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 7)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.TextSize = 14
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn
    
    -- Minimize Button
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -70, 0, 7)
    MinBtn.BackgroundColor3 = BUTTON_BG
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Color3.new(1, 1, 1)
    MinBtn.TextSize = 18
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Parent = TitleBar
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinBtn
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, -45)
    Sidebar.Position = UDim2.new(0, 0, 0, 45)
    Sidebar.BackgroundColor3 = PANEL_BG
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    local SideCorner = Instance.new("UICorner")
    SideCorner.CornerRadius = UDim.new(0, 0)
    SideCorner.Parent = Sidebar
    
    -- Tab Buttons Container
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 2
    TabContainer.Parent = Sidebar
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = TabContainer
    
    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "Content"
    ContentArea.Size = UDim2.new(1, -150, 1, -45)
    ContentArea.Position = UDim2.new(0, 150, 0, 45)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame
    
    -- Tab System
    local Tabs = {}
    local CurrentTab = nil
    
    local function CreateTab(name, icon)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, -10, 0, 40)
        TabBtn.Position = UDim2.new(0, 5, 0, 0)
        TabBtn.BackgroundColor3 = BUTTON_BG
        TabBtn.Text = "  " .. icon .. "  " .. name
        TabBtn.TextColor3 = Color3.new(1, 1, 1)
        TabBtn.TextSize = 13
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Parent = TabContainer
        
        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabBtn
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, -10, 1, -10)
        TabContent.Position = UDim2.new(0, 5, 0, 5)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 3
        TabContent.Visible = false
        TabContent.Parent = ContentArea
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.Parent = TabContent
        
        table.insert(Tabs, {Button = TabBtn, Content = TabContent, Name = name})
        
        return TabContent
    end
    
    local function SwitchTab(tabName)
        for _, tab in pairs(Tabs) do
            if tab.Name == tabName then
                tab.Content.Visible = true
                tab.Button.BackgroundColor3 = VN_RED
                TweenService:Create(tab.Button, TweenInfo.new(0.2), {BackgroundColor3 = VN_RED}):Play()
                CurrentTab = tab
            else
                tab.Content.Visible = false
                tab.Button.BackgroundColor3 = BUTTON_BG
            end
        end
    end
    
    -- Create Toggle Function
    local function CreateToggle(parent, text, configKey, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 45)
        ToggleFrame.BackgroundColor3 = PANEL_BG
        ToggleFrame.Parent = parent
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 6)
        ToggleCorner.Parent = ToggleFrame
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -70, 1, 0)
        Label.Position = UDim2.new(0, 15, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.new(1, 1, 1)
        Label.TextSize = 13
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame
        
        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Size = UDim2.new(0, 50, 0, 26)
        ToggleBtn.Position = UDim2.new(1, -60, 0.5, -13)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        ToggleBtn.Text = ""
        ToggleBtn.Parent = ToggleFrame
        
        local ToggleBtnCorner = Instance.new("UICorner")
        ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
        ToggleBtnCorner.Parent = ToggleBtn
        
        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(0, 20, 0, 20)
        Circle.Position = UDim2.new(0, 3, 0.5, -10)
        Circle.BackgroundColor3 = Color3.new(1, 1, 1)
        Circle.Parent = ToggleBtn
        
        local CircleCorner = Instance.new("UICorner")
        CircleCorner.CornerRadius = UDim.new(1, 0)
        CircleCorner.Parent = Circle
        
        local enabled = false
        
        ToggleBtn.MouseButton1Click:Connect(function()
            enabled = not enabled
            Config[configKey] = enabled
            
            if enabled then
                TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = VN_RED}):Play()
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 27, 0.5, -10)}):Play()
            else
                TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -10)}):Play()
            end
            
            if callback then callback(enabled) end
        end)
        
        return ToggleFrame
    end
    
    -- Create Button Function
    local function CreateButton(parent, text, callback)
        local BtnFrame = Instance.new("Frame")
        BtnFrame.Size = UDim2.new(1, 0, 0, 40)
        BtnFrame.BackgroundColor3 = PANEL_BG
        BtnFrame.Parent = parent
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = BtnFrame
        
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 1, 0)
        Button.BackgroundTransparency = 1
        Button.Text = text
        Button.TextColor3 = Color3.new(1, 1, 1)
        Button.TextSize = 13
        Button.Font = Enum.Font.GothamSemibold
        Button.Parent = BtnFrame
        
        Button.MouseButton1Click:Connect(function()
            TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = VN_RED}):Play()
            wait(0.1)
            TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = PANEL_BG}):Play()
            if callback then callback() end
        end)
        
        return BtnFrame
    end
    
    -- Create Dropdown Function
    local function CreateDropdown(parent, text, options, callback)
        local DropFrame = Instance.new("Frame")
        DropFrame.Size = UDim2.new(1, 0, 0, 40)
        DropFrame.BackgroundColor3 = PANEL_BG
        DropFrame.Parent = parent
        
        local DropCorner = Instance.new("UICorner")
        DropCorner.CornerRadius = UDim.new(0, 6)
        DropCorner.Parent = DropFrame
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.5, 0, 1, 0)
        Label.Position = UDim2.new(0, 15, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.new(1, 1, 1)
        Label.TextSize = 13
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = DropFrame
        
        local DropBtn = Instance.new("TextButton")
        DropBtn.Size = UDim2.new(0, 120, 0, 30)
        DropBtn.Position = UDim2.new(1, -130, 0.5, -15)
        DropBtn.BackgroundColor3 = BUTTON_BG
        DropBtn.Text = options[1]
        DropBtn.TextColor3 = Color3.new(1, 1, 1)
        DropBtn.TextSize = 12
        DropBtn.Font = Enum.Font.Gotham
        DropBtn.Parent = DropFrame
        
        local DropBtnCorner = Instance.new("UICorner")
        DropBtnCorner.CornerRadius = UDim.new(0, 4)
        DropBtnCorner.Parent = DropBtn
        
        local index = 1
        DropBtn.MouseButton1Click:Connect(function()
            index = index % #options + 1
            DropBtn.Text = options[index]
            if callback then callback(options[index]) end
        end)
        
        return DropFrame
    end
    
    -- TABS
    local MainTab = CreateTab("Main", "🏠")
    local FarmTab = CreateTab("Farm", "⚔️")
    local StatsTab = CreateTab("Stats", "📊")
    local TeleportTab = CreateTab("Teleport", "🌐")
    local MiscTab = CreateTab("Misc", "⚙️")
    
    -- Connect Tab Buttons
    for _, tab in pairs(Tabs) do
        tab.Button.MouseButton1Click:Connect(function()
            SwitchTab(tab.Name)
        end)
    end
    
    -- MAIN TAB
    CreateToggle(MainTab, "Auto Random Fruit", "AutoFruit")
    CreateToggle(MainTab, "Auto Store Fruits", "AutoStore")
    CreateToggle(MainTab, "Auto Buy Abilities", "AutoAbilities")
    CreateToggle(MainTab, "Auto Buso (Haki)", "AutoHaki")
    CreateButton(MainTab, "Redeem All Codes", function()
        local codes = {"EXP_5B","RESET_5B","ADMIN_TROLL","ADMIN_STRENGTH","JULYUPDATE_RESET","NOOB2PRO","CODESLIDE","15B_BESTBROTHERS","NOOB2ADMIN","REWARDFUN","CHICKEN","THEGREATACE","DRAGONABUSE","SECRET_ADMIN","STRAWHAT_MAIN","RANDOM_DF","BARRIER","SHUTDOWN_FIX","GAMEMODE","GAMEMODE1","SERVER_FIX","UPDATE11","XMASEXP","1BILLION","UPD16","UPD15","2BILLION","3BILLION","UPD14","UPD13","DEVSCOOKING","ENYU_IS_PRO","Magicbus","Sub2Fer999","Starcodeheo","Sub2NoobMaster123","Sub2Daigrock","Axiore","TantaiGaming","StrawHatMain","Sub2OfficialNoobie","TheGreatAce","Fudd10","Fudd10_V2","BIGNEWS","Update10","Sub2UncleKizaru","YOUTUBE_CLOSED","ZIOLES_CARRY","Bignews","TantaiGaming","STRAWHAT_MAIN","JCWK","Fudd10","1MLIKES_RESET","THIRDSEA","2BILLION","UPD14","UPD13","DEVSCOOKING","Axiore","Magicbus","JCWK","Starcodeheo","Bluxxy","Enyu_is_Pro","Sub2Fer999","GAMERROBOT_EXP1","GAMERROBOT_EXP","TY_FOR_WATCHING","EXP_5B","RESET_5B","kittgaming","Sub2CaptainMaui","DEVSCOOKING","HYPE_IS_BACK","NOOB_SET_UP"}
        for _, code in pairs(codes) do
            pcall(function()
                ReplicatedStorage.Remotes.Redeem:InvokeServer(code)
            end)
            wait(0.1)
        end
    end)
    
    -- FARM TAB
    CreateToggle(FarmTab, "Auto Farm Level", "AutoFarm", function(e)
        spawn(function()
            while Config.AutoFarm do
                wait()
                pcall(function()
                    local enemy = GetEnemy(CurrentSea)
                    if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                        HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                        AutoClick()
                    end
                end)
            end
        end)
    end)
    
    CreateToggle(FarmTab, "Auto Farm Boss", "AutoBoss", function(e)
        spawn(function()
            while Config.AutoBoss do
                wait()
                pcall(function()
                    local boss = GetBoss(CurrentSea)
                    if boss and boss:FindFirstChild("HumanoidRootPart") then
                        HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                        AutoClick()
                    end
                end)
            end
        end)
    end)
    
    CreateToggle(FarmTab, "Auto Farm Mastery", "AutoMastery", function(e)
        spawn(function()
            while Config.AutoMastery do
                wait()
                pcall(function()
                    local enemy = GetEnemy(CurrentSea)
                    if enemy then
                        for _, tool in pairs(Player.Backpack:GetChildren()) do
                            if tool:IsA("Tool") then
                                if Config.Weapon == "Melee" and (tool.Name:lower():find("melee") or tool.Name:lower():find("combat") or tool.Name:lower():find("dark")) then
                                    Humanoid:EquipTool(tool)
                                elseif Config.Weapon == "Sword" and (tool.Name:lower():find("sword") or tool.Name:lower():find("blade")) then
                                    Humanoid:EquipTool(tool)
                                elseif Config.Weapon == "Gun" and (tool.Name:lower():find("gun") or tool.Name:lower():find("pistol") or tool.Name:lower():find("rifle")) then
                                    Humanoid:EquipTool(tool)
                                elseif Config.Weapon == "Fruit" and tool.Name:lower():find("fruit") then
                                    Humanoid:EquipTool(tool)
                                end
                            end
                        end
                        if enemy:FindFirstChild("HumanoidRootPart") then
                            HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                            AutoClick()
                        end
                    end
                end)
            end
        end)
    end)
    
    CreateDropdown(FarmTab, "Select Weapon", {"Melee", "Sword", "Gun", "Fruit"}, function(opt)
        Config.Weapon = opt
    end)
    
    CreateToggle(FarmTab, "Auto Sea Beast", "AutoSeaBeast", function(e)
        spawn(function()
            while Config.AutoSeaBeast do
                wait()
                pcall(function()
                    local beast = GetSeaBeast()
                    if beast and beast:FindFirstChild("HumanoidRootPart") then
                        HumanoidRootPart.CFrame = beast.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)
                        AutoClick()
                    end
                end)
            end
        end)
    end)
    
    CreateToggle(FarmTab, "Auto Raid", "AutoRaid", function(e)
        spawn(function()
            while Config.AutoRaid do
                wait(1)
                pcall(function()
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                            if v.Name:lower():find("raid") or v.Name:lower():find("enemy") then
                                HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                                AutoClick()
                            end
                        end
                    end
                end)
            end
        end)
    end)
    
    -- STATS TAB
    CreateToggle(StatsTab, "Auto Melee", "MeleeStats", function(e)
        spawn(function()
            while Config.AutoStats.Melee do
                wait(0.5)
                pcall(function()
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
                end)
            end
        end)
    end)
    
    CreateToggle(StatsTab, "Auto Defense", "DefenseStats", function(e)
        spawn(function()
            while Config.AutoStats.Defense do
                wait(0.5)
                pcall(function()
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
                end)
            end
        end)
    end)
    
    CreateToggle(StatsTab, "Auto Sword", "SwordStats", function(e)
        spawn(function()
            while Config.AutoStats.Sword do
                wait(0.5)
                pcall(function()
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1)
                end)
            end
        end)
    end)
    
    CreateToggle(StatsTab, "Auto Gun", "GunStats", function(e)
        spawn(function()
            while Config.AutoStats.Gun do
                wait(0.5)
                pcall(function()
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Gun", 1)
                end)
            end
        end)
    end)
    
    CreateToggle(StatsTab, "Auto Fruit", "FruitStats", function(e)
        spawn(function()
            while Config.AutoStats.Fruit do
                wait(0.5)
                pcall(function()
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1)
                end)
            end
        end)
    end)
    
    -- TELEPORT TAB LOCATIONS
    local Locations = {
        ["First Sea"] = {
            ["Starter Island"] = CFrame.new(1057, 16, 1425),
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
        },
        ["Second Sea"] = {
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
        },
        ["Third Sea"] = {
            ["Mansion"] = CFrame.new(-390, 332, 565),
            ["Hydra Island"] = CFrame.new(5200, 10, 1500),
            ["Great Tree"] = CFrame.new(2200, 30, -6500),
            ["Castle on the Sea"] = CFrame.new(-5000, 50, -3000),
            ["Floating Turtle"] = CFrame.new(-11000, 30, -17000),
            ["Sea of Treats"] = CFrame.new(200, 50, -12000),
            ["Port Town"] = CFrame.new(-200, 50, 4700),
            ["Chocolate Land"] = CFrame.new(200, 50, 12500)
        }
    }
    
    for seaName, places in pairs(Locations) do
        local SeaLabel = Instance.new("TextLabel")
        SeaLabel.Size = UDim2.new(1, 0, 0, 25)
        SeaLabel.BackgroundTransparency = 1
        SeaLabel.Text = "━━━ " .. seaName .. " ━━━"
        SeaLabel.TextColor3 = VN_YELLOW
        SeaLabel.TextSize = 14
        SeaLabel.Font = Enum.Font.GothamBold
        SeaLabel.Parent = TeleportTab
        
        for placeName, cf in pairs(places) do
            CreateButton(TeleportTab, "TP to " .. placeName, function()
                pcall(function()
                    HumanoidRootPart.CFrame = cf
                end)
            end)
        end
    end
    
    -- MISC TAB
    CreateToggle(MiscTab, "Fruit ESP", "FruitESP", function(e)
        spawn(function()
            while Config.FruitESP do
                wait(1)
                pcall(function()
                    for _, v in pairs(Workspace:GetChildren()) do
                        if v.Name:find("Fruit") and v:FindFirstChild("Handle") then
                            if not v.Handle:FindFirstChild("ESPGUI") then
                                local b = Instance.new("BillboardGui")
                                b.Name = "ESPGUI"
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
        end)
    end)
    
    CreateToggle(MiscTab, "Chest ESP", "ChestESP", function(e)
        spawn(function()
            while Config.ChestESP do
                wait(1)
                pcall(function()
                    for _, v in pairs(Workspace:GetChildren()) do
                        if v.Name:find("Chest") then
                            if not v:FindFirstChild("ESPGUI") then
                                local b = Instance.new("BillboardGui")
                                b.Name = "ESPGUI"
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
        end)
    end)
    
    CreateButton(MiscTab, "Delete ESP", function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name == "ESPGUI" then
                v:Destroy()
            end
        end
    end)
    
    CreateButton(MiscTab, "Rejoin Server", function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
    end)
    
    CreateButton(MiscTab, "Server Hop", function()
        local Http = game:GetService("HttpService")
        local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local Data = Http:JSONDecode(game:HttpGet(Api))
        for _, v in pairs(Data.data) do
            if v.playing < v.maxPlayers then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id, Player)
                break
            end
        end
    end)
    
    -- UI Controls
    local dragging = false
    local dragStart
    local startPos
    
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
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Minimize
    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            ContentArea.Visible = false
            Sidebar.Visible = false
            MainFrame.Size = UDim2.new(0, 600, 0, 45)
            MinBtn.Text = "+"
        else
            ContentArea.Visible = true
            Sidebar.Visible = true
            MainFrame.Size = UDim2.new(0, 600, 0, 400)
            MinBtn.Text = "-"
        end
    end)
    
    -- Close
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Character Handler
    Player.CharacterAdded:Connect(function(newChar)
        Character = newChar
        Humanoid = newChar:WaitForChild("Humanoid")
        HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
        CurrentSea = GetSea()
        SeaLabel.Text = "Sea " .. CurrentSea
    end)
    
    -- Start with Main tab
    SwitchTab("Main")
    
    -- Notification
    game.StarterGui:SetCore("SendNotification", {
        Title = "🇻🇳 Vietnamese Hub",
        Text = "Sea " .. CurrentSea .. " Loaded! Made with ❤️",
        Duration = 5
    })
    
    print("🇻🇳 Vietnamese Hub Loaded Successfully!")
end

-- Execute
LoadHub()
