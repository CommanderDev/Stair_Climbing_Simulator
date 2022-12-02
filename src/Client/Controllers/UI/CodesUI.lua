-- CodesController
-- Author(s): Jesse Appleton
-- Date: 09/17/2022

--[[
    
]]

---------------------------------------------------------------------


-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local CodesPanel = require( Knit.Modules.UI.CodesPanel )

-- Roblox Services

-- Variables

-- Objects
local CodesPanelFrame: Frame = Knit.MainUI:WaitForChild("CodesPanel")

---------------------------------------------------------------------

local CodesController = Knit.CreateController { Name = "CodesController" }


function CodesController:KnitStart(): ()
    CodesPanel.new( CodesPanelFrame )
end


function CodesController:KnitInit(): ()
    
end


return CodesController