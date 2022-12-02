-- SpeedService
-- Author(s): Jesse Appleton
-- Date: 09/02/2022

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local RemoteSignal = require( Knit.Util.Remote.RemoteSignal )
local DataService = Knit.GetService("DataService")
local SpeedHelper = require( Knit.Helpers.SpeedHelper )

-- Roblox Services

-- Variables

-- Objects
local Overhead = game.ReplicatedStorage.Assets.General.UI.Overhead

---------------------------------------------------------------------


local SpeedService = Knit.CreateService {
    Name = "SpeedService";
    Client = {
        IncreaseLevel = RemoteSignal.new();
    };
}


function SpeedService:UpdatePlayerSpeed( player: Player )
    local playerData = DataService:GetPlayerDataAsync(player).Data
    local speed = SpeedHelper.GetSpeedByLevel(playerData.Speed)
    local humanoid = player.Character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = speed
end

function SpeedService:KnitStart(): ()
    self.Client.IncreaseLevel:Connect(function(player)
        local playerData = DataService:GetPlayerDataAsync(player).Data
        local price = SpeedHelper.GetPriceByLevel(playerData.Speed)
        if playerData.Coins < price or SpeedHelper.MaxSpeedReached(playerData.Speed) then return end
        DataService:IncrementPlayerData(player, "Speed", 1)
        DataService:IncrementPlayerData(player, "Coins", -price)
        self:UpdatePlayerSpeed(player)
    end)
end


function SpeedService:KnitInit(): ()
    
    local function OnCharacterAdded( character: Model )
        local player = game.Players:GetPlayerFromCharacter(character)
        self:UpdatePlayerSpeed(player)
        local overhead = Overhead:Clone()

        local function UpdateSpeed(speedLevel: number): ()
            local currentSpeed = SpeedHelper.GetSpeedByLevel(speedLevel)
            overhead.Speed.Text = "Speed: "..currentSpeed
        end

        local function UpdateSteps( steps: number ): ()
            overhead.Steps.Text = "Steps: "..steps
        end
        
        UpdateSpeed( DataService:GetPlayerDataAsync(player).Data.Speed)
        UpdateSteps( DataService:GetPlayerDataAsync(player).Data.Steps)
        DataService:GetDataChangedSignal("Speed", player):Connect(UpdateSpeed)
        DataService:GetDataChangedSignal("Steps", player):Connect(UpdateSteps)
        overhead.Parent = character:WaitForChild("Head")
    end

    local function OnPlayerAdded( player: Player ): ()
        if player.Character then 
            OnCharacterAdded(player.Character)
        end
        player.CharacterAdded:Connect(OnCharacterAdded)
    end

    for index, player: Player in pairs( game.Players:GetPlayers() ) do 
        OnPlayerAdded(player)
    end

    game.Players.PlayerAdded:Connect(OnPlayerAdded)
end


return SpeedService