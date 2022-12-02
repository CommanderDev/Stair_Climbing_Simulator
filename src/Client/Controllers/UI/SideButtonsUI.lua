-- SideButtons
-- Author(s): YOURNAME
-- Date: 09/15/2022

--[[
    
]]

---------------------------------------------------------------------


-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local UIController = Knit.GetController("UIController")
local Sell = require( Knit.Modules.UI.SideButtons.Sell )
local Shop = require( Knit.Modules.UI.SideButtons.Shop )
local Pets = require( Knit.Modules.UI.SideButtons.Pets )
local Codes = require( Knit.Modules.UI.SideButtons.Codes )
local Settings = require( Knit.Modules.UI.SideButtons.Settings )

-- Roblox Services

-- Variables

-- Objects
local SideButtonsFrame: Frame = Knit.MainUI:WaitForChild("SideButtons")
local SellButton: ImageButton = SideButtonsFrame:WaitForChild("Sell")
local ShopButton: ImageButton = SideButtonsFrame:WaitForChild("Shop")
local PetsButton: ImageButton = SideButtonsFrame:WaitForChild("Pets")
local CodesButton: ImageButton = SideButtonsFrame:WaitForChild("Codes")
local SettingsButton: ImageButton = SideButtonsFrame:WaitForChild("Settings")

---------------------------------------------------------------------

local SideButtons = Knit.CreateController { Name = "SideButtons" }


function SideButtons:KnitStart(): ()
    Sell.new( SellButton )
    Shop.new( ShopButton )
    Pets.new( PetsButton )
    Codes.new( CodesButton )
    Settings.new( SettingsButton )
end


function SideButtons:KnitInit(): ()
    
end


return SideButtons