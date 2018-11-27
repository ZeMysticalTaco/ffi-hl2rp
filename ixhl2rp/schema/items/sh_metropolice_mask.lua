ITEM.name = "Combine Civil Authority Mask"
ITEM.description = "A clean CCA mask, the respiratory systems appear to be functional and it has a built in radio."
ITEM.price = 8
ITEM.model = "models/props_junk/cardboard_box004a.mdl"
ITEM.factions = {FACTION_MPF, FACTION_OTA}

ITEM.functions.Wear = {
	OnRun = function(item)
		local ply = item.player

		if item.player:IsCombine() then
			local mdl = ply:GetModel()
			local char = ply:GetCharacter()
			char:SetData("realModel", mdl)

			if string.find(mdl, "female") then
				char:SetModel("models/police/c18_police_female.mdl")
			else
				char:SetModel("models/police/c18_police.mdl")
			end
			item:SetData("equip", true)
		else
			ply:Notify("Functionality for you to wear this mask isn't in just yet, but hang onto it and store it somewhere! It will be in soon.")
		end

		return false
	end,
	OnCanRun = function(item)
		if item:GetData("equip", false) == false then
			return true
		else
			return false
		end

		return not IsValid(item.entity) and item.bBeingUsed and not item:GetData("equip", false) and item.invID == item.player:GetCharacter():GetInventory():GetID()
	end
}

ITEM.functions.Remove = {
	OnRun = function(item)
		local ply = item.player

		if item.player:IsCombine() then
			local mdl = ply:GetModel()
			local char = ply:GetCharacter()
			local realModel = char:GetData("realModel", nil)

			if not realModel then
				ply:Notify("You should not be able to use the remove function if you haven't used the wear one yet, contact a developer.")

				return false
			end

			char:SetModel(realModel)
		else
			ply:Notify("Functionality for you to wear this mask isn't in just yet, but hang onto it and store it somewhere! It will be in soon.")
		end
		item:SetData("equip", false)
		return false
	end,
	OnCanRun = function(item)
		if item:GetData("equip", false) == true then
			return true
		else
			return false
		end

		return not IsValid(item.entity) and item.bBeingUsed and item.player:IsCombine() and item.invID == item.player:GetCharacter():GetInventory():GetID()
	end
}

function ITEM:CanTransfer(inventory, newInventory)
	return not self:GetData("equip", false) == true
end