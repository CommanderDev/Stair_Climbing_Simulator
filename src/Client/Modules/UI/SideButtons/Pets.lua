-- Pets
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


local Pets = {}
Pets.__index = Pets


function Pets.new( holder: ImageButton ): ( {} )
    local self = setmetatable( {}, Pets )
    self._janitor = Janitor.new()

    local function OnButtonClick(): ()
        UIController:SetScreen("Pets")
    end

    holder.MouseButton1Click:Connect( OnButtonClick )
    return self
end


function Pets:Destroy(): ()
    self._janitor:Destroy()
end


return Pets