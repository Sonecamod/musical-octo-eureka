-- Fly Script funcional com botão de ativar/desativar
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Criar GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FlyGui"

local flyButton = Instance.new("TextButton", screenGui)
flyButton.Size = UDim2.new(0, 100, 0, 40)
flyButton.Position = UDim2.new(0, 20, 0, 100)
flyButton.Text = "Ativar Fly"
flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.Font = Enum.Font.SourceSansBold
flyButton.TextSize = 18

-- Lógica do fly
local flying = false
local speed = 80
local keysDown = {}
local bodyGyro, bodyVelocity

-- Início do voo
local function startFlying()
	if flying then return end
	flying = true

	-- Criar BodyGyro e BodyVelocity
	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	bodyGyro.P = 1e4
	bodyGyro.CFrame = humanoidRootPart.CFrame
	bodyGyro.Parent = humanoidRootPart

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.Parent = humanoidRootPart

	player.Character:WaitForChild("Humanoid").PlatformStand = true
end

-- Fim do voo
local function stopFlying()
	flying = false
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end
	player.Character:WaitForChild("Humanoid").PlatformStand = false
end

-- Alternar fly com botão
flyButton.MouseButton1Click:Connect(function()
	if flying then
		stopFlying()
		flyButton.Text = "Ativar Fly"
	else
		startFlying()
		flyButton.Text = "Desativar Fly"
	end
end)

-- Captura de teclas
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	keysDown[input.KeyCode] = true
end)

UserInputService.InputEnded:Connect(function(input)
	keysDown[input.KeyCode] = false
end)

-- Loop de movimento
RunService.RenderStepped:Connect(function()
	if flying and bodyVelocity and bodyGyro then
		local cam = workspace.CurrentCamera
		local moveDir = Vector3.zero

		if keysDown[Enum.KeyCode.W] then
			moveDir += cam.CFrame.LookVector
		end
		if keysDown[Enum.KeyCode.S] then
			moveDir -= cam.CFrame.LookVector
		end
		if keysDown[Enum.KeyCode.A] then
			moveDir -= cam.CFrame.RightVector
		end
		if keysDown[Enum.KeyCode.D] then
			moveDir += cam.CFrame.RightVector
		end
		if keysDown[Enum.KeyCode.Space] then
			moveDir += Vector3.new(0, 1, 0)
		end
		if keysDown[Enum.KeyCode.LeftShift] then
			moveDir -= Vector3.new(0, 1, 0)
		end

		if moveDir.Magnitude > 0 then
			moveDir = moveDir.Unit
		end

		bodyVelocity.Velocity = moveDir * speed
		bodyGyro.CFrame = cam.CFrame
	end
end)
