-- Coins
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
local DataController = Knit.GetController("DataController")
local UIController = Knit.GetController("UIController")

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local Coins = {}
Coins.__index = Coins


function Coins.new( holder ): ( {} )
    local self = setmetatable( {}, Coins )
    self._janitor = Janitor.new()

    local function UpdateText( coins: number ): ()
        holder.Label.Text = coins
    end

    DataController:ObserveDataChanged("Coins", UpdateText)
    return self
end


function Coins:Destroy(): ()
    self._janitor:Destroy()
end


return Coins