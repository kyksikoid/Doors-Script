if getgenv().AIHubUnload then
pcall(getgenv().AIHubUnload)
task.wait(0.2)
end
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local PathfindingService = game:GetService("PathfindingService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local OriginalWalkSpeed = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed) or 15
local OriginalLighting = {
Ambient = Lighting.Ambient,
OutdoorAmbient = Lighting.OutdoorAmbient,
Brightness = Lighting.Brightness,
GlobalShadows = Lighting.GlobalShadows,
FogEnd = Lighting.FogEnd,
AtmosphereDensity = nil
}
local currentAtmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
if currentAtmosphere then
OriginalLighting.AtmosphereDensity = currentAtmosphere.Density
end
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/TheHunterSolo1/Scripts/main/ESPLibrary"))()
ESPLibrary:SetShowDistance(true)
ESPLibrary:SetTracers(false)
ESPLibrary:SetESPMode("Highlight/Text")
ESPLibrary:SetFont("Legacy")
local RemotesFolder = ReplicatedStorage:FindFirstChild("EntityInfo")
or ReplicatedStorage:FindFirstChild("Bricks")
or ReplicatedStorage:FindFirstChild("RemotesFolder")
or ReplicatedStorage:WaitForChild("RemotesFolder", 5)
local MotorReplication = RemotesFolder:FindFirstChild("MotorReplication")
local ClientModules = ReplicatedStorage:FindFirstChild("ModulesClient") or ReplicatedStorage:FindFirstChild("ClientModules")
local FakeScreech = Instance.new("RemoteEvent", RemotesFolder)
FakeScreech.Name = "Screech_"
local FakeA90 = Instance.new("RemoteEvent", RemotesFolder)
FakeA90.Name = "A90_"
local CollisionClone = nil
local ManipulationNoClipForced = false
local gotToggled = false
local gotToggled2 = false
local Surge = Instance.new("RemoteEvent", ReplicatedStorage)
Surge.Name = "SurgeRemote"
local ExecutorSupport = getgenv().ExecutorSupport or {}
local ReplicateSignal = ExecutorSupport.replicatesignal or replicatesignal
local Firepp = ExecutorSupport.fireproximityprompt or fireproximityprompt
local FireTouch = ExecutorSupport.firetouchinterest or firetouchinterest
if getgenv().ScriptLibrary ~= "Linoria" and getgenv().ScriptLibrary ~= "Obsidian" then
getgenv().ScriptLibrary = "Linoria"
end
local function IsJamminModifierActive()
local liveMod = ReplicatedStorage:FindFirstChild("LiveModifiers")
return liveMod and liveMod:FindFirstChild("Jammin") ~= nil
end
function GetLibraryCode()
local CodeLength = game.ReplicatedStorage.GameData.Floor.Value == "Fools" and 10 or 5
local Slot = table.create(CodeLength, "_")
local Paper
for _, plr in pairs(Players:GetPlayers()) do
local char = plr.Character
if char then
Paper = char:FindFirstChild("LibraryHintPaper") or char:FindFirstChild("LibraryHintPaperHard") or
plr.Backpack:FindFirstChild("LibraryHintPaper") or plr.Backpack:FindFirstChild("LibraryHintPaperHard")
if Paper then break end
end
end
if not Paper then return table.concat(Slot) end
local Hints = LocalPlayer.PlayerGui.PermUI.Hints:GetChildren()
for _, i in pairs(Paper.UI:GetChildren()) do
if i:IsA("ImageLabel") and i.Name ~= "Image" then
local Pos = tonumber(i.Name)
if Pos and Slot[Pos] then
for _, v in pairs(Hints) do
if v.Name == "Icon" and v.ImageRectOffset.X == i.ImageRectOffset.X then
local Label = v:FindFirstChild("TextLabel")
if Label then
Slot[Pos] = Label.Text
end
break
end
end
end
end
end
return table.concat(Slot)
end
local OldFogEnd = nil
local RequiredMainGame = nil
task.spawn(function()
local mainUI = LocalPlayer:WaitForChild("PlayerGui", 5) and LocalPlayer.PlayerGui:WaitForChild("MainUI", 5)
if mainUI then
local mainGame = mainUI:FindFirstChild("Initiator") and mainUI.Initiator:FindFirstChild("Main_Game")
if mainGame then
local req = getgenv().ExecutorSupport and getgenv().ExecutorSupport.require or require
if req then
pcall(function() RequiredMainGame = req(mainGame) end)
end
end
end
end)
function Breaker(part)
local surfaceGui = part:WaitForChild("SurfaceGui", 5)
if not surfaceGui then return end
local frame = surfaceGui:WaitForChild("Frame", 5)
if not frame then return end
local label = frame:WaitForChild("Code", 5)
if not label then return end
local function run()
task.wait(0.05)
if not (Toggles.AutoBreaker and Toggles.AutoBreaker.Value) then return end
local target = tonumber(label.Text)
if target then
for _, v in pairs(part:GetChildren()) do
if v.Name == "BreakerSwitch" and v:GetAttribute("ID") == target then
local codeFrame = label:FindFirstChild("Frame")
if not codeFrame then break end
local trans = codeFrame.BackgroundTransparency
local pc = v:FindFirstChild("PrismaticConstraint")
local light = v:FindFirstChild("Light")
local sound = v:FindFirstChild("Sound")
if trans == 0 then
if v:GetAttribute("Enabled") then return end
v:SetAttribute("Enabled", true)
if pc then pc.TargetPosition = -0.2 end
if light then
light.Material = Enum.Material.Neon
local spark = light:FindFirstChild("Spark", true)
if spark then spark:Emit(1) end
end
if sound then sound:Play() end
elseif trans == 1 then
if not v:GetAttribute("Enabled") then return end
v:SetAttribute("Enabled", false)
if pc then pc.TargetPosition = 0.2 end
if light then light.Material = Enum.Material.Glass end
if sound then sound:Play() end
end
break
end
end
end
end
table.insert(Connections, label:GetPropertyChangedSignal("Text"):Connect(run))
run()
end
local repo = getgenv().ScriptLibrary == "Obsidian"
and 'https://raw.githubusercontent.com/mstudio45/Obsidian/main/'
or 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local LibraryName = "AIHub's Hub"
local Options = Library.Options
local Toggles = Library.Toggles
local Connections = {}
local Window = Library:CreateWindow({
Title = LibraryName,
Center = true,
ToggleKeybind = Enum.KeyCode.RightControl,
AutoShow = true,
NotifySide = "Right",
ShowCustomCursor = true,
})
local Notifying = "Library"
local PlaySound = true
local function Notify(txt, duration)
if Notifying == "Library" then
Library:Notify(txt, duration)
end
if PlaySound then
local Sound = Instance.new("Sound", game:GetService("SoundService"))
Sound.SoundId = "rbxassetid://101511361468852"
Sound.PlaybackSpeed = 0.77
Sound.Volume = 2
Sound:Play()
game:GetService("Debris"):AddItem(Sound, 3)
end
end
if workspace:FindFirstChild("Lobby") then
getgenv().AIHubUnload = function()
pcall(function() Library:Unload() end)
getgenv().AIHubUnload = nil
end
local Tabs = {
Main = Window:AddTab('Teleports', "star"),
Settings = Window:AddTab('Settings', "settings"),
}
local Tp = Tabs.Main:AddLeftGroupbox("Teleport")
Tp:AddLabel('Main menu appears after teleport', true)
Tp:AddButton("Teleport to Hotel", function()
if RemotesFolder:FindFirstChild("CreateElevator") then
RemotesFolder.CreateElevator:FireServer({
Mods = {"AdminPanel"},
Settings = {},
Destination = "Hotel",
FriendsOnly = false,
MaxPlayers = "1"
})
end
end)
Tp:AddButton("Teleport to Mines", function()
if RemotesFolder:FindFirstChild("CreateElevator") then
RemotesFolder.CreateElevator:FireServer({
Mods = {"AdminPanel"},
Settings = {},
Destination = "Mines",
FriendsOnly = false,
MaxPlayers = "1"
})
end
end)
Tp:AddButton("Teleport to Rooms (FREE)", function()
if RemotesFolder:FindFirstChild("CreateElevator") then
RemotesFolder.CreateElevator:FireServer({
Mods = {"AdminPanel"},
Settings = {},
Destination = "Rooms",
FriendsOnly = false,
MaxPlayers = "1"
})
end
end)
Tp:AddButton("Teleport to Backdoors", function()
if RemotesFolder:FindFirstChild("CreateElevator") then
RemotesFolder.CreateElevator:FireServer({
Mods = {"AdminPanel"},
Settings = {},
Destination = "Backdoor",
FriendsOnly = false,
MaxPlayers = "1"
})
end
end)
Tp:AddButton("Teleport to Outdoors (FREE)", function()
if RemotesFolder:FindFirstChild("CreateElevator") then
RemotesFolder.CreateElevator:FireServer({
Mods = {},
Settings = {},
Destination = "Garden",
FriendsOnly = false,
MaxPlayers = "1"
})
end
end)
Tp:AddButton("Teleport to Retro Mode", function()
if RemotesFolder:FindFirstChild("CreateElevator") then
RemotesFolder.CreateElevator:FireServer({
Mods = {},
Settings = {},
Destination = "Retro",
FriendsOnly = false,
MaxPlayers = "1"
})
end
end)
Tp:AddButton("Teleport to Super Hard Mode", function()
if RemotesFolder:FindFirstChild("CreateElevator") then
RemotesFolder.CreateElevator:FireServer({
Mods = {},
Settings = {},
Destination = "SuperHardMode",
FriendsOnly = false,
MaxPlayers = "1"
})
end
end)
Tp:AddButton("Teleport to Endless", function()
if RemotesFolder:FindFirstChild("CreateElevator") then
RemotesFolder.CreateElevator:FireServer({
Mods = {},
Settings = {},
Destination = "Endless",
FriendsOnly = false,
MaxPlayers = "1"
})
end
end)
Tp:AddButton("Teleport to Rush Mode", function()
if RemotesFolder:FindFirstChild("CreateElevator") then
RemotesFolder.CreateElevator:FireServer({
Mods = {},
Settings = {},
Destination = "Fools26",
FriendsOnly = false,
MaxPlayers = "1"
})
end
end)
Tp:AddButton("Teleport to Battle Mode", function()
if RemotesFolder:FindFirstChild("CreateElevator") then
RemotesFolder.CreateElevator:FireServer({
Mods = {},
Settings = {},
Destination = "Party",
FriendsOnly = false,
MaxPlayers = "1"
})
end
end)
Tp:AddButton("Teleport to Chaos", function()
if RemotesFolder:FindFirstChild("CreateElevator") then
RemotesFolder.CreateElevator:FireServer({
Mods = {},
Settings = { youtube = "", twitch = "" },
Destination = "Curated",
FriendsOnly = false,
MaxPlayers = "1"
})
end
end)
Tp:AddButton("Teleport to Daily Run", function()
if RemotesFolder:FindFirstChild("CreateElevator") then
RemotesFolder.CreateElevator:FireServer({
Mods = {},
Settings = {},
Destination = "Daily",
FriendsOnly = false,
MaxPlayers = "1"
})
end
end)
Tp:AddButton("Teleport to Cringles Workshop", function()
if RemotesFolder:FindFirstChild("CreateElevator") then
RemotesFolder.CreateElevator:FireServer({
Mods = {},
Settings = {},
Destination = "CringlesWorkshop",
FriendsOnly = false,
MaxPlayers = "1"
})
end
end)
Tp:AddButton("Teleport to Trick Or Treat", function()
if RemotesFolder:FindFirstChild("CreateElevator") then
RemotesFolder.CreateElevator:FireServer({
Mods = {},
Settings = {},
Destination = "Halloween25",
FriendsOnly = false,
MaxPlayers = "1"
})
end
end)
Tp:AddButton("Teleport to Hotel-", function()
if RemotesFolder:FindFirstChild("CreateElevator") then
RemotesFolder.CreateElevator:FireServer({
Mods = {},
Settings = {},
Destination = "BeforePlus",
FriendsOnly = false,
MaxPlayers = "1"
})
end
end)
local MenuGroup = Tabs.Settings:AddLeftGroupbox('UI Settings')
local UtilityBox = Tabs.Settings:AddRightGroupbox('Hub Utilities')
local MenuPicker = MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
Default = "RightShift",
NoUI = true,
Text = "Menu keybind"
})
Library.ToggleKeybind = Options.MenuKeybind
function MenuPicker:OnClick()
local Event
Event = game:GetService("UserInputService").InputBegan:Connect(function(Input)
if Input.UserInputType ~= Enum.UserInputType.Keyboard then return end
local Key = Input.KeyCode.Name
if Key == "Escape" then
Event:Disconnect()
self:Update()
return
end
self.Value = Key
self.Modifiers = {}
Event:Disconnect()
self:Update()
if Library and Library.UpdateKeybinds then
Library:UpdateKeybinds()
end
end)
end
UtilityBox:AddButton({
Text = "Unload Hub",
Func = function()
if getgenv().AIHubUnload then
getgenv().AIHubUnload()
end
end
})
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'})
ThemeManager:SetFolder("AIHub")
SaveManager:SetFolder("AIHub/DOORSLOBBY")
SaveManager:BuildConfigSection(Tabs['Settings'])
ThemeManager:ApplyToTab(Tabs['Settings'])
Notify("Successfully Loaded for DOORS Lobby", 4)
return
end
local Floor = ReplicatedStorage:FindFirstChild("GameData") and ReplicatedStorage.GameData:FindFirstChild("Floor")
or ReplicatedStorage:WaitForChild("GameData"):WaitForChild("Floor")
local LatestRoom = ReplicatedStorage:WaitForChild("GameData"):WaitForChild("LatestRoom")
local PL = RemotesFolder:FindFirstChild("PL") or RemotesFolder:WaitForChild("PL")
local function RemoveDoorESP(part)
if part and ESPLibrary then
ESPLibrary:RemoveESP(part)
end
end
local function ClearAllDoorESP()
local currentRoomsFolder = workspace:FindFirstChild("CurrentRooms")
if currentRoomsFolder then
for _, v in ipairs(currentRoomsFolder:GetChildren()) do
if v:FindFirstChild("Door") and v.Door:FindFirstChild("Door") then
RemoveDoorESP(v.Door.Door)
if v.Door.Door:FindFirstChild("CrossBoards") then
RemoveDoorESP(v.Door.Door.CrossBoards)
end
end
end
end
end
local function UpdateDoorESP()
if not (Toggles.Door and Toggles.Door.Value) then
ClearAllDoorESP()
return
end
local DoorColor = Options.ColorPicker2 and Options.ColorPicker2.Value or Color3.fromRGB(0, 255, 0)
local currentRoomNum = LocalPlayer:GetAttribute("CurrentRoom")
if not currentRoomNum then return end
local currentRoomsFolder = workspace:FindFirstChild("CurrentRooms")
if not currentRoomsFolder then return end
local oldRoom = currentRoomsFolder:FindFirstChild(tostring(currentRoomNum - 1))
if oldRoom and oldRoom:FindFirstChild("Door") and oldRoom.Door:FindFirstChild("Door") then
local oldDoor = oldRoom.Door.Door
RemoveDoorESP(oldDoor)
if oldDoor:FindFirstChild("CrossBoards") then
RemoveDoorESP(oldDoor.CrossBoards)
end
end
local curRoom = currentRoomsFolder:FindFirstChild(tostring(currentRoomNum))
if curRoom and curRoom:FindFirstChild("Door") and curRoom.Door:FindFirstChild("Door") then
local curDoor = curRoom.Door.Door
local curRoomID = curRoom.Door:GetAttribute("RoomID") or "?"
ESPLibrary:AddESP({ Object = curDoor, Text = "Door " .. curRoomID, Color = DoorColor })
if curDoor:FindFirstChild("CrossBoards") then
ESPLibrary:AddESP({ Object = curDoor.CrossBoards, Text = "", Color = DoorColor })
end
end
local nextRoom = currentRoomsFolder:FindFirstChild(tostring(currentRoomNum + 1))
if nextRoom and nextRoom:FindFirstChild("Door") and nextRoom.Door:FindFirstChild("Door") then
local nextDoor = nextRoom.Door.Door
local nextRoomID = nextDoor.Parent:GetAttribute("RoomID") or "?"
ESPLibrary:AddESP({ Object = nextDoor, Text = "Door " .. nextRoomID, Color = DoorColor })
if nextDoor:FindFirstChild("CrossBoards") then
ESPLibrary:AddESP({ Object = nextDoor.CrossBoards, Text = "", Color = DoorColor })
end
end
end
local HidingPlaces = {
["Wardrobe"] = "Closet",
["Rooms_Locker"] = "Locker",
["Rooms_Locker_Fridge"] = "Fridge",
["Locker_Large"] = "Locker",
["Backdoor_Wardrobe"] = "Closet",
["Bed"] = "Bed",
["Double_Bed"] = "Double Bed",
["Toolshed"] = "Closet",
["RetroWardrobe"] = "Closet",
["CircularVent"] = "Vent",
}
local Closets = {}
local HidingPlaceColor = Color3.new(0, 0.4, 0)
if workspace:FindFirstChild("CurrentRooms") then
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if HidingPlaces[v.Name] then
table.insert(Closets, v)
end
end
end
local ObjectiveItems = {
["Bandage"] = "Bandage",
["Flashlight"] = "Flash light",
["Battery"] = "Battery",
["BatteryPack"] = "Battery Pack",
["SkeletonKey"] = "Skeleton Key",
["Crucifix"] = "Crucifix",
["Straplight"] = "Strap Light",
["Lockpick"] = "Lockpick",
["Bulklight"] = "Bulk Light",
["Vitamins"] = "Vitamin",
["Shears"] = "Shears",
["LaserPointer"] = "Laser Pointer",
["Candle"] = "Candle",
["Smoothie"] = "Smoothie",
["StarJug"] = "Jug of Bottle",
["StardustPickup"] = "Stardust",
["ChestBoxLocked"] = "Locked Chest",
["ChestBox"] = "Chest",
["Chest_Vine"] = "Chest Vine",
["Toolbox_Locked"] = "Locked Toolbox",
["Toolshed_Small"] = "Toolshed",
["TimerLever"] = "Lever",
["HolyGrenade"] = "Holy Grenade",
["ShieldMini"] = "Mini Shield",
["ShieldBig"] = "Big Shield",
["CrucifixWall"] = "Crucifix",
["Glowsticks"] = "Glow Sticks",
["BandagePack"] = "Bandage Pack",
["AlarmClock"] = "Alarm Clock",
["MouseHole"] = "Louie Mouse",
["StarVial"] = "Star Vial",
["StarBottle"] = "Star Bottle",
["Compass"] = "Compass",
["Lantern"] = "Lantern",
["KeyIron"] = "Iron Key",
["GoldGun"] = "Golden Gun",
["Candy"] = "Candy",
["WaterPump"] = "Water Pump",
["VineGuillotine"] = "Vine Lever",
["Shakelight"] = "Shake Light",
["LibraryHintPaper"] = "Hint Paper",
["LotusPetalPickup"] = "Lotus Petal",
["KeyObtain"] = "Key",
["ElectrialKeyObtain"] = "Electrical Key"
}
local ActiveObjectiveESPs = {}
local function RemoveObjectiveESP(inst)
if inst and ActiveObjectiveESPs[inst] then
ActiveObjectiveESPs[inst] = nil
if ESPLibrary then
ESPLibrary:RemoveESP(inst)
end
end
end
local function ClearAllObjectiveESP()
for inst in pairs(ActiveObjectiveESPs) do
if ESPLibrary then
ESPLibrary:RemoveESP(inst)
end
end
table.clear(ActiveObjectiveESPs)
end
local function ClearObjectiveESPInRoom(roomFolder)
if not roomFolder then return end
for inst in pairs(ActiveObjectiveESPs) do
if inst:IsDescendantOf(roomFolder) then
RemoveObjectiveESP(inst)
end
end
end
local function AddObjectiveESPToObject(v)
if not (Toggles.Objective and Toggles.Objective.Value) then return end
if ActiveObjectiveESPs[v] then return end
if v.Name == "Candle" then
if v.Parent and v.Parent.Name == "Candle" then return end
if v.Parent and v.Parent.Parent and v.Parent.Parent.Name == "Candle" then return end
end
local ObjColor = Options.ColorPicker3 and Options.ColorPicker3.Value or Color3.fromRGB(0, 120, 255)
local label = ObjectiveItems[v.Name]
if label then
ActiveObjectiveESPs[v] = true
ESPLibrary:AddESP({ Object = v, Text = label, Color = ObjColor })
elseif v.Name == "MinesAnchor" then
local text = ""
local sign = v:FindFirstChild("Sign")
if sign then
local textLabel = sign:FindFirstChild("TextLabel", true)
if textLabel then
text = textLabel.Text
end
end
ActiveObjectiveESPs[v] = true
ESPLibrary:AddESP({ Object = v, Text = "Anchor " .. text, Color = ObjColor })
end
end
local function UpdateObjectiveESP()
if not (Toggles.Objective and Toggles.Objective.Value) then
ClearAllObjectiveESP()
return
end
local currentRoomNum = LocalPlayer:GetAttribute("CurrentRoom")
if not currentRoomNum then return end
local currentRoomsFolder = workspace:FindFirstChild("CurrentRooms")
if not currentRoomsFolder then return end
local oldRoom = currentRoomsFolder:FindFirstChild(tostring(currentRoomNum - 1))
if oldRoom then
ClearObjectiveESPInRoom(oldRoom)
end
for inst in pairs(ActiveObjectiveESPs) do
local parentRoom = inst:FindFirstAncestorOfClass("Model")
if parentRoom and parentRoom.Parent == currentRoomsFolder then
local rNum = tonumber(parentRoom.Name)
if rNum and rNum < currentRoomNum then
RemoveObjectiveESP(inst)
end
end
end
local curRoom = currentRoomsFolder:FindFirstChild(tostring(currentRoomNum))
if curRoom then
for _, v in ipairs(curRoom:GetDescendants()) do
AddObjectiveESPToObject(v)
end
local floorVal = Floor and Floor.Value or "Hotel"
if floorVal == "Mines" and currentRoomNum == 100 then
local ObjColor = Options.ColorPicker3 and Options.ColorPicker3.Value or Color3.fromRGB(0, 120, 255)
for _, v in ipairs(curRoom:GetDescendants()) do
if v.Name == "WaterPump" or v.Name == "Wheel" then
local prompt = v:FindFirstChildWhichIsA("ProximityPrompt", true) or v.Parent:FindFirstChildWhichIsA("ProximityPrompt", true)
if prompt and prompt.Enabled and not ActiveObjectiveESPs[v] then
ActiveObjectiveESPs[v] = true
ESPLibrary:AddESP({ Object = v, Text = "Valve", Color = ObjColor })
local conn
conn = prompt:GetPropertyChangedSignal("Enabled"):Connect(function()
if not prompt.Enabled then
RemoveObjectiveESP(v)
if conn then conn:Disconnect() end
end
end)
table.insert(Connections, conn)
end
end
end
end
end
local nextRoom = currentRoomsFolder:FindFirstChild(tostring(currentRoomNum + 1))
if nextRoom then
for _, v in ipairs(nextRoom:GetDescendants()) do
AddObjectiveESPToObject(v)
end
end
end
local ActiveCurrentRoomESPs = {}
local LocalEntityNames = {
["Snare"] = "Snare",
["FigureRig"] = "Figure",
["FigureRagdoll"] = "Figure",
["Groundskeeper"] = "Ground Keeper",
["MandrakeLive"] = "Man Drake",
["JeffTheKiller"] = "Jeff"
}
local UtilityNames = {
["Root"] = true,
["HumanoidRootPart"] = true,
["Hitbox"] = true,
["Collision"] = true,
["CollisionPart"] = true,
["Box"] = true,
["Sight"] = true,
["Raycast"] = true,
["Anchor"] = true,
["Pivot"] = true
}
local function SetupEntityForESP(part, callback)
if not part then return end
task.spawn(function()
if part:IsA("Model") then
local visualPart = part:FindFirstChildWhichIsA("MeshPart", true) or part.PrimaryPart or part:FindFirstChildWhichIsA("BasePart", true)
if visualPart then
part.PrimaryPart = visualPart
if visualPart.Transparency >= 1 then
visualPart.Transparency = 0.99
end
end
for _, child in ipairs(part:GetChildren()) do
if child:IsA("BasePart") then
if UtilityNames[child.Name] then
child.Transparency = 1
end
end
end
if not part:FindFirstChildOfClass("Humanoid") then
local hum = Instance.new("Humanoid")
hum.Parent = part
end
end
if callback then callback() end
end)
end
local function ClearCurrentRoomESPs()
for inst in pairs(ActiveCurrentRoomESPs) do
if ESPLibrary then
ESPLibrary:RemoveESP(inst)
end
end
table.clear(ActiveCurrentRoomESPs)
end
local function UpdateCurrentRoomESPs()
ClearCurrentRoomESPs()
local currentRoomNum = LocalPlayer:GetAttribute("CurrentRoom")
if not currentRoomNum then return end
local currentRoomsFolder = workspace:FindFirstChild("CurrentRooms")
if not currentRoomsFolder then return end
local curRoom = currentRoomsFolder:FindFirstChild(tostring(currentRoomNum))
if not curRoom then return end
local floorVal = Floor and Floor.Value or "Hotel"
local entityColor = Options.ColorPicker9 and Options.ColorPicker9.Value or Color3.fromRGB(255, 0, 0)
if Toggles.Books and Toggles.Books.Value then
local presentColor = Options.ColorPicker6 and Options.ColorPicker6.Value or Color3.fromRGB(255, 100, 100)
for _, v in ipairs(curRoom:GetDescendants()) do
if v.Name == "CringlePresent" then
local boxPart = v:FindFirstChild("Box", true) or v:FindFirstChildWhichIsA("BasePart", true)
if boxPart and not ActiveCurrentRoomESPs[boxPart] then
ActiveCurrentRoomESPs[boxPart] = true
ESPLibrary:AddESP({ Object = boxPart, Text = "Present", Color = presentColor })
end
end
end
end
if Toggles.Entity and Toggles.Entity.Value then
for _, v in ipairs(curRoom:GetDescendants()) do
local label = LocalEntityNames[v.Name]
if label then
if (v.Name == "Eyes" or v.Name == "Lookman" or v.Name == "Egg") and
(v:FindFirstAncestor("ScreechPiles") or v:FindFirstAncestor("ScreechPile") or v:FindFirstAncestor("GloomPile") or v:FindFirstAncestor("GloomEgg") or v:FindFirstAncestor("GiggleCeiling")) then
continue
end
if v.Name == "Snare" then
if v:FindFirstChild("Hitbox") then
SetupEntityForESP(v)
ActiveCurrentRoomESPs[v] = true
ESPLibrary:AddESP({ Object = v, Text = label, Color = entityColor })
end
else
SetupEntityForESP(v)
ActiveCurrentRoomESPs[v] = true
ESPLibrary:AddESP({ Object = v, Text = label, Color = entityColor })
end
elseif v.Name == "DoorFake" and v.Parent and v.Parent.Name == "SideroomDupe" then
local door = v:FindFirstChild("Door")
if door then
SetupEntityForESP(door)
ActiveCurrentRoomESPs[door] = true
ESPLibrary:AddESP({ Object = door, Text = "Dupe", Color = entityColor })
end
elseif v.Name == "GiggleCeiling" then
if v:FindFirstChild("Hitbox") then
SetupEntityForESP(v)
ActiveCurrentRoomESPs[v] = true
ESPLibrary:AddESP({ Object = v, Text = "Giggle", Color = entityColor })
end
end
end
if floorVal == "Mines" and currentRoomNum == 50 then
for _, v in ipairs(curRoom:GetDescendants()) do
if v.Name == "GrumbleRig" or v.Name == "LiveEntityBramble" then
local label = v.Name == "GrumbleRig" and "Grumble" or "Bramble"
SetupEntityForESP(v)
ActiveCurrentRoomESPs[v] = true
ESPLibrary:AddESP({ Object = v, Text = label, Color = entityColor })
end
end
end
end
if Toggles.Books and Toggles.Books.Value then
if (floorVal == "Hotel" or floorVal == "Fools") and currentRoomNum == 50 then
local bookColor = Options.ColorPicker6 and Options.ColorPicker6.Value or Color3.fromRGB(0, 0, 128)
for _, v in ipairs(curRoom:GetDescendants()) do
if v.Name == "LiveHintBook" then
ActiveCurrentRoomESPs[v] = true
ESPLibrary:AddESP({ Object = v, Text = "Library Book", Color = bookColor })
end
end
end
end
if Toggles.Breakers and Toggles.Breakers.Value then
if (floorVal == "Hotel" or floorVal == "Fools") and currentRoomNum == 100 then
local breakerColor = Options.ColorPicker7 and Options.ColorPicker7.Value or Color3.fromRGB(128, 255, 128)
for _, v in ipairs(curRoom:GetDescendants()) do
if v.Name == "LiveBreakerPolePickup" then
ActiveCurrentRoomESPs[v] = true
ESPLibrary:AddESP({ Object = v, Text = "Breaker", Color = breakerColor })
end
end
end
end
if Toggles.Gold and Toggles.Gold.Value then
local goldColor = Options.ColorPicker8 and Options.ColorPicker8.Value or Color3.fromRGB(255, 255, 0)
for _, v in ipairs(curRoom:GetDescendants()) do
if v.Name == "GoldPile" then
local val = v:GetAttribute("GoldValue")
local label = val and ("Gold [" .. tostring(val) .. "]") or "Gold"
ActiveCurrentRoomESPs[v] = true
ESPLibrary:AddESP({ Object = v, Text = label, Color = goldColor })
end
end
end
if Toggles.Ladder and Toggles.Ladder.Value then
local ladderColor = Options.ColorPicker10 and Options.ColorPicker10.Value or Color3.fromRGB(0, 0, 255)
for _, v in ipairs(curRoom:GetDescendants()) do
if v.Name == "Ladder" then
ActiveCurrentRoomESPs[v] = true
ESPLibrary:AddESP({ Object = v, Text = "Ladder", Color = ladderColor })
end
end
end
if Toggles.Fuse and Toggles.Fuse.Value then
local fuseColor = Options.ColorPicker11 and Options.ColorPicker11.Value or Color3.fromRGB(255, 170, 0)
for _, v in ipairs(curRoom:GetDescendants()) do
local name = v.Name
local label = nil
if (name == "FuseObtain" or name == "Fuse") and not v:FindFirstAncestor("MinesGenerator") then
label = "Fuse"
elseif name == "MinesGenerator" then
label = "Generator"
elseif name == "MinesGateButton" then
label = "Gate Button"
elseif name == "ElevatorBreaker" then
label = "Breaker Switch"
end
if label then
ActiveCurrentRoomESPs[v] = true
ESPLibrary:AddESP({ Object = v, Text = label, Color = fuseColor })
end
end
end
if Toggles.HidingPlace and Toggles.HidingPlace.Value then
for _, v in ipairs(curRoom:GetDescendants()) do
local label = HidingPlaces[v.Name]
if label then
ActiveCurrentRoomESPs[v] = true
ESPLibrary:AddESP({ Object = v, Text = label, Color = HidingPlaceColor })
end
end
end
if Toggles.GateLever and Toggles.GateLever.Value then
local leverColor = Options.ColorPicker5 and Options.ColorPicker5.Value or Color3.fromRGB(128, 128, 128)
for _, v in ipairs(curRoom:GetDescendants()) do
if v.Name == "LeverForGate" then
ActiveCurrentRoomESPs[v] = true
ESPLibrary:AddESP({ Object = v, Text = "Gate Lever", Color = leverColor })
end
end
end
end
local FastMovingEntityNames = {
["FrozenAmbush"] = "Ambush",
["CringleScreech"] = "Screech",
["RushMoving"] = "Rush",
["AmbushMoving"] = "Ambush",
["A60"] = "A-60",
["A120"] = "A-120",
["GlitchRush"] = "Glitch Rush",
["GlitchAmbush"] = "Glitch Ambush",
["BackdoorRush"] = "Blitz",
["Eyes"] = "Eyes",
["Lookman"] = "Eyes",
["BackdoorLookman"] = "Lookman",
["Screech"] = "Screech"
}
local GlobalEntityESPs = {}
local function ClearGlobalEntityESPs()
for inst in pairs(GlobalEntityESPs) do
if ESPLibrary then ESPLibrary:RemoveESP(inst) end
end
table.clear(GlobalEntityESPs)
end
local function AddGlobalEntityESP(v)
if not (Toggles.Entity and Toggles.Entity.Value) then return end
local label = FastMovingEntityNames[v.Name]
if label and not GlobalEntityESPs[v] then
SetupEntityForESP(v, function()
if not GlobalEntityESPs[v] and Toggles.Entity and Toggles.Entity.Value and v and v.Parent then
local entityColor = Options.ColorPicker9 and Options.ColorPicker9.Value or Color3.fromRGB(255, 0, 0)
GlobalEntityESPs[v] = true
ESPLibrary:AddESP({ Object = v, Text = label, Color = entityColor })
end
end)
end
end
table.insert(Connections, LocalPlayer:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
task.spawn(UpdateDoorESP)
task.spawn(UpdateObjectiveESP)
task.spawn(UpdateCurrentRoomESPs)
end))
table.insert(Connections, LocalPlayer:GetAttributeChangedSignal("Alive"):Connect(function()
if LocalPlayer:GetAttribute("Alive") == false and Toggles.InfRevive and Toggles.InfRevive.Value then
task.wait(0.1)
if RemotesFolder:FindFirstChild("Revive") then
RemotesFolder.Revive:FireServer()
end
end
end))
local Tabs = {
Main = Window:AddTab('Player', "star"),
Bypass = Window:AddTab('Bypass', "ban"),
Visuals = Window:AddTab('Visuals', "eye"),
Floor = Window:AddTab('Floor', "sparkles"),
Settings = Window:AddTab('Settings', "settings"),
}
local DuckBoards = {}
local Nodes = {}
local DefaultMoveControl = nil
pcall(function()
DefaultMoveControl = require(LocalPlayer.PlayerScripts.PlayerModule):GetControls().GetMoveVector
end)
local EntityNotifyNames = {
["FrozenAmbush"] = "Ambush",
["CringleScreech"] = "Screech",
["RushMoving"] = "Rush",
["AmbushMoving"] = "Ambush",
["A60"] = "A-60",
["A120"] = "A-120",
["GlitchRush"] = "GlitchRush",
["GlitchAmbush"] = "GlitchAmbush",
["BackdoorRush"] = "Blitz",
["Eyes"] = "Eyes",
["Lookman"] = "Lookman",
["BackdoorLookman"] = "Lookman",
["JeffTheKiller"] = "Jeff",
["Screech"] = "Screech"
}
local Debris = game:GetService("Debris")
local PathFolder = Instance.new("Folder", workspace)
PathFolder.Name = "AIHub_PathFolder"
local SeekPathFolder = Instance.new("Folder", workspace)
SeekPathFolder.Name = "AIHub_SeekPath"
local Figures = {}
local Anchors = {}
local AutoClosetTable = {
RushMoving = 150,
AmbushMoving = 190,
A60 = 210,
A120 = 120,
GlitchRush = 150,
GlitchAmbush = 190,
BackdoorRush = 160,
}
local function ShowSeekPath(v)
if not v then return end
local Part = Instance.new("Part", SeekPathFolder)
Part.Size = Vector3.new(1.5, 1.5, 1.5)
Part.Anchored = true
Part.Shape = Enum.PartType.Ball
Part.Position = v.Position
Part.CanCollide = false
Part.Color = Color3.fromRGB(0, 255, 0)
Part.Material = Enum.Material.Neon
Debris:AddItem(Part, 60)
end
local function FixBridge(v)
if not v then return end
for _, i in ipairs(v:GetChildren()) do
if i.Name == "PlayerBarrier" and (i.Rotation.X == 180 or math.abs(i.Rotation.X) >= 170) then
if not v:FindFirstChild("BridgeBarrier") then
local Barrier = i:Clone()
Barrier.CFrame = CFrame.new(i.Position.X, i.Position.Y, i.Position.Z) * CFrame.new(0, -7, 0)
Barrier.Size = Vector3.new(40, 0.1, 40)
Barrier.Transparency = 0.5
Barrier.Color = Color3.fromRGB(128, 0, 128)
Barrier.Material = Enum.Material.ForceField
Barrier.Parent = v
Barrier.Name = "BridgeBarrier"
Barrier.Anchored = true
Barrier.CanCollide = true
end
end
end
end
local function PathTo(Pos)
local Character = LocalPlayer.Character
local Root = Character and Character:FindFirstChild("HumanoidRootPart")
local Humanoid = Character and Character:FindFirstChild("Humanoid")
if not Root or not Humanoid or not Pos then return end
local p = PathfindingService:CreatePath({
AgentRadius = 2,
AgentHeight = 5,
AgentCanJump = true,
WaypointSpacing = 2,
AgentCanSprint = false,
AgentMaxSlope = 45,
AgentJumpHeight = 0
})
local AdjustedPos = Pos + Vector3.new(0, 0, 1)
p:ComputeAsync(Root.Position, AdjustedPos)
if p.Status ~= Enum.PathStatus.Success then return end
for _, waypoint in ipairs(p:GetWaypoints()) do
if not (Toggles.AutoRooms and Toggles.AutoRooms.Value) or (Library and Library.Unloaded) then break end
local Dist = (Root.Position - waypoint.Position).Magnitude
if Dist >= 2 then
Humanoid:MoveTo(waypoint.Position)
Humanoid.MoveToFinished:Wait()
end
end
end
local function SolveAnchors()
if not (Toggles.AutoAnchorSolver and Toggles.AutoAnchorSolver.Value) then return end
local latestRoomVal = ReplicatedStorage:FindFirstChild("GameData") and ReplicatedStorage.GameData:FindFirstChild("LatestRoom")
if not latestRoomVal or latestRoomVal.Value ~= 50 then return end
local mainUI = LocalPlayer.PlayerGui:FindFirstChild("MainUI")
local Hint = mainUI and mainUI:FindFirstChild("AnchorHintFrame")
if Hint and Hint.Visible then
local ID = Hint.AnchorCode.Text
for _, v in pairs(Anchors) do
if v and v.Parent and v:FindFirstChild("Sign") and v.Sign:FindFirstChild("TextLabel") and v.Sign.TextLabel.Text == ID then
local Code = Hint.Code.Text
local Note = v:FindFirstChild("Note")
local NoteText = (Note and Note:FindFirstChild("SurfaceGui") and Note.SurfaceGui:FindFirstChild("TextLabel")) and Note.SurfaceGui.TextLabel.Text or ""
local Mod = tonumber(string.match(NoteText, "%d+")) or 0
local Final = ""
for i = 1, #Code do
local Digit = tonumber(string.sub(Code, i, i)) or 0
local Res = string.find(NoteText, "+") and (Digit + Mod) % 10 or (Digit - Mod) % 10
Final = Final .. tostring(Res < 0 and Res + 10 or Res)
end
local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if hrp and (hrp.Position - v:GetPivot().Position).Magnitude < 20 then
local AnchorRemote = v:FindFirstChildOfClass("RemoteFunction")
if AnchorRemote then
AnchorRemote:InvokeServer(tostring(Code))
end
Notify("Anchor Solved: " .. Final, 2)
end
end
end
end
end
local function DeleteSeekFE(v)
if not v or v.Name ~= "TriggerEventCollision" then return end
Notify("Deleting Seek (FE)...", 3)
local Part = v:FindFirstChild("Collision") or v:WaitForChild("Collision", 2)
if Part then
Notify("DONT OPEN NEXT DOOR YET", 2)
task.wait(0.1)
local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if hrp and FireTouch then
for _, Item in ipairs(v:GetChildren()) do
if Item.Name == "Collision" then
FireTouch(hrp, Item, 0)
task.wait(0.02)
FireTouch(hrp, Item, 1)
end
end
end
task.wait(0.4)
local Success = not v:FindFirstChild("Collision")
if Success then
Notify("Deleted Seek Successfully! Open Next Door.", 3)
else
Notify("Failed To Delete Seek!", 3)
end
end
end
local function CheckAndNotifyEntity(v)
if not (Toggles.NotifySpawn and Toggles.NotifySpawn.Value) then return end
if not Options.Notify or not Options.Notify.Value then return end
local notifyKey = EntityNotifyNames[v.Name]
if notifyKey and Options.Notify.Value[notifyKey] then
Notify(notifyKey .. " has Spawned!", 5)
end
end
table.insert(Connections, workspace.ChildAdded:Connect(function(v)
if Toggles.Entity and Toggles.Entity.Value then
AddGlobalEntityESP(v)
end
CheckAndNotifyEntity(v)
if v.Name == "BananaPeel" and Toggles.AntiBanana and Toggles.AntiBanana.Value then
v.CanTouch = false
end
if v.Name == "JeffTheKiller" and Toggles.AntiJeff and Toggles.AntiJeff.Value then
task.spawn(function()
local isOwnerFunc = ExecutorSupport and ExecutorSupport.isnetworkowner or isnetworkowner
local timeout = 0
repeat
task.wait(0.1)
timeout = timeout + 0.1
until (v.PrimaryPart and isOwnerFunc and isOwnerFunc(v.PrimaryPart)) or timeout > 3 or not v.Parent
for _, i in ipairs(v:GetChildren()) do
if i:IsA("BasePart") then
i.CanTouch = false
end
end
local hum = v:FindFirstChildOfClass("Humanoid")
if hum then
hum.Health = 0
end
end)
end
end))
table.insert(Connections, workspace.CurrentCamera.ChildAdded:Connect(function(v)
if v.Name == "Screech" then
if Toggles.Entity and Toggles.Entity.Value then
AddGlobalEntityESP(v)
end
CheckAndNotifyEntity(v)
end
end))
local PlayerBox = Tabs.Main:AddLeftGroupbox('Player')
local GameBox = Tabs.Main:AddLeftGroupbox('Game Management')
local AutoBox = Tabs.Main:AddRightGroupbox('Auto')
local ReachBox = Tabs.Main:AddRightGroupbox('Reach')
local BypassEntityBox = Tabs.Bypass:AddLeftGroupbox('Bypass Entities')
local BypassBox = Tabs.Bypass:AddRightGroupbox('Bypass')
local CameraBox = Tabs.Visuals:AddLeftGroupbox('Camera')
local LightingBox = Tabs.Visuals:AddLeftGroupbox('Lighting')
local ESPBox = Tabs.Visuals:AddRightGroupbox('ESP')
local ESPSettings = Tabs.Visuals:AddRightGroupbox('Settings')
local NotifyBox = Tabs.Visuals:AddRightGroupbox('Notifying')
local HotelFloor = Tabs.Floor:AddLeftGroupbox('Hotel')
local MinesFloor = Tabs.Floor:AddRightGroupbox('Mines')
local FoolsFloor = Tabs.Floor:AddRightGroupbox('Fools')
local RetroFloor = Tabs.Floor:AddLeftGroupbox('Retro')
local RoomsFloor = Tabs.Floor:AddLeftGroupbox('Rooms')
local OldAccel = nil
PlayerBox:AddSlider("MovementSpeed", { Text = "Movement Speed", Default = 15, Min = 15, Max = 21, Rounding = 1, Compact = false, Callback = function() end })
PlayerBox:AddToggle('EnableMovementSpeed', {
Text = "Enable Movement Speed",
Default = false,
Callback = function(Value)
if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
LocalPlayer.Character.Humanoid.WalkSpeed = 15
end
end
})
PlayerBox:AddSlider("ClimbingSpeed", {
Text = "Climbing Speed",
Default = 15,
Min = 15,
Max = 30,
Rounding = 1,
Compact = false,
Callback = function() end,
Tooltip = "Climbing Speed"
})
PlayerBox:AddToggle('EnableClimbingSpeed', {
Text = "Enable Climbing Speed",
Default = false,
Callback = function(Value)
if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
LocalPlayer.Character.Humanoid.WalkSpeed = 15
end
end
})
PlayerBox:AddDivider()
PlayerBox:AddToggle('NoAcc', {
Text = "No Slipping",
Default = false,
Callback = function(Value)
if Value then
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
OldAccel = LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties
end
else
if OldAccel and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = OldAccel
OldAccel = nil
end
end
end
})
PlayerBox:AddToggle('NoClip', {
Text = "No Clip",
Default = false,
Tooltip = "You Can Move Through Wall",
Callback = function(Value)
if not Value and LocalPlayer.Character then
for _, v in pairs(LocalPlayer.Character:GetChildren()) do
if v.Name ~= "CollisionClone" then
if v:IsA("BasePart") then
v.CanCollide = true
end
end
end
end
end
}):AddKeyPicker("NoclipKeybind", {
Default = "N",
SyncToggleState = true,
Mode = "Toggle",
Text = "No Clip",
NoUI = false,
})
PlayerBox:AddToggle('Flight', {
Text = "Flight",
Default = false,
Callback = function(Value)
if not Value then
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlightVelocity") then
LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlightVelocity"):Destroy()
end
end
end
end
}):AddKeyPicker("FlightKeybind", {
Default = "F",
SyncToggleState = true,
Mode = "Toggle",
Text = "Flight",
NoUI = false,
})
PlayerBox:AddSlider("FlightSpeed", {
Text = "Flight Speed",
Default = 15,
Min = 15,
Max = 21,
Rounding = 1,
Compact = false,
Callback = function() end,
Tooltip = "Flight Speed",
})
PlayerBox:AddDivider()
PlayerBox:AddToggle('EnableJump', {
Text = "Enable Jumping",
Default = false,
Tooltip = "You Can Move Jump",
Callback = function(Value)
if not Value and LocalPlayer.Character then
LocalPlayer.Character:SetAttribute("CanJump", false)
end
end
})
PlayerBox:AddDivider()
PlayerBox:AddToggle('InstaInteract', {
Text = "Instant Interact",
Default = false,
Tooltip = "Interactions are Instantly",
Callback = function(Value)
if Value then
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("ProximityPrompt") then
v:SetAttribute("Duration", v.HoldDuration)
v.HoldDuration = 0
end
end
else
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("ProximityPrompt") then
v.HoldDuration = v:GetAttribute("Duration") or 0
end
end
end
end
})
PlayerBox:AddToggle('InfJump', {
Text = "Infinite Jump",
Default = false
})
if UserInputService.KeyboardEnabled then
local d = false
table.insert(Connections, UserInputService.JumpRequest:Connect(function()
if Toggles.InfJump and Toggles.InfJump.Value and not d and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
d = true
LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping, true)
task.wait(0.1)
d = false
end
end))
elseif UserInputService.TouchEnabled then
table.insert(Connections, LocalPlayer.CharacterAdded:Connect(function()
task.wait(1)
if LocalPlayer.PlayerGui:FindFirstChild("MainUI") and LocalPlayer.PlayerGui.MainUI.MainFrame.MobileButtons:FindFirstChild("JumpButton") then
table.insert(Connections, LocalPlayer.PlayerGui.MainUI.MainFrame.MobileButtons.JumpButton.MouseButton1Click:Connect(function()
if Toggles.InfJump and Toggles.InfJump.Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping, true)
end
end))
end
end))
if LocalPlayer.PlayerGui:FindFirstChild("MainUI") and LocalPlayer.PlayerGui.MainUI.MainFrame.MobileButtons:FindFirstChild("JumpButton") then
table.insert(Connections, LocalPlayer.PlayerGui.MainUI.MainFrame.MobileButtons.JumpButton.MouseButton1Click:Connect(function()
if Toggles.InfJump and Toggles.InfJump.Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping, true)
end
end))
end
end
PlayerBox:AddDivider()
PlayerBox:AddLabel("Flat surfaces only. Height changes or launches = DEATH", true)
PlayerBox:AddToggle('Godmode', {
Text = "Godmode",
Default = false,
Tooltip = "Can Lagback you or not work",
Risky = true,
Callback = function(Value)
local Char = LocalPlayer.Character
if not Char then return end
if Value then
if Toggles.FigureHearing then
if not Toggles.FigureHearing.Value then
Toggles.FigureHearing:SetValue(true)
elseif RemotesFolder:FindFirstChild("Crouch") then
RemotesFolder.Crouch:FireServer(true, true)
end
end
if RemotesFolder.Name ~= "RemotesFolder" then
if Char:FindFirstChild("Collision") then
Char.Collision.Position -= Vector3.new(0, 4, 0)
end
else
if Char:FindFirstChild("CollisionPart") then
Char:PivotTo(Char.CollisionPart.CFrame * CFrame.new(0, -2, 0))
end
end
else
if RemotesFolder.Name == "RemotesFolder" then
if Char:FindFirstChild("Humanoid") then Char.Humanoid.HipHeight = 2.4 end
if Char:FindFirstChild("Collision") then Char.Collision.Size = Vector3.new(5.5, 3, 3) end
if Char:FindFirstChild("LowerTorso") and Char.LowerTorso:FindFirstChild("Root") and Char.LowerTorso.Root:IsA("Motor6D") then
pcall(function() Char.LowerTorso.Root.C1 = CFrame.new(0, 0, 0) end)
end
if Char:FindFirstChild("Collision") and Char.Collision:FindFirstChild("CollisionCrouch") then
Char.Collision.CollisionCrouch.Size = Vector3.new(5.5, 3, 3)
end
if Char:FindFirstChild("CollisionPart") then
Char:PivotTo(Char.CollisionPart.CFrame * CFrame.new(0, 2, 0))
end
else
if Char:FindFirstChild("Collision") and Char:FindFirstChild("HumanoidRootPart") then
Char.Collision.Position = Char.HumanoidRootPart.Position
end
end
if RemotesFolder:FindFirstChild("Crouch") then
if Toggles.FigureHearing and Toggles.FigureHearing.Value then
RemotesFolder.Crouch:FireServer(true, true)
else
RemotesFolder.Crouch:FireServer(false, false)
end
end
end
end
}):AddKeyPicker("GodmodeKeybind", {
Default = "G",
SyncToggleState = true,
Mode = "Toggle",
Text = "Godmode",
NoUI = false,
})
GameBox:AddButton({
Text = "Revive",
DoubleClick = true,
Func = function()
if RemotesFolder:FindFirstChild("Revive") then
RemotesFolder.Revive:FireServer()
end
end
})
GameBox:AddButton({
Text = "Play Again",
DoubleClick = true,
Func = function()
if RemotesFolder:FindFirstChild("PlayAgain") then
RemotesFolder.PlayAgain:FireServer()
end
end
})
local ResetPressed = false
GameBox:AddButton({
Text = "Reset",
DoubleClick = true,
Func = function()
ResetPressed = not ResetPressed
if not ResetPressed then
if RemotesFolder:FindFirstChild("Underwater") then
RemotesFolder.Underwater:FireServer(false)
end
return
end
if ReplicateSignal then
ReplicateSignal(LocalPlayer.Kill)
else
Notify("Double Click to stop", 5)
task.spawn(function()
while ResetPressed and LocalPlayer:GetAttribute("Alive") ~= false do
if RemotesFolder:FindFirstChild("Underwater") then
RemotesFolder.Underwater:FireServer(true)
end
task.wait()
end
if RemotesFolder:FindFirstChild("Underwater") then
RemotesFolder.Underwater:FireServer(false)
end
ResetPressed = false
end)
end
end
})
GameBox:AddButton({
Text = "Lobby",
DoubleClick = true,
Func = function()
if RemotesFolder:FindFirstChild("Lobby") then
RemotesFolder.Lobby:FireServer()
end
end
})
table.insert(Connections, LocalPlayer.CharacterAdded:Connect(function(char)
task.wait(1.5)
if Toggles.Godmode and Toggles.Godmode.Value and RemotesFolder.Name ~= "RemotesFolder" then
if char:FindFirstChild("Collision") then
char.Collision.Position -= Vector3.new(0, 4, 0)
end
end
if Toggles.Dread and Toggles.Dread.Value then
local Dread = LocalPlayer:FindFirstChild("Dread", true) or LocalPlayer:FindFirstChild("_Dread", true)
if Dread then
Dread.Name = "_Dread"
end
end
if Toggles.Halt and Toggles.Halt.Value then
local Dread = ClientModules and ClientModules:FindFirstChild("EntityModules") and (ClientModules.EntityModules:FindFirstChild("Shade", true) or ClientModules.EntityModules:FindFirstChild("_Shade", true))
if Dread then
Dread.Name = "_Shade"
end
end
if Toggles.Jamming and Toggles.Jamming.Value then
pcall(function()
local jam = LocalPlayer.PlayerGui.MainUI.Initiator:FindFirstChild("Main_Game").Health.Jam
if jam then jam.Playing = false end
local jammingSound = game:GetService("SoundService").Main:FindFirstChild("Jamming")
if jammingSound then jammingSound.Enabled = false end
end)
end
if Toggles.FigureHearing and Toggles.FigureHearing.Value then
if RemotesFolder:FindFirstChild("Crouch") then
RemotesFolder.Crouch:FireServer(true)
end
end
end))
local lastDoorReachCheck = 0
local InfItemsDelay = 0
local Stored = {}
local Names = {
Lock = true,
ChestBoxLocked = true,
Cellar = true,
Chest_Vine = true,
CuttableVines = true,
SkullLock = true,
Toolbox_Locked = true,
Lock1 = true,
Lock2 = true,
}
local function IsInfItemTarget(prompt)
if not prompt or not prompt:IsA("ProximityPrompt") then return false end
if prompt.Name == "FusesPrompt" then return true end
local parent = prompt.Parent
if not parent then return false end
local parentName = parent.Name
local grandParentName = parent.Parent and parent.Parent.Name
if Names[parentName] or (grandParentName and Names[grandParentName]) then return true end
if grandParentName == "Locker_Small_Locked" then return true end
return false
end
local InfCrucfixTable = {
RushMoving = 90,
AmbushMoving = 160,
A60 = 140,
A120 = 99,
GlitchRush = 150,
GlitchAmbush = 110,
}
local InfParams = RaycastParams.new()
InfParams.FilterType = Enum.RaycastFilterType.Exclude
local function GetDistanceToPlayer(Pos)
if not Pos then return 999999 end
local DisA = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
or (workspace.CurrentCamera and workspace.CurrentCamera.CFrame.Position)
or Vector3.new(0, 0, 0)
return (DisA - Pos).Magnitude
end
local PromptIgnore = {
HidePrompt = true,
ClimbPrompt = true,
PropPrompt = true,
InteractPrompt = true,
RiftPrompt = true,
StarRiftPrompt = true,
NoHidingLilBro = true,
AnimatePrompt = true,
RevivePrompt = true,
}
local Interactions = {}
local Stored = {}
local AutoInteractTimer = 0
local Names = {
Lock = true,
ChestBoxLocked = true,
Cellar = true,
Chest_Vine = true,
CuttableVines = true,
SkullLock = true,
Toolbox_Locked = true,
Lock1 = true,
Lock2 = true,
}
local function InfPrompt(Prompt)
local Char = LocalPlayer.Character
if not Char then return end
local RootPart = Char:FindFirstChild("HumanoidRootPart")
if not RootPart then return end
local Tool = Char:FindFirstChild("Lockpick") or Char:FindFirstChild("SkeletonKey") or Char:FindFirstChild("Shears")
local Name = Tool and Tool.Name
if Tool then
if Prompt:GetAttribute("InfItems") and Prompt:GetAttribute("Tool") ~= Name then
if Prompt.Parent then
local ExistingPrompt = Prompt.Parent:FindFirstChild("InfPrompt")
if ExistingPrompt then
ExistingPrompt:Destroy()
end
Prompt:SetAttribute("InfItems", nil)
Prompt.Enabled = true
end
end
if not Prompt:GetAttribute("InfItems") then
Prompt.Enabled = false
Prompt:SetAttribute("InfItems", true)
Prompt:SetAttribute("Tool", Name)
Prompt.ClickablePrompt = false
local Clone = Prompt:Clone()
Clone.Name = "InfPrompt"
Clone.MaxActivationDistance = Prompt.MaxActivationDistance * 0.5
Clone.Parent = Prompt.Parent
Clone.Enabled = true
Clone.ClickablePrompt = true
local Con, ConEnded
ConEnded = Clone.PromptButtonHoldEnded:Connect(function()
task.delay(0.15, function()
if Clone and Clone.Parent then
if Con then Con:Disconnect() end
if ConEnded then ConEnded:Disconnect() end
Clone:Destroy()
Prompt:SetAttribute("InfItems", nil)
Prompt:SetAttribute("Tool", nil)
Prompt.Enabled = true
Prompt.ClickablePrompt = true
end
end)
end)
Con = Clone.Triggered:Connect(function()
if ConEnded then ConEnded:Disconnect() end
Con:Disconnect()
Clone:Destroy()
if Char:FindFirstChild(Name) then
task.spawn(function()
local Drop = nil
local StartTime = tick()
repeat
RemotesFolder.DropItem:FireServer(Tool)
task.wait(0.01)
local ClosestDist = 15
if workspace:FindFirstChild("Drops") then
for _, v in ipairs(workspace.Drops:GetChildren()) do
if v.Name == Name then
local Dist = GetDistanceToPlayer(v:GetPivot().Position)
if Dist < ClosestDist then
ClosestDist = Dist
Drop = v
end
end
end
end
until Drop or not Char:FindFirstChild(Name) or (tick() - StartTime) > 3
local firePromptFunc = Firepp or fireproximityprompt
if Name == "Shears" then
if firePromptFunc then firePromptFunc(Prompt) end
if Drop then
local DropPrompt = Drop:FindFirstChildWhichIsA("ProximityPrompt", true)
if DropPrompt and firePromptFunc then firePromptFunc(DropPrompt) end
end
else
if Drop then
local DropPrompt = Drop:FindFirstChildWhichIsA("ProximityPrompt", true)
if DropPrompt and firePromptFunc then firePromptFunc(DropPrompt) end
end
if firePromptFunc then firePromptFunc(Prompt) end
end
Prompt:SetAttribute("InfItems", nil)
Prompt:SetAttribute("Tool", nil)
Prompt.Enabled = true
Prompt.ClickablePrompt = true
end)
else
Prompt:SetAttribute("InfItems", nil)
Prompt:SetAttribute("Tool", nil)
Prompt.Enabled = true
Prompt.ClickablePrompt = true
end
end)
end
else
if Prompt:GetAttribute("InfItems") then
if Prompt.Parent then
local ExistingPrompt = Prompt.Parent:FindFirstChild("InfPrompt")
if ExistingPrompt then
ExistingPrompt:Destroy()
end
end
Prompt:SetAttribute("InfItems", nil)
Prompt:SetAttribute("Tool", nil)
Prompt.Enabled = true
Prompt.ClickablePrompt = true
end
end
end
table.insert(Connections, RunService.RenderStepped:Connect(function(dt)
if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or not LocalPlayer.Character:FindFirstChild("Humanoid") then
return
end
if Toggles.AutoMinecart and Toggles.AutoMinecart.Value and Camera:FindFirstChild("MinecartRig") then
if LatestRoom and LatestRoom.Value < 49 then
if not LocalPlayer:GetAttribute("NotifyMinecart") then
Notify("[Auto Minecart] DONT MOVE", 5)
LocalPlayer:SetAttribute("NotifyMinecart", true)
end
local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if Root then
local ClosestDuckDist = math.huge
for _, v in pairs(DuckBoards) do
local Dist = GetDistanceToPlayer(v:GetPivot().Position)
if Dist < ClosestDuckDist then ClosestDuckDist = Dist end
end
if RequiredMainGame and RequiredMainGame.crouching ~= (ClosestDuckDist < 30) then
RequiredMainGame.crouching = (ClosestDuckDist < 30)
end
local CurrentNode = nil
local MinDist = math.huge
for _, Node in pairs(Nodes) do
if Node:GetAttribute("ForceConnect") then
local Dist = (Root.Position - Node.Position).Magnitude
if Dist < MinDist then
MinDist = Dist
CurrentNode = Node
end
end
end
if CurrentNode then
local CurrentNum = tonumber(string.match(CurrentNode.Name, "%d+"))
if CurrentNum then
local Node1
for _, Node in pairs(Nodes) do
if Node.Name == "MinecartNode" .. tostring(CurrentNum + 3) then
Node1 = Node
break
end
end
if Node1 then
local DistToNode = GetDistanceToPlayer(CurrentNode.Position)
local controls = require(LocalPlayer.PlayerScripts.PlayerModule):GetControls()
if DistToNode > 30 then
controls.GetMoveVector = function()
return Vector3.new(0, 0, -1)
end
else
local DirectionToNode = (CurrentNode.Position - Node1.Position).Unit
local Dot = DirectionToNode:Dot(CurrentNode.CFrame.RightVector)
controls.GetMoveVector = function()
if Dot > 0.15 then
return Vector3.new(1, 0, 0)
elseif Dot < -0.15 then
return Vector3.new(1, 0, 0)
end
return Vector3.new(0, 0, -1)
end
end
end
end
end
end
elseif LatestRoom and LatestRoom.Value >= 50 then
if LocalPlayer:GetAttribute("NotifyMinecart") then
Notify("[Auto Minecart] YOU CAN MOVE", 5)
LocalPlayer:SetAttribute("NotifyMinecart", false)
end
if Toggles.AutoMinecart then Toggles.AutoMinecart:SetValue(false) end
if DefaultMoveControl then
pcall(function()
require(LocalPlayer.PlayerScripts.PlayerModule):GetControls().GetMoveVector = DefaultMoveControl
end)
end
end
end
if Toggles.AutoRooms and Toggles.AutoRooms.Value then
if Toggles.IgnoreA60 and Toggles.IgnoreA60.Value and Toggles.Godmode and not Toggles.Godmode.Value then
Toggles.Godmode:SetValue(true)
Notify("Godmode Enabled Automatically For Ignore A-60", 4)
end
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Collision") then
LocalPlayer.Character.Collision.Size = Vector3.new(1, 1, 3)
end
local DangerousEntity = workspace:FindFirstChild("A120") or workspace:FindFirstChild("GlitchRush") or workspace:FindFirstChild("GlitchAmbush")
local A60 = workspace:FindFirstChild("A60")
local ShouldHide = false
if DangerousEntity and DangerousEntity.PrimaryPart and DangerousEntity.PrimaryPart.Position.Y > -4 then
ShouldHide = true
elseif A60 and A60.PrimaryPart and A60.PrimaryPart.Position.Y > -4 then
if not (Toggles.IgnoreA60 and Toggles.IgnoreA60.Value) then
ShouldHide = true
end
end
if ShouldHide then
local Closet = GetNearestHidingSpot()
if Closet then
if Closet:FindFirstChild("Base") then Closet.Base.CanCollide = false end
PathTo(Closet:GetPivot().Position)
local prompt = Closet:FindFirstChildWhichIsA("ProximityPrompt", true)
if prompt and Firepp then
Firepp(prompt)
end
end
else
if LocalPlayer.Character then LocalPlayer.Character:SetAttribute("Hiding", false) end
local currentRoomNum = LocalPlayer:GetAttribute("CurrentRoom")
local currentRoomsFolder = workspace:FindFirstChild("CurrentRooms")
if currentRoomsFolder and currentRoomNum then
local CurrentRoom = currentRoomsFolder:FindFirstChild(tostring(currentRoomNum))
if CurrentRoom and CurrentRoom:FindFirstChild("Door") and CurrentRoom.Door:FindFirstChild("Door") then
PathTo(CurrentRoom.Door.Door.Position)
end
end
end
end
if Toggles.DeleteFigureFE and Toggles.DeleteFigureFE.Value and #Figures > 0 then
for _, v in ipairs(Figures) do
if v and v.Parent then
local Root = v:FindFirstChild("Root")
local isOwnerFunc = ExecutorSupport and ExecutorSupport.isnetworkowner or isnetworkowner
if Root and isOwnerFunc and isOwnerFunc(Root) then
if Root:FindFirstChild("BodyForce") then
Root.BodyForce.Force = Vector3.new(0, -50000, 0)
else
v:PivotTo(CFrame.new(0, -50000, 0))
end
for _, part in ipairs(v:GetDescendants()) do
if part:IsA("BasePart") then
part.CanCollide = false
part.Anchored = false
end
end
if Root.Position.Y < -1000 and not v:GetAttribute("Deleted") then
Notify("Deleted Figure Successfully!", 4)
v:SetAttribute("Deleted", true)
end
end
end
end
end
SolveAnchors()
if Toggles.NotifyLibraryCode and Toggles.NotifyLibraryCode.Value then
if LatestRoom and LatestRoom.Value == 50 then
local Code = GetLibraryCode()
if Code and not LocalPlayer:GetAttribute("LastNotifiedCode") or LocalPlayer:GetAttribute("LastNotifiedCode") ~= Code then
LocalPlayer:SetAttribute("LastNotifiedCode", Code)
Notify("Library Code: " .. Code, 5)
end
end
end
if Toggles.InfRevive and Toggles.InfRevive.Value then
if LocalPlayer:GetAttribute("Alive") == false then
if RemotesFolder:FindFirstChild("Revive") then
RemotesFolder.Revive:FireServer()
end
end
end
if LocalPlayer.Character and not LocalPlayer.Character:FindFirstChild("CollisionClone") then
local cp = LocalPlayer.Character:FindFirstChild("CollisionPart")
if cp then
CollisionClone = cp:Clone()
CollisionClone.Name = "CollisionClone"
CollisionClone.Parent = LocalPlayer.Character
CollisionClone.RootPriority = 127
CollisionClone.Anchored = false
CollisionClone.CanCollide = false
local weld = CollisionClone:FindFirstChildWhichIsA("Weld") or CollisionClone:FindFirstChildWhichIsA("WeldConstraint") or CollisionClone:FindFirstChildWhichIsA("Motor6D")
if weld then
weld.Part0 = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or cp
weld.Part1 = CollisionClone
end
local crouch = CollisionClone:FindFirstChild("CollisionCrouch")
if crouch then
crouch:Destroy()
end
end
end
if Toggles.AutoInteract and Toggles.AutoInteract.Value then
AutoInteractTimer = AutoInteractTimer + (dt or 0.016)
local interactDelay = Options.AutoInteractDelay and Options.AutoInteractDelay.Value or 0.05
if AutoInteractTimer > interactDelay then
AutoInteractTimer = 0
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
local hrpPos = LocalPlayer.Character.HumanoidRootPart.Position
local reachDist = Options.AutoInteractreach and Options.AutoInteractreach.Value or 7
local fireppFunc = Firepp or fireproximityprompt
for i = #Interactions, 1, -1 do
local prompt = Interactions[i]
if not prompt or not prompt.Parent then
table.remove(Interactions, i)
continue
end
if (prompt.Parent.Name == "GoldPile" and Floor and Floor.Value == "Fools") or prompt.Parent.Name == "KeyObtainFake" then
continue
end
if prompt.Parent.Parent and prompt.Parent.Parent.Parent and prompt.Parent.Parent.Parent.Name == "ItemSpawns" then
continue
end
if prompt:GetAttribute("InfItems") and prompt.Name ~= "InfPrompt" then
continue
end
if prompt.Parent.Name == "Mandrake" then
continue
end
if prompt:GetAttribute("Interactions") and prompt:GetAttribute("Interactions") > 0 then
table.remove(Interactions, i)
continue
end
if prompt.Parent:IsA("BasePart") or prompt.Parent:IsA("Model") then
local TargetPart = prompt.Parent:IsA("BasePart") and prompt.Parent or (prompt.Parent.PrimaryPart or prompt.Parent:FindFirstChildWhichIsA("BasePart"))
if TargetPart then
if (hrpPos - TargetPart.Position).Magnitude <= reachDist then
if not prompt.Enabled then
prompt.Enabled = true
end
if fireppFunc then
fireppFunc(prompt)
else
prompt:InputHoldBegin()
prompt:InputHoldEnd(prompt.HoldDuration or 0)
end
end
end
end
end
end
end
end
if Options.AutoInteractKeybind then
if Options.AutoInteractKeybind:GetState() and not Toggles.AutoInteract.Value then
Toggles.AutoInteract:SetValue(true)
elseif not Options.AutoInteractKeybind:GetState() and Toggles.AutoInteract.Value then
Toggles.AutoInteract:SetValue(false)
end
end
local Char = LocalPlayer.Character
local HRP = Char.HumanoidRootPart
local Hum = Char.Humanoid
Camera = workspace.CurrentCamera
local LightingService = game:GetService("Lighting")
local InfItemsToggle = Toggles and Toggles.InfItems
local InfCrucifixToggle = Toggles and Toggles.InfCrucifix
InfItemsDelay += 0.0166666667
if InfItemsToggle and InfItemsToggle.Value and InfItemsDelay > 0.15 then
InfItemsDelay = 0
for _, Prompt in pairs(Stored) do
InfPrompt(Prompt)
end
end
if InfCrucifixToggle and InfCrucifixToggle.Value and (not Toggles.Godmode or not Toggles.Godmode.Value) then
local Origin = HRP.Position
for _, Entity in pairs(workspace:GetChildren()) do
local Range = InfCrucfixTable[Entity.Name]
if Range and Entity.PrimaryPart then
local Target = Entity.PrimaryPart.Position
if (Origin - Target).Magnitude < Range then
InfParams.FilterDescendantsInstances = {Char, Entity}
if not workspace:Raycast(Origin, Target - Origin, InfParams) then
local Tool = Char:FindFirstChild("Crucifix")
if Tool then
RemotesFolder.DropItem:FireServer(Tool)
repeat task.wait()
local dropsFolder = workspace:FindFirstChild("Drops")
local Drop = dropsFolder and dropsFolder:FindFirstChild("Crucifix")
local dropPrompt = Drop and Drop:FindFirstChildOfClass("ProximityPrompt")
if dropPrompt then
if Firepp then Firepp(dropPrompt) elseif fireproximityprompt then fireproximityprompt(dropPrompt) end
end
until Char:FindFirstChild("Crucifix")
end
end
end
end
end
end
if Char and Hum then
if Char:GetAttribute("Climbing") and Toggles.EnableClimbingSpeed and Toggles.EnableClimbingSpeed.Value then
if Hum.WalkSpeed ~= Options.ClimbingSpeed.Value then
Hum.WalkSpeed = Options.ClimbingSpeed.Value
end
elseif not Char:GetAttribute("Climbing") and Toggles.EnableMovementSpeed and Toggles.EnableMovementSpeed.Value then
if Hum.WalkSpeed ~= Options.MovementSpeed.Value then
Hum.WalkSpeed = Options.MovementSpeed.Value
end
end
end
if Toggles.Flight and Toggles.Flight.Value then
if not HRP:FindFirstChild("FlightVelocity") then
local Velocity = Instance.new("BodyVelocity", HRP)
Velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
Velocity.Velocity = Vector3.zero
Velocity.Name = "FlightVelocity"
Velocity.P = math.huge
end
if OldAccel then
HRP.CustomPhysicalProperties = OldAccel
end
local moveDir = Hum.MoveDirection
local flatLook = Camera.CFrame.LookVector * Vector3.new(1, 0, 1)
if flatLook.Magnitude < 0.001 then
flatLook = Camera.CFrame.UpVector * Vector3.new(1, 0, 1) * math.sign(-Camera.CFrame.LookVector.Y)
end
local flatCam = CFrame.lookAt(Vector3.zero, flatLook)
local localInput = flatCam:VectorToObjectSpace(moveDir)
if HRP:FindFirstChild("FlightVelocity") then
HRP.FlightVelocity.Velocity = Camera.CFrame:VectorToWorldSpace(localInput) * Options.FlightSpeed.Value
end
end
if Toggles.NoAcc and Toggles.NoAcc.Value then
if not (Toggles.Flight and Toggles.Flight.Value) then
if HRP.CustomPhysicalProperties ~= PhysicalProperties.new(100, 0.1, 0.1, 0.1, 0.1) then
HRP.CustomPhysicalProperties = PhysicalProperties.new(100, 0.1, 0.1, 0.1, 0.1)
end
end
end
if Toggles.EnableJump and Toggles.EnableJump.Value then
if not Char:GetAttribute("CanJump") then
Char:SetAttribute("CanJump", true)
end
end
if Toggles.AutoLibraryCode and Toggles.AutoLibraryCode.Value then
if LatestRoom and LatestRoom.Value == 50 then
local Code = GetLibraryCode()
if Code then
if Toggles.BruteForceLibCode and Toggles.BruteForceLibCode.Value and string.find(Code, "_") then
local Bruted = ""
for i = 1, #Code do
local char = string.sub(Code, i, i)
Bruted ..= (char == "_" and math.random(0, 9) or char)
end
Code = Bruted
end
if PL then
PL:FireServer(Code)
end
end
end
end
if Toggles and Toggles.EyesDamage and Toggles.EyesDamage.Value then
if workspace:FindFirstChild("Eyes") and not Char:GetAttribute("Hiding") then
if MotorReplication then
if RemotesFolder.Name ~= "RemotesFolder" then
MotorReplication:FireServer(0, -650, 0, false)
else
MotorReplication:FireServer(-650)
end
end
end
end
if Toggles and Toggles.LookmanDamage and Toggles.LookmanDamage.Value then
if (workspace:FindFirstChild("Lookman") or workspace:FindFirstChild("BackdoorLookman")) and not Char:GetAttribute("Hiding") then
if MotorReplication then
MotorReplication:FireServer(-650)
end
end
end
if Toggles.Godmode and Toggles.Godmode.Value then
if RemotesFolder.Name == "RemotesFolder" then
if Toggles.FigureHearing and not Toggles.FigureHearing.Value then
Notify("Enabled Figure Hearing Automaticlly cause Godmode needs it", 3)
Toggles.FigureHearing:SetValue(true)
end
if Char:FindFirstChild("LowerTorso") and Char.LowerTorso:FindFirstChild("Root") and Char.LowerTorso.Root:IsA("Motor6D") then
pcall(function()
if Char.LowerTorso.Root.C1 ~= CFrame.new(0, -2.3, 0) then
Char.LowerTorso.Root.C1 = CFrame.new(0, -2.3, 0)
end
end)
end
if Hum.HipHeight ~= 0.22 then
Hum.HipHeight = 0.22
end
if Char:FindFirstChild("Collision") then
if Char.Collision.Size ~= Vector3.new(1, 1, 4) then
Char.Collision.Size = Vector3.new(1, 1, 4)
end
if Char.Collision:FindFirstChild("CollisionCrouch") and Char.Collision.CollisionCrouch.Size ~= Vector3.new(1, 1, 4) then
Char.Collision.CollisionCrouch.Size = Vector3.new(1, 1, 4)
end
end
end
if (Floor and (Floor.Value == "Fools" or RemotesFolder.Name == "Bricks")) and Toggles.NoClip and not Toggles.NoClip.Value then
Toggles.NoClip:SetValue(true)
end
end
if Toggles.AntiCheatMani and Toggles.AntiCheatMani.Value then
if Options.AntiCheatManiMethod and Options.AntiCheatManiMethod.Value == "Velocity" then
if Toggles.NoClip and not Toggles.NoClip.Value then
Toggles.NoClip:SetValue(true)
ManipulationNoClipForced = true
end
local BodyVelocity = HRP:FindFirstChild("VelocityMani") or Instance.new("BodyVelocity", HRP)
BodyVelocity.Name = "VelocityMani"
BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
local LookingVector = HRP.CFrame.LookVector * 2
BodyVelocity.Velocity = Vector3.new(LookingVector.X, LookingVector.Y, LookingVector.Z)
else
local currentPivot = Char:GetPivot()
Char:PivotTo(currentPivot * CFrame.new(0, 0, 10000))
end
else
if HRP:FindFirstChild("VelocityMani") then
HRP.VelocityMani:Destroy()
end
if ManipulationNoClipForced and Toggles.NoClip and Toggles.NoClip.Value then
Toggles.NoClip:SetValue(false)
end
ManipulationNoClipForced = false
end
if Toggles.NoClip and Toggles.NoClip.Value then
for _, v in ipairs(Char:GetChildren()) do
if v:IsA("BasePart") and v.Name ~= "CollisionClone" and v.CanCollide then
v.CanCollide = false
end
end
if Char:FindFirstChild("Collision") then
Char.Collision.CanCollide = false
if Char.Collision:FindFirstChild("CollisionCrouch") then
Char.Collision.CollisionCrouch.CanCollide = false
end
end
else
for _, v in pairs(Char:GetChildren()) do
if v.Name ~= "CollisionClone" and v.Name ~= "Collision" then
if v:IsA("BasePart") and not v.CanCollide then
v.CanCollide = true
end
end
end
if Char:FindFirstChild("Collision") then
Char.Collision.CanCollide = (Char.Collision.CollisionGroup == "PlayerCrouching" and false or Char.Collision.CollisionGroup ~= "PlayerCrouching" and true)
if Char.Collision:FindFirstChild("CollisionCrouch") then
Char.Collision.CollisionCrouch.CanCollide = Char.Collision.CanCollide
end
end
end
if Toggles and Toggles.DoorReach and Toggles.DoorReach.Value then
local now = os.clock()
if now - lastDoorReachCheck >= 0.2 then
lastDoorReachCheck = now
local gameData = ReplicatedStorage:FindFirstChild("GameData")
local latestRoomVal = gameData and gameData:FindFirstChild("LatestRoom")
if latestRoomVal and workspace:FindFirstChild("CurrentRooms") then
local roomObj = workspace.CurrentRooms:FindFirstChild(tostring(latestRoomVal.Value))
if roomObj and roomObj:FindFirstChild("Door") then
local Door = roomObj.Door
if Door and Door.Parent and Door.Parent.Name ~= "101" then
local doorPart = Door:FindFirstChild("Door") or Door.PrimaryPart or Door:FindFirstChildWhichIsA("BasePart", true)
if doorPart and doorPart.Position then
local dist = GetDistanceToPlayer(doorPart.Position)
if dist and dist < 30 then
local clientOpen = Door:FindFirstChild("ClientOpen")
if clientOpen then
clientOpen:FireServer()
end
end
end
end
end
end
end
end
if Options.FOV then
Camera.FieldOfView = Options.FOV.Value
end
local isThirdPerson = Toggles.ThirdPerson and Toggles.ThirdPerson.Value
local isFreecam = Toggles.Freecam and Toggles.Freecam.Value
for _, v in ipairs(Char:GetChildren()) do
if v:IsA("BasePart") and (v.Name == "Head" or v.Name == "FakeHead") then
v.LocalTransparencyModifier = (isThirdPerson or isFreecam) and 0 or 1
elseif v:IsA("Accessory") then
local handle = v:FindFirstChild("Handle")
if handle then
handle.LocalTransparencyModifier = (isThirdPerson or isFreecam) and 0 or 1
end
end
end
if isThirdPerson then
Camera.CFrame = Camera.CFrame * CFrame.new(Options.X.Value, Options.Y.Value, Options.Z.Value)
end
if isFreecam then
Camera.CameraType = Enum.CameraType.Scriptable
if HRP and not HRP.Anchored then HRP.Anchored = true end
if not getgenv().FreecamCFrame then
getgenv().FreecamCFrame = Camera.CFrame
end
local speed = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 1.5 or 0.6
local moveVec = Vector3.zero
if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec += Vector3.new(0, 0, -1) end
if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec += Vector3.new(0, 0, 1) end
if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec += Vector3.new(-1, 0, 0) end
if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec += Vector3.new(1, 0, 0) end
if UserInputService:IsKeyDown(Enum.KeyCode.E) or UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec += Vector3.new(0, 1, 0) end
if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveVec += Vector3.new(0, -1, 0) end
local delta = UserInputService:GetMouseDelta()
local yaw = CFrame.Angles(0, -math.rad(delta.X * 0.3), 0)
local pitch = CFrame.Angles(-math.rad(delta.Y * 0.3), 0, 0)
getgenv().FreecamCFrame = CFrame.new(getgenv().FreecamCFrame.Position) * yaw * getgenv().FreecamCFrame.Rotation * pitch
local worldMove = getgenv().FreecamCFrame:VectorToWorldSpace(moveVec)
getgenv().FreecamCFrame = getgenv().FreecamCFrame + (worldMove * speed)
Camera.CFrame = getgenv().FreecamCFrame
end
if Toggles.NoCamShake and Toggles.NoCamShake.Value then
if RequiredMainGame and RequiredMainGame.csgo then
RequiredMainGame.csgo = CFrame.identity
end
if Hum then
Hum.CameraOffset = Vector3.zero
end
end
local latestRoomVal = ReplicatedStorage:FindFirstChild("GameData") and ReplicatedStorage.GameData:FindFirstChild("LatestRoom")
if latestRoomVal and latestRoomVal.Value == 100 then
if Toggles.NoScenes and Toggles.NoScenes.Value then
Toggles.NoScenes:SetValue(false)
end
end
if Toggles.NoFog and Toggles.NoFog.Value then
if LightingService.FogEnd < 100000 then
LightingService.FogEnd = 100000
end
for _, v in pairs(LightingService:GetChildren()) do
if v:IsA("Atmosphere") and v.Density > 0 then
v.Density = 0
end
end
end
if Toggles.FullBright and Toggles.FullBright.Value then
if LightingService.Ambient ~= Color3.new(1, 1, 1) then
LightingService.Ambient = Color3.new(1, 1, 1)
end
local currentRoomNum = LocalPlayer:GetAttribute("CurrentRoom")
local currentRoomsFolder = workspace:FindFirstChild("CurrentRooms")
if currentRoomNum and currentRoomsFolder then
local curRoom = currentRoomsFolder:FindFirstChild(tostring(currentRoomNum))
if curRoom then
if not curRoom:GetAttribute("OldAmbient") then
curRoom:SetAttribute("OldAmbient", curRoom:GetAttribute("Ambient") or Color3.new(0, 0, 0))
end
curRoom:SetAttribute("Ambient", Color3.new(1, 1, 1))
end
local nextRoom = currentRoomsFolder:FindFirstChild(tostring(currentRoomNum + 1))
if nextRoom then
if not nextRoom:GetAttribute("OldAmbient") then
nextRoom:SetAttribute("OldAmbient", nextRoom:GetAttribute("Ambient") or Color3.new(0, 0, 0))
end
nextRoom:SetAttribute("Ambient", Color3.new(1, 1, 1))
end
end
end
if Options.NoclipKeybind and Options.NoclipKeybind:GetState() and not Toggles.NoClip.Value then
Toggles.NoClip:SetValue(true)
elseif Options.NoclipKeybind and not Options.NoclipKeybind:GetState() and Toggles.NoClip.Value then
Toggles.NoClip:SetValue(false)
end
if Options.ThirdpersonKeybind then
if Options.ThirdpersonKeybind:GetState() and not Toggles.ThirdPerson.Value then
Toggles.ThirdPerson:SetValue(true)
elseif not Options.ThirdpersonKeybind:GetState() and Toggles.ThirdPerson.Value then
Toggles.ThirdPerson:SetValue(false)
end
end
if Options.FreecamKeybind then
if Options.FreecamKeybind:GetState() and not Toggles.Freecam.Value then
Toggles.Freecam:SetValue(true)
elseif not Options.FreecamKeybind:GetState() and Toggles.Freecam.Value then
Toggles.Freecam:SetValue(false)
end
end
end))
table.insert(Connections, workspace.DescendantAdded:Connect(function(v)
if HidingPlaces[v.Name] then
table.insert(Closets, v)
end
if v.Name == "FigureRig" or v.Name == "FigureRagdoll" then
if Toggles.DeleteFigureFE and Toggles.DeleteFigureFE.Value then
table.insert(Figures, v)
end
end
if v.Name == "MinesAnchor" then
if Toggles.AutoAnchorSolver and Toggles.AutoAnchorSolver.Value then
table.insert(Anchors, v)
end
end
if v.Name == "SeekGuidingLight" and Toggles.ShowPath and Toggles.ShowPath.Value then
ShowSeekPath(v)
end
if v.Name == "SeekFloodline" and Toggles.AntiSeekFlood and Toggles.AntiSeekFlood.Value then
v.CanCollide = true
end
if v.Name == "BananaPeel" and Toggles.AntiBanana and Toggles.AntiBanana.Value then
v.CanTouch = false
end
if v.Name == "JeffTheKiller" and Toggles.AntiJeff and Toggles.AntiJeff.Value then
task.spawn(function()
for _, i in ipairs(v:GetChildren()) do
if i:IsA("BasePart") then i.CanTouch = false end
end
if v:FindFirstChildOfClass("Humanoid") then
v:FindFirstChildOfClass("Humanoid").Health = 0
end
end)
end
if v.Name == "TriggerEventCollision" and Toggles.DeleteSeekFE and Toggles.DeleteSeekFE.Value then
task.spawn(function()
DeleteSeekFE(v)
end)
end
if (v.Name == "Seek_Arm" or v.Name == "ChandelierObstruction") and Toggles.SeekObf and Toggles.SeekObf.Value then
for _, i in ipairs(v:GetChildren()) do
if i:IsA("BasePart") then i.CanTouch = false end
end
end
if v.Name == "Lava" and Toggles.AntiLava and Toggles.AntiLava.Value then
v.CanTouch = false
end
if v.Name == "ScaryWall" and Toggles.AntiWall and Toggles.AntiWall.Value then
for _, i in ipairs(v:GetChildren()) do
if i:IsA("BasePart") then i.CanTouch = false end
end
end
if Toggles.AutoMinecart and Toggles.AutoMinecart.Value then
if v.Name == "DuckBoard" then
table.insert(DuckBoards, v)
end
if string.find(v.Name, "MinecartNode") then
table.insert(Nodes, v)
end
end
if v.Name == "Bridge" and Toggles.FixBrokenBridge and Toggles.FixBrokenBridge.Value then
task.spawn(function()
task.wait(0.1)
FixBridge(v)
end)
end
if v:IsA("ProximityPrompt") then
if not (PromptIgnore[v.Name] or (v.Parent and v.Parent.Name == "Padlock") or (v.Parent and v.Parent:GetAttribute("JeffShop"))) or (v.Parent and v.Parent.Name == "RetroWardrobe") then
if not table.find(Interactions, v) then
table.insert(Interactions, v)
end
end
if Toggles.InstaInteract and Toggles.InstaInteract.Value then
v:SetAttribute("Duration", v.HoldDuration)
v.HoldDuration = 0
end
if Toggles.InfItems and Toggles.InfItems.Value then
if IsInfItemTarget(v) then
if not table.find(Stored, v) then
table.insert(Stored, v)
end
end
end
end
if Toggles and Toggles.Objective and Toggles.Objective.Value then
local name = v.Name
if ObjectiveItems[name] or name == "MinesAnchor" then
local currentRoomNum = LocalPlayer:GetAttribute("CurrentRoom")
if currentRoomNum then
local currentRoomsFolder = workspace:FindFirstChild("CurrentRooms")
if currentRoomsFolder then
local curRoom = currentRoomsFolder:FindFirstChild(tostring(currentRoomNum))
local nextRoom = currentRoomsFolder:FindFirstChild(tostring(currentRoomNum + 1))
if (curRoom and v:IsDescendantOf(curRoom)) or (nextRoom and v:IsDescendantOf(nextRoom)) then
AddObjectiveESPToObject(v)
end
end
end
end
end
if Toggles.Snare and Toggles.Snare.Value and v.Name == "Snare" then
task.spawn(function()
local hb = v:WaitForChild("Hitbox", 3)
if hb then hb.CanTouch = false end
end)
end
if Toggles.Giggle and Toggles.Giggle.Value and v.Name == "GiggleCeiling" then
task.spawn(function()
local hb = v:WaitForChild("Hitbox", 3)
if hb then hb.CanTouch = false end
end)
end
if Toggles.Dupe and Toggles.Dupe.Value then
if v.Name == "DoorFake" and v.Parent and v.Parent.Name == "SideroomDupe" then
local hidden = v:FindFirstChild("Hidden")
if hidden then hidden.CanTouch = false end
end
end
if Toggles.GloomEggDamage and Toggles.GloomEggDamage.Value and v.Name == "GloomEgg" then
task.spawn(function()
for _, i in ipairs(v:GetChildren()) do
if i:IsA("BasePart") then i.CanTouch = false end
end
end)
end
if Toggles.AntiLag and Toggles.AntiLag.Value then
if v:IsA("BasePart") then
v:SetAttribute("Mat", v.Material)
v.Material = Enum.Material.Plastic
end
end
if Toggles.AutoBreaker and Toggles.AutoBreaker.Value then
if v.Name == "ElevatorBreaker" then
Breaker(v)
end
end
end))
table.insert(Connections, workspace.DescendantRemoving:Connect(function(v)
local closetIndex = table.find(Closets, v)
if closetIndex then
table.remove(Closets, closetIndex)
end
if v:IsA("ProximityPrompt") then
local index = table.find(Stored, v)
if index then table.remove(Stored, index) end
local intIndex = table.find(Interactions, v)
if intIndex then table.remove(Interactions, intIndex) end
end
if ActiveCurrentRoomESPs[v] then
ActiveCurrentRoomESPs[v] = nil
if ESPLibrary then ESPLibrary:RemoveESP(v) end
end
if GlobalEntityESPs[v] then
GlobalEntityESPs[v] = nil
if ESPLibrary then ESPLibrary:RemoveESP(v) end
end
if ActiveObjectiveESPs[v] then
RemoveObjectiveESP(v)
end
end))
AutoBox:AddToggle("AutoInteract", {
Text = "Auto Interact",
Default = false,
Tooltip = "Automatically Interacts with things when near",
Callback = function(Value)
if Value then
table.clear(Interactions)
local currentRoomsFolder = workspace:FindFirstChild("CurrentRooms")
if currentRoomsFolder then
for _, v in ipairs(currentRoomsFolder:GetDescendants()) do
if v:IsA("ProximityPrompt") then
if not (PromptIgnore[v.Name] or (v.Parent and v.Parent.Name == "Padlock") or (v.Parent and v.Parent:GetAttribute("JeffShop"))) or (v.Parent and v.Parent.Name == "RetroWardrobe") or (v.Parent and v.Parent.Name == "KeyObtainFake") then
table.insert(Interactions, v)
end
end
end
end
else
table.clear(Interactions)
end
end
}):AddKeyPicker("AutoInteractKeybind", {
Default = "R",
SyncToggleState = true,
Mode = Library.IsMobile and "Toggle" or "Hold",
Text = "Auto Interact"
})
AutoBox:AddSlider("AutoInteractDelay", {
Text = "Auto Interact Delay",
Default = 0,
Min = 0,
Max = 0.2,
Rounding = 2,
Compact = false,
Callback = function() end
})
AutoBox:AddSlider("AutoInteractreach", {
Text = "Auto Interact Range",
Default = 12,
Min = 7,
Max = 12,
Rounding = 2,
Compact = false,
Callback = function() end
})
AutoBox:AddDivider()
AutoBox:AddToggle('AutoLibraryCode', { Text = "Auto Library Code", Default = false, Callback = function() end })
AutoBox:AddToggle('BruteForceLibCode', { Text = "Bruteforce Library Code", Default = false, Callback = function() end })
AutoBox:AddToggle('AutoHeartbeat', { Text = "Auto Heartbeat Minigame", Default = false, Callback = function() end })
AutoBox:AddDivider()
local function SolveBreaker(breaker)
if not breaker or not breaker.Parent then return end
local surfaceGui = breaker:FindFirstChild("SurfaceGui", true)
if not surfaceGui then return end
local frame = surfaceGui:FindFirstChild("Frame", true)
if not frame then return end
local codeLabel = frame:FindFirstChild("Code", true)
if not codeLabel then return end
local targetNum = tonumber(codeLabel.Text)
if not targetNum then return end
local indicatorFrame = codeLabel:FindFirstChild("Frame")
local shouldBeOn = indicatorFrame and (indicatorFrame.BackgroundTransparency == 0) or false
for _, switch in ipairs(breaker:GetChildren()) do
if switch.Name == "BreakerSwitch" and switch:GetAttribute("ID") == targetNum then
local pc = switch:FindFirstChild("PrismaticConstraint")
local light = switch:FindFirstChild("Light")
local sound = switch:FindFirstChild("Sound")
if shouldBeOn then
if not switch:GetAttribute("Enabled") then
switch:SetAttribute("Enabled", true)
if pc then pc.TargetPosition = -0.2 end
if light then
light.Material = Enum.Material.Neon
local spark = light:FindFirstChild("Spark", true)
if spark then spark:Emit(1) end
end
if sound then sound:Play() end
end
else
if switch:GetAttribute("Enabled") then
switch:SetAttribute("Enabled", false)
if pc then pc.TargetPosition = 0.2 end
if light then light.Material = Enum.Material.Glass end
if sound then sound:Play() end
end
end
break
end
end
end
AutoBox:AddToggle('AutoBreaker', {
Text = "Auto Breaker Minigame",
Disabled = Floor and (Floor.Value == "Mines" or Floor.Value == "Retro" or Floor.Value == "Outdoors") or false,
Default = false,
Callback = function() end
})
task.spawn(function()
while task.wait(0.1) do
if Toggles and Toggles.AutoBreaker and Toggles.AutoBreaker.Value then
local breakerObj = workspace:FindFirstChild("ElevatorBreaker", true)
if breakerObj then
SolveBreaker(breakerObj)
end
end
end
end)
ReachBox:AddToggle('DoorReach', {
Text = "Door Reach",
Default = false,
Callback = function() end
})
BypassEntityBox:AddToggle('Screech', {
Text = "Anti Screech Damage",
Default = false,
Callback = function(Value)
if Value then
gotToggled = true
if RemotesFolder:FindFirstChild("Screech") then
RemotesFolder.Screech.Name = "Screech_"
end
FakeScreech.Name = "Screech"
else
if gotToggled then
if RemotesFolder:FindFirstChild("Screech_") then
RemotesFolder["Screech_"].Name = "Screech"
end
FakeScreech.Name = "Screech_"
end
end
end
})
local HookMeta = hookmetamethod or hookfunction
if HookMeta then
local Old
Old = hookmetamethod(game, "__namecall", function(Self, ...)
if Library and Library.Unloaded then
return Old(Self, ...)
end
local Method = getnamecallmethod()
if Method == "FireServer" or Method == "InvokeServer" then
if Toggles.AutoHeartbeat and Toggles.AutoHeartbeat.Value and Self.Name == "ClutchHeartbeat" then
return Old(Self, true)
end
if Method == "FireServer" and Self.Name == "Crouch" then
local isSpeedBypass = Toggles.BypassSpeed and Toggles.BypassSpeed.Value
local isFigHearing = Toggles.FigureHearing and Toggles.FigureHearing.Value
if isSpeedBypass or isFigHearing then
return Old(Self, true, true)
end
end
end
return Old(Self, ...)
end)
end
BypassEntityBox:AddToggle('A90', {
Text = "Anti A90 Damage",
Default = false,
Callback = function(Value)
if Value then
gotToggled2 = true
if RemotesFolder:FindFirstChild("A90") then
RemotesFolder.A90.Name = "A90_"
end
FakeA90.Name = "A90"
else
if gotToggled2 then
if RemotesFolder:FindFirstChild("A90_") then
RemotesFolder["A90_"].Name = "A90"
end
FakeA90.Name = "A90_"
end
end
end
})
BypassEntityBox:AddToggle('Dread', {
Text = "Anti Dread",
Default = false,
Callback = function(Value)
local DreadObj = LocalPlayer:FindFirstChild("Dread", true) or LocalPlayer:FindFirstChild("_Dread", true)
if DreadObj then
DreadObj.Name = Value and "_Dread" or "Dread"
end
end
})
BypassEntityBox:AddToggle('Halt', {
Text = "Anti Halt",
Default = false,
Callback = function(Value)
if ClientModules and ClientModules:FindFirstChild("EntityModules") then
local ShadeObj = ClientModules.EntityModules:FindFirstChild("Shade", true) or ClientModules.EntityModules:FindFirstChild("_Shade", true)
if ShadeObj then
ShadeObj.Name = Value and "_Shade" or "Shade"
end
end
end
})
BypassEntityBox:AddToggle('Jamming', {
Text = "Anti Jamming",
Default = false,
Callback = function(Value)
pcall(function()
local mainUI = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("MainUI")
if mainUI then
local jam = mainUI:FindFirstChild("Initiator", true) and mainUI.Initiator:FindFirstChild("Main_Game", true) and mainUI.Initiator.Main_Game:FindFirstChild("Health", true) and mainUI.Initiator.Main_Game.Health:FindFirstChild("Jam")
if jam and Value then jam.Playing = false end
end
local jammingSound = game:GetService("SoundService"):FindFirstChild("Main") and game:GetService("SoundService").Main:FindFirstChild("Jamming")
if jammingSound then
if Value then
jammingSound.Enabled = false
else
jammingSound.Enabled = IsJamminModifierActive()
end
end
end)
end
})
BypassEntityBox:AddToggle('BypassSurgeDamage', {
Text = "Anti Surge Damage",
Default = false,
Callback = function(Value)
if Value then
if RemotesFolder:FindFirstChild("SurgeRemote") then
RemotesFolder.SurgeRemote.Parent = ReplicatedStorage
Surge.Parent = RemotesFolder
end
else
if ReplicatedStorage:FindFirstChild("SurgeRemote") then
ReplicatedStorage.SurgeRemote.Parent = RemotesFolder
Surge.Parent = ReplicatedStorage
end
end
end
})
BypassEntityBox:AddToggle('Snare', {
Text = "Anti Snare",
Default = false,
Callback = function(Value)
if workspace:FindFirstChild("CurrentRooms") then
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "Snare" and v:FindFirstChild("Hitbox") then
v.Hitbox.CanTouch = not Value
end
end
end
end
})
BypassEntityBox:AddToggle('Giggle', {
Text = "Anti Giggle",
Default = false,
Disabled = Floor and Floor.Value == "Fools" and RemotesFolder.Name == "Bricks" and true or false,
Callback = function(Value)
if workspace:FindFirstChild("CurrentRooms") then
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "GiggleCeiling" and v:FindFirstChild("Hitbox") then
v.Hitbox.CanTouch = not Value
end
end
end
end
})
BypassEntityBox:AddToggle('Dupe', {
Text = "Anti Dupe",
Default = false,
Callback = function(Value)
if workspace:FindFirstChild("CurrentRooms") then
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "DoorFake" and v.Parent and v.Parent.Name == "SideroomDupe" then
local hidden = v:FindFirstChild("Hidden")
if hidden then hidden.CanTouch = not Value end
end
end
end
end
})
BypassEntityBox:AddToggle('EyesDamage', {
Text = "Anti Eyes Damage",
Default = false,
Callback = function() end
})
BypassEntityBox:AddToggle('LookmanDamage', {
Text = "Anti Lookman Damage",
Default = false,
Callback = function() end
})
BypassEntityBox:AddToggle('GloomEggDamage', {
Text = "Anti Gloom Egg",
Default = false,
Callback = function(Value)
if workspace:FindFirstChild("CurrentRooms") then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "GloomEgg" or v.Name == "GloomPile" then
for _, p in ipairs(v:GetDescendants()) do
if p:IsA("BasePart") then
p.CanTouch = not Value
end
end
end
end
end
end
})
BypassEntityBox:AddToggle('FigureHearing', {
Text = "Anti Figure Hearing",
Default = false,
Disabled = Floor and Floor.Value == "Fools" and true or false,
DisabledTooltip = "This floor wont support this feature",
Callback = function(Value)
if RemotesFolder:FindFirstChild("Crouch") then
local speedBypassOn = Toggles.BypassSpeed and Toggles.BypassSpeed.Value
if not speedBypassOn then
if Value then
RemotesFolder.Crouch:FireServer(true, true)
else
RemotesFolder.Crouch:FireServer(false, false)
end
end
end
end
})
BypassEntityBox:AddToggle('AntiLag', {
Text = "Anti Lag",
Default = false,
Callback = function(Value)
if workspace:FindFirstChild("CurrentRooms") then
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if v:IsA("BasePart") then
if Value then
if not v:GetAttribute("Mat") then
v:SetAttribute("Mat", v.Material)
end
v.Material = Enum.Material.Plastic
else
if v:GetAttribute("Mat") then
v.Material = v:GetAttribute("Mat")
end
end
end
end
end
end
})
BypassEntityBox:AddLabel('Anti Lag if it Lags you Turn it off', true)
BypassBox:AddToggle('BypassSpeed', {
Text = "Speed Bypass",
Default = false,
Callback = function(Value)
Options.MovementSpeed:SetMax(Value and 75 or 21)
Options.FlightSpeed:SetMax(Value and 75 or 21)
end
})
BypassBox:AddDivider()
BypassBox:AddDropdown("AntiCheatManiMethod", { Values = { "Velocity", "Anticheat" }, Default = 1, Text = "Manipulation Method", Callback = function() end })
BypassBox:AddToggle('AntiCheatMani', { Text = "Manipulation", Default = false, Callback = function() end }):AddKeyPicker("AntiCheatMan", { Default = "V", SyncToggleState = true, Mode = "Hold", Text = "Manipulation" })
BypassBox:AddDivider()
BypassBox:AddLabel("Infinite Crucfix Only Works on A-60 A-120 Rush And Ambush and it have a chance to fail so take it at your own risk", true)
BypassBox:AddToggle('InfCrucifix', {
Text = "Infinite Crucifix",
Risky = true,
Default = false,
Callback = function() end
})
BypassBox:AddDivider()
BypassBox:AddLabel("Works ONLY with Auto Interact Highly sensitive, breaks easily", true)
BypassBox:AddToggle('InfItems', {
Text = "Infinite Items",
Risky = true,
Default = false,
Tooltip = "Works ONLY with Auto Interact Highly sensitive, breaks easily",
Callback = function(Value)
if Value then
if workspace:FindFirstChild("CurrentRooms") then
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if v:IsA("ProximityPrompt") then
if IsInfItemTarget(v) then
if not table.find(Stored, v) then
table.insert(Stored, v)
end
end
end
end
end
else
if workspace:FindFirstChild("CurrentRooms") then
for _, Prompt in pairs(workspace.CurrentRooms:GetDescendants()) do
if Prompt:IsA("ProximityPrompt") then
if Prompt:GetAttribute("InfItems") then
local Fake = Prompt.Parent and Prompt.Parent:FindFirstChild("InfPrompt")
if Fake then
Fake:Destroy()
end
Prompt:SetAttribute("InfItems", nil)
Prompt:SetAttribute("Tool", nil)
Prompt.Enabled = true
Prompt.ClickablePrompt = true
end
end
end
end
table.clear(Stored)
end
end
})
table.insert(Connections, LocalPlayer.CharacterAdded:Connect(function()
if CollisionClone then
CollisionClone = nil
end
end))
task.spawn(function()
while task.wait(0.05) do
if Library and Library.Unloaded then break end
if Toggles.BypassSpeed and Toggles.BypassSpeed.Value then
if CollisionClone and CollisionClone.Parent then
CollisionClone.Massless = true
end
if RemotesFolder and RemotesFolder:FindFirstChild("Crouch") then
RemotesFolder.Crouch:FireServer(true, true)
end
end
end
end)
CameraBox:AddSlider("FOV", { Text = "FOV", Default = 70, Min = 70, Max = 120, Rounding = 1, Compact = false, Callback = function() end })
CameraBox:AddDivider()
CameraBox:AddToggle('ThirdPerson', {
Text = "Third Person",
Default = false,
Callback = function(Value)
if not Value and LocalPlayer.Character then
for _, v in pairs(LocalPlayer.Character:GetChildren()) do
if v:IsA("BasePart") and (v.Name == "Head" or v.Name == "FakeHead") then
v.Transparency = 0
v.LocalTransparencyModifier = 0
elseif v:IsA("Accessory") and v:FindFirstChild("Handle") then
v.Handle.Transparency = 0
v.Handle.LocalTransparencyModifier = 0
end
end
end
end
}):AddKeyPicker("ThirdpersonKeybind", { Default = "T", SyncToggleState = true, Mode = "Toggle", Text = "Third Person" })
CameraBox:AddSlider("X", { Text = "X", Default = 2, Min = -10, Max = 10, Rounding = 1, Compact = false, Callback = function() end })
CameraBox:AddSlider("Y", { Text = "Y", Default = 0, Min = -10, Max = 10, Rounding = 1, Compact = false, Callback = function() end })
CameraBox:AddSlider("Z", { Text = "Z", Default = 4, Min = -10, Max = 10, Rounding = 1, Compact = false, Callback = function() end })
CameraBox:AddToggle('NoCamShake', { Text = "No Camera Shake", Default = false, Callback = function() end })
CameraBox:AddToggle('Freecam', {
Text = "Freecam",
Default = false,
Callback = function(Value)
local char = LocalPlayer.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if Value then
if hrp then hrp.Anchored = true end
workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
getgenv().FreecamCFrame = workspace.CurrentCamera.CFrame
else
if hrp then hrp.Anchored = false end
workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
if char and char:FindFirstChildOfClass("Humanoid") then
workspace.CurrentCamera.CameraSubject = char:FindFirstChildOfClass("Humanoid")
end
end
end
}):AddKeyPicker("FreecamKeybind", { Default = "B", SyncToggleState = true, Mode = "Toggle", Text = "Freecam" })
CameraBox:AddToggle('NoScenes', {
Text = "No Cutscenes",
Default = false,
Callback = function(Value)
local latestRoom = ReplicatedStorage:FindFirstChild("GameData") and ReplicatedStorage.GameData:FindFirstChild("LatestRoom")
if latestRoom and latestRoom.Value == 100 and Value then
Notify("No Cutscenes disabled for Room 100 to prevent softlock", 3)
task.spawn(function()
Toggles.NoScenes:SetValue(false)
end)
return
end
pcall(function()
local mainUI = LocalPlayer.PlayerGui:FindFirstChild("MainUI")
local remoteListener = mainUI and mainUI.Initiator.Main_Game:FindFirstChild("RemoteListener")
if remoteListener then
for _, v in ipairs(remoteListener:GetChildren()) do
if v.Name == "Cutscenes" or v.Name == "Cutscenes_" then
v.Name = Value and "Cutscenes_" or "Cutscenes"
end
end
end
end)
end
})
LightingBox:AddToggle('NoFog', {
Text = "No Fog",
Default = false,
Callback = function(Value)
if not Value then
for _, v in pairs(Lighting:GetChildren()) do
if v:IsA("Atmosphere") then
v.Density = 0.94
end
end
if OldFogEnd then
Lighting.FogEnd = OldFogEnd
OldFogEnd = nil
end
else
OldFogEnd = Lighting.FogEnd
end
end
})
LightingBox:AddToggle('FullBright', {
Text = "Fullbright",
Default = false,
Callback = function(Value)
if not Value then
Lighting.Ambient = Color3.fromRGB(0, 0, 0)
Lighting.GlobalShadows = true
local currentRoomsFolder = workspace:FindFirstChild("CurrentRooms")
if currentRoomsFolder then
for _, v in pairs(currentRoomsFolder:GetChildren()) do
if v:GetAttribute("OldAmbient") then
v:SetAttribute("Ambient", v:GetAttribute("OldAmbient"))
end
end
end
end
end
})
ESPBox:AddToggle('Door', {
Text = "Door",
Default = false,
Callback = function(Value)
if Value then UpdateDoorESP() else ClearAllDoorESP() end
end
}):AddColorPicker("ColorPicker2", {
Default = Color3.fromRGB(0, 255, 0),
Title = "Door Color",
Callback = function() if Toggles.Door and Toggles.Door.Value then UpdateDoorESP() end end
})
ESPBox:AddToggle('Objective', {
Text = "Objective",
Default = false,
Callback = function(Value)
if Value then UpdateObjectiveESP() else ClearAllObjectiveESP() end
end
}):AddColorPicker("ColorPicker3", {
Default = Color3.fromRGB(0, 120, 255),
Title = "Objective Color",
Callback = function() if Toggles.Objective and Toggles.Objective.Value then UpdateObjectiveESP() end end
})
ESPBox:AddToggle('HidingPlace', {
Text = "Hiding Place",
Default = false,
Callback = function() UpdateCurrentRoomESPs() end
}):AddColorPicker("ColorPicker4", {
Default = HidingPlaceColor,
Title = "Hiding Place Color",
Callback = function(Value) HidingPlaceColor = Value; UpdateCurrentRoomESPs() end
})
ESPBox:AddToggle('GateLever', {
Text = "Gate Lever",
Default = false,
Callback = function() UpdateCurrentRoomESPs() end
}):AddColorPicker("ColorPicker5", {
Default = Color3.fromRGB(128, 128, 128),
Title = "Lever Color",
Callback = function() UpdateCurrentRoomESPs() end
})
ESPBox:AddToggle('Books', {
Text = "Library Book",
Default = false,
Callback = function() UpdateCurrentRoomESPs() end
}):AddColorPicker("ColorPicker6", {
Default = Color3.fromRGB(0, 0, 128),
Title = "Book Color",
Callback = function() UpdateCurrentRoomESPs() end
})
ESPBox:AddToggle('Breakers', {
Text = "Breaker",
Default = false,
Callback = function() UpdateCurrentRoomESPs() end
}):AddColorPicker("ColorPicker7", {
Default = Color3.fromRGB(128, 255, 128),
Title = "Breaker Color",
Callback = function() UpdateCurrentRoomESPs() end
})
ESPBox:AddToggle('Gold', {
Text = "Gold",
Default = false,
Callback = function() UpdateCurrentRoomESPs() end
}):AddColorPicker("ColorPicker8", {
Default = Color3.fromRGB(255, 255, 0),
Title = "Gold Color",
Callback = function() UpdateCurrentRoomESPs() end
})
ESPBox:AddToggle('Entity', {
Text = "Entity",
Default = false,
Callback = function(Value)
if Value then
UpdateCurrentRoomESPs()
for _, v in ipairs(workspace:GetChildren()) do
AddGlobalEntityESP(v)
end
else
ClearGlobalEntityESPs()
UpdateCurrentRoomESPs()
end
end
}):AddColorPicker("ColorPicker9", {
Default = Color3.fromRGB(255, 0, 0),
Title = "Entity Color",
Callback = function()
if Toggles.Entity and Toggles.Entity.Value then
ClearGlobalEntityESPs()
UpdateCurrentRoomESPs()
end
end
})
ESPBox:AddToggle('Ladder', {
Text = "Ladder",
Default = false,
Callback = function() UpdateCurrentRoomESPs() end
}):AddColorPicker("ColorPicker10", {
Default = Color3.fromRGB(0, 0, 255),
Title = "Ladder Color",
Callback = function() UpdateCurrentRoomESPs() end
})
ESPBox:AddToggle('Fuse', {
Text = "Fuse",
Default = false,
Callback = function() UpdateCurrentRoomESPs() end
}):AddColorPicker("ColorPicker11", {
Default = Color3.fromRGB(255, 170, 0),
Title = "Fuse Color",
Callback = function() UpdateCurrentRoomESPs() end
})
local PlayerESPModule = {
CharConnections = {}
}
function PlayerESPModule:UpdatePlayerESP(player)
if not (Toggles.Player and Toggles.Player.Value) then
if player and player.Character then
ESPLibrary:RemoveESP(player.Character)
end
return
end
if not player or player == LocalPlayer then return end
local char = player.Character
if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
if hum and hum.Health > 0 then
local maxHp = math.max(hum.MaxHealth, 1)
local currentHp = math.clamp(hum.Health, 0, maxHp)
local hpPercent = math.floor((currentHp / maxHp) * 100)
local color = Options.ColorPicker99 and Options.ColorPicker99.Value or PlayerColor or Color3.fromRGB(255, 255, 255)
local text = string.format("%s [%d%%]", player.Name, hpPercent)
ESPLibrary:AddESP({
Object = char,
Text = text,
Color = color
})
else
ESPLibrary:RemoveESP(char)
end
end
function PlayerESPModule:ClearCharConnections(userId)
if self.CharConnections[userId] then
for _, conn in ipairs(self.CharConnections[userId]) do
if conn and conn.Connected then
conn:Disconnect()
end
end
self.CharConnections[userId] = nil
end
end
function PlayerESPModule:TrackCharacter(player, char)
if not player or player == LocalPlayer or not char then return end
local userId = player.UserId
self:ClearCharConnections(userId)
self.CharConnections[userId] = {}
local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
if hum then
local hpConn = hum.HealthChanged:Connect(function()
self:UpdatePlayerESP(player)
end)
local maxHpConn = hum:GetPropertyChangedSignal("MaxHealth"):Connect(function()
self:UpdatePlayerESP(player)
end)
table.insert(self.CharConnections[userId], hpConn)
table.insert(self.CharConnections[userId], maxHpConn)
end
self:UpdatePlayerESP(player)
end
function PlayerESPModule:TrackPlayer(player)
if not player or player == LocalPlayer then return end
if player.Character then
task.spawn(function()
self:TrackCharacter(player, player.Character)
end)
end
local charAddedConn = player.CharacterAdded:Connect(function(char)
self:TrackCharacter(player, char)
end)
local charRemovingConn = player.CharacterRemoving:Connect(function(char)
ESPLibrary:RemoveESP(char)
self:ClearCharConnections(player.UserId)
end)
table.insert(Connections, charAddedConn)
table.insert(Connections, charRemovingConn)
end
function PlayerESPModule:RefreshAll()
for _, player in ipairs(Players:GetPlayers()) do
if player ~= LocalPlayer then
self:UpdatePlayerESP(player)
end
end
end
function PlayerESPModule:Init()
table.insert(Connections, Players.PlayerAdded:Connect(function(player)
self:TrackPlayer(player)
end))
table.insert(Connections, Players.PlayerRemoving:Connect(function(player)
if player.Character then
ESPLibrary:RemoveESP(player.Character)
end
self:ClearCharConnections(player.UserId)
end))
for _, player in ipairs(Players:GetPlayers()) do
if player ~= LocalPlayer then
self:TrackPlayer(player)
end
end
end
ESPBox:AddToggle('Player', {
Text = "Player",
Default = false,
Callback = function() PlayerESPModule:RefreshAll() end
}):AddColorPicker("ColorPicker99", {
Default = Color3.fromRGB(255, 255, 255),
Title = "Player ESP Color",
Callback = function(Value)
PlayerColor = Value
PlayerESPModule:RefreshAll()
end,
})
PlayerESPModule:Init()
ESPSettings:AddToggle('ShowDistance', {
Text = "Show ESP Distance",
Default = true,
Callback = function(Value)
if ESPLibrary then ESPLibrary:SetShowDistance(Value) end
end
})
ESPSettings:AddToggle('ShowTracers', {
Text = "Show ESP Tracers",
Default = false,
Callback = function(Value)
if ESPLibrary then ESPLibrary:SetTracers(Value) end
end
})
ESPSettings:AddToggle('ShowRainbow', {
Text = "Show ESP Rainbow",
Default = false,
Callback = function(Value)
ESPLibrary:SetRainbow(Value)
end
})
ESPSettings:AddDropdown("SetESPMode", {
Text = "Set ESP Mode",
Values = {"Highlight/Text", "Text", "Highlight"},
Default = 1,
Callback = function(Value)
if ESPLibrary then ESPLibrary:SetESPMode(Value) end
end
})
ESPSettings:AddDropdown("SetFont", {
Text = "Set Font",
Values = {
"Legacy", "Arial", "ArialBold", "SourceSans", "SourceSansBold",
"SourceSansLight", "SourceSansItalic", "Bodoni", "Garamond",
"Cartoon", "Code", "Highway", "SciFi", "Arcade", "Fantasy",
"Antique", "Gotham", "GothamMedium", "GothamBold", "GothamBlack",
"AmaticSC", "Bangers", "Creepster", "DenkOne", "FredokaOne",
"IndieFlower", "LuckiestGuy", "Michroma", "Nunito", "Oswald",
"PatrickHand", "PermanentMarker", "Roboto", "RobotoCondensed",
"RobotoMono", "Sarpanch", "SpecialElite", "TitilliumWeb", "Ubuntu"
},
Default = "Legacy",
Callback = function(Value)
if ESPLibrary and ESPLibrary.SetFont then
ESPLibrary:SetFont(Value)
end
end
})
NotifyBox:AddDropdown("Notify", {
Values = { "Rush", "Ambush", "GlitchRush", "GlitchAmbush", "A-60", "A-120", "Eyes", "Blitz", "Lookman", "Jeff", "Screech" },
Default = 1,
Multi = true,
Text = "Choose to Notify",
Callback = function() end
})
NotifyBox:AddToggle('NotifySpawn', {
Text = "Notify Entity",
Default = false,
Tooltip = "Notify Entity On Spawn",
Callback = function(Value)
if Value then
for _, v in ipairs(workspace:GetChildren()) do
CheckAndNotifyEntity(v)
end
for _, v in ipairs(workspace.CurrentCamera:GetChildren()) do
CheckAndNotifyEntity(v)
end
end
end
})
HotelFloor:AddToggle('NotifyLibraryCode', {
Text = "Notify Library Code",
Default = false,
Disabled = Floor and Floor.Value ~= "Hotel" and Floor.Value ~= "Fools" or false,
Callback = function(Value)
if Value and LatestRoom and LatestRoom.Value == 50 then
local Code = GetLibraryCode()
if Code then Notify("Code: " .. Code, 5) end
end
end
})
HotelFloor:AddToggle('SeekObf', {
Text = "Anti Seek Obstacles",
Default = false,
Disabled = Floor and Floor.Value == "Retro" or false,
Callback = function(Value)
if workspace:FindFirstChild("CurrentRooms") then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "Seek_Arm" or v.Name == "ChandelierObstruction" then
for _, i in ipairs(v:GetChildren()) do
if i:IsA("BasePart") then
i.CanTouch = not Value
end
end
end
end
end
end
})
MinesFloor:AddToggle('DeleteFigureFE', {
Text = "Delete Figure (FE)",
Default = false,
Disabled = Floor and Floor.Value ~= "Mines" and RemotesFolder.Name ~= "Bricks" or false,
Callback = function(Value)
if Value then
table.clear(Figures)
if workspace:FindFirstChild("CurrentRooms") then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "FigureRig" or v.Name == "FigureRagdoll" then
table.insert(Figures, v)
end
end
end
else
table.clear(Figures)
end
end
})
MinesFloor:AddToggle('ShowPath', {
Text = "Show Seek Path",
Default = false,
Disabled = Floor and Floor.Value ~= "Mines" or false,
Callback = function(Value)
if Value then
if workspace:FindFirstChild("CurrentRooms") then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "SeekGuidingLight" then
ShowSeekPath(v)
end
end
end
else
if SeekPathFolder then SeekPathFolder:ClearAllChildren() end
end
end
})
MinesFloor:AddToggle('FixBrokenBridge', {
Text = "Fix Broken Bridge",
Default = false,
Disabled = Floor and Floor.Value ~= "Mines" or false,
Callback = function(Value)
if workspace:FindFirstChild("CurrentRooms") then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "Bridge" then
if Value then
FixBridge(v)
else
local barrier = v:FindFirstChild("BridgeBarrier")
if barrier then barrier:Destroy() end
end
end
end
end
end
})
MinesFloor:AddToggle('AutoMinecart', {
Text = "Auto Minecart",
Risky = true,
Default = false,
Disabled = Floor and Floor.Value ~= "Mines" or false,
Callback = function(Value)
if Value then
table.clear(DuckBoards)
table.clear(Nodes)
if workspace:FindFirstChild("CurrentRooms") then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "DuckBoard" then table.insert(DuckBoards, v) end
if string.find(v.Name, "MinecartNode") then table.insert(Nodes, v) end
end
end
else
if DefaultMoveControl then
pcall(function()
require(LocalPlayer.PlayerScripts.PlayerModule):GetControls().GetMoveVector = DefaultMoveControl
end)
end
table.clear(Nodes)
table.clear(DuckBoards)
end
end
})
MinesFloor:AddToggle('AutoAnchorSolver', {
Text = "Auto Anchor Solver",
Default = false,
Disabled = Floor and Floor.Value ~= "Mines" or false,
Callback = function(Value)
if Value then
table.clear(Anchors)
if workspace:FindFirstChild("CurrentRooms") then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "MinesAnchor" then table.insert(Anchors, v) end
end
end
else
table.clear(Anchors)
end
end
})
MinesFloor:AddToggle('AntiSeekFlood', {
Text = "Anti Seek Flood",
Default = false,
Disabled = Floor and Floor.Value ~= "Mines" or false,
Callback = function(Value)
if workspace:FindFirstChild("CurrentRooms") then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "SeekFloodline" then v.CanCollide = Value end
end
end
end
})
FoolsFloor:AddToggle('AntiBanana', {
Text = "Anti Banana",
Default = false,
Disabled = Floor and Floor.Value ~= "Fools" and RemotesFolder.Name ~= "Bricks" or false,
Callback = function(Value)
for _, v in ipairs(workspace:GetChildren()) do
if v.Name == "BananaPeel" then v.CanTouch = not Value end
end
end
})
FoolsFloor:AddToggle('AntiJeff', {
Text = "Anti Jeff",
Default = false,
Disabled = Floor and Floor.Value ~= "Fools" and RemotesFolder.Name ~= "Bricks" or false,
Callback = function(Value)
local jf = workspace:FindFirstChild("JeffTheKiller")
if jf then
for _, p in ipairs(jf:GetChildren()) do
if p:IsA("BasePart") then p.CanTouch = not Value end
end
if Value and jf:FindFirstChildOfClass("Humanoid") then
jf:FindFirstChildOfClass("Humanoid").Health = 0
end
end
end
})
FoolsFloor:AddToggle('InfRevive', {
Text = "Infinite Revive",
Default = false,
Disabled = Floor and Floor.Value ~= "Fools" and RemotesFolder.Name ~= "Bricks" or false,
Callback = function(Value)
if Value and LocalPlayer:GetAttribute("Alive") == false then
if RemotesFolder:FindFirstChild("Revive") then
RemotesFolder.Revive:FireServer()
end
end
end
})
FoolsFloor:AddToggle('DeleteSeekFE', {
Text = "Delete Seek (FE)",
Default = false,
Disabled = Floor and Floor.Value ~= "Fools" and RemotesFolder.Name ~= "Bricks" or false,
Callback = function(Value)
if Value and workspace:FindFirstChild("CurrentRooms") then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "TriggerEventCollision" then DeleteSeekFE(v) end
end
end
end
})
RoomsFloor:AddToggle('AutoRooms', {
Text = "Auto A-1000",
Default = false,
Disabled = Floor and Floor.Value ~= "Rooms" or false,
Callback = function(Value)
if not Value then
if PathFolder then PathFolder:ClearAllChildren() end
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
LocalPlayer.Character.Humanoid:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position)
end
end
end
})
RoomsFloor:AddToggle('IgnoreA60', {
Text = "Ignore A-60",
Default = false,
Disabled = Floor and Floor.Value ~= "Rooms" or false,
Callback = function() end
})
RetroFloor:AddToggle('AntiLava', {
Text = "Anti Lava",
Default = false,
Disabled = Floor and Floor.Value ~= "Retro" or false,
Callback = function(Value)
if workspace:FindFirstChild("CurrentRooms") then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "Lava" then v.CanTouch = not Value end
end
end
end
})
RetroFloor:AddToggle('AntiWall', {
Text = "Anti SeekWall",
Default = false,
Disabled = Floor and Floor.Value ~= "Retro" or false,
Callback = function(Value)
if workspace:FindFirstChild("CurrentRooms") then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "ScaryWall" then
for _, i in ipairs(v:GetChildren()) do
if i:IsA("BasePart") then i.CanTouch = not Value end
end
end
end
end
end
})
RetroFloor:AddToggle('RealBridge', {
Text = "Show Real Bridge",
Default = false,
Disabled = Floor and Floor.Value ~= "Retro" or false,
Callback = function(Value)
if workspace:FindFirstChild("CurrentRooms") then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "Bridge" and v.CanCollide == false then
v.Transparency = Value and 1 or 0
end
end
end
end
})
local MenuGroup = Tabs.Settings:AddLeftGroupbox('UI Settings')
local UtilityBox = Tabs.Settings:AddRightGroupbox('Hub Utilities')
local MenuPicker = MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
Default = "RightShift",
NoUI = true,
Text = "Menu keybind"
})
Library.ToggleKeybind = Options.MenuKeybind
function MenuPicker:OnClick()
local Event
Event = game:GetService("UserInputService").InputBegan:Connect(function(Input)
if Input.UserInputType ~= Enum.UserInputType.Keyboard then return end
local Key = Input.KeyCode.Name
if Key == "Escape" then
Event:Disconnect()
self:Update()
return
end
self.Value = Key
self.Modifiers = {}
Event:Disconnect()
self:Update()
if Library and Library.UpdateKeybinds then
Library:UpdateKeybinds()
end
end)
end
MenuGroup:AddToggle("ShowKeybinds", { Text = "Show Keybinds Overlay", Default = false }):OnChanged(function()
if Library.KeybindFrame then
Library.KeybindFrame.Visible = Toggles.ShowKeybinds.Value
end
end)
MenuGroup:AddToggle("ShowCustomCursor", { Text = "Custom Cursor", Default = true, Callback = function(Value) Library.ShowCustomCursor = Value end })
MenuGroup:AddDivider()
MenuGroup:AddToggle('PlayNotifySound', { Text = "Play Notification Sound", Default = true, Callback = function(Value) PlaySound = Value end })
MenuGroup:AddDropdown("NotificationSide", { Values = { "Left", "Right" }, Default = "Right", Text = "Notification Side", Callback = function(Value) Library:SetNotifySide(Value) end })
MenuGroup:AddButton('Test Notification', function() Notify("Hello World", 2) end)
MenuGroup:AddDropdown("Library", {
Values = { "Obsidian", "Linoria" },
Default = getgenv().ScriptLibrary,
Text = "Library",
Callback = function(Value)
getgenv().ScriptLibrary = tostring(Value)
Notify('Please Unload Script and Execute Again to Take Effect', 4)
end
})
MenuGroup:AddDropdown("RenderESPSpeed", {
Values = { "10", "30", "60", "90", "120", "144", "240" },
Default = Library.IsMobile and 2 or 6,
Text = "ESP Rendering Speed",
Callback = function(Value)
if ESPLibrary and ESPLibrary.SetRenderingSpeed then
ESPLibrary:SetRenderingSpeed(tonumber(Value))
end
end
})
MenuGroup:AddDivider()
MenuGroup:AddDropdown("DPIDropdown", {
Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
Default = "100%",
Text = "DPI Scale",
Callback = function(Value)
Value = Value:gsub("%%", "")
Library:SetDPIScale(tonumber(Value))
end
})
UtilityBox:AddLabel("AI Hub", true)
local function UnloadHubLogic()
for _, v in ipairs(workspace:GetChildren()) do
if v.Name == "BananaPeel" then
pcall(function() v.CanTouch = true end)
elseif v.Name == "JeffTheKiller" then
for _, p in ipairs(v:GetChildren()) do
if p:IsA("BasePart") then
pcall(function() p.CanTouch = true end)
end
end
end
end
if PathFolder then pcall(function() PathFolder:Destroy() end) end
if SeekPathFolder then pcall(function() SeekPathFolder:Destroy() end) end
table.clear(Figures)
table.clear(Anchors)
table.clear(DuckBoards)
table.clear(Nodes)
if DefaultMoveControl then
pcall(function()
require(LocalPlayer.PlayerScripts.PlayerModule):GetControls().GetMoveVector = DefaultMoveControl
end)
end
if workspace:FindFirstChild("CurrentRooms") then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "BridgeBarrier" then
pcall(function() v:Destroy() end)
end
end
end
for _, v in pairs(Closets) do
if ESPLibrary then ESPLibrary:RemoveESP(v) end
end
table.clear(Closets)
getgenv().FreecamCFrame = nil
if workspace.CurrentCamera then
workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end
end
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
LocalPlayer.Character.HumanoidRootPart.Anchored = false
end
if workspace.CurrentCamera then
workspace.CurrentCamera.FieldOfView = 70
end
pcall(function()
local mainUI = LocalPlayer.PlayerGui:FindFirstChild("MainUI")
local remoteListener = mainUI and mainUI.Initiator.Main_Game:FindFirstChild("RemoteListener")
if remoteListener then
for _, v in ipairs(remoteListener:GetChildren()) do
if v.Name == "Cutscenes_" then
v.Name = "Cutscenes"
end
end
end
end)
Lighting.Ambient = OriginalLighting.Ambient
Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
Lighting.Brightness = OriginalLighting.Brightness
Lighting.GlobalShadows = OriginalLighting.GlobalShadows
Lighting.FogEnd = OriginalLighting.FogEnd
local atm = Lighting:FindFirstChildOfClass("Atmosphere")
if atm and OriginalLighting.AtmosphereDensity then
atm.Density = OriginalLighting.AtmosphereDensity
end
local currentRoomsFolder = workspace:FindFirstChild("CurrentRooms")
if currentRoomsFolder then
for _, v in pairs(currentRoomsFolder:GetChildren()) do
if v:GetAttribute("OldAmbient") then
v:SetAttribute("Ambient", v:GetAttribute("OldAmbient"))
v:SetAttribute("OldAmbient", nil)
end
end
end
pcall(function() ClearAllDoorESP() end)
pcall(function() ClearAllObjectiveESP() end)
pcall(function() ClearCurrentRoomESPs() end)
pcall(function() ClearGlobalEntityESPs() end)
if workspace:FindFirstChild("CurrentRooms") then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "LiveHintBook" then
ESPLibrary:RemoveESP(v)
end
end
end
if ESPLibrary and type(ESPLibrary.Unload) == "function" then
pcall(function() ESPLibrary:Unload() end)
end
ResetPressed = false
if Connections and type(Connections) == "table" then
for i, con in pairs(Connections) do
if con and type(con.Disconnect) == "function" then
pcall(function() con:Disconnect() end)
elseif con and type(con) == "RBXScriptConnection" then
pcall(function() con:Disconnect() end)
end
end
table.clear(Connections)
end
if LocalPlayer and type(LocalPlayer) == "userdata" then
local Dread = LocalPlayer:FindFirstChild("Dread", true) or LocalPlayer:FindFirstChild("_Dread", true)
if Dread and Dread.Name then Dread.Name = "Dread" end
end
if ClientModules and type(ClientModules) == "userdata" then
local entityModules = ClientModules:FindFirstChild("EntityModules")
if entityModules then
local Shade = entityModules:FindFirstChild("Shade", true) or entityModules:FindFirstChild("_Shade", true)
if Shade and Shade.Name then Shade.Name = "Shade" end
end
end
if RemotesFolder and type(RemotesFolder) == "userdata" then
local crouch = RemotesFolder:FindFirstChild("Crouch")
if crouch and type(crouch.FireServer) == "function" then
pcall(function() crouch:FireServer(false, false) end)
end
end
if FakeA90 and type(FakeA90) == "userdata" then pcall(function() FakeA90:Destroy() end) FakeA90 = nil end
if FakeScreech and type(FakeScreech) == "userdata" then pcall(function() FakeScreech:Destroy() end) FakeScreech = nil end
if ReplicatedStorage and type(ReplicatedStorage) == "userdata" then
local screech = ReplicatedStorage:FindFirstChild("Screech")
if screech and RemotesFolder then pcall(function() screech.Parent = RemotesFolder end) end
local a90 = ReplicatedStorage:FindFirstChild("A90")
if a90 and RemotesFolder then pcall(function() a90.Parent = RemotesFolder end) end
local surgeRemote = ReplicatedStorage:FindFirstChild("SurgeRemote")
if surgeRemote and RemotesFolder then pcall(function() surgeRemote.Parent = RemotesFolder end) end
pcall(function()
local soundService = game:GetService("SoundService")
local mainSound = soundService:FindFirstChild("Main")
if mainSound and mainSound:FindFirstChild("Jamming") then
mainSound.Jamming.Enabled = IsJamminModifierActive()
end
end)
end
if RemotesFolder and type(RemotesFolder) == "userdata" then
local a90_ = RemotesFolder:FindFirstChild("A90_")
if a90_ then pcall(function() a90_.Name = "A90" end) end
local screech_ = RemotesFolder:FindFirstChild("Screech_")
if screech_ then pcall(function() screech_.Name = "Screech" end) end
end
if Surge and type(Surge) == "userdata" then pcall(function() Surge:Destroy() end) Surge = nil end
if LocalPlayer and type(LocalPlayer) == "userdata" then
local char = LocalPlayer.Character
if char and type(char) == "userdata" then
local humanoid = char:FindFirstChild("Humanoid")
local hrp = char:FindFirstChild("HumanoidRootPart")
if humanoid and type(humanoid) == "userdata" then
pcall(function()
humanoid.WalkSpeed = OriginalWalkSpeed
char:SetAttribute("CanJump", false)
if humanoid:FindFirstChild("Root") and humanoid.Root:IsA("Motor6D") then
pcall(function() humanoid.Root.C1 = CFrame.new(0, 0, 0) end)
end
humanoid.HipHeight = 2.4
end)
end
for _, v in pairs(char:GetChildren()) do
if v and type(v) == "userdata" and v:IsA("BasePart") and v.Name ~= "CollisionClone" then
pcall(function() v.CanCollide = true end)
end
end
if OldAccel and hrp then
pcall(function()
hrp.CustomPhysicalProperties = OldAccel
OldAccel = nil
end)
end
if hrp then
local flightVel = hrp:FindFirstChild("FlightVelocity")
if flightVel then pcall(function() flightVel:Destroy() end) end
local velocityMani = hrp:FindFirstChild("VelocityMani")
if velocityMani then pcall(function() velocityMani:Destroy() end) end
end
ManipulationNoClipForced = false
local collision = char:FindFirstChild("Collision")
if collision and hrp then
pcall(function() collision.Position = hrp.Position end)
end
end
end
for _, v in ipairs(workspace:GetDescendants()) do
if v and type(v) == "userdata" and v:IsA("ProximityPrompt") then
pcall(function()
local duration = v:GetAttribute("Duration")
if duration then v.HoldDuration = duration end
end)
end
end
if SaveManager and type(SaveManager) == "table" and type(SaveManager.Save) == "function" then
pcall(function() SaveManager:Save("AIHub/DOORS") end)
end
if Library and type(Library) == "table" and type(Library.Unload) == "function" then
pcall(function() Library:Unload() end)
end
for userId in pairs(PlayerESPModule.CharConnections) do
PlayerESPModule:ClearCharConnections(userId)
end
getgenv().Toggles = nil
getgenv().Options = nil
getgenv().Library = nil
getgenv().Window = nil
getgenv().ScriptLibrary = nil
getgenv().Connections = nil
getgenv().AIHubUnload = nil
end
getgenv().AIHubUnload = UnloadHubLogic
UtilityBox:AddButton({
Text = "Unload Hub",
Func = function()
UnloadHubLogic()
end
})
local HttpService = game:GetService("HttpService")
local KeybindPosFile = "AIHub/DOORS/keybinds_pos.json"
local function SaveKeybindPosition()
if Library and Library.KeybindFrame and writefile then
pcall(function()
local pos = Library.KeybindFrame.Position
local data = {
XScale = pos.X.Scale,
XOffset = pos.X.Offset,
YScale = pos.Y.Scale,
YOffset = pos.Y.Offset
}
writefile(KeybindPosFile, HttpService:JSONEncode(data))
end)
end
end
local function LoadKeybindPosition()
if Library and Library.KeybindFrame and readfile and isfile and isfile(KeybindPosFile) then
pcall(function()
local data = HttpService:JSONDecode(readfile(KeybindPosFile))
if data and data.XScale then
Library.KeybindFrame.Position = UDim2.new(data.XScale, data.XOffset, data.YScale, data.YOffset)
end
end)
end
end
task.spawn(function()
task.wait(0.5)
LoadKeybindPosition()
end)
if Library and Library.KeybindFrame then
Library.KeybindFrame.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
SaveKeybindPosition()
end
end)
end
pcall(function()
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'})
ThemeManager:SetFolder("AIHUB")
SaveManager:SetFolder("AIHUB/DOORS")
SaveManager:BuildConfigSection(Tabs['Settings'])
ThemeManager:ApplyToTab(Tabs['Settings'])
end)
Notify("Successfully Loaded ///", 4)
