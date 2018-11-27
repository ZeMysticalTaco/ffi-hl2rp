--TODO: POPULATE CRAFTING ITEMS AND RECIPES
PLUGIN.name = "Crafting"
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.desc = "Replacing the business menu with crafting because that's a more sensible thing to do."
STORED_RECIPES = {}

function PLUGIN:AddRecipe(name, model, desc, requirements, results, id, skill, blueprint, guns, entity, category)
	if type(name) ~= "table" then
		local RECIPE = {}
		RECIPE["id"] = id --Unique ID of the recipe.
		RECIPE["name"] = name -- Name of the recipe.
		RECIPE["model"] = model -- Model it uses in the menu.
		RECIPE["desc"] = desc -- Description of what it is.
		RECIPE["req"] = requirements --Requirements to craft it(use item id's)
		RECIPE["results"] = results --Results of the craft (use item id's)
		RECIPE["blueprint"] = blueprint or false
		RECIPE["guns"] = guns or false
		RECIPE["entity"] = entity or false
		RECIPE["category"] = category or "Miscellaneous"

		if skill then
			RECIPE["skill"] = skill
		end

		STORED_RECIPES[id] = RECIPE
	else
		for k, v in pairs(name) do
		RECIPE["id"] = k --Unique ID of the recipe.
		RECIPE["name"] = v.name -- Name of the recipe.
		RECIPE["model"] = v.model -- Model it uses in the menu.
		RECIPE["desc"] = v.desc -- Description of what it is.
		RECIPE["req"] = v.requirements --Requirements to craft it(use item id's)
		RECIPE["results"] = v.results --Results of the craft (use item id's)
		RECIPE["blueprint"] = v.blueprint or false
		RECIPE["guns"] = v.guns or false
		RECIPE["entity"] = v.entity or false
		RECIPE["category"] = v.category or "Miscellaneous"

		end
	end
end
--[[-------------------------------------------------------------------------
TODO: For release, demonstrate full capacity of plugin.
---------------------------------------------------------------------------]]
local NEW_RECIPES = {
	["metal_downgrade_reclaimed"] = {
		["name"] = "Breakdown: Reclaimed Metal",
		["model"] = "models/props_c17/oildrumchunk01d.mdl",
		["desc"] = "Break down Reclaimed Metal into Scrap Metal.",
		["requirements"] = {["reclaimed_metal"] = 1, ["scrap_hammer"] = 1},
		["results"] = {["scrap_metal"] = 2},
		["category"] = "Metal Breakdown"
	},
	["metal_downgrade_refined"] = {
		["name"] = "Breakdown: Refined Metal",
		["model"] = "models/props_c17/canisterchunk02a.mdl",
		["desc"] = "Break down Refined Metal into Reclaimed Metal.",
		["requirements"] = {["refined_metal"] = 1, ["scrap_hammer"] = 1},
		["results"] = {["reclaimed_metal"] = 2},
		["category"] = "Metal Breakdown",
	},
	["metal_upgrade_battered"] = {
		["name"] = "Metal Combination: Battered Scrap",
		["model"] = "models/props_debris/metal_panelchunk02d.mdl",
		["desc"] = "Combine existing Battered Scrap to make a couple pieces of Scrap Metal.",
		["requirements"] = {["battered_scrap"] = 4},
		["results"] = {["scrap_metal"] = 2},
		["category"] = "Metal Upgrade",
	},
	["metal_upgrade_charred"] = {
		["name"] = "Metal Combination: Battered Scrap",
		["model"] = "models/props_debris/rebar001a_32.mdl",
		["desc"] = "Combine existing Charred Metal to make a couple pieces of Battered Metal.",
		["requirements"] = {["burned_metal"] = 5},
		["results"] = {["battered_scrap"] = 3},
		["category"] = "Metal Upgrade",
	}
}

for k, v in pairs(NEW_RECIPES) do
	PLUGIN:AddRecipe(v.name, v.model, v.desc, v.requirements, v.results, k, v.skill or nil, v.blueprint or nil, v.guns or nil, v.entity or nil, v.category or "Miscellaneous")
end

--[[-------------------------------------------------------------------------
LEGACY WAY TO ADD RECIPES DO NOT USE ANYMORE
TODO: Convert these to the new system.
---------------------------------------------------------------------------]]
PLUGIN:AddRecipe("Metal Combination: Reclaimed", "models/props_c17/oildrumchunk01d.mdl", "Combine existing Scrap Metal to make a Reclaimed Metal piece.", {["scrap_metal"] = 3}, {["reclaimed_metal"] = 1}, "scraptorec", false)
PLUGIN:AddRecipe("Metal Combination: Refined", "models/props_c17/canisterchunk02a.mdl", "Combine existing Reclaimed Metal to make a Refined Metal piece", {["reclaimed_metal"] = 3}, {["refined_metal"] = 1}, "rectoref", false)
PLUGIN:AddRecipe("Breakdown: Locker Door", "models/props_lab/lockerdoorleft.mdl", "Break down a Locker Door to get several pieces of Scrap Metal.", {["scrap_hammer"] = 1,["locker_door"] = 1}, {["scrap_metal"] = 5}, "doortoscrap", false )
PLUGIN:AddRecipe("Ammunition: 9MM Ammo", "models/Items/BoxSRounds.mdl", "Create ammunition from spare parts you've found around.", {["empty_ammo_box"] = 1, ["bullet_casings"] = 3, ["scrap_metal"] = 2, ["gunpowder"] = 4}, {["pistolammo"] = 1}, "ammo9mm", nil, nil, nil, true)
PLUGIN:AddRecipe("Ammunition: SMG Ammo", "models/Items/BoxMRounds.mdl", "Create ammunition from spare parts you've found around.", {["empty_ammo_box"] = 2, ["bullet_casings"] = 5, ["scrap_metal"] = 4, ["gunpowder"] = 6}, {["smg1ammo"] = 1}, "ammosmg", {["guns"] = 2}, nil, nil, true)
PLUGIN:AddRecipe("Weapon: 9MM Pistol", "models/weapons/w_pistol.mdl", "Create ammunition from spare parts you've found around.", {["scrap_metal"] = 4, ["scrap_screwdriver"] = 1, ["refined_metal"] = 2, ["reclaimed_metal"] = 1}, {["pistol"] = 1}, "gunpistol", {["guns"] = 5}, nil, nil, true)
PLUGIN:AddRecipe("Breakdown: Wooden Plank", "models/props_debris/wood_board06a.mdl", "Break down a Plank of Wood to get some pieces.", {["plank"] = 1}, {["wood_piece"] = 5}, "planktowood", false )
PLUGIN:AddRecipe("Tool: Scrap Hammer", "models/props_interiors/pot02a.mdl", "Fashion a crude hammer for use in building.", {["wood_piece"] = 2, ["scrap_metal"] = 2}, {["scrap_hammer"] = 1}, "hammer", false )
PLUGIN:AddRecipe("Weapon: Crude Axe", "models/props_interiors/pot02a.mdl", "Create a Crude Crowbar from metal you've acquired.", {["refined_metal"] = 4, ["scrap_metal"] = 2, ["wood_piece"] = 4}, {["wooden_axe"] = 1}, "axe", false )
--[[-------------------------------------------------------------------------
Tying in with the 'Citizen Production Plugin', adding schematics for study.
---------------------------------------------------------------------------]]
for k, v in pairs(ix.item.list) do
	if v.category == "Schematics" then
		local tbl = v.requirements
		local tbl2 = v.result
		local req_table_empty = {}
		local res_table_empty = {}
		for k2, v2 in pairs(tbl) do
			req_table_empty[v2[1]] = v2[2]
		end
		for k3,v3 in pairs(tbl2) do
			if v3[1] != "manufacturing_ticket" then
				res_table_empty[v3[1]] = v3[2]
			end
		end
		PLUGIN:AddRecipe(v.name, v.model, v.description .. "\nYou studied this blueprint from the factories.", req_table_empty, res_table_empty, v.uniqueID, false, v.uniqueID)
	end
end

--Example: PLUGIN:AddRecipe("Bag of Clothes". "models/props_c17/BriefCase001a.mdl", "This is a bag of clothes, made from cloth.", {["cloth"] = 7}, {["bag_of_clothes"] = 1}, "bagofclothes")
--[[PLUGIN:AddRecipe("Test", "models/props_c17/BriefCase001a.mdl", "Test", {
	["cid"] = 4
}, {
	["cid"] = 2
}, "test",
{
	["medical"] = 1,
	["end"] = 1}
)

PLUGIN:AddRecipe(
	"no skill",
	"models/props_c17/BriefCase001a.mdl",
	"no skill",
	{["cid"] = 4},
	{["cid"] = 2},
	"test 2",
	false,
	"bluprint1")

PLUGIN:AddRecipe("double gay", "models/props_c17/BriefCase001a.mdl", "no skill", {
	["cid"] = 1,
	["chinese_takeout"] = 1
}, {
	["cid"] = 2,
	["chinese_takeout"] = 2
}, "test 3")

PLUGIN:AddRecipe("Test", "models/props_c17/BriefCase001a.mdl", "Test", {
	["cid"] = 4
}, {
	["cid"] = 2
}, "test", {
	["medical"] = 1,
	["end"] = 1
})--]]
--[[PLUGIN:AddRecipe("blueprint gay", "models/props_c17/BriefCase001a.mdl", "no skill", {
	["cid"] = 1,
	["chinese_takeout"] = 1
}, {
	["cid"] = 2,
	["chinese_takeout"] = 2
}, "test 4", "blueprint1")--]]

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("sh_items.lua")
--[[
This is the 'skill' crafting recipe, which means it requires a skill.
The first argument is the name.
The second argument is the model.
The third is the description.
The fourth is the requirements.
Requirements must be in the form of item id's, you can tell what an item's id is based on what is inbetween sh_ and .lua in an item's file name.
Each argument MUST be separated by a comma.
Requirements MUST be in between brackets.
each item must be separated with a comma AFTER it's number.
the fifth argument is the item identifier, it's a unique id and should be changed for each recipe.
the sixth argument is the skills required, just remove it and it's {} if you don't need it to have a skill.
skill names:
guns - gunsmithing
end - endurance
stm - stamina
med - medical knowledge
eng - engineering
str - strength
acr - acrobatics
last argument is blueprint, don't put one there if there isn't one
]]


--[[PLUGIN:AddRecipe(
	"no skill", --name
	"models/props_c17/BriefCase001a.mdl", --model
	"no skill", --desc
	{["cid"] = 4}, --input items
	{["cid"] = 2}, --receiving items
	"test 2", --id must be unique
	false, --requires stats?
	"bluprint1") --blueprint, put in false if no blueprint

PLUGIN:AddRecipe("Bag of Clothes", "models/props_c17/BriefCase001a.mdl", "This is a bag of clothes, made from cloth.", {
	["cid"] = 7
}, {
	["chinese_takeout"] = 1
}, "bagofclothes", {
	["end"] = 3
})

PLUGIN:AddRecipe("double gay", "models/props_c17/BriefCase001a.mdl", "no skill", {
	["cid"] = 1,
	["chinese_takeout"] = 1
}, {
	["cid"] = 2,
	["chinese_takeout"] = 2
}, "test 3")--]]

ix.command.Add("BlueprintGive", {
	description = "Give a blueprint to a player.",
	adminOnly = true,
	arguments = {ix.type.character, ix.type.string},
	OnRun = function(self, client, target, blueprint)
		local data = target:GetData("blueprints", {})

		if not table.HasValue(data, blueprint) then
			table.insert(data, blueprint)
		else
			client:Notify(target:GetName() .. " already has this blueprint.")

			return
		end

		target:SetData("blueprints", data)
		client:Notify("You have given " .. target:GetName() .. " the blueprint " .. blueprint .. ".")
		target.player:Notify("You have been given the blueprint " .. blueprint .. " by " .. client:Name())
	end
})

ix.command.Add("BlueprintRemove", {
	description = "Give a blueprint to a player.",
	adminOnly = true,
	arguments = {ix.type.character, ix.type.string},
	OnRun = function(self, client, target, blueprint)
		local data = target:GetData("blueprints", {})

		if table.HasValue(data, blueprint) then
			table.RemoveByValue(data, blueprint)
		else
			client:Notify(target:GetName() .. " does not have this blueprint.")
		end

		target:SetData("blueprints", data)
		client:Notify("You have taken " .. target:GetName() .. " the blueprint " .. blueprint .. ".")
		target.player:Notify("You have had the blueprint " .. blueprint .. " taken from you by " .. client:Name())
	end
})