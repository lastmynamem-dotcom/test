local currentID = game.PlaceId -- You can also use game.GameId for the Universe ID

if currentID == 16552821455 then
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
elseif currentID == 9772878203 then
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
  print("Game supported: Raise A Floppa 2")
for _, x in pairs(game.Workspace:GetDescendants()) do
    if x:IsA("ProximityPrompt") then
        x.RequiresLineOfSight = false
    end
end

-- // getgenv()'s \\ --
getgenv().FloppaAutofarm = true
getgenv().BabyFloppasAutofarm = true
getgenv().AutoCollectMoney = true
getgenv().CheckHappiness = true

-- // Services \\ --
local Workspace = game.Workspace
local Players = game.Players

-- // Variables \\ --
local Floppa = Workspace.Floppa
local MsFloppa = Workspace.Unlocks["Ms. Floppa"]
local BabyFloppa = Workspace.Unlocks["Baby Floppa"]
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

LeftGroupBox:AddToggle("AutoCollectMoney", {
    Text = "Auto Collect Money",
    Tooltip = "Automatically collects all of the moneys dropped (money bags included).",
    Default = false,

    Callback = function(Value)
        AutoCollectMoney = Value

        if Value then
            task.spawn(function()
                while AutoCollectMoney do
                    for _, v in pairs(Workspace:GetChildren()) do
                        if v.Name == "Money" and v:IsA("MeshPart") then
                        firetouchinterest(HumanoidRootPart, v, 0)
                        firetouchinterest(HumanoidRootPart, v, 1)
                    end
                end

                    for _, k in pairs(Workspace:GetChildren()) do
                        if k.Name == "Money Bag" then
                        firetouchinterest(HumanoidRootPart, k, 0)
                        firetouchinterest(HumanoidRootPart, k, 1)
                    end
                end
                task.wait()
                end
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

local Unlockss = workspace.Unlocks
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
    ["Basement"] = CFrame.new(-66.6239243, 35.9000168, -42.3410835, 0.0041889227, 8.57384421e-08, -0.999991238, -2.25510117e-08, 1, 8.56447286e-08, 0.999991238, 2.21920562e-08, 0.0041889227),
    ["Second Floor"] = CFrame.new(-58.1133461, 91.4000168, -41.8777542, 0.00523509458, 0, 0.999986291, 0, 1, 0, -0.999986291, 0, 0.00523509458),
    ["Room from the 2nd floor"] = CFrame.new(-68.2723312, 91.4000168, -98.1589966, -0.00383815751, -8.55764597e-08, -0.999992609, -4.77865001e-08, 1, -8.53936726e-08, 0.999992609, 4.74583928e-08, -0.00383815751),
    ["Third Floor"] = CFrame.new(-59.3578835, 110.500015, -41.95158, 0.00732855452, 0, 0.999973118, 0, 1, 0, -0.999973118, 0, 0.00732855452),
    ["DJ El Gato"] = CFrame.new(-78.794281, 73.4000092, -41.9453812, -0.00663209474, 1.63774274e-08, 0.999978006, -9.71405854e-08, 1, -1.70220478e-08, -0.999978006, -9.72513376e-08, -0.00663209474),
    ["Basement 2"] = CFrame.new(-71.616478, 35.9000168, -41.3364449, 0.0254750568, -3.57637582e-08, -0.999675453, 7.03165304e-09, 1, -3.55961802e-08, 0.999675453, -6.12255624e-09, 0.0254750568),
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
