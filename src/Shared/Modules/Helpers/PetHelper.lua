local Knit = require( game.ReplicatedStorage.Knit )

local PetData = require( Knit.GameData.PetData )

local PetHelper = {} 

function PetHelper.GetDataByName( petName: string ): {}
    for index, petData in pairs( PetData.Pets ) do 
        if petData.Name == petName then 
            return petData 
        end
    end
end

function PetHelper.GetPlayerMaxPets(player)
    player = player or game.Players.LocalPlayer
    return PetData.Max_Inventory
end

function PetHelper.GetPlayerMaxEquipped(player)
    player = player or game.Players.LocalPlayer
    return PetData.Max_Equipped
end

function PetHelper.GetPetCoinMultiplier( petData ): number
    local data = PetHelper.GetDataByName(petData.Name)
    return math.round(data.CoinMultiplier + (data.MultiplierPerLevel * petData.Level + 1)*10)/10
end

function PetHelper.GetPetCoinMultiplierInBatch( batch: {} ): number
    local multiplier: number = 1
    for index, petData in pairs( batch ) do 
        multiplier += PetHelper.GetPetCoinMultiplier(petData)
    end
    return multiplier
end

function PetHelper.GetPetPrefabByName( petName: string )
    return Knit.Assets.Content.Pets[ petName ]
end

return PetHelper