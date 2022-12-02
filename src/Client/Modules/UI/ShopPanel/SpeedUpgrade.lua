-- SpeedUpgrade
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
local SpeedHelper = require( Knit.Helpers.SpeedHelper )
local DataController = Knit.GetController("DataController")
local UIController = Knit.GetController("UIController")
local SpeedService = Knit.GetService("SpeedService")
-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local SpeedUpgrade = {}
SpeedUpgrade.__index = SpeedUpgrade


function SpeedUpgrade.new( holder: Frame ): ( {} )
    local self = setmetatable( {}, SpeedUpgrade )
    self._janitor = Janitor.new()

    local function UpdatePriceLabel( speedLevel: number )
        local nextLevelIncrease: number = SpeedHelper.GetNextLevelIncrease(speedLevel)
        holder.Main.SpeedBoostValue.Visible = if nextLevelIncrease then true else false
        holder.Main.Price.Visible = if nextLevelIncrease then true else false
        holder.Main.UpgradeButton.Label.Text = if nextLevelIncrease then "Upgrade" else "Max Speed"
        holder.Main.Price.Label.Text = SpeedHelper.GetPriceByLevel(speedLevel)
        if nextLevelIncrease then 
            holder.Main.SpeedBoostValue.Text = "Boost: +"..nextLevelIncrease
        end
    end

    local function OnUpgradeClick(): ()
        SpeedService.IncreaseLevel:Fire()
    end

    local function OnCloseClick(): ()
        self:Destroy()
        UIController:SetScreen("HUD")
    end

    local function OnBackClick(): ()
        self:Destroy()
    end

    self._janitor:Add( holder.Main.UpgradeButton.MouseButton1Click:Connect(OnUpgradeClick) ) 
    self._janitor:Add( holder.TopBar.CloseButton.MouseButton1Click:Connect(OnCloseClick) )
    self._janitor:Add( holder.TopBar.BackButton.MouseButton1Click:Connect(OnBackClick) )
    self._janitor:Add( DataController:ObserveDataChanged("Speed", UpdatePriceLabel) )

    self._janitor:Add(function()
        holder.Visible = false
    end)
    
    holder.Visible = true
    return self
end


function SpeedUpgrade:Destroy(): ()
    self._janitor:Destroy()
end


return SpeedUpgrade