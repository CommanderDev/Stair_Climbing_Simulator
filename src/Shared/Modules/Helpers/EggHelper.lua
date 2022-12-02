local Knit = require( game.ReplicatedStorage.Knit )

local EggData = require( Knit.GameData.EggData )

local TableUtil = require( Knit.Util.TableUtil )

local EggHelper = {}

function EggHelper.GetSortedEggListByName( listName: string ): {}
    return EggData[ listName ].Eggs
end

function EggHelper.GetDataByName( listName: string ): {}
    return EggData[ listName ]
end

function EggHelper.GetEggPrice( listName: string ): {}
    return EggData[ listName ].Price
end

local EggRandom = Random.new()
function EggHelper.RollEggFromList( listName: string ): {}
    local rarityToItemData: {} = {}
    local totalRarity: number = 0
    local eggList = EggHelper.GetSortedEggListByName(listName)
    for _, itemData: {} in pairs( eggList ) do
        totalRarity += itemData.Weight
        rarityToItemData[ totalRarity ] = itemData
    end

    if ( totalRarity > 100 ) then
        error( listName ..  " total item rarity chance adds up to over 100!" )
    elseif ( totalRarity < 100 ) then
        error( listName .. " total item rarity chance adds up to less than 100!" )
    end

    local randomRoll: number = EggRandom:NextNumber( 0, 10000 ) / 100

    local selectedItemData, selectedItemRarity
    for minRarity: number, itemData: {} in pairs( rarityToItemData ) do
        if ( randomRoll <= minRarity ) and ( (not selectedItemRarity) or (selectedItemRarity > minRarity) ) then
            selectedItemData, selectedItemRarity = itemData, minRarity
        end
    end
    return selectedItemData
end


return EggHelper