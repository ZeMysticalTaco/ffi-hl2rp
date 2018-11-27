ITEM.name = "Manufacturing Ticket"
ITEM.price = 100
ITEM.description = "A Manufacturing Ticket for completing a manufacturing job."
ITEM.model = "models/dorado/tarjeta4.mdl"

function ITEM:PopulateTooltip(tooltip)
	local tt = tooltip:AddRow("tt")
	tt:SetText("Turn this ticket into a Civil Worker or CCA Officer to receive a monetary reward.")
	tt:SizeToContents()
	tt:SetBackgroundColor(derma.GetColor("Info", tooltip))
end

ITEM.functions.Reigster = {
	name = "Register",
	OnRun = function(item)
		item.player:GetCharacter():GiveMoney(20)
		item.player:Notify("You have registered this Manufacturing Ticket, and have received money from it, give the person who gave it to you an amount of it.")
	end,
	OnCanRun = function(item)
		return item.player:IsCombine() or item.player:Team() == FACTION_CWU
	end
}