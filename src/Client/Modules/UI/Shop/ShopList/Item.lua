-- Item
-- Author(s): Jesse Appleton
-- Date: 09/02/2022

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local DataStoreService = game:GetService("DataStoreService")
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Janitor = require( Knit.Util.Janitor )
local Promise = require( Knit.Util.Promise )

-- Modules
local SpeedHelper = require( Knit.Helpers.SpeedHelper )
local OrbHelper = require( Knit.Helpers.OrbHelper )
local DataController = Knit.GetController("DataController")
local SpeedService = Knit.GetService("SpeedService")
local InventoryService = Knit.GetService("InventoryService")
-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local Item = {}
Item.__index = Item


function Item.new( holder: TextButton, stat: string ): ( {} )
    local self = setmetatable( {}, Item )
    self._janitor = Janitor.new()

    local data: number?
    local price: number?
    local function OnButtonClick(): ()
        if DataController:GetDataByName("Coins") < price then return end
        if stat == "Speed" then 
            local speed = DataController:GetDataByName("Speed")
            if SpeedHelper.MaxSpeedReached(speed) then return end
            SpeedService.IncreaseLevel:Fire()
            if SpeedHelper.MaxSpeedReached(speed + 1) then 
                holder.Text = "MAX SPEED"
                price = math.huge
            end
        elseif stat == "InventoryLevel" then 
            local inventoryLevel = DataController:GetDataByName("InventoryLevel")
            if OrbHelper.MaxInventorySlotsReached(inventoryLevel) then return end
            InventoryService.AddInventorySlots:Fire()
            if OrbHelper.MaxInventorySlotsReached(inventoryLevel + 1) then 
                holder.Text = "MAX INVENTORY SLOTS" 
                price = math.huge
                return
            end
        end
    end

    local function OnDataChanged( newData: number ): ()
        data = if stat == "Speed" then SpeedHelper.GetSpeedByLevel(newData + 1) else OrbHelper.GetMaxInventorySlots(newData + 1)
        price = if stat == "Speed" then SpeedHelper.GetPriceByLevel(newData + 1) else OrbHelper.GetInventorySlotPriceByLevel(newData + 1)
        if not price or not data then 
            price = math.huge
            return 
        end
        holder.Text = stat..": "..data.."  Price: "..price
    end

    holder.MouseButton1Click:Connect( OnButtonClick )
    DataController:ObserveDataChanged(stat, OnDataChanged)
    return self
end


function Item:Destroy(): ()
    self._janitor:Destroy()
end


return Item