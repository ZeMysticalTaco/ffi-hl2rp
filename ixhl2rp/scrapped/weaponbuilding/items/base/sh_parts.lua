ITEM.name = "Parts"
ITEM.description = "Parts for guns."
ITEM.category = "Parts"
ITEM.model = "models/weapons/w_pistol.mdl"
ITEM.isPart = true
ITEM.width = 1
ITEM.height = 1
ITEM.guns = {} --list weapon classes it can fit on
--[[-------------------------------------------------------------------------
	Bonuses:
	["recoil"] -- lowers or raises swep.primary.recoil by the specified amount.
	["damage"] -- lowers or raises swep.primary.damage by the specified amount.
	["magsize"] -- sets the magsize to the specified value
	["reloadspeed"] -- lowers or raises the reload speed by the specified amount.
---------------------------------------------------------------------------]]
ITEM.bonuses = {}

-- Inventory drawing
if (CLIENT) then
function ITEM:PopulateTooltip(tooltip)
		PrintTable(self.bonuses)

		if table.Count(self.bonuses) > 0 then
			for k, v in pairs(self.bonuses) do
				local bonus = tooltip:AddRow("bonus" .. k)
				if v > 0 then
					bonus:SetBackgroundColor(derma.GetColor("Info", tooltip))

					if k == "recoil" then
						bonus:SetText("Recoil: " .. v)
					end

					if k == "MagSize" then
						bonus:SetText("Magazine Capacity: " .. v)
					end
				end
			end
		end
	end
end