--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
player = game.Players.LocalPlayer
char = player.Character

for i = 1, 500  do
	part = Instance.new("Part", char)
	part.Size = Vector3.zero
	weld = Instance.new("Weld", part)
	weld.Part1 = char.HumanoidRootPart
	weld.Part0 = part
	part.CanCollide = false
	part.Size = Vector3.new(6,6,6) -- Max size so the player doesnt freeze server sided
	part.CustomPhysicalProperties = PhysicalProperties.new(100, 0, 0, 1, 10)
	part.Transparency = 1
end
