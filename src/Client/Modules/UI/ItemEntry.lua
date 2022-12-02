-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local StarterPlayer = game:GetService("StarterPlayer")
local Janitor = require( Knit.Util.Janitor )
local Create = require( Knit.Util.Create )

-- Modules
local ViewportManager = require( Knit.SharedModules.ViewportManager )

-- Roblox Services

-- Variables

-- Object
local template: Frame = Create( "Frame", {
    Name = "template";
    BackgroundColor3 = Color3.fromRGB( 75, 75, 75 );
    BackgroundTransparency = 1;
} )

local button: ImageButton = Create("ImageButton", {
    AnchorPoint = Vector2.new(0.5,0.5);
    BackgroundTransparency = 1;
    Position = UDim2.new(0.5, 0, 0.5, 0);
    Size = UDim2.new(0.997, 0, 0.995, 0);
    HoverImage = "rbxassetid://10832831232";
    Image = "rbxassetid://10832831418";
    PressedImage = "rbxassetid://10832831232";
    Name = "Button";
    Parent = template;
})

local starred: ImageButton = Create("ImageButton", {
    BackgroundTransparency = 1;
    Position = UDim2.new(0.06, 0, 0.064, 0);
    Size = UDim2.new(0.166, 0, 0.151, 0); 
    HoverImage = "rbxassetid://10833007132";
    Image = "rbxassetid://10833007407";
    PressedImage = "rbxassetid://10833007132";
    Parent = template;
})

local viewportFrame: ViewportFrame = Create( "ViewportFrame", {
    Ambient = Color3.fromRGB( 200, 200, 200 );
    LightColor = Color3.fromRGB( 140, 140, 140 );
    LightDirection = Vector3.new( -1, -1, -1 );
    BackgroundTransparency = 1;
    Size = UDim2.new( 0.749, 0, 0.596, 0 );
    Position = UDim2.new( 0.117, 0, 0.157, 0 );
    Visible = false;
    Parent = template
} )

local imageLabel: ImageLabel = Create( "ImageLabel", {
    BackgroundTransparency = 1;
    Size = UDim2.new( 0.166, 0, 0.159, 0 );
    AnchorPoint = Vector2.new( 0.5, 0.5 );
    Position = UDim2.new( 0.93, 0, 0.07, 0 );
    Image = "rbxassetid://10833007720";
    Visible = true;
    Parent = template
} )

--[[
local levelLabel: TextLabel = Create("TextLabel", {
    BackgroundTransparency = 1;
    AnchorPoint = Vector2.new(1, 0.5);
    Position = UDim2.new(0.923, 0, 0.808, 0);
    Size = UDim2.new(0.299, 0,0.24, 0);
    Font = Enum.Font.FredokaOne;
    TextScaled = true;
    TextColor3 = Color3.new(1,1,1);
    Name = "LevelLabel";
    Parent = template;
})
]]
local nameLabel: TextLabel = Create("TextLabel", {
    BackgroundTransparency = 1;
    Position = UDim2.new(0.337, 0, 0.831, 0);
    Size = UDim2.new(0.473, 0, 0.155, 0);
    AnchorPoint = Vector2.new(0.5, 0.5);
    Font = Enum.Font.FredokaOne;
    TextXAlignment = Enum.TextXAlignment.Left;
    TextScaled = true;
    TextColor3 = Color3.new(1,1,1);
    Name = "NameLabel";
    Parent = template
})

local nameUIStroke: UIStroke = Create("UIStroke", {
    Color = Color3.fromRGB(141,141,141);
    Thickness = 2;
    ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
    Parent = nameLabel;
})


---------------------------------------------------------------------


local ItemEntry = {}
ItemEntry.__index = ItemEntry


function ItemEntry.new( isButton: boolean? ): ( {} )
    local self = setmetatable( {}, ItemEntry )
    self._janitor = Janitor.new()

    local item: Frame = template:Clone()
    self._janitor:Add( button )
    button.AutoButtonColor = not not isButton
    local viewportFrame: ViewportFrame = item.ViewportFrame
    local imageLabel: ImageLabel = item.ImageLabel
    --local equippedIcon: ImageLabel = button.Equipped

    self.Item = item
    self.Viewport = viewportFrame
    self.Image = imageLabel
    self.Button = item.Button
    self.NameLabel = item.NameLabel
   -- self.LevelLabel = item.LevelLabel
    --self.EquippedIcon = equippedIcon

    self.SelectedAmbient = Color3.fromRGB( 255, 255, 255 )
    self.DefaultAmbient = Color3.fromRGB( 150, 150, 150 )
    self.DisabledAmbient = Color3.fromRGB( 0, 0, 0 )

    self.SelectedLight = Color3.fromRGB( 255, 255, 255 )
    self.DefaultLight = Color3.fromRGB( 255, 255, 255 )
    self.DisabledLight = Color3.fromRGB( 0, 0, 0 )

    --self:SetRarity( "Common" )
    --self:SetSelected( false )
    --self:SetEquipped( false )
    self:SetEnabled( true )

    return self
end

function ItemEntry:UpdateVisual()

end

function ItemEntry:SetEquipped( equipped: boolean? ): ()
    self.EquippedIcon.Visible = not not equipped
end

function ItemEntry:SetViewportDisplay( ... ): ()
    if ( not self.ViewportManager ) then
        self.ViewportManager = ViewportManager.new( self.Viewport, {FOV=10} )
        self._janitor:Add( self.ViewportManager )
    end

    self.Image.Visible = false
    self.Viewport.Visible = true

    return self.ViewportManager:SetDisplay( ... )
end


function ItemEntry:SetEnabled( enabled: boolean? ): ()
    self.Enabled = enabled
    self:UpdateVisual()

    local viewportDisplay: Model|BasePart? = self.ViewportManager and self.ViewportManager.DisplayObject
    if ( not self.Enabled ) and ( viewportDisplay ) then
        for _, object: Instance in pairs( viewportDisplay:GetDescendants() ) do
            if ( object:IsA("SurfaceAppearance") ) then
                object:Destroy()
            end
        end
    end
end


function ItemEntry:SetImageId( imageId: number ): ()
    self.Button.Image = "rbxassetid://" .. tostring( imageId )
    self.Viewport.Visible = false
    self.Image.Visible = true
end

function ItemEntry:SetHoverImageId( imageId: number): () 
    self.Button.HoverImage = "rbxassetid://".. tostring( imageId )
end


function ItemEntry:SetSelected( bool: boolean ): ()
    self.Selected = bool
   -- self:UpdateVisual()
end

--[[
function ItemEntry:SetLevel( level: number ): () 
    self.LevelLabel.Text = level
end
]]
function ItemEntry:SetName( rarity: string )
    self.NameLabel.Text = rarity
end

function ItemEntry:Destroy(): ()
    self._janitor:Destroy()
end


return ItemEntry