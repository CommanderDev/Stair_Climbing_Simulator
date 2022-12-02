return function(Part: BasePart, Offset: number, Color: Color3, Transparency: number)
	local Attachment0 = Instance.new('Attachment')
	Attachment0.Position = Vector3.new(0, Offset, 0)
	Attachment0.Parent = Part
	
	local Attachment1 = Instance.new('Attachment')
	Attachment1.Position = Vector3.new(0, -Offset, 0)
	Attachment1.Parent = Part
	
	local Trail = game.ReplicatedStorage.Assets.General.Trails.SpiralTrail:Clone()
	Trail.FaceCamera, Trail.LightInfluence, Trail.Lifetime = true, false, 0.55
	Trail.Attachment0, Trail.Attachment1 = Attachment0, Attachment1
	Trail.Brightness = 2
	Trail.Color = ColorSequence.new(Color or Color3.fromRGB(108, 168, 255))
	Trail.WidthScale = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.5, 1), NumberSequenceKeypoint.new(1, 0)})
	Trail.Transparency = NumberSequence.new(Transparency)
	Trail.Parent = Part
	return Trail
end