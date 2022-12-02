-- Orbs
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


local Orbs = {}
Orbs.__index = Orbs


function Orbs.new( holder: Frame ): ( {} )
    local self = setmetatable( {}, Orbs )
    self._janitor = Janitor.new()

    
    local function UpdateText( orbs: number ): ()
        holder.Label.Text = orbs
    end

    DataController:ObserveDataChanged("Orbs", UpdateText)
    return self
end


function Orbs:Destroy(): ()
    self._janitor:Destroy()
end


return Orbs