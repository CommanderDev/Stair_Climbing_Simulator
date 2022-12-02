-- PetFrame
-- Author(s): Jesse Appleton
-- Date: 09/06/2022

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Janitor = require( Knit.Util.Janitor )
local Promise = require( Knit.Util.Promise )

-- Modules
local RarityHelper = require( Knit.Helpers.RarityHelper )
local ViewportManager = require( Knit.Modules.ViewportManager )
local DataController = Knit.GetController("DataController")

-- Roblox Services

-- Variables

-- Objects
local PetTemplate: Frame = Knit.Assets:WaitForChild("General"):WaitForChild("UI"):WaitForChild("PetTemplate")
local Pets: Folder = Knit.Assets:WaitForChild("Content"):WaitForChild("Pets")

---------------------------------------------------------------------


local PetFrame = {}
PetFrame.__index = PetFrame


function PetFrame.new( list: Frame, petData: {}, playerPetData, callback ): ( {} )
    local self = setmetatable( {}, PetFrame )
    self._janitor = Janitor.new()

    local frame: Frame = PetTemplate:Clone()
    local Button: ImageButton = frame:WaitForChild("Button")
    local RarityLabel: TextLabel = frame:WaitForChild("RarityLabel")
    local ViewportFrame: ViewportFrame = frame:WaitForChild("ViewportFrame")

    local rarity = RarityHelper.GetDataByName(petData.Rarity)

    Button.Image = "rbxassetid://".. rarity.PetBackgroundId
    Button.HoverImage = "rbxassetid://".. rarity.PetHoverId
    RarityLabel.Text = rarity.Name

    local pet = Pets[ petData.Name ]:Clone()
    local viewport = ViewportManager.new(ViewportFrame, {})
    viewport:SetDisplay(pet, CFrame.new(Vector3.new(0,0,-2), pet.PrimaryPart.Position))
    frame.Name = playerPetData.GUID
    frame:WaitForChild("LevelLabel").Text = playerPetData.Level
    frame.Parent = list

    local function OnButtonClick() 
        callback(petData, playerPetData)
    end

    Button.MouseButton1Click:Connect( OnButtonClick )
    self._janitor:Add(pet)
    self._janitor:Add(viewport)
    self._janitor:Add(frame)

    local function OnPetDataChanged( inventory ): ()
        frame.LevelLabel.Text = inventory[playerPetData.GUID].Level
    end

    DataController:ObserveDataChanged("Pets", OnPetDataChanged)
    return self
end

function PetFrame:Destroy(): ()
    self._janitor:Destroy()
end


return PetFrame