-- ShopList
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
local Item = require( script.Item )

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local ShopList = {}
ShopList.__index = ShopList


function ShopList.new( holder: Frame ): ( {} )
    local self = setmetatable( {}, ShopList )
    self._janitor = Janitor.new()

    Item.new(holder:WaitForChild("Speed"), "Speed")
    Item.new(holder:WaitForChild("InventorySlots"), "InventoryLevel")
    return self
end


function ShopList:Destroy(): ()
    self._janitor:Destroy()
end


return ShopList