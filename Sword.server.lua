-- Server Script for a Roblox Tool.
-- Setup: Put this Script inside a Tool and add a BasePart named "Handle".
-- The Tool should have RequiresHandle enabled. Tune the values below for your game.

local tool = script.Parent
local handle = tool:WaitForChild("Handle")

local DAMAGE = 25
local SWING_COOLDOWN = 0.6
local HIT_WINDOW = 0.3

local lastSwingAt = 0
local hitThisSwing = {}
local swingOpen = false
local swingNumber = 0

local function getAttackerCharacter()
	local character = tool.Parent
	if character and character:IsA("Model") then
		return character
	end
	return nil
end

local function onActivated()
	local now = os.clock()
	if now - lastSwingAt < SWING_COOLDOWN then
		return
	end

	local character = getAttackerCharacter()
	if not character or not character:FindFirstChildOfClass("Humanoid") then
		return
	end

	lastSwingAt = now
	swingNumber += 1
	local thisSwing = swingNumber
	table.clear(hitThisSwing)
	swingOpen = true

	task.delay(HIT_WINDOW, function()
		if swingNumber == thisSwing then
			swingOpen = false
		end
	end)
end

local function onHandleTouched(part)
	if not swingOpen then
		return
	end

	local attackerCharacter = getAttackerCharacter()
	if not attackerCharacter or part:IsDescendantOf(attackerCharacter) then
		return
	end

	local targetCharacter = part:FindFirstAncestorOfClass("Model")
	if not targetCharacter or targetCharacter == attackerCharacter or hitThisSwing[targetCharacter] then
		return
	end

	local targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
	if not targetHumanoid or targetHumanoid.Health <= 0 then
		return
	end

	hitThisSwing[targetCharacter] = true
	targetHumanoid:TakeDamage(DAMAGE)
end

tool.Activated:Connect(onActivated)
handle.Touched:Connect(onHandleTouched)
