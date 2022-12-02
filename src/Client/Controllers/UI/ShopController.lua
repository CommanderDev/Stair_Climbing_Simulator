-- ShopController
-- Author(s): Jesse Appleton
-- Date: 09/02/2022

--[[
    
]]

---------------------------------------------------------------------


-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local Field = require( Knit.Util.Field )
local UIController = Knit.GetController("UIController")
local ShopPanel = require( Knit.Modules.UI.ShopPanel )

-- Roblox Services
local CollectionService = game:GetService("CollectionService")
-- Variables

-- Objects
local ShopPanelFrame: Frame = Knit.MainUI:WaitForChild("ShopPanel")

---------------------------------------------------------------------

local ShopController = Knit.CreateController { Name = "ShopController" }


function ShopController:KnitStart(): ()
    ShopPanel.new( ShopPanelFrame )
end


function ShopController:KnitInit(): ()
    local field = Field.new( CollectionService:GetTagged("Shop") )
    field.PlayerEntered:Connect(function()
        UIController:SetScreen("Shop")
    end)
    field.PlayerLeft:Connect(function()
        UIController:SetScreen("HUD")
    end)
    field:Start()

end


return ShopController