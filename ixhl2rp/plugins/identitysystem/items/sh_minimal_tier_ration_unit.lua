ITEM.name = "Minimal Tier Ration Unit"
ITEM.model = "models/pg_plops/pg_food/pg_tortellinan.mdl"
ITEM.description = "A Minimal Tier Ration Unit, designed to subsidize you until the next ration cycle."

ITEM.functions.Open = {
	name = "Open",
	OnRun = function(item)
		local char = item.player:GetCharacter()
		local inv = char:GetInventory()
		inv:Add("minimal_supplements", 1)
		item.player:EmitSound("physics/cardboard/cardboard_cup_impact_hard1.wav")
	end
}