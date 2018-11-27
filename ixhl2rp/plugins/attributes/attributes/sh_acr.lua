ATTRIBUTE.name = "Acrobatics"
ATTRIBUTE.description = "Affects how high you can jump."

function ATTRIBUTE:OnSetup(client, value)
	client:SetJumpPower(200 + value / 2)
end
