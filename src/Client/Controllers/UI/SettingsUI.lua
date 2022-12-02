-- SettingsUI
-- Author(s): Jesse Appleton
-- Date: 09/17/2022

--[[
    
]]

---------------------------------------------------------------------


-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local SettingsPanel = require( Knit.Modules.UI.SettingsPanel )

-- Roblox Services

-- Variables

-- Objects
local SettingsPanelFrame: Frame = Knit.MainUI:WaitForChild("SettingsPanel")

---------------------------------------------------------------------

local SettingsUI = Knit.CreateController { Name = "SettingsUI" }


function SettingsUI:KnitStart(): ()
    SettingsPanel.new( SettingsPanelFrame )
end


function SettingsUI:KnitInit(): ()
    
end


return SettingsUI