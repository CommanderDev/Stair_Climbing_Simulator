-- BackpackUpgrade
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
local UIController = Knit.GetController("UIController")
local DataController = Knit.GetController("DataController")
local InventoryService = Knit.GetService("InventoryService")

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local BackpackUpgrade = {}
BackpackUpgrade.__index = BackpackUpgrade


function BackpackUpgrade.new( holder: Frame ): ( {} )
    local self = setmetatable( {}, BackpackUpgrade )
    self._janitor = Janitor.new()

    local function OnInventoryLevelChanged( inventoryLevel ): ()

    end

    local function OnCloseClick()
        self:Destroy()
        UIController:SetScreen("HUD")
    end

    local function OnBackClick()
        self:Destroy()
    end

    self._janitor:Add( holder.TopBar.CloseButton.MouseButton1Click:Connect(OnCloseClick) )
    self._janitor:Add( holder.TopBar.BackButton.MouseButton1Click:Connect(OnBackClick) )

    self._janitor:Add( DataController:ObserveDataChanged("InventoryLevel", OnInventoryLevelChanged) )
    self._janitor:Add( function() 
        holder.Visible = false
    end)

    holder.Visible = true

    return self
end


function BackpackUpgrade:Destroy(): ()
    self._janitor:Destroy()
end


return BackpackUpgrade