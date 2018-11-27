
FACTION.name = "Civil Workers Union"
FACTION.description = "A regular human citizen enslaved by the Universal Union."
FACTION.color = Color(150, 125, 100, 255)
FACTION.models = {"models/tnb/citizens/aphelion/male_09.mdl", "models/tnb/citizens/aphelion/male_16.mdl", "models/tnb/citizens/aphelion/female_11.mdl","models/tnb/citizens/aphelion/female_10.mdl"}
for i = 1, 5 do
	table.insert(FACTION.models, "models/tnb/citizens/aphelion/female_0"..i..".mdl")
end

for i = 8, 9 do
	table.insert(FACTION.models, "models/tnb/citizens/aphelion/female_0"..i..".mdl")
end

for i = 1, 7 do
	table.insert(FACTION.models, "models/tnb/citizens/aphelion/male_0"..i..".mdl")
end

function FACTION:OnCharacterCreated(client, character)
	local id = Schema:ZeroNumber(math.random(1, 99999), 5)
	local inventory = character:GetInventory()
	local Timestamp = os.time()
	local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )

	character:SetData("cid", id)

	inventory:Add("suitcase", 1)
	inventory:Add("cid", 1, {
		["citizen_name"] = character:GetName(),
		["cid"] = id,
		["issue_date"] = TimeString,
		["cwu"] = true,
		["associated_character"] = character:GetID(),
		["worker_id"] = math.random(0, 100)
	})
end

FACTION_CWU = FACTION.index
