-- =========================================================================
-- ZEDHUB - SAFE UI LOADER
-- =========================================================================
local success, err = pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    if PlayerGui:FindFirstChild("ZedHubCustomUI") then
        PlayerGui.ZedHubCustomUI:Destroy()
    end

    -- CONFIGURATION & STATE
    getgenv().ZedHubConfig = {
        AutoCollect = false,
        AutoSubmitFallBloom = false,
        GiveASeed = false,
        AutoSellBackpack = false
    }

    -- GUI BUILDER
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ZedHubCustomUI"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    MainFrame.BorderColor3 = Color3.fromRGB(30, 41, 59)
    MainFrame.Position = UDim2.new(0.5, -340, 0.5, -200)
    MainFrame.Size = UDim2.new(0, 680, 0, 400)
    MainFrame.Active = true
    MainFrame.Draggable = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(2, 6, 23)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 36)

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 12)
    TopCorner.Parent = TopBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = TopBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 12, 0, 0)
    TitleLabel.Size = UDim2.new(0, 300, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "🪐 ZedHub - Grow A Garden"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TopBar
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -35, 0, 6)
    CloseBtn.Size = UDim2.new(0, 24, 0, 24)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(148, 163, 184)
    CloseBtn.TextSize = 14

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- CONTAINER & TOGGLES
    local ContentContainer = Instance.new("ScrollingFrame")
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 12, 0, 48)
    ContentContainer.Size = UDim2.new(1, -24, 1, -60)
    ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 250)
    ContentContainer.ScrollBarThickness = 4

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = ContentContainer
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)

    local function CreateToggle(name, defaultState, callback)
        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Parent = ContentContainer
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
        ToggleBtn.Size = UDim2.new(1, 0, 0, 36)
        ToggleBtn.Font = Enum.Font.GothamBold
        ToggleBtn.Text = name .. ": " .. (defaultState and "ON" else "OFF")
        ToggleBtn.TextColor3 = defaultState and Color3.fromRGB(74, 222, 128) or Color3.fromRGB(248, 113, 113)
        ToggleBtn.TextSize = 12
        ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = ToggleBtn
        
        local Padding = Instance.new("UIPadding")
    	Padding.PaddingLeft = UDim.new(0, 12)
    	Padding.Parent = ToggleBtn

        local state = defaultState
        ToggleBtn.MouseButton1Click:Connect(function()
            state = not state
            ToggleBtn.Text = name .. ": " .. (state and "ON" else "OFF")
            ToggleBtn.TextColor3 = state and Color3.fromRGB(74, 222, 128) or Color3.fromRGB(248, 113, 113)
            callback(state)
        end)
    end

    CreateToggle("Auto Collect Fall/Bloom", getgenv().ZedHubConfig.AutoCollect, function(val)
        getgenv().ZedHubConfig.AutoCollect = val
    end)

    CreateToggle("Auto Submit Fall Plant", getgenv().ZedHubConfig.AutoSubmitFallBloom, function(val)
        getgenv().ZedHubConfig.AutoSubmitFallBloom = val
    end)

    CreateToggle("Shady Scarecrow Give Seed", getgenv().ZedHubConfig.GiveASeed, function(val)
        getgenv().ZedHubConfig.GiveASeed = val
    end)

    CreateToggle("Auto Sell Backpack", getgenv().ZedHubConfig.AutoSellBackpack, function(val)
        getgenv().ZedHubConfig.AutoSellBackpack = val
    end)
end)

if not success then
    warn("ZedHub Error: " .. tostring(err))
else
    print("ZedHub UI Loaded Successfully!")
end
