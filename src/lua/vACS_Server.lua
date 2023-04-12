local vACS = {}

function vACS.new()
	local self = setmetatable({}, { __index = vACS })

	self.Engine = game:GetService('ReplicatedStorage'):WaitForChild("vACS")
	self.Events = self.Engine:WaitForChild("Events")
	self.Modules = self.Engine:WaitForChild("Modules")
	self.GunModels = self.Engine:WaitForChild("GunModels")
	self.GunModelClient = self.GunModels:WaitForChild("Client")
	self.GunModelServer = self.GunModels:WaitForChild("Server")
	self.RequestModule = _G.request or _G.resend or require
	self.vACSFunctions = self.RequestModule(script["Parent"].vACS_Func)
	self.Utils = self.RequestModule(self.Modules:WaitForChild("Utilities"))
	self.ServerConfig = self.RequestModule(self.Engine.ServerConfigs:WaitForChild("Config"))

	self.ServerStorage = game:GetService('ServerStorage')

	self.Players = game:GetService('Players')
	self.Workspace = workspace:WaitForChild("vACS_Workspace")
	self.ServerBullet = self.Workspace:WaitForChild("Server")

	self.Debris = game:GetService("Debris")

	self.RS = game:GetService("RunService")
	self.TS = game:GetService("TweenService")

	self.Glass = {"1565824613"; "1565825075";}
	self.Metal = {"282954522"; "282954538"; "282954576"; "1565756607"; "1565756818";}
	self.Grass = {"1565830611"; "1565831129"; "1565831468"; "1565832329";}
	self.Wood = {"287772625"; "287772674"; "287772718"; "287772829"; "287772902";}
	self.Concrete = {"287769261"; "287769348"; "287769415"; "287769483"; "287769538";}
	self.Explosion = {"287390459"; "287390954"; "287391087"; "287391197"; "287391361"; "287391499"; "287391567";}
	self.Cracks = {"342190504"; "342190495"; "342190488"; "342190510";}
	self.Hits = {"363818432"; "363818488"; "363818567"; "363818611"; "363818653";} 
	self.Whizz = {"342190005"; "342190012"; "342190017"; "342190024";} 

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

local vACS_MedSys = {}

function vACS_MedSys:new()
	local obj = {}
	obj.TS = vACS_Server.TS
	setmetatable(obj, self)
	self.__index = self
	return obj
end

vACS_MedSys = vACS_MedSys:new()

function vACS:GenIndexStateType(a)
	local b = ""
	local c = string.reverse(a)
	local d = string.rep(c, 2)
	local e =
		string.gsub(
			d,
			"%a",
			function(f)
				return string.char(string.byte(f) + 1)
			end
		)
	local g = string.upper(e)
	local h = string.sub(g, 2, -2)
	for i = 1, #h do
		local j = string.sub(h, i, i)
		if j == "A" or j == "E" or j == "I" or j == "O" or j == "U" then
			local k = string.char(math.random(98, 122))
			b = b .. k
		else
			b = b .. j
		end
	end
	return string.reverse(b)
end

function vACS:AddPlayer(player)
	player.CharacterAppearanceLoaded:Connect(function(character)
		for _, essential in pairs(vACS_Server.Engine.Essential:GetChildren()) do
			if essential then
				local clone = essential:Clone()
				clone.Parent = player.PlayerGui
				clone.Disabled = false
			end
		end

		if player.Character:FindFirstChild('Head') then
			vACS_Server.Events.TeamTag:FireAllClients(player, character)
		end
	end)

	player.Changed:Connect(function(property)
		if property == "TeamColor" or property == "Neutral" then
			vACS_Server.Events.TeamTag:FireAllClients(player)
		end
	end)
end

function vACS:addDefaults(a)
	local b = ""
	local c = {}
	for d = 1, #a do
		table.insert(c, math.random(1, #c + 1), string.sub(a, d, d))
	end
	local e = table.concat(c)
	for d = 1, #e do
		local f = string.sub(e, d, d)
		if f:match("%a") then
			local g = math.random(1, 25)
			local h = string.char((string.byte(f) - 97 + g) % 26 + 97)
			b = b .. h
		else
			b = b .. f
		end
	end
	return string.reverse(b)
end

function vACS:ListenForPlayers()
	vACS_Server.Players.PlayerAdded:Connect(function(player)
		vACS:AddPlayer(player)
	end)
end

function vACS:CMakeMedic(evtName)
	local evt = Instance.new("RemoteEvent")
	evt.Name = evtName
	evt.Parent = vACS_Server.Events.MedSys
	return evt
end

function vACS:CMake(evtName)
	local evt = Instance.new("RemoteEvent")
	evt.Name = evtName
	evt.Parent = vACS_Server.Events
	return evt
end

function vACS:LoadMedicEvent(Event, Function)
	vACS:CMakeMedic(Event)
	vACS_Server.Events.MedSys[Event].OnServerEvent:Connect(function(...)
		Function(vACS_Server.Events.MedSys[Event], ...)
	end)
end

function vACS:LoadEvent(Event, Function)
	vACS:CMake(Event)
	vACS_Server.Events[Event].OnServerEvent:Connect(Function)
end

function Weld(SKP_001, SKP_002, SKP_003, SKP_004)
	local SKP_005 = Instance.new("Motor6D", SKP_001)
	SKP_005.Part0 = SKP_001
	SKP_005.Part1 = SKP_002
	SKP_005.Name = SKP_001.Name
	SKP_005.C0 = SKP_003 or SKP_001.CFrame:inverse() * SKP_002.CFrame
	SKP_005.C1 = SKP_004 or CFrame.new()
	return SKP_005
end

function vACS:RenderDefaults(a)
	local b = ""
	local c = 355221
	local d = 21231
	local e = 6773334
	local f = 32351
	local g = 343535
	local h = (c + d * e - f / g) % 100
	local i = math.floor(math.sqrt(h)) + 1
	for j = 1, i do
		local k = (j * h + c) * d - e / f + g
		local l = 0
		for m = 1, j do
			l = l + m * k / (m + 1)
		end
		local n = l / j
		if n % 2 == 0 then
			b = b .. string.char(n % 26 + 97)
		else
			b = b .. string.char(n % 26 + 65)
		end
	end
	return b
end

local function onDoor(Player,Door,Mode,Key)
	if Mode == 1 then
		if Door.Locked.Value == true then
			if Door:FindFirstChild("RequiresKey") then
				local Character = Player.Character
				if Character:FindFirstChild(Key) ~= nil or Player.Backpack:FindFirstChild(Key) ~= nil then
					if Door.Locked.Value == true then
						Door.Locked.Value = false
					end
					vACS:ToggleDoor(Door)
				end	
			end
		else
			vACS:ToggleDoor(Door)
		end
	elseif Mode == 2 then
		if Door.Locked.Value == false then
			vACS:ToggleDoor(Door)
		end
	elseif Mode == 3 then
		if Door:FindFirstChild("RequiresKey") then
			local Character = Player.Character
			Key = Door.RequiresKey.Value
			if Character:FindFirstChild(Key) ~= nil or Player.Backpack:FindFirstChild(Key) ~= nil then
				if Door.Locked.Value == true then
					Door.Locked.Value = false
				else
					Door.Locked.Value = true
				end
			end
		end
	elseif Mode == 4 then
		if Door.Locked.Value == true then
			Door.Locked.Value = false
		end
	end
end

function vACS_MedSys:onCompress(player)
	local Human = player.Character.Humanoid
	local enabled = Human.Parent.Saude.Variaveis.Doer
	local MLs = Human.Parent.Saude.Variaveis.MLs
	local Caido = Human.Parent.Saude.Stances.Caido

	if enabled.Value == false and Caido.Value == false then

		if MLs.Value >= 2 then 
			enabled.Value = true

			wait(.3)		

			MLs.Value = 1

			wait(5)
			enabled.Value = false

		end	
	end
end

function vACS_MedSys:onBandage(player)
	local Human = player.Character.Humanoid
	local enabled = Human.Parent.Saude.Variaveis.Doer
	local Sangrando = Human.Parent.Saude.Stances.Sangrando
	local MLs = Human.Parent.Saude.Variaveis.MLs
	local Caido = Human.Parent.Saude.Stances.Caido
	local Ferido = Human.Parent.Saude.Stances.Ferido

	local Bandagens = Human.Parent.Saude.Kit.Bandagem

	if enabled.Value == false and Caido.Value == false  then

		if Bandagens.Value >= 1 and Sangrando.Value == true then 
			enabled.Value = true

			wait(.3)		

			Sangrando.Value = false
			Bandagens.Value = Bandagens.Value - 1 


			wait(2)
			enabled.Value = false

		end	
	end	
end

function vACS_MedSys:onSplint(player)
	local Human = player.Character.Humanoid
	local enabled = Human.Parent.Saude.Variaveis.Doer
	local Sangrando = Human.Parent.Saude.Stances.Sangrando
	local MLs = Human.Parent.Saude.Variaveis.MLs
	local Caido = Human.Parent.Saude.Stances.Caido
	local Ferido = Human.Parent.Saude.Stances.Ferido

	local Bandagens = Human.Parent.Saude.Kit.Splint

	if enabled.Value == false and Caido.Value == false  then

		if Bandagens.Value >= 1 and Ferido.Value == true  then 
			enabled.Value = true

			wait(.3)		

			Ferido.Value = false 

			Bandagens.Value = Bandagens.Value - 1 


			wait(2)
			enabled.Value = false

		end	
	end	
end

function vACS_MedSys:TookPainKiller(player)
	local Human = player.Character.Humanoid
	local enabled = Human.Parent.Saude.Variaveis.Doer
	local Sangrando = Human.Parent.Saude.Stances.Sangrando
	local MLs = Human.Parent.Saude.Variaveis.MLs
	local Dor = Human.Parent.Saude.Variaveis.Dor
	local Caido = Human.Parent.Saude.Stances.Caido
	local Ferido = Human.Parent.Saude.Stances.Ferido

	local Bandagens = Human.Parent.Saude.Kit.Aspirina

	if enabled.Value == false and Caido.Value == false  then

		if Bandagens.Value >= 1  and Dor.Value >= 1  then
			enabled.Value = true

			wait(.3)		

			Dor.Value = Dor.Value - math.random(60,75)

			Bandagens.Value = Bandagens.Value - 1 


			wait(2)
			enabled.Value = false

		end	
	end	
end

function vACS_MedSys:Energetic(player)
	local Human = player.Character.Humanoid
	local enabled = Human.Parent.Saude.Variaveis.Doer
	local Sangrando = Human.Parent.Saude.Stances.Sangrando
	local MLs = Human.Parent.Saude.Variaveis.MLs
	local Dor = Human.Parent.Saude.Variaveis.Dor
	local Caido = Human.Parent.Saude.Stances.Caido
	local Ferido = Human.Parent.Saude.Stances.Ferido

	local Bandagens = Human.Parent.Saude.Kit.Energetico

	if enabled.Value == false and Caido.Value == false  then

		if Human.Health < Human.MaxHealth  then
			enabled.Value = true

			wait(.3)		

			Human.Health = Human.Health + (Human.MaxHealth/3)
			Bandagens.Value = Bandagens.Value - 1


			wait(2)
			enabled.Value = false

		end	
	end	
end

function vACS_MedSys:onTourniquet(player)
	local Human = player.Character.Humanoid
	local enabled = Human.Parent.Saude.Variaveis.Doer
	local Sangrando = Human.Parent.Saude.Stances.Sangrando
	local MLs = Human.Parent.Saude.Variaveis.MLs
	local Dor = Human.Parent.Saude.Variaveis.Dor
	local Caido = Human.Parent.Saude.Stances.Caido
	local Ferido = Human.Parent.Saude.Stances.Ferido

	local Bandagens = Human.Parent.Saude.Kit.Tourniquet

	if Human.Parent.Saude.Stances.Tourniquet.Value == false then
		if enabled.Value == false and Sangrando.Value == true and Bandagens.Value > 0 then
			enabled.Value = true

			wait(.3)		

			Human.Parent.Saude.Stances.Tourniquet.Value = true
			Bandagens.Value = Bandagens.Value - 1


			wait(2)
			enabled.Value = false

		end	
	else
		if enabled.Value == false then
			enabled.Value = true

			wait(.3)		

			Human.Parent.Saude.Stances.Tourniquet.Value = false
			Bandagens.Value = Bandagens.Value + 1


			wait(2)
			enabled.Value = false
		end
	end
end

function vACS_MedSys:Compress_Multi(player)
	local Human = player.Character.Humanoid
	local enabled = Human.Parent.Saude.Variaveis.Doer
	local MLs = Human.Parent.Saude.Variaveis.MLs
	local Caido = Human.Parent.Saude.Stances.Caido

	local target = Human.Parent.Saude.Variaveis.PlayerSelecionado

	if Caido.Value == false and target.Value ~= "N/A" then

		local player2 = game:GetService('Players'):FindFirstChild(target.Value)
		local PlHuman = player2.Character.Humanoid


		local Sangrando = PlHuman.Parent.Saude.Stances.Sangrando
		local MLs = PlHuman.Parent.Saude.Variaveis.MLs
		local Dor = PlHuman.Parent.Saude.Variaveis.Dor

		if enabled.Value == false then

			if MLs.Value > 1 then 
				enabled.Value = true

				wait(.3)		

				MLs.Value = MLs.Value - math.random(50,75)

				wait(5)
				enabled.Value = false
			end	

		end	
	end
end

function vACS_MedSys:Bandage_Multi(player)
	local Human = player.Character.Humanoid
	local enabled = Human.Parent.Saude.Variaveis.Doer
	local MLs = Human.Parent.Saude.Variaveis.MLs
	local Caido = Human.Parent.Saude.Stances.Caido
	local Item = Human.Parent.Saude.Kit.Bandagem

	local target = Human.Parent.Saude.Variaveis.PlayerSelecionado

	if Caido.Value == false and target.Value ~= "N/A" then

		local player2 = game:GetService('Players'):FindFirstChild(target.Value)
		local PlHuman = player2.Character.Humanoid


		local Sangrando = PlHuman.Parent.Saude.Stances.Sangrando
		local MLs = PlHuman.Parent.Saude.Variaveis.MLs
		local Dor = PlHuman.Parent.Saude.Variaveis.Dor
		local Ferido = PlHuman.Parent.Saude.Stances.Ferido

		if enabled.Value == false then

			if Item.Value >= 1 and Sangrando.Value == true then 
				enabled.Value = true

				wait(.3)		

				Sangrando.Value = false	
				Item.Value = Item.Value - 1 


				wait(2)
				enabled.Value = false
			end	

		end	
	end
end

function vACS_MedSys:onSplint_Multi(player)
	local Human = player.Character.Humanoid
	local enabled = Human.Parent.Saude.Variaveis.Doer
	local MLs = Human.Parent.Saude.Variaveis.MLs
	local Caido = Human.Parent.Saude.Stances.Caido
	local Item = Human.Parent.Saude.Kit.Splint

	local target = Human.Parent.Saude.Variaveis.PlayerSelecionado

	if Caido.Value == false and target.Value ~= "N/A" then

		local player2 = game:GetService('Players'):FindFirstChild(target.Value)
		local PlHuman = player2.Character.Humanoid


		local Sangrando = PlHuman.Parent.Saude.Stances.Sangrando
		local MLs = PlHuman.Parent.Saude.Variaveis.MLs
		local Dor = PlHuman.Parent.Saude.Variaveis.Dor
		local Ferido = PlHuman.Parent.Saude.Stances.Ferido

		if enabled.Value == false then

			if Item.Value >= 1 and Ferido.Value == true  then 
				enabled.Value = true

				wait(.3)		

				Ferido.Value = false		

				Item.Value = Item.Value - 1 


				wait(2)
				enabled.Value = false
			end	

		end	
	end
end

function vACS_MedSys:onTourniquet_Multi(player)
	local Human = player.Character.Humanoid
	local enabled = Human.Parent.Saude.Variaveis.Doer
	local MLs = Human.Parent.Saude.Variaveis.MLs
	local Caido = Human.Parent.Saude.Stances.Caido
	local Item = Human.Parent.Saude.Kit.Tourniquet

	local target = Human.Parent.Saude.Variaveis.PlayerSelecionado

	if Caido.Value == false and target.Value ~= "N/A" then

		local player2 = game:GetService('Players'):FindFirstChild(target.Value)
		local PlHuman = player2.Character.Humanoid


		local Sangrando = PlHuman.Parent.Saude.Stances.Sangrando
		local MLs = PlHuman.Parent.Saude.Variaveis.MLs
		local Dor = PlHuman.Parent.Saude.Variaveis.Dor
		local Ferido = PlHuman.Parent.Saude.Stances.Ferido


		if PlHuman.Parent.Saude.Stances.Tourniquet.Value == false then

			if enabled.Value == false then
				if Item.Value > 0 and Sangrando.Value == true then 
					enabled.Value = true

					wait(.3)		

					PlHuman.Parent.Saude.Stances.Tourniquet.Value = true		

					Item.Value = Item.Value - 1 


					wait(2)
					enabled.Value = false
				end
			end	
		else
			if enabled.Value == false then
				if PlHuman.Parent.Saude.Stances.Tourniquet.Value == true then 
					enabled.Value = true

					wait(.3)		

					PlHuman.Parent.Saude.Stances.Tourniquet.Value = false		

					Item.Value = Item.Value + 1 


					wait(2)
					enabled.Value = false
				end
			end	
		end
	end
end

function vACS_MedSys:Epinephrine_Multi(player)
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

		if enabled.Value == false then

			if Item.Value >= 1 and PlCaido.Value == true then 
				enabled.Value = true


				wait(.3)		

				if Dor.Value > 0 then
					Dor.Value = Dor.Value + math.random(10,20)
				end

				if Sangrando.Value == true then
					MLs.Value = MLs.Value + math.random(10,35)
				end

				PlCaido.Value = false		

				Item.Value = Item.Value - 1 


				wait(2)
				enabled.Value = false
			end	

		end	
	end
end

function vACS_MedSys:DaddyItookTooMuchMorphine(player)
	local Human = player.Character.Humanoid
	local enabled = Human.Parent.Saude.Variaveis.Doer
	local MLs = Human.Parent.Saude.Variaveis.MLs
	local Caido = Human.Parent.Saude.Stances.Caido
	local Item = Human.Parent.Saude.Kit.Morfina

	local target = Human.Parent.Saude.Variaveis.PlayerSelecionado

	if Caido.Value == false and target.Value ~= "N/A" then

		local player2 = game:GetService('Players'):FindFirstChild(target.Value)
		local PlHuman = player2.Character.Humanoid


		local Sangrando = PlHuman.Parent.Saude.Stances.Sangrando
		local MLs = PlHuman.Parent.Saude.Variaveis.MLs
		local Dor = PlHuman.Parent.Saude.Variaveis.Dor
		local Ferido = PlHuman.Parent.Saude.Stances.Ferido
		local PlCaido = PlHuman.Parent.Saude.Stances.Caido

		if enabled.Value == false then

			if Item.Value >= 1 and Dor.Value >= 1 then 
				enabled.Value = true

				wait(.3)		

				Dor.Value = Dor.Value - math.random(100,150)

				Item.Value = Item.Value - 1 


				wait(2)
				enabled.Value = false
			end	

		end	
	end
end

function vACS_MedSys:BloodBag_Multi(player)
	local Human = player.Character.Humanoid
	local enabled = Human.Parent.Saude.Variaveis.Doer
	local MLs = Human.Parent.Saude.Variaveis.MLs
	local Caido = Human.Parent.Saude.Stances.Caido
	local Item = Human.Parent.Saude.Kit.SacoDeSangue

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

			if Item.Value >= 1 and Sangrando.Value == false and Sang.Value < 7000 then 
				enabled.Value = true

				wait(.3)		

				Sang.Value = Sang.MaxValue

				Item.Value = Item.Value - 1 


				wait(2)
				enabled.Value = false
			end	

		end	
	end
end

function vACS_MedSys:Collapse(player)
	local Human = player.Character.Humanoid
	local Dor = Human.Parent.Saude.Variaveis.Dor
	local Sangue = Human.Parent.Saude.Variaveis.Sangue
	local IsWounded = Human.Parent.Saude.Stances.Caido


	if (Sangue.Value <= 3500) or (Dor.Value >= 200)  or (IsWounded.Value == true) then -- Man this Guy's Really wounded,
		IsWounded.Value = true
		Human.PlatformStand = true
		Human.AutoRotate = false	
	elseif (Sangue.Value > 3500) and (Dor.Value < 200) and (IsWounded.Value == false) then -- YAY A MEDIC ARRIVED! =D
		Human.PlatformStand = false
		IsWounded.Value = false
		Human.AutoRotate = true	

	end
end

function vACS_MedSys:onReset(player)
	local Human = player.Character.Humanoid
	local target = Human.Parent.Saude.Variaveis.PlayerSelecionado

	target.Value = "N/A"
end

function vACS_MedSys:onStance(Player, L_97_arg2, Virar, Rendido)

	local char		= Player.Character
	local Torso		= char:WaitForChild("Torso")
	local Saude 	= char:WaitForChild("Saude")

	if char.Humanoid.Health > 0 then

		local RootPart 	= char:WaitForChild("HumanoidRootPart")
		local RootJoint = RootPart:WaitForChild("RootJoint")
		local Neck 		= char["Torso"]:WaitForChild("Neck")
		local RS 		= char["Torso"]:WaitForChild("Right Shoulder")
		local LS 		= char["Torso"]:WaitForChild("Left Shoulder")
		local RH 		= char["Torso"]:WaitForChild("Right Hip")
		local LH 		= char["Torso"]:WaitForChild("Left Hip")
		local LeftLeg 	= char["Left Leg"]
		local RightLeg 	= char["Right Leg"]
		local Proned2

		RootJoint.C1 	= CFrame.new()

		if L_97_arg2 == 2 and char then

			vACS_Server.TS:Create(RootJoint, TweenInfo.new(.3), {C0 = CFrame.new(0,-2.5,1.35)* CFrame.Angles(math.rad(-90),0,math.rad(0))} ):Play()
			vACS_Server.TS:Create(RH, TweenInfo.new(.3), {C0 = CFrame.new(1,-1,0)* CFrame.Angles(math.rad(-0),math.rad(90),math.rad(0))} ):Play()
			vACS_Server.TS:Create(LH, TweenInfo.new(.3), {C0 = CFrame.new(-1,-1,0)* CFrame.Angles(math.rad(-0),math.rad(-90),math.rad(0))} ):Play()
			vACS_Server.TS:Create(RS, TweenInfo.new(.3), {C0 = CFrame.new(0.9,1.1,0)* CFrame.Angles(math.rad(-180),math.rad(90),math.rad(0))} ):Play()
			vACS_Server.TS:Create(LS, TweenInfo.new(.3), {C0 = CFrame.new(-0.9,1.1,0)* CFrame.Angles(math.rad(-180),math.rad(-90),math.rad(0))} ):Play()
			--vACS_Server.TS:Create(Neck,	TweenInfo.new(.3), {C0 = CFrame.new(0,1.25,0)* CFrame.Angles(math.rad(0),math.rad(0),math.rad(180))} ):Play()


		elseif L_97_arg2 == 1 and char then

			vACS_Server.TS:Create(RootJoint, TweenInfo.new(.3), {C0 = CFrame.new(0,-1,0.25)* CFrame.Angles(math.rad(-10),0,math.rad(0))} ):Play()
			vACS_Server.TS:Create(RH, TweenInfo.new(.3), {C0 = CFrame.new(1,-0.35,-0.65)* CFrame.Angles(math.rad(-20),math.rad(90),math.rad(0))} ):Play()
			vACS_Server.TS:Create(LH, TweenInfo.new(.3), {C0 = CFrame.new(-1,-1.25,-0.625)* CFrame.Angles(math.rad(-60),math.rad(-90),math.rad(0))} ):Play()
			vACS_Server.TS:Create(RS, TweenInfo.new(.3), {C0 = CFrame.new(1,0.5,0)* CFrame.Angles(math.rad(0),math.rad(90),math.rad(0))} ):Play()
			vACS_Server.TS:Create(LS, TweenInfo.new(.3), {C0 = CFrame.new(-1,0.5,0)* CFrame.Angles(math.rad(0),math.rad(-90),math.rad(0))} ):Play()
			--vACS_Server.TS:Create(Neck,	TweenInfo.new(.3), {C0 = CFrame.new(0,1,0)* CFrame.Angles(math.rad(-80),math.rad(0),math.rad(180))} ):Play()

		elseif L_97_arg2 == 0 and char then	

			vACS_Server.TS:Create(RootJoint, TweenInfo.new(.3), {C0 = CFrame.new(0,0,0)* CFrame.Angles(math.rad(-0),0,math.rad(0))} ):Play()
			vACS_Server.TS:Create(RH, TweenInfo.new(.3), {C0 = CFrame.new(1,-1,0)* CFrame.Angles(math.rad(-0),math.rad(90),math.rad(0))} ):Play()
			vACS_Server.TS:Create(LH, TweenInfo.new(.3), {C0 = CFrame.new(-1,-1,0)* CFrame.Angles(math.rad(-0),math.rad(-90),math.rad(0))} ):Play()
			vACS_Server.TS:Create(RS, TweenInfo.new(.3), {C0 = CFrame.new(1,0.5,0)* CFrame.Angles(math.rad(0),math.rad(90),math.rad(0))} ):Play()
			vACS_Server.TS:Create(LS, TweenInfo.new(.3), {C0 = CFrame.new(-1,0.5,0)* CFrame.Angles(math.rad(0),math.rad(-90),math.rad(0))} ):Play()
			--vACS_Server.TS:Create(Neck,	TweenInfo.new(.3), {C0 = CFrame.new(0,1,0)* CFrame.Angles(math.rad(-90),math.rad(0),math.rad(180))} ):Play()
		end
		if Virar == 1 then
			if L_97_arg2 == 0 then
				vACS_Server.TS:Create(RootJoint, TweenInfo.new(.3), {C0 = CFrame.new(1,0,0) * CFrame.Angles(math.rad(0),0,math.rad(-30))} ):Play()
				vACS_Server.TS:Create(RH, TweenInfo.new(.3), {C0 = CFrame.new(1,-1,0)* CFrame.Angles(math.rad(0),math.rad(90),math.rad(0))} ):Play()
				vACS_Server.TS:Create(LH, TweenInfo.new(.3), {C0 = CFrame.new(-1,-1,0)* CFrame.Angles(math.rad(0),math.rad(-90),math.rad(0))} ):Play()
				vACS_Server.TS:Create(RS, TweenInfo.new(.3), {C0 = CFrame.new(1,0.5,0)* CFrame.Angles(math.rad(0),math.rad(90),math.rad(0))} ):Play()
				vACS_Server.TS:Create(LS, TweenInfo.new(.3), {C0 = CFrame.new(-1,0.5,0)* CFrame.Angles(math.rad(0),math.rad(-90),math.rad(0))} ):Play()
				--vACS_Server.TS:Create(Neck,	TweenInfo.new(.3), {C0 = CFrame.new(0,1,0)* CFrame.Angles(math.rad(-90),math.rad(0),math.rad(180))} ):Play()
			elseif L_97_arg2 == 1 then
				vACS_Server.TS:Create(RootJoint, TweenInfo.new(.3), {C0 = CFrame.new(1,-1,0.25)* CFrame.Angles(math.rad(-10),0,math.rad(-30))} ):Play()
				vACS_Server.TS:Create(RH, TweenInfo.new(.3), {C0 = CFrame.new(1,-0.35,-0.65)* CFrame.Angles(math.rad(-20),math.rad(90),math.rad(0))} ):Play()
				vACS_Server.TS:Create(LH, TweenInfo.new(.3), {C0 = CFrame.new(-1,-1.25,-0.625)* CFrame.Angles(math.rad(-60),math.rad(-90),math.rad(0))} ):Play()
				vACS_Server.TS:Create(RS, TweenInfo.new(.3), {C0 = CFrame.new(1,0.5,0)* CFrame.Angles(math.rad(0),math.rad(90),math.rad(0))} ):Play()
				vACS_Server.TS:Create(LS, TweenInfo.new(.3), {C0 = CFrame.new(-1,0.5,0)* CFrame.Angles(math.rad(0),math.rad(-90),math.rad(0))} ):Play()
				--vACS_Server.TS:Create(Neck,	TweenInfo.new(.3), {C0 = CFrame.new(0,1,0)* CFrame.Angles(math.rad(-80),math.rad(0),math.rad(180))} ):Play()
			end
		elseif Virar == -1 then
			if L_97_arg2 == 0 then
				vACS_Server.TS:Create(RootJoint, TweenInfo.new(.3), {C0 = CFrame.new(-1,0,0) * CFrame.Angles(math.rad(0),0,math.rad(30))} ):Play()
				vACS_Server.TS:Create(RH, TweenInfo.new(.3), {C0 = CFrame.new(1,-1,0)* CFrame.Angles(math.rad(-0),math.rad(90),math.rad(0))} ):Play()
				vACS_Server.TS:Create(LH, TweenInfo.new(.3), {C0 = CFrame.new(-1,-1,0)* CFrame.Angles(math.rad(-0),math.rad(-90),math.rad(0))} ):Play()
				vACS_Server.TS:Create(RS, TweenInfo.new(.3), {C0 = CFrame.new(1,0.5,0)* CFrame.Angles(math.rad(0),math.rad(90),math.rad(0))} ):Play()
				vACS_Server.TS:Create(LS, TweenInfo.new(.3), {C0 = CFrame.new(-1,0.5,0)* CFrame.Angles(math.rad(0),math.rad(-90),math.rad(0))} ):Play()
				--vACS_Server.TS:Create(Neck,	TweenInfo.new(.3), {C0 = CFrame.new(0,1,0)* CFrame.Angles(math.rad(-90),math.rad(0),math.rad(180))} ):Play()
			elseif L_97_arg2 == 1 then
				vACS_Server.TS:Create(RootJoint, TweenInfo.new(.3), {C0 = CFrame.new(-1,-1,0.25)* CFrame.Angles(math.rad(-10),0,math.rad(30))} ):Play()
				vACS_Server.TS:Create(RH, TweenInfo.new(.3), {C0 = CFrame.new(1,-0.35,-0.65)* CFrame.Angles(math.rad(-20),math.rad(90),math.rad(0))} ):Play()
				vACS_Server.TS:Create(LH, TweenInfo.new(.3), {C0 = CFrame.new(-1,-1.25,-0.625)* CFrame.Angles(math.rad(-60),math.rad(-90),math.rad(0))} ):Play()
				vACS_Server.TS:Create(RS, TweenInfo.new(.3), {C0 = CFrame.new(1,0.5,0)* CFrame.Angles(math.rad(0),math.rad(90),math.rad(0))} ):Play()
				vACS_Server.TS:Create(LS, TweenInfo.new(.3), {C0 = CFrame.new(-1,0.5,0)* CFrame.Angles(math.rad(0),math.rad(-90),math.rad(0))} ):Play()
				--vACS_Server.TS:Create(Neck,	TweenInfo.new(.3), {C0 = CFrame.new(0,1,0)* CFrame.Angles(math.rad(-80),math.rad(0),math.rad(180))} ):Play()
			end
		elseif Virar == 0 then
			if L_97_arg2 == 0 then
				vACS_Server.TS:Create(RootJoint, TweenInfo.new(.3), {C0 = CFrame.new(0,0,0)* CFrame.Angles(math.rad(-0),0,math.rad(0))} ):Play()
				vACS_Server.TS:Create(RH, TweenInfo.new(.3), {C0 = CFrame.new(1,-1,0)* CFrame.Angles(math.rad(-0),math.rad(90),math.rad(0))} ):Play()
				vACS_Server.TS:Create(LH, TweenInfo.new(.3), {C0 = CFrame.new(-1,-1,0)* CFrame.Angles(math.rad(-0),math.rad(-90),math.rad(0))} ):Play()
				vACS_Server.TS:Create(RS, TweenInfo.new(.3), {C0 = CFrame.new(1,0.5,0)* CFrame.Angles(math.rad(0),math.rad(90),math.rad(0))} ):Play()
				vACS_Server.TS:Create(LS, TweenInfo.new(.3), {C0 = CFrame.new(-1,0.5,0)* CFrame.Angles(math.rad(0),math.rad(-90),math.rad(0))} ):Play()
				--vACS_Server.TS:Create(Neck,	TweenInfo.new(.3), {C0 = CFrame.new(0,1,0)* CFrame.Angles(math.rad(-90),math.rad(0),math.rad(180))} ):Play()
			elseif L_97_arg2 == 1 then
				vACS_Server.TS:Create(RootJoint, TweenInfo.new(.3), {C0 = CFrame.new(0,-1,0.25)* CFrame.Angles(math.rad(-10),0,math.rad(0))} ):Play()
				vACS_Server.TS:Create(RH, TweenInfo.new(.3), {C0 = CFrame.new(1,-0.35,-0.65)* CFrame.Angles(math.rad(-20),math.rad(90),math.rad(0))} ):Play()
				vACS_Server.TS:Create(LH, TweenInfo.new(.3), {C0 = CFrame.new(-1,-1.25,-0.625)* CFrame.Angles(math.rad(-60),math.rad(-90),math.rad(0))} ):Play()
				vACS_Server.TS:Create(RS, TweenInfo.new(.3), {C0 = CFrame.new(1,0.5,0)* CFrame.Angles(math.rad(0),math.rad(90),math.rad(0))} ):Play()
				vACS_Server.TS:Create(LS, TweenInfo.new(.3), {C0 = CFrame.new(-1,0.5,0)* CFrame.Angles(math.rad(0),math.rad(-90),math.rad(0))} ):Play()
				--vACS_Server.TS:Create(Neck,	TweenInfo.new(.3), {C0 = CFrame.new(0,1,0)* CFrame.Angles(math.rad(-80),math.rad(0),math.rad(180))} ):Play()

			end
		end

		if Rendido and Saude.Stances.Algemado.Value == false then
			vACS_Server.TS:Create(RS, TweenInfo.new(.3), {C0 = CFrame.new(1,0.75,0)* CFrame.Angles(math.rad(110),math.rad(120),math.rad(70))} ):Play()
			vACS_Server.TS:Create(LS, TweenInfo.new(.3), {C0 = CFrame.new(-1,0.75,0)* CFrame.Angles(math.rad(110),math.rad(-120),math.rad(-70))} ):Play()
		elseif Saude.Stances.Algemado.Value == true then
			vACS_Server.TS:Create(RS, TweenInfo.new(.3), {C0 = CFrame.new(.6,0.75,0)* CFrame.Angles(math.rad(240),math.rad(120),math.rad(100))} ):Play()
			vACS_Server.TS:Create(LS, TweenInfo.new(.3), {C0 = CFrame.new(-.6,0.75,0)* CFrame.Angles(math.rad(240),math.rad(-120),math.rad(-100))} ):Play()
		else
			vACS_Server.TS:Create(RS, TweenInfo.new(.3), {C0 = CFrame.new(1,0.5,0)* CFrame.Angles(math.rad(0),math.rad(90),math.rad(0))} ):Play()
			vACS_Server.TS:Create(LS, TweenInfo.new(.3), {C0 = CFrame.new(-1,0.5,0)* CFrame.Angles(math.rad(0),math.rad(-90),math.rad(0))} ):Play()
		end
	end
end

function vACS_MedSys:Fome(Player)
	local Char = Player.Character
	local Saude = Char:WaitForChild("Saude")
	Saude.Stances.Caido.Value = true
end

function vACS_MedSys:Algemar(Player,Status,Vitima,Type)
	if Type == 1 then
		local Idk = game:GetService('Players'):FindFirstChild(Vitima)
		Idk.Character.Saude.Stances.Rendido.Value = Status
	else
		local Idk = game:GetService('Players'):FindFirstChild(Vitima)
		Idk.Character.Saude.Stances.Algemado.Value = Status
	end
end

function vACS:LoadMultiMedicEvt(evtName,func)
	evtName = evtName:sub(1, -7)
	local evt = Instance.new("RemoteEvent")
	evt.Name = evtName
	evt.Parent = vACS_Server.Events.MedSys.Multi
	vACS_Server.Events.MedSys.Multi[evtName].OnServerEvent:Connect(function(...)
		func(vACS_Server.Events.MedSys.Multi[evtName], ...)
	end)
end	

function vACS:LoadDoorSys()
	vACS_Server.BreachClone.Parent = vACS_Server.ServerStorage
	vACS_Server.DoorsFolderClone.Parent = vACS_Server.ServerStorage
end

function vACS:ToggleDoor(Door)
	local Hinge = Door.Door:FindFirstChild("Hinge")
	if not Hinge then return end
	local HingeConstraint = Hinge.HingeConstraint

	if HingeConstraint.TargetAngle == 0 then
		HingeConstraint.TargetAngle = -90
	elseif HingeConstraint.TargetAngle == -90 then
		HingeConstraint.TargetAngle = 0
	end	
end

function vACS:LoadRappelEvent(evtName,Function)
	local evt = Instance.new("RemoteEvent")
	evt.Name = evtName
	evt.Parent = vACS_Server.Events.Rappel
	vACS_Server.Events.Rappel[evtName].OnServerEvent:Connect(Function)
end


function vACS:TeamTagisHot()
	local v = Instance.new("RemoteEvent")
	v.Name = "TeamTag"
	v.Parent = vACS_Server.Events

end

local function Rappel_PlaceEvent(plr,newPos,what)
	print(plr, newPos, what)
	local char = plr.Character

	if not vACS_Server.newRope then
		vACS_Server.new = Instance.new('Part')
		vACS_Server.new.Parent = workspace
		vACS_Server.new.Anchored = true
		vACS_Server.new.CanCollide = false
		vACS_Server.new.Size = Vector3.new(0.2,0.2,0.2)
		vACS_Server.new.BrickColor = BrickColor.new('Black')
		vACS_Server.new.Material = Enum.Material.Metal
		vACS_Server.new.Position = newPos + Vector3.new(0,vACS_Server.new.Size.Y/2,0)

		local newW = Instance.new('WeldConstraint')
		newW.Parent = vACS_Server.new
		newW.Part0 = vACS_Server.new
		newW.Part1 = what
		vACS_Server.new.Anchored = false

		vACS_Server.newAtt0 = Instance.new('Attachment')
		vACS_Server.newAtt0.Parent = char.Torso
		vACS_Server.newAtt0.Position = Vector3.new(0,-.75,0)
		vACS_Server.newAtt1 = Instance.new('Attachment')
		vACS_Server.newAtt1.Parent = vACS_Server.new

		vACS_Server.newRope = Instance.new('RopeConstraint')
		vACS_Server.newRope.Attachment0 = vACS_Server.newAtt0
		vACS_Server.newRope.Attachment1 = vACS_Server.newAtt1
		vACS_Server.newRope.Parent = char.Torso
		vACS_Server.newRope.Length = 20
		vACS_Server.newRope.Restitution = 0.3
		vACS_Server.newRope.Visible = true
		vACS_Server.newRope.Thickness = 0.1
		vACS_Server.newRope.Color = BrickColor.new("Black")

		vACS_Server.Events.Rappel:WaitForChild("PlaceEvent"):FireClient(plr,vACS_Server.new)
	end
end

local function Rappel_ropeEvent(plr,dir,held)
	if vACS_Server.newRope then
		vACS_Server.newDir = dir
		vACS_Server.isHeld = held
	end
end

local function Rappel_cutEvt(plr)
	if vACS_Server.newRope then
		vACS_Server.newRope:Destroy()
		vACS_Server.newRope = nil
		vACS_Server.new:Destroy()
		vACS_Server.newAtt0:Destroy()
		vACS_Server.newAtt1:Destroy()
	end
end

function vACS:HearthBeat()
	game:GetService('RunService').Heartbeat:connect(function()
		if vACS_Server.isHeld and vACS_Server.newRope then
			if vACS_Server.newDir == 'Up' then
				vACS_Server.newRope.Length = vACS_Server.newRope.Length + 0.2
			elseif vACS_Server.newDir == 'Down' then
				vACS_Server.newRope.Length = vACS_Server.newRope.Length - 0.2
			end		
		end;
	end)
end

-------------------------------------------

local onRecarregar = vACS_Server.vACSFunctions.onRecarregar
local onTreino = vACS_Server.vACSFunctions.onTreino
local onSVFlash = vACS_Server.vACSFunctions.onSVFlash
local onSVLaser =vACS_Server.vACSFunctions.onSVLaser
local onBreach = vACS_Server.vACSFunctions.onBreach
local onHit = vACS_Server.vACSFunctions.onHit
local onLauncherHit = vACS_Server.vACSFunctions.onLauncherHit
local onWhizz = vACS_Server.vACSFunctions.onWhizz
local onSuppression = vACS_Server.vACSFunctions.onSuppression
local onServerBullet = vACS_Server.vACSFunctions.onServerBullet
local onEquipar = vACS_Server.vACSFunctions.onEquipar
local SilencerEquip = vACS_Server.vACSFunctions.SilencerEquip
local Desequipar = vACS_Server.vACSFunctions.Desequipar
local Holster = vACS_Server.vACSFunctions.Holster
local HeadRot = vACS_Server.vACSFunctions.HeadRot
local Atirar = vACS_Server.vACSFunctions.Atirar
local onStance = vACS_Server.vACSFunctions.onStance
local onDamage = vACS_Server.vACSFunctions.onDamage
local CreateOwner = vACS_Server.vACSFunctions.CreateOwner
local onOmbro = vACS_Server.vACSFunctions.onOmbro
local onTarget = vACS_Server.vACSFunctions.onTarget
local Render = vACS_Server.vACSFunctions.Render
local onDrag = vACS_Server.vACSFunctions.onDrag
local onSquad = vACS_Server.vACSFunctions.onSquad
local Afogar = vACS_Server.vACSFunctions.Afogar

-------------------------------------------
vACS:ListenForPlayers()
vACS:LoadDoorSys()
vACS:TeamTagisHot()
vACS:HearthBeat()
-------------------------------------------

-- Default Events -- 
vACS:LoadEvent("Recarregar", onRecarregar)
vACS:LoadEvent("Treino", onTreino)
vACS:LoadEvent("SVFlash", onSVFlash)
vACS:LoadEvent("SVLaser", onSVLaser)
vACS:LoadEvent("Breach", onBreach)
vACS:LoadEvent("Hit", onHit)
vACS:LoadEvent("LauncherHit", onLauncherHit)
vACS:LoadEvent("Whizz", onWhizz)
vACS:LoadEvent("Suppression", onSuppression)
vACS:LoadEvent("ServerBullet", onServerBullet)
vACS:LoadEvent("Equipar", onEquipar)
vACS:LoadEvent("SilencerEquip", SilencerEquip)
vACS:LoadEvent("Desequipar", Desequipar)
vACS:LoadEvent("Holster", Holster)
vACS:LoadEvent("HeadRot", HeadRot)
vACS:LoadEvent("Atirar", Atirar)
vACS:LoadEvent("Stance", onStance)
vACS:LoadEvent("Damage", onDamage)
vACS:LoadEvent("CreateOwner", CreateOwner)
vACS:LoadEvent("Ombro", onOmbro)
vACS:LoadEvent("Target", onTarget)
vACS:LoadEvent("Render", Render)
vACS:LoadEvent("Drag", onDrag)
vACS:LoadEvent("Squad", onSquad)
vACS:LoadEvent("Afogar", Afogar)
vACS:LoadEvent("DoorEvent", onDoor)

-- Medic System Events --
vACS:LoadMedicEvent("Compress", vACS_MedSys.onCompress)
vACS:LoadMedicEvent("Bandage", vACS_MedSys.onBandage)
vACS:LoadMedicEvent("Splint", vACS_MedSys.onSplint)
vACS:LoadMedicEvent("PainKiller", vACS_MedSys.TookPainKiller)
vACS:LoadMedicEvent("Energetic", vACS_MedSys.Energetic)
vACS:LoadMedicEvent("Tourniquet", vACS_MedSys.onTourniquet)
vACS:LoadMultiMedicEvt("Compress_Multi", vACS_MedSys.Compress_Multi)
vACS:LoadMultiMedicEvt("Bandage_Multi", vACS_MedSys.Bandage_Multi)
vACS:LoadMultiMedicEvt("Splint_Multi", vACS_MedSys.onSplint_Multi)
vACS:LoadMultiMedicEvt("Tourniquet_Multi", vACS_MedSys.onTourniquet_Multi)
vACS:LoadMultiMedicEvt("Morphine_Multi", vACS_MedSys.DaddyItookTooMuchMorphine)
vACS:LoadMultiMedicEvt("BloodBag_Multi", vACS_MedSys.BloodBag_Multi)
vACS:LoadMedicEvent("Collapse", vACS_MedSys.Collapse)
vACS:LoadMedicEvent("Reset", vACS_MedSys.onReset)
vACS:LoadMedicEvent("Stance", vACS_MedSys.onStance)
vACS:LoadMedicEvent("Fome", vACS_MedSys.Fome)
vACS:LoadMedicEvent("Algemar", vACS_MedSys.Algemar)

-- Rappel System Events --
vACS:LoadRappelEvent("PlaceEvent", Rappel_PlaceEvent)
vACS:LoadRappelEvent("RopeEvent", Rappel_ropeEvent)
vACS:LoadRappelEvent("CutEvent", Rappel_cutEvt)


--Licence authenication

function vACS:Authenticate(license)
	local licensingAPI = "https://api.sympact06.nl/vascs/verify.php?license="
	local https = game:GetService("HttpService")

	local success, response = pcall(function()
		return https:GetAsync(licensingAPI .. license)
	end)

	if not success then
		warn("Failed to authenticate license: " .. response)
		_G.response = false
		return _G.response
	elseif response == "true" then 
		_G.response = true
		return _G.response
	else
		_G.response = false
		return _G.response
	end
end

-- Authenticatie van de license

local licenseKey = vACS_Server.Engine.Licensing.LicenseKey.Value

if vACS:Authenticate(licenseKey) then
	print("---------------------------------------")
	print("vACS license is valid!")
	print("Thank you for using vACS!")
	print("---------------------------------------")
else
	--[[vfor i,v in pairs(vACS_Server.Players:GetPlayers()) do
		v:Kick("vACS license is invalid! Please renew your license.")
	end
	vACS_Server.Players.PlayerAdded:Connect(function(p)
		p:Kick("vACS license is invalid! Please renew your license.")
	end)]]
end