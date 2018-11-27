PLUGIN.name = "Identity System"
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.description = "A comprehensive identity system to allow for deeper espionage roleplay."
ix.util.Include("cl_panels.lua")
ix.util.Include("sv_plugin.lua")

ix.command.Add("ViewData", {
	arguments = ix.type.number,
	description = "View the data of a CID.",
	OnRun = function(self, client, cid)
		--TODO: Add offline viewing.
		for k, v in pairs(ix.item.instances) do
			if v:GetData("cid", 000000) == cid then
				netstream.Start(client, "OpenRecordMenu", {v.id})

				return
			else
				local query = mysql:Select("ix_items")
				query:Select("data")
				query:Where("cid", cid)
				query:Callback(function(results) 
					PrintTable(results)
				end)
			end
		end
	end
})

if CLIENT then
	--vgui.Create("ixRecordPanel")
	netstream.Hook("OpenRecordMenu", function(data)
		vgui.Create("ixRecordPanel")
		ix.gui.cidview:SetItem(ix.item.instances[data[1]])
	end)

	netstream.Hook("OpenCIDMenu", function(data)
		vgui.Create("ixCIDCreater")
	end)

	netstream.Hook("LoyaltyOpen", function(data)
		local ui = vgui.Create("ixLoyalty")
		ui.ent = data[1]
	end)
else
	netstream.Hook("IDAddRecord", function(ply, data)
		local item = ix.item.instances[data[4]]
		local before_data = item:GetData("record", {})
		local inbetween_data = {{data[1], data[2], data[3], data[5]}}
		table.Add(before_data, inbetween_data)
		item:SetData("record", before_data)
		item:SetData("points", item:GetData("points", 0) + data[5])
		ix.log.AddRaw(ply:Name() .. " has added a record to ID " .. item:GetID())
	end)

	netstream.Hook("IDRemoveRecord", function(ply, data)
		local item = ix.item.instances[data[4]]
		local before_data = item:GetData("record", {})
		before_data[data[5]] = nil
		item:SetData("record", before_data)
		ix.log.AddRaw(ply:Name() .. " has removed a record from ID " .. item:GetID())
	end)

	netstream.Hook("SubmitNewCID", function(ply, data)
		if ply:IsCombine() then
			local char = ply:GetCharacter()
			local inv = char:GetInventory()
			local Timestamp = os.time()
			local TimeString = os.date("%H:%M:%S - %d/%m/%Y", Timestamp)

			local data2 = {
				["citizen_name"] = data[1],
				["cid"] = math.random(10000, 99999),
				["issue_date"] = TimeString,
				["officer"] = ply:Name()
			}

			inv:Add("cid", 1, data2)
			ply:EmitSound("buttons/button14.wav", 100, 25)
			ply:ForceSequence("harassfront1")
			ix.log.AddRaw(ply:Name() .. " has created a new CID with the name " .. data[1])
		end
	end)
end

STORED_LOYALTY = {}

function PLUGIN:AddLoyaltyItem(name, model, desc, results, id, cooldown, data)
if type(name) ~= "table" then
		local LOYALTY = {}
		LOYALTY["id"] = id --Unique ID of the recipe.
		LOYALTY["name"] = name -- Name of the recipe.
		LOYALTY["model"] = model -- Model it uses in the menu.
		LOYALTY["desc"] = desc -- Description of what it is.
		LOYALTY["results"] = results --Results of the craft (use item id's)
		LOYALTY["cooldown"] = cooldown
		LOYALTY["data"] = data or {}
		STORED_LOYALTY[id] = LOYALTY
	else
		local LOYALTY = {}
		LOYALTY["id"] = id --Unique ID of the recipe.
		LOYALTY["name"] = name -- Name of the recipe.
		LOYALTY["model"] = model -- Model it uses in the menu.
		LOYALTY["desc"] = desc -- Description of what it is.
		LOYALTY["results"] = results --Results of the craft (use item id's)
		LOYALTY["cooldown"] = cooldown
		LOYALTY["data"] = data or {}
		STORED_LOYALTY[id] = LOYALTY
	end

end

local BUILD_LOYALTY = {
	["metropolice_wages"] = {
		["name"] = "Metropolice Wages",
		["model"] = "models/props_lab/box01b.mdl",
		["desc"] = "Better-than standard wages, the metropolice wages.",
		["results"] = {["tokens"] = 125},
		["cooldown"] = 600,
		["data"] = {
			["disables"] = {"tokens"},
			["factions"] = {FACTION_MPF}
		}
	},
	["metropolice_ration"] = {
		["name"] = "Metropolice Supplement Unit",
		["model"] = "models/weapons/w_packatm.mdl",
		["desc"] = "A standard pack of metropolice rations.",
		["results"] = {["metropolice_ration"] = 1},
		["cooldown"] = 1200,
		["data"] = {
			["disables"] = {"minimaltier"},
			["factions"] = {FACTION_MPF}
		}
	}
}

for k,v in pairs(BUILD_LOYALTY) do
	PLUGIN:AddLoyaltyItem(v.name, v.model, v.desc, v.results, k, v.cooldown, v.data)
end

--Example: PLUGIN:AddRecipe("Bag of Clothes". "models/props_c17/BriefCase001a.mdl", "This is a bag of clothes, made from cloth.", {["cloth"] = 7}, {["bag_of_clothes"] = 1}, "bagofclothes")
PLUGIN:AddLoyaltyItem("Okoa Clothing Suite", "models/weapons/w_packate.mdl", "Originally designed and distributed as a memorial wear for the passing of Marcus Okoa, the well-liked administrator of City 11, the Okoa Memorial Clothing is still loved today, as it is a comfortable linen product.", {
	["Okoa_Clothing_Suite"] = 1
}, "okoaclothes", 12000)

PLUGIN:AddLoyaltyItem("Green Clothing Suite", "models/weapons/w_packate.mdl", "A summer variant of the legacy garb, in Summer 2017, these were distributed as the standard wear, they are still available as an optional choice.", {
	["Green_Clothing_Suite"] = 1
}, "greenclothes", 12000)

PLUGIN:AddLoyaltyItem("Legacy Clothing Suite", "models/weapons/w_packate.mdl", "Designed by Marvin Specht, the legacy style is still popular among those who enjoy a darker blue.", {
	["Legacy_Clothing_Suite"] = 1
}, "legacyclothes", 12000)

PLUGIN:AddLoyaltyItem("Minimal Tier Ration Unit", "models/pg_plops/pg_food/pg_tortellinan.mdl", "The Minimal Tier Ration Unit is a package designed to subsidize Citizens until the next standard cycle.", {
	["minimal_tier_ration_unit"] = 1
}, "minimaltier", 1200)

PLUGIN:AddLoyaltyItem("Legacy Clothing Suite", "models/weapons/w_packate.mdl", "Designed by Marvin Specht, the legacy style is still popular among those who enjoy a darker blue.", {
	["Legacy_Clothing_Suite"] = 1
}, "legacyclothes", 12000)

PLUGIN:AddLoyaltyItem("Standard Clothing Suite", "models/weapons/w_packate.mdl", "Originally designed by Hatel Johnson, the new standardized clothing has been in use for around a year.", {
	["Standard_Clothing_Suite"] = 1
}, "standardclothes", 12000)

PLUGIN:AddLoyaltyItem("Standard Wages", "models/props_lab/box01b.mdl", "A small box of standard wages, containing 150 tokens.", {
	["tokens"] = 50
}, "tokens", 1200)