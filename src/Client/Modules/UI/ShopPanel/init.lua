-- init
-- Author(s): Jesse Appleton
-- Date: 09/16/2022

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Janitor = require( Knit.Util.Janitor )
local Promise = require( Knit.Util.Promise )

-- Modules
local BackpackUpgrade = require( script.BackpackUpgrade )
local SpeedUpgrade = require( script.SpeedUpgrade )

local UIController = Knit.GetController("UIController")

-- Roblox Services

-- Variables

-- Objects
local SpeedUpgradePanel: Frame = Knit.MainUI:WaitForChild("SpeedUpgradePanel")
local BackpackUpgradePanel: Frame = Knit.MainUI:WaitForChild("BackpackUpgradePanel")
---------------------------------------------------------------------


local ShopPanel = {}
ShopPanel.__index = ShopPanel


function ShopPanel.new( holder: Frame ): ( {} )
    local self = setmetatable( {}, ShopPanel )
    self._janitor = Janitor.new()

    local function OnScreenChanged( screenName: string ): ()
        holder.Visible = if screenName == "Shop" then true else false
    end

    local MainShop: Frame = holder:WaitForChild("MainShop")
    local SpeedButton: ImageButton = MainShop:WaitForChild("SpeedButton")
    local BackpackButton: ImageButton = MainShop:WaitForChild("BackpackButton")

    local function OnSpeedClick(): ()
        SpeedUpgrade.new( SpeedUpgradePanel )
    end

    local function OnBackpackClick(): ()
        BackpackUpgradePanel.new( BackpackUpgradePanel )
    end

    local function OnCloseClick(): ()
        UIController:SetScreen("HUD")
    end

    holder.TopBar.CloseButton.MouseButton1Click:Connect( OnCloseClick )
    SpeedButton.MouseButton1Click:Connect( OnSpeedClick )
    UIController.ScreenChanged:Connect( OnScreenChanged )
    return self
end


function ShopPanel:Destroy(): ()
    self._janitor:Destroy()
end


return ShopPanel