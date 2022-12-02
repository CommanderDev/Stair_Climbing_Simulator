-- PetInventory
-- Author(s): Jesse Appleton
-- Date: 09/06/2022

--[[
    
]]

---------------------------------------------------------------------
--Type
type InventoryEntry = {
    GUID: string,
    Name: string,
    Level: number,
    Experience: number
}

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Janitor = require( Knit.Util.Janitor )
local Promise = require( Knit.Util.Promise )
local Create = require( Knit.Util.Create )
local CallbackQueue = require( Knit.Util.CallbackQueue )

-- Modules
local DataController = Knit.GetController("DataController")
local PetHelper = require( Knit.Helpers.PetHelper )
local RarityHelper = require( Knit.Helpers.RarityHelper )

local InventoryHelper = require( Knit.Helpers.InventoryHelper )
local PetFrame = require( script.PetFrame ) 
local ItemEntry = require( Knit.Modules.UI.ItemEntry )

-- Roblox Services

-- Variables
local UpdateQueue = CallbackQueue.new( 5 )

-- Objects

---------------------------------------------------------------------


local PetInventory = {
    Entries = {};
}

PetInventory.__index = PetInventory

function PetInventory._findOrCreateEntry( data: InventoryEntry, callback ): ()
    local guid: string = data.GUID
    local findEntry: {} = PetInventory.Entries[ guid ]
    if ( findEntry ) then
        return findEntry
    end

    local petData: {}? = PetHelper.GetDataByName( data.Name )
    local rarityData: {}? = RarityHelper.GetDataByName( petData.Rarity )
    if ( petData ) then
        local entry: {} = ItemEntry.new( true )
        PetInventory.Entries[ guid ] = entry

        entry:SetImageId( rarityData.PetBackgroundId )
        entry:SetHoverImageId( rarityData.PetHoverId )
        local petPrefab = PetHelper.GetPetPrefabByName(data.Name)
        entry:SetViewportDisplay( petPrefab, nil, CFrame.Angles(math.rad(0), math.rad(0), 0), true )
        --entry:SetLevel(data.Level)
        entry:SetName(petData.Name)

        entry._janitor:Add( entry.Button.MouseButton1Click:Connect(function()
            callback(petData, data)
        end) )
        entry.Item.Parent = PetInventory.Scroller

        return entry
    end
end

function PetInventory.new( holder: Frame, callback ): ( {} )
    local self = setmetatable( {}, PetInventory )
    self._janitor = Janitor.new()

    PetInventory.Scroller  = Create( "ScrollingFrame", {
        Name = "InventoryScroller";
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        Size = UDim2.new( 0.624, 0, 0.656, 0  );
        Position = UDim2.new(0.014, 0, 0.494, 0);
        CanvasSize = UDim2.new( 0, 0, 0, 0 );
        ScrollBarImageColor3 = Color3.new( 0, 0, 0 );
        AutomaticCanvasSize = Enum.AutomaticSize.Y;
        ScrollingDirection = Enum.ScrollingDirection.Y;
        VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
        ScrollBarThickness = 10;
        AnchorPoint = Vector2.new(0, 0.5);
        Parent = holder;
    })

    local gridLayout: UIGridLayout = Create( "UIGridLayout", {
        CellPadding = UDim2.new();
        CellSize = UDim2.new();
        FillDirection = Enum.FillDirection.Horizontal;
        HorizontalAlignment = Enum.HorizontalAlignment.Left;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = PetInventory.Scroller;
    })

    local uiPadding: UIPadding = Create( "UIPadding", {
        Parent = PetInventory.Scroller
    })

    local function UpdateEntries( petInventory: { {} })
        for entryId: string, entry: {} in pairs( PetInventory.Entries ) do
            if ( not InventoryHelper.GetInventoryEntryByGUID(petInventory, entry.GUID) ) then
                PetInventory.Entries[ entryId ] = nil
                entry:Destroy()
            end
        end

        --Update Entries
        local equippedPets: {InventoryEntry}? = DataController:GetDataByName("EquippedPets")
        local bestSelection: InventoryEntry, bestSelectionValue: number
        for _, entryData: InventoryEntry in pairs( petInventory ) do 
            local entry: {} = PetInventory._findOrCreateEntry( entryData, callback )
            entry.GUID = entryData.GUID
            entry.Data = entryData
        end

        PetInventory.Scroller.CanvasSize = UDim2.new(0, gridLayout.AbsoluteContentSize.X, 0, gridLayout.AbsoluteContentSize.Y)
    end

    local function UpdateScaling(): ()
        local sizeX: number = PetInventory.Scroller.AbsoluteCanvasSize.X
        local padding: number = math.round( sizeX * 0.01 )
        local sizeX: number = math.round( sizeX * 0.3 )
        local sizeY: number = math.round( sizeX * 0.8 )

        gridLayout.CellPadding = UDim2.new( 0, padding, 0, padding )
        gridLayout.CellSize = UDim2.new( 0, sizeX, 0, sizeY )

        uiPadding.PaddingBottom = UDim.new( 0, padding )
        uiPadding.PaddingTop = UDim.new( 0, padding )
        uiPadding.PaddingLeft = UDim.new( 0, padding )
        uiPadding.PaddingRight = UDim.new( 0, padding )
    end
    PetInventory.Scroller:GetPropertyChangedSignal( "AbsoluteSize" ):Connect( UpdateScaling )

    local function OnDataChanged(inventory)
        UpdateQueue:Add(UpdateEntries, inventory)
    end
    DataController:ObserveDataChanged("Pets", OnDataChanged)

    return self
end


function PetInventory:Destroy(): ()
    self._janitor:Destroy()
end


return PetInventory