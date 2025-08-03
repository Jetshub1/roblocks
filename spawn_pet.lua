--[[
    spawn_pet.lua
    Roblox Pet Spawner Script
    --------------------------
    Usage:
        loadstring(game:HttpGet("https://raw.githubusercontent.com/<your-username>/<repo-name>/main/spawn_pet.lua"))()

    Notes:
    - Designed for your own Roblox games or testing environments
    - Replace PET_NAME with your pet template model name
    - Replace SPAWN_PART_NAME with the name of the part that triggers the spawn
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- CONFIGURATION
local PET_NAME = "MyPet"  -- Name of the pet template model inside Workspace.PetTemplates
local SPAWN_PART_NAME = "PetSpawner"  -- Name of the part in workspace that triggers spawn

-- References
local petTemplateFolder = Workspace:FindFirstChild("PetTemplates")
local spawnPart = Workspace:FindFirstChild(SPAWN_PART_NAME)

if not petTemplateFolder then
    warn("[Pet Spawner] PetTemplates folder not found in Workspace.")
    return
end

local petTemplate = petTemplateFolder:FindFirstChild(PET_NAME)
if not petTemplate then
    warn("[Pet Spawner] Pet template '" .. PET_NAME .. "' not found.")
    return
end

if not spawnPart then
    warn("[Pet Spawner] Spawn part '" .. SPAWN_PART_NAME .. "' not found.")
    return
end

-- Spawn Pet Function
local function spawnPetForPlayer(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end

    -- Clone and set up pet
    local newPet = petTemplate:Clone()
    newPet.Name = player.Name .. "'s Pet"
    newPet.Parent = Workspace
    newPet:SetAttribute("Owner", player.Name)

    -- Place near player
    newPet:PivotTo(player.Character.HumanoidRootPart.CFrame * CFrame.new(2, 0, 2))

    -- Optional: Make pet follow player
    spawn(function()
        while newPet and newPet.Parent and player.Character do
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                newPet:PivotTo(hrp.CFrame * CFrame.new(2, 0, 2))
            end
            task.wait(0.5)
        end
    end)
end

-- Listen for touch on spawn part
spawnPart.Touched:Connect(function(hit)
    local player = Players:GetPlayerFromCharacter(hit.Parent)
    if player then
        spawnPetForPlayer(player)
    end
end)

print("[Pet Spawner] Script loaded successfully. Touch '" .. SPAWN_PART_NAME .. "' to spawn a pet.")
