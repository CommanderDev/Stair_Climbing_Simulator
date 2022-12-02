-- OrbController
-- Author(s): Jesse Appleton
-- Date: 09/02/2022

--[[
    
]]

---------------------------------------------------------------------


-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local OrbService = Knit.GetService("OrbService")
local OrbHelper = require( Knit.Helpers.OrbHelper )
local OrbData = require( Knit.GameData.OrbData )
local OrbHandler = require( game.ReplicatedStorage.OrbHandler )

local DataController = Knit.GetController("DataController")

-- Roblox Services
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
-- Variables
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Whitelist
raycastParams.IgnoreWater = true
local random = Random.new()

local orbList = {}
local lastPickup = os.clock()
local amountPickedup = 0
local losingPickups = false
local lastLostPickup = os.clock()

-- Objects
local player: Player = game.Players.LocalPlayer

local Orb: BasePart = Knit.Assets.General.Orb
local Map: Folder = workspace:WaitForChild("Map")
local OrbSpawners: Folder = Map:WaitForChild("OrbSpawners")
local Zones = Map:WaitForChild("Zones")
local instances = {} 
for index, stairs in pairs( CollectionService:GetTagged("Stairs")) do 
    for index, stair in pairs( stairs:GetChildren() ) do 
        if stair:IsA("WedgePart") then continue end
        table.insert(instances, stair)
    end
end

raycastParams.FilterDescendantsInstances = instances
---------------------------------------------------------------------

local OrbController = Knit.CreateController { Name = "OrbController" }

local function selectRandomColor(): ()
	local randomChoice = {}
	for index,value in OrbData.Light do
		table.insert(randomChoice,index)
    end
	return randomChoice[random:NextInteger(1,#randomChoice)]
end

local function GetParticleColor()
    if amountPickedup >= 10 then
        return OrbData.Lights.Purple
    elseif amountPickedup > 8 then
        return OrbData.Lights.Orange
    elseif amountPickedup > 6 then 
        return OrbData.Lights.Green
    elseif amountPickedup > 4 then 
        return OrbData.Lights.Blue
    end
    return OrbData.Lights.White
end

local function ConnectTouch( orb: BasePart, spawner: BasePart ): () 
    local touchedConnection
    touchedConnection = orb.Touched:Connect(function(): ()
        touchedConnection:Disconnect()
        OrbService.OrbTouched:Fire()
        lastPickup = os.clock()
        losingPickups = false
        amountPickedup = math.clamp(amountPickedup + 1, 1, OrbData.MAX_PICKUPS)
        OrbHandler.ActivateEffect(orb, game.Players.LocalPlayer.Character.PrimaryPart, GetParticleColor())
        task.wait( spawner:GetAttribute("SpawnRate") )
        SpawnOrb(spawner)
    end)
end

local function GetOrbBrickColor( spawner )
    local selectedColor = OrbData.Colors[1].BrickColor
    local minAmount = OrbData.Colors[1].MinAmount
    for index, orbColorData in pairs( OrbData.Colors ) do 
        if orbColorData.MinAmount < spawner:GetAttribute("OrbCost") then 
            minAmount = orbColorData.MinAmount
            selectedColor = orbColorData.BrickColor
        else 
            break
        end
    end
    return selectedColor
end

function SpawnOrb( spawner: BasePart ): ()
    local randomX = math.random(-spawner.Size.X / 2, spawner.Size.X / 2)
    local randomZ = math.random(-spawner.Size.Z / 2, spawner.Size.Z / 2)
    local origin = spawner.CFrame * CFrame.new(randomX, -2, randomZ)
    local result = workspace:Raycast(origin.Position, Vector3.new(0, 1000, 0), raycastParams)
    if result then 
        local orb = Orb:Clone()
        orb.BrickColor = GetOrbBrickColor(spawner)
        orb.Position = result.Position + Vector3.new(0, orb.Size.Y, 0)
        ConnectTouch(orb, spawner)
        orb.Parent = workspace
        table.insert(orbList, orb)
        OrbHandler.InitialiseOrb(orb)
    else
        task.spawn(function()
            task.wait()
            SpawnOrb(spawner)
        end)
    end
end

local function SpawnAllOrbs(spawner): ()
    local MaxSpawn = spawner:GetAttribute("MaxSpawn")
    for index = 1, MaxSpawn do
        SpawnOrb(spawner)
    end
end

function OrbController:KnitStart(): ()
    for index, spawner in pairs( OrbSpawners:GetChildren() ) do
        SpawnAllOrbs(spawner)
    end
end


function OrbController:KnitInit(): ()
    local function Magnet(): ()
        local character = player.Character
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not character or not humanoidRootPart then return end
        for index, orb in pairs( orbList ) do 
            if (orb.Position-player.Character.HumanoidRootPart.Position).magnitude < 10 then
                local characterSpeed: number = character.Humanoid.WalkSpeed
                local projectedCharacterCFrame: CFrame = humanoidRootPart.CFrame + ( humanoidRootPart.CFrame.LookVector * (characterSpeed*(1/60)) )
                local speed = math.max( characterSpeed*1.2, 60 )
                local percent = math.clamp(
                    ( character.Humanoid.WalkSpeed * (1/60) ) -- MOVEMENT AMOUNT
                    /
                    ( orb.CFrame.Position - projectedCharacterCFrame.Position ).Magnitude -- DISTANCE TO TARGET
                , 0, 1 )
                orb.CFrame = orb.CFrame:Lerp(projectedCharacterCFrame, percent)
            end
        end
    end

    local function LastOrbPickup()
        local clock = os.clock()
        if clock-lastPickup >= 2 and amountPickedup > 0 and not losingPickups then 
            losingPickups = true
            lastLostPickup = clock
        end
        if losingPickups and clock-lastLostPickup >= 0.5 then
            amountPickedup -= 1
            lastLostPickup = clock
            if amountPickedup == 0 then 
                losingPickups = false
            end
        end
    end

    RunService:BindToRenderStep("LastOrbPickup", Enum.RenderPriority.First.Value, LastOrbPickup)
    RunService:BindToRenderStep("OrbMagnet", Enum.RenderPriority.Last.Value, Magnet)
end


return OrbController