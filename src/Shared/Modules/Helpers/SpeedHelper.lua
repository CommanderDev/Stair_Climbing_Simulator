local Knit = require( game.ReplicatedStorage.Knit )

local SpeedData = require( Knit.GameData.SpeedData )

local t = require( Knit.Util.t )

local SpeedHelper = {}

local tGetSpeedByLevel = t.tuple(t.number)
function SpeedHelper.GetSpeedByLevel( speedLevel: number ): number
    assert( tGetSpeedByLevel(speedLevel) )
    return SpeedData.LevelValues[ speedLevel ]
end

local tGetPriceByLevel = t.tuple(t.number)
function SpeedHelper.GetPriceByLevel( speedLevel: number ): number
    assert( tGetPriceByLevel(speedLevel) )
    return SpeedData.Prices[ speedLevel ]
end

local tMaxSpeedReached = t.tuple(t.number)
function SpeedHelper.MaxSpeedReached( speedLevel: number ): boolean
    assert( tMaxSpeedReached(speedLevel) )
    return speedLevel >= #SpeedData.LevelValues
end

function SpeedHelper.GetNextLevelIncrease( speedLevel: number ): ( number | boolean )
    local nextLevelValue = SpeedData.LevelValues[ speedLevel + 1 ]
    if not nextLevelValue then 
        return false
    end 
    return nextLevelValue - SpeedData.LevelValues[ speedLevel ]
end

return SpeedHelper