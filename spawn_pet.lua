--[[
    spawn_pet.lua
    Roblox Big Pet Spawner Script
    --------------------------------------------
    Features:
    - Spawns a pet 3x bigger than normal
    - Spawn pet by typing "!pet" in chat
    - Auto-detects first pet model in Workspace.PetTemplates
    - Pet follows the player

    Load in executor:
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Jetshub1/roblocks/main/spawn_pet.lua"))()
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Scale Model function (simple proportional scaling)
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

-- Find pet template
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

-- Spawn big pet
local function spawnPet()
    local petTemplate = findPetTemplate()
    if not petTemplate then return end

    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        warn("[Pet Spawner] Player character not ready.")
        return
    end

    -- Clone and scale
    local newPet = petTemplate:Clone()
    newPet.Name = LocalPlayer.Name .. "'s BIG Pet"
    newPet.Parent = Workspace
    newPet:SetAttribute("Owner", LocalPlayer.Name)

    -- Make it 3x bigger
    scaleModel(newPet, 3)

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

-- Chat command
LocalPlayer.Chatted:Connect(function(msg)
    msg = string.lower(msg)
    if msg == "!pet" then
        spawnPet()
    end
end)

print("[Pet Spawner] Type !pet in chat to spawn your BIG pet.")
