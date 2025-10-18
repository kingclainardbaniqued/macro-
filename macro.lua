-- Macro Speed Script (Improved)
-- Made by GLockz (adapted for better reliability)

local Player = game:GetService("Players").LocalPlayer
if not Player then
    warn("[Macro] LocalPlayer not found. This script must run on the client (LocalScript or executor).")
    return
end

local UserInputService = game:GetService("UserInputService")

local NormalSpeed = 16
local BoostSpeed = 50 -- change this value if you want a different speed
local SpeedOn = false
local Humanoid = nil

local function setSpeed(val)
    if Humanoid and Humanoid.Parent then
        -- protect against accidental nils
        pcall(function() Humanoid.WalkSpeed = val end)
    end
end

local function getHumanoid()
    local char = Player.Character or Player.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then
        hum = char:WaitForChild("Humanoid", 5) -- wait up to 5s for humanoid
    end
    return hum
end

-- initial humanoid
Humanoid = getHumanoid()
if not Humanoid then
    warn("[Macro] Humanoid not found on spawn.")
else
    setSpeed(NormalSpeed)
end

-- handle respawn / character change
Player.CharacterAdded:Connect(function(char)
    Humanoid = char:WaitForChild("Humanoid")
    if SpeedOn then
        setSpeed(BoostSpeed)
    else
        setSpeed(NormalSpeed)
    end
end)

-- keybind toggle (E)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.E then
        SpeedOn = not SpeedOn
        setSpeed(SpeedOn and BoostSpeed or NormalSpeed)
        print(("[Macro] Speed %s (%d)"):format(SpeedOn and "ON" or "OFF", SpeedOn and BoostSpeed or NormalSpeed))
    end
end)

-- Simple draggable GUI toggle for mobile
local PlayerGui = Player:WaitForChild("PlayerGui")
-- remove old GUI if present (helps when testing multiple times)
pcall(function() PlayerGui:FindFirstChild("MacroGUI"):Destroy() end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MacroGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local button = Instance.new("TextButton")
button.Name = "MacroToggle"
button.Size = UDim2.new(0, 160, 0, 48)
button.Position = UDim2.new(0.5, -80, 0.92, 0) -- bottom center
button.AnchorPoint = Vector2.new(0.5, 0.5)
button.Text = "Macro: OFF"
button.TextScaled = true
button.BackgroundTransparency = 0.35
button.BorderSizePixel = 0
button.Active = true
button.AutoButtonColor = true
button.Parent = screenGui
button.Draggable = true

button.MouseButton1Click:Connect(function()
    SpeedOn = not SpeedOn
    setSpeed(SpeedOn and BoostSpeed or NormalSpeed)
    button.Text = "Macro: " .. (SpeedOn and "ON" or "OFF")
    print("[Macro] Button -> " .. (SpeedOn and "ON" or "OFF"))
end)

-- final helpful print
print("[Macro] Loaded. Press E (PC) or tap the 'Macro' button (mobile). If nothing happens, check the note below.")
