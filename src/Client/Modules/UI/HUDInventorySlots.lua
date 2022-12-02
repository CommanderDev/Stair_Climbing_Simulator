-- HUDInventorySlots
-- Author(s): Jesse Appleton
-- Date: 09/02/2022

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Janitor = require( Knit.Util.Janitor )
local Promise = require( Knit.Util.Promise )

-- Modules
local OrbHelper = require( Knit.Helpers.OrbHelper )
local DataController = Knit.GetController("DataController")

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local HUDInventorySlots = {}
HUDInventorySlots.__index = HUDInventorySlots


function HUDInventorySlots.new( holder: Frame ): ( {} )
    local self = setmetatable( {}, HUDInventorySlots )
    self._janitor = Janitor.new()

    local function OnDataChanged( inventoryLevel: number ): ()
        holder.SlotsLabel.Text = "Inventory Slots: "..OrbHelper.GetMaxInventorySlots(inventoryLevel)
    end

    DataController:ObserveDataChanged("InventoryLevel", OnDataChanged)
    return self
end


function HUDInventorySlots:Destroy(): ()
    self._janitor:Destroy()
end


return HUDInventorySlots