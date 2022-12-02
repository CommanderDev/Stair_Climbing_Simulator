-- init
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
local PetInventory = require( script.PetInventory )
local PetInfo = require( script.PetInfo )
local UIController = Knit.GetController("UIController")
local DataController = Knit.GetController("DataController")
local InventoryHelper = require( Knit.Helpers.InventoryHelper )
local PetHelper = require( Knit.Helpers.PetHelper )
local PetService = Knit.GetService("PetService")

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local PetsPanel = {}
PetsPanel.__index = PetsPanel


function PetsPanel.new( holder: Frame ): ( {} )
    local self = setmetatable( {}, PetsPanel )
    self._janitor = Janitor.new()

    local petInfo = PetInfo.new( holder:WaitForChild("PetInfo") )

    PetInventory.new( holder, function(petData, pet)
        petInfo:SetPet( petData, pet )
    end)

    local function OnCloseClick(): ()
        UIController:SetScreen("HUD")
    end

    local function OnScreenChanged( newScreen: string ): ()
        holder.Visible = if newScreen == "Pets" then true else false
    end

    local function PetDataChanged( inventory: {} ): ()
        local petCount = InventoryHelper.CountInventoryEntries(inventory)
        local equippedPets = InventoryHelper.CountInventoryEntriesWithFilter(inventory, {
            _equipped = true;
        })
        holder.TopBar.PetInventory.ButtonLabel.Text = petCount.."/"..PetHelper.GetPlayerMaxPets()   
        holder.TopBar.EquippedPets.ButtonLabel.Text = equippedPets.."/"..PetHelper.GetPlayerMaxEquipped()
    end

    local function EquipBestPet(): ()
        local bestPet = InventoryHelper.GetHighestLevelEntry( DataController:GetDataByName("Pets"))
        if bestPet._equipped then return end
        PetService.TogglePetEquip:Fire(bestPet)
    end

    local BottomButtons: Frame = holder:WaitForChild("BottomBar"):WaitForChild("Buttons")
    BottomButtons:WaitForChild("EquipBestButton").MouseButton1Click:Connect( EquipBestPet )
    holder:WaitForChild("TopBar"):WaitForChild("CloseButton").MouseButton1Click:Connect( OnCloseClick )
    UIController.ScreenChanged:Connect( OnScreenChanged)
    DataController:ObserveDataChanged("Pets", PetDataChanged)
    return self
end


function PetsPanel:Destroy(): ()
    self._janitor:Destroy()
end


return PetsPanel