-- ZoneController
-- Author(s): Jesse Appleton
-- Date: 09/03/2022

--[[
    
]]

---------------------------------------------------------------------


-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local DataController = Knit.GetController("DataController")
local ZoneHelper = require( Knit.Helpers.ZoneHelper )
local ZoneService = Knit.GetService("ZoneService")
-- Roblox Services
local TweenService = game:GetService("TweenService")
-- Variables
local tweens = {}
local doorSize
local tweenInfo = TweenInfo.new(1)
-- Objects
local Map: Folder = workspace:WaitForChild("Map")
local Zones: Folder = Map:WaitForChild("Zones")
---------------------------------------------------------------------

local ZoneController = Knit.CreateController { Name = "ZoneController" }

for indez, zone in pairs( Zones:GetChildren() ) do 
    local portal = zone:FindFirstChild("Portal")
    if not portal then continue end
    tweens[zone] = TweenService:Create(portal.Door, tweenInfo, {Position = Vector3.new(portal.Door.Position.X, portal.Door.Position.Y - portal.Door.Size.Y, portal.Door.Position.Z)})
    if not doorSize then 
        doorSize = portal.Door.Size
    end
end

function ZoneController:KnitStart(): ()
    
    local function SetZoneLocked( zone: Folder ): ()
        for index, object: Model | BasePart in pairs( zone:GetChildren() ) do 
            for _, child: BasePart in pairs( object:GetChildren() ) do 
                local brickColor = child:GetAttribute("UnlockedBrickColor") or object:GetAttribute("UnlockedBrickColor")
                if not brickColor then continue end
                child.BrickColor = child:GetAttribute("LockedBrickColor") or object:GetAttribute("LockedBrickColor")
            end
            local portal = object:FindFirstChild("Portal")
            if not portal then continue end
            portal.Door.Size = doorSize
            portal.Door.Transparency = 0
        end
    end

    local function SetZoneUnlocked( zone: Folder ): ()
        for index, object: Model | BasePart in pairs( zone:GetChildren() ) do 
            for _, child: BasePart in pairs( object:GetChildren() ) do 
                local brickColor = child:GetAttribute("UnlockedBrickColor") or object:GetAttribute("UnlockedBrickColor")
                if not brickColor then continue end
                child.BrickColor = brickColor
            end
            if tweens[ zone ] then 
                tweens[ zone ]:Play()
                local tweenCompleted
                tweenCompleted = tweens[ zone ].Completed:Connect(function()
                    zone.Portal.Door.Transparency = 1
                    tweenCompleted:Disconnect()
                end)
            end
        end
    end

    local function UpdateZoneColors( rebirths: number ): ()
        for index, zone in pairs( Zones:GetChildren() ) do
            print(zone)
            local requiredRebirths = ZoneHelper.GetRequiredRebirthsByName(zone.Name)
            if rebirths >= requiredRebirths then 
                SetZoneUnlocked(zone)
            else
                SetZoneLocked(zone)
            end
        end
    end

    local function OnRebirthsChanged( rebirths: number ): ()
        for index, zone in pairs( Zones:GetChildren() ) do 
            local zoneData = ZoneHelper.GetDataByName(zone.Name)
            local UnlockedZones = DataController:GetDataByName("UnlockedZones")
            if not table.find(UnlockedZones, zone.Name) and rebirths >= zoneData.RequiredRebirths then 
                local level = ZoneHelper.GetZoneLevelByName(zone.Name)
                local floor = ZoneHelper.GetZoneFolderByLevel(level).Floor
                local connections = {}
                for index, part in pairs( floor:GetChildren() ) do 
                    table.insert(connections, part.Touched:Connect(function()
                        for index, connection in pairs( connections ) do 
                            connection:Disconnect()
                        end
                        SetZoneUnlocked(zone)
                        ZoneService.ZoneUnlocked:Fire(zone.Name)
                    end) )
                end
            end
        end
    end
    UpdateZoneColors(DataController:GetDataByName("Rebirths"))
    DataController:ObserveDataChanged("Rebirths", OnRebirthsChanged)
end


function ZoneController:KnitInit(): ()
    
end


return ZoneController