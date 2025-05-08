-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Jogador
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Fly Vars
local flying = true
local speed = 100
local bodyGyro, bodyVelocity

-- Início do Fly
local function startFlying()
	if flying then return end
	flying = true

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.P = 1e4
	bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	bodyGyro.CFrame = rootPart.CFrame
	bodyGyro.Parent = rootPart

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bodyVelocity.P = 1e4
	bodyVelocity.Parent = rootPart

	humanoid.PlatformStand = true
end

-- Loop de movimento
RunService.RenderStepped:Connect(function()
	if flying and bodyVelocity and bodyGyro then
		local cam = workspace.CurrentCamera
		local moveDir = humanoid.MoveDirection

		-- Corrige o movimento para usar somente o plano XZ da câmera
		local cameraCF = cam.CFrame
		local camRight = Vector3.new(cameraCF.RightVector.X, 0, cameraCF.RightVector.Z).Unit
		local camForward = Vector3.new(cameraCF.LookVector.X, 0, cameraCF.LookVector.Z).Unit

		local flatDirection = (camRight * moveDir.X + camForward * moveDir.Z)

		-- Mantém a movimentação suave e evita NaN
		if flatDirection.Magnitude > 0 then
			flatDirection = flatDirection.Unit
		end

		bodyVelocity.Velocity = flatDirection * speed
		bodyGyro.CFrame = CFrame.new(Vector3.zero, cam.CFrame.LookVector)
	end
end)

startFlying()
