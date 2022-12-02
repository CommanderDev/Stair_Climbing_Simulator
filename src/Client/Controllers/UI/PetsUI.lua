-- PetsUI
-- Author(s): Jesse Appleton
-- Date: 09/05/2022

--[[
    
]]

---------------------------------------------------------------------


-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local PetsPanel = require( Knit.Modules.UI:WaitForChild("PetsPanel") )

-- Roblox Services

-- Variables

-- Objects
local PetsPanelFrame: Frame = Knit.MainUI:WaitForChild("PetsPanel")

---------------------------------------------------------------------

local PetsUI = Knit.CreateController { Name = "PetsUI" }


function PetsUI:KnitStart(): ()
    PetsPanel.new( PetsPanelFrame )
end


function PetsUI:KnitInit(): ()
    
end


return PetsUI