-- OpenEggPanel
-- Author(s): Jesse Appleton
-- Date: 09/17/2022

--[[
    
]]

---------------------------------------------------------------------

-- Constants
local AutoDeleteSelected = "rbxassetid://10839338861";
local AutoDeleteUnselected = "rbxassetid://10839339190"

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Janitor = require( Knit.Util.Janitor )
local Promise = require( Knit.Util.Promise )

-- Modules
local EggHelper = require( Knit.Helpers.EggHelper )
local ViewportManager = require( Knit.Modules.ViewportManager )
local UIController = Knit.GetController("UIController")
local EggService = Knit.GetService("EggService")

-- Roblox Services

-- Variables
-- Objects
local Pets: Folder = Knit.Assets:WaitForChild("Content"):WaitForChild("Pets")
---------------------------------------------------------------------


local OpenEggPanel = {}
OpenEggPanel.__index = OpenEggPanel


function OpenEggPanel.new( holder: Frame ): ( {} )
    local self = setmetatable( {}, OpenEggPanel )
    self._janitor = Janitor.new()

    self._holder = holder

    self:SetEggList("Egg1")

    local function OnButtonClick(): ()
        UIController:SetScreen("HUD")
    end

    local function OnScreenChanged( screenName: string ): ()
        holder.Visible = if screenName == "OpenEgg" then true else false
    end

    local function OnBuyClick(): ()
        EggService:PurchaseEgg(self.listName)
    end

    local function ToggleAutoDelete(): ()
        holder.AutoDelete.Visible = not holder.AutoDelete.Visible
    end
    
    UIController.ScreenChanged:Connect(OnScreenChanged)
    holder.TopBar.CloseButton.MouseButton1Click:Connect(OnButtonClick)
    local BottomBar = holder:WaitForChild("BottomBar")
    BottomBar.Buttons.BuyButton.MouseButton1Click:Connect( OnBuyClick )
    BottomBar.Buttons.AutoDeleteButton.MouseButton1Click:Connect( ToggleAutoDelete )
    holder.AutoDelete.TopBar.CloseButton.MouseButton1Click:Connect( ToggleAutoDelete )
    
    return self
end

function OpenEggPanel:HandleAutoDelete(): ()

end

function OpenEggPanel:SetEggList( listName: string )
    self.listName = "Egg1"

    self.eggList = EggHelper.GetSortedEggListByName(self.listName)

    for index, egg in pairs( self.eggList ) do 
        local eggFrame = self._holder.Main[ index ]
        eggFrame.LayoutOrder = index
        eggFrame.Frame.Label.Text = egg.Name
        eggFrame.RarityPercentage.Text = egg.Weight.."%"
        local viewport = ViewportManager.new(eggFrame.ViewportFrame, {})
        local pet = Pets[ egg.Name ]:Clone()
        viewport:SetDisplay(pet,CFrame.new(Vector3.new(0,0,-2), pet.PrimaryPart.Position))
    end

    self._holder.BottomBar.Buttons.BuyButton.Pricetag.Text = EggHelper.GetEggPrice(listName)
    self._holder.TopBar.EggName.Text = listName
end


function OpenEggPanel:Destroy(): ()
    self._janitor:Destroy()
end


return OpenEggPanel