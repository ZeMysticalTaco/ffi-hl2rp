//TODO: Manual Restraint Machine
local ITEMS = {
	["raw_package"] = {
		["name"] = "Plastic Package",
		["description"] = "A flexible plastic package with cut indicators for each item.",
		["model"] = "models/bioshockinfinite/hext_candy_chocolate.mdl"
	},
	["raw_box"] = {
		["name"] = "Production Box",
		["description"] = "A standard Universal Union production package, it can fit a few items inside.",
		["model"] = "models/probs_misc/tobbcco_box-1.mdl"
	},
	["usp_frame"] = {
		["name"] = "USPM94 Frame",
		["description"] = "A frame to a USPM94 Pistol.",
		["model"] = "models/weapons/w_pistol.mdl"
	},
	["usp_slide"] = {
		["name"] = "USPM94 Slide",
		["description"] = "A slide to a USPM94 Pistol.",
		["model"] = "models/props_junk/cardboard_box004a.mdl"
	},
	["usp_pin"] = {
		["name"] = "USPM94 Pin",
		["description"] = "A pin to a USPM94 Pistol.",
		["model"] = "models/props_junk/cardboard_box004a.mdl"
	},
	["usp_hammer"] = {
		["name"] = "USPM94 Hammer",
		["description"] = "A hammer to a USPM94 Pistol.",
		["model"] = "models/props_junk/cardboard_box004a.mdl"
	},
	["usp_parts"] = {
		["name"] = "USPM94 Parts",
		["description"] = "A set of smaller, miscellaneous parts to the USPM94 Pistol.",
		["model"] = "models/props_junk/cardboard_box004a.mdl"
	},
	["mp7_frame"] = {
		["name"] = "MP7A1 Frame",
		["description"] = "A frame to a USPM94 Pistol.",
		["model"] = "models/weapons/w_pistol.mdl"
	},
	["mp7_slide"] = {
		["name"] = "MP7A1 Slide",
		["description"] = "A slide to a MP7A1.",
		["model"] = "models/props_junk/cardboard_box004a.mdl"
	},
	["mp7_pin"] = {
		["name"] = "MP7A1 Pin",
		["description"] = "A pin to a MP7A1.",
		["model"] = "models/props_junk/cardboard_box004a.mdl"
	},
	["mp7_bolt"] = {
		["name"] = "MP7A1 Bolt",
		["description"] = "A bolt to a MP7A1.",
		["model"] = "models/props_junk/cardboard_box004a.mdl"
	},
	["mp7_parts"] = {
		["name"] = "MP7A1 Parts",
		["description"] = "A set of smaller, miscellaneous parts to the MP7A1.",
		["model"] = "models/props_junk/cardboard_box004a.mdl"
	},
	["empty_standard_package"] = {
		["name"] = "Empty Standard Ration Package",
		["description"] = "An empty standard ration package.",
		["model"] = "models/weapons/w_packatc.mdl"
	},
	["token_pack"] = {
		["name"] = "Sealed Box of Tokens",
		["description"] = "A wrap sealed box of tokens.",
		["model"] = "models/probs_misc/tobccco_box-1.mdl"
	},

	["empty_bleach_bottle"] = {
		["name"] = "Empty Bleach Bottle",
		["description"] = "An empty bottle of bleach.",
		["model"] = "models/props_junk/garbage_plasticbottle001a.mdl"
	},

	["bleach_chemical_1"] = {
		["name"] = "Bleach Chemical Substitute",
		["description"] = "A substitute to normal bleach chemicals.",
		["model"] = "models/props_junk/garbage_plasticbottle003a.mdl"	
	},
	["oil_packet"] = {
		["name"] = "Oil Package",
		["description"] = "A package of oil for pouring into bottles.",
		["model"] = "models/foodnhouseholdaaaaa/combirationa.mdl"	
	},

	["empty_oil_bottle"] = {
		["name"] = "Empty Oil Bottle",
		["description"] = "An empty bottle of oil.",
		["model"] = "models/props_junk/garbage_plasticbottle002a.mdl"
	},
}

for k, v in pairs(ITEMS) do
	local ITEM = ix.item.Register(k, nil, false, nil, true)
	ITEM.name = v.name
	ITEM.model = v.model
	ITEM.description = v.description
	ITEM.category = "Production"
	ITEM.width = v.width or 1
	ITEM.height = v.height or 1
end

local BLUEPRINTS = {
	["b_pistol"] = {
		["name"] = "Schematic: UUAR USPM94 Pistol",
		["description"] = "A blueprint for manufacturing a USPM94 Pistol.",
		["model"] = "models/props_lab/clipboard.mdl",
		["requirements"] = {
			{"usp_frame", 1},
			{"usp_slide", 1},
			{"usp_pin", 1},
			{"usp_hammer", 1},
			{"usp_parts", 1},
		},

		["result"] = {
			{"pistol", 1},
			{"manufacturing_ticket", 1}
		}
	},

	["b_smg"] = {
		["name"] = "Schematic: UUAR MP7A1 SMG",
		["description"] = "A blueprint for manufacturing a MP7A1 SMG.",
		["model"] = "models/props_lab/clipboard.mdl",
		["requirements"] = {
			{"mp7_frame", 1},
			{"mp7_slide", 1},
			{"mp7_pin", 1},
			{"mp7_bolt", 1},
			{"mp7_parts", 1},
		},

		["result"] = {
			{"smg1", 1},
			{"manufacturing_ticket", 1}
		}
	},

	["b_ration"] = {
		["name"] = "Schematic: Standard Ration",
		["model"] = "models/props_lab/clipboard.mdl",
		["description"] = "A list layout of the requirements for a standard UU ration.",
		["requirements"] = {
			{"token_pack" , 1},
			{"empty_standard_package", 1},
			{"standard_supplement", 1},
			{"standard_hydration_pack", 1},
		},
		["result"] = {{"ration", 1}, {"manufacturing_ticket", 1}}
	},

	["b_supplement"] = {
		["name"] = "Schematic: Standard Supplements",
		["model"] = "models/props_lab/clipboard.mdl",
		["description"] = "A list layout of the requirements for a standard UU ration.",
		["requirements"] = {
			{"orange" , 1},
			{"oat_cookies", 1},
			{"cold_cooked_meat", 1},
		},
		["result"] = {{"standard_supplement", 1}, {"manufacturing_ticket", 1}}
	},

	["b_bleach"] = {
		["name"] = "Schematic: Bleach",
		["model"] = "models/props_lab/clipboard.mdl",
		["description"] = "A hazard guide to pouring the standard bleaching chemicals.",
		["requirements"] = {
			{"empty_bleach_bottle" , 1},
			{"bleach_chemical_1", 1},
		},
		["result"] = {{"bleach", 1}, {"manufacturing_ticket", 1}}
	},

	["b_oil"] = {
		["name"] = "Schematic: Oil",
		["model"] = "models/props_lab/clipboard.mdl",
		["description"] = "A hazard guide to pouring cooking oil.",
		["requirements"] = {
			{"empty_oil_bottle" , 1},
			{"oil_packet", 1},
		},
		["result"] = {{"vegetable_oil", 1}, {"manufacturing_ticket", 1}}
	},	

}
for k, v in pairs(BLUEPRINTS) do
	local ITEM = ix.item.Register(k, "base_blueprints", false, nil, true)
	ITEM.name = v.name
	ITEM.base = "base_blueprints"
	ITEM.model = v.model
	ITEM.description = v.description
	ITEM.category = "Schematics"
	ITEM.width = v.width or 1
	ITEM.height = v.height or 1
	ITEM.requirements = v.requirements
	ITEM.result = v.result
function ITEM:PopulateTooltip(tooltip)
	local titletip = tooltip:AddRow("title")
	titletip:SetBackgroundColor(derma.GetColor("Info", tooltip))
	titletip:SetText("Requirements")
	titletip:SetExpensiveShadow(0.25)
	titletip:SizeToContents()
	for k2, v2 in pairs(self.requirements) do
		local inv = self.invID
		local inv2 = ix.item.inventories[inv]
		local id = ix.item.Get(v2[1])
		local warning = tooltip:AddRow("requirements")
		if inv2:HasItem(v2[1]) then
			warning:SetBackgroundColor(derma.GetColor("Success", tooltip))
		else
			warning:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		end
		warning:SetText(id.name .. " (" .. v2[2] .. "x)")
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

end