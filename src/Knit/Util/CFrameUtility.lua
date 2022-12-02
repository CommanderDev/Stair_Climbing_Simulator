-- CFrameUtility
-- Author(s): serverOptimist
-- Date: 03/29/2021

--[[
    
]]

---------------------------------------------------------------------


-- Constants

-- Roblox Services
local HttpService = game:GetService( "HttpService" )

-- Variables

---------------------------------------------------------------------

local CFrameUtility = {}


function CFrameUtility.Encode( cframe: CFrame ): string?
    return HttpService:JSONEncode( cframe:GetComponents() )
end


function CFrameUtility.Decode( jsonTable: string ): CFrame?
    return CFrame.new( unpack(HttpService:JSONDecode(jsonTable)) )
end


return CFrameUtility