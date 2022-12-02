-- IslandController
-- Author(s): Jesse Appleton
-- Date: 12/01/2022

--[[
    
]]

---------------------------------------------------------------------


-- Constants
local STAIR_WIDTH: number = 46
-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local IslandData = require( Knit.GameData.IslandData )
-- Roblox Services

-- Variables

-- Objects
local Islands = Knit.Assets.General.Islands

---------------------------------------------------------------------

local IslandController = Knit.CreateController { Name = "IslandController" }

local function _generateIsland( island: {}, startingPoint: Vector3 ): () 
    local stairs: Model = Instance.new("Model")
    local islandPrefab: Folder = Islands[ island.Name ]
    for i = 1, island.StairCount do 
        local part = Instance.new("Part")
        part.CanCollide = false
        part.CanTouch = false
        part.Name = i
        part.Size = Vector3.new(STAIR_WIDTH,1,1)
        part.Position = startingPoint + Vector3.new(0, i,i)
        part.TopSurface = "Smooth"
        part.BottomSurface = "Smooth"
        part.Anchored = true
        part.Parent = stairs
    end
    local a = 1
    local wedge = Instance.new("WedgePart")
    wedge.Size = Vector3.new(STAIR_WIDTH, island.StairCount - a,island.StairCount)
    wedge.Position = startingPoint + Vector3.new(0, (island.StairCount / 2) + a, (island.StairCount / 2) + a / 2)
    wedge.Anchored = true
    wedge.Transparency = 1
    wedge.Parent = stairs

    islandPrefab.Barrier:Destroy()
    islandPrefab.Door:Destroy()
    islandPrefab.Parent = workspace
    islandPrefab:SetPrimaryPartCFrame( stairs[island.StairCount].CFrame )
    stairs.Parent = islandPrefab
end

function IslandController:KnitStart(): ()
    local Starter = Islands.Starter
    Starter.Parent = workspace

    local _nextStartingPoint = Starter.StartStair.Position
    for _, island in pairs( IslandData.Islands ) do 
        if ( island.Name ~= "Starter") then
            local startStair = Islands[ island.Name ].StartStair
            _generateIsland(island, _nextStartingPoint)
            _nextStartingPoint = startStair.Position
        end
    end
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Starter.SpawnLocation.CFrame
end


function IslandController:KnitInit(): ()
    
end


return IslandController