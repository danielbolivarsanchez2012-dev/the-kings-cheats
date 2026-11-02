-- [[ The King cheat - [FPS] Pro Full + Player Hacks + Armas + Teleport + Head Expander ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==========================================
-- CONFIG
-- ==========================================
local Config = {
    -- Aimbot / ESP
    Aimbot = false,
    WallCheck = true,
    FOV = true,
    FOVRadius = 120,
    TeamCheck = true,
    FreeForAll = false,
    MaxDistance = 500,
    
    HeadExpander = false,
    HeadSizeValue = 4,
    
    ESPBox = false,
    ESPCorner = false,
    ESPSkeleton = false,
    ESPLine = false,
    ESPHealth = false,
    ESPName = false,
    
    VisibleColor = Color3.fromRGB(0, 255, 0),
    HiddenColor = Color3.fromRGB(255, 0, 0),
    
    -- Player Hacks
    Fly = false,
    Noclip = false,
    Speed = false,
    SpeedValue = 50,
    SuperJump = false,
    JumpPower = 100,
    
    -- Armas
    NoRecoil = false,
    InfiniteAmmo = false,
    RapidFire = false,
    
    -- Teleport
    TeleportForward = false,
    TeleportDistance = 12
}

local Keybinds = {
    Aimbot = nil,
    WallCheck = nil,
    FOV = nil,
    TeamCheck = nil,
    FreeForAll = nil,
    HeadExpander = nil,
    ESPBox = nil,
    ESPCorner = nil,
    ESPSkeleton = nil,
    ESPLine = nil,
    ESPHealth = nil,
    ESPName = nil,
    Menu = Enum.KeyCode.Insert,
    
    -- Player
    Fly = nil,
    Noclip = nil,
    Speed = nil,
    SuperJump = nil,
    
    -- Armas
    NoRecoil = nil,
    InfiniteAmmo = nil,
    RapidFire = nil,
    
    -- Teleport
    TeleportForward = nil
}

local WaitingForKeybind = nil
local MenuVisible = true

-- Destruir GUI anterior
if CoreGui:FindFirstChild("TheKingCheatGUI") then
    CoreGui.TheKingCheatGUI:Destroy()
end

-- ==========================================
-- FOV CIRCLE
-- ==========================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Filled = false
FOVCircle.Thickness = 1.5
FOVCircle.Radius = Config.FOVRadius

-- ==========================================
-- GUI
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TheKingCheatGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 560, 0, 520)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- TopBar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

local FixBar = Instance.new("Frame")
FixBar.Size = UDim2.new(1, 0, 0, 10)
FixBar.Position = UDim2.new(0, 0, 1, -10)
FixBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
FixBar.BorderSizePixel = 0
FixBar.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "The King Cheats"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

local ControlsFrame = Instance.new("Frame")
ControlsFrame.Size = UDim2.new(0, 70, 1, 0)
ControlsFrame.Position = UDim2.new(1, -75, 0, 0)
ControlsFrame.BackgroundTransparency = 1
ControlsFrame.Parent = TopBar

local UIListLayoutControls = Instance.new("UIListLayout")
UIListLayoutControls.FillDirection = Enum.FillDirection.Horizontal
UIListLayoutControls.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIListLayoutControls.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayoutControls.Padding = UDim.new(0, 6)
UIListLayoutControls.Parent = ControlsFrame

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 16
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.Parent = ControlsFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = ControlsFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Tabs
local TabButtonsFrame = Instance.new("Frame")
TabButtonsFrame.Size = UDim2.new(1, -20, 0, 35)
TabButtonsFrame.Position = UDim2.new(0, 10, 0, 50)
TabButtonsFrame.BackgroundTransparency = 1
TabButtonsFrame.Parent = MainFrame

local UIListLayoutTabs = Instance.new("UIListLayout")
UIListLayoutTabs.FillDirection = Enum.FillDirection.Horizontal
UIListLayoutTabs.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutTabs.Padding = UDim.new(0, 6)
UIListLayoutTabs.Parent = TabButtonsFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -110)
ContentFrame.Position = UDim2.new(0, 10, 0, 95)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local function createTabContent(name)
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Name = name .. "Content"
    scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.Visible = false
    scrollingFrame.ScrollBarThickness = 4
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollingFrame.Parent = ContentFrame
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = scrollingFrame
    return scrollingFrame
end

local ESPTab = createTabContent("ESP")
local AimbotTab = createTabContent("Aimbot")
local JugadorTab = createTabContent("Jugador")
local ArmasTab = createTabContent("Armas")
local TeleportTab = createTabContent("Teleport")
local MiscTab = createTabContent("Misc")
ESPTab.Visible = true

local function createTabButton(name, targetTab)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 85, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamSemibold
    btn.AutoButtonColor = false
    btn.Parent = TabButtonsFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, child in pairs(ContentFrame:GetChildren()) do
            if child:IsA("ScrollingFrame") then child.Visible = false end
        end
        targetTab.Visible = true
        
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 215, 0), TextColor3 = Color3.fromRGB(0, 0, 0)}):Play()
        for _, otherBtn in pairs(TabButtonsFrame:GetChildren()) do
            if otherBtn:IsA("TextButton") and otherBtn ~= btn then
                TweenService:Create(otherBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            end
        end
    end)
    return btn
end

local btnESP = createTabButton("ESP", ESPTab)
btnESP.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
btnESP.TextColor3 = Color3.fromRGB(0, 0, 0)
createTabButton("Aimbot", AimbotTab)
createTabButton("Jugador", JugadorTab)
createTabButton("Armas", ArmasTab)
createTabButton("Teleport", TeleportTab)
createTabButton("Misc", MiscTab)

-- ==========================================
-- TOGGLE + KEYBIND
-- ==========================================
local function createToggleWithKeybind(parent, text, configKey, defaultState, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 42)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    toggleFrame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -110, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = toggleFrame
    
    local keybindBox = Instance.new("TextButton")
    keybindBox.Size = UDim2.new(0, 48, 0, 24)
    keybindBox.Position = UDim2.new(1, -100, 0.5, -12)
    keybindBox.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    keybindBox.Text = "None"
    keybindBox.TextColor3 = Color3.fromRGB(180, 180, 180)
    keybindBox.TextSize = 11
    keybindBox.Font = Enum.Font.GothamSemibold
    keybindBox.AutoButtonColor = false
    keybindBox.Parent = toggleFrame
    
    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 6)
    keyCorner.Parent = keybindBox
    
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 40, 0, 20)
    switch.Position = UDim2.new(1, -48, 0.5, -10)
    switch.BackgroundColor3 = defaultState and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(60, 60, 75)
    switch.Text = ""
    switch.AutoButtonColor = false
    switch.Parent = toggleFrame
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switch
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = defaultState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    circle.BackgroundColor3 = defaultState and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    circle.Parent = switch
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle
    
    local enabled = defaultState
    
    local function updateVisual(state)
        local goalSwitchColor = state and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(60, 60, 75)
        local goalCirclePos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local goalCircleColor = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        
        TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = goalSwitchColor}):Play()
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = goalCirclePos, BackgroundColor3 = goalCircleColor}):Play()
    end
    
    switch.MouseButton1Click:Connect(function()
        enabled = not enabled
        callback(enabled)
        updateVisual(enabled)
    end)
    
    keybindBox.MouseButton1Click:Connect(function()
        if WaitingForKeybind then return end
        WaitingForKeybind = configKey
        keybindBox.Text = "..."
        keybindBox.TextColor3 = Color3.fromRGB(255, 215, 0)
        keybindBox.BackgroundColor3 = Color3.fromRGB(60, 50, 30)
    end)
    
    return {
        keybindBox = keybindBox,
        setEnabled = function(state)
            enabled = state
            callback(state)
            updateVisual(state)
        end,
        getEnabled = function() return enabled end
    }
end

local toggles = {}

-- ESP Tab
toggles.ESPBox = createToggleWithKeybind(ESPTab, "ESP Box (Cuadro)", "ESPBox", false, function(state) Config.ESPBox = state end)
toggles.ESPCorner = createToggleWithKeybind(ESPTab, "ESP Corner Box", "ESPCorner", false, function(state) Config.ESPCorner = state end)
toggles.ESPSkeleton = createToggleWithKeybind(ESPTab, "ESP Skeleton", "ESPSkeleton", false, function(state) Config.ESPSkeleton = state end)
toggles.ESPLine = createToggleWithKeybind(ESPTab, "ESP Line (Tracer)", "ESPLine", false, function(state) Config.ESPLine = state end)
toggles.ESPHealth = createToggleWithKeybind(ESPTab, "ESP Health", "ESPHealth", false, function(state) Config.ESPHealth = state end)
toggles.ESPName = createToggleWithKeybind(ESPTab, "ESP Name + Distancia", "ESPName", false, function(state) Config.ESPName = state end)

-- Aimbot Tab
toggles.Aimbot = createToggleWithKeybind(AimbotTab, "Aimbot (Activo con Click Derecho)", "Aimbot", false, function(state) Config.Aimbot = state end)
toggles.HeadExpander = createToggleWithKeybind(AimbotTab, "Head Expander (Agrandar Cabezas)", "HeadExpander", false, function(state) Config.HeadExpander = state end)
toggles.WallCheck = createToggleWithKeybind(AimbotTab, "Wallcheck", "WallCheck", true, function(state) Config.WallCheck = state end)
toggles.TeamCheck = createToggleWithKeybind(AimbotTab, "Team Check", "TeamCheck", true, function(state) Config.TeamCheck = state end)
toggles.FreeForAll = createToggleWithKeybind(AimbotTab, "Modo FFA (Todos contra Todos)", "FreeForAll", false, function(state) Config.FreeForAll = state end)
toggles.FOV = createToggleWithKeybind(AimbotTab, "Mostrar FOV RGB", "FOV", true, function(state) 
    Config.FOV = state 
    FOVCircle.Visible = state 
end)

-- Jugador Tab
toggles.Fly = createToggleWithKeybind(JugadorTab, "Fly", "Fly", false, function(state) Config.Fly = state end)
toggles.Noclip = createToggleWithKeybind(JugadorTab, "Noclip", "Noclip", false, function(state) Config.Noclip = state end)
toggles.Speed = createToggleWithKeybind(JugadorTab, "Velocidad", "Speed", false, function(state) Config.Speed = state end)
toggles.SuperJump = createToggleWithKeybind(JugadorTab, "Super Salto", "SuperJump", false, function(state) Config.SuperJump = state end)

-- Armas Tab
toggles.NoRecoil = createToggleWithKeybind(ArmasTab, "No Recoil Extremo", "NoRecoil", false, function(state) Config.NoRecoil = state end)
toggles.InfiniteAmmo = createToggleWithKeybind(ArmasTab, "Infinite Ammo", "InfiniteAmmo", false, function(state) Config.InfiniteAmmo = state end)
toggles.RapidFire = createToggleWithKeybind(ArmasTab, "Fire Rate Hiper Rápido", "RapidFire", false, function(state) Config.RapidFire = state end)

-- Teleport Tab
toggles.TeleportForward = createToggleWithKeybind(TeleportTab, "Teleport Forward (Keybind)", "TeleportForward", false, function(state) Config.TeleportForward = state end)

-- Slider helper
local function createSlider(parent, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 55)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    sliderFrame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = sliderFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -30, 0, 6)
    sliderBar.Position = UDim2.new(0, 15, 0, 38)
    sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local draggingSlider = false
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mousePos = input.Position.X
            local barPos = sliderBar.AbsolutePosition.X
            local barSize = sliderBar.AbsoluteSize.X
            local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
            local value = math.floor(min + (max - min) * percent)
            
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = text .. ": " .. value
            callback(value)
        end
    end)
end

createSlider(AimbotTab, "Tamaño del FOV", 30, 400, Config.FOVRadius, function(value)
    Config.FOVRadius = value
end)

createSlider(AimbotTab, "Max Distance", 50, 2000, Config.MaxDistance, function(value)
    Config.MaxDistance = value
end)

createSlider(AimbotTab, "Tamaño de la Cabeza (Head Size)", 2, 10, Config.HeadSizeValue, function(value)
    Config.HeadSizeValue = value
end)

createSlider(JugadorTab, "Velocidad (WalkSpeed)", 16, 200, Config.SpeedValue, function(value)
    Config.SpeedValue = value
end)

createSlider(JugadorTab, "Super Salto (JumpPower)", 50, 300, Config.JumpPower, function(value)
    Config.JumpPower = value
end)

createSlider(TeleportTab, "Distancia Teleport Forward", 5, 40, Config.TeleportDistance, function(value)
    Config.TeleportDistance = value
end)

-- Botón Teleport al más cercano
local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.AutoButtonColor = false
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

createButton(TeleportTab, "Teleport al Jugador más Cercano", function()
    local closest, shortest = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = p
            end
        end
    end
    if closest and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = closest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end)

-- ==========================================
-- MISC TAB
-- ==========================================
local menuKeyFrame = Instance.new("Frame")
menuKeyFrame.Size = UDim2.new(1, 0, 0, 42)
menuKeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
menuKeyFrame.Parent = MiscTab

local menuKeyCorner = Instance.new("UICorner")
menuKeyCorner.CornerRadius = UDim.new(0, 6)
menuKeyCorner.Parent = menuKeyFrame

local menuKeyLabel = Instance.new("TextLabel")
menuKeyLabel.Size = UDim2.new(1, -110, 1, 0)
menuKeyLabel.Position = UDim2.new(0, 15, 0, 0)
menuKeyLabel.Text = "Keybind Abrir/Cerrar Menú"
menuKeyLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
menuKeyLabel.TextSize = 13
menuKeyLabel.Font = Enum.Font.Gotham
menuKeyLabel.TextXAlignment = Enum.TextXAlignment.Left
menuKeyLabel.BackgroundTransparency = 1
menuKeyLabel.Parent = menuKeyFrame

local menuKeyBox = Instance.new("TextButton")
menuKeyBox.Size = UDim2.new(0, 70, 0, 24)
menuKeyBox.Position = UDim2.new(1, -85, 0.5, -12)
menuKeyBox.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
menuKeyBox.Text = "Insert"
menuKeyBox.TextColor3 = Color3.fromRGB(0, 255, 120)
menuKeyBox.TextSize = 11
menuKeyBox.Font = Enum.Font.GothamSemibold
menuKeyBox.AutoButtonColor = false
menuKeyBox.Parent = menuKeyFrame

local menuKeyBoxCorner = Instance.new("UICorner")
menuKeyBoxCorner.CornerRadius = UDim.new(0, 6)
menuKeyBoxCorner.Parent = menuKeyBox

menuKeyBox.MouseButton1Click:Connect(function()
    if WaitingForKeybind then return end
    WaitingForKeybind = "Menu"
    menuKeyBox.Text = "..."
    menuKeyBox.TextColor3 = Color3.fromRGB(255, 215, 0)
end)

createButton(MiscTab, "Guardar Configuración", function()
    local data = {
        Config = Config,
        Keybinds = {}
    }
    for k, v in pairs(Keybinds) do
        if v then data.Keybinds[k] = v.Name end
    end
    local success = pcall(function()
        writefile("TheKingConfig.json", HttpService:JSONEncode(data))
    end)
    if success then print("[The King] Config guardada") else warn("[The King] Error al guardar") end
end)

createButton(MiscTab, "Cargar Configuración", function()
    local success, result = pcall(function()
        if isfile("TheKingConfig.json") then
            return HttpService:JSONDecode(readfile("TheKingConfig.json"))
        end
    end)
    if success and result then
        if result.Config then
            for k, v in pairs(result.Config) do
                if Config[k] ~= nil then Config[k] = v end
            end
        end
        if result.Keybinds then
            for k, v in pairs(result.Keybinds) do
                if Enum.KeyCode[v] then
                    Keybinds[k] = Enum.KeyCode[v]
                    if toggles[k] and toggles[k].keybindBox then
                        toggles[k].keybindBox.Text = v
                        toggles[k].keybindBox.TextColor3 = Color3.fromRGB(0, 255, 120)
                    end
                    if k == "Menu" then
                        menuKeyBox.Text = v
                        menuKeyBox.TextColor3 = Color3.fromRGB(0, 255, 120)
                    end
                end
            end
        end
        for name, toggle in pairs(toggles) do
            if Config[name] ~= nil then toggle.setEnabled(Config[name]) end
        end
        FOVCircle.Visible = Config.FOV
        print("[The King] Config cargada")
    else
        warn("[The King] No se encontró config")
    end
end)

-- ==========================================
-- KEYBIND LISTENER
-- ==========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if WaitingForKeybind then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local keyName = input.KeyCode.Name
            if WaitingForKeybind == "Menu" then
                Keybinds.Menu = input.KeyCode
                menuKeyBox.Text = keyName
                menuKeyBox.TextColor3 = Color3.fromRGB(0, 255, 120)
            else
                Keybinds[WaitingForKeybind] = input.KeyCode
                if toggles[WaitingForKeybind] then
                    local box = toggles[WaitingForKeybind].keybindBox
                    box.Text = keyName
                    box.TextColor3 = Color3.fromRGB(0, 255, 120)
                    box.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
                end
            end
            WaitingForKeybind = nil
        end
        return
    end
    
    if Keybinds.Menu and input.KeyCode == Keybinds.Menu then
        MenuVisible = not MenuVisible
        MainFrame.Visible = MenuVisible
        return
    end
    
    -- Teleport Forward
    if Config.TeleportForward and Keybinds.TeleportForward and input.KeyCode == Keybinds.TeleportForward then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            root.CFrame = root.CFrame + (root.CFrame.LookVector * Config.TeleportDistance)
        end
        return
    end
    
    for name, keyCode in pairs(Keybinds) do
        if name ~= "Menu" and name ~= "TeleportForward" and keyCode and input.KeyCode == keyCode then
            local toggle = toggles[name]
            if toggle then
                toggle.setEnabled(not toggle.getEnabled())
            end
        end
    end
end)

-- ==========================================
-- MINIMIZE / CLOSE / DRAG
-- ==========================================
local minimized = false

MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TabButtonsFrame.Visible = false
        ContentFrame.Visible = false
        MinimizeBtn.Text = "+"
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 560, 0, 40)
        }):Play()
    else
        MinimizeBtn.Text = "-"
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 560, 0, 520)
        }):Play()
        task.delay(0.22, function()
            if not minimized then
                TabButtonsFrame.Visible = true
                ContentFrame.Visible = true
            end
        end)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0), Transparency = 1})
    tween:Play()
    tween.Completed:Connect(function()
        ScreenGui:Destroy()
        FOVCircle:Remove()
        for _, drawings in pairs(espDrawings) do
            for _, obj in pairs(drawings) do
                if typeof(obj) == "table" then
                    for _, line in pairs(obj) do pcall(function() line:Remove() end) end
                else
                    pcall(function() obj:Remove() end)
                end
            end
        end
    end)
end)

local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

-- ==========================================
-- WALLCHECK + TEAM CHECK
-- ==========================================
local function isVisible(targetPart)
    if not targetPart or not LocalPlayer.Character then return false end
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    raycastParams.IgnoreWater = true
    local result = workspace:Raycast(origin, direction, raycastParams)
    if result then
        local hitCharacter = result.Instance:FindFirstAncestorOfClass("Model")
        if hitCharacter and hitCharacter == targetPart.Parent then return true end
        return false
    end
    return true
end

local function isEnemy(player)
    if Config.FreeForAll then return true end
    if not Config.TeamCheck then return true end
    if not player.Team or not LocalPlayer.Team then return true end
    return player.Team ~= LocalPlayer.Team
end

-- ==========================================
-- ESP SYSTEM
-- ==========================================
local espDrawings = {}

local function removeESP(player)
    if espDrawings[player] then
        for _, obj in pairs(espDrawings[player]) do
            if typeof(obj) == "table" then
                for _, line in pairs(obj) do pcall(function() line:Remove() end) end
            else
                pcall(function() obj:Remove() end)
            end
        end
        espDrawings[player] = nil
    end
end

local function setupESP(player)
    if player == LocalPlayer then return end
    local drawings = {
        Box = Drawing.new("Square"),
        Line = Drawing.new("Line"),
        HealthBar = Drawing.new("Line"),
        HealthBarBg = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        CornerTL1 = Drawing.new("Line"), CornerTL2 = Drawing.new("Line"),
        CornerTR1 = Drawing.new("Line"), CornerTR2 = Drawing.new("Line"),
        CornerBL1 = Drawing.new("Line"), CornerBL2 = Drawing.new("Line"),
        CornerBR1 = Drawing.new("Line"), CornerBR2 = Drawing.new("Line"),
        Skeleton = {}
    }
    drawings.Box.Visible = false
    drawings.Box.Thickness = 1.5
    drawings.Box.Filled = false
    drawings.Line.Visible = false
    drawings.Line.Thickness = 1
    drawings.HealthBar.Visible = false
    drawings.HealthBar.Thickness = 2
    drawings.HealthBarBg.Visible = false
    drawings.HealthBarBg.Thickness = 4
    drawings.HealthBarBg.Color = Color3.fromRGB(30, 30, 30)
    drawings.Name.Visible = false
    drawings.Name.Size = 13
    drawings.Name.Center = true
    drawings.Name.Outline = true
    drawings.Name.Font = 2
    for _, name in pairs({"CornerTL1","CornerTL2","CornerTR1","CornerTR2","CornerBL1","CornerBL2","CornerBR1","CornerBR2"}) do
        drawings[name].Visible = false
        drawings[name].Thickness = 1.5
    end
    local skeletonBones = {
        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
        {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"},
        {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
        {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
    }
    for i = 1, #skeletonBones do
        local l = Drawing.new("Line")
        l.Visible = false
        l.Thickness = 1.5
        table.insert(drawings.Skeleton, {line = l, p1 = skeletonBones[i][1], p2 = skeletonBones[i][2]})
    end
    espDrawings[player] = drawings
end

Players.PlayerRemoving:Connect(removeESP)
for _, p in pairs(Players:GetPlayers()) do setupESP(p) end
Players.PlayerAdded:Connect(setupESP)

-- ==========================================
-- AIMBOT HELPER
-- ==========================================
local function getClosestEnemyHead()
    local closestTarget = nil
    local shortestDistance = Config.FOVRadius
    local mouseLocation = UserInputService:GetMouseLocation()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and isEnemy(p) then
            local humanoid = p.Character:FindFirstChild("Humanoid")
            local head = p.Character:FindFirstChild("Head")
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            if humanoid and head and root and humanoid.Health > 0 then
                local dist3D = (root.Position - Camera.CFrame.Position).Magnitude
                if dist3D > Config.MaxDistance then continue end
                local passesWallCheck = true
                if Config.WallCheck then passesWallCheck = isVisible(head) end
                if passesWallCheck then
                    local headScreenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local distance = (Vector2.new(headScreenPos.X, headScreenPos.Y) - mouseLocation).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            closestTarget = head
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end

-- ==========================================
-- PLAYER HACKS + ARMAS + TELEPORT LOGIC
-- ==========================================
local flyBV = nil

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end
    
    -- Speed
    if Config.Speed then
        hum.WalkSpeed = Config.SpeedValue
    end
    
    -- Super Jump
    if Config.SuperJump then
        hum.JumpPower = Config.JumpPower
        hum.JumpHeight = Config.JumpPower / 3
    end
    
    -- Noclip
    if Config.Noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    -- Fly
    if Config.Fly then
        if not flyBV or flyBV.Parent ~= root then
            if flyBV then flyBV:Destroy() end
            flyBV = Instance.new("BodyVelocity")
            flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            flyBV.Velocity = Vector3.zero
            flyBV.Parent = root
        end
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
        flyBV.Velocity = dir.Unit * (Config.SpeedValue + 20)
        if dir.Magnitude < 0.1 then flyBV.Velocity = Vector3.zero end
    else
        if flyBV then
            flyBV:Destroy()
            flyBV = nil
        end
    end
end)

-- Armas (No Recoil + Infinite Ammo + Rapid Fire)
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    -- Infinite Ammo
    if Config.InfiniteAmmo then
        for _, v in pairs(tool:GetDescendants()) do
            if v:IsA("NumberValue") or v:IsA("IntValue") then
                local name = v.Name:lower()
                if name:find("ammo") or name:find("bullet") or name:find("clip") or name:find("magazine") then
                    v.Value = 999
                end
            end
        end
        pcall(function()
            if tool:FindFirstChild("Ammo") then tool.Ammo.Value = 999 end
            if tool:FindFirstChild("Clip") then tool.Clip.Value = 999 end
        end)
    end
    
    -- Rapid Fire
    if Config.RapidFire then
        for _, v in pairs(tool:GetDescendants()) do
            if v:IsA("NumberValue") or v:IsA("IntValue") then
                local name = v.Name:lower()
                if name:find("fire") or name:find("cooldown") or name:find("delay") or name:find("rate") or name:find("rpm") then
                    v.Value = 0.01
                end
            end
        end
    end
end)

-- ==========================================
-- HEAD EXPANDER LOGIC
-- ==========================================
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if head and humanoid and humanoid.Health > 0 and isEnemy(player) then
                if Config.HeadExpander then
                    head.Size = Vector3.new(Config.HeadSizeValue, Config.HeadSizeValue, Config.HeadSizeValue)
                    head.CanCollide = false
                    head.Transparency = 0.5
                else
                    head.Size = Vector3.new(2, 1, 1)
                    head.Transparency = 0
                end
            end
        end
    end
end)

-- ==========================================
-- RENDERSTEPPED PRINCIPAL (ESP + Aimbot + FOV)
-- ==========================================
RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    FOVCircle.Visible = Config.FOV and MenuVisible
    FOVCircle.Radius = Config.FOVRadius
    local mouseLocation = UserInputService:GetMouseLocation()
    FOVCircle.Position = mouseLocation
    FOVCircle.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    
    -- Aimbot con Click Derecho (tradicional)
    if Config.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local targetHead = getClosestEnemyHead()
        if targetHead then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
        end
    end
    
    for player, drawings in pairs(espDrawings) do
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local head = character and character:FindFirstChild("Head")
        local humanoid = character and character:FindFirstChild("Humanoid")
        
        if character and rootPart and head and humanoid and humanoid.Health > 0 and isEnemy(player) then
            local dist3D = (rootPart.Position - Camera.CFrame.Position).Magnitude
            if dist3D > Config.MaxDistance then
                drawings.Box.Visible = false
                drawings.Line.Visible = false
                drawings.HealthBar.Visible = false
                drawings.HealthBarBg.Visible = false
                drawings.Name.Visible = false
                for _, name in pairs({"CornerTL1","CornerTL2","CornerTR1","CornerTR2","CornerBL1","CornerBL2","CornerBR1","CornerBR2"}) do
                    drawings[name].Visible = false
                end
                for _, boneData in ipairs(drawings.Skeleton) do boneData.line.Visible = false end
                continue
            end
            
            local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            local visible = isVisible(head)
            local dynamicColor = visible and Config.VisibleColor or Config.HiddenColor
            
            if onScreen then
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 2
                local boxX = vector.X - width / 2
                local boxY = headPos.Y
                
                if Config.ESPBox then
                    drawings.Box.Size = Vector2.new(width, height)
                    drawings.Box.Position = Vector2.new(boxX, boxY)
                    drawings.Box.Color = dynamicColor
                    drawings.Box.Visible = true
                else
                    drawings.Box.Visible = false
                end
                
                if Config.ESPCorner then
                    local cornerLen = math.min(width, height) * 0.25
                    drawings.CornerTL1.From = Vector2.new(boxX, boxY)
                    drawings.CornerTL1.To = Vector2.new(boxX + cornerLen, boxY)
                    drawings.CornerTL2.From = Vector2.new(boxX, boxY)
                    drawings.CornerTL2.To = Vector2.new(boxX, boxY + cornerLen)
                    drawings.CornerTR1.From = Vector2.new(boxX + width, boxY)
                    drawings.CornerTR1.To = Vector2.new(boxX + width - cornerLen, boxY)
                    drawings.CornerTR2.From = Vector2.new(boxX + width, boxY)
                    drawings.CornerTR2.To = Vector2.new(boxX + width, boxY + cornerLen)
                    drawings.CornerBL1.From = Vector2.new(boxX, boxY + height)
                    drawings.CornerBL1.To = Vector2.new(boxX + cornerLen, boxY + height)
                    drawings.CornerBL2.From = Vector2.new(boxX, boxY + height)
                    drawings.CornerBL2.To = Vector2.new(boxX, boxY + height - cornerLen)
                    drawings.CornerBR1.From = Vector2.new(boxX + width, boxY + height)
                    drawings.CornerBR1.To = Vector2.new(boxX + width - cornerLen, boxY + height)
                    drawings.CornerBR2.From = Vector2.new(boxX + width, boxY + height)
                    drawings.CornerBR2.To = Vector2.new(boxX + width, boxY + height - cornerLen)
                    for _, name in pairs({"CornerTL1","CornerTL2","CornerTR1","CornerTR2","CornerBL1","CornerBL2","CornerBR1","CornerBR2"}) do
                        drawings[name].Color = dynamicColor
                        drawings[name].Visible = true
                    end
                else
                    for _, name in pairs({"CornerTL1","CornerTL2","CornerTR1","CornerTR2","CornerBL1","CornerBL2","CornerBR1","CornerBR2"}) do
                        drawings[name].Visible = false
                    end
                end
                
                if Config.ESPLine then
                    drawings.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    drawings.Line.To = Vector2.new(vector.X, vector.Y)
                    drawings.Line.Color = dynamicColor
                    drawings.Line.Visible = true
                else
                    drawings.Line.Visible = false
                end
                
                if Config.ESPHealth then
                    local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                    local barX = boxX - 6
                    drawings.HealthBarBg.From = Vector2.new(barX, boxY + height)
                    drawings.HealthBarBg.To = Vector2.new(barX, boxY)
                    drawings.HealthBarBg.Visible = true
                    drawings.HealthBar.From = Vector2.new(barX, boxY + height)
                    drawings.HealthBar.To = Vector2.new(barX, boxY + (height * (1 - healthPercent)))
                    drawings.HealthBar.Color = Color3.fromRGB(0, 255, 0)
                    drawings.HealthBar.Visible = true
                else
                    drawings.HealthBar.Visible = false
                    drawings.HealthBarBg.Visible = false
                end
                
                if Config.ESPName then
                    local namePos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.2, 0))
                    drawings.Name.Position = Vector2.new(namePos.X, namePos.Y)
                    drawings.Name.Text = player.Name .. " [" .. math.floor(dist3D) .. "m]"
                    drawings.Name.Color = dynamicColor
                    drawings.Name.Visible = true
                else
                    drawings.Name.Visible = false
                end
                
                if Config.ESPSkeleton then
                    for _, boneData in ipairs(drawings.Skeleton) do
                        local p1Obj = character:FindFirstChild(boneData.p1)
                        local p2Obj = character:FindFirstChild(boneData.p2)
                        if p1Obj and p2Obj then
                            local v1, onS1 = Camera:WorldToViewportPoint(p1Obj.Position)
                            local v2, onS2 = Camera:WorldToViewportPoint(p2Obj.Position)
                            if onS1 or onS2 then
                                boneData.line.From = Vector2.new(v1.X, v1.Y)
                                boneData.line.To = Vector2.new(v2.X, v2.Y)
                                boneData.line.Color = dynamicColor
                                boneData.line.Visible = true
                            else
                                boneData.line.Visible = false
                            end
                        else
                            boneData.line.Visible = false
                        end
                    end
                else
                    for _, boneData in ipairs(drawings.Skeleton) do boneData.line.Visible = false end
                end
            else
                drawings.Box.Visible = false
                drawings.Line.Visible = false
                drawings.HealthBar.Visible = false
                drawings.HealthBarBg.Visible = false
                drawings.Name.Visible = false
                for _, name in pairs({"CornerTL1","CornerTL2","CornerTR1","CornerTR2","CornerBL1","CornerBL2","CornerBR1","CornerBR2"}) do
                    drawings[name].Visible = false
                end
                for _, boneData in ipairs(drawings.Skeleton) do boneData.line.Visible = false end
            end
        else
            drawings.Box.Visible = false
            drawings.Line.Visible = false
            drawings.HealthBar.Visible = false
            drawings.HealthBarBg.Visible = false
            drawings.Name.Visible = false
            for _, name in pairs({"CornerTL1","CornerTL2","CornerTR1","CornerTR2","CornerBL1","CornerBL2","CornerBR1","CornerBR2"}) do
                drawings[name].Visible = false
            end
            for _, boneData in ipairs(drawings.Skeleton) do boneData.line.Visible = false end
        end
    end
end)

print("¡The King Cheat Full Pack (Versión Normal / Sin Silent) cargado con éxito!")
