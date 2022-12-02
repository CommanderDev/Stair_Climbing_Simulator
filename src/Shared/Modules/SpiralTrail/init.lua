-- Services
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService')
local Debris = game:GetService('Debris')

-- Modules
local CreateTrail = require(script.CreateTrail)

local SpiralModule = { }

function SpiralModule.Init(Part: BasePart, Properties: table)
	
	-- Properties
	local Frequency = Properties.Frequency or math.huge
	
	-- Physics Properties
	local Radius = Properties.Radius or 2
	local Lifetime = Properties.Lifetime or math.huge
	local Time = Properties.Time or 0.45
	local Offset = Properties.Offset or 0.05
	
	for _ = 1, Frequency do
		local Connection
		local Index = 0
		
		-- Trail Properties
		local Size = Properties.Size or 0.275
		local Color = Properties.Color or Color3.fromRGB(255, 255, 255)
		local Transparency = Properties.Transparency or 0
		
		local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1)

		local RotationPart = Instance.new('Part')
		RotationPart.Anchored, RotationPart.CanCollide = true, false
		RotationPart.CanTouch, RotationPart.CanQuery = false, false
		RotationPart.CFrame = Part.CFrame * CFrame.new(0, -(Part.Size.Y / 2), 0)
		RotationPart.Size = Vector3.one
		RotationPart.Transparency = 1
		RotationPart.Parent = Part
		
		TweenService:Create(RotationPart, Info, {Orientation = RotationPart.Orientation + Vector3.new(0, 360, 0)}):Play()
		
		local TPart = Instance.new('Part')
		TPart.Anchored, TPart.CanCollide = true, false
		TPart.CanTouch, TPart.CanQuery = false, false
		TPart.CFrame = RotationPart.CFrame
		TPart.Size = Vector3.one
		TPart.Transparency = 1
		TPart.Parent = workspace
		local Trail = CreateTrail(TPart, Size, Color, Transparency)
		
		local NewOffset = CFrame.new()
		
		Connection = RunService.RenderStepped:Connect(function(Delta)
			Index = (Index + Delta / Lifetime) % 1
			local Alpha = 2 * math.pi * Index
			NewOffset = NewOffset * CFrame.new(0,Offset,0)
			
			RotationPart.CFrame = Part.CFrame * CFrame.new(0, -(Part.Size.Y / 2), 0) * NewOffset
			TPart.CFrame = RotationPart.CFrame * CFrame.Angles(0, Alpha, 0) * CFrame.new(0, 0, Radius)
		end)

		task.wait(1.35)
		Trail.Enabled = false
		Debris:AddItem(RotationPart, 1)
		Debris:AddItem(TPart, 1)
		
		task.wait(1)
		Connection:Disconnect()
	end
end

return SpiralModule