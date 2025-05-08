-- Fly Script com Botões de Interface (LocalScript)
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

-- Fly lógica
local flying = false
local speed = 80
local keysDown = {}
local bodyVelocity

local function startFlying()
	if flying then return end
	flying = true

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.Parent = humanoidRootPart
end

local function stopFlying()
	flying = false
	if bodyVelocity then
		bodyVelocity:Destroy()
	end
end

-- Toggle pelo botão
flyButton.MouseButton1Click:Connect(function()
	if flying then
		stopFlying()
		flyButton.Text = "Ativar Fly"
	else
		startFlying()
		flyButton.Text = "Desativar Fly"
	end
end)

-- Controles
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	keysDown[input.KeyCode] = true
end)

UserInputService.InputEnded:Connect(function(input)
	keysDown[input.KeyCode] = false
end)

-- Loop de movimento
RunService.RenderStepped:Connect(function()
	if not flying or not bodyVelocity then return end

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
		bodyVelocity.Velocity = moveDir.Unit * speed
	else
		bodyVelocity.Velocity = Vector3.zero
	end
end)
