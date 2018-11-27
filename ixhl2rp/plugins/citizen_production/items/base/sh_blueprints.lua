ITEM.name = "Blueprint Base"
ITEM.model = "models/props_lab/binderblue.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "Crafting's basic."
ITEM.price = 100
ITEM.isBlueprint = true

function ITEM:GetDescription()
	return self.description
end

function ITEM:OnRegistered()
	if (SERVER) then
		if (self.requirements and self.result) then
			if (!self.base) then
				ErrorNoHalt(self.uniqueID .. " does not have proper craft data!")
			end
		end
	end
end

function ITEM:PopulateTooltip(tooltip)
	local titletip = tooltip:AddRow("title")
	titletip:SetBackgroundColor(derma.GetColor("Info", tooltip))
	titletip:SetText("Requirements")
	titletip:SetExpensiveShadow(0.25)
	titletip:SizeToContents()
	for k, v in pairs(self.requirements) do
		local inv = self.invID
		local inv2 = ix.item.inventories[inv]
		local id = ix.item.Get(v[1])
		local warning = tooltip:AddRow("requirements")
		if inv2:HasItem(v[1]) then
			warning:SetBackgroundColor(derma.GetColor("Success", tooltip))
		else
			warning:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		end
		warning:SetText(id.name .. " (" .. v[2] .. "x)")
		warning:SetExpensiveShadow(0.5 )
		warning:SizeToContents()
	end

	local bpwarning = tooltip:AddRow("bpwarning")
	bpwarning:SetBackgroundColor(derma.GetColor("DarkerBackground", tooltip))
	bpwarning:SetText("If you study this blueprint and craft the item outside of the Union Manufacturing Table, you will not get a ticket.")
	bpwarning:SetExpensiveShadow(0.25)
	bpwarning:SizeToContents()
end

ITEM.functions.Study = {
	name = "Study",
	OnRun = function(item)
		item.player:Notify("You study the schematic carefully, should you acquire these items outside of the factory, you are now able to form it's result.")
		local data = item.player:GetCharacter():GetData("blueprints", {})
		table.insert(data, item.uniqueID)
		item.player:GetCharacter():SetData("blueprints", data)
		return false
	end
}

