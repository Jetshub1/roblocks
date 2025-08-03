-- Keyless Grow a Garden Pet Spawner + Big & Reset Buttons
-- Author: Jetshub custom version

-- 1️⃣ Load Mozil Hub Keyless Pet & Seed Spawner
loadstring(game:HttpGet("https://raw.githubusercontent.com/MoziIOnTop/MoziIHub/refs/heads/main/GrowaGarden"))()

-- 2️⃣ Wait for game and hub to fully load
task.wait(5)

-- Function to scale pets
local function scalePets(scaleSize)
    local count = 0
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
            for _, part in pairs(obj:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Size = part.Size * scaleSize
                elseif part:IsA("SpecialMesh") then
                    part.Scale = part.Scale * scaleSize
                end
            end
            count += 1
        end
    end
    print("[Pet Scaler] Scaled " .. count .. " pets by x" .. scaleSize)
end

-- Function to reset pets to normal size (approximate)
local function resetPets()
    local scaleSize = 1/5 -- reset after 5x big
    scalePets(scaleSize)
    print("[Pet Scaler] Reset all pets to normal size.")
end

-- 3️⃣ Create GUI
local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "PetScalerGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Big Button
local bigBtn = Instance.new("TextButton")
bigBtn.Size = UDim2.new(0, 180, 0, 50)
bigBtn.Position = UDim2.new(0.5, -90, 0.75, 0)
bigBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
bigBtn.TextColor3 = Color3.new(1, 1, 1)
bigBtn.TextSize = 20
bigBtn.Font = Enum.Font.SourceSansBold
bigBtn.Text = "🐾 Make Pet BIG"
bigBtn.Parent = gui

-- Reset Button
local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0, 180, 0, 50)
resetBtn.Position = UDim2.new(0.5, -90, 0.85, 0)
resetBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
resetBtn.TextColor3 = Color3.new(1, 1, 1)
resetBtn.TextSize = 20
resetBtn.Font = Enum.Font.SourceSansBold
resetBtn.Text = "🔄 Reset Size"
resetBtn.Parent = gui

-- Button Events
bigBtn.MouseButton1Click:Connect(function()
    scalePets(5) -- Change to 10 for extra giant pets
end)

resetBtn.MouseButton1Click:Connect(function()
    resetPets()
end)

print("[Big Pet Spawner] GUI loaded. Spawn pets with Mozil Hub, then use BIG or RESET buttons.")
