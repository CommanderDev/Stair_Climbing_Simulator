-- Sell
-- Author(s): Jesse Appleton
-- Date: 09/17/2022

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Players = game:GetService("Players")
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Janitor = require( Knit.Util.Janitor )
local Promise = require( Knit.Util.Promise )

-- Modules
local ZoneHelper = require( Knit.Helpers.ZoneHelper )

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local Sell = {}
Sell.__index = Sell


function Sell.new( holder: ImageButton ): ( {} )
    local self = setmetatable( {}, Sell )
    self._janitor = Janitor.new()

    local function OnButtonClick(): ()
        local playerZone = ZoneHelper.GetLocalPlayerZone()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = playerZone.Sell.CFrame
    end

    holder.MouseButton1Click:Connect( OnButtonClick )
    return self
end


function Sell:Destroy(): ()
    self._janitor:Destroy()
end


return Sell