-- HUD
-- Author(s): Jesse Appleton
-- Date: 09/02/2022

--[[
    
]]

---------------------------------------------------------------------


-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local HUDCoins = require( Knit.Modules.UI.HUDCoins )
local HUDOrbs = require( Knit.Modules.UI.HUDOrbs )
local HUDRebirths = require( Knit.Modules.UI.HUDRebirths )
local HUDSteps = require( Knit.Modules.UI.HUDSteps )

-- Roblox Services

-- Variables
-- Objects
local SideDisplays: Frame = Knit.MainUI:WaitForChild("SideDisplays")
local CoinsDisplay: Frame = SideDisplays:WaitForChild("CoinsDisplay")
local OrbsDisplay: Frame = SideDisplays:WaitForChild("OrbsDisplay")
local RebirthsDisplay: Frame = SideDisplays:WaitForChild("RebirthsDisplay")
local StepsDisplay: Frame = SideDisplays:WaitForChild("StepsDisplay")
---------------------------------------------------------------------

local HUD = Knit.CreateController { Name = "HUD" }


function HUD:KnitStart(): ()
    HUDCoins.new( CoinsDisplay )
    HUDOrbs.new( OrbsDisplay )
    HUDRebirths.new( RebirthsDisplay )
    HUDSteps.new( StepsDisplay )
end


function HUD:KnitInit(): ()
    
end


return HUD