
FACTION.name = "Metropolice Force"
FACTION.description = "A metropolice unit working as Civil Protection."
FACTION.color = Color(50, 100, 150)
--FACTION.pay = 10
FACTION.models = {}
FACTION.weapons = {"ix_stunstick"}
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.runSounds = {[0] = "NPC_MetroPolice.RunFootstepLeft", [1] = "NPC_MetroPolice.RunFootstepRight"}

for i = 1, 9 do
	table.insert(FACTION.models, "models/police/c18_police_male_0"..i..".mdl")
end

for i = 1, 4 do
	table.insert(FACTION.models, "models/police/c18_police_female_0"..i..".mdl")
end

for i = 6, 7 do
	table.insert(FACTION.models, "models/police/c18_police_female_0"..i..".mdl")
end

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()
	local str = "UUCP-"..math.random(00000,99999) .. "-" .. math.random(00000,99999) .. "://JFK"
	local Timestamp = os.time()
	local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )
	inventory:Add("pistol", 1)
	inventory:Add("pistolammo", 2)
	inventory:Add("cid", 1, {
		["citizen_name"] = character:GetName(),
		["service_number"] = str,
		["cid"] = str,
		["issue_date"] = TimeString,
		["cca"] = true,
		["associated_character"] = character:GetID()
	})
	inventory:Add("metropolice_mask", 1)
	character:SetMoney(500)
end

function FACTION:GetDefaultName(client)
	return "CCA:c18.RT." .. Schema:ZeroNumber(math.random(1, 999), 3), true
end

function FACTION:OnTransfered(client)
	local character = client:GetCharacter()

	character:SetName(self:GetDefaultName())
	character:SetModel(self.models[1])
end

function FACTION:OnNameChanged(client, oldValue, value)
	local character = client:GetCharacter()

	if (!Schema:IsCombineRank(oldValue, "RT") and Schema:IsCombineRank(value, "RT")) then
		character:JoinClass(CLASS_MPR)
	elseif (!Schema:IsCombineRank(oldValue, "OfC") and Schema:IsCombineRank(value, "OfC")) then
		character:SetModel("models/policetrench.mdl")
	elseif (!Schema:IsCombineRank(oldValue, "EpU") and Schema:IsCombineRank(value, "EpU")) then
		character:JoinClass(CLASS_EMP)

		character:SetModel("models/leet_police2.mdl")
	elseif (!Schema:IsCombineRank(oldValue, "DvL") and Schema:IsCombineRank(value, "DvL")) then
		character:SetModel("models/eliteshockcp.mdl")
	elseif (!Schema:IsCombineRank(oldValue, "SeC") and Schema:IsCombineRank(value, "SeC")) then
		character:SetModel("models/sect_police2.mdl")
	elseif (!Schema:IsCombineRank(oldValue, "SCN") and Schema:IsCombineRank(value, "SCN")
	or !Schema:IsCombineRank(oldValue, "SHIELD") and Schema:IsCombineRank(value, "SHIELD")) then
		character:JoinClass(CLASS_MPS)

		Schema:CreateScanner(client, Schema:IsCombineRank(client:Name(), "SHIELD") and "npc_clawscanner" or nil)
	end

	if (!Schema:IsCombineRank(oldValue, "GHOST") and Schema:IsCombineRank(value, "GHOST")) then
		character:SetModel("models/eliteghostcp.mdl")
	end
end

FACTION_MPF = FACTION.index
