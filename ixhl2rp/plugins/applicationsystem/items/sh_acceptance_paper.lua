ITEM.name = "Application Acceptance Notification"
ITEM.model = Model("models/gibs/metal_gib4.mdl")
ITEM.description = "A letter, it has a Union Logo on it. It appears to be an acceptance letter for the CCA."

function ITEM:GetDescription()
	return self.description .. "\n" .. self:GetData("application", "n")
end

function ITEM:PopulateTooltip(tooltip)
	--[[local data = tooltip:AddRow("data")
	data:SetBackgroundColor(derma.GetColor("Success", tooltip))
	data:SetText("Name: " .. self:GetData("citizen_name", "Unissued") .. "\nID Number: " .. self:GetData("cid", "00000") .. "\nIssue Date: " .. self:GetData("issue_date", "Unissued"))
	data:SetFont("BudgetLabel")
	data:SetExpensiveShadow(0.5 )
	data:SizeToContents()--]]

	local warning = tooltip:AddRow("warning")
	warning:SetBackgroundColor(derma.GetColor("Success", tooltip))
	warning:SetText("Turn this letter into an officer, who will direct you to a senior officer for an interview, if one is not avaialble, please be patient and wait for one. It's in your best interest not to lose this paper.")
	warning:SetFont("DermaDefault")
	warning:SetExpensiveShadow(0.5 )
	warning:SizeToContents()


end