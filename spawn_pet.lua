--[[
    spawn_pet.lua
    Roblox Pet Spawner Script - Updated Version
    --------------------------------------------
    Features:
    - Spawn your pet by typing "!pet" in chat
    - Auto-detects a pet model from Workspace.PetTemplates
    - No spawner part needed
    - Pet follows the player around

    Load in executor:
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Jetshub1/roblocks/main/spawn_pet.lua"))()
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Find any pet model in Workspace.PetTemplates
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

-- Spawn the pet near the player and make it follow
local function spawnPet()
    local petTemplate = findPetTemplate()
    if not petTemplate then return end

    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        warn("[Pet Spawner] Player character not ready.")
        return
    end

    -- Clone the pet
    local newPet = petTemplate:Clone()
    newPet.Name = LocalPlayer.Name .. "'s Pet"
    newPet.Parent = Workspace
    newPet:SetAttribute("Owner", LocalPlayer.Name)

    -- Place pet near the player
    newPet:PivotTo(LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(2, 0, 2))

    -- Follow loop
    task.spawn(function()
        while newPet and newPet.Parent and LocalPlayer.Character do
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                newPet:PivotTo(hrp.CFrame * CFrame.new(2, 0, 2))
            end
            task.wait(0.5)
        end
    end)

    print("[Pet Spawner] Spawned pet: " .. newPet.Name)
end

-- Listen for chat command
LocalPlayer.Chatted:Connect(function(msg)
    msg = string.lower(msg)
    if msg == "!pet" then
        spawnPet()
    end
end)

print("[Pet Spawner] Type !pet in chat to spawn your pet.")
