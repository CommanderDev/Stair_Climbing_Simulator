if ( not game:IsLoaded() ) then
    game.Loaded:Wait()
end

local startTime = os.clock()

local ReplicatedStorage = game:GetService( "ReplicatedStorage" )

local Knit = require( ReplicatedStorage.Knit )

Knit.LocalPlayer = game:GetService( "Players" ).LocalPlayer
Knit.PlayerGui = Knit.LocalPlayer:WaitForChild( "PlayerGui" )
Knit.MainUI = Knit.PlayerGui:WaitForChild("Main")

local Component = require( Knit.Util.Component )

-- EXPOSE ASSETS FOLDERS
Knit.Assets = ReplicatedStorage.Assets

-- EXPOSE CLIENT MODULES
Knit.Modules = script.Parent.Modules

--EXPOSE SHARED MODULES
Knit.GameData = game.ReplicatedStorage.Shared.Data
Knit.SharedModules = game.ReplicatedStorage.Shared.Modules
Knit.Helpers = Knit.SharedModules.Helpers
Knit.Enums = require( Knit.SharedModules.Enums )
-- ENVIRONMENT SWITCHES
Knit.IsStudio = game:GetService( "RunService" ):IsStudio()
Knit.IsClient = game:GetService( "RunService" ):IsClient()
Knit.IsServer = game:GetService( "RunService" ):IsServer()

-- DISABLE HURT FLASH IN COREGUI
local StarterGui = game:GetService("StarterGui")
pcall(function()
    StarterGui:SetCoreGuiEnabled( Enum.CoreGuiType.Health, false )
    StarterGui:SetCoreGuiEnabled( Enum.CoreGuiType.Backpack, false )
end)

-- ADD CONTROLLERS
local Controllers = script.Parent.Controllers
Knit.AddControllersDeep( Controllers )
-- START
Knit:Start():andThen(function()
    print( string.format("Client Successfully Compiled! [%s ms]", math.round((os.clock()-startTime)/1000)) )
end):catch(error )