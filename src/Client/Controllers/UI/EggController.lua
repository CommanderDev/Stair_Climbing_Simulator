-- EggController
-- Author(s): Jesse Appleton
-- Date: 09/17/2022

--[[
    
]]

---------------------------------------------------------------------


-- Constants
local MAX_DISTANCE = 10
-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local OpenEggPanel = require( Knit.Modules.UI.OpenEggPanel )
local UIController = Knit.GetController("UIController")

-- Roblox Services
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
-- Variables

-- Objects
local OpenEggPanelFrame: Frame = Knit.MainUI:WaitForChild("OpenEggPanel")

local LocalPlayer = game.Players.LocalPlayer 

---------------------------------------------------------------------

local EggController = Knit.CreateController { Name = "EggController" }


function EggController:KnitStart(): ()
   local openEggPanel = OpenEggPanel.new( OpenEggPanelFrame )
   
   local dispensers: { Model } = CollectionService:GetTagged("EggDispenser")
   RunService.RenderStepped:Connect(function()
      for index, dispenser in pairs( dispensers ) do 
         if ( UIController.Screen ~= "OpenEgg" and LocalPlayer:DistanceFromCharacter(dispenser.PrimaryPart.Position) < MAX_DISTANCE ) then 
            UIController:SetScreen("OpenEgg")
            return
         elseif ( UIController.Screen == "OpenEgg" and LocalPlayer:DistanceFromCharacter(dispenser.PrimaryPart.Position) > MAX_DISTANCE ) then 
            UIController:SetScreen("HUD")
         end 
      end
   end)
end


function EggController:KnitInit(): ()
    
end


return EggController