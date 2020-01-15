PLUGIN.name = "Item Populator"
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.description = "I wrote a plugin to make items for me."

local clothes_torso = {
	[0] = {"Standard Citizen Clothing", "Originally designed by Hatel Johnson, the new standardized clothing has been in use for around a year.", 1},
	[2] = {"Civil Workers Clothing", "The standard garb worn by the Civil Workers, these contain a label with your CID and your Employee ID.", 1},
	[3] = {"Civil Workers Foreman Clothing", "This is an advanced sew of clothing, made for Civil Workers Foremen, these contain a label with your CID and your Employee ID.", 1},
	[4] = {"Legacy Citizen Clothing", "Designed by Marvin Specht, the legacy style is still popular among those who enjoy a darker blue.", 1},
	[5] = {"Green Citizen Clothing", "A summer variant of the legacy garb, in Summer 2017, these were distributed as the standard wear, they are still available as an optional choice.", 1},
	[6] = {"Okoa Citizen Clothing", "Originally designed and distributed as a memorial wear for the passing of Marcus Okoa, the well-liked administrator of City 11, the Okoa Memorial Clothing is still loved today, as it is a comfortable linen product.", 1},
	[8] = {"Railroad Light Armor Suite", "Designed by the Underground Railroad, this suite is a combination of several items and clothing, most notably, a CCA kevlar vest. This one sports an Underground Railroad logo.", 2},
	[9] = {"Light Armor Suite", "Designed by the Underground Railroad, this suite is a combination of several items and clothing, most notably, a CCA kevlar vest. This one sports an Underground Railroad logo.", 2},
	[10] = {"Railroad Light Armor Suite Zesha", "Designed by the Underground Railroad, this suite is a combination of several items and clothing, most notably, a CCA kevlar vest.\nThe Zesha variant was designed to be more logo bearing, to show support for the movement.", 2},
	[11] = {"Railroad Light Armor Suite Okoa", "Designed by the Underground Railroad, this suite is a combination of several items and clothing, most notably, a CCA kevlar vest.\nOkoa was a fraud, and most people knew it. This look was made by the Railroad to show their disgust towards him.", 2},
	[12] = {"Railroad Light Armor Suite Courier", "Designed by the Underground Railroad, this suite is a combination of several items and clothing, most notably, a CCA kevlar vest.\nThe Couriers of the Underground Railroad are valued, because they bring people in from the outside.", 2},
	[13] = {"Railroad Heavy Armor Suite", "Designed by the Underground Railroad, this suite is a combination of several items and clothing, most notably, an OTA kevlar vest.\nThe vest has the names of several people engraved on it, it's common tradition in the railroad to engrave the names of those who died fighting whoever wore this armor, Overwatch are not to be trifled with.", 2},
	[14] = {"Combine Civil Authority Light Armor", "A standard Combine Civil Authority Vest.", 2},
	[15] = {"Railroad Old World Military Vest", "This set of armor contains an old world military vest.", 2},
	[16] = {"Winter Coat", "Designed by Maxim Toier for the 2015 winter, this well made coat replaces the old variant, which was denim.", 1}
}

for k, v in pairs(clothes_torso) do
	local ITEM = ix.item.Register(string.gsub(v[1], "%s", "_"), nil, false, nil, true)
	ITEM.name = v[1]
	ITEM.model = "models/props_junk/cardboard_box004a.mdl"
	ITEM.description = v[2]

	ITEM.functions.Wear = {
		OnRun = function(item)
			item.player:SetBodygroup(1, k)
			local data = item.player:GetCharacter():GetData("groups", {})
			data[1] = k
			item.player:GetCharacter():SetData("groups", data)
			item:SetData("equip", true)
			
			return false
		end,
		OnCanRun = function(item)
			if item:GetData("equip", false) == false then
				return true
			else
				return false
			end
		end
	}
	ITEM.functions.Remove = {
		OnRun = function(item)
			item.player:SetBodygroup(1, 0)
			local data = item.player:GetCharacter():GetData("groups", {})
			data[1] = 0
			item.player:GetCharacter():SetData("groups", data)
			item:SetData("equip", false)
			
			return false
			
		end,
		OnCanRun = function(item)
			if item:GetData("equip", false) == true then
				return true
			else
				return false
			end

end}

	function ITEM:PopulateTooltip(tooltip)
		if v[3] == 2 then
			local tip = tooltip:AddRow("clothingwarning")
			tip:SetBackgroundColor(derma.GetColor("Error", tooltip))
			tip:SetText("This clothing contains items which are illegal to possess, wearing it and being caught will result with you being arrested and charged.")
			tip:SetFont("DermaDefault")
			tip:SizeToContents()
		end
	end
end

local clothes_legs = {
	[0] = {"Standard Citizen Jeans", "Designed by Hatel Johnson, these jeans were highly requested, they've been woven for comfort and thermal containment, the new standardized clothing has been in use for around a year."},
	[1] = {"Legacy Citizen Jeans", "Designed by Marvin Specht, these jeans were part of the old Civillian wear, complaints arose at a lack of back pockets, which was fixed in the Hatel design."},
	[2] = {"Green Citizen Jeans", "While not green, these jeans were designed by Jeremy Green, and are known for their insane wear rate, with most people wearing them out within a month, it went with the Green Uniform Design."},
	[3] = {"Okoa Citizen Jeans", "Originally designed and distributed as a memorial wear for the passing of Marcus Okoa, the well-liked administrator of City 11, the Okoa Memorial Clothing is still loved today, for it's legendary comfort and life time."},
	[4] = {"Railroad Modified Green Jeans", "Designed by the Railroad, these jeans contain light padding for use of skidding across surfaces in an emergency."},
	[5] = {"Railroad Modified Blue Jeans", "Designed by the Railroad, these jeans contain light padding for use of skidding across surfaces in an emergency."},
	[6] = {"Black Citizen Slacks", "Designed by Marcus Okoa himself, the Black Citizen Slacks were designed for comfort and formal events, but eventually became an available wear because of the unique comfort they provide."}
}

for k, v in pairs(clothes_legs) do
	local ITEM = ix.item.Register(string.gsub(v[1], "%s", "_"), nil, false, nil, true)
	ITEM.name = v[1]
	ITEM.model = "models/props_junk/cardboard_box004a.mdl"
	ITEM.description = v[2]

	ITEM.functions.Wear = {
		OnRun = function(item)
			item.player:SetBodygroup(2, k)
			local data = item.player:GetCharacter():GetData("groups", {})
			data[2] = k
			item.player:GetCharacter():SetData("groups", data)
			item:SetData("equip", true)
			
			return false
		end,
		OnCanRun = function(item)
			if item:GetData("equip", false) == false then
				return true
			else
				return false
			end
		end
	}
	ITEM.functions.Remove = {
		OnRun = function(item)
			item.player:SetBodygroup(2, 0)
			local data = item.player:GetCharacter():GetData("groups", {})
			data[2] = 0
			item.player:GetCharacter():SetData("groups", data)
			item:SetData("equip", false)
			
			return false
			
		end,
		OnCanRun = function(item)
			if item:GetData("equip", false) == true then
				return true
			else
				return false
			end

end}
end

local ITEM = ix.item.Register("gloves", nil, false, nil, true)
ITEM.name = "Gloves"
ITEM.model = "models/props_junk/cardboard_box004a.mdl"
ITEM.description = "A set of generic gloves."

ITEM.functions.Wear = {
	OnRun = function(item)
	item.player:SetBodygroup(3, 1)
	local data = item.player:GetCharacter():GetData("groups", {})
	data[3] = 1
	item.player:GetCharacter():SetData("groups", data)
	item:SetData("equip", true)
	return false
end,
		OnCanRun = function(item)
			if item:GetData("equip", false) == false then
				return true
			else
				return false
			end
		end
}

	ITEM.functions.Remove = {
		OnRun = function(item)
			item.player:SetBodygroup(3, 0)
			local data = item.player:GetCharacter():GetData("groups", {})
			data[3] = 0
			item.player:GetCharacter():SetData("groups", data)
			item:SetData("equip", false)
			
			return false
			
		end,
		OnCanRun = function(item)
			if item:GetData("equip", false) == true then
				return true
			else
				return false
			end

end}

//TODO: POPULATE BEANIES
//TODO: POPULATE LOYALTY KIOSK ITEMS
//TODO: POPULATE LORE ITEMS		
local clothes_head = {
	[1] = {"Bandana", "A small red wrapped bandana, in relatively good condition, there appears to be some dirt and tears here and there.", 1},
	[2] = {"Respiratory Mask", "A non-functioning worn respiratory mask, in relatively good condition, but there appear to be some cracks here and there.", 1},
	[3] = {"Beanie", "A wool beanie, issued to Civillians in cool weather."},
	[4] = {"Green Beanie", "A wool beanie, issued to Civillians in cool weather."}
}

for k, v in pairs(clothes_head) do
	local ITEM = ix.item.Register(string.gsub(v[1], "%s", "_"), nil, false, nil, true)
	ITEM.name = v[1]
	ITEM.model = "models/props_junk/cardboard_box004a.mdl"
	ITEM.description = v[2]

	ITEM.functions.Wear = {
		OnRun = function(item)
			item.player:SetBodygroup(4, k)
			local data = item.player:GetCharacter():GetData("groups", {})
			data[4] = k
			item.player:GetCharacter():SetData("groups", data)
			item:SetData("equip", true)
			return false
		end,
		OnCanRun = function(item)
			if item:GetData("equip", false) == false then
				return true
			else
				return false
			end
		end
}
	ITEM.functions.Remove = {
		OnRun = function(item)
			item.player:SetBodygroup(4, 0)
			local data = item.player:GetCharacter():GetData("groups", {})
			data[4] = 0
			item.player:GetCharacter():SetData("groups", data)
			item:SetData("equip", false)
			
			return false
			
		end,
		OnCanRun = function(item)
			if item:GetData("equip", false) == true then
				return true
			else
				return false
			end

end}
	function ITEM:PopulateTooltip(tooltip)
		if v[3] then
			local tip = tooltip:AddRow("clothingwarning")
			tip:SetBackgroundColor(derma.GetColor("Error", tooltip))
			tip:SetText("It is considered illegal to cover your face in a mask, wearing this item and being seen wearing may result in being charged.")
			tip:SetFont("DermaDefault")
			tip:SizeToContents()
		end
	end
end


local clothes_packages = {
	[1] = {"Okoa Clothing Suite", "This package contains clothing from the Okoa design family, the contents can't be seen. The Package is shrink-wrapped and has a release fold at the top.", "models/weapons/w_packate.mdl", {["Okoa_Citizen_Clothing"] = 1, ["Okoa_Citizen_Jeans"] = 1}},
	[2] = {"Standard Clothing Suite", "This package contains clothing from the Sandardized family, the contents can't be seen. The Package is shrink-wrapped and has a release fold at the top.", "models/weapons/w_packate.mdl", {["Standard_Citizen_Clothing"] = 1, ["Standard_Citizen_Jeans"] = 1}},
	[3] = {"Legacy Clothing Suite", "This package contains clothing from the Legacy design family, the contents can't be seen. The Package is shrink-wrapped and has a release fold at the top.", "models/weapons/w_packate.mdl", {["Legacy_Citizen_Clothing"] = 1, ["Legacy_Citizen_Jeans"] = 1}},
	[4] = {"Green Clothing Suite", "This package contains clothing from the Okoa design family, the contents can't be seen. The Package is shrink-wrapped and has a release fold at the top.", "models/weapons/w_packate.mdl", {["Green_Citizen_Clothing"] = 1, ["Green_Citizen_Jeans"] = 1}}


}

for k, v in pairs(clothes_packages) do
	local ITEM = ix.item.Register(string.gsub(v[1], "%s", "_"), nil, false, nil, true)
	ITEM.name = v[1]
	ITEM.model = v[3]
	ITEM.description = v[2]

	ITEM.functions.Open = {
		OnRun = function(item)
			for k2, v2 in pairs(v[4]) do
				item.player:GetCharacter():GetInventory():Add(k2)
			end
	end}
end
--[[-------------------------------------------------------------------------
	Below are LUA Generated items that needed to be added on the fly.
---------------------------------------------------------------------------]]
--Railroad Coin

local ITEM = ix.item.Register("railroad_coin", nil, false, nil, true)
ITEM.name = "Railroad Coin"
ITEM.model = "models/bioshockinfinite/hext_coin.mdl"
ITEM.description = "A pristine coin, manufactured by the Underground Railroad for the sole purpose of unique trading."

--Metropolice Ration
local ITEM = ix.item.Register("metropolice_ration", nil, false, nil, true)
ITEM.name = "Metropolice Ration Unit"
ITEM.model = "models/weapons/w_packatm.mdl"
ITEM.description = "A large wrapped packet, filled with goodies for Metropolice Units."

ITEM.functions.Open = {
	name = "Open",
	OnRun = function(item)
		local char = item.player:GetCharacter()
		local inv = char:GetInventory()
		inv:Add("standard_hydration_pack", 2)
		inv:Add("standard_supplement", 2)
		item.player:EmitSound("physics/cardboard/cardboard_cup_impact_hard1.wav")
	end
}

local ITEM = ix.item.Register("backpack", "base_bags", false, nil, true)
ITEM.name = "Backpack"
ITEM.model = "models/props_junk/cardboard_box001a.mdl"
ITEM.description = "A large... backpack?"
ITEM.invWidth = 6
ITEM.invHeight = 4
ITEM.width = 2
ITEM.height = 2
