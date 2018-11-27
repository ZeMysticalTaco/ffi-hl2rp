AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName = "UUAR USPM94"
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
SWEP.Primary.Damage = 11
SWEP.Primary.Delay = 0.1
SWEP.Primary.Spread = .01
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
end

function SWEP:Deploy()
	if SERVER then
		self:SetupBonusTable()
	end
end

function SWEP:SetupBonusTable()
	--[[-------------------------------------------------------------------------
		Future.
	---------------------------------------------------------------------------]]
	--[[if SERVER then
		for k, v in pairs(self.Owner:GetCharacter():GetInventory():GetItems()) do
			if v.class then
				local winv = v:GetInventory():GetItems()

				for k2, v2 in pairs(winv) do
					PrintTable(v2)
				end
			end
		end
	end--]]
end

local color_glow = Color(128, 128, 128)

function SWEP:DrawWorldModel()
	self:DrawModel()
end

function SWEP:PostDrawViewModel()
end

function SWEP:PrimaryAttack()
	if self:Clip1() <= 0 then
		if !self.NextEmptyNotify or self.NextEmptyNotify <= CurTime() then
			self:EmitSound(self.Primary.EmptySound)
			self.NextEmptyNotify = CurTime() + 0.2
		end
		return false
	end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if (not self.Owner:IsWepRaised()) then
		return
	end

	self:EmitSound(self.Primary.Sound)
	local recoils = {ACT_VM_RECOIL1, ACT_VM_RECOIL2, ACT_VM_RECOIL3}
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	local damage = self.Primary.Damage
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	--self.Owner:ViewPunch(Angle(math.random(-1,-2), 0, -0.125))
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	--bullet code
	self:ShootBullet(self.Primary.Damage, 1, self.Primary.Spread)
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
	self:SetClip1(ammoInMag) --change to ammoinmag
	--get item for mag and put ammo into it for how much you have
	self:SetNetVar("MagSize", magsize)
end

function SWEP:Reload()
	if self:Clip1() < self.Primary.ClipSize then
		self:DefaultReload(ACT_VM_RELOAD)
		self:EmitSound(self.Primary.ReloadSound)
		self.Owner:SetAnimation(PLAYER_RELOAD)
	end
end