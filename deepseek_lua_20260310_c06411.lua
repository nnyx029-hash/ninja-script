-- Script Edukasi Ninja Battlegrounds
-- Fitur: Informasi game, statistik player, dan tips gameplay
-- Tidak mengandung cheat/exploit

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ================= GUI INFORMASI =================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NinjaInfoGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 200)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.new(1, 0.5, 0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
titleLabel.Text = "⚔️ NINJA INFO ⚔️"
titleLabel.TextColor3 = Color3.new(1, 0.5, 0)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.Parent = mainFrame

-- ================= FITUR 1: INFO PLAYER =================
local playerInfoFrame = Instance.new("Frame")
playerInfoFrame.Size = UDim2.new(1, -20, 0, 80)
playerInfoFrame.Position = UDim2.new(0, 10, 0, 35)
playerInfoFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
playerInfoFrame.Parent = mainFrame

local playerNameLabel = Instance.new("TextLabel")
playerNameLabel.Size = UDim2.new(1, 0, 0, 25)
playerNameLabel.BackgroundTransparency = 1
playerNameLabel.Text = "Player: " .. LocalPlayer.Name
playerNameLabel.TextColor3 = Color3.new(1, 1, 1)
playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
playerNameLabel.Font = Enum.Font.SourceSans
playerNameLabel.TextSize = 16
playerNameLabel.Parent = playerInfoFrame

local playerHealthLabel = Instance.new("TextLabel")
playerHealthLabel.Size = UDim2.new(1, 0, 0, 25)
playerHealthLabel.Position = UDim2.new(0, 0, 0, 25)
playerHealthLabel.BackgroundTransparency = 1
playerHealthLabel.Text = "Health: --"
playerHealthLabel.TextColor3 = Color3.new(0, 1, 0)
playerHealthLabel.TextXAlignment = Enum.TextXAlignment.Left
playerHealthLabel.Font = Enum.Font.SourceSans
playerHealthLabel.TextSize = 16
playerHealthLabel.Parent = playerInfoFrame

local playerEnergyLabel = Instance.new("TextLabel")
playerEnergyLabel.Size = UDim2.new(1, 0, 0, 25)
playerEnergyLabel.Position = UDim2.new(0, 0, 0, 50)
playerEnergyLabel.BackgroundTransparency = 1
playerEnergyLabel.Text = "Energy: --"
playerEnergyLabel.TextColor3 = Color3.new(1, 1, 0)
playerEnergyLabel.TextXAlignment = Enum.TextXAlignment.Left
playerEnergyLabel.Font = Enum.Font.SourceSans
playerEnergyLabel.TextSize = 16
playerEnergyLabel.Parent = playerInfoFrame

-- ================= FITUR 2: NEARBY PLAYERS =================
local nearbyFrame = Instance.new("Frame")
nearbyFrame.Size = UDim2.new(1, -20, 0, 80)
nearbyFrame.Position = UDim2.new(0, 10, 0, 120)
nearbyFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
nearbyFrame.Parent = mainFrame

local nearbyTitle = Instance.new("TextLabel")
nearbyTitle.Size = UDim2.new(1, 0, 0, 20)
nearbyTitle.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
nearbyTitle.Text = "👥 Players Nearby"
nearbyTitle.TextColor3 = Color3.new(0.5, 0.8, 1)
nearbyTitle.Font = Enum.Font.SourceSansBold
nearbyTitle.TextSize = 14
nearbyTitle.Parent = nearbyFrame

local nearbyList = Instance.new("ScrollingFrame")
nearbyList.Size = UDim2.new(1, -10, 0, 55)
nearbyList.Position = UDim2.new(0, 5, 0, 20)
nearbyList.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
nearbyList.ScrollBarThickness = 5
nearbyList.Parent = nearbyFrame

-- ================= UPDATE LOOP =================
local function updateInfo()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            playerHealthLabel.Text = "Health: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
            
            -- Cari energy (bisa berbeda tergantung game)
            local energy = character:FindFirstChild("Energy") or character:FindFirstChild("Stamina")
            if energy then
                playerEnergyLabel.Text = "Energy: " .. math.floor(energy.Value)
            else
                playerEnergyLabel.Text = "Energy: N/A"
            end
        end
    end
    
    -- Update nearby players list
    local listContent = Instance.new("UIListLayout")
    listContent.Parent = nearbyList
    listContent:Destroy() -- Hapus yang lama
    
    local yOffset = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local distance = "?"
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if rootPart and myRoot then
                    local dist = (rootPart.Position - myRoot.Position).Magnitude
                    distance = string.format("%.1f", dist)
                end
                
                local playerLabel = Instance.new("TextLabel")
                playerLabel.Size = UDim2.new(1, 0, 0, 18)
                playerLabel.Position = UDim2.new(0, 0, 0, yOffset)
                playerLabel.BackgroundTransparency = 1
                playerLabel.Text = player.Name .. " (" .. distance .. " studs)"
                playerLabel.TextColor3 = Color3.new(1, 1, 1)
                playerLabel.TextXAlignment = Enum.TextXAlignment.Left
                playerLabel.Font = Enum.Font.SourceSans
                playerLabel.TextSize = 12
                playerLabel.Parent = nearbyList
                
                yOffset = yOffset + 18
            end
        end
    end
    
    nearbyList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

-- Run update loop
RunService.RenderStepped:Connect(updateInfo)

-- ================= FITUR 3: HOTKEY INFO =================
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- ================= FITUR 4: GAME TIPS =================
local tips = {
    "Gunakan shuriken untuk serangan jarak jauh",
    "Smoke bomb bisa membuatmu kabur dari musuh",
    "Double jump memungkinkan combo udara",
    "Block untuk mengurangi damage",
    "Ultimate charge lebih cepat saat bertarung",
    "Jangan lupa beli upgrade di shop",
    "Gunakan environment untuk keuntungan taktis"
}

local tipLabel = Instance.new("TextLabel")
tipLabel.Size = UDim2.new(1, -20, 0, 30)
tipLabel.Position = UDim2.new(0, 10, 0, 205)
tipLabel.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
tipLabel.Text = "💡 Tip: " .. tips[math.random(#tips)]
tipLabel.TextColor3 = Color3.new(1, 1, 0.5)
tipLabel.Font = Enum.Font.SourceSans
tipLabel.TextSize = 12
tipLabel.TextWrapped = true
tipLabel.Parent = mainFrame

-- Rotate tips setiap 30 detik
spawn(function()
    while wait(30) do
        tipLabel.Text = "💡 Tip: " .. tips[math.random(#tips)]
    end
end)

-- ================= FITUR 5: PERFORMANCE MONITOR =================
local perfFrame = Instance.new("Frame")
perfFrame.Size = UDim2.new(0, 150, 0, 60)
perfFrame.Position = UDim2.new(1, -160, 0, 10)
perfFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
perfFrame.BackgroundTransparency = 0.5
perfFrame.BorderSizePixel = 1
perfFrame.BorderColor3 = Color3.new(0, 1, 0)
perfFrame.Parent = screenGui

local perfTitle = Instance.new("TextLabel")
perfTitle.Size = UDim2.new(1, 0, 0, 20)
perfTitle.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
perfTitle.Text = "📊 PERFORMANCE"
perfTitle.TextColor3 = Color3.new(0, 1, 0)
perfTitle.Font = Enum.Font.SourceSansBold
perfTitle.TextSize = 12
perfTitle.Parent = perfFrame

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, 0, 0, 20)
fpsLabel.Position = UDim2.new(0, 0, 0, 20)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 60"
fpsLabel.TextColor3 = Color3.new(1, 1, 1)
fpsLabel.Font = Enum.Font.SourceSans
fpsLabel.TextSize = 12
fpsLabel.Parent = perfFrame

local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(1, 0, 0, 20)
pingLabel.Position = UDim2.new(0, 0, 0, 40)
pingLabel.BackgroundTransparency = 1
pingLabel.Text = "Ping: --"
pingLabel.TextColor3 = Color3.new(1, 1, 1)
pingLabel.Font = Enum.Font.SourceSans
pingLabel.TextSize = 12
pingLabel.Parent = perfFrame

-- Update performance
local lastTime = tick()
local frames = 0
local fps = 60

RunService.RenderStepped:Connect(function()
    frames = frames + 1
    local currentTime = tick()
    if currentTime - lastTime >= 1 then
        fps = frames
        frames = 0
        lastTime = currentTime
        
        fpsLabel.Text = "FPS: " .. fps
        
        -- Dapatkan ping (jika tersedia)
        local stats = game:GetService("Stats")
        local network = stats:FindFirstChild("Network")
        if network then
            local ping = network:FindFirstChild("ServerStatsItem")
            if ping then
                pingLabel.Text = "Ping: " .. math.floor(ping.Value) .. "ms"
            end
        end
    end
end)

-- ================= WELCOME MESSAGE =================
print("⚔️ Ninja Info Script Loaded! ⚔️")
print("Tekan F1 untuk toggle menu")
print("Semoga membantu gameplay kamu!")

-- Loadstring untuk kemudahan
loadstring([[
    print("Script edukasi Ninja Battlegrounds siap digunakan!")
    print("Fitur: Player Info, Nearby Players, Tips, Performance Monitor")
]])()