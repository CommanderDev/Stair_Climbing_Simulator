-- UIController
-- Author(s): Jesse
-- Date: 03/01/2022

--[[
    MEMBER      UIController.UIType: string?
    SIGNAL      UIController.UITypeChanged -> ( string? )

    MEMBER      UIController.Screen: string?
    SIGNAL      UIController.ScreenChanged -> ( string? )
    FUNCTION    UIController:SetScreen( screenName: string? ) -> ()

    MEMBER      UIController.HUDEnabled: boolean
    SIGNAL      UIController.HUDEnabledChanged -> ( boolean )

    MEMBER      UIController.MenuEnabled: boolean
    SIGNAL      UIController.MenuEnabledChanged -> ( boolean )
]]

---------------------------------------------------------------------


-- Constants

-- Knit
local UserInputService = game:GetService("UserInputService")
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Signal = require( Knit.Util.Signal )

-- Modules
-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------

local UIController = Knit.CreateController {
    Name = "UIController";
    HUDEnabled = false;
    HUDEnabledChanged = Signal.new();
    Screen = "HUD";
    ScreenChanged = Signal.new();
}


function UIController:_setHUDEnabled( bool: boolean? ): ()
    bool = not not bool
    if ( self.HUDEnabled ~= bool ) then
        self.HUDEnabled = bool
        self.HUDEnabledChanged:Fire( bool )
    end
end

function UIController:SetScreen( screenName: string ): ()
    if ( self.Screen ~= screenName ) then
        self.Screen = screenName
        self.ScreenChanged:Fire( screenName )
    end
end


function UIController:KnitStart(): ()
    local function UpdateEnabledState(): ()
        local isEnabled: boolean =
            ( not self.Screen )

        self:_setHUDEnabled( isEnabled )
    end

    -- Menus? Screens? Events?
    self.ScreenChanged:Connect( UpdateEnabledState )
    task.spawn( UpdateEnabledState )

end


function UIController:KnitInit(): ()
    
end


return UIController