-- Shop
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
local ZoneHelper = require( Knit.Helpers.ZoneHelper )

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local Shop = {}
Shop.__index = Shop


function Shop.new( holder: ImageButton ): ( {} )
    local self = setmetatable( {}, Shop )
    self._janitor = Janitor.new()

    local function OnButtonClick()
        local playerZone = ZoneHelper.GetLocalPlayerZone()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = playerZone.Shop.CFrame
    end

    holder.MouseButton1Click:Connect( OnButtonClick )
    return self
end


function Shop:Destroy(): ()
    self._janitor:Destroy()
end


return Shop