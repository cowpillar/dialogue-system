--[[

	Proximity & Touch Dialogue System
	
    Made by: cowpillar
    Description: This script allows you to have dialogue in Roblox,
    triggered either by ProximityPrompt (holding E) or by Touch
    (when a player physically interacts with a part or union).

]]

local triggerpart = game.Workspace.Dialogue.TemplateProximity.ProximityPrompt

-- Character name
local a = "James" -- Change speaker name, you can add as many speakers as you want
local b = "Peter"
local c = "John"

-- Stop player movement (optional, remove if you want)
local function slowDownPlayer(player, freeze)
	local character = player.Character
	if not character then return end

	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then return end

	if freeze then
		-- Gradually decrease speed to 0
		local initialSpeed = humanoid.WalkSpeed
		for i = 1, 10 do
			humanoid.WalkSpeed = math.max(initialSpeed * (1 - i / 10), 0)
			wait(0.05) -- Adjust duration for smoother effect
		end
		humanoid.WalkSpeed = 0
		humanoid.AutoRotate = false -- Prevent rotation
	else
		-- Restore speed and rotation
		humanoid.WalkSpeed = 16 -- Default Roblox speed (adjust if needed)
		humanoid.AutoRotate = true
	end
end

-- Typewriter effect
local function typewrite(object, text, length)
	for i = 1, #text do
		local sound = Instance.new("Sound")
		sound.Parent = game.Workspace
		sound.SoundId = "rbxassetid://147982968"
		sound.Name = "DialogueSound"
		sound:Play()
		object.Text = string.sub(text, 1, i)
		wait(length)
	end

	for _, v in pairs(game.Workspace:GetChildren()) do
		if v.Name == "DialogueSound" then
			v:Destroy()
		end
	end
end

-- GUI adjustments
local textLabelParent = script.Parent
local nameText = textLabelParent:WaitForChild("TextBox")
local dialogueText = textLabelParent

dialogueText.TextScaled = false
dialogueText.AnchorPoint = Vector2.new(0.5, 0)
dialogueText.Position = UDim2.new(0.5, 0, dialogueText.Position.Y.Scale, dialogueText.Position.Y.Offset)
dialogueText.Size = UDim2.new(0.8, 0, dialogueText.Size.Y.Scale, dialogueText.Size.Y.Offset)

nameText.TextScaled = false
nameText.AnchorPoint = Vector2.new(0.5, 0.5)
nameText.Position = UDim2.new(0.5, 0, 0.05, 0)
nameText.Size = UDim2.new(0.4, 0, nameText.Size.Y.Scale, nameText.Size.Y.Offset)

-- Dialogue trigger
triggerpart.Triggered:Connect(function(player)
	triggerpart.Enabled = false
	textLabelParent.Visible = true
	slowDownPlayer(player, true) -- Stop player movement (optional, remove if you want)

	-- Dialogue sequence
	nameText.Text = a -- Change who's speaking here
	typewrite(dialogueText, "Hey guys, wanna hang out?", 0.05) -- Change dialogue text and speed here
	wait(2) -- Time before it goes to the next dialogue text

	nameText.Text = b
	typewrite(dialogueText, "Hmm...", 0.5)
	wait(2)

	nameText.Text = c
	typewrite(dialogueText, "Sure!", 0.05)
	wait(2)

	nameText.Text = "" -- This is just to fix leftover dialogue visual
	typewrite(dialogueText, " ", 0.001)
	wait(2)

	slowDownPlayer(player, false) -- Restore movement
	textLabelParent.Visible = false
	triggerpart.Enabled = true
end)