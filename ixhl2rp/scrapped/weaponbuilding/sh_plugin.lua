PLUGIN.name = "Weapon Building"
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.description = "An intricate weapon customization system."


local playerMeta = FindMetaTable("Player")

--[[-------------------------------------------------------------------------
	playerMeta:GetItemWeapon()

	Purpose: Checks the player's currently equipped weapon and returns the item and weapon.
	Syntax: player:GetItemWeapon()
	Returns: @weapon, @item
---------------------------------------------------------------------------]]

function playerMeta:GetItemWeapon()
	local char = self:GetCharacter()
	local inv = char:GetInventory()
	local items = inv:GetItems()
	local weapon = self:GetActiveWeapon()

	for k, v in pairs(items) do
		if v.class then
			if v.class == weapon:GetClass() then
				if v:GetData("equip", false) then
					return weapon, v
				else
					return false
				end
			end
		end
	end
end