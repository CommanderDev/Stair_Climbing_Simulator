-- CodesPanel
-- Author(s): Jesse Appleton
-- Date: 09/17/2022

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

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local CodesPanel = {}
CodesPanel.__index = CodesPanel


function CodesPanel.new( holder: Frame ): ( {} )
    local self = setmetatable( {}, CodesPanel )
    self._janitor = Janitor.new()

    local function OnScreenChanged( screenName: string ): ()
        holder.Visible = if screenName == "Codes" then true else false
    end

    local function OnCloseClick(): ()
        UIController:SetScreen("HUD")
    end
    
    holder.TopBar.CloseButton.MouseButton1Click:Connect( OnCloseClick )
    UIController.ScreenChanged:Connect(OnScreenChanged)

    return self
end


function CodesPanel:Destroy(): ()
    self._janitor:Destroy()
end


return CodesPanel