ITEM.name = "Transfer Card"
ITEM.model = Model("models/dorado/tarjeta3.mdl")
ITEM.description = "A piece of paper, indicating your new transfer status."

function ITEM:GetDescription()
	return self.description
end
function ITEM:PopulateTooltip(tooltip)
	local data = tooltip:AddRow("data")
	data:SetBackgroundColor(derma.GetColor("Success", tooltip))
	data:SetText("Name: " .. self:GetData("citizen_name", "Unissued") .. "\nTransfer Number: " .. self:GetData("unique", "00000") .. "\nIssue Date: " .. self:GetData("issue_date", "Unissued"))
	data:SetFont("BudgetLabel")
	data:SetExpensiveShadow(0.5 )
	data:SizeToContents()

	local data2 = tooltip:AddRow("data2")
	data2:SetBackgroundColor(derma.GetColor("Warning", tooltip))
	data2:SetText("Take these papers to a CCA officer, to receive a CID in return. THIS IS NOT VALID IDENTIFICATION.")
	data2:SetFont("DermaDefault")
	data2:SetExpensiveShadow(0.5)
	data2:SizeToContents()



end