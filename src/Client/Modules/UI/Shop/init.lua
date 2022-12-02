-- init
-- Author(s): Jesse Appleton
-- Date: 09/02/2022

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Janitor = require( Knit.Util.Janitor )
local Promise = require( Knit.Util.Promise )

-- Modules
local ShopList = require( script.ShopList )
local UIController = Knit.GetController("UIController")

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local Shop = {}
Shop.__index = Shop


function Shop.new( holder: Frame ): ( {} )
    local self = setmetatable( {}, Shop )
    self._janitor = Janitor.new()

    ShopList.new( holder:WaitForChild("List") )

    local function OnScreenChanged( newScreen: string ): ()
        holder.Visible = if newScreen == "Shop" then true else false 
    end

    UIController.ScreenChanged:Connect( OnScreenChanged )
    
    return self
end

function Shop:Destroy(): ()
    self._janitor:Destroy()
end


return Shop