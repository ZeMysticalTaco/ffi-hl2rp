AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName = "H&K USP Match"
	SWEP.Slot = 0
	SWEP.SlotPos = 5
	SWEP.DrawAmmo = true
	SWEP.DrawCrosshair = false
end

SWEP.Category = "HL2 RP"
SWEP.Author = "ZeMysticalTaco"
SWEP.Instructions = ""
SWEP.Purpose = ""
SWEP.Drop = true
SWEP.HoldType = "pistol"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.ViewModelFOV = 54
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "pistol"
SWEP.ViewTranslation = 4
SWEP.Primary.ClipSize = 18
SWEP.Primary.DefaultClip = 18
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Damage = 10.5
SWEP.Primary.Delay = 0.1
SWEP.Primary.Spread = .02
SWEP.Primary.Recoil = 8
SWEP.Primary.Sound = "weapons/pistol/pistol_fire2.wav"
SWEP.Primary.EmptySound = "weapons/pistol/pistol_empty.wav"
SWEP.Primary.ReloadSound = "weapons/pistol/pistol_reload1.wav"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.ViewModel = Model("models/weapons/c_pistol.mdl")
SWEP.WorldModel = Model("models/weapons/w_pistol.mdl")
SWEP.UseHands = true
SWEP.FireWhenLowered = true
SWEP.LowerPosition = Vector(-0.1, -10, 5)
SWEP.LowerAngles = Angle(15.896, 0, -2)

function SWEP:SetupDataTables()
	--self:NetworkVar("Bool", 0, "Activated")
end

function SWEP:Precache()
	util.PrecacheSound("physics/wood/wood_crate_impact_hard3.wav")
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:Think()
	if not self.NextBonusUpdate or self.NextBonusUpdate <= CurTime() then
		self:SetupBonusTable()
		self.NextBonusUpdate = CurTime() + 30
	end
end

function SWEP:Deploy()
	if SERVER then
		self:SetupBonusTable()
	end
end

function SWEP:SetupBonusTable()
	if SERVER then
		timer.Simple(0.1, function()
			local weapon, item = self.Owner:GetItemWeapon()
			local inv = item:GetInventory():GetItems()

			for k2, v2 in pairs(inv) do
				if v2.isPart then
					for k3, v3 in pairs(v2.bonuses) do
						self:SetNetVar(k3, v3)
						print("Set " .. k3 .. " to " .. v3)
					end
				end
			end
			if self:Clip1() > self:GetMagSize() then
				self.Owner:GiveAmmo(self:Clip1() - self:GetMagSize(), self:GetPrimaryAmmoType())
				self:SetClip1(self:GetMagSize())
			end
		end)
	end
end

local color_glow = Color(128, 128, 128)

function SWEP:DrawWorldModel()
	self:DrawModel()
end

function SWEP:PostDrawViewModel()
end

function SWEP:PrimaryAttack()
	if self:Clip1() <= 0 then
		if not self.NextEmptyNotify or self.NextEmptyNotify <= CurTime() then
			self:EmitSound(self.Primary.EmptySound)
			self.NextEmptyNotify = CurTime() + 0.2
		end

		return false
	end

	self:SetNextPrimaryFire(CurTime() + self:GetNetVar("delay", self.Primary.Delay))

	if (not self.Owner:IsWepRaised()) then
		return
	end

	self:EmitSound(self.Primary.Sound)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:ViewPunch(Angle(math.Rand(-0.2, -0.1) * self.Primary.Recoil, math.Rand(-0.1, 0.1) * self:GetNetVar("recoil", self.Primary.Recoil), 0))
	

	--bullet code
	self:ShootBullet(self:GetNetVar("damage", self.Primary.Damage), 1, self:GetNetVar("spread", self.Primary.Spread))
	self:TakePrimaryAmmo(1)
end

function SWEP:SecondaryAttack()
end

function SWEP:ShootBullet(damage, num_bullets, aimcone)
	local bullet = {}
	bullet.Num = num_bullets
	bullet.Src = self.Owner:GetShootPos() -- Source
	bullet.Dir = self.Owner:GetAimVector() -- Dir of bullet
	bullet.Spread = Vector(aimcone, aimcone, 0) -- Aim Cone
	bullet.Tracer = 5 -- Show a tracer on every x bullets
	bullet.Force = 1 -- Amount of force to give to phys objects
	bullet.Damage = damage
	bullet.AmmoType = "Pistol"
	self.Owner:FireBullets(bullet)
	self:ShootEffects()
end

function SWEP:SetMagSize(magsize, ammoInMag)
	--self:SetClip1(ammoInMag) --change to ammoinmag
	--get item for mag and put ammo into it for how much you have
	self:SetNetVar("MagSize", magsize)
end

function SWEP:GetMagSize()
	--print(self:GetNetVar("MagSize"))

	return self:GetNetVar("MagSize", self.Primary.ClipSize)
end

function SWEP:Reload()
	if self:Clip1() == self:GetMagSize() then return end
	if self.Owner:GetAmmoCount(self:GetPrimaryAmmoType()) < 1 then return end
	if self:GetNetVar("nextReload", 0) > CurTime() then return end
	if self:Clip1() <= self:GetMagSize() and self:GetNetVar("nextReload", 0) <= CurTime() then
		self:SendWeaponAnim(ACT_VM_RELOAD)

		if SERVER then
			--self:DefaultReload(ACT_VM_RELOAD)
			if  self.Owner:GetAmmoCount(self:GetPrimaryAmmoType()) > 0 then
				local mathstuff = self:GetMagSize() - self:Clip1()
				if mathstuff > self.Owner:GetAmmoCount(self:GetPrimaryAmmoType()) then
					mathstuff = self.Owner:GetAmmoCount(self:GetPrimaryAmmoType())
				end
				print(mathstuff)
				self:SetClip1(self:Clip1() + mathstuff)
				self.Owner:RemoveAmmo(mathstuff, self:GetPrimaryAmmoType())
			end

			self.Owner:EmitSound(self.Primary.ReloadSound)
			self.Owner:SetAnimation(PLAYER_RELOAD)
		end
	end

	if SERVER then
		self:SetNetVar("nextReload", CurTime() + 3)
	end
end