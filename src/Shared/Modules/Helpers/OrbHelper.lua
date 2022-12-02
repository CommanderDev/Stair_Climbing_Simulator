local Knit = require( game.ReplicatedStorage.Knit )

local InventorySlotData = require( Knit.GameData.InventorySlotData )

local t = require( Knit.Util.t )

local OrbHelper = {}

local tGetMaxInventorySlots = t.tuple(t.number)
function OrbHelper.GetMaxInventorySlots( inventoryLevel: number ): number
    assert( tGetMaxInventorySlots(inventoryLevel) )
    return InventorySlotData.LevelValues[ inventoryLevel ]
end

local tInventoryIsMaxed = t.tuple(t.number, t.number)
function OrbHelper.InventoryIsMaxed( inventoryCount: number, inventoryLevel: number ): boolean
    assert( tInventoryIsMaxed(inventoryCount, inventoryLevel) )
     local maxSlots: number = OrbHelper.GetMaxInventorySlots(inventoryLevel)
     if inventoryCount >= maxSlots then
        return true
     end
     return false
end

function OrbHelper.GetInventorySlotPriceByLevel( level: number ): number 
    return InventorySlotData.Prices[ level ]
end

local tMaxInventorySlotsReached = t.tuple(t.number)
function OrbHelper.MaxInventorySlotsReached( level: number ): boolean 
    assert( tMaxInventorySlotsReached(level) )
    return level >= #InventorySlotData.LevelValues
end

return OrbHelper