-- ZoneService
-- Author(s): Jesse Appleton
-- Date: 09/03/2022

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local RemoteSignal = require( Knit.Util.Remote.RemoteSignal )
local DataService = Knit.GetService("DataService")
local ZoneHelper = require( Knit.Helpers.ZoneHelper )

-- Roblox Services

-- Variables

-- Objects
local Zones: Folder = workspace.Map.Zones

---------------------------------------------------------------------


local ZoneService = Knit.CreateService {
    Name = "ZoneService";
    Client = {
        ZoneUnlocked = RemoteSignal.new();
    };
}


function ZoneService:KnitStart(): ()

    local function OnZoneUnlocked( player: Player, zoneName: string )
        local playerData = DataService:GetPlayerDataAsync(player).Data
        local zone = Zones:FindFirstChild(zoneName)
        if not zone or playerData.Rebirths < ZoneHelper.GetRequiredRebirthsByName(zoneName) then return end        
        table.insert(playerData.UnlockedZones, zone.Name)
        DataService:ReplicateTableIndex(player, "UnlockedZones", #playerData.UnlockedZones)
    end

    self.Client.ZoneUnlocked:Connect(OnZoneUnlocked)
end


function ZoneService:KnitInit(): ()
    
end


return ZoneService