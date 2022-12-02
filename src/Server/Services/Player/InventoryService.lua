-- InventoryService
-- Author(s): Jesse Appleton
-- Date: 09/02/2022

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local RemoteSignal = require( Knit.Util.Remote.RemoteSignal )
local OrbHelper = require( Knit.Helpers.OrbHelper )
local DataService = Knit.GetService("DataService")
-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local InventoryService = Knit.CreateService {
    Name = "InventoryService";
    Client = {
        AddInventorySlots = RemoteSignal.new();
    };
}


function InventoryService:KnitStart(): ()
    self.Client.AddInventorySlots:Connect(function(player)
        local playerData = DataService:GetPlayerDataAsync(player).Data
        local price = OrbHelper.GetInventorySlotPriceByLevel(playerData.InventoryLevel + 1)
        if OrbHelper.MaxInventorySlotsReached(playerData.InventoryLevel) or playerData.Coins < price then return end
        DataService:IncrementPlayerData(player, "InventoryLevel", 1)
        DataService:IncrementPlayerData(player, "Coins", -price)
    end)
end


function InventoryService:KnitInit(): ()
    
end


return InventoryService