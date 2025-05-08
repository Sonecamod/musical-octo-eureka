-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Interface
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FlyGui"

-- Botão Fly
local flyButton = Instance.new("TextButton", screenGui)
flyButton.Size = UDim2.new(0, 120, 0, 40)
flyButton.Position = UDim2.new(0, 20, 0, 100)
flyButton.Text = "Ativar Fly"
flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.Font = Enum.Font.SourceSansBold
flyButton.TextSize = 18

-- Slider
local sliderFrame = Instance.new("Frame", screenGui)
sliderFrame.Size = UDim2.new(0, 120, 0, 25)
sliderFrame.Position = UDim2.new(0, 20, 0, 150)
sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local sliderBar = Instance.new("Frame", sliderFrame)
sliderBar.Size = UDim2.new(0.5, 0, 1, 0)
sliderBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

-- Variáveis
local flying = false
local dragging = false
local speed = 100
local maxSpeed = 200
local bodyGyro, bodyVelocity

-- Atualizar velocidade
local function updateSlider(inputPosition)
	local x = math.clamp((inputPosition.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
	sliderBar.Size = UDim2.new(x, 0, 1, 0)
	speed = math.floor(x * maxSpeed)
end

-- Slider eventos
sliderFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		updateSlider(input.Position)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateSlider(input.Position)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

-- Ativar Fly
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
	flyButton.Text = "Desativar Fly"
end

-- Desativar Fly
local function stopFlying()
	flying = false
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end
	humanoid.PlatformStand = false
	flyButton.Text = "Ativar Fly"
end

-- Botão
flyButton.MouseButton1Click:Connect(function()
	if flying then
		stopFlying()
	else
		startFlying()
	end
end)

-- Movimento baseado na câmera
RunService.RenderStepped:Connect(function()
	if flying and bodyVelocity and bodyGyro then
		local cam = workspace.CurrentCamera
		local direction = cam.CFrame.LookVector
		bodyVelocity.Velocity = direction * speed
		bodyGyro.CFrame = cam.CFrame
	end
end)
