-- SellService
-- Author(s): Jesse Appleton
-- Date: 09/02/2022

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local Field = require( Knit.Util.Field )
local DataService = Knit.GetService("DataService")
local PetHelper = require( Knit.Helpers.PetHelper )
local InventoryHelper = require( Knit.Helpers.InventoryHelper )

-- Roblox Services
local CollectionService = game:GetService("CollectionService")
-- Variables

-- Objects

---------------------------------------------------------------------


local SellService = Knit.CreateService {
    Name = "SellService";
    Client = {
        
    };
}


function SellService:KnitStart(): ()
    for index, sellPart in pairs( CollectionService:GetTagged("Seller") ) do
        local field = Field.new({sellPart})
        field:Start()
        field.PlayerEntered:Connect(function(player)
            local playerData = DataService:GetPlayerDataAsync(player).Data
            if playerData.Orbs > 0 then
                local equippedPets = InventoryHelper.GetInventoryEntryByFilter(playerData.Pets, {
                    _equipped = true;
                })
                local increment = playerData.Orbs * math.round(PetHelper.GetPetCoinMultiplierInBatch(equippedPets))
                DataService:IncrementPlayerData(player, "Coins", increment)
                DataService:SetPlayerData(player, "Orbs", 0)
            end
        end)
    end
end


function SellService:KnitInit(): ()
    
end


return SellService