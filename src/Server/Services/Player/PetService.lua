-- PetService
-- Author(s): Jesse Appleton
-- Date: 09/04/2022

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local DataService = Knit.GetService("DataService")
local InventoryHelper = require( Knit.Helpers.InventoryHelper )
local PetHelper = require( Knit.Helpers.PetHelper )
local RemoteSignal = require( Knit.Util.Remote.RemoteSignal )

-- Roblox Services
local CollectionService = game:GetService("CollectionService")
local PhysicsService = game:GetService("PhysicsService")
-- Variables
local attachmentPositions = {
    Vector3.new(0,0,4);
    Vector3.new(5,0,0);
    Vector3.new(-5,0,0);
}

-- Objects
local Pets = Knit.Assets.Content.Pets

---------------------------------------------------------------------


local PetService = Knit.CreateService {
    Name = "PetService";
    Client = {
        TogglePetEquip = RemoteSignal.new();
    };
}

local function ScaleModel(model, scale)
	
	local primary = model.PrimaryPart
	local primaryCf = primary.CFrame
	
	for _,v in pairs(model:GetDescendants()) do
		if (v:IsA("BasePart")) then
			v.Size = (v.Size * scale)
			if (v ~= primary) then
				v.CFrame = (primaryCf + (primaryCf:inverse() * v.Position * scale))
			end
		end
	end
	
	return model
	
end

function PetService:CreatePet(player, petData: {}, index: number) 
    local object = Pets[ petData.Name ]:Clone()
    object.Name = petData.GUID
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart: BasePart = character:WaitForChild("HumanoidRootPart")
    local attachment = humanoidRootPart:FindFirstChild(tostring(index))
    if not attachment then 
        attachment = Instance.new("Attachment")
        attachment.Parent = humanoidRootPart
        attachment.Name = index
        attachment.Position = attachmentPositions[ index ]
    end
    object.PrimaryPart.AlignPosition.Attachment1 = attachment
    object.PrimaryPart.AlignOrientation.Attachment1 = attachment
    object.Parent = player.Character
    CollectionService:AddTag(object, "Pet")
    for _, part in pairs( object:GetDescendants() ) do 
        if part:IsA("BasePart") then 
            PhysicsService:SetPartCollisionGroup(part, "Pet")
            part.Anchored = false
        end
    end
end

function PetService:KnitStart(): ()

    for index, object in pairs( Pets:GetChildren() ) do
        ScaleModel(object, 0.2)
        for index, part in pairs( object:GetDescendants() ) do
            if part:IsA("BasePart") then
                if part == object.PrimaryPart then
                    local attachment: Attachment = Instance.new("Attachment") 
                    local alignPosition: AlignPosition = Instance.new("AlignPosition")
                    local alignOrientation: AlignOrientation = Instance.new("AlignOrientation")   
                    alignPosition.Attachment0 = attachment
                    alignPosition.ApplyAtCenterOfMass = true
                    alignPosition.MaxForce = math.huge
                    alignPosition.MaxVelocity = math.huge
                    alignPosition.Responsiveness = 40
                    alignOrientation.Attachment0 = attachment  
                    alignOrientation.MaxTorque = math.huge
                    alignOrientation.Responsiveness = 200
                    alignOrientation.SecondaryAxis = Vector3.new(1,1,1)
                    attachment.Parent = part
                    alignPosition.Parent = part
                    alignOrientation.Parent = part
                else
                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = part
                    weld.Part1 = object.PrimaryPart 
                    weld.Parent = part
                end
            end
        end
    end
    DataService.PlayerDataLoaded:Connect(function(player: Player, profile: {})
        local data = profile.Data
        local equippedPets = InventoryHelper.GetInventoryEntryByFilter(data.Pets, {
            _equipped = true
        })
        for index: number, data in pairs( equippedPets ) do 
            self:CreatePet(player, data, index)
        end
    end)

    self.Client.TogglePetEquip:Connect(function(player, petId)
        local playerData = DataService:GetPlayerDataAsync(player).Data
        local petData = playerData.Pets[ petId ]
        
        local countPetEquipped: number = InventoryHelper.CountInventoryEntriesWithFilter(playerData.Pets, {
            _equipped = true
        })
        if countPetEquipped == PetHelper.GetPlayerMaxEquipped() and not petData._equipped then return end
        if petData then 
            if not petData._equipped then  
                local equippedPetsCount = InventoryHelper.CountInventoryEntriesWithFilter(playerData.Pets, {
                    _equipped = true;
                })
                self:CreatePet(player, petData, equippedPetsCount + 1)
            else
                player.Character[ petData.GUID ]:Destroy()
            end
            petData._equipped = not petData._equipped
            DataService:ReplicateTableIndex(player, "Pets", petData.GUID)
        end
    end)
end


function PetService:KnitInit(): ()
    
end


return PetService