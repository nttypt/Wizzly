-- Triggerbot Script with Configurable Parameters

--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Camera = game:GetService("Workspace").CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// Default Configurations (can be overwritten by other scripts)
local Config = {
    TriggerbotEnabled = false, -- Start disabled (default)
    TriggerKey = Enum.UserInputType.MouseButton2, -- Trigger key to shoot (Right Mouse Button)
    ToggleKey = Enum.KeyCode.T, -- Key to toggle triggerbot on/off
    Delay = 0.1, -- Delay before shooting (to simulate reaction time)
    ShootPartName = "Head", -- The part to target (e.g., "Head")
}

--// Variables
local IsShooting = false

--// Helper Functions
local function IsValidTarget(Target)
    if not Target then return false end
    if not Target.Parent then return false end
    local Character = Target.Parent
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    return Humanoid and Humanoid.Health > 0
end

local function HasClearLineOfSight(TargetPart)
    if not TargetPart then return false end
    local Origin = Camera.CFrame.Position -- Player's camera position
    local TargetPosition = TargetPart.Position -- Position of the target part
    local ObstructingParts = Camera:GetPartsObscuringTarget({Origin, TargetPosition}, {LocalPlayer.Character}) -- Ignore the player's character
    return #ObstructingParts == 0 -- If no parts obstruct the view, return true
end

--// Triggerbot Logic
local function Triggerbot()
    if IsShooting or not Config.TriggerbotEnabled then return end
    IsShooting = true

    local Target = Mouse.Target -- The object under the crosshair
    if IsValidTarget(Target) and Target.Name == Config.ShootPartName and HasClearLineOfSight(Target) then
        wait(Config.Delay) -- Optional delay for realism
        mouse1press() -- Simulates mouse click
        wait(0.1) -- Simulates holding the mouse button
        mouse1release() -- Simulates mouse release
    end

    IsShooting = false
end

--// Toggle Key Functionality
UserInputService.InputBegan:Connect(function(Input)
    -- Check if the toggle key is pressed
    if Input.KeyCode == Config.ToggleKey then
        Config.TriggerbotEnabled = not Config.TriggerbotEnabled -- Toggle the state
        print("Triggerbot Enabled:", Config.TriggerbotEnabled) -- For feedback in the console
    end

    -- Activate the triggerbot if the trigger key is pressed
    if Input.UserInputType == Config.TriggerKey then
        Triggerbot()
    end
end)
