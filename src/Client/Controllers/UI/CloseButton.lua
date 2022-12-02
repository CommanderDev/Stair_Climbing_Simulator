-- CloseButton
-- Author(s): Jesse Appleton
-- Date: 06/12/2022

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Janitor = require( Knit.Util.Janitor )
local Promise = require( Knit.Util.Promise )

-- Modules

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local CloseButton = {}
CloseButton.__index = CloseButton


function CloseButton.new( holder: TextButton | ImageButton, container: Frame | ScreenGui, callback ): ( {} )
    local self = setmetatable( {}, CloseButton )
    self._janitor = Janitor.new()

    local function OnButtonClick(): ()
        if container:IsA("ScreenGui") then 
            container.Enabled = true
        else
            container.Visible = false
        end
        if callback then
            callback()
        end
    end

    holder.MouseButton1Click:Connect( OnButtonClick )

    return self
end


function CloseButton:Destroy(): ()
    self._janitor:Destroy()
end


return CloseButton