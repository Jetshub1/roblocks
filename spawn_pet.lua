--[[
    spawn_pet.lua
    Roblox Pet Spawner Script - GUI Edition
    ----------------------------------------
    Features:
    - On-screen "Spawn Pet" button (no chat needed)
    - Spawns a BIG pet (3x size) that follows you
    - Auto-detects pet model from Workspace.PetTemplates
    - Works in your own Roblox games or where pet templates exist

    Load in Ronix:
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Jetshub1/roblocks/main/spawn_pet.lua"))()
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Utility: Scale a Model
local function scaleModel(model, scale)
    local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if not primary then return end
    local primaryPos = primary.Position
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            local relativePos = part.Position - primaryPos
            part.Size = part.Size * scale
            part.Position = primaryPos + (relativePos * scale)
        elseif part:IsA("SpecialMesh") then
            part.Scale = part.Scale * scale
        end
    end
end

-- Find first pet template
local function findPetTemplate()
    local petFolder = Workspace:FindFirstChild("PetTemplates")
    if not petFolder then
        warn("[Pet Spawner] No 'PetTemplates' folder found in Workspace.")
        return nil
    end
    for _, obj in ipairs(petFolder:GetChildren()) do
        if obj:IsA("Model") then
            return obj
        end
    end
    warn("[Pet Spawner] No pet model found in PetTemplates folder.")
    return nil
end

-- Spawn pet near player & make it follow
local function spawnPet()
    local petTemplate = findPetTemplate()
    if not petTemplate then
        warn("[Pet Spawner] No pet template available.")
        return
    end

    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        warn("[Pet Spawner] Player character not ready.")
        return
    end

    -- Clone & scale pet
    local newPet = petTemplate:Clone()
    newPet.Name = LocalPlayer.Name .. "'s BIG Pet"
    newPet.Parent = Workspace
    newPet:SetAttribute("Owner", LocalPlayer.Name)
    scaleModel(newPet, 3) -- BIG pet

    -- Place near player
    newPet:PivotTo(LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(5, 0, 5))

    -- Follow loop
    task.spawn(function()
        while newPet and newPet.Parent and LocalPlayer.Character do
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                newPet:PivotTo(hrp.CFrame * CFrame.new(5, 0, 5))
            end
            task.wait(0.5)
        end
    end)

    print("[Pet Spawner] Spawned BIG pet: " .. newPet.Name)
end

-- Create GUI Button
local function createGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = "PetSpawnerGui"
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local button = Instance.new("TextButton")
    button.Parent = gui
    button.Size = UDim2.new(0, 150, 0, 50)
    button.Position = UDim2.new(0.5, -75, 0.85, 0)
    button.BackgroundColor3 = Color3.fromRGB(30, 200, 50)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 20
    button.Font = Enum.Font.SourceSansBold
    button.Text = "Spawn Pet"

    -- Button click action
    button.MouseButton1Click:Connect(function()
        spawnPet()
    end)
end

-- Start script
createGui()
print("[Pet Spawner] GUI loaded. Click 'Spawn Pet' button to spawn a BIG pet.")
