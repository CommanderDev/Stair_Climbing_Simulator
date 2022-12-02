local Knit = require( game.ReplicatedStorage.Knit )

local ZoneData = require( Knit.GameData.ZoneData )
local t = require( Knit.Util.t )

local Map: Folder = workspace:WaitForChild("Map")
local Zones: Folder =  Map:WaitForChild("Zones")

local ZoneHelper = {}

function ZoneHelper.GetZoneLevelByName( name: string ): number
    for level, zoneData in pairs( ZoneData ) do 
        if zoneData.Name == name then 
            return level
        end
    end
end

function ZoneHelper.GetRequiredRebirthsByName( name: string ): number
    for level, zoneData in pairs( ZoneData ) do 
        if zoneData.Name == name then 
            return zoneData.RequiredRebirths
        end
    end
end

function ZoneHelper.GetZoneFolderByLevel( level: string ): Folder
    local levelData = ZoneData[level]
    print(level, levelData, Zones:GetChildren())
    return Zones[ levelData.Name ]
end

function ZoneHelper.GetZoneFolderByName( name: string ): Folder
    return Zones[ name ]
end

function ZoneHelper.GetDataByName( name: string ): {}
    for index, zoneData in pairs( ZoneData ) do 
        if zoneData.Name == name then 
            return zoneData
        end
    end
end

local raycastParams = RaycastParams.new()
raycastParams.IgnoreWater = true
raycastParams.FilterDescendantsInstances = {workspace.Map.Zones}
raycastParams.FilterType = Enum.RaycastFilterType.Whitelist

function ZoneHelper.GetLocalPlayerZone(): Folder
    local ray = workspace:Raycast(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, Vector3.new(0,-5,0), raycastParams)
    if not ray then 
        return workspace.Map.Zones.Starter
    end
    local path = string.split(ray.Instance:GetFullName(), ".")
    for i, v in pairs( path ) do 
        if v == "Zones" then 
            return path[ i + 1 ]
        end
    end
end

return ZoneHelper