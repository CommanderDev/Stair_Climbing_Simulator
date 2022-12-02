-- RebirthsService
-- Author(s): Jesse Appleton
-- Date: 09/03/2022

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


local RebirthsService = Knit.CreateService {
    Name = "RebirthsService";
    Client = {
        
    };
}


function RebirthsService:KnitStart(): ()
end


function RebirthsService:KnitInit(): ()
    
end


return RebirthsService