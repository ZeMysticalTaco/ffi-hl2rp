ITEM.name = "Standard .9mm Factory Muzzle Break"
ITEM.description = "A factory produced muzzle break, it's just small enough to fit on the .9mm Pistol."
ITEM.model = "models/props_c17/TrapPropeller_Lever.mdl"
ITEM.isPart = true
ITEM.width = 1
ITEM.height = 1
ITEM.guns = {"pistol"} --list weapon classes it can fit on
--[[-------------------------------------------------------------------------
	Bonuses:
	["recoil"] -- lowers or raises swep.primary.recoil by the specified amount.
	["damage"] -- lowers or raises swep.primary.damage by the specified amount.
	["magsize"] -- sets the magsize to the specified value
	["reloadspeed"] -- lowers or raises the reload speed by the specified amount.
---------------------------------------------------------------------------]]
ITEM.bonuses = {["recoil"] = 2, ["MagSize"] = 3}