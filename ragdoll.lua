task.wait(6)

-- Services
local RS = game:GetService("ReplicatedStorage")
local RF = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local HRP = char:WaitForChild("HumanoidRootPart")

-- Blobman Setup
local spawnFunc = RS.MenuToys:FindFirstChild("SpawnToyRemoteFunction")
spawnFunc:InvokeServer("CreatureBlobman", HRP.CFrame * CFrame.new(0, 10000, 0), Vector3.zero)
task.wait(2)

local blobmanFolder = workspace:FindFirstChild(plr.Name.."SpawnedInToys")
local blobman = blobmanFolder and blobmanFolder:FindFirstChild("CreatureBlobman")
if not blobman then return warn("❌ Blobman not found") end

local CD = blobman:WaitForChild("BlobmanSeatAndOwnerScript"):WaitForChild("CreatureDrop")

-- === Break Functions ===

local function breakAlign(obj)
    CD:FireServer(obj.AlignPosition, HRP)
    CD:FireServer(obj.AlignOrientation, HRP)
end

-- 1. Break UFOs
local function breakUFOs()
    local outer = workspace.Map.AlwaysHereTweenedObjects.OuterUFO.Object.FollowThisPart
    local inner = workspace.Map.AlwaysHereTweenedObjects.InnerUFO.Object.FollowThisPart
    breakAlign(outer)
    breakAlign(inner)
end

-- 2. Remove Ocean
local function removeOcean()
    local ocean = workspace.Map.AlwaysHereTweenedObjects.Ocean.Object.FollowThisPart
    breakAlign(ocean)
end

-- 3. Break Train
local function breakTrain()
    local train = workspace.Map.AlwaysHereTweenedObjects.Train.Object.FollowThisPart
    breakAlign(train)
end

-- 4. Break Island Rocks
local function breakIslandRocks()
    local rocks = {
        "LrgDebris", "LrgDebris2", "SmlDebris", "SmlDebris2"
    }
    for _, name in pairs(rocks) do
        local part = workspace.Map.AlwaysHereTweenedObjects[name].Object.FollowThisPart
        breakAlign(part)
    end
end

-- 5. Ragdoll Kill
local function ragdollKill()
    CD:FireServer(RF.ThrowPlayers.RagdollTemplate.Head.BallSocketConstraint, HRP)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Head") then
            local bsc = p.Character.Head:FindFirstChild("BallSocketConstraint")
            if bsc then
                CD:FireServer(bsc, HRP)
            end
        end
    end
end

-- 6. Break Grabber Tool
local function breakGrabber()
    CD:FireServer(RF.GrabParts.DragPart.AlignOrientation, HRP)
    CD:FireServer(RF.GrabParts.DragPart.AlignPosition, HRP)
end

-- === Execute All ===
removeOcean()
breakUFOs()
breakTrain()
breakIslandRocks()
ragdollKill()
breakGrabber()

game.StarterGui:SetCore("SendNotification", {
    Title = "🔥 Weld Breaker",
    Text = "Executed all actions successfully",
    Duration = 5
})
