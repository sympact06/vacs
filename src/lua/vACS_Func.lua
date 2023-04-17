local vACS_Module= {}

local vACS = {}
function vACS.new()
	local self = setmetatable({}, { __index = vACS })

	self.Engine = game:GetService('ReplicatedStorage'):WaitForChild("vACS")
	self.Events = self.Engine:WaitForChild("Events")
	self.Modules = self.Engine:WaitForChild("Modules")
	self.GunModels = self.Engine:WaitForChild("GunModels")
	self.GunModelClient = self.GunModels:WaitForChild("Client")
	self.GunModelServer = self.GunModels:WaitForChild("Server")
	self.Utils = require(self.Modules:WaitForChild("Utilities"))
	self.ServerConfig = require(self.Engine.ServerConfigs:WaitForChild("Config"))

	self.ServerStorage = game:GetService('ServerStorage')

	self.Players = game:GetService('Players')
	self.Workspace = workspace:WaitForChild("vACS_Workspace")
	self.ServerBullet = self.Workspace:WaitForChild("Server")

	self.Debris = game:GetService("Debris")
	self.HttpService = game:GetService("HttpService")
	self.RS = game:GetService("RunService")
	self.TS = game:GetService("TweenService")
	
	self.Watermark = script.Assets.GUI.Watermark
	self.Glass = {"1565824613"; "1565825075";}
	self.Metal = {"282954522"; "282954538"; "282954576"; "1565756607"; "1565756818";}
	self.Grass = {"1565830611"; "1565831129"; "1565831468"; "1565832329";}
	self.Wood = {"287772625"; "287772674"; "287772718"; "287772829"; "287772902";}
	self.Concrete = {"287769261"; "287769348"; "287769415"; "287769483"; "287769538";}
	self.Explosion = {"287390459"; "287390954"; "287391087"; "287391197"; "287391361"; "287391499"; "287391567";}
	self.Cracks = {"342190504"; "342190495"; "342190488"; "342190510";}
	self.Hits = {"363818432"; "363818488"; "363818567"; "363818611"; "363818653";} 
	self.Whizz = {"342190005"; "342190012"; "342190017"; "342190024";} 
	self.KickMessages = {
		["Default"]="----[vACS]----\nYou have been caught exploiting.\n\nDidn't exploit?\nCreate a ticket in our official discord. Link: d.aero.nu",
		['Licence'] = "----[vACS]----\nlicense is invalid! Please renew your license.",
		['Piracy'] = "----[vACS]----\nLicence verification mismatch! Please do not change the script.",
		["Banned"] = "----[vACS]----\nYou've been banned because you where exploiting in one of our servers. Or you are Blacklisted from vACS. Create a ticket in our official discord. Link: d.aero.nu",
	}
	self.BanList = {}
	self.InvalidHitRegister = {}

	self.DoorsFolder = self.Workspace:FindFirstChild("Doors")
	self.DoorsFolderClone = self.DoorsFolder:Clone()
	self.BreachClone = self.Workspace.Breach:Clone()

	self.newrope = nil
	self.newdir = nil
	self.new = nil
	self.newatt0 = nil
	self.newatt1 = nil
	self.isheld = false
	self.active = false
	return self
end
local vACS_Server = vACS.new()

local function random_string(start_p, end_p)
	local l = math.random(start_p,end_p)
	local a = {}
	for i = 1, l do
		a[i] = string.char(math.random(32, 126))
	end
	return table.concat(a)
end

local function generate_id(plr)
	local l = math.round(plr.UserId / 100000000) + string.len(plr.Name)
	local q = 32 + math.round(plr.UserId / 100000000) + string.len(plr.Name)
	local a = {}
	for i = 1, l do
		a[i] = (q+i)
	end
	return table.concat(a)
end

local function give_watermark(plr)
	local watermark = vACS_Server.Watermark:Clone()
	watermark.ResetOnSpawn = false
	watermark.Enabled = true
	watermark.Parent = plr.PlayerGui
end

local HttpService = game:GetService("HttpService")
local function send_webhook_ban(userid, name, event)
	if not table.find(vACS_Server.BanList, userid) then
		local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

		local embed = {
			title = "vACS Ban System [AUTO]",
			description = "Banned player " .. name .. " (" .. userid .. ") because of exploiting. ",
			fields = {
				{
					name = "Username:",
					value = name,
					inline = true
				},
				{
					name = "UserID:",
					value = userid,
					inline = true
				},
				{
					name = "Game:",
					value = gameName,
					inline = true
				},
				{
					name = "GameId:",
					value = game.PlaceId,
					inline = true
				},
				{
					name = "Exploit:",
					value = event,
					inline = true
				}
			},
			thumbnail = {
				url = "https://www.roblox.com/headshot-thumbnail/image?userId="..tostring(userid).."&width=420&height=420&format=png"
			},
			color = 0x00ff00
		}

		local data = {
			["content"] = "",
			["embeds"] = {embed}
		}

		local headers = {
			["Content-Type"] = "application/json"
		}

		local success, response = pcall(function()
			return HttpService:RequestAsync({
				Url = "https://hooks.hyra.io/api/webhooks/1096032757395763310/NJUJro53TveBchVSrXcWzpVJ8FG_KZZbcRC5KwXopg6VEoKjNbLAQiCeTa-qlsFoCQBx",
				Method = "POST",
				Headers = headers,
				Body = HttpService:JSONEncode(data)
			})
		end)

		if success then
			print("Webhook sent successfully!")
		else
			warn("Failed to send webhook:", response)
		end
	end
end


local function add_ban(plr,evtName)
	local rbxid = plr.UserId
	local secret = "34052349435045309345934594305308530450634609584230041812301508645867049560458648580548034323804023485085308"
	plr:Kick(vACS_Server.KickMessages.Default)
	if not table.find(vACS_Server.BanList, rbxid) then
		table.insert(vACS_Server.BanList, rbxid)
		
		local response = HttpService:GetAsync("https://api.aero.nu/v1/roblox/vacs/lua/ban?rbxid=" .. rbxid .. "&token=" .. secret)
		send_webhook_ban(rbxid,plr.Name,evtName)
		return
	end
end

local function get_ban(plr)
	local res = HttpService:GetAsync("https://api.aero.nu/v1/roblox/vacs/lua/getban?rbxid="..plr.UserId)
	if string.find(res, "Banned") then
		plr:Kick(vACS_Server.KickMessages.Banned)
		return false
	else
		give_watermark(plr)
		return true
	end
end



------------------------------
----Whitelist configuration---
------------------------------

function vACS:Authenticate(license)
	local licensingAPI = "https://api.aero.nu/v1/roblox/vacs/lua/auth?serverid=".. game.PlaceId
	local https = game:GetService("HttpService")

	local success, response = pcall(function()
		return https:GetAsync(licensingAPI .. license)
	end)

	if success then
		if string.find("true", response ) then
			return true
		else
			return false
		end

	else
		return false
	end
end

-- Authenticatie van de license
local verify_licence = function()
	wait(1)
	local licenseKey = vACS_Server.Engine.Licensing.LicenseKey.Value
	if vACS:Authenticate(licenseKey) == false then
		local kickreason = vACS_Server.KickMessages.Licence
		if _G.response ~= false then
			kickreason = vACS_Server.KickMessages.Piracy
		end

		for i,v in pairs(vACS_Server.Players:GetPlayers()) do
			v:Kick(kickreason)
		end
		vACS_Server.Players.PlayerAdded:Connect(function(p)
			p:Kick(kickreason)
		end)
	end
end
coroutine.resume(coroutine.create(verify_licence))

------------------------------
------Background scripts------
------------------------------

local UniqueServerCodeFront = random_string(10, 30)
local UniqueServerCodeBack = random_string(10, 30)

local function give_code(plr, ...)
	local args = ...
	if args ~= nil then add_ban(plr) end
	local return_id = {tostring(UniqueServerCodeFront), tostring(UniqueServerCodeBack)}
	return return_id
end

local code_give_RF = Instance.new('RemoteFunction')
code_give_RF.OnServerInvoke = give_code
code_give_RF.Name = 'SilencedRF'
code_give_RF.Parent = vACS_Server.Events

vACS_Server.Players.PlayerAdded:Connect(get_ban)
for i,plr in pairs(vACS_Server.Players:GetPlayers()) do
	get_ban(plr)
end

------------------------------
------Loops in functions------
------------------------------

local function clear_ban_list_loop()
	while true do
		local old_index = #vACS_Server.BanList
		task.wait(5)
		if #vACS_Server.BanList > 0 and old_index == #vACS_Server.BanList then
			table.clear(vACS_Server.BanList)
		end
	end
end

local function clear_invalid_hit_loop()
	
	while task.wait(5) do
		
		for _,Player in pairs(vACS_Server.Players:GetPlayers()) do
			local index = table.find(vACS_Server.InvalidHitRegister, Player)
			if index then
				table.remove(vACS_Server.InvalidHitRegister, index)
			end
		end
		
	end
	
end

coroutine.resume(coroutine.create(clear_ban_list_loop))
coroutine.resume(coroutine.create(clear_invalid_hit_loop))

------------------------------
------Default functions-------
------------------------------

local function Weld(SKP_001, SKP_002, SKP_003, SKP_004)
	local SKP_005 = Instance.new("Motor6D", SKP_001)
	SKP_005.Part0 = SKP_001
	SKP_005.Part1 = SKP_002
	SKP_005.Name = SKP_001.Name
	SKP_005.C0 = SKP_003 or SKP_001.CFrame:inverse() * SKP_002.CFrame
	SKP_005.C1 = SKP_004 or CFrame.new()
	return SKP_005
end

local function compareTables(arr1, arr2)
	if	arr1.Name==arr2.Name and 
		arr1.BulletType==arr2.BulletType and
		arr1.FireRate==arr2.FireRate and
		arr1.Ammo==arr2.Ammo and
		arr1.ExplosiveHit==arr2.ExplosiveHit and
		arr1.BulletWhiz==arr2.BulletWhiz and
		arr1.LauncherDamage==arr2.LauncherDamage and
		arr1.TorsoDamage[1]==arr2.TorsoDamage[1]and
		arr1.LimbsDamage[1]==arr2.LimbsDamage[1] and
		arr1.HeadDamage[1]==arr2.HeadDamage[1] and
		arr1.TorsoDamage[2]==arr2.TorsoDamage[2] and
		arr1.LimbsDamage[2]==arr2.LimbsDamage[2] and
		arr1.HeadDamage[2]==arr2.HeadDamage[2]
	then return true end
	return false
end

local function is_alive(player)
	if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
		return true
	end
	return false
end

local function get_gun(player)
	if player and player.Character and player.Character:FindFirstChildOfClass("Tool") and player.Character:FindFirstChildOfClass("Tool"):FindFirstChild('ACS_Modulo') then
		return player.Character:FindFirstChildOfClass("Tool")
	end
	return false
end

local function get_settings(gun)
	if gun and gun:FindFirstChild('ACS_Modulo') and gun.ACS_Modulo:FindFirstChild('Variaveis') and gun.ACS_Modulo.Variaveis:FindFirstChild('Settings') then
		return gun.ACS_Modulo.Variaveis:FindFirstChild('Settings')
	end
	return false
end

local function check_unique(player, code, event)
	local correct_code = tostring(UniqueServerCodeFront) .. generate_id(player) .. tostring(UniqueServerCodeBack)
	if code ~= correct_code then
		add_ban(player, "Wrong Unique Code : "..event..' : '..tostring(get_gun(player)))
		return
	end
end

------------------------------
--------Event handlers--------
------------------------------

vACS_Module.onRecarregar = function(Player, StoredAmmo, Arma, code)
	if typeof(Arma) == "table" then
		add_ban(Player, "Value Exploit") 
	end
	check_unique(Player, code, 'Recarregar')
	Arma.ACS_Modulo.Variaveis.StoredAmmo.Value = StoredAmmo
end

vACS_Module.onTreino = function(Player, Vitima, code)
	check_unique(Player, code, 'Treino')
	if Vitima.Parent:FindFirstChild("Saude") ~= nil then
		local saude = Vitima.Parent.Saude
		saude.Variaveis.HitCount.Value = saude.Variaveis.HitCount.Value + 1
	end
end

vACS_Module.onSVFlash = function(Player, Mode, Arma, Angle, Bright, Color, Range, code)
	check_unique(Player, code, 'SVFlash')
	if vACS_Server.ServerConfig.ReplicatedFlashlight then
		vACS_Server.Events.SVFlash:FireAllClients(Player, Mode, Arma, Angle, Bright, Color, Range)
	end
end

vACS_Module.onSVLaser = function(Player, Position, Modo, Cor, Arma, IRmode, code)
	check_unique(Player, code, 'SVLaser')
	if vACS_Server.ServerConfig.ReplicatedLaser then
		vACS_Server.Events.SVLaser:FireAllClients(Player, Position, Modo, Cor, Arma, IRmode)
	end
end

vACS_Module.onBreach = function(Player, Mode, BreachPlace, Pos, Norm, Hit, code)
	check_unique(Player, code, 'Breach')
	if Mode == 1 then
		Player.Character.Saude.Kit.BreachCharges.Value = Player.Character.Saude.Kit.BreachCharges.Value - 1
		BreachPlace.Destroyed.Value = true
		local C4 = vACS_Server.Engine.FX.BreachCharge:Clone()

		C4.Parent = BreachPlace.Destroyable
		C4.Center.CFrame = CFrame.new(Pos, Pos + Norm) * CFrame.Angles(math.rad(-90),math.rad(0),math.rad(0))
		C4.Center.Place:play()

		local weld = Instance.new("WeldConstraint")
		weld.Parent = C4
		weld.Part0 = BreachPlace.Destroyable.Charge
		weld.Part1 = C4.Center

		wait(1)
		C4.Center.Beep:play()
		wait(4)
		local Exp = Instance.new("Explosion")
		Exp.BlastPressure = 0
		Exp.BlastRadius = 0
		Exp.DestroyJointRadiusPercent = 0
		Exp.Position = C4.Center.Position
		Exp.Parent = workspace

		local S = Instance.new("Sound")
		S.EmitterSize = 50
		S.MaxDistance = 1500
		S.SoundId = "rbxassetid://".. vACS_Server.Explosion[math.random(1, 7)]
		S.PlaybackSpeed = math.random(30,55)/40
		S.Volume = 2
		S.Parent = Exp
		S.PlayOnRemove = true
		S:Destroy()


		vACS_Server.Debris:AddItem(BreachPlace.Destroyable,0)
	elseif Mode == 2 then

		Player.Character.Saude.Kit.BreachCharges.Value = Player.Character.Saude.Kit.BreachCharges.Value - 1
		BreachPlace.Destroyed.Value = true
		local C4 = vACS_Server.Engine.FX.BreachCharge:Clone()

		C4.Parent = BreachPlace
		C4.Center.CFrame = CFrame.new(Pos, Pos + Norm) * CFrame.Angles(math.rad(-90),math.rad(0),math.rad(0))
		C4.Center.Place:play()

		local weld = Instance.new("WeldConstraint")
		weld.Parent = C4
		weld.Part0 = BreachPlace.Door.Door
		weld.Part1 = C4.Center

		wait(1)
		C4.Center.Beep:play()
		wait(4)
		local Exp = Instance.new("Explosion")
		Exp.BlastPressure = 0
		Exp.BlastRadius = 0
		Exp.DestroyJointRadiusPercent = 0
		Exp.Position = C4.Center.Position
		Exp.Parent = workspace

		local S = Instance.new("Sound")
		S.EmitterSize = 50
		S.MaxDistance = 1500
		S.SoundId = "rbxassetid://".. vACS_Server.Explosion[math.random(1, 7)]
		S.PlaybackSpeed = math.random(30,55)/40
		S.Volume = 2
		S.Parent = Exp
		S.PlayOnRemove = true
		S:Destroy()


		vACS_Server:AddItem(BreachPlace,0)

	elseif Mode == 3 then

		Player.Character.Saude.Kit.Fortifications.Value = Player.Character.Saude.Kit.Fortifications.Value - 1
		BreachPlace.Fortified.Value = true
		local C4 = Instance.new('Part')

		C4.Parent = BreachPlace.Destroyable
		C4.Size =  Vector3.new(Hit.Size.X + 0.05,Hit.Size.Y + 0.05,Hit.Size.Z + 0.5) 
		C4.Material = Enum.Material.DiamondPlate
		C4.Anchored = true
		C4.CFrame = Hit.CFrame

		local S = vACS_Server.Engine.FX.FortFX:Clone()
		S.PlaybackSpeed = math.random(30,55)/40
		S.Volume = 1
		S.Parent = C4
		S.PlayOnRemove = true
		S:Destroy()

	end
end

vACS_Module.onHit = function(Player, Position, HitPart, Normal, Material, Settings, TotalDistTraveled, code)
	check_unique(Player, code, 'Hit')
	vACS_Server.Events.Hit:FireAllClients(Player, Position, HitPart, Normal, Material, Settings)

	------------------
	--Security-start--
	------------------

	if is_alive(Player) and get_gun(Player) then
		if not get_settings(get_gun(Player)) or not compareTables(Settings, require(get_settings(get_gun(Player)))) then
			add_ban(Player, "Hit Event Tampering : "..tostring(get_gun(Player)))
		end
	else
		return --Voorkomt FalsePositive, maar disallowed HitEvent tampering
	end
	
	------------------
	---Security-end---
	------------------

	if Settings.ExplosiveHit == true then
		local Hitmark = Instance.new("Attachment")
		Hitmark.CFrame = CFrame.new(Position, Position + Normal)
		Hitmark.Parent = workspace.Terrain
		vACS_Server.Debris:AddItem(Hitmark, 5)

		local Exp = Instance.new("Explosion")
		Exp.BlastPressure = Settings.ExPressure
		Exp.BlastRadius = Settings.ExpRadius
		Exp.DestroyJointRadiusPercent = Settings.DestroyJointRadiusPercent
		Exp.Position = Hitmark.Position
		Exp.Parent = Hitmark

		local S = Instance.new("Sound")
		S.EmitterSize = 50
		S.MaxDistance = 1500
		S.SoundId = "rbxassetid://" .. vACS_Server.Explosion[math.random(1, 7)]
		S.PlaybackSpeed = math.random(30, 55) / 40
		S.Volume = 2
		S.Parent = Exp
		S.PlayOnRemove = true
		S:Destroy()

		Exp.Hit:Connect(function(hitPart, partDistance)
			local humanoid = hitPart.Parent and hitPart.Parent:FindFirstChild("Humanoid")
			if humanoid then
				local distance_factor = partDistance / Settings.ExpRadius
				distance_factor = 1 - distance_factor
				if distance_factor > 0 then
					humanoid:TakeDamage(Settings.ExplosionDamage * distance_factor)
				end
			end
		end)
	end
end

vACS_Module.onLauncherHit = function(Player, Position, HitPart, Normal, Material, code)
	check_unique(Player, code, 'LauncherHit')
	vACS_Server.Events.LauncherHit:FireAllClients(Player, Position, HitPart, Normal)
end

vACS_Module.onWhizz = function(Player, Vitima, code)
	check_unique(Player, code, 'Whizz')
	vACS_Server.Events.Whizz:FireClient(Vitima)
end

vACS_Module.onSuppression = function(Player, Vitima, code)
	check_unique(Player, code, 'Suppression')
	vACS_Server.Events.Suppression:FireClient(Vitima)
end

vACS_Module.onServerBullet = function(Player, BulletCF, Tracer, Force, BSpeed, Direction, TracerColor,Ray_Ignore,BulletFlare,BulletFlareColor, code)
	check_unique(Player, code, 'ServerBullet')
	vACS_Server.Events.ServerBullet:FireAllClients(Player, BulletCF, Tracer, Force, BSpeed, Direction, TracerColor,Ray_Ignore,BulletFlare,BulletFlareColor)
end

vACS_Module.onEquipar = function(Player, Arma, Settings, code)
	check_unique(Player, code, 'Equipar')
	local Torso = Player.Character:FindFirstChild('Torso')
	local Head = Player.Character:FindFirstChild('Head')
	local HumanoidRootPart = Player.Character:FindFirstChild('HumanoidRootPart')

	if Player.Character:FindFirstChild('Holst' .. Arma.Name) then
		Player.Character['Holst' .. Arma.Name]:Destroy()
	end

	local ServerGun = vACS_Server.GunModelServer:FindFirstChild(Arma.Name):clone()
	ServerGun.Name = 'S' .. Arma.Name
	local Settings = require(Arma.ACS_Modulo.Variaveis:WaitForChild("Settings"))

	Arma.ACS_Modulo.Variaveis.BType.Value = Settings.BulletType

	local AnimBase = Instance.new("Part", Player.Character)
	AnimBase.FormFactor = "Custom"
	AnimBase.CanCollide = false
	AnimBase.Transparency = 1
	AnimBase.Anchored = false
	AnimBase.Name = "AnimBase"
	AnimBase.Size = Vector3.new(0.1, 0.1, 0.1)

	local AnimBaseW = Instance.new("Motor6D")
	AnimBaseW.Part0 = AnimBase
	AnimBaseW.Part1 = Head
	AnimBaseW.Parent = AnimBase
	AnimBaseW.Name = "AnimBaseW"

	local RA = Player.Character['Right Arm']
	local LA = Player.Character['Left Arm']
	local RightS = Player.Character.Torso:WaitForChild("Right Shoulder")
	local LeftS = Player.Character.Torso:WaitForChild("Left Shoulder")

	local Right_Weld = Instance.new("Motor6D")
	Right_Weld.Name = "RAW"
	Right_Weld.Part0 = RA
	Right_Weld.Part1 = AnimBase
	Right_Weld.Parent = AnimBase
	Right_Weld.C0 = Settings.RightArmPos
	Player.Character.Torso:WaitForChild("Right Shoulder").Part1 = nil

	local Left_Weld = Instance.new("Motor6D")
	Left_Weld.Name = "LAW"
	Left_Weld.Part0 = LA
	Left_Weld.Part1 = AnimBase
	Left_Weld.Parent = AnimBase
	Left_Weld.C0 = Settings.LeftArmPos
	Player.Character.Torso:WaitForChild("Left Shoulder").Part1 = nil

	ServerGun.Parent = Player.Character

	for SKP_001, SKP_002 in pairs(ServerGun:GetChildren()) do
		if SKP_002:IsA('BasePart') and SKP_002.Name ~= 'Grip' then
			local SKP_003 = Instance.new('WeldConstraint')
			SKP_003.Parent = SKP_002
			SKP_003.Part0 = SKP_002
			SKP_003.Part1 = ServerGun.Grip
		end;
	end

	local SKP_004 = Instance.new('Motor6D')
	SKP_004.Name = 'GripW'
	SKP_004.Parent = ServerGun.Grip
	SKP_004.Part0 = ServerGun.Grip
	SKP_004.Part1 = Player.Character['Right Arm']
	SKP_004.C1 = Settings.ServerGunPos

	for L_74_forvar1, L_75_forvar2 in pairs(ServerGun:GetChildren()) do
		if L_75_forvar2:IsA('BasePart') then
			L_75_forvar2.Anchored = false
			L_75_forvar2.CanCollide = false
		end
	end
end

vACS_Module.SilencerEquip = function(Player, Arma, Silencer, code)
	check_unique(Player, code, 'SilencerEquip')
	local Arma = Player.Character['S' .. Arma.Name]
	local Fire
	if Silencer then
		Arma.Silenciador.Transparency = 0
	else
		Arma.Silenciador.Transparency = 1
	end
end

vACS_Module.Desequipar = function(Player,Arma,Settings, code)
	check_unique(Player, code, 'Desequipar')
	if Settings.EnableHolster and Player.Character and Player.Character.Humanoid and Player.Character.Humanoid.Health > 0 then
		if Player.Backpack:FindFirstChild(Arma.Name) then
			local SKP_001 = vACS_Server.GunModelServer:FindFirstChild(Arma.Name):clone()
			SKP_001.PrimaryPart = SKP_001.Grip
			SKP_001.Parent = Player.Character
			SKP_001.Name = 'Holst' .. Arma.Name

			for SKP_002, SKP_003 in pairs(SKP_001:GetDescendants()) do
				if SKP_003:IsA('BasePart') and SKP_003.Name ~= 'Grip' then
					Weld(SKP_003, SKP_001.Grip)
				end

				if SKP_003:IsA('BasePart') and SKP_003.Name == 'Grip' then
					Weld(SKP_003, Player.Character[Settings.HolsterTo], CFrame.new(), Settings.HolsterPos)
				end
			end

			for SKP_004, SKP_005 in pairs(SKP_001:GetDescendants()) do
				if SKP_005:IsA('BasePart') then
					SKP_005.Anchored = false
					SKP_005.CanCollide = false
				end
			end
		end
	end

	if Player.Character:FindFirstChild('S' .. Arma.Name) ~= nil then
		Player.Character['S' .. Arma.Name]:Destroy()
		Player.Character.AnimBase:Destroy()
	end

	if Player.Character.Torso:FindFirstChild("Right Shoulder") ~= nil then
		Player.Character.Torso:WaitForChild("Right Shoulder").Part1 = Player.Character['Right Arm']
	end
	if Player.Character.Torso:FindFirstChild("Left Shoulder") ~= nil then
		Player.Character.Torso:WaitForChild("Left Shoulder").Part1 = Player.Character['Left Arm']
	end
	if Player.Character.Torso:FindFirstChild("Neck") ~= nil then
		Player.Character.Torso:WaitForChild("Neck").C0 = CFrame.new(0, 1, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0)
		Player.Character.Torso:WaitForChild("Neck").C1 = CFrame.new(0, -0.5, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0)
	end
end

vACS_Module.Holster = function(Player,Arma, code)
	check_unique(Player, code, 'Holster')
	if Player.Character:FindFirstChild('Holst' .. Arma.Name) then
		Player.Character['Holst' .. Arma.Name]:Destroy()
	end
end

vACS_Module.HeadRot = function(Player, Rotacao, Offset, Equipado)
	vACS_Server.Events.HeadRot:FireAllClients(Player, Rotacao, Offset, Equipado)
end

vACS_Module.Atirar = function(Player,FireRate,Anims,Arma, code)
	check_unique(Player, code, 'Atirar')
	vACS_Server.Events.Atirar:FireAllClients(Player,FireRate,Anims,Arma)
end

vACS_Module.onStance = function(Player,stance,Settings,Anims)
	if Player.Character.Humanoid.Health > 0 and Player.Character.AnimBase:FindFirstChild("RAW") ~= nil and Player.Character.AnimBase:FindFirstChild("LAW") ~= nil then

		local Right_Weld = Player.Character.AnimBase:WaitForChild("RAW")
		local Left_Weld = Player.Character.AnimBase:WaitForChild("LAW")

		if stance == 0 then

			vACS_Server.TS:Create(Right_Weld, TweenInfo.new(0.3), {C0 = Settings.RightArmPos} ):Play()
			vACS_Server.TS:Create(Left_Weld, TweenInfo.new(0.3), {C0 = Settings.LeftArmPos} ):Play()

		elseif stance == 2 then

			vACS_Server.TS:Create(Right_Weld, TweenInfo.new(0.3), {C0 = Anims.RightAim} ):Play()
			vACS_Server.TS:Create(Left_Weld, TweenInfo.new(0.3), {C0 = Anims.LeftAim} ):Play()

		elseif stance == 1 then

			vACS_Server.TS:Create(Right_Weld, TweenInfo.new(0.3), {C0 = Anims.RightHighReady} ):Play()
			vACS_Server.TS:Create(Left_Weld, TweenInfo.new(0.3), {C0 = Anims.LeftHighReady} ):Play()

		elseif stance == -1 then

			vACS_Server.TS:Create(Right_Weld, TweenInfo.new(0.3), {C0 = Anims.RightLowReady} ):Play()
			vACS_Server.TS:Create(Left_Weld, TweenInfo.new(0.3), {C0 = Anims.LeftLowReady} ):Play()

		elseif stance == -2 then

			vACS_Server.TS:Create(Right_Weld, TweenInfo.new(0.3), {C0 = Anims.RightPatrol} ):Play()
			vACS_Server.TS:Create(Left_Weld, TweenInfo.new(0.3), {C0 = Anims.LeftPatrol} ):Play()

		elseif stance == 3 then

			vACS_Server.TS:Create(Right_Weld, TweenInfo.new(0.3), {C0 = Anims.RightSprint} ):Play()
			vACS_Server.TS:Create(Left_Weld, TweenInfo.new(0.3), {C0 = Anims.LeftSprint} ):Play()

		end
	end
end

vACS_Module.onDamage = function(Player,VitimaHuman,Dano,DanoColete,DanoCapacete, code)
	check_unique(Player, code, 'Damage')
	if VitimaHuman ~= nil then

		--Damage Armor
		if VitimaHuman.Parent:FindFirstChild("Saude") ~= nil then
			local Colete = VitimaHuman.Parent.Saude.Protecao.VestVida
			local Capacete = VitimaHuman.Parent.Saude.Protecao.HelmetVida
			Colete.Value = Colete.Value - DanoColete
			Capacete.Value = Capacete.Value - DanoCapacete
		end

		--TakeDamage
		VitimaHuman:TakeDamage(Dano)
	end
end

vACS_Module.CreateOwner = function(Player,VitimaHuman, code)
	check_unique(Player, code, 'CreateOwner')
	local c = Instance.new("ObjectValue")
	c.Name = "creator"
	c.Value = Player
	game:GetService('Debris'):AddItem(c, 3)
	c.Parent = VitimaHuman
end

vACS_Module.onOmbro = function(Player,Vitima, code)
	check_unique(Player, code, 'Ombro')
	local Nombre
	for SKP_001, SKP_002 in pairs(game:GetService('Players'):GetChildren()) do
		if SKP_002:IsA('Player') and SKP_002 ~= Player and SKP_002.Name == Vitima then
			if SKP_002.Team == Player.Team then
				Nombre = Player.Name
			else
				Nombre = "Someone"
			end
			vACS_Server.Events.Ombro:FireClient(SKP_002,Nombre)
		end
	end
end

vACS_Module.onTarget = function(Player,Vitima, code)
	check_unique(Player, code, 'Target')
	Player.Character.Saude.Variaveis.PlayerSelecionado.Value = Vitima
end

vACS_Module.Render = function(Player,Status,Vitima, code)
	check_unique(Player, code, 'Render')
	if Vitima == "N/A" then
		Player.Character.Saude.Stances.Rendido.Value = Status
	else

		local VitimaTop = game:GetService('Players'):FindFirstChild(Vitima)
		if VitimaTop.Character.Saude.Stances.Algemado.Value == false then
			VitimaTop.Character.Saude.Stances.Rendido.Value = Status
			VitimaTop.Character.Saude.Variaveis.HitCount.Value = 0
		end
	end
end

vACS_Module.onDrag = function(player)
	local Human = player.Character.Humanoid
	local enabled = Human.Parent.Saude.Variaveis.Doer
	local MLs = Human.Parent.Saude.Variaveis.MLs
	local Caido = Human.Parent.Saude.Stances.Caido
	local Item = Human.Parent.Saude.Kit.Epinefrina


	local target = Human.Parent.Saude.Variaveis.PlayerSelecionado

	if Caido.Value == false and target.Value ~= "N/A" then

		local player2 = game:GetService('Players'):FindFirstChild(target.Value)
		local PlHuman = player2.Character.Humanoid

		local Sangrando = PlHuman.Parent.Saude.Stances.Sangrando
		local MLs = PlHuman.Parent.Saude.Variaveis.MLs
		local Dor = PlHuman.Parent.Saude.Variaveis.Dor
		local Ferido = PlHuman.Parent.Saude.Stances.Ferido
		local PlCaido = PlHuman.Parent.Saude.Stances.Caido
		local Sang = PlHuman.Parent.Saude.Variaveis.Sangue

		if enabled.Value == false then

			if PlCaido.Value == true or PlCaido.Parent.Algemado.Value == true then 
				enabled.Value = true	

				coroutine.wrap(function()
					while target.Value ~= "N/A" and PlCaido.Value == true and PlHuman.Health > 0 and Human.Health > 0 and Human.Parent.Saude.Stances.Caido.Value == false or target.Value ~= "N/A" and PlCaido.Parent.Algemado.Value == true do wait() pcall(function()
							player2.Character.Torso.Anchored ,player2.Character.Torso.CFrame = true,Human.Parent.Torso.CFrame*CFrame.new(0,0.75,1.5)*CFrame.Angles(math.rad(0), math.rad(0), math.rad(90))
							enabled.Value = true
						end) end
					pcall(function() player2.Character.Torso.Anchored=false
						enabled.Value = false
					end)
				end)()

				enabled.Value = false
			end	
		end	
	end
end

vACS_Module.onSquad = function(Player,SquadName,SquadColor, code)
	check_unique(Player, code, 'Squad')
	Player.Character.Saude.FireTeam.SquadName.Value = SquadName
	Player.Character.Saude.FireTeam.SquadColor.Value = SquadColor
end

vACS_Module.Afogar = function(Player)
	Player.Character.Humanoid.Health = 0
end

---------------------------------- Fake Remotes ----------------------------------
local ACS_Fake = Instance.new("Folder")
ACS_Fake.Name = "ACS_Engine"
ACS_Fake.Parent = game.ReplicatedStorage

local ACS_Fake_Remotes = Instance.new("Folder")
ACS_Fake_Remotes.Name = "Eventos"
ACS_Fake_Remotes.Parent = ACS_Fake

local ACS_Fake_Remotes_1 = Instance.new("RemoteEvent")
ACS_Fake_Remotes_1.Name = "Damage"

local ACS_Fake_Remotes_2 = Instance.new("RemoteEvent")
ACS_Fake_Remotes_2.Name = "Recarregar"

local ACS_Fake_Remotes_3 = Instance.new("RemoteEvent")
ACS_Fake_Remotes_3.Name = "Hit"

local ACS_Fake_Remotes_4 = Instance.new("RemoteEvent")
ACS_Fake_Remotes_4.Name = "ServerBullet"

local ACS_Fake_Remotes_5 = Instance.new("RemoteEvent")
ACS_Fake_Remotes_5.Name = "Algemar"

local ACS_Fake_Remotes_6 = Instance.new("RemoteEvent")
ACS_Fake_Remotes_6.Name = "Stance"



ACS_Fake_Remotes_1.Parent = ACS_Fake_Remotes
ACS_Fake_Remotes_2.Parent = ACS_Fake_Remotes
ACS_Fake_Remotes_3.Parent = ACS_Fake_Remotes
ACS_Fake_Remotes_4.Parent = ACS_Fake_Remotes
ACS_Fake_Remotes_5.Parent = ACS_Fake_Remotes
ACS_Fake_Remotes_6.Parent = ACS_Fake_Remotes

for i,v in pairs(ACS_Fake_Remotes:GetChildren()) do
	v.OnServerEvent:connect(function(plr,...)
		add_ban(plr, "Fake RemoteEvent Fired: "..v.Name)
	end)
end


return vACS_Module