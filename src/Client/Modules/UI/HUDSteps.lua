-- HUDSteps
-- Author(s): YOURNAME
-- Date: 11/30/2022

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


local HUDSteps = {}
HUDSteps.__index = HUDSteps


function HUDSteps.new( holder: Frame ): ( {} )
    local self = setmetatable( {}, HUDSteps )
    self._janitor = Janitor.new()

    local function OnStepsChanged( steps: number )
        holder.Label.Text = steps
    end

    DataController:ObserveDataChanged("Steps", OnStepsChanged)
    return self
end


function HUDSteps:Destroy(): ()
    self._janitor:Destroy()
end


return HUDSteps