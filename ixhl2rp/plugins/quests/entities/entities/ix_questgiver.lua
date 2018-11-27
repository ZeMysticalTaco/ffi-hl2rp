AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "Quest NPC"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = true

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/humans/group01/male_01.mdl")
		self:SetSolid(SOLID_BBOX)
		self:PhysicsInit(SOLID_BBOX)
		self:SetMoveType(MOVETYPE_NONE)
		--self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetUseType(SIMPLE_USE)
		self:SetupAnimation(4)
	end

	function ENT:Use(client)
		if client:IsAdmin() and client:KeyDown(IN_WALK) then
			netstream.Start(client, "OpenQuestEditMenu", {self})
		else
			netstream.Start(client, "OpenQuestDialogue", {self})
		end
	end
else
	function ENT:CreateBubble()
		self.bubble = ClientsideModel("models/extras/info_speech.mdl", RENDERGROUP_OPAQUE)
		self.bubble:SetPos(self:GetPos() + Vector(0, 0, 84))
		self.bubble:SetModelScale(0.6, 0)
	end

	function ENT:Think()
		if (not IsValid(self.bubble) and not noBubble) then
			self:CreateBubble()
		end
		self:SetNextClientThink(CurTime() + 0.25)
	end

	function ENT:OnRemove()
		if (IsValid(self.bubble)) then
			self.bubble:Remove()
		end
	end

	function ENT:Draw()
		self:DrawModel()
		local bubble = self.bubble

		if (IsValid(bubble)) then
			local realTime = RealTime()
			bubble:SetRenderOrigin(self:GetPos() + Vector(0, 0, 84 + math.sin(realTime * 3) * 0.05))
			bubble:SetRenderAngles(Angle(0, realTime * 100, 0))
		end

		self:DrawModel()
	end

	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(container)
		local name = container:AddRow("name")
		name:SetImportant()
		name:SetText(self:GetNetVar("Name", "John Doe"))
		name:SizeToContents()
		local descriptionText = self:GetNetVar("Description", "")

		if (descriptionText ~= "") then
			local description = container:AddRow("Description")
			description:SetText(self:GetNetVar("Description"))
			description:SizeToContents()
		end
	end
end

function ENT:SetupAnimation(animation)
	if (animation and animation ~= -1) then
		self:ResetSequence(4)
	else
		self:ResetSequence(4)
	end
end