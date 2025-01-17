local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local noclip = false
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local player = game.Players.LocalPlayer
local defaultWalkSpeed = 16 -- Standard-Wert für den Slider
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local espEnabled = false
local espConnections = {}


-- Event, um den WalkSpeed nach Respawn zu setzen
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid").WalkSpeed = defaultWalkSpeed
end)

local function setNoclip(state)
   noclip = state
   if noclip then
       print("No-Clip Activated")
   else
       print("No-Clip Deactivated")
   end
end

-- Event zum Aktualisieren des Charakters nach Respawn
player.CharacterAdded:Connect(function(newCharacter)
   character = newCharacter -- Aktualisiere den Charakter
   if noclip then
       -- Stelle sicher, dass No-Clip weiterhin aktiv bleibt
       for _, part in pairs(character:GetDescendants()) do
           if part:IsA("BasePart") and part.CanCollide then
               part.CanCollide = false
           end
       end
   end
end)

-- No-Clip-Logik
game:GetService("RunService").Stepped:Connect(function()
   if noclip and character then
       for _, part in pairs(character:GetDescendants()) do
           if part:IsA("BasePart") and part.CanCollide then
               part.CanCollide = false
           end
       end
   end
end)

    

--For esp

-- Funktion zum Erstellen eines ESP für einen Spieler


local function createESP(player)
    if player == localPlayer then return end -- Ignoriere den lokalen Spieler

    local function addESP(character)
        if not character:FindFirstChild("HumanoidRootPart") then
            character:WaitForChild("HumanoidRootPart")
        end

        -- Erstelle BillboardGui (Text-Anzeige)
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "ESP"
        billboardGui.Adornee = character.HumanoidRootPart
        billboardGui.Size = UDim2.new(6, 0, 1.5, 0) -- Größere Anzeige
        billboardGui.AlwaysOnTop = true

        -- TextLabel für Namen und HP
        local textLabel = Instance.new("TextLabel")
        textLabel.Parent = billboardGui
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.new(1, 0, 0) -- Roter Text
        textLabel.TextStrokeTransparency = 0.5 -- Kontur
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextScaled = true
        textLabel.Text = player.Name .. " [HP: ???]" -- Standardtext

        billboardGui.Parent = character.HumanoidRootPart

        -- Erstelle SelectionBox (Markierung um den Charakter)
        

        -- Verbindung zur Aktualisierung der Lebenspunkte
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            if not espEnabled or not character:FindFirstChild("Humanoid") then
                billboardGui:Destroy()
                connection:Disconnect()
            else
                textLabel.Text = player.Name .. " [HP: " .. math.floor(character.Humanoid.Health) .. "]"
            end
        end)

        table.insert(espConnections, connection)
    end

    -- Füge ESP hinzu, wenn der Charakter vorhanden ist
    if player.Character then
        addESP(player.Character)
    end

    -- Warte auf neue Charaktere
    player.CharacterAdded:Connect(addESP)
end

-- Funktion: Entferne alle ESPs
local function removeAllESP()
    for _, connection in ipairs(espConnections) do
        connection:Disconnect()
    end
    espConnections = {}

    for _, player in ipairs(players:GetPlayers()) do
        if player.Character then
            -- Entferne BillboardGui und SelectionBox
            local espGui = player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart:FindFirstChild("ESP")
            if espGui then
                espGui:Destroy()
            end
        end
    end
end

-- Funktion: ESP umschalten
local function toggleESP(state)
    espEnabled = state

    if espEnabled then
        -- Aktiviere ESP für alle existierenden Spieler
        for _, player in ipairs(players:GetPlayers()) do
            createESP(player)
        end

        -- Neue Spieler hinzufügen
        players.PlayerAdded:Connect(createESP)
    else
        removeAllESP()
    end
end



-------------------------------------------------------------------------------------------------------------------------------------------

local Window = Rayfield:CreateWindow({
   Name = "Universal ✔",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "TEst",
   LoadingSubtitle = "By Speedking",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "kbn8pW7SWj", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Test",
      Subtitle = "Key System",
      Note = "Its now under Testing", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"KING"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("Home", nil) -- Title, Image
local VisualTab = Window:CreateTab("Visual", nil) -- Title, Image
local MainSection = MainTab:CreateSection("Main")
local VisualSection = VisualTab:CreateSection("Esp")

Rayfield:Notify({
   Title = "Success!",
   Content = "It worked, have fun :)",
   Duration = 3.4,
   Image = nil,
})



local Toggle = MainTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "Inf Jump", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   _G.infinjump = not _G.infinjump


if _G.infinJumpStarted == nil then
	--Ensures this only runs once to save resources
	_G.infinJumpStarted = true
	

	--The actual infinite jump
	local plr = game:GetService('Players').LocalPlayer
	local m = plr:GetMouse()
	m.KeyDown:connect(function(k)
		if _G.infinjump then
			if k:byte() == 32 then
			humanoid = game:GetService'Players'.LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
			humanoid:ChangeState('Jumping')
			wait()
			humanoid:ChangeState('Seated')
			end
		end
	end)
end
   end,
})


-- Toggle with integrated No-Clip
local Toggle = MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        setNoclip(Value) -- Activate or deactivate No-Clip based on toggle value
    end
})

local Slider = MainTab:CreateSlider({
   Name = "Walkspeed",
   Range = {0, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Walkspeed", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      defaultWalkSpeed = Value -- Speichere den neuen WalkSpeed-Wert
      if player.Character and player.Character:FindFirstChild("Humanoid") then
          player.Character.Humanoid.WalkSpeed = Value -- Setze den WalkSpeed direkt
      end
   end,
})

local Toggle = VisualTab:CreateToggle({
    Name = "Esp",
    CurrentValue = false,
    Flag = "EspToggle", 
    Callback = function(Value)
        toggleESP(Value)
    end
})


