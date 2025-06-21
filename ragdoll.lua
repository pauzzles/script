-- FTAP Ragdoll Kill by qaterin
local RS = game:GetService("ReplicatedStorage")
local RF = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local HRP = char:WaitForChild("HumanoidRootPart")

-- Spawn Blobman
local spawnFunc = RS:FindFirstChild("MenuToys"):FindFirstChild("SpawnToyRemoteFunction")
spawnFunc:InvokeServer("CreatureBlobman", HRP.CFrame * CFrame.new(0,10000,0), Vector3.zero)
task.wait(1.5)

-- Get Blobman and remote
local blobman = workspace:FindFirstChild(plr.Name.."SpawnedInToys"):FindFirstChild("CreatureBlobman")
local CD = blobman.BlobmanSeatAndOwnerScript.CreatureDrop

-- Ragdoll template break (permanent)
CD:FireServer(RF.ThrowPlayers.RagdollTemplate.Head.BallSocketConstraint, HRP)

-- Kill all players via head constraint
for _, p in pairs(Players:GetPlayers()) do
    if p ~= plr and p.Character and p.Character:FindFirstChild("Head") then
        local bsc = p.Character.Head:FindFirstChild("BallSocketConstraint")
        if bsc then
            CD:FireServer(bsc, HRP)
        end
    end
end
