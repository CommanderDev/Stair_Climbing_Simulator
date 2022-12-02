local Knit = require( game.ReplicatedStorage.Knit )
local RarityData = require( Knit.GameData.RarityData )

local RarityHelper = {} 

function RarityHelper.GetDataByName( rarityName: string ): {}
    for index, rarity in pairs( RarityData ) do 
        if rarity.Name == rarityName then 
            return rarity
        end
    end
end

return RarityHelper