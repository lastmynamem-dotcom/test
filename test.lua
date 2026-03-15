repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- wait for character
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- wait for humanoid
local Humanoid = Character:WaitForChild("Humanoid")

-- wait for HRP
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- optional: ensure character is actually alive
repeat task.wait() until Humanoid.Health > 0

-- Force global environment registration
if not getgenv then
    getfenv().getgenv = function() return _G end
end

-- Force Drawing into global if missing
if not Drawing then
    local drawingLib = {
        Fonts = { UI = 0, System = 1, Plex = 2, Monospace = 3 },
        new = function(type)
            local dummy = {}
            setmetatable(dummy, {
                __index = function() return function() end end,
                __newindex = function() end
            })
            dummy.Visible = true
            dummy.Color = Color3.new(1,1,1)
            dummy.Remove = function() end
            dummy.Destroy = function() end
            return dummy
        end
    }
    getfenv().Drawing = drawingLib
end

-- Force file functions into global if missing
if not writefile then
    getfenv().writefile = function() end
    getfenv().readfile = function() return "" end
    getfenv().isfolder = function() return false end
    getfenv().makefolder = function() end
end

print("Your Current Place ID is:", game.PlaceId)
task.wait(1) -- Give the game a second to settle

local currentID = game.PlaceId
-- Fallback checks for different versions of the game or lobby
if currentID == 0 then 
    task.wait(1)
    currentID = game.PlaceId 
end

if currentID == 111530421351096 then
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
	Title = "Synth Hub",
	Footer = "[UPD] You VS Homer | Version: 1",
	NotifySide = "Right",
	ShowCustomCursor = true,
})

local Tabs = {
    Main = Window:AddTab("Main", "house"),
    Player = Window:AddTab("Player", "user"),
    Visuals = Window:AddTab("Visuals", "eye"),
    Extras = Window:AddTab("Extras", "boxes"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character.Humanoid
local HumanoidRootPart = Character.HumanoidRootPart

local SoundService = game:GetService("SoundService")
local NotificationSound = Instance.new("Sound")

NotificationSound.SoundId = "rbxassetid://17582299860"
NotificationSound.Parent = SoundService
NotificationSound.Volume = 2

local LocalPlayer = game.Players.LocalPlayer

local leftgroupboxextras = Tabs.Extras:AddLeftGroupbox("Scripts")

leftgroupboxextras:AddButton({
    Text = "Infinite Yield",
    DoubleClick = true,

    Func = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end,
})

-- main ac bypass

pcall(function()
    local ACtable = {
        LocalPlayer.PlayerScripts:FindFirstChild("QuitsAntiCheatChecker"),
        LocalPlayer.PlayerScripts:FindFirstChild("QuitsAntiCheatLocal"),
        game:GetService("StarterPlayer").StarterPlayerScripts:FindFirstChild("QuitsAntiCheatChecker"),
        game:GetService("StarterPlayer").StarterPlayerScripts:FindFirstChild("QuitsAntiCheatLocal"),
    }

    for _, v in pairs(ACtable) do
        if v then
            v:Destroy()
        end
    end
end)

-- adonis ac bypass

local args = {
    [1] = {
        Received = 5,
        Loader = nil, -- prevent infinite yield
        Mode = "Fire",
        Sent = 15,
        Module = (function()
            local function getNil(objType, objName)
                for _, v in getnilinstances() do
                    if v.ClassName == objType and v.Name == objName then
                        return v
                    end
                end
            end
            return getNil("ModuleScript", "Client")
        end)(),
    },
    [2] = "!U\ZA",
    [3] = "kick",
    [4] = "namecallInstance detector detected - On mobile",
}

local g = getinfo or debug.getinfo
local d = false
local h = {}

local x, y

setthreadidentity(2)

for i, v in getgc(true) do
    if typeof(v) == "table" then
        local a = rawget(v, "Detected")
        local b = rawget(v, "Kill")
    
        if typeof(a) == "function" and not x then
            x = a
            
            local o; o = hookfunction(x, function(c, f, n)
                if c ~= "_" then
                    if d then
                        warn('Adonis AntiCheat flagged\nMethod: {c}\nInfo: {f}')
                    end
                end
                
                return true
            end)

            table.insert(h, x)
        end

        if rawget(v, "Variables") and rawget(v, "Process") and typeof(b) == "function" and not y then
            y = b
            local o; o = hookfunction(y, function(f)
                if d then
                    warn('Adonis AntiCheat tried to kill (fallback): {f}')
                end
            end)

            table.insert(h, y)
        end
    end
end

local o; o = hookfunction(getrenv().debug.info, newcclosure(function(...)
    local a, f = ...

    if x and a == x then
        if d then
            warn('adonis bypassed')
        end

        return coroutine.yield(coroutine.running())
    end
    
    return o(...)
end))

setthreadidentity(7)

print("Bypassed")

local banana = Instance.new("Part", workspace)

banana.CFrame = CFrame.new(
	0.328133374, 225.102631, -0.160657108,
	-0.00628323993, 5.33986189e-09, 0.999980271,
	2.73997305e-08, 1, -5.16780441e-09,
	-0.999980271, 2.73667187e-08, -0.00628323993
)
banana.Name = "nababa"
banana.Anchored = true
banana.Size = Vector3.new(10, 1, 10)

local bart = Instance.new("Decal", banana)
bart.Texture = "rbxassetid://5629029458"
bart.Face = Enum.NormalId.Top
bart.Parent = workspace.nababa

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Automation")

LeftGroupBox:AddToggle("AutoFarmBart", {
    Text = "Auto Win as Bart",
    Tooltip = "Teleports you to a platform really high up where no one can catch up to you.",
    Default = false,
    Callback = function(Value)
        -- 1. Create a function for the "Off" teleport so we can reuse it
        local function teleportToExit()
            local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local Root = Char:WaitForChild("HumanoidRootPart", 10)
            if Root then
                Root.CFrame = CFrame.new(
                    -0.0539585017, 103.999977, 44.5736847, 
                    0.999980271, 5.21511829e-08, 0.00628343504, 
                    -5.23917691e-08, 1, 3.8124238e-08, 
                    -0.00628343504, -3.84526864e-08, 0.999980271
                )
            end
        end

        if Value then
            -- 2. Start the persistent loop
            task.spawn(function()
                while Toggles.AutoFarmBart.Value do
                    -- Always fetch the LATEST character and root part
                    local Char = LocalPlayer.Character
                    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
                    local Hum = Char and Char:FindFirstChildOfClass("Humanoid")

                    -- Only teleport if you are on team Bart and currently ALIVE
                    if LocalPlayer.Team and LocalPlayer.Team.Name == "Bart" then
                        if Root and Hum and Hum.Health > 0 then
                            Root.CFrame = banana.CFrame * CFrame.new(0, 5, 0)
                        end
                    end
                    
                    task.wait(5) 
                end
            end)
        else
            -- 3. Teleport to exit coordinates immediately when disabled
            teleportToExit()
        end
    end,
})

-- 4. EMERGENCY RESET CHECK
-- This ensures that if you respawn while the toggle is ALREADY on, it checks immediately
LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
    task.wait(0.5) -- Give the game a split second to load the character
    if Toggles.AutoFarmBart and Toggles.AutoFarmBart.Value then
        if LocalPlayer.Team and LocalPlayer.Team.Name == "Bart" then
            local Root = NewCharacter:WaitForChild("HumanoidRootPart", 10)
            if Root then
                Root.CFrame = banana.CFrame * CFrame.new(0, 5, 0)
            end
        end
    end
end)

LeftGroupBox:AddToggle("AutoKillAll", {
    Text = "Auto Kill all Barts",
    Tooltip = "Auto kills all barts if you're Homer.",
    Default = false,
    Callback = function(Value)
    end
})

local StaffIDs = {
    2347168837, 2763394267, 417808988, 8471806493, 3389139247, 159738094, 
    1710295794, 3507806217, 7220198628, 285614724, 17012224, 1940280769, 
    2287836655, 1444966817, 720488317, 449257947, 205158206, 8456366786, 
    2975057597, 1266087589, 3741610167, 3828580731, 3784282105, 7325295108, 
    2944427202, 1213488078, 81924054, 1563414031, 7245573964, 2209851428, 
    353615815, 593783922, 3952272355, 3347961784
}

LeftGroupBox:AddToggle("StaffDetector", {
    Text = "Staff Detector",
    Tooltip = "Automatically kicks you if a staff or admin joins or is in the server.",
    Default = false,
    Callback = function(Value)
        if Value then
            -- Immediate check for anyone already in the server
            for _, player in ipairs(game.Players:GetPlayers()) do
                if table.find(StaffIDs, player.UserId) then
                    LocalPlayer:Kick("\n[Synth Hub Security]\nStaff member already in the server: " .. player.Name)
                end
            end
        end
    end,
})

-- Background Listener (Always active, but only kicks if Toggle is ON)
game.Players.PlayerAdded:Connect(function(player)
    if Toggles.StaffDetector and Toggles.StaffDetector.Value then
        if table.find(StaffIDs, player.UserId) then
            LocalPlayer:Kick("\n[Synth Hub Security]\nStaff joined the server: " .. player.Name)
        end
    end
end)

local RightGroupBox = Tabs.Main:AddRightGroupbox("Utilities")

RightGroupBox:AddButton({
    Text = "Delete Foxy Jumpscare",
    Tooltip = "Deletes Foxy Jumpscare.",

    Func = function()
        game:GetService("ReplicatedStorage").moduleFolders.misc.foxyJumpscare:Destroy()
        Library:Notify("Deleted Foxy Jumpscare.")
        NotificationSound:Play()
    end,
})

-- ESP Group Box
local EspGroup = Tabs.Visuals:AddLeftGroupbox("ESPs")

EspGroup:AddToggle("BartESP", {
    Text = "Bart ESP",
    Default = false,
}):AddColorPicker("BartColor", {
    Default = Color3.fromRGB(255, 217, 15), -- Default Bart Yellow
    Title = "Bart Highlight Color",
})

EspGroup:AddToggle("HomerESP", {
    Text = "Homer ESP",
    Default = false,
}):AddColorPicker("HomerColor", {
    Default = Color3.fromRGB(255, 0, 0), -- Default Homer Red
    Title = "Homer Highlight Color",
})

-- Environment Group Box
local notESPGroup = Tabs.Visuals:AddRightGroupbox("Environment")

notESPGroup:AddToggle("Fullbright", {
    Text = "Fullbright",
    Default = false,
}):AddColorPicker("FBColor", {
    Default = Color3.fromRGB(255, 255, 255), -- Default White
    Title = "Fullbright Tint",
})

notESPGroup:AddToggle("NoFog", {
    Text = "No Fog",
    Default = false,
})

local Lighting = game:GetService("Lighting")

-- ESP Logic Loop
task.spawn(function()
    while task.wait(0.5) do
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local char = p.Character
                local team = (p.Team and p.Team.Name) or "None"
                
                -- Determine if we should show based on team toggle
                local isBart = (Toggles.BartESP.Value and team == "Bart")
                local isHomer = (Toggles.HomerESP.Value and team == "Homer")
                
                local highlight = char:FindFirstChild("SynthHighlight")
                local billboard = char:FindFirstChild("SynthBillboard")

                if isBart or isHomer then
                    -- Get color from pickers
                    local color = isBart and Options.BartColor.Value or Options.HomerColor.Value
                    local labelText = isBart and "BART" or "HOMER"

                    -- Update or Create Highlight
                    if not highlight then
                        highlight = Instance.new("Highlight", char)
                        highlight.Name = "SynthHighlight"
                    end
                    highlight.FillColor = color
                    
                    -- Update or Create Label
                    if not billboard then
                        billboard = Instance.new("BillboardGui", char)
                        billboard.Name = "SynthBillboard"
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 3.5, 0)
                        billboard.AlwaysOnTop = true
                        local l = Instance.new("TextLabel", billboard)
                        l.Size = UDim2.new(1, 0, 1, 0)
                        l.BackgroundTransparency = 1
                        l.TextStrokeTransparency = 0
                        l.Font = Enum.Font.GothamBold
                    end
                    billboard.TextLabel.Text = labelText
                    billboard.TextLabel.TextColor3 = color
                else
                    -- Cleanup if toggles are off
                    if highlight then highlight:Destroy() end
                    if billboard then billboard:Destroy() end
                end
            end
        end
    end
end)

-- Lighting Logic Loop
task.spawn(function()
    while task.wait(1) do
        if Toggles.Fullbright.Value then
            Lighting.Ambient = Options.FBColor.Value
            Lighting.OutdoorAmbient = Options.FBColor.Value
            Lighting.Brightness = 2
        end
        
        if Toggles.NoFog.Value then
            Lighting.FogEnd = 1000000
            local atm = Lighting:FindFirstChildOfClass("Atmosphere")
            if atm then atm.Density = 0 end
        end
    end
end)

LeftGroupBox:AddToggle('AutoCompleteObby', {
    Text = 'Auto Complete Obby',
    Default = false,
    Tooltip = 'Instantly wins the lobby obby repeatedly',
    Callback = function(Value)
    end
})

-- LOGIC HANDLER
task.spawn(function()
    local Teams = game:GetService("Teams")
    local p = game.Players.LocalPlayer

    while task.wait() do
        -- 1. AUTO COMPLETE OBBY LOGIC
        if Toggles.AutoCompleteObby and Toggles.AutoCompleteObby.Value then
            pcall(function()
                local winpad = workspace.lobbyCage.obby.landawnObby:FindFirstChild("winpad")
                local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                if winpad and hrp then
                    firetouchinterest(hrp, winpad, 0)
                    task.wait()
                    firetouchinterest(hrp, winpad, 1)
                end
            end)
        end

        -- 2. AUTO KILL BARTS (TEAM-BASED)
        if Toggles.AutoKillBarts and Toggles.AutoKillBarts.Value then
            -- Check if YOU are Homer
            if p.Team == Teams:FindFirstChild("Homer") then
                
                -- Find a target on Team Bart
                local targetPlayer = nil
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v.Team == Teams:FindFirstChild("Bart") and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                        targetPlayer = v
                        break
                    end
                end

                if targetPlayer and targetPlayer.Character then
                    local bHum = targetPlayer.Character:FindFirstChild("Humanoid")
                    local bRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")

                    -- Loop until THIS specific Bart dies or switches teams
                    repeat
                        if not Toggles.AutoKillBarts.Value or p.Team ~= Teams:FindFirstChild("Homer") then break end
                        
                        local myChar = p.Character
                        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                        local myHum = myChar and myChar:FindFirstChild("Humanoid")

                        -- Verify we are alive and target is still valid
                        if myRoot and myHum and myHum.Health > 0 and bRoot and bHum and bHum.Health > 0 then
                            -- Stay behind the Bart
                            myRoot.CFrame = bRoot.CFrame * CFrame.new(0, 0, 3)

                            -- Weapon Handling
                            local tool = p.Backpack:FindFirstOfClass("Tool") or myChar:FindFirstOfClass("Tool")
                            if tool then
                                tool.Parent = myChar
                                tool:Activate()
                            end
                        end
                        task.wait()
                    -- Condition: Loop until they die, leave team, or leave game
                    until not targetPlayer or not targetPlayer.Character or bHum.Health <= 0 or targetPlayer.Team ~= Teams:FindFirstChild("Bart") or not Toggles.AutoKillBarts.Value
                end
            end
        end
    end
end)

LeftGroupBox:AddDivider()
LeftGroupBox:AddLabel({
    Text = "Info",
    Size = 16
})

LeftGroupBox:AddLabel({
    Text = "The anti-cheat is bypassed by\ndefault. It is not a toggle\nor a button.",
    DoesWrap = true
})

local LeftGroupBoxPlayer = Tabs.Player:AddLeftGroupbox("Player")

-- Toggle
LeftGroupBoxPlayer:AddToggle("SpeedHack", {
    Text = "Enable Speed Hack",
    Default = false,
})

-- Slider (compact, under toggle)
LeftGroupBoxPlayer:AddSlider("WalkSpeed", {
    Text = "Walk Speed",
    Default = 16,
    Min = 16,
    Max = 250,
    Rounding = 0,
    Compact = true,

    Parent = "SpeedHack",

    Callback = function(Value)
        local humanoid = Character:FindFirstChild("Humanoid")
        if humanoid and Toggles.SpeedHack.Value then
            humanoid.WalkSpeed = Value
        end
    end,
})

-- Jump Power toggle
LeftGroupBoxPlayer:AddToggle("JumpPowerHack", {
    Text = "Enable Jump Power",
    Default = false,
})

-- Jump Power slider
LeftGroupBoxPlayer:AddSlider("JumpPower", {
    Text = "Jump Power",
    Default = 50,
    Min = 50,
    Max = 250,
    Rounding = 0,
    Compact = true,

    Parent = "JumpPowerHack",

    Callback = function(Value)
        local humanoid = Character:FindFirstChild("Humanoid")
        if humanoid and Toggles.JumpPowerHack.Value then
            humanoid.JumpPower = Value
        end
    end,
})

-- Apply / reset logic
Toggles.JumpPowerHack:OnChanged(function()
    local humanoid = Character:FindFirstChild("Humanoid")
    if not humanoid then return end

    if Toggles.JumpPowerHack.Value then
        humanoid.JumpPower = Options.JumpPower.Value
    else
        humanoid.JumpPower = 50 -- 🔁 reset
    end
end)

LeftGroupBoxPlayer:AddDivider()

LeftGroupBoxPlayer:AddToggle("NoClip", {
    Text = "Noclip",
    Default = false,
})

local RunService = game:GetService("RunService")
local NoClipConnection

Toggles.NoClip:OnChanged(function()
    if NoClipConnection then
        NoClipConnection:Disconnect()
        NoClipConnection = nil
    end

    if Toggles.NoClip.Value then
        NoClipConnection = RunService.Stepped:Connect(function()
            if Character then
                for _, v in ipairs(Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
end)

LeftGroupBoxPlayer:AddToggle("Fly", {
    Text = "Fly",
    Default = false,
})

LeftGroupBoxPlayer:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Default = 60,
    Min = 10,
    Max = 250,
    Rounding = 0,
    Compact = true,

    Parent = "Fly",
})

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local FlyConnection
local BodyVelocity
local BodyGyro

Toggles.Fly:OnChanged(function()
    local hrp = Character and Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- CLEANUP (disable fly)
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end

    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end

    if BodyGyro then
        BodyGyro:Destroy()
        BodyGyro = nil
    end

    -- ENABLE FLY
    if Toggles.Fly.Value then
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        BodyVelocity.Velocity = Vector3.zero
        BodyVelocity.Parent = hrp

        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        BodyGyro.P = 1e5
        BodyGyro.CFrame = Camera.CFrame
        BodyGyro.Parent = hrp

        FlyConnection = RunService.RenderStepped:Connect(function()
            local moveVec = Vector3.zero
            local camCF = Camera.CFrame
            local speed = Options.FlySpeed.Value

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveVec += camCF.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveVec -= camCF.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveVec -= camCF.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveVec += camCF.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveVec += camCF.UpVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveVec -= camCF.UpVector
            end

            -- 🔥 INSTANT movement (no smoothing)
            if moveVec.Magnitude > 0 then
                BodyVelocity.Velocity = moveVec.Unit * speed
            else
                BodyVelocity.Velocity = Vector3.zero
            end

            -- snap rotation to camera
            BodyGyro.CFrame = camCF
        end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char

    if Toggles.NoClip.Value then
        Toggles.NoClip:SetValue(false)
        Toggles.NoClip:SetValue(true)
    end

    if Toggles.Fly.Value then
        Toggles.Fly:SetValue(false)
        Toggles.Fly:SetValue(true)
    end
end)

LeftGroupBoxPlayer:AddDivider()

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local InfiniteJumpConnection

LeftGroupBoxPlayer:AddToggle("InfiniteJump", {
    Text = "Infinite Jump",
    Default = false,
})

Toggles.InfiniteJump:OnChanged(function()
    -- disconnect if turning off
    if InfiniteJumpConnection then
        InfiniteJumpConnection:Disconnect()
        InfiniteJumpConnection = nil
    end

    -- connect when enabled
    if Toggles.InfiniteJump.Value then
        InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            local humanoid = Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char

    if Toggles.InfiniteJump.Value then
        -- reconnect JumpRequest cleanly
        Toggles.InfiniteJump:SetValue(false)
        Toggles.InfiniteJump:SetValue(true)
    end
end)

local PromptFixEnabled = false
local PromptConnections = {}

local function applyPrompt(prompt)
    if not PromptFixEnabled then return end
    prompt.HoldDuration = 0
end

local function hookPrompt(prompt)
    if PromptConnections[prompt] then return end

    PromptConnections[prompt] = prompt.PromptShown:Connect(function()
        applyPrompt(prompt)
    end)
end

local function enablePromptFix()
    PromptFixEnabled = true

    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            applyPrompt(v)
            hookPrompt(v)
        end
    end
end

local function disablePromptFix()
    PromptFixEnabled = false
    -- We don't disconnect on purpose; logic gate blocks changes
end

Workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
        hookPrompt(obj)
        applyPrompt(obj)
    end
end)

LeftGroupBoxPlayer:AddToggle("InstantPrompts", {
    Text = "Instant PPs",
    Default = false,
    Callback = function(Value)
        if Value then
            enablePromptFix()
        else
            disablePromptFix()
        end
    end
})

local AntiAfkConnection

LeftGroupBoxPlayer:AddToggle("AntiAFK", {
    Text = "Anti AFK",
    Default = false,
})

Toggles.AntiAFK:OnChanged(function()
    if Toggles.AntiAFK.Value then
        AntiAfkConnection = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    else
        if AntiAfkConnection then
            AntiAfkConnection:Disconnect()
            AntiAfkConnection = nil
        end
    end
end)


LeftGroupBoxPlayer:AddToggle("DisableVoid", {
    Text = "Disable Roblox Void",
    Default = false,
})

Toggles.DisableVoid:OnChanged(function()
    if Toggles.DisableVoid.Value then
        workspace.FallenPartsDestroyHeight = -math.huge
    else
        workspace.FallenPartsDestroyHeight = OldVoidHeight
    end
end)

-- Reset / apply logic
Toggles.SpeedHack:OnChanged(function()
    local humanoid = Character:FindFirstChild("Humanoid")
    if not humanoid then return end

    if Toggles.SpeedHack.Value then
        humanoid.WalkSpeed = Options.WalkSpeed.Value
    else
        humanoid.WalkSpeed = 16 -- reset when disabled
    end
end)

RightGroupBox:AddButton({
    Text = "Disable Scream Sounds",
    Tooltip = "Self-Explanatory.",

    Func = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Sound") and v.Name:match("scream") then
                v.Volume = 0
            end
        end

        Library:Notify("Disabled all scream sounds.")
        NotificationSound:Play()
    end,
})

RightGroupBox:AddButton({
    Text = "Fake Homer Ritual",
    Func = function()
local RunService = game:GetService("RunService")

-- References
local lp = game.Players.LocalPlayer
local character = lp.Character or lp.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Configuration
local duration = 10          -- Seconds to go up
local pauseTime = 2         -- Seconds to wait at top
local distance = 15         -- Studs to travel
local startRotationSpeed = 500 -- Initial spin speed

-- 1. Create the Red Glowing Platform
local platform = Instance.new("Part")
platform.Name = "AscensionPlatform"
platform.Size = Vector3.new(0.5, 5, 5) -- Thin disc
platform.Color = Color3.fromRGB(255, 0, 0)
platform.Material = Enum.Material.Neon
platform.CanCollide = false -- Won't trip the player
platform.CanQuery = false   -- Camera/Raycasts ignore it
platform.Anchored = true
platform.Parent = character

local startCFrame = hrp.CFrame
local elapsedTime = 0

-- The Animation Loop
hrp.Anchored = true

local connection
connection = RunService.Heartbeat:Connect(function(dt)
	elapsedTime = elapsedTime + dt
	
	-- Calculate progress (0 to 1)
	local alpha = math.clamp(elapsedTime / duration, 0, 1)
	
	-- Linear Movement Up
	local currentHeight = distance * alpha
	local positionOffset = Vector3.new(0, currentHeight, 0)
	
	-- Decelerating Spin math
	local rotationAngle = startRotationSpeed * (alpha - (alpha^2 / 2))
	
	-- Update HRP CFrame
	local currentCFrame = (startCFrame + positionOffset) * CFrame.Angles(0, rotationAngle, 0)
	hrp.CFrame = currentCFrame
	
	-- Update Platform CFrame (stay 3.5 studs below HRP center)
	-- We rotate the cylinder 90 degrees on the Z axis so it lays flat
	platform.CFrame = currentCFrame * CFrame.new(0, -3.2, 0) * CFrame.Angles(0, 0, math.rad(90))
	
	-- Stop when time is up
	if alpha >= 1 then
		connection:Disconnect()
		
		-- Brief wait at the top
		task.wait(pauseTime)
		
		-- Cleanup and Reset
		platform:Destroy()
		hrp.Anchored = false
		humanoid.Health = 0
	end
end)
    end,
    Tooltip = "Ascends you into the sky and resets character"
})

RightGroupBox:AddButton({
    Text = "Gamble all machines",
    Func = function()

local cl = workspace.lobbyCage.fun.slotMachine3.lever.handle.ClickDetector

cl.MaxActivationDistance = 9e9
fireclickdetector(cl)

local cl1 = workspace.lobbyCage.fun.slotMachine2.lever.handle.ClickDetector

cl1.MaxActivationDistance = 9e9
fireclickdetector(cl1)

local cl2 = workspace.lobbyCage.fun.slotMachine1.lever.handle.ClickDetector

cl2.MaxActivationDistance = 9e9
fireclickdetector(cl2)

local cl3 = workspace.lobbyCage.fun.slotMachine4.lever.handle.ClickDetector

cl3.MaxActivationDistance = 9e9
fireclickdetector(cl3)

    end,
    Tooltip = "Gambles all of the machines"
})
wait(1)

Library:Notify("Bypassed Anti-cheats!")
NotificationSound:Play()

local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")

MenuGroup:AddToggle("KeybindMenuOpen", {
	Default = Library.KeybindFrame.Visible,
	Text = "Open Keybind Menu",
	Callback = function(value)
		Library.KeybindFrame.Visible = value
	end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
	Text = "Custom Cursor",
	Default = true,
	Callback = function(Value)
		Library.ShowCustomCursor = Value
	end,
})
MenuGroup:AddDropdown("NotificationSide", {
	Values = { "Left", "Right" },
	Default = "Right",

	Text = "Notification Side",

	Callback = function(Value)
		Library:SetNotifySide(Value)
	end,
})
MenuGroup:AddDropdown("DPIDropdown", {
	Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
	Default = "100%",

	Text = "DPI Scale",

	Callback = function(Value)
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)

		Library:SetDPIScale(DPI)
	end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
	:AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
	Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:SetSubFolder("specific-place")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()
elseif currentID == 16552821455 then
    -- Extended sUNC-style Executor Capability Checker
-- No sUNC table, no execution, environment validation only

local functionList = {
    -- Environment / Globals
    "getgenv", "getrenv", "getfenv", "setfenv", "getgc", "getreg",

    -- Closure / Function Introspection
    "islclosure", "iscclosure", "isexecutorclosure", "newcclosure",
    "clonefunction", "hookfunction", "replaceclosure",

    -- Metamethod / Namecall
    "getrawmetatable", "setrawmetatable",
    "getnamecallmethod", "setnamecallmethod",
    "hookmetamethod",

    -- Readonly / Table Control
    "setreadonly", "isreadonly",
    "make_readonly", "make_writeable",

    -- Script / Module Introspection
    "getscripts", "getloadedmodules", "getsenv",
    "getscriptclosure", "getscriptbytecode",
    "getcallingscript",

    -- Connections / Signals
    "getconnections", "firesignal",

    -- Debug Library
    "debug.getupvalue", "debug.getupvalues",
    "debug.setupvalue", "debug.setstack",
    "debug.getstack", "debug.traceback",
    "debug.getproto", "debug.getprotos",

    -- File System
    "readfile", "writefile", "appendfile",
    "makefolder", "delfolder",
    "listfiles", "isfile", "isfolder", "delfile",

    -- HTTP / Network
    "request", "http_request", "syn.request",

    -- Input / Misc
    "mouse1click", "mouse1press", "mouse1release",
    "mouse2click", "keypress", "keyrelease",

    -- Executor Info
    "identifyexecutor", "getexecutorname",

    -- Threading / Task
    "queue_on_teleport", "setthreadidentity",
    "getthreadidentity", "setidentity"
}

local supported = 0
local total = #functionList

for _, fname in ipairs(functionList) do
    local fn =
        rawget(getgenv(), fname) or
        rawget(_G, fname)

    if typeof(fn) == "function" then
        local ok = pcall(function()
            return tostring(fn)
        end)

        if ok then
            supported += 1
            print("✅ " .. fname)
        else
            print("❌ " .. fname)
        end
    else
        print("❌ " .. fname)
    end
end

print(string.format(
    "🛠️ Supported functions: %d/%d",
    supported,
    total
))

-- Executor identification (safe, no execution of dangerous APIs)

local executor = "Unknown"

-- Modern standard
if typeof(identifyexecutor) == "function" then
    local ok, name = pcall(identifyexecutor)
    if ok and typeof(name) == "string" then
        executor = name
    end
end

-- Synapse fallback
if executor == "Unknown" and typeof(syn) == "table" and typeof(syn.getexecutorname) == "function" then
    local ok, name = pcall(syn.getexecutorname)
    if ok and typeof(name) == "string" then
        executor = name
    end
end

-- Generic executor globals
if executor == "Unknown" then
    local genv = getgenv and getgenv() or _G
    for _, key in ipairs({ "KRNL_LOADED", "FLUXUS_LOADED", "ELECTRON_LOADED", "WAVE_LOADED" }) do
        if genv[key] then
            executor = key:gsub("_LOADED", "")
            break
        end
    end
end

print("👻 Executor: " .. executor)
    print("Game Supported: Dandy's World")
    local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local PathfindingService = game:GetService("PathfindingService")

local Player = Players.LocalPlayer
local Connections = {}

-- State Management
local autoGTEEnabled = false
local itemAuraEnabled = false
local hasTeleportedThisRound = false
local autoGenEnabled = false
local visitedGenerators = {}
local isDoingGenerators = false
local antiLagEnabled = false
local gteCFrame = CFrame.new(-747.833984, 99.6797256, 93.432579, 0.660354853, 8.19742922e-08, 0.750953734, -2.6152005e-08, 1, -8.61633538e-08, -0.750953734, 3.725944e-08, 0.660354853)

-- Window
local Window = Library:CreateWindow({
    Title = 'Dandys World | Synth Hub',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- Tabs
local Tabs = {
    Main = Window:AddTab('Main'),
    Visuals = Window:AddTab('Visuals'),
    Extras = Window:AddTab('Extras'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local MainLeft = Tabs.Main:AddLeftGroupbox('Main')
local MainRight = Tabs.Main:AddRightGroupbox('Player')
local ESPsGroup = Tabs.Visuals:AddLeftGroupbox('ESPs')
local ESPOptionsGroup = Tabs.Visuals:AddLeftGroupbox('ESP Options')
local PlayerVisualsGroup = Tabs.Visuals:AddRightGroupbox('Player')
local EnvGroup = Tabs.Visuals:AddRightGroupbox('Environment')
local ExtrasLeft = Tabs.Extras:AddLeftGroupbox('Scripts')
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

-- ============================================================================
--  UTILITY
-- ============================================================================

local function safeDisconnect(name)
    if Connections[name] then Connections[name]:Disconnect() Connections[name] = nil end
end

-- ============================================================================
--  ITEM AURA LOGIC (LOCKED TO 12)
-- ============================================================================

local function updateItemPrompts()
    local room = Workspace:FindFirstChild("CurrentRoom")
    local itemsFolder = room and room:FindFirstChild("EmotionMap") and room.EmotionMap:FindFirstChild("Items")
    
    local dist = itemAuraEnabled and 12 or 7
    
    if itemsFolder then
        for _, item in pairs(itemsFolder:GetDescendants()) do
            if item:IsA("ProximityPrompt") then
                item.MaxActivationDistance = dist
            end
        end
    end
end

-- ============================================================================
--  AUTO GENERATOR LOGIC
-- ============================================================================

local function getGeneratorFakeValve(genModel)
    return genModel:FindFirstChild("Model") and genModel.Model:FindFirstChild("FakeValve")
end

local function findNearestGenerator(generatorsFolder)
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local hrp = Player.Character.HumanoidRootPart
    local nearest = nil
    local shortestDist = math.huge
    
    for _, gen in pairs(generatorsFolder:GetChildren()) do
        if gen:IsA("Model") and not visitedGenerators[gen] then
            local valve = getGeneratorFakeValve(gen)
            if valve then
                local dist = (hrp.Position - valve.Position).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    nearest = gen
                end
            end
        end
    end
    
    return nearest
end

local function fireGeneratorPrompt(generatorModel)
    local valve = getGeneratorFakeValve(generatorModel)
    if not valve then 
        warn("No FakeValve found in generator")
        return false 
    end
    
    local prompt = generatorModel:FindFirstChildOfClass("ProximityPrompt", true)
    if not prompt then
        for _, desc in pairs(generatorModel:GetDescendants()) do
            if desc:IsA("ProximityPrompt") then
                prompt = desc
                break
            end
        end
    end
    
    if not prompt then 
        warn("No ProximityPrompt found in generator model")
        return false 
    end
    
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = valve.CFrame * CFrame.new(0, 3, 0)
        task.wait(0.3)
        
        local success, err = pcall(function()
            fireproximityprompt(prompt)
        end)
        
        if not success then
            warn("Failed to fire prompt: " .. tostring(err))
            return false
        end
        
        Library:Notify("Prompt fired successfully!")
        return true
    end
    
    return false
end

local function pathfindToGenerator(targetGenerator)
    if not Player.Character then return false end
    
    local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = Player.Character:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return false end
    
    local valve = getGeneratorFakeValve(targetGenerator)
    if not valve then return false end
    
    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        AgentJumpHeight = 7.5,
        AgentMaxSlope = 45
    })
    
    local success, errorMsg = pcall(function()
        path:ComputeAsync(hrp.Position, valve.Position)
    end)
    
    if not success or path.Status ~= Enum.PathStatus.Success then
        warn("Pathfinding failed: " .. tostring(errorMsg))
        return false
    end
    
    local waypoints = path:GetWaypoints()
    humanoid.WalkSpeed = 28
    
    local currentWaypointIndex = 1
    
    local function moveToNextWaypoint()
        if currentWaypointIndex > #waypoints then return true end
        
        local waypoint = waypoints[currentWaypointIndex]
        
        if waypoint.Action == Enum.PathWaypointAction.Jump then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        
        humanoid:MoveTo(waypoint.Position)
        currentWaypointIndex = currentWaypointIndex + 1
        return false
    end
    
    local reachedConnection
    local blockedConnection
    local timeout = tick()
    
    reachedConnection = humanoid.MoveToFinished:Connect(function(reached)
        if reached then
            local done = moveToNextWaypoint()
            if done then
                if reachedConnection then reachedConnection:Disconnect() end
                if blockedConnection then blockedConnection:Disconnect() end
            end
        else
            if reachedConnection then reachedConnection:Disconnect() end
            if blockedConnection then blockedConnection:Disconnect() end
        end
    end)
    
    blockedConnection = path.Blocked:Connect(function()
        warn("Path blocked, stopping pathfind")
        if reachedConnection then reachedConnection:Disconnect() end
        if blockedConnection then blockedConnection:Disconnect() end
    end)
    
    moveToNextWaypoint()
    
    while autoGenEnabled and isDoingGenerators do
        if (hrp.Position - valve.Position).Magnitude < 10 then
            break
        end
        if tick() - timeout > 30 then
            warn("Pathfinding timeout")
            break
        end
        task.wait(0.1)
    end
    
    if reachedConnection then reachedConnection:Disconnect() end
    if blockedConnection then blockedConnection:Disconnect() end
    humanoid:MoveTo(hrp.Position)
    
    return true
end

local function waitForGeneratorCompletion(currentCount)
    local playerStats = Workspace:FindFirstChild("Info") and Workspace.Info:FindFirstChild("PlayerStats")
    if not playerStats then 
        warn("PlayerStats not found")
        return false 
    end
    
    local playerStat = playerStats:FindFirstChild(Player.Name)
    if not playerStat then 
        warn("Player stat for " .. Player.Name .. " not found")
        return false 
    end
    
    local genValue = playerStat:FindFirstChild("Generators")
    if not genValue then 
        warn("Generators value not found")
        return false 
    end
    
    Library:Notify("Current count: " .. currentCount .. " | Waiting for: " .. (currentCount + 1))
    
    while autoGenEnabled and isDoingGenerators do
        if genValue.Value > currentCount then
            Library:Notify("Value increased! New count: " .. genValue.Value)
            return true
        end
        task.wait(0.2)
    end
    
    return false
end

local function doAutoGenerators()
    if isDoingGenerators then return end
    isDoingGenerators = true
    visitedGenerators = {}
    
    task.spawn(function()
        local room = Workspace:FindFirstChild("CurrentRoom")
        if not room then 
            Library:Notify("No CurrentRoom found!")
            isDoingGenerators = false
            return 
        end
        
        local roomModel = nil
        local generatorsFolder = nil
        
        for _, child in pairs(room:GetChildren()) do
            if child:IsA("Model") then
                local genFolder = child:FindFirstChild("Generators")
                if genFolder then
                    roomModel = child
                    generatorsFolder = genFolder
                    break
                end
            end
        end
        
        if not roomModel or not generatorsFolder then 
            Library:Notify("No room with Generators found!")
            isDoingGenerators = false
            return 
        end
        
        Library:Notify("Found room: " .. roomModel.Name)
        
        local playerStats = Workspace:FindFirstChild("Info") and Workspace.Info:FindFirstChild("PlayerStats")
        local playerStat = playerStats and playerStats:FindFirstChild(Player.Name)
        local genValue = playerStat and playerStat:FindFirstChild("Generators")
        
        if not genValue then
            Library:Notify("Could not find player generator stats!")
            isDoingGenerators = false
            return
        end
        
        local isFirstGenerator = true
        
        while autoGenEnabled and isDoingGenerators do
            local nearestGen = findNearestGenerator(generatorsFolder)
            
            if not nearestGen then
                Library:Notify("All generators completed!")
                break
            end
            
            visitedGenerators[nearestGen] = true
            
            if isFirstGenerator then
                Library:Notify("Pathfinding to first generator...")
                local pathSuccess = pathfindToGenerator(nearestGen)
                if not pathSuccess then
                    Library:Notify("Pathfinding failed, will teleport instead")
                    local valve = getGeneratorFakeValve(nearestGen)
                    if valve and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                        Player.Character.HumanoidRootPart.CFrame = valve.CFrame * CFrame.new(0, 3, 0)
                        task.wait(0.3)
                    end
                end
                isFirstGenerator = false
            else
                local valve = getGeneratorFakeValve(nearestGen)
                if valve and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    Player.Character.HumanoidRootPart.CFrame = valve.CFrame * CFrame.new(0, 3, 0)
                    task.wait(0.3)
                end
            end
            
            local currentGenCount = genValue.Value
            
            local fired = fireGeneratorPrompt(nearestGen)
            if fired then
                Library:Notify("Generator activated! Waiting 3 seconds...")
                task.wait(3)
                
                local nextGen = findNearestGenerator(generatorsFolder)
                if nextGen then
                    Library:Notify("Teleporting to next generator...")
                    local valve = getGeneratorFakeValve(nextGen)
                    if valve and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                        Player.Character.HumanoidRootPart.CFrame = valve.CFrame * CFrame.new(0, 3, 0)
                        task.wait(0.3)
                    end
                end
                
                Library:Notify("Waiting for previous generator to complete...")
                local completed = waitForGeneratorCompletion(currentGenCount)
                if completed then
                    Library:Notify("Previous generator completed! Ready for next...")
                else
                    Library:Notify("Timeout - Continuing anyway...")
                end
            else
                Library:Notify("Failed to fire generator prompt")
                task.wait(1)
            end
            
            task.wait(0.5)
        end
        
        isDoingGenerators = false
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = 16
        end
    end)
end

-- ============================================================================
--  ANTI-LAG SYSTEM
-- ============================================================================

local REMOVED = 0
local originalPartProperties = {}

local function optimize(obj)
    if not antiLagEnabled then return end
    
    if obj:IsA("ParticleEmitter")
    or obj:IsA("Trail")
    or obj:IsA("Smoke")
    or obj:IsA("Fire")
    or obj:IsA("Sparkles") then
        obj:Destroy()
        REMOVED += 1
    end
    
    if obj:IsA("BasePart") then
        if not originalPartProperties[obj] then
            originalPartProperties[obj] = {
                Material = obj.Material,
                Reflectance = obj.Reflectance,
                CastShadow = obj.CastShadow
            }
        end
        obj.Material = Enum.Material.Plastic
        obj.Reflectance = 0
        obj.CastShadow = false
    end
    
    if obj:IsA("Decal") or obj:IsA("Texture") then
        obj:Destroy()
        REMOVED += 1
    end
end

local function restoreParts()
    for obj, props in pairs(originalPartProperties) do
        if obj and obj.Parent then
            pcall(function()
                obj.Material = props.Material
                obj.Reflectance = props.Reflectance
                obj.CastShadow = props.CastShadow
            end)
        end
    end
    originalPartProperties = {}
end

local function initAntiLag()
    REMOVED = 0
    for _, v in ipairs(Workspace:GetDescendants()) do
        optimize(v)
    end
    Library:Notify("[AntiLag] Initial cleanup done. Removed: " .. REMOVED)
end

Workspace.DescendantAdded:Connect(function(obj)
    if antiLagEnabled then
        task.wait()
        optimize(obj)
    end
end)

-- ============================================================================
--  CORE LOGIC (AUTO GTE)
-- ============================================================================

local function teleportToElevator()
    if not autoGTEEnabled or hasTeleportedThisRound then return end
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = gteCFrame
        hasTeleportedThisRound = true
        Library:Notify("Floor Completed! Teleported to Elevator.")
    end
end

local function handleRoundLogic()
    safeDisconnect("GenMonitor")
    hasTeleportedThisRound = false
    
    task.wait(0.5)
    
    local info = Workspace:FindFirstChild("Info")
    if not info then 
        warn("Info folder not found")
        return 
    end

    local req = info:FindFirstChild("RequiredGenerators")
    local comp = info:FindFirstChild("GeneratorsCompleted")

    if req and comp then
        if autoGTEEnabled and req.Value > 0 and comp.Value >= req.Value then
            teleportToElevator()
        end
        
        Connections["GenMonitor"] = comp:GetPropertyChangedSignal("Value"):Connect(function()
            if autoGTEEnabled and req.Value > 0 and comp.Value >= req.Value then
                teleportToElevator()
            end
        end)
    else
        warn("RequiredGenerators or GeneratorsCompleted not found")
    end
    
    if itemAuraEnabled then updateItemPrompts() end
end

-- ============================================================================
--  VISUALS (ESP)
-- ============================================================================

local ESP_SETTINGS = {
    Monster = { Enabled = false, Color = Color3.fromRGB(255, 50, 50) },
    Generator = { Enabled = false, Color = Color3.fromRGB(50, 50, 255) },
    Item = { Enabled = false, Color = Color3.fromRGB(50, 255, 50) },
    Elevator = { Enabled = false, Color = Color3.fromRGB(255, 255, 0) },
    Player = { Enabled = false, Color = Color3.fromRGB(170, 100, 230) },
}

local ESP_OPTIONS = {
    Tracers = false,
    Labels = true,
}

local function ClearAllESP()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v.Name == "SynthESP_Highlight" or v.Name == "SynthESP_Text" or v.Name == "SynthESP_Tracer" then
            v:Destroy()
        end
    end
    
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        for _, v in pairs(Player.Character.HumanoidRootPart:GetChildren()) do
            if v.Name == "SynthESP_TracerOrigin" then
                v:Destroy()
            end
        end
    end
    
    if workspace.CurrentCamera then
        for _, v in pairs(workspace.CurrentCamera:GetChildren()) do
            if v.Name == "SynthESP_TracerOrigin" then
                v:Destroy()
            end
        end
    end
end

local function CreateESP(instance, typeName, textOverride)
    if not instance or instance:FindFirstChild("SynthESP_Highlight") then return end
    local settings = ESP_SETTINGS[typeName]
    if not settings or not settings.Enabled then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "SynthESP_Highlight"
    highlight.FillColor = settings.Color
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = instance

    if ESP_OPTIONS.Labels then
        local bb = Instance.new("BillboardGui")
        bb.Name = "SynthESP_Text"
        bb.Adornee = instance
        bb.Size = UDim2.new(0, 200, 0, 50)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.Parent = instance

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = textOverride or instance.Name
        label.TextColor3 = typeName == "Player" and Color3.fromRGB(255, 255, 255) or settings.Color
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.Parent = bb
    end
    
    if ESP_OPTIONS.Tracers then
        local attachment = Instance.new("Attachment")
        attachment.Name = "SynthESP_Tracer"
        attachment.Parent = instance:IsA("Model") and (instance:FindFirstChild("HumanoidRootPart") or instance:FindFirstChildWhichIsA("BasePart")) or instance
        
        local beam = Instance.new("Beam")
        beam.Name = "SynthESP_Tracer"
        beam.Color = ColorSequence.new(settings.Color)
        beam.FaceCamera = true
        beam.Width0 = 0.1
        beam.Width1 = 0.1
        beam.Transparency = NumberSequence.new(0.5)
        beam.Attachment0 = attachment
        
        local camAttachment = Instance.new("Attachment")
        camAttachment.Name = "SynthESP_TracerOrigin"
        
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            camAttachment.Parent = Player.Character.HumanoidRootPart
        else
            camAttachment.Parent = workspace.CurrentCamera
        end
        
        beam.Attachment1 = camAttachment
        beam.Parent = instance
    end
end

local function ProcessObject(obj)
    local nameLower = obj.Name:lower()
    if nameLower:find("blocker") or nameLower:find("clip") or nameLower:find("trigger") then return end

    if obj.Name == "ElevatorDoor" and obj:IsDescendantOf(Workspace:FindFirstChild("Elevators")) then
        CreateESP(obj, "Elevator", "Elevator")
        return
    end

    if (obj:IsA("Model") or obj:IsA("BasePart")) and (nameLower:find("monster") or (obj.Parent and obj.Parent.Name == "Monsters")) then
        CreateESP(obj, "Monster", obj.Name:gsub("Monster", ""))
    end

    if obj.Name == "Generator" then
        CreateESP(obj, "Generator", "Generator")
    end

    if (obj:IsA("Model") or obj:IsA("BasePart")) and not obj.Name:find("Generator") then
        if (obj.Parent and obj.Parent.Name == "Items") or (obj:FindFirstChild("InteractPrompt") and not obj:IsDescendantOf(Workspace:FindFirstChild("Elevators"))) then
            CreateESP(obj, "Item", obj.Name)
        end
    end
    
    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
        local isPlayer = Players:GetPlayerFromCharacter(obj)
        if isPlayer and isPlayer ~= Player then
            CreateESP(obj, "Player", isPlayer.Name)
        end
    end
end

local function RefreshFullESP()
    ClearAllESP()
    for _, obj in pairs(Workspace:GetDescendants()) do ProcessObject(obj) end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            ProcessObject(plr.Character)
        end
    end
end

local function SetupWorldWatcher()
    local function HandleNewFolder(child)
        if child.Name == "CurrentRoom" then
            task.wait(1)
            handleRoundLogic()
            RefreshFullESP()
            
            hasTeleportedThisRound = false
            
            if autoGenEnabled then
                task.wait(0.5)
                doAutoGenerators()
            end
            
            safeDisconnect("RoomChildAdded")
            Connections["RoomChildAdded"] = child.DescendantAdded:Connect(function(d)
                task.wait(0.2)
                ProcessObject(d)
                if itemAuraEnabled and d:IsA("ProximityPrompt") then
                    d.MaxActivationDistance = 12
                end
            end)
        end
    end

    if Workspace:FindFirstChild("CurrentRoom") then
        HandleNewFolder(Workspace.CurrentRoom)
    end

    Connections["GlobalWorldWatcher"] = Workspace.ChildAdded:Connect(HandleNewFolder)
end

-- ============================================================================
--  MAIN UI
-- ============================================================================

MainLeft:AddToggle('AutoGTE', { Text = 'Auto GTE', Callback = function(v) autoGTEEnabled = v end })

MainLeft:AddToggle('AutoGenerators', { 
    Text = 'Auto Generators', 
    Callback = function(v) 
        autoGenEnabled = v 
        if v then
            doAutoGenerators()
        else
            isDoingGenerators = false
            visitedGenerators = {}
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.WalkSpeed = 16
            end
        end
    end 
})

MainLeft:AddToggle('ItemAura', { 
    Text = 'Item Aura', 
    Callback = function(v) 
        itemAuraEnabled = v 
        updateItemPrompts()
    end 
})

MainLeft:AddToggle('AutoSkillCheck', {
    Text = 'Auto Skill Check',
    Callback = function(v)
        safeDisconnect("AutoSkill")
        if v then
            Connections["AutoSkill"] = RunService.Heartbeat:Connect(function()
                local gui = Player.PlayerGui:FindFirstChild("ScreenGui")
                local frame = gui and gui:FindFirstChild("Menu") and gui.Menu:FindFirstChild("SkillCheckFrame")
                if frame and frame.Visible then
                    local marker, gold = frame:FindFirstChild("Marker"), frame:FindFirstChild("GoldArea")
                    if marker and gold then
                        local mPos, gPos, gSize = marker.Position.X.Scale, gold.Position.X.Scale, gold.Size.X.Scale
                        if mPos >= gPos and mPos <= (gPos + gSize) then
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                            task.wait()
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                        end
                    end
                end
            end)
        end
    end
})

MainRight:AddToggle('SpeedHack', { 
    Text = 'Speed Hack', 
    Default = false,
    Callback = function(v) 
        if v and Toggles.PulseSpeed and Toggles.PulseSpeed.Value then
            Toggles.PulseSpeed:SetValue(false)
            Library:Notify("Pulse Speed disabled - Speed Hack enabled")
        end
        if not v then
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.WalkSpeed = 16
            end
        end
    end 
})

MainRight:AddSlider('SpeedValue', { 
    Text = 'Speed Value', 
    Default = 16, 
    Min = 16, 
    Max = 50, 
    Rounding = 0, 
    Callback = function(v) end 
})

MainRight:AddDivider()

local pulseTimer = 0
local isHighSpeed = false

MainRight:AddToggle('PulseSpeed', { 
    Text = 'Pulse Speed', 
    Default = false,
    Callback = function(v) 
        if v and Toggles.SpeedHack and Toggles.SpeedHack.Value then
            Toggles.SpeedHack:SetValue(false)
            Library:Notify("Speed Hack disabled - Pulse Speed enabled")
        end
        if not v then
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.WalkSpeed = 16
            end
            pulseTimer = 0
            isHighSpeed = false
        end
    end 
})

MainRight:AddSlider('PulseValue', { 
    Text = 'Pulse Speed Value', 
    Default = 50, 
    Min = 50, 
    Max = 300, 
    Rounding = 0, 
    Callback = function(v) end 
})

RunService.Heartbeat:Connect(function(dt)
    if Toggles.SpeedHack and Toggles.SpeedHack.Value then
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = Options.SpeedValue.Value
        end
    end
    
    if Toggles.PulseSpeed and Toggles.PulseSpeed.Value then
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            pulseTimer = pulseTimer + dt
            if pulseTimer >= 0.5 then
                pulseTimer = 0
                isHighSpeed = not isHighSpeed
            end
            
            Player.Character.Humanoid.WalkSpeed = isHighSpeed and Options.PulseValue.Value or 16
        end
    end
end)

-- ============================================================================
--  VISUALS & ENVIRONMENT
-- ============================================================================

ESPsGroup:AddToggle('ESP_Monster', { Text = 'Twisted ESP', Callback = function(v) ESP_SETTINGS.Monster.Enabled = v RefreshFullESP() end })
ESPsGroup:AddToggle('ESP_Generator', { Text = 'Generator ESP', Callback = function(v) ESP_SETTINGS.Generator.Enabled = v RefreshFullESP() end })
ESPsGroup:AddToggle('ESP_Item', { Text = 'Items ESP', Callback = function(v) ESP_SETTINGS.Item.Enabled = v RefreshFullESP() end })
ESPsGroup:AddToggle('ESP_Elevator', { Text = 'Elevator ESP', Callback = function(v) ESP_SETTINGS.Elevator.Enabled = v RefreshFullESP() end })
ESPsGroup:AddToggle('ESP_Player', { Text = 'Player ESP', Callback = function(v) ESP_SETTINGS.Player.Enabled = v RefreshFullESP() end })

ESPOptionsGroup:AddToggle('ESP_Labels', { 
    Text = 'Labels', 
    Default = true,
    Callback = function(v) 
        ESP_OPTIONS.Labels = v 
        RefreshFullESP() 
    end 
})

ESPOptionsGroup:AddToggle('ESP_Tracers', { 
    Text = 'Tracers', 
    Default = false,
    Callback = function(v) 
        ESP_OPTIONS.Tracers = v 
        RefreshFullESP() 
    end 
})

PlayerVisualsGroup:AddToggle('FOVToggle', {
    Text = 'Field of View',
    Default = false,
    Callback = function(v)
        if not v then
            workspace.CurrentCamera.FieldOfView = 70
        end
    end
})

PlayerVisualsGroup:AddSlider('FOVSlider', {
    Text = 'FOV Value',
    Default = 70,
    Min = 0,
    Max = 120,
    Rounding = 0,
    Callback = function(v)
        if Toggles.FOVToggle and Toggles.FOVToggle.Value then
            workspace.CurrentCamera.FieldOfView = v
        end
    end
})

RunService.RenderStepped:Connect(function()
    if Toggles.FOVToggle and Toggles.FOVToggle.Value then
        workspace.CurrentCamera.FieldOfView = Options.FOVSlider.Value
    end
end)

local DefaultLighting = {
    Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart,
    Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
}

EnvGroup:AddToggle('Fullbright', {
    Text = 'Fullbright',
    Callback = function(v)
        safeDisconnect("FBLoop")
        if v then
            Connections["FBLoop"] = RunService.RenderStepped:Connect(function()
                Lighting.Brightness = 2 Lighting.ClockTime = 14 Lighting.FogEnd = 100000
                Lighting.Ambient = Color3.new(1,1,1) Lighting.OutdoorAmbient = Color3.new(1,1,1)
            end)
        else
            Lighting.Brightness = DefaultLighting.Brightness Lighting.ClockTime = DefaultLighting.ClockTime
            Lighting.FogEnd = DefaultLighting.FogEnd Lighting.Ambient = DefaultLighting.Ambient
        end
    end
})

EnvGroup:AddToggle('NoFog', {
    Text = 'No Fog',
    Callback = function(v)
        safeDisconnect("FogLoop")
        if v then
            Connections["FogLoop"] = RunService.RenderStepped:Connect(function()
                Lighting.FogEnd = 100000 Lighting.FogStart = 0
                for _, x in pairs(Lighting:GetChildren()) do if x:IsA("Atmosphere") then x.Density = 0 end end
            end)
        else
            Lighting.FogEnd = DefaultLighting.FogEnd Lighting.FogStart = DefaultLighting.FogStart
        end
    end
})

EnvGroup:AddToggle('AntiLag', {
    Text = 'Anti-Lag',
    Default = false,
    Callback = function(v)
        antiLagEnabled = v
        if v then
            Library:Notify("Anti-Lag enabled - Optimizing game...")
            initAntiLag()
        else
            Library:Notify("Anti-Lag disabled - Restoring parts...")
            restoreParts()
        end
    end
})

RunService.RenderStepped:Connect(function()
    if antiLagEnabled then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end
end)

-- ============================================================================
--  INIT
-- ============================================================================

ExtrasLeft:AddButton('Infinite Yield', function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder('SynthHub_Dandy')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])

SetupWorldWatcher()

Player.CharacterAdded:Connect(function()
    task.wait(1)
    if ESP_OPTIONS.Tracers then
        RefreshFullESP()
    end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(1)
        if ESP_SETTINGS.Player.Enabled then
            ProcessObject(char)
        end
    end)
end)

Library:OnUnload(function()
    for _, c in pairs(Connections) do if c then c:Disconnect() end end
    ClearAllESP()
    Library.Unloaded = true
end)
elseif currentID == 10660791703 then
    -- Extended sUNC-style Executor Capability Checker
-- No sUNC table, no execution, environment validation only

local functionList = {
    -- Environment / Globals
    "getgenv", "getrenv", "getfenv", "setfenv", "getgc", "getreg",

    -- Closure / Function Introspection
    "islclosure", "iscclosure", "isexecutorclosure", "newcclosure",
    "clonefunction", "hookfunction", "replaceclosure",

    -- Metamethod / Namecall
    "getrawmetatable", "setrawmetatable",
    "getnamecallmethod", "setnamecallmethod",
    "hookmetamethod",

    -- Readonly / Table Control
    "setreadonly", "isreadonly",
    "make_readonly", "make_writeable",

    -- Script / Module Introspection
    "getscripts", "getloadedmodules", "getsenv",
    "getscriptclosure", "getscriptbytecode",
    "getcallingscript",

    -- Connections / Signals
    "getconnections", "firesignal",

    -- Debug Library
    "debug.getupvalue", "debug.getupvalues",
    "debug.setupvalue", "debug.setstack",
    "debug.getstack", "debug.traceback",
    "debug.getproto", "debug.getprotos",

    -- File System
    "readfile", "writefile", "appendfile",
    "makefolder", "delfolder",
    "listfiles", "isfile", "isfolder", "delfile",

    -- HTTP / Network
    "request", "http_request", "syn.request",

    -- Input / Misc
    "mouse1click", "mouse1press", "mouse1release",
    "mouse2click", "keypress", "keyrelease",

    -- Executor Info
    "identifyexecutor", "getexecutorname",

    -- Threading / Task
    "queue_on_teleport", "setthreadidentity",
    "getthreadidentity", "setidentity"
}

local supported = 0
local total = #functionList

for _, fname in ipairs(functionList) do
    local fn =
        rawget(getgenv(), fname) or
        rawget(_G, fname)

    if typeof(fn) == "function" then
        local ok = pcall(function()
            return tostring(fn)
        end)

        if ok then
            supported += 1
            print("✅ " .. fname)
        else
            print("❌ " .. fname)
        end
    else
        print("❌ " .. fname)
    end
end

print(string.format(
    "🛠️ Supported functions: %d/%d",
    supported,
    total
))

-- Executor identification (safe, no execution of dangerous APIs)

local executor = "Unknown"

-- Modern standard
if typeof(identifyexecutor) == "function" then
    local ok, name = pcall(identifyexecutor)
    if ok and typeof(name) == "string" then
        executor = name
    end
end

-- Synapse fallback
if executor == "Unknown" and typeof(syn) == "table" and typeof(syn.getexecutorname) == "function" then
    local ok, name = pcall(syn.getexecutorname)
    if ok and typeof(name) == "string" then
        executor = name
    end
end

-- Generic executor globals
if executor == "Unknown" then
    local genv = getgenv and getgenv() or _G
    for _, key in ipairs({ "KRNL_LOADED", "FLUXUS_LOADED", "ELECTRON_LOADED", "WAVE_LOADED" }) do
        if genv[key] then
            executor = key:gsub("_LOADED", "")
            break
        end
    end
end

print("👻 Executor: " .. executor)
    print("Game Supported: Cart ride around nothing")
-- // Services \\ --

local v1 = workspace.Misc.Giver.ProximityPrompt
local Players = game:GetService("Players")
local v2 = Players.LocalPlayer
local v3
local v4
local v5 = game.Workspace.Spawners
local v6

local function UpdateCharacter(char)
    v3 = char
    v4 = char:WaitForChild("HumanoidRootPart")
    v6 = char:WaitForChild("Humanoid")
end

if v2.Character then
    UpdateCharacter(v2.Character)
end

v2.CharacterAdded:Connect(UpdateCharacter)

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
    Title = "Synth Hub",
    Footer = "Cart ride around nothing | Version: 1",
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Main = Window:AddTab("Main", "user"),
    Visuals = Window:AddTab("Visuals", "eye"),
    Extras = Window:AddTab("Extras", "boxes"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

local RightGroupBox = Tabs.Main:AddRightGroupbox("Badges")

local secretbadge = RightGroupBox:AddButton({
    Text = "Get Secret Badge",
    Func = function()
    v4.CFrame = CFrame.new(234.500259, 4.78452969, 296.495483)
    v1.RequiresLineOfSight = false
    game.Workspace.Camera.CFrame = CFrame.new(234.506393, 7.37084818, 296.697144, 0.999548614, -0.0295358226, 0.00548673933, 0, 0.18264094, 0.983179748, -0.0300411209, -0.982735932, 0.182558522)
    wait(0.2)
    fireproximityprompt(v1)
    wait(0.1)
    print("Claimed secret badge, returning to lobby")
    wait(1)
    v4.CFrame = CFrame.new(-4, 2.99802542, -28)
    print("Returned to lobby.")
    end,
    DoubleClick = false,
    Tooltip = "Gets the secret badge located in the tunnel",
})

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Main")

local checkpoint2 = LeftGroupBox:AddButton({
    Text = "Complete Checkpoint 1",
    Func = function()
    v4.CFrame = CFrame.new(-431.20105, 162.998016, 112.971413)
    task.wait(2)
    v4.CFrame = CFrame.new(-431.272095, 163.298019, 133.439621)
    v6.Sit = true
    task.wait(40)
    v4.CFrame = CFrame.new(-418.416016, 162.998016, 167.197021)
    task.wait(0.5)
    v6.Sit = false
    end,
    DoubleClick = false,
    Tooltip = "Completes the first checkpoint and makes you join the suffering team",
})

local checkpoint3 = LeftGroupBox:AddButton({
    Text = "Complete Checkpoint 2 (end)",
    Func = function()
    v4.CFrame = CFrame.new(-233.073441, 121.291847, -179.573547)
    task.wait(0.6)
    v4.Anchored = true
    task.wait(1.5)
    v4.CFrame = CFrame.new(-215.859985, 115.43145, -180.136078)
    v4.Anchored = false
    v6.Sit = true
    task.wait(40)
    v4.CFrame = CFrame.new(-147.401611, 93.7178802, -181.203766)
    task.wait(0.05)
    v6.Sit = false
    end,
    DoubleClick = false,
    Tooltip = "Goes to the end of the game (MUST COMPLETE FIRST CHECKPOINT)",
})

local spawnallcarts = LeftGroupBox:AddButton({
    Text = "Spawn All Available Carts",
    Func = function()
    for _, v in pairs(v5:GetChildren()) do
        if v.Name == "SpawnButton" and v.Color == Color3.fromRGB(31, 128, 29) then
            v4.CFrame = v.CFrame
            wait(0.2)
            for _, k in pairs(v:GetChildren()) do
                if k:IsA("ProximityPrompt") then
                    fireproximityprompt(k)
                    wait(0.2)
                end
            end
        end
    end
    end,
    DoubleClick = false,
    Tooltip = "Spawns all free carts",
})

local LeftGroupBoxVisuals = Tabs.Visuals:AddLeftGroupbox("ESP")

-- // Player ESP Toggle \\ --
LeftGroupBoxVisuals:AddToggle("PlayerESP", {
    Default = false,
    Text = "Player ESP",
    Callback = function(enabled)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local HIGHLIGHT_NAME = "PlayerHighlight"

        _G.PlayerESP = _G.PlayerESP or {
            connections = {},
            enabled = false
        }

        local ESP = _G.PlayerESP

        local function addHighlight(character)
            if not ESP.enabled then return end
            if not character or character:FindFirstChild(HIGHLIGHT_NAME) then return end

            local h = Instance.new("Highlight")
            h.Name = HIGHLIGHT_NAME
            h.Adornee = character
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.FillTransparency = 0.5
            h.OutlineTransparency = 0
            h.Parent = character
        end

        local function removeHighlight(character)
            if character then
                local h = character:FindFirstChild(HIGHLIGHT_NAME)
                if h then h:Destroy() end
            end
        end

        local function setupPlayer(player)
            if player == LocalPlayer then return end
            if player.Character then addHighlight(player.Character) end
            table.insert(ESP.connections, player.CharacterAdded:Connect(addHighlight))
        end

        if enabled then
            ESP.enabled = true
            for _, p in ipairs(Players:GetPlayers()) do setupPlayer(p) end
            table.insert(ESP.connections, Players.PlayerAdded:Connect(setupPlayer))
        else
            ESP.enabled = false
            for _, p in ipairs(Players:GetPlayers()) do if p.Character then removeHighlight(p.Character) end end
            for _, c in ipairs(ESP.connections) do c:Disconnect() end
            table.clear(ESP.connections)
        end
    end,
})

-- // Carts ESP Toggle \\ --
LeftGroupBoxVisuals:AddToggle("CartsESP", {
    Default = false,
    Text = "Carts ESP",
    Callback = function(enabled)
        local CartsFolder = game.Workspace:FindFirstChild("Carts")
        local HIGHLIGHT_NAME = "CartHighlight"
        
        _G.CartsESP = _G.CartsESP or {
            connections = {},
            enabled = false
        }
        
        local ESP = _G.CartsESP

        local function addHighlight(model)
            if not ESP.enabled or not model:IsA("Model") then return end
            if model:FindFirstChild(HIGHLIGHT_NAME) then return end

            local h = Instance.new("Highlight")
            h.Name = HIGHLIGHT_NAME
            h.Adornee = model
            h.FillColor = Color3.fromRGB(0, 0, 255) -- Bright Blue
            h.OutlineColor = Color3.new(1, 1, 1)      -- White Outline
            h.FillTransparency = 0.5
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.Parent = model
        end

        local function removeHighlights()
            if CartsFolder then
                for _, cart in ipairs(CartsFolder:GetChildren()) do
                    local h = cart:FindFirstChild(HIGHLIGHT_NAME)
                    if h then h:Destroy() end
                end
            end
        end

        if enabled then
            ESP.enabled = true
            if CartsFolder then
                -- Highlight existing carts
                for _, cart in ipairs(CartsFolder:GetChildren()) do
                    addHighlight(cart)
                end
                -- Listen for new carts
                table.insert(ESP.connections, CartsFolder.ChildAdded:Connect(function(child)
                    task.wait(0.1) -- Small delay to ensure model is loaded
                    addHighlight(child)
                end))
            end
        else
            ESP.enabled = false
            removeHighlights()
            for _, c in ipairs(ESP.connections) do c:Disconnect() end
            table.clear(ESP.connections)
        end
    end,
})

local scriptsGroup = Tabs.Extras:AddLeftGroupbox("Scripts")

scriptsGroup:AddButton("Iy", {
    Text = "Infinite Yield",
    Func = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end,
    DoubleClick = true,
    
    Tooltip = "Loads the script Infinite Yield (FE)",
})

scriptsGroup:AddButton("dexplusplus", {
    Text = "DEX++",
    Func = function()
    loadstring(game:HttpGet("https://github.com/AZYsGithub/DexPlusPlus/releases/latest/download/out.lua"))()
    end,
    DoubleClick = true,
    
    Tooltip = "Loads the script DEX++",
})

local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench")

MenuGroup:AddToggle("KeybindMenuOpen", {
	Default = Library.KeybindFrame.Visible,
	Text = "Open Keybind Menu",
	Callback = function(value)
		Library.KeybindFrame.Visible = value
	end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
	Text = "Custom Cursor",
	Default = true,
	Callback = function(Value)
		Library.ShowCustomCursor = Value
	end,
})
MenuGroup:AddDropdown("NotificationSide", {
	Values = { "Left", "Right" },
	Default = "Right",

	Text = "Notification Side",

	Callback = function(Value)
		Library:SetNotifySide(Value)
	end,
})
MenuGroup:AddDropdown("DPIDropdown", {
	Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
	Default = "100%",

	Text = "DPI Scale",

	Callback = function(Value)
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)

		Library:SetDPIScale(DPI)
	end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
	:AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
	Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:SetSubFolder("specific-place")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

elseif currentID == 9772878203 or 9921522947 then
    
for _, x in pairs(game.Workspace:GetDescendants()) do
    if x:IsA("ProximityPrompt") then
        x.RequiresLineOfSight = false
    end
end
for _, h in pairs(game.Workspace:GetDescendants()) do
    if h:IsA("ClickDetector") then
        h.MaxActivationDistance = 9e9
    end
end

-- // getgenv()'s \\ --
getgenv().FloppaAutofarm = true
getgenv().BabyFloppasAutofarm = true
getgenv().AutoCollectMoney = true
getgenv().CheckHappiness = true
getgenv().AutoCollectGold = true

-- // Services \\ --
local Workspace = game.Workspace
local Players = game.Players

-- // Variables \\ --
local Floppa = Workspace:FindFirstChild("Floppa")

-- Safe check for Ms. Floppa
local Unlocks = Workspace:FindFirstChild("Unlocks")
if Unlocks then
local MsFloppa = Workspace.Unlocks:FindFirstChild("Ms. Floppa")
if not MsFloppa then
    print("no ms floppa")
end
else
    return
end

-- Safe check for Baby Floppa (prevents crashing if you don't have this either)
-- Wait up to 10 seconds for Unlocks to load
local UnlocksFolder = Workspace:WaitForChild("Unlocks", 10)

-- Check if it loaded, otherwise prevent crash
if not UnlocksFolder then 
    warn("Unlocks folder failed to load!") 
    return 
end

local BabyFloppa = UnlocksFolder:FindFirstChild("Baby Floppa")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character.HumanoidRootPart

-- // UI References \\ --
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local FloppaUI = PlayerGui:WaitForChild("FloppaUI")
local PercentageLabel = FloppaUI.Frame.Floppa.Happiness.Percentage

-- // UI \\ --
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
    Title = "Synth Hub",
	Footer = "Raise A Floppa 2 | Version: 1",
	NotifySide = "Right",
	ShowCustomCursor = true,
})

local Tabs = {
	Main = Window:AddTab("Main", "house"),
    Player = Window:AddTab("Player", "user"),
    Visuals = Window:AddTab("Visuals", "eye"),
    Teleports = Window:AddTab("Teleports", "map-pin"),
    Misc = Window:AddTab("Misc", "wrench"),
    Extras = Window:AddTab("Extras", "boxes"),
	["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

-- // Player \\ --

local LeftGroupBoxPlayer = Tabs.Player:AddLeftGroupbox("Player")

-- Toggle
LeftGroupBoxPlayer:AddToggle("SpeedHack", {
    Text = "Enable Speed Hack",
    Default = false,
})

-- Slider (compact, under toggle)
LeftGroupBoxPlayer:AddSlider("WalkSpeed", {
    Text = "Walk Speed",
    Default = 16,
    Min = 16,
    Max = 250,
    Rounding = 0,
    Compact = true,

    Parent = "SpeedHack",

    Callback = function(Value)
        local humanoid = Character:FindFirstChild("Humanoid")
        if humanoid and Toggles.SpeedHack.Value then
            humanoid.WalkSpeed = Value
        end
    end,
})

-- Jump Power toggle
LeftGroupBoxPlayer:AddToggle("JumpPowerHack", {
    Text = "Enable Jump Power",
    Default = false,
})

-- Jump Power slider
LeftGroupBoxPlayer:AddSlider("JumpPower", {
    Text = "Jump Power",
    Default = 50,
    Min = 50,
    Max = 250,
    Rounding = 0,
    Compact = true,

    Parent = "JumpPowerHack",

    Callback = function(Value)
        local humanoid = Character:FindFirstChild("Humanoid")
        if humanoid and Toggles.JumpPowerHack.Value then
            humanoid.JumpPower = Value
        end
    end,
})

-- Apply / reset logic
Toggles.JumpPowerHack:OnChanged(function()
    local humanoid = Character:FindFirstChild("Humanoid")
    if not humanoid then return end

    if Toggles.JumpPowerHack.Value then
        humanoid.JumpPower = Options.JumpPower.Value
    else
        humanoid.JumpPower = 50 -- 🔁 reset
    end
end)

LeftGroupBoxPlayer:AddDivider()

LeftGroupBoxPlayer:AddToggle("NoClip", {
    Text = "Noclip",
    Default = false,
})

local RunService = game:GetService("RunService")
local NoClipConnection

Toggles.NoClip:OnChanged(function()
    if NoClipConnection then
        NoClipConnection:Disconnect()
        NoClipConnection = nil
    end

    if Toggles.NoClip.Value then
        NoClipConnection = RunService.Stepped:Connect(function()
            if Character then
                for _, v in ipairs(Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
end)

LeftGroupBoxPlayer:AddToggle("Fly", {
    Text = "Fly",
    Default = false,
})

LeftGroupBoxPlayer:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Default = 60,
    Min = 10,
    Max = 250,
    Rounding = 0,
    Compact = true,

    Parent = "Fly",
})

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local FlyConnection
local BodyVelocity
local BodyGyro

Toggles.Fly:OnChanged(function()
    local hrp = Character and Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- CLEANUP (disable fly)
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end

    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end

    if BodyGyro then
        BodyGyro:Destroy()
        BodyGyro = nil
    end

    -- ENABLE FLY
    if Toggles.Fly.Value then
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        BodyVelocity.Velocity = Vector3.zero
        BodyVelocity.Parent = hrp

        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        BodyGyro.P = 1e5
        BodyGyro.CFrame = Camera.CFrame
        BodyGyro.Parent = hrp

        FlyConnection = RunService.RenderStepped:Connect(function()
            local moveVec = Vector3.zero
            local camCF = Camera.CFrame
            local speed = Options.FlySpeed.Value

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveVec += camCF.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveVec -= camCF.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveVec -= camCF.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveVec += camCF.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveVec += camCF.UpVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveVec -= camCF.UpVector
            end

            -- 🔥 INSTANT movement (no smoothing)
            if moveVec.Magnitude > 0 then
                BodyVelocity.Velocity = moveVec.Unit * speed
            else
                BodyVelocity.Velocity = Vector3.zero
            end

            -- snap rotation to camera
            BodyGyro.CFrame = camCF
        end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char

    if Toggles.NoClip.Value then
        Toggles.NoClip:SetValue(false)
        Toggles.NoClip:SetValue(true)
    end

    if Toggles.Fly.Value then
        Toggles.Fly:SetValue(false)
        Toggles.Fly:SetValue(true)
    end
end)

LeftGroupBoxPlayer:AddDivider()

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local InfiniteJumpConnection

LeftGroupBoxPlayer:AddToggle("InfiniteJump", {
    Text = "Infinite Jump",
    Default = false,
})

Toggles.InfiniteJump:OnChanged(function()
    -- disconnect if turning off
    if InfiniteJumpConnection then
        InfiniteJumpConnection:Disconnect()
        InfiniteJumpConnection = nil
    end

    -- connect when enabled
    if Toggles.InfiniteJump.Value then
        InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            local humanoid = Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char

    if Toggles.InfiniteJump.Value then
        -- reconnect JumpRequest cleanly
        Toggles.InfiniteJump:SetValue(false)
        Toggles.InfiniteJump:SetValue(true)
    end
end)

local PromptFixEnabled = false
local PromptConnections = {}

local function applyPrompt(prompt)
    if not PromptFixEnabled then return end
    prompt.HoldDuration = 0
end

local function hookPrompt(prompt)
    if PromptConnections[prompt] then return end

    PromptConnections[prompt] = prompt.PromptShown:Connect(function()
        applyPrompt(prompt)
    end)
end

local function enablePromptFix()
    PromptFixEnabled = true

    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            applyPrompt(v)
            hookPrompt(v)
        end
    end
end

local function disablePromptFix()
    PromptFixEnabled = false
    -- We don't disconnect on purpose; logic gate blocks changes
end

Workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
        hookPrompt(obj)
        applyPrompt(obj)
    end
end)

LeftGroupBoxPlayer:AddToggle("InstantPrompts", {
    Text = "Instant PPs",
    Default = false,
    Callback = function(Value)
        if Value then
            enablePromptFix()
        else
            disablePromptFix()
        end
    end
})

local AntiAfkConnection

LeftGroupBoxPlayer:AddToggle("AntiAFK", {
    Text = "Anti AFK",
    Default = false,
})

Toggles.AntiAFK:OnChanged(function()
    if Toggles.AntiAFK.Value then
        AntiAfkConnection = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    else
        if AntiAfkConnection then
            AntiAfkConnection:Disconnect()
            AntiAfkConnection = nil
        end
    end
end)


LeftGroupBoxPlayer:AddToggle("DisableVoid", {
    Text = "Disable Roblox Void",
    Default = false,
})

Toggles.DisableVoid:OnChanged(function()
    if Toggles.DisableVoid.Value then
        workspace.FallenPartsDestroyHeight = -math.huge
    else
        workspace.FallenPartsDestroyHeight = OldVoidHeight
    end
end)

-- Reset / apply logic
Toggles.SpeedHack:OnChanged(function()
    local humanoid = Character:FindFirstChild("Humanoid")
    if not humanoid then return end

    if Toggles.SpeedHack.Value then
        humanoid.WalkSpeed = Options.WalkSpeed.Value
    else
        humanoid.WalkSpeed = 16 -- reset when disabled
    end
end)

-- // Scripts \\ --

local ExtrasLeftGroupBox = Tabs.Extras:AddLeftGroupbox("Scripts")

local InfiniteYield = ExtrasLeftGroupBox:AddButton({
    Text = "Infinite Yield",
    Func = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end,
})

-- // Floppa Auto Farm \\ --

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Automation")

LeftGroupBox:AddToggle("FloppaAutoFarm", {
    Text = "Floppa Auto Farm",
    Tooltip = "Automatically clicks floppa.",
    Default = false,

    Callback = function(Value)
        FloppaAutofarm = Value

        if Value then
            task.spawn(function()
                while FloppaAutofarm do
                    fireclickdetector(Floppa.ClickDetector)
                    task.wait()
                end
            end)
        end
    end,
})

-- // Baby Floppas Auto Farm \\ --

LeftGroupBox:AddToggle("BabyFloppasAutoFarm", {
    Text = "Baby Floppas Auto Farm",
    Tooltip = "Automatically clicks all baby floppas.",
    Default = false,

    Callback = function(Value)
        BabyFloppasAutofarm = Value

        if Value then
            task.spawn(function()
                while BabyFloppasAutofarm do
                    for _, v in ipairs(Workspace.Unlocks:GetChildren()) do
                        if v.Name == "Baby Floppa" and v:FindFirstChild("ClickDetector") then
                            fireclickdetector(v.ClickDetector)
                        end
                    end
                    task.wait()
                end
            end)
        end
    end,
})

-- // Auto Collect Money \\ --

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Update HRP on reset
Player.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

local AutoCollectMoney = false
local AutoCollectThread

LeftGroupBox:AddToggle("AutoCollectMoney", {
    Text = "Auto Collect Money",
    Tooltip = "Automatically collects all of the moneys dropped (money bags included).",
    Default = false,

    Callback = function(Value)
        AutoCollectMoney = Value

        if Value and not AutoCollectThread then
            AutoCollectThread = task.spawn(function()
                while AutoCollectMoney do
                    if HumanoidRootPart then
                        for _, v in pairs(Workspace:GetChildren()) do
                            if v:IsA("BasePart") and (v.Name == "Money" or v.Name == "Money Bag") then
                                firetouchinterest(HumanoidRootPart, v, 0)
                                firetouchinterest(HumanoidRootPart, v, 1)
                            end
                        end
                    end
                    task.wait(0.1)
                end
                AutoCollectThread = nil
            end)
        end
    end,
})

-- // Auto Collect Gems \\ --

local gemNames = { "Diamond", "Emerald", "Ruby", "Sapphire" }
local AutoCollectGems = false

local function isGem(part)
	for _, name in ipairs(gemNames) do
		if part.Name == name then
			return true
		end
	end
	return false
end

LeftGroupBox:AddToggle("AutoCollectGems", {
	Text = "Auto Collect Gems",
	Tooltip = "Automatically pulls all gems to you.",
	Default = false,

	Callback = function(Value)
		AutoCollectGems = Value

		if Value then
			task.spawn(function()
				while AutoCollectGems do
					local char = LocalPlayer.Character
					local hrp = char and char:FindFirstChild("HumanoidRootPart")

					if hrp then
						for _, obj in ipairs(workspace:GetChildren()) do
							if isGem(obj) and obj:IsA("BasePart") then
								obj.Position = hrp.Position
							end
						end
					end

					task.wait(1) -- increase if laggy
				end
			end)
		end
	end
})

-- // Auto Pet Floppa \\ --
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local FloppaUI = PlayerGui:WaitForChild("FloppaUI")
local PercentageLabel = FloppaUI.Frame.Floppa.Happiness.Percentage

local HappinessConnection = nil

local function CheckHappiness()
    local text = PercentageLabel.Text
    local value = tonumber(text:match("(%d+)"))

    if value and value <= 50 then
        HumanoidRootPart.CFrame = Floppa:GetPivot()
        wait(0.1)
        fireproximityprompt(Floppa.HumanoidRootPart.ProximityPrompt)
    end
end

LeftGroupBox:AddToggle("AutoFloppaTP", {
	Text = "Auto Pet Floppa",
	Default = false,
	Tooltip = "Pets Floppa when its happiness reaches 50%.",

	Callback = function(Value)
		if Value then
			CheckHappiness()

			HappinessConnection = PercentageLabel:GetPropertyChangedSignal("Text"):Connect(CheckHappiness)
		else
			if HappinessConnection then
				HappinessConnection:Disconnect()
				HappinessConnection = nil
			end
		end
	end
})

-- =====================================================================
-- SERVICES & VARIABLES
-- =====================================================================

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

local lp = Players.LocalPlayer

-- =====================================================================
-- TOGGLE (UI HANDLED BY YOU)
-- =====================================================================

LeftGroupBox:AddToggle("AutoDefeat", {
    Text = "Auto Defeat Enemies",
    Default = false,
    Tooltip = "Auto kills enemies."
})

-- =====================================================================
-- UTILITY FUNCTIONS
-- =====================================================================

local function getCharacter()
    return lp.Character or lp.CharacterAdded:Wait()
end

-- ✅ CORRECT mouse click (no UserInputState)
local function precisionClick()
    local cam = Workspace.CurrentCamera
    if not cam then return end

    local vp = cam.ViewportSize
    local x, y = vp.X / 2, vp.Y / 2

    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.02)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

-- Weapon priority
local function getBestWeapon(char)
    local bp = lp:WaitForChild("Backpack")

    local excalibur = char:FindFirstChild("Excalibur") or bp:FindFirstChild("Excalibur")
    if excalibur then return excalibur end

    local sword = char:FindFirstChild("Sword") or bp:FindFirstChild("Sword")
    if sword then return sword end

    return nil
end

local function equipWeapon(hum, char)
    local weapon = getBestWeapon(char)
    if weapon and weapon.Parent ~= char then
        hum:EquipTool(weapon)
        task.wait(0.15)
    end
end

local function teleportBehind(hrp, target)
    hrp.CFrame = CFrame.new(
        target.Position - target.CFrame.LookVector * 3,
        target.Position
    )
end

-- ✅ EXACT triple click you asked for
local function tripleClick()
    precisionClick()
    task.wait(0.1)
    precisionClick()
    task.wait(0.1)
    precisionClick()
end

-- =====================================================================
-- MAIN LOOP
-- =====================================================================

task.spawn(function()
    while true do
        task.wait(0.1)

        if not Toggles.AutoDefeat.Value then
            continue
        end

        local ok, err = pcall(function()
            local enemyFolder = Workspace:FindFirstChild("Enemies")
            if not enemyFolder then return end

            for _, enemy in ipairs(enemyFolder:GetChildren()) do
                if not Toggles.AutoDefeat.Value then break end
                if not enemy:IsA("Model") then continue end

                local enemyHum = enemy:FindFirstChildOfClass("Humanoid")
                local target = enemy:FindFirstChild("HumanoidRootPart")
                    or enemy:FindFirstChildWhichIsA("BasePart")

                if not enemyHum or not target then
                    continue
                end

                -- LOCK ON
                while Toggles.AutoDefeat.Value
                    and enemy.Parent
                    and enemyHum.Health > 0 do

                    local char = getCharacter()
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChildOfClass("Humanoid")

                    if not hrp or not hum then break end

                    equipWeapon(hum, char)
                    teleportBehind(hrp, target)
                    hrp.Velocity = Vector3.zero

                    tripleClick()
                    task.wait(0.05)
                end
            end
        end)

        if not ok then
            warn("auto kill error (report to dev):", err)
        end
    end
end)

-- SERVICES
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- WAIT FOR LOCALPLAYER
local lp = Players.LocalPlayer
if not lp then
    repeat task.wait() lp = Players.LocalPlayer until lp
end

-- CHARACTER & HRP HANDLING
local Character = lp.Character or lp.CharacterAdded:Wait()
local hrp = Character:WaitForChild("HumanoidRootPart")

lp.CharacterAdded:Connect(function(char)
    Character = char
    hrp = char:WaitForChild("HumanoidRootPart")
end)

local GoldThread -- Variable to hold the loop thread

LeftGroupBox:AddToggle("AutoCollectGoldToggle", {
    Text = "Auto Collect Gold",
    Default = false,
    Tooltip = "Automatically collects MeshParts with 'Gold' in their name",
    
    Callback = function(Value)
        getgenv().AutoCollectGold = Value

        -- Start the loop if enabled and not already running
        if Value and not GoldThread then
            GoldThread = task.spawn(function()
                while getgenv().AutoCollectGold do
                    pcall(function()
                        -- Ensure HRP exists before trying to collect
                        if hrp then
                            -- Logic: Check workspace descendants for MeshParts named "Gold"
                            for _, v in ipairs(Workspace:GetDescendants()) do
                                if not getgenv().AutoCollectGold then break end
                                
                                if v:IsA("MeshPart") and v.Name:match("Gold") then
                                    firetouchinterest(hrp, v, 0)
                                    task.wait(0.01) -- Very fast wait for touch registration
                                    firetouchinterest(hrp, v, 1)
                                end
                            end
                        end
                    end)
                    task.wait(0.5) -- Delay between full workspace scans to prevent lag
                end
                GoldThread = nil -- Clean up thread variable when stopped
            end)
        end
    end,
})

LeftGroupBox:AddToggle("AutoStealEgg", {
    Text = "Auto Steal Dragon Egg",
    Default = false,
    Tooltip = "TPs to Lava Egg when it spawns, steals it, and TPs back"
})

-- ============================================================================
-- LOGIC FUNCTIONS
-- ============================================================================

local function fireNearestPrompt(maxDistance)
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local dist = (v.Parent:IsA("BasePart") and (hrp.Position - v.Parent.Position).Magnitude) or 100
            if dist <= maxDistance then
                fireproximityprompt(v)
            end
        end
    end
end

-- ============================================================================
-- MAIN LOOP
-- ============================================================================

task.spawn(function()
    while true do
        task.wait(0.1) -- Constant check
        
        if Toggles.AutoStealEgg.Value then
            pcall(function()
                -- 1. Check if workspace.AU2["Dragon Nest"]["Lava Egg"] exists
                local lavaEgg = Workspace:FindFirstChild("AU2") 
                                and Workspace.AU2:FindFirstChild("Dragon Nest") 
                                and Workspace.AU2["Dragon Nest"]:FindFirstChild("Lava Egg")

                if lavaEgg then
                    local char = lp.Character
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end

                    -- 2. Teleport to the Egg Location
                    hrp.CFrame = CFrame.new(5155.99561, -4805.07764, -59343.168, -0.22484614, -0.750962377, 0.620886266, -2.46128593e-08, 0.637202263, 0.77069658, -0.974394262, 0.173288137, -0.143272489)
                    
                    -- 3. Wait 0.1s
                    task.wait(0.1)

                    -- 4. Fire nearest proximity prompt (30 studs max)
                    fireNearestPrompt(30)
                    
                    -- 5. Teleport back to original position
                    hrp.CFrame = CFrame.new(-60.7250023, 73.4000092, -41.9992981, 0.999988079, 1.9830372e-08, -0.00488542765, -2.006343e-08, 1, -4.7655945e-08, 0.00488542765, 4.77533959e-08, 0.999988079)

                    -- 6. Notify
                    Library:Notify("Stole Dragon Egg")
                    
                    -- 7. Cooldown to prevent spamming while the egg object is being destroyed by the game
                    task.wait(2)
                end
            end)
        end
    end
end)

LeftGroupBox:AddToggle("AutoCollectCrystals", {
    Text = "Auto Collect Crystals",
    Default = false,
    Tooltip = "TPs to Crystals in the Wormhole Machine and collects them"
})

-- ============================================================================
-- LOGIC FUNCTIONS
-- ============================================================================

local function getCrystalFolder()
    local unlocks = Workspace:FindFirstChild("Unlocks")
    if unlocks then
        local wormhole = unlocks:FindFirstChild("Wormhole Machine")
        if wormhole then
            return wormhole:FindFirstChild("Crystal")
        end
    end
    return nil
end

-- ============================================================================
-- MAIN LOOP
-- ============================================================================

task.spawn(function()
    while true do
        task.wait(0.5) -- Scan interval
        
        if Toggles.AutoCollectCrystals.Value then
            pcall(function()
                local crystalFolder = getCrystalFolder()
                
                if crystalFolder then
                    local crystals = crystalFolder:GetChildren()
                    
                    for _, crystal in pairs(crystals) do
                        -- Stop if toggle is turned off mid-loop
                        if not Toggles.AutoCollectCrystals.Value then break end

                        local char = lp.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        
                        -- Check if the child is a MeshPart as requested
                        if hrp and crystal:IsA("MeshPart") then
                            
                            -- 1. Teleport to the Crystal
                            hrp.CFrame = crystal.CFrame
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            task.wait(0.2) -- Small wait for the game to register position

                            -- 2. Find and fire the ProximityPrompt
                            -- Using recursive search (true) to find it inside children of children
                            local prompt = crystal:FindFirstChildWhichIsA("ProximityPrompt", true)
                            
                            if prompt then
                                fireproximityprompt(prompt)
                                task.wait(0.3) -- Cooldown for the animation/collection
                            end
                        end
                    end
                end
            end)
        end
    end
end)

LeftGroupBox:AddToggle("AutoChargeFloppa", {
    Text = "Auto Charge Floppa",
    Default = false,
    Tooltip = "Uses Space Crystals to charge the converter when empty"
})

-- ============================================================================
-- LOGIC FUNCTIONS
-- ============================================================================

local targetCFrame = CFrame.new(-44.1373291, 110.500015, -62.5137863, 0.999993026, -1.48757948e-08, 0.00373192248, 1.4920424e-08, 1, -1.19307177e-08, -0.00373192248, 1.19863159e-08, 0.999993026)

local function getSpaceCrystal()
    local bp = lp:FindFirstChild("Backpack")
    if bp then
        return bp:FindFirstChild("Space Crystal")
    end
    return nil
end

-- ============================================================================
-- MAIN LOOP
-- ============================================================================

task.spawn(function()
    while true do
        task.wait(0.5) -- Scan interval
        
        if Toggles.AutoChargeFloppa.Value then
            pcall(function()
                local unlocks = Workspace:FindFirstChild("Unlocks")
                local converter = unlocks and unlocks:FindFirstChild("Crystal Converter")
                
                if converter then
                    local crystalPart = converter:FindFirstChild("Crystal")
                    local primary = converter:FindFirstChild("Primary")
                    
                    -- Check Transparency Condition: Must be 1 or more (Empty/Ready)
                    if crystalPart and crystalPart.Transparency >= 1 then
                        
                        -- Check for Tool
                        local crystalTool = getSpaceCrystal()
                        local char = lp.Character
                        local hum = char and char:FindFirstChild("Humanoid")
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        
                        if crystalTool and hum and hrp then
                            -- 1. Equip the Space Crystal
                            hum:EquipTool(crystalTool)
                            task.wait(0.1)
                            
                            -- 2. Teleport to the specific coordinates
                            hrp.CFrame = targetCFrame
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            task.wait(0.2)
                            
                            -- 3. Fire the ProximityPrompt
                            local prompt = primary and primary:FindFirstChild("ProximityPrompt")
                            if prompt then
                                fireproximityprompt(prompt)
                                Library:Notify("Charged Floppa!")
                                task.wait(1) -- Delay to avoid double-firing
                            end
                        end
                    end
                end
            end)
        end
    end
end)

LeftGroupBox:AddToggle("AutoElGatoParty", {
    Text = "Auto El Gato Party",
    Tooltip = "Auto plays DJ El Gato party when its available to do so.",
    Default = false,
})

-- // Services \\ --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- // Vars \\ --
local ElGatoConnection

-- target CFrame
local ElGatoCFrame = CFrame.new(
    -78.794281, 73.4000092, -41.9453812,
    -0.00663209474,  1.63774274e-08,  0.999978006,
    -9.71405854e-08, 1,              -1.70220478e-08,
    -0.999978006,   -9.72513376e-08, -0.00663209474
)

Toggles.AutoElGatoParty:OnChanged(function()
    -- cleanup
    if ElGatoConnection then
        ElGatoConnection:Disconnect()
        ElGatoConnection = nil
    end

    if not Toggles.AutoElGatoParty.Value then
        return
    end

    -- loop
    ElGatoConnection = RunService.Heartbeat:Connect(function()
        local Character = LocalPlayer.Character
        local HRP = Character and Character:FindFirstChild("HumanoidRootPart")
        if not HRP then return end

        local Unlocks = workspace:FindFirstChild("Unlocks")
        local ElGato = Unlocks and Unlocks:FindFirstChild("DJ El Gato")
        if not ElGato then return end

        local Cooldown = ElGato:FindFirstChild("Cooldown")
        if not (Cooldown and Cooldown:IsA("ValueBase")) then return end

        if Cooldown.Value == 0 then
            -- teleport
            HRP.CFrame = ElGatoCFrame

            task.wait(0.1)

            -- fire proximity prompt
            local Primary = ElGato:FindFirstChild("Primary")
            local Prompt = Primary and Primary:FindFirstChildOfClass("ProximityPrompt")
            if Prompt then
                fireproximityprompt(Prompt)
            end
        end
    end)
end)

-- // ESPs \\ --

local HighlightInstance = nil
local LeftGroupBoxVisuals = Tabs.Visuals:AddLeftGroupbox("ESPs")

LeftGroupBoxVisuals:AddToggle("PathHighlight", {
	Text = "Floppa ESP",
	Default = false,
})

Toggles.PathHighlight:OnChanged(function()
	if Toggles.PathHighlight.Value then
		-- create highlight
		if not HighlightInstance then
			local hl = Instance.new("Highlight")
			hl.Name = "PathHighlight"
			hl.Adornee = Floppa
			hl.FillColor = Color3.fromRGB(255, 51, 51)
			hl.OutlineColor = Color3.fromRGB(255, 255, 255)
			hl.FillTransparency = 0.5
			hl.OutlineTransparency = 0
			hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			hl.Parent = Floppa

			HighlightInstance = hl
		end
	else
		-- remove highlight
		if HighlightInstance then
			HighlightInstance:Destroy()
			HighlightInstance = nil
		end
	end
end)

local HighlightInstance1 = nil

LeftGroupBoxVisuals:AddToggle("PathHighlight1", {
	Text = "Ms. Floppa ESP",
	Default = false,
})

Toggles.PathHighlight1:OnChanged(function()
	if Toggles.PathHighlight1.Value then
		-- create highlight
		if not HighlightInstance1 then
			local hl1 = Instance.new("Highlight")
			hl1.Name = "PathHighlight1"
			hl1.Adornee = MsFloppa
			hl1.FillColor = Color3.fromRGB(251, 116, 168)
			hl1.OutlineColor = Color3.fromRGB(255, 255, 255)
			hl1.FillTransparency = 0.5
			hl1.OutlineTransparency = 0
			hl1.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			hl1.Parent = MsFloppa

			HighlightInstance1 = hl1
		end
	else
		-- remove highlight
		if HighlightInstance1 then
			HighlightInstance1:Destroy()
			HighlightInstance1 = nil
		end
	end
end)

local Unlockss = workspace:WaitForChild("Unlocks", 10)
local BabyFloppaHighlights = {}

LeftGroupBoxVisuals:AddToggle("PathHighlight2", {
	Text = "Baby Floppas ESP",
	Default = false,
})

Toggles.PathHighlight2:OnChanged(function()
	if Toggles.PathHighlight2.Value then
		for _, obj in ipairs(Unlockss:GetChildren()) do
			if obj.Name == "Baby Floppa" and not BabyFloppaHighlights[obj] then
				local hl = Instance.new("Highlight")
				hl.Name = "BabyFloppaHighlight"
				hl.Adornee = obj
				hl.FillColor = Color3.fromRGB(0, 115, 187)
				hl.OutlineColor = Color3.fromRGB(255, 255, 255)
				hl.FillTransparency = 0.5
				hl.OutlineTransparency = 0
				hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				hl.Parent = obj

				BabyFloppaHighlights[obj] = hl
			end
		end
	else
		for _, hl in pairs(BabyFloppaHighlights) do
			if hl then
				hl:Destroy()
			end
		end
		table.clear(BabyFloppaHighlights)
	end
end)

-- // Seeds ESP \\ --

local SeedsFolder = workspace:WaitForChild("Seeds")
local SeedHighlights = {}
local SeedsConnection = nil

LeftGroupBoxVisuals:AddToggle("SeedsESP", {
	Text = "Seeds ESP",
	Tooltip = "Highlights all seeds.",
	Default = false,
})

local function AddSeedHighlight(obj)
	if SeedHighlights[obj] then return end

	local hl = Instance.new("Highlight")
	hl.Name = "SeedHighlight"
	hl.Adornee = obj
	hl.FillColor = Color3.fromRGB(255, 255, 0) -- Yellow
	hl.OutlineColor = Color3.fromRGB(255, 255, 255)
	hl.FillTransparency = 0.5
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = obj

	SeedHighlights[obj] = hl
end

local function ClearSeedHighlights()
	for _, hl in pairs(SeedHighlights) do
		if hl then
			hl:Destroy()
		end
	end
	table.clear(SeedHighlights)
end

Toggles.SeedsESP:OnChanged(function()
	if Toggles.SeedsESP.Value then
		-- Existing seeds
		for _, seed in ipairs(SeedsFolder:GetChildren()) do
			AddSeedHighlight(seed)
		end

		-- New seeds
		SeedsConnection = SeedsFolder.ChildAdded:Connect(function(seed)
			AddSeedHighlight(seed)
		end)
	else
		if SeedsConnection then
			SeedsConnection:Disconnect()
			SeedsConnection = nil
		end

		ClearSeedHighlights()
	end
end)

-- // SFXs \\ --

local LeftGroupBoxMisc = Tabs.Misc:AddLeftGroupbox("SFXs")

local MuteBills = false
local name_sound = "DollaDollaBills"

local function handleSound(obj)
	if obj:IsA("Sound") and obj.Name == name_sound then
		if MuteBills then
			obj.Volume = 0

			-- prevent volume being reset
			obj:GetPropertyChangedSignal("Volume"):Connect(function()
				if MuteBills then
					obj.Volume = 0
				end
			end)

			-- stop replay if needed
			obj:Stop()
		end
	end
end

-- Existing sounds (deep scan)
for _, v in ipairs(workspace:GetDescendants()) do
	handleSound(v)
end

-- Future sounds (deep)
workspace.DescendantAdded:Connect(function(obj)
	task.wait()
	handleSound(obj)
end)

LeftGroupBoxMisc:AddToggle("MuteBills", {
	Text = "Disable Money SFX",
	Tooltip = "Disables the money SFX when collecting money.",
	Default = false,

	Callback = function(Value)
		MuteBills = Value

		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("Sound") and v.Name == name_sound then
				if Value then
					v.Volume = 0
					v:Stop()
				else
					v.Volume = 0.2
				end
			end
		end
	end
})

-- // Utilities \\ --

local RightGroupBox = Tabs.Main:AddRightGroupbox("Utilities")

local CollectAllPoops = RightGroupBox:AddButton({
    Text = "Clean All Poops",
    Tooltip = "Cleans all the poops.",
    Func = function()
        for _, a in ipairs(Workspace:GetDescendants()) do
            if a:IsA("ProximityPrompt") and a.Parent and a.Parent.Name == "Poop" then
                HumanoidRootPart.CFrame = a.Parent.WorldPivot + Vector3.new(0, 3, 0)
                task.wait(0.25)
                fireproximityprompt(a)
                task.wait(0.25)
            end
        end
    end,
})

local CollectAllSeeds = RightGroupBox:AddButton({
    Text = "Collect All Seeds",
    Tooltip = "Collects all the seeds.",
    Func = function()
        for _, v in pairs(Workspace.Seeds:GetDescendants()) do
            if v.Name == "Seed" then
            HumanoidRootPart.CFrame = v.CFrame wait(0.2) end
            if v.Name == "ProximityPrompt" then
            wait(0.05)
            fireproximityprompt(v)
        end
    end 
    end,
})

-- // Collect all meteorites \\ --

local CollectAllMeteorites = RightGroupBox:AddButton({
    Text = "Collect All Meteorites",
    Tooltip = "Collects All the Meteorites.",
    Func = function()
        for _, v in pairs(game.Workspace:GetChildren()) do
            if v.Name == "Meteorite" and v:IsA("Tool") then
                HumanoidRootPart.CFrame = v.WorldPivot
                wait(0.1)
            end
        end
    end,
})

local CollectAlmondWater = RightGroupBox:AddButton({
    Text = "Collect Almond Water",
    Tooltip = "Collects almond water",
    Func = function()
        local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local rooms = workspace.Backrooms.Rooms

-- will stop entering new doors if humanoid cframe ts
local stopCFrame = CFrame.new(
    1210.86853, -1216.3501, -28.9999371,
    1, 9.19804179e-08, -5.59256748e-08,
    -9.19804179e-08, 1, 9.00675001e-09,
    5.59256748e-08, -9.00674468e-09, 1
)

local tolerance = 0.1
local shouldBreak = false

for _, v in ipairs(rooms:GetDescendants()) do
    if shouldBreak then break end

    if (hrp.Position - stopCFrame.Position).Magnitude <= tolerance then
        shouldBreak = true
        break
    end

    if v:IsA("Part") and v.Name == "Primary" and v.Parent then

        -- ENTER
        if v.Parent.Name == "Enter" then
            hrp.CFrame = v.CFrame
            task.wait(0.1)
        end

        -- EXIT
        if v.Parent.Name == "Exit" then
            hrp.CFrame = v.CFrame
            task.wait(0.1)
        end

        -- FIRE DOOR PROMPTS
        for _, k in ipairs(v.Parent:GetDescendants()) do
            if k:IsA("ProximityPrompt") then
                fireproximityprompt(k)
                task.wait(0.05)
            end
        end
    end
end

task.wait(0.1)

hrp.CFrame = CFrame.new(
    1176.21606, -1214, -29.2083721,
    -1, 0, 0,
     0, 1, 0,
     0, 0, -1
)

task.wait(0.1)

local almondPrompt =
    workspace.Backrooms:FindFirstChild("Almond Water", true)
        :FindFirstChildWhichIsA("ProximityPrompt", true)

if almondPrompt then
    task.wait(0.25)
    fireproximityprompt(almondPrompt)
end
end,
})

local BuyFloppaFood = RightGroupBox:AddButton({
    Text = "Buy Floppa Food",
    Tooltip = "Buys Floppa Food from the interwebs.",
    Func = function()
local Event = game:GetService("ReplicatedStorage").Events.Unlock
Event:FireServer(
    "Floppa Food",
    "the_interwebs"
)
    end,
})

-- // Auto Collect Milk \\ --

local AutoCollectMilk = false
local MilkConnection

LeftGroupBox:AddToggle("AutoCollectMilk", {
    Text = "Auto Collect Milk",
    Tooltip = "Teleports you to the Milk Delivery.",
    Default = false,

    Callback = function(Value)
        AutoCollectMilk = Value

        -- cleanup
        if MilkConnection then
            MilkConnection:Disconnect()
            MilkConnection = nil
        end

        if not Value then return end

        MilkConnection = task.spawn(function()
            while AutoCollectMilk do
                local milk = workspace:FindFirstChild("Milk Delivery")
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")

                if milk and hrp then
                    hrp.CFrame = milk.WorldPivot
                    wait(0.5)
                    fireproximityprompt(workspace["Milk Delivery"].Crate.ProximityPrompt)
                end

                task.wait(1) -- prevents spam / lag
            end
        end)
    end,
})

--// Teleports \\--
local LeftGroupBoxTPS = Tabs.Teleports:AddLeftGroupbox("Teleports")

local TeleportLocations = {
    ["Rent Guy"] = CFrame.new(-77.209549, 73.4000092, -41.8216248, -0.0136132091, 0, -0.999907315, 0, 1, 0, 0.999907315, 0, -0.0136132091),
    ["Roof"] = CFrame.new(-42.1624832, 145.400024, -42.0087891, -0.0146608381, -8.3999268e-08, -0.999892533, 1.00862922e-10, 1, -8.40097769e-08, 0.999892533, -1.33250577e-09, -0.0146608381),
    ["House"] = CFrame.new(-60.7250023, 73.4000092, -41.9992981, 0.999988079, 1.9830372e-08, -0.00488542765, -2.006343e-08, 1, -4.7655945e-08, 0.00488542765, 4.77533959e-08, 0.999988079),
    ["Watering Can Shop"] = CFrame.new(36.6954918, 69.1000214, -95.8595734, 0.00418849709, -4.57559146e-08, -0.999991238, -2.09726299e-08, 1, -4.58441605e-08, 0.999991238, 2.1164464e-08, 0.00418849709),
    ["Sword Shop"] = CFrame.new(34.4367142, 69.6000214, -139.268768, -0.25409469, -1.74380013e-08, -0.967179358, -1.97459773e-08, 1, -1.28421416e-08, 0.967179358, 1.58347806e-08, -0.25409469),
    ["Food Shop"] = CFrame.new(58.6328392, 69.5999985, -119.327972, 0.872580528, -9.26338188e-08, 0.488470227, 7.08403576e-08, 1, 6.30947312e-08, -0.488470227, -2.04518287e-08, 0.872580528),
    ["Lemonade Stand"] = CFrame.new(-5.89272404, 69.0935898, -109.667778, 0.00313977525, 3.51277336e-08, 0.999995053, -2.76596861e-08, 1, -3.50410616e-08, -0.999995053, -2.75495289e-08, 0.00313977525),
    ["Computer"] = CFrame.new(-47.8897476, 73.4000092, -40.8341026, 0.0108212391, -1.03630535e-08, -0.999941468, 3.04304315e-08, 1, -1.00343467e-08, 0.999941468, -3.03200629e-08, 0.0108212391),
    ["Outside"] = CFrame.new(-21.487957, 68.5935898, -52.9398956, 0.000348773785, 1.61803602e-08, 0.99999994, 6.62653621e-09, 1, -1.6182673e-08, -0.99999994, 6.63217969e-09, 0.000348773785),
    ["Basement"] = CFrame.new(-64.9342499, 55.4000168, -43.1095963, -0.0169861279, 1.53852771e-08, -0.999855697, 3.49273357e-08, 1, 1.47941304e-08, 0.999855697, -3.46710003e-08, -0.0169861279),
    ["Second Floor"] = CFrame.new(-58.1133461, 91.4000168, -41.8777542, 0.00523509458, 0, 0.999986291, 0, 1, 0, -0.999986291, 0, 0.00523509458),
    ["Room from the 2nd floor"] = CFrame.new(-68.2723312, 91.4000168, -98.1589966, -0.00383815751, -8.55764597e-08, -0.999992609, -4.77865001e-08, 1, -8.53936726e-08, 0.999992609, 4.74583928e-08, -0.00383815751),
    ["Third Floor"] = CFrame.new(-59.3578835, 110.500015, -41.95158, 0.00732855452, 0, 0.999973118, 0, 1, 0, -0.999973118, 0, 0.00732855452),
    ["Moon"] = CFrame.new(-42175.7188, 528.936157, -82.662674, 0.929988742, -1.45854342e-08, 0.367588013, 3.26767768e-08, 1, -4.29926921e-08, -0.367588013, 5.19943093e-08, 0.929988742),
    ["DJ El Gato"] = CFrame.new(-78.794281, 73.4000092, -41.9453812, -0.00663209474, 1.63774274e-08, 0.999978006, -9.71405854e-08, 1, -1.70220478e-08, -0.999978006, -9.72513376e-08, -0.00663209474),
    ["Cellar"] = CFrame.new(-71.616478, 35.9000168, -41.3364449, 0.0254750568, -3.57637582e-08, -0.999675453, 7.03165304e-09, 1, -3.55961802e-08, 0.999675453, -6.12255624e-09, 0.0254750568),
    ["Ascend"] = CFrame.new(6520.71924, -341.600006, -1.83147562, 0.999638855, 1.18989441e-08, 0.0268737935, -1.29397506e-08, 1, 3.85555055e-08, -0.0268737935, -3.8889322e-08, 0.999638855),
}

local TeleportNames = {}
for name in pairs(TeleportLocations) do
    table.insert(TeleportNames, name)
end

LeftGroupBoxTPS:AddDropdown("TeleportDropdown", {
    Values = TeleportNames,
    Default = 1,
    Multi = false,

    Text = "Teleport Location",
    Tooltip = "Select a location to teleport to.",

    Disabled = false,
    Visible = true,
})

LeftGroupBoxTPS:AddButton({
    Text = "Teleport",
    Tooltip = "Teleports to selected location.",

    Disabled = false,
    Visible = true,

    Func = function()
        local SelectedLocation = Options.TeleportDropdown.Value
        if not SelectedLocation then return end

        local TargetCFrame = TeleportLocations[SelectedLocation]
        if not TargetCFrame then return end

        local Player = game.Players.LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local HRP = Character:FindFirstChild("HumanoidRootPart")

        if HRP then
            HRP.CFrame = TargetCFrame
        end
    end
})

local MeteoriteHighlights = {}

LeftGroupBoxVisuals:AddToggle("MeteoriteESP", {
	Text = "Meteorite ESP",
	Default = false,
})

local function isMeteorite(obj)
	return obj:IsA("Tool") and obj.Name == "Meteorite"
end

local function addHighlight(meteorite)
	if MeteoriteHighlights[meteorite] then return end

	local adornee = meteorite

	-- Fallback to Handle if Tool highlighting fails
	if meteorite:IsA("Tool") and meteorite:FindFirstChild("Handle") then
		adornee = meteorite
	end

	local hl = Instance.new("Highlight")
	hl.Name = "MeteoriteHighlight"
	hl.Adornee = adornee
	hl.FillColor = Color3.fromRGB(255, 140, 0) -- Orange
	hl.OutlineColor = Color3.fromRGB(255, 255, 255)
	hl.FillTransparency = 0.4
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = adornee

	MeteoriteHighlights[meteorite] = hl
end

local function removeAllHighlights()
	for _, hl in pairs(MeteoriteHighlights) do
		if hl then
			hl:Destroy()
		end
	end
	table.clear(MeteoriteHighlights)
end

-- Initial scan
local function scanWorkspace()
	for _, obj in ipairs(Workspace:GetChildren()) do
		if isMeteorite(obj) then
			addHighlight(obj)
		end
	end
end

-- Toggle logic
Toggles.MeteoriteESP:OnChanged(function()
	if Toggles.MeteoriteESP.Value then
		scanWorkspace()
	else
		removeAllHighlights()
	end
end)

-- Detect newly dropped meteorites
Workspace.ChildAdded:Connect(function(obj)
	if Toggles.MeteoriteESP.Value and isMeteorite(obj) then
		task.wait()
		addHighlight(obj)
	end
end)

-- Cleanup if meteorite is removed
Workspace.ChildRemoved:Connect(function(obj)
	if MeteoriteHighlights[obj] then
		MeteoriteHighlights[obj] = nil
	end
end)

-- AUTO FISH (Cross-Platform Safe: Windows + macOS + Mobile)

-- SERVICES
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService") -- Added for Mobile Check
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- LOCAL PLAYER (robust)
local lp = Players.LocalPlayer
while not lp do task.wait() lp = Players.LocalPlayer end

local OriginalHipHeight

-- UI
-- Note: Ensure "Tabs" and "Library" exist in your execution environment or load a UI library before this.
local MainGroup = Tabs.Main:AddLeftGroupbox("Fishing")

MainGroup:AddToggle("AutoFish", {
    Text = "Enable Auto Fish",
    Default = false,
})

MainGroup:AddDropdown("Blacklist", {
    Values = {
        "Fish","Almond Water","Mushroom","Burguer","Milk","Catnip",
        "Space Soup","Money Bag","Treasure","Jumbo Treasure",
        "Speed Potion","Sanity Potion","Carrot Seed","Money Seed",
        "Fungal Spore","Lettuce Seed","Catnip Seed","Space Crystal",
        "Flopptonium","The Big One","Dirty Old Boot","Meteorite","Gift"
    },
    Text = "Blacklist",
    Multi = true,
})

-- =========================
-- HELPERS
-- =========================

local function safeFirePrompt(prompt)
    if prompt
        and prompt:IsA("ProximityPrompt")
        and prompt.Enabled
        and prompt.Parent
    then
        task.wait() -- critical for macOS CoreGui
        fireproximityprompt(prompt)
    end
end

-- [[ UPDATED CLICK LOGIC ]] --
local function click()
    -- specific mobile check
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    
    -- Calculate center of screen (safer than 0,0 which hits mobile menus)
    local viewportSize = Workspace.CurrentCamera.ViewportSize
    local x, y = viewportSize.X / 2, viewportSize.Y / 2
    
    if isMobile then
        -- Mobile Touch Logic
        VirtualInputManager:SendTouchEvent(0, Enum.UserInputState.Begin, Vector2.new(x, y), nil)
        task.wait(0.05)
        VirtualInputManager:SendTouchEvent(0, Enum.UserInputState.End, Vector2.new(x, y), nil)
    else
        -- PC Mouse Logic
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end
end

local function deleteBlacklistedItems()
    local selections = Library.Options.Blacklist.Value
    local bp = lp:FindFirstChild("Backpack")
    if not bp then return end

    for _, tool in ipairs(bp:GetChildren()) do
        if selections[tool.Name] then
            tool:Destroy()
        end
    end
end

local function getBestRod()
    local char = lp.Character
    local bp = lp:FindFirstChild("Backpack")
    if not char or not bp then return nil end

    return
        char:FindFirstChild("Golden Fishing Rod")
        or bp:FindFirstChild("Golden Fishing Rod")
        or char:FindFirstChild("Fishing Rod")
        or bp:FindFirstChild("Fishing Rod")
        or (function()
            for _, v in ipairs(char:GetChildren()) do
                if v:IsA("Tool") and v.Name:find("Rod") then return v end
            end
            for _, v in ipairs(bp:GetChildren()) do
                if v:IsA("Tool") and v.Name:find("Rod") then return v end
            end
        end)()
end

-- =========================
-- MOVEMENT
-- =========================

local OriginalCF = CFrame.new(
    -41.3120956, 69.5935898, 37.4599171,
    -0.999871075, 0, -0.0160569679,
    0, 1, 0,
    0.0160569679, 0, -0.999871075
)

local Spots = {
    OriginalCF,
    OriginalCF * CFrame.new(10, 0, 0),
    OriginalCF * CFrame.new(-10, 0, 0),
}

local currentSpotIndex = 1
local castCounter = 0

local function getSafeSpot()
    if type(currentSpotIndex) ~= "number" or not Spots[currentSpotIndex] then
        currentSpotIndex = 1
    end
    return Spots[currentSpotIndex]
end

-- =========================
-- MAIN LOOP
-- =========================

task.spawn(function()
    while true do
        local ok, err = pcall(function()
            if not Library.Toggles.AutoFish.Value then
                if lp.Character and OriginalHipHeight then
                    local hum = lp.Character:FindFirstChild("Humanoid")
                    if hum then hum.HipHeight = OriginalHipHeight end
                    OriginalHipHeight = nil
                end
                return
            end

            local char = lp.Character or lp.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            local hum = char:WaitForChild("Humanoid")

            if not OriginalHipHeight then
                OriginalHipHeight = hum.HipHeight
            end

            deleteBlacklistedItems()

            local rod = getBestRod()

            -- BUY ROD IF NONE
            if not rod then
                hrp.CFrame = CFrame.new(4.516, 69.6, -128.26)
                task.wait(0.6)

                local npc = Workspace:FindFirstChild("Village")
                    and Workspace.Village.FishStore.NPC
                local prompt = npc and npc.Torso:FindFirstChild("ProximityPrompt")
                safeFirePrompt(prompt)

                task.wait(1.5)
                rod = getBestRod()
                if not rod then return end
            end

            -- EQUIP
            if rod.Parent ~= char then
                hum:EquipTool(rod)
                task.wait(0.25)
            end

            -- MOVE SPOT
            if castCounter >= 2 then
                castCounter = 0
                currentSpotIndex += 1
                if currentSpotIndex > #Spots then
                    currentSpotIndex = 1
                end
            end

            hrp.CFrame = getSafeSpot()
            if hrp.AssemblyLinearVelocity then
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
            task.wait(0.3)

            -- CAST
            click()
            castCounter += 1

            -- MONITOR
            while Library.Toggles.AutoFish.Value do
                task.wait(1)
                if rod.Parent ~= char then break end

                local uiVisible = false
                pcall(function()
                    local playerFolder = Workspace:FindFirstChild(lp.Name)
                    local rodModel = playerFolder and playerFolder:FindFirstChild(rod.Name)
                    local hook = rodModel and rodModel:FindFirstChild("Hook")
                    local notif = hook and hook:FindFirstChild("Notification")
                    local frame = notif and notif:FindFirstChild("Frame")
                    local label = frame and frame:FindFirstChild("TextLabel")

                    if label and label.Visible then
                        uiVisible = true
                    end
                end)

                if not uiVisible then
                    click()
                else
                    local hook = rod:FindFirstChild("Hook")
                    local sparkles = hook and hook:FindFirstChild("Sparkles")
                    if sparkles and sparkles.Enabled then
                        break
                    end
                end
            end

            -- REEL
            click()
            task.wait(1)
        end)

        if not ok then
            warn("AutoFish Loop Error:", err)
            currentSpotIndex = 1
            castCounter = 0
            task.wait(1)
        end

        task.wait(0.1)
    end
end)

-- ============================================================================
-- DATA CONFIGURATION
-- ============================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StoveCFrame = CFrame.new(-53.4228821, 73.4000092, -61.1771812, 0.999941468, 4.78427431e-08, 0.0108202631, -4.73167248e-08, 1, -4.88701701e-08, -0.0108202631, 4.83553286e-08, 0.999941468)
local StovePrompt = Workspace:FindFirstChild("Key Parts") and Workspace["Key Parts"].Stove.Parts.Primary.ProximityPrompt
local CookingRemote = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Cooking")

local RecipeData = {
    ["Grilled Cheese"] = { Ingredients = {{"Bread", 1}, {"Cheese", 1}}, Temp = 3 },
    ["Vegetable Soup"] = { Ingredients = {{"Noodle", 1}, {"Carrot", 1}, {"Lettuce", 1}}, Temp = 1 },
    ["Burger"] = { Ingredients = {{"Bread", 1}, {"Lettuce", 1}, {"Tomato", 1}, {"Beef", 1}}, Temp = 2 },
    ["Cake"] = { Ingredients = {{"Eggs", 1}, {"Milk", 1}, {"Flour", 1}, {"Sugar", 1}}, Temp = 1 },
    ["Space Soup"] = { Ingredients = {{"Meteorite", 2}, {"Carrot", 1}, {"Noodle", 1}}, Temp = 1 },
    ["Mega Breakfast"] = { Ingredients = {{"Dragon Egg", 1}, {"Beef", 3}}, Temp = 3 }
}

-- ============================================================================
-- LOGIC FUNCTIONS
-- ============================================================================

-- Function to check if player has all required ingredients
local function hasIngredients(recipeName)
    local data = RecipeData[recipeName]
    local bp = lp:FindFirstChild("Backpack")
    local char = lp.Character
    if not (bp and char) then return false end

    for _, itemInfo in pairs(data.Ingredients) do
        local name = itemInfo[1]
        local amountNeeded = itemInfo[2]
        local count = 0
        
        -- Count in backpack
        for _, tool in pairs(bp:GetChildren()) do
            if tool.Name == name then count = count + 1 end
        end
        -- Count in character
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == name then count = count + 1 end
        end

        if count < amountNeeded then return false end
    end
    return true
end

-- Function to find and equip a specific tool instance
local function equipAndFire(itemName)
    local bp = lp:FindFirstChild("Backpack")
    local char = lp.Character
    local hum = char and char:FindFirstChild("Humanoid")
    
    local tool = bp and bp:FindFirstChild(itemName)
    if not tool then tool = char:FindFirstChild(itemName) end

    if tool and hum then
        hum:EquipTool(tool)
        task.wait(0.1)
        if StovePrompt then
            fireproximityprompt(StovePrompt)
        end
        task.wait(0.1)
        return true
    end
    return false
end

local function startCooking()
    local selected = Options.Recipes.Value
    if not RecipeData[selected] then return end

    -- 1. Check Ingredients
    if not hasIngredients(selected) then
        Library:Notify("Missing ingredients!", 3)
        return
    end

    -- 2. Teleport to Stove
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = StoveCFrame
        task.wait(0.2)
    end

    -- 3. Equip and Fire for each ingredient
    local data = RecipeData[selected]
    for _, itemInfo in pairs(data.Ingredients) do
        local name = itemInfo[1]
        local amount = itemInfo[2]
        
        for i = 1, amount do
            equipAndFire(name)
        end
    end

    -- 4. Fire Remotes
    CookingRemote:FireServer("Change Temperature", data.Temp)
    task.wait(0.05)
    CookingRemote:FireServer("Cook")
    
    Library:Notify("Started cooking " .. selected .. "!", 3)
end

-- ============================================================================
-- UI ELEMENTS
-- ============================================================================

local CookGroup = Tabs.Main:AddRightGroupbox("Cooking")

CookGroup:AddDropdown("Recipes", {
    Values = { "Grilled Cheese", "Vegetable Soup", "Burger", "Cake", "Space Soup", "Mega Breakfast" },
    Default = 1,
    Multi = false,
    Text = "Recipes",
    Tooltip = "Select a meal to cook"
})

CookGroup:AddButton({
    Text = "Cook",
    Func = function()
        startCooking()
    end,
    DoubleClick = false,
    Tooltip = "Verify ingredients and start cooking"
})

local ShopGroupBox = Tabs.Main:AddRightGroupbox("Shop")

-- Function to handle the buying logic
local function BuyMaxItems()
    local itemName = Options.UnlocksDropdown.Value
    local isToggled = Toggles.ShopFeatureToggle.Value
    
    if not isToggled or not itemName or itemName == "No Unlocks Found" then 
        return 
    end

    local player = game:GetService("Players").LocalPlayer
    local moneyValueObject = player:FindFirstChild("Money")
    
    if not moneyValueObject then
        print("[DEBUG] Money object not found at LocalPlayer.Money")
        return
    end

    local money = moneyValueObject.Value
    local unlockFolder = player.PlayerGui.PlayerUI.the_interwebs.Unlocks
    local itemFrame = unlockFolder:FindFirstChild(itemName)
    
    if itemFrame and itemFrame:FindFirstChild("Item Price") then
        local rawPriceText = itemFrame["Item Price"].Text
        
        -- Improved price extraction: finds the first number in the string
        -- This handles "Price:$100", "Price: $100", or "Price: 1,000"
        local cleanPrice = rawPriceText:gsub(",", ""):match("%d+")
        local price = tonumber(cleanPrice)

        print("[DEBUG] Item:", itemName, "| Money:", money, "| Price:", price)

        if price and price > 0 then
            local amountToBuy = math.floor(money / price)
            print("[DEBUG] Attempting to buy x" .. tostring(amountToBuy))

            if amountToBuy > 0 then
                for i = 1, amountToBuy do
                    game:GetService("ReplicatedStorage").Events.Unlock:FireServer(itemName, "the_interwebs")
                end
                Library:Notify("Success: Bought " .. tostring(amountToBuy) .. "x " .. itemName)
            else
                print("[DEBUG] Not enough money to buy even one.")
            end
        else
            print("[DEBUG] Price was invalid or zero.")
        end
    else
        print("[DEBUG] Could not find Item Frame or 'Item Price' text label.")
    end
end

-- Toggle for Auto-Buy
ShopGroupBox:AddToggle("ShopFeatureToggle", {
    Text = "Enable Auto-Buy Max",
    Default = false,
    Tooltip = "Automatically buys max amount when turned on or item changed.",
    
    Callback = function(Value)
        if Value then
            BuyMaxItems()
        end
    end
})

--- Logic to fetch names from the specified path
local function GetUnlocksList()
    local unlocks = {}
    local path = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
        and game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("PlayerUI")
        and game:GetService("Players").LocalPlayer.PlayerGui.PlayerUI:FindFirstChild("the_interwebs")
        and game:GetService("Players").LocalPlayer.PlayerGui.PlayerUI.the_interwebs:FindFirstChild("Unlocks")

    if path then
        for _, child in ipairs(path:GetChildren()) do
            if child:IsA("Frame") then
                table.insert(unlocks, child.Name)
            end
        end
    else
        table.insert(unlocks, "No Unlocks Found")
    end
    
    return unlocks
end

-- Creating the Dropdown
ShopGroupBox:AddDropdown("UnlocksDropdown", {
    Values = GetUnlocksList(),
    Default = 1,
    Multi = false,
    Text = "Available Unlocks",
    Tooltip = "Select an item",
    Searchable = true,

    Callback = function(Value)
        BuyMaxItems()
    end,
})

-- Refresh button
ShopGroupBox:AddButton({
    Text = "Refresh List",
    Func = function()
        local newList = GetUnlocksList()
        Options.UnlocksDropdown:SetValues(newList)
        Library:Notify("Dropdown refreshed!")
    end
})

-- // UI Settings \\ --

local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")

MenuGroup:AddToggle("KeybindMenuOpen", {
	Default = Library.KeybindFrame.Visible,
	Text = "Open Keybind Menu",
	Callback = function(value)
		Library.KeybindFrame.Visible = value
	end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
	Text = "Custom Cursor",
	Default = true,
	Callback = function(Value)
		Library.ShowCustomCursor = Value
	end,
})
MenuGroup:AddDropdown("NotificationSide", {
	Values = { "Left", "Right" },
	Default = "Right",

	Text = "Notification Side",

	Callback = function(Value)
		Library:SetNotifySide(Value)
	end,
})
MenuGroup:AddDropdown("DPIDropdown", {
	Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
	Default = "100%",

	Text = "DPI Scale",

	Callback = function(Value)
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)

		Library:SetDPIScale(DPI)
	end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
	:AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
	Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:SetSubFolder("specific-place")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()
else
    warn("We do not support this game. In case you're in Dandy's World lobby, please join a match so it works.")
end
