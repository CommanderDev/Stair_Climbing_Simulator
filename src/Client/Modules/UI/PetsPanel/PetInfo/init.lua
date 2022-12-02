-- PetInfo
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
local ViewportManager = require( Knit.Modules.ViewportManager )
local RarityHelper = require( Knit.Helpers.RarityHelper )
local PetService = Knit.GetService("PetService")
local InventoryHelper = require( Knit.Helpers.InventoryHelper )
local PetHelper = require( Knit.Helpers.PetHelper )
local DataController = Knit.GetController("DataController")

-- Roblox Services

-- Variables

-- Objects
local Pets: Folder = Knit.Assets:WaitForChild("Content"):WaitForChild("Pets")
---------------------------------------------------------------------


local PetInfo = {}
PetInfo.__index = PetInfo


function PetInfo.new( holder: Frame ): ( {} )
    local self = setmetatable( {}, PetInfo )
    self._janitor = Janitor.new()

    self._holder = holder

    self._viewport = nil
    self.ViewportFrame = holder:WaitForChild("ViewportFrame")
    self.PetRarities = holder:WaitForChild("PetRarities"):WaitForChild("Container")
    self.Buttons = holder:WaitForChild("Buttons")

    local function UpdateEquipInfo(isEquipped: boolean)
        if not isEquipped then
            self.Buttons.EquipButton.ButtonLabel.Text = "Equip";
        else
            self.Buttons.EquipButton.ButtonLabel.Text = "Un-Equip"
        end
        self.playerPetData._equipped = isEquipped
    end

    local function OnEquipClick(): ()
        print("Equip clicked!")
        local petEquippedCount = InventoryHelper.CountInventoryEntriesWithFilter(DataController:GetDataByName("Pets"), {
            _equipped = true
        })

        if not self.playerPetData or ( petEquippedCount == PetHelper.GetPlayerMaxEquipped() and not self.playerPetData._equipped) then return end
        self.playerPetData._equipped = not self.playerPetData._equipped
        UpdateEquipInfo(self.playerPetData._equipped)
        PetService.TogglePetEquip:Fire(self.playerPetData.GUID)
    end

    local function OnPetsChanged(inventory): ()
        if not self.playerPetData then 
            return
        end

        self.playerPetData = inventory[ self.playerPetData.GUID ]
        if not self.playerPetData then return end
        UpdateEquipInfo(self.playerPetData._equipped)
    end

    self.Buttons.EquipButton.MouseButton1Click:Connect( OnEquipClick )

    DataController:ObserveDataChanged("Pets", OnPetsChanged)
    return self
end

function PetInfo:SetPet( petData: {}, playerPetData: {} )
    self._holder.Visible = true
    if self._viewport then
        self._viewport:Destroy()
    end
    local rarity = RarityHelper.GetDataByName(petData.Rarity)
    local pet: Model = Pets[ petData.Name ]:Clone()
    self.PetRarities.Backdrop.Image = "rbxassetid://".. rarity.PetBackgroundId
    self.PetRarities.RarityLabel.Text = petData.Rarity
    self._viewport = ViewportManager.new(self.ViewportFrame, {})
    self._viewport:SetDisplay(pet,CFrame.new(Vector3.new(0,0,-2), pet.PrimaryPart.Position))

    if playerPetData._equipped then 
        self.Buttons.EquipButton.ButtonLabel.Text = "Un-Equip" 
    else
        self.Buttons.EquipButton.ButtonLabel.Text = "Equip"
    end

    self._holder.CoinRate.ButtonLabel.Text = PetHelper.GetPetCoinMultiplier(playerPetData).."X"
    self._holder.PetName.Text = playerPetData.Name
    self.playerPetData = playerPetData
end

function PetInfo:Destroy(): ()
    self._janitor:Destroy()
end


return PetInfo