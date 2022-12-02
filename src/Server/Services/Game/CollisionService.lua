-- CollisionService
-- Author(s): Jesse Appleton
-- Date: 10/12/2022

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules

-- Roblox Services
local PhysicsService = game:GetService("PhysicsService")
local CollectionService = game:GetService("CollectionService")

-- Variables

-- Objects

---------------------------------------------------------------------


local CollisionService = Knit.CreateService {
    Name = "CollisionService";
    Client = {
        
    };
}

function CollisionService:KnitStart(): ()
    PhysicsService:CreateCollisionGroup("Pet")
    PhysicsService:CreateCollisionGroup("Player")
    PhysicsService:CreateCollisionGroup("Stair")
    PhysicsService:CollisionGroupSetCollidable("Player", "Player", false)
    PhysicsService:CollisionGroupSetCollidable("Player", "Pet", false)
    PhysicsService:CollisionGroupSetCollidable("Player", "Stair", false)
    local function OnCharacterAdded( character: Model )
        for _, object in pairs( character:GetDescendants() ) do 
            if object:IsA("BasePart") then
                PhysicsService:SetPartCollisionGroup(object, "Player")
            end
        end 
    end

    for _, stairs in pairs( CollectionService:GetTagged("Stairs")) do 
        for _, object in pairs( stairs:GetChildren() ) do
            if object.ClassName ~= "WedgePart" then 
                PhysicsService:SetPartCollisionGroup(object, "Stair")
                task.wait()
            end
        end
    end
    local function OnPlayerAdded( player: Player )
        if player.Character then 
            OnCharacterAdded(player.Character)
        end
        player.CharacterAdded:Connect(OnCharacterAdded)
    end

    game.Players.PlayerAdded:Connect(OnPlayerAdded)
end


function CollisionService:KnitInit(): ()
    
end


return CollisionService