
ITEM.name = "Percocet 20mg"
ITEM.model = Model("models/props_junk/garbage_metalcan002a.mdl")
ITEM.description = "A small tin of Percoet Painkillers, 20mg."
ITEM.category = "Medical"
ITEM.price = 65

ITEM.functions.Apply = {
	sound = "items/medshot4.wav",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 20, 100))
	end
}
