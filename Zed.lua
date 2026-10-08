-- =========================================================================
-- ZEDHUB - GROW A GARDEN (FULL FEATURED CUSTOM UI SCRIPT)
-- =========================================================================
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("ZedHubCustomUI") then
    CoreGui.ZedHubCustomUI:Destroy()
end

-- CONFIGURATION & STATE
getgenv().ZedHubConfig = {
    AutoCollect = false,
    AutoSubmitFallBloom = false,
    GiveASeed = false,
    AutoShovel = false,
    ShadyScarecrowMode = "GOLD_EGG_SEED",
    AutoSellBackpack = false,
    AutoSellFruit = false,
    
    FallMarketBuy = {
        FallGear = { Active = false, BuyAll = false, Items = {} },
        FallSeed = { Active = false, BuyAll = false, Items = {} },
        FallPets = { Active = false, BuyAll = false, Items = {} },
        FallCrate = { Active = false, BuyAll = false, Items = {} }
    },
    
    MainShopBuy = {
        MainEgg = { Active = false, BuyAll = false, Items = {} },
        MainSeed = { Active = false, BuyAll = false, Items = {} },
        MainGear = { Active = false, BuyAll = false, Items = {} }
    }
}

-- ================= GUI BUILDER =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZedHubCustomUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Hub Window
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42) -- Slate 900
MainFrame.BorderColor3 = Color3.fromRGB(30, 41, 59)
MainFrame.Position = UDim2.new(0.5, -340, 0.5, -200)
MainFrame.Size = UDim2.new(0, 680, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Top Title Bar
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(2, 6, 23) -- Slate 950
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
TitleLabel.Text = "🪐 ZedHub  <font color='#94a3b8' size='10'>Grow A Garden</font>"
TitleLabel.RichText = true
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- FPS Counter di Atas
local FpsLabel = Instance.new("TextLabel")
FpsLabel.Parent = TopBar
FpsLabel.BackgroundColor3 = Color3.fromRGB(30, 58, 138)
FpsLabel.BackgroundTransparency = 0.7
FpsLabel.Position = UDim2.new(1, -125, 0, 8)
FpsLabel.Size = UDim2.new(0, 50, 0, 20)
FpsLabel.Font = Enum.Font.GothamBold
FpsLabel.Text = "60 FPS"
FpsLabel.TextColor3 = Color3.fromRGB(96, 165, 250)
FpsLabel.TextSize = 10
local FpsCorner = Instance.new("UICorner")
FpsCorner.CornerRadius = UDim.new(0, 4)
FpsCorner.Parent = FpsLabel

-- Tombol Close (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(1, -35, 0, 6)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(148, 163, 184)
CloseBtn.TextSize = 14

-- Modal Konfirmasi Exit (Are you sure wanna exit?)
local ExitModal = Instance.new("Frame")
ExitModal.Parent = ScreenGui
ExitModal.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ExitModal.BackgroundTransparency = 0.6
ExitModal.Size = UDim2.new(1, 0, 1, 0)
ExitModal.Visible = false
ExitModal.ZIndex = 50

local ModalBox = Instance.new("Frame")
ModalBox.Parent = ExitModal
ModalBox.AnchorPoint = Vector2.new(0.5, 0.5)
ModalBox.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
ModalBox.BorderColor3 = Color3.fromRGB(51, 65, 85)
ModalBox.Position = UDim2.new(0.5, 0, 0.5, 0)
ModalBox.Size = UDim2.new(0, 260, 0, 110)
ModalBox.ZIndex = 51

local ModalCorner = Instance.new("UICorner")
ModalCorner.CornerRadius = UDim.new(0, 10)
ModalCorner.Parent = ModalBox

local ModalText = Instance.new("TextLabel")
ModalText.Parent = ModalBox
ModalText.BackgroundTransparency = 1
ModalText.Position = UDim2.new(0, 0, 0, 15)
ModalText.Size = UDim2.new(1, 0, 0, 30)
ModalText.Font = Enum.Font.GothamBold
ModalText.Text = "Are you sure wanna exit?"
ModalText.TextColor3 = Color3.fromRGB(241, 245, 249)
ModalText.TextSize = 13
ModalText.ZIndex = 52

local YesBtn = Instance.new("TextButton")
YesBtn.Parent = ModalBox
YesBtn.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
YesBtn.Position = UDim2.new(0, 20, 0, 60)
YesBtn.Size = UDim2.new(0, 100, 0, 30)
YesBtn.Font = Enum.Font.GothamBold
YesBtn.Text = "Yes"
YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
YesBtn.TextSize = 12
YesBtn.ZIndex = 52
Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 6)

local NoBtn = Instance.new("TextButton")
NoBtn.Parent = ModalBox
NoBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
NoBtn.Position = UDim2.new(1, -120, 0, 60)
NoBtn.Size = UDim2.new(0, 100, 0, 30)
NoBtn.Font = Enum.Font.GothamBold
NoBtn.Text = "No"
NoBtn.TextColor3 = Color3.fromRGB(203, 213, 225)
NoBtn.TextSize = 12
NoBtn.ZIndex = 52
Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function() ExitModal.Visible = true end)
YesBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
NoBtn.MouseButton1Click:Connect(function() ExitModal.Visible = false end)

-- ================= BACKEND AUTOMATION ENGINE =================
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
local GameEvents = ReplicatedStorage:FindFirstChild("GameEvents")

local isProcessingScarecrow = false
local IsSelling = false

-- Presisi Auto Sell (Kasir)
local function PreciseSellInventory()
    if IsSelling then return end
    IsSelling = true
    pcall(function()
        local character = LocalPlayer.Character
        if not character then IsSelling = false return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local sheckles = LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Sheckles")
        if not hrp or not sheckles then IsSelling = false return end

        local prevCF = hrp.CFrame
        local prevVal = sheckles.Value

        hrp.CFrame = CFrame.new(62, 4, -26)
        task.wait(0.3)

        while task.wait(0.2) do
            if sheckles.Value ~= prevVal then break end
            if GameEvents and GameEvents:FindFirstChild("Sell_Inventory") then
                GameEvents.Sell_Inventory:FireServer()
            end
        end
        task.wait(0.2)
        hrp.CFrame = prevCF
    end)
    IsSelling = false
end

-- Loop Auto Sell Backpack/Fruit
task.spawn(function()
    while task.wait(3) do
        local backpackOn = getgenv().ZedHubConfig.AutoSellBackpack
        local fruitOn = getgenv().ZedHubConfig.AutoSellFruit
        local count = 0
        pcall(function()
            for _, t in pairs(LocalPlayer.Backpack:GetChildren()) do
                if t:FindFirstChild("Item_String") then count += 1 end
            end
        end)

        if (backpackOn and count >= 15) or (backpackOn and not fruitOn and count >= 15) or (not backpackOn and fruitOn) then
            PreciseSellInventory()
            task.wait(4)
        end
    end
end)

local function GetEventRequiredItemName()
    if not PlayerGui then return nil end
    for _, gui in pairs(PlayerGui:GetChildren()) do
        if gui.Name:lower():find("event") or gui.Name:lower():find("fall") or gui.Name:lower():find("bloom") then
            for _, desc in pairs(gui:GetDescendants()) do
                if desc:IsA("TextLabel") and (desc.Text:lower():find("need") or desc.Text:lower():find("require") or desc.Text:lower():find("/")) then
                    return desc.Text
                end
            end
        end
    end
    return nil
end

-- Auto Collect Required Plant
task.spawn(function()
    while task.wait(2) do
        if getgenv().ZedHubConfig.AutoCollect then
            pcall(function()
                local requiredKeyword = GetEventRequiredItemName()
                local myFarm = Workspace:FindFirstChild("Farm")
                if myFarm then
                    for _, plant in pairs(myFarm:GetDescendants()) do
                        if plant:IsA("Model") or plant:IsA("Part") then
                            local pName = plant.Name:lower()
                            local match = (requiredKeyword and pName:find(requiredKeyword:lower())) or (not requiredKeyword and (pName:find("fall") or pName:find("bloom")))
                            if match then
                                local prompt = plant:FindFirstChildWhichIsA("ProximityPrompt", true)
                                if prompt and prompt.Enabled then
                                    fireproximityprompt(prompt)
                                    task.wait(0.2)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Submit Plant
task.spawn(function()
    while task.wait(3) do
        if getgenv().ZedHubConfig.AutoSubmitFallBloom then
            pcall(function()
                local needed = GetEventRequiredItemName()
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and (not needed or tool.Name:lower():find(needed:lower()) or tool.Name:lower():find("fall")) then
                        local submitEvt = GameEvents and (GameEvents:FindFirstChild("SubmitFallPlant") or GameEvents:FindFirstChild("SubmitEvent"))
                        if submitEvt then
                            submitEvt:FireServer(tool)
                            task.wait(0.5)
                        end
                    end
                end
            end)
        end
    end
end)

-- Shady Scarecrow Logic
local function EquipSpecificSeed(mode)
    local character = LocalPlayer.Character
    local backpack = LocalPlayer.Backpack
    if not character then return false end
    local keywords = (mode == "GOLD_EGG_SEED") and {"gold", "egg", "golden"} or {"seed"}

    local currentTool = character:FindFirstChildOfClass("Tool")
    if currentTool then
        local tName = currentTool.Name:lower()
        for _, kw in pairs(keywords) do if tName:find(kw) then return true end end
    end

    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            local iName = item.Name:lower()
            for _, kw in pairs(keywords) do
                if iName:find(kw) then
                    if currentTool then currentTool.Parent = backpack end
                    item.Parent = character
                    task.wait(0.4)
                    return true
                end
            end
        end
    end
    return false
end

task.spawn(function()
    while task.wait(5) do
        if getgenv().ZedHubConfig.GiveASeed and not isProcessingScarecrow then
            pcall(function()
                isProcessingScarecrow = true
                local mode = getgenv().ZedHubConfig.ShadyScarecrowMode
                if EquipSpecificSeed(mode) then
                    local scarecrow = nil
                    for _, obj in pairs(Workspace:GetChildren()) do
                        if obj.Name:lower():find("scarecrow") or obj.Name:lower():find("shady") then
                            scarecrow = obj
                            break
                        end
                    end

                    if scarecrow then
                        local npcPart = scarecrow:FindFirstChild("HumanoidRootPart") or scarecrow.PrimaryPart or scarecrow:FindFirstChildWhichIsA("BasePart")
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if npcPart and hrp then
                            local origin = hrp.CFrame
                            local dist = (hrp.Position - npcPart.Position).Magnitude
                            local tween = TweenService:Create(hrp, TweenInfo.new(dist / 25, Enum.EasingStyle.Linear), {CFrame = npcPart.CFrame + Vector3.new(0, 3, 0)})
                            tween:Play()
                            tween.Completed:Wait()
                            task.wait(0.4)

                            local giveEvt = GameEvents and GameEvents:FindFirstChild("ScarecrowGiveSeed")
                            if giveEvt then giveEvt:FireServer(mode)
                            else
                                local p = scarecrow:FindFirstChildWhichIsA("ProximityPrompt", true)
                                if p then fireproximityprompt(p) end
                            end
                            task.wait(0.8)

                            local rTween = TweenService:Create(hrp, TweenInfo.new((hrp.Position - origin.Position).Magnitude / 25, Enum.EasingStyle.Linear), {CFrame = origin})
                            rTween:Play()
                            rTween.Completed:Wait()
                        end
                    end
                end
                isProcessingScarecrow = false
            end)
        end
    end
end)

print("ZedHub Full Custom Script Loaded Successfully!")
