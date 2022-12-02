
--[[
    
]]

---------------------------------------------------------------------

-- Constants
local UPDATE_TIME_RANGE = NumberRange.new( (1/60), 0.6 )

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Timer = require( Knit.Util.Timer )
local t = require( Knit.Util.t )

-- Knit Services
local CharacterService = Knit.GetService( "CharacterService" )
local DataService = Knit.GetService( "DataService" )
local LevelingService = Knit.GetService( "LevelingService" )

-- Roblox Services
local Players = game:GetService( "Players" )
local RunService = game:GetService( "RunService" )

-- Variables

---------------------------------------------------------------------


local StepService = Knit.CreateService {
    Name = "StepService";
    Client = {};

    _lastStepUpdates = {};
    _lastPositionUpdates = {};
}

function StepService:KnitStart(): ()
    -- Loop through all moving players and increment their steps by 1

    local minTime: number = UPDATE_TIME_RANGE.Min
    local timeRange: number = ( UPDATE_TIME_RANGE.Max - minTime )
    local function GetUpdateTimeFromPercent( percent: number ): ( number )
        return minTime + ( timeRange * (1-percent) )
    end

    local function IncrementPlayerSteps( player: Player ): ()
    
        if not player.Character then return end
        local lastStepUpdate: number = self._lastStepUpdates[ player ] or 0
        if not self._lastPositionUpdates[ player ] then 
            self._lastPositionUpdates[ player ] = player.Character.HumanoidRootPart.Position
        end
        local lastPositionUpdate: Vector3 = self._lastPositionUpdates[ player ]
        local playerPosition: Vector3 = player.Character.HumanoidRootPart.Position
        if ( ( playerPosition-lastPositionUpdate).Magnitude >= 10 ) then
            self._lastStepUpdates[ player ] = os.clock()
            self._lastPositionUpdates[ player ] = player.Character.HumanoidRootPart.Position
            local profile = DataService:GetPlayerDataAsync( player )
            if ( not profile ) then return end

            DataService:SetPlayerData( player, "Steps", profile.Data.Steps + 1 )
        end
    end

    local function IncrementSteps(): ()
        debug.profilebegin( "IncrementSteps" )
        for _, player: Player in pairs( Players:GetPlayers() ) do
            task.spawn( IncrementPlayerSteps, player )
        end
        debug.profileend()
    end
    RunService.Stepped:Connect( IncrementSteps )


    local function OnPlayerRemoving( player: Player ): ()
        self._lastStepUpdates[ player ] = nil
    end
    Players.PlayerRemoving:Connect( OnPlayerRemoving )
end


function StepService:KnitInit(): ()
    
end


return StepService