-- OrbService
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
local DataService = Knit.GetService("DataService")
local InventorySlotData = require( Knit.GameData.InventorySlotData )
local OrbHelper = require( Knit.Helpers.OrbHelper )

-- Roblox Services

-- Variables
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Whitelist
raycastParams.IgnoreWater = false
raycastParams.FilterDescendantsInstances = workspace.Map.OrbSpawners:GetChildren()

-- Objects

---------------------------------------------------------------------


local OrbService = Knit.CreateService {
    Name = "OrbService";
    Client = {
        OrbTouched = RemoteSignal.new();
    };
}


function OrbService:KnitStart(): ()
    self.Client.OrbTouched:Connect(function(player)
        local character = player.Character
        if not character then return end
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local result = workspace:Raycast(humanoidRootPart.Position, Vector3.new(0,-1000,0), raycastParams) 
        if result then 
            local OrbCost = result.Instance:GetAttribute("OrbCost")
            local playerData = DataService:GetPlayerDataAsync(player).Data
            local newOrbs = playerData.Orbs + OrbCost
            DataService:SetPlayerData(player, "Orbs", math.clamp(newOrbs, 0, OrbHelper.GetMaxInventorySlots(playerData.InventoryLevel)))
            --DataService:IncrementPlayerData(player, "Orbs", OrbCost)
        end
    end)
end


function OrbService:KnitInit(): ()
    
end


return OrbService