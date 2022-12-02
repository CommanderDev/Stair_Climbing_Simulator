-- EggService
-- Author(s): Jesse Appleton
-- Date: 09/18/2022

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local RemoteSignal = require( Knit.Util.Remote.RemoteSignal )

-- Modules
local EggHelper = require( Knit.Helpers.EggHelper )
local InventoryHelper = require( Knit.Helpers.InventoryHelper )

local DataService = Knit.GetService("DataService")
-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local EggService = Knit.CreateService {
    Name = "EggService";
    Client = {
        AutoDeleteToggled = RemoteSignal.new();
    };
}


function EggService.Client:PurchaseEgg( player: Player, listName: string )
    return self.Server:PurchaseEgg(player, listName)
end

function EggService:PurchaseEgg( player: Player, listName: string ): {}
    local playerData = DataService:GetPlayerDataAsync(player).Data
    local price = EggHelper.GetDataByName(listName).Price
    if ( playerData.Coins < price ) then return end
    local rolledEgg = EggHelper.RollEggFromList(listName)
    local success, petData = InventoryHelper.AddToInventory(playerData.Pets, {
        Name = rolledEgg.Name;
        _equipped = false;
        Level = 1;
        Experience = 0;
    })
    DataService:ReplicateTableIndex(player, "Pets", petData.GUID)
    DataService:IncrementPlayerData(player, "Coins", -price)
    return rolledEgg
end

function EggService:KnitStart(): ()
    self.Client.AutoDeleteToggled:Connect(function()
    
    end)
end


function EggService:KnitInit(): ()
    
end


return EggService