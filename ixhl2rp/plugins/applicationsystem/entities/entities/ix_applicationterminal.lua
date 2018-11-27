AddCSLuaFile()
--[[-------------------------------------------------------------------------
TODO: PLAY ANIMATION WHEN DEPLOYING SUPPORT
---------------------------------------------------------------------------]]
ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.PrintName = "Application Terminal"
ENT.Category = "Helix"
ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_BOTH

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_combine/breenconsole.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		--self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self.health = 50
	end

	function ENT:OnTakeDamage(damage)
		local atk = damage:GetAttacker()
		local dmg = damage:GetDamage()

		if not self:GetNetVar("destroyed", false) then
			self.health = self.health - dmg
		end

		if self.health <= 0 and self:GetNetVar("destroyed", false) == false then
			self:Destruct(atk)
		end
	end

	function ENT:Destruct(atk)
		self.health = 0
		self:SetNetVar("destroyed", true)
		local spark = ents.Create("env_spark")
		spark:SetPos(self:GetPos() + Vector(0, 10, 0))
		spark:Fire("SparkOnce")
		--I don't feel like remembering stuff.
		local explosion = ents.Create("npc_grenade_frag")
		explosion:SetPos(spark:GetPos())
		explosion:Fire("Timer", 0.01)
		explosion:Fire("SetTimer", 0.01)
	end

	function ENT:Use(user)
		if self:GetNetVar("destroyed", false) then
			user:Notify("This terminal is destroyed!")
			self:EmitSound("buttons/combine_button_locked.wav")

			return
		end

		if not user:GetCharacter():GetInventory():HasItem("cid") then
			user:Notify("You need a CID to do this.")
			self:EmitSound("buttons/combine_button_locked.wav")

			return
		end

		user:SetAction("Logging in...", 2, function()
			netstream.Start(user, "OpenApplicationMenu", {})
			user:Freeze(false)
			self:SetNetVar("InUse", false)
		end)

		self:EmitSound("buttons/button14.wav", 100, 75)
		user:SelectWeapon("ix_hands")
		user:Freeze(true)
		self:SetNetVar("InUse", true)
	end
	--[[-------------------------------------------------------------------------
	I'm not sure who made the original CW terminals plugin, but the 3d2d here is theirs.
	---------------------------------------------------------------------------]]
else
	surface.CreateFont("panel_font", {
		["font"] = "verdana",
		["size"] = 12,
		["weight"] = 128,
		["antialias"] = true
	})

	function ENT:Draw()
		self:DrawModel()
		local ang = self:GetAngles()
		local pos = self:GetPos() + ang:Up() * 48 + ang:Right() * -5 + ang:Forward() * -9.75
		ang:RotateAroundAxis(ang:Forward(), 42)
		cam.Start3D2D(pos, ang, 0.1)
		local width, height = 155, 77
		surface.SetDrawColor(Color(16, 16, 16))

		if self:GetNetVar("destroyed", false) then
			surface.SetDrawColor(Color(255, 0, 0, 255))
		end

		surface.DrawRect(0, 0, width, height)
		surface.SetDrawColor(Color(255, 255, 255, 16))

		if self:GetNetVar("destroyed", false) then
			surface.SetDrawColor(Color(255, 0, 0, 255))
		end

		surface.DrawRect(0, height / 2 + math.sin(CurTime() * 4) * height / 2, width, 1)
		local alpha = 191 + 64 * math.sin(CurTime() * 4)

		if not self:GetNetVar("InUse", false) then
			if self:GetNetVar("destroyed", false) == true then
				draw.SimpleText("", "panel_font", 5, 36, Color(90, 210, 255, alpha))
				draw.SimpleText("ERR-...", "panel_font", 5, 46, Color(102, 255, 255, alpha))
			end

			draw.SimpleText("Application Terminal", "panel_font", width / 2, 25, Color(90, 210, 255, alpha), TEXT_ALIGN_CENTER)
			draw.SimpleText("Insert CID to begin!", "panel_font", width / 2, height - 16, Color(205, 255, 180, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			--draw.SimpleText(LocalPlayer():SteamID64(), "panel_font", 5, 36, Color(90, 210, 255, alpha))
			--draw.SimpleText("Validating CID Input...", "panel_font", 5, 46, Color(102, 255, 255, alpha))
		end

		cam.End3D2D()
	end
end