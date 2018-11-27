AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName = "H&K MP7A1"
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
SWEP.HoldType = "smg"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.ViewModelFOV = 54
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "smg"
SWEP.ViewTranslation = 4
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Damage = 8
SWEP.Primary.Delay = 0.1
SWEP.Primary.Spread = .04
SWEP.Primary.Sound = "weapons/smg1/smg1_fire1.wav"
SWEP.Primary.EmptySound = "weapons/pistol/pistol_empty.wav"
SWEP.Primary.ReloadSound = "weapons/smg1/smg1_reload.wav"
SWEP.Primary.Recoil = 6
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = ""
SWEP.ViewModel = Model("models/weapons/v_smg1.mdl")
SWEP.WorldModel = Model("models/weapons/w_smg1.mdl")
SWEP.UseHands = true
SWEP.LowerAngles = Angle(15.896, 0, -2)
SWEP.FireWhenLowered = true

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