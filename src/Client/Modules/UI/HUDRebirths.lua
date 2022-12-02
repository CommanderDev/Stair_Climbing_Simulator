-- HUDRebirths
-- Author(s): Jesse Appleton
-- Date: 09/03/2022

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

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local HUDRebirths = {}
HUDRebirths.__index = HUDRebirths


function HUDRebirths.new( holder: Frame ): ( {} )
    local self = setmetatable( {}, HUDRebirths )
    self._janitor = Janitor.new()

    local function OnRebirthsChanged( rebirths: number )
        holder.Label.Text = rebirths
    end

    DataController:ObserveDataChanged("Rebirths", OnRebirthsChanged)
    return self
end


function HUDRebirths:Destroy(): ()
    self._janitor:Destroy()
end


return HUDRebirths