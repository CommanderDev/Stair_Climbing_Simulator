-- StatService
-- Author(s): Jesse Appleton
-- Date: 11/30/2022

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local DataService = Knit.GetService("DataService")

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local StatService = Knit.CreateService {
    Name = "StatService";
    Client = {
        
    };
}


function StatService:KnitStart(): ()  
    DataService.PlayerDataLoaded:Connect(function(player, profile )
        local leaderstats = Instance.new("IntValue")
        leaderstats.Name = "leaderstats"
        leaderstats.Parent = player
        local steps = Instance.new("IntValue")
        steps.Value = profile.Data.Steps
        steps.Name = "Steps"
        steps.Parent = leaderstats
        while task.wait(3) do
            steps.Value = profile.Data.Steps
        end
    end)
end


function StatService:KnitInit(): ()
    
end


return StatService