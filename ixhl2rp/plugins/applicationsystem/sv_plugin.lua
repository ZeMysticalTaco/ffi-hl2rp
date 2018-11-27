local PLUGIN = PLUGIN

--[[-------------------------------------------------------------------------
If there's ever an exploit where messages are popping up on people's screens, this is where it is.
---------------------------------------------------------------------------]]
--[[netstream.Hook("SubmitApplication", function(ply, data)
	local cp_apps = PLUGIN.ApplicationsCP

	--the table that is being added into the existing save has to be double bracket so that it creates a new entry into the table and preserves keyvalues
	-- this is a LOT of data
	local organize = {
		{
			["name"] = data[1],
			["cid"] = data[2],
			["referral"] = data[3],
			["why"] = data[4],
			["story"] = data[5],
			["skills"] = data[6],
			["relocation"] = data[7],
			["family"] = data[8],
			["employment"] = data[9],
			["date"] = data[11],
			["steamid"] = data[12],
			["char_id"] = data[13]
		}
	}

	table.Add(cp_apps, organize)
end)--]]
function PLUGIN:CharacterLoaded(char)
	if SERVER then
		local query = mysql:Select("ix_applications")
		query:Select("response")
		query:Select("name")
		query:Select("seen")
		query:Select("app_id")
		--query:Select("accepted")
		query:Where("char_id", char:GetID())
		query:Where("seen", "false")

		query:Callback(function(results)
			if results and #results > 0 then
				PrintTable(results)

				if not tobool(results["seen"]) then
					for k, v in pairs(results) do
						if string.len(v["response"]) > 1 then
							local isaccepted = v["response"]

							if isaccepted == "!true" then
								isaccepted = true
							end

							netstream.Start(char.player, "ApplicationPlayerResponse", {v["response"], false, isaccepted, v["name"], v["app_id"]}) --change third data variable to accepted column later when adding acceptance, change field 2 to false
							print(isaccepted)
							print("Response OK")
							char:SetData("applicationopen", false)
						end
					end
				end
			end
		end)

		query:Execute()
	end
end

--PrintTable(cp_apps)
netstream.Hook("ApplicationResponse", function(ply, data)
	local appinfo = data[2]
	local reason = data[1]
	local test = appinfo["appinfo"]
	local jsondata

	for k, v in pairs(player.GetAll()) do
		print(appinfo.steamid)

		if v:SteamID64() == appinfo.steamid then
			local isaccepted = data[1]
			print("response:" ..test["response"])
			if isaccepted == "!true" then
				isaccepted = true
				print("appresponse")
			end
			print("appresponse")
			print(isaccepted)
			netstream.Start(v, "ApplicationPlayerResponse", {reason, true, isaccepted, test["name"], test["app_id"]})
			v:GetCharacter():SetData("applicationopen", false)
		end

		--("Your application has received a response: " .. reason)
		--v["response"], false, isaccepted, v["name"], v["app_id"

	end

	--print(test["app_id"])
	--PrintTable(appinfo)
	local query = mysql:Update("ix_applications")
	query:Update("response", reason)
	query:Where("app_id", test["app_id"])

	query:Callback(function(result, status, lastID)
		print("Response OK")
	end)

	query:Execute()
end)
--PrintTable(ply:GetCharacter().ixData)
--the callback once the query is completed, argument is a table of what it brings back
--end
--test
function PLUGIN:DatabaseConnected()
	--create tables
	local query
	query = mysql:Create("ix_applications")
	query:Create("app_id", "INT AUTO_INCREMENT")
	query:Create("name", "VARCHAR(128) NOT NULL")
	query:Create("cid", "VARCHAR(6) NOT NULL")
	query:Create("referral", "TEXT")
	query:Create("why", "VARCHAR(600) DEFAULT NULL")
	query:Create("story", "VARCHAR(1500) DEFAULT NULL")
	query:Create("skills", "TEXT")
	query:Create("relocation", "TEXT")
	query:Create("family", "TEXT")
	query:Create("employment", "TEXT")
	query:Create("date", "TEXT")
	query:Create("steamid", "TEXT")
	query:Create("char_id", "TEXT")
	query:Create("response", "TEXT")
	query:Create("seen", "TEXT")
	query:PrimaryKey("app_id")
	query:Execute()
	--print("created")
end

netstream.Hook("SubmitApplication", function(ply, data)
	if ply:GetCharacter():GetData("applicationopen", false) == true then
		ply:Notify("You cannot submit another application while you already have one open!")

		return
	end

	local cp_apps = PLUGIN.ApplicationsCP
	--the table that is being added into the existing save has to be double bracket so that it creates a new entry into the table and preserves keyvalues
	-- this is a LOT of data
	--PrintTable(data)

	local organize = {
		["name"] = data[1],
		["cid"] = data[2],
		["referral"] = data[3],
		["why"] = data[4],
		["story"] = data[5],
		["skills"] = data[6],
		["relocation"] = data[7],
		["family"] = data[8],
		["employment"] = data[9],
		["date"] = data[11],
		["steamid"] = data[12],
		["char_id"] = data[13]
	}
	local Timestamp = os.time()
	local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )
	local query = mysql:Insert("ix_applications")
	query:Insert("name", organize["name"])
	query:Insert("cid", organize["cid"])
	query:Insert("referral", organize["referral"])
	query:Insert("why", organize["why"])
	query:Insert("story", organize["story"])
	query:Insert("skills", organize["skills"])
	query:Insert("relocation", organize["relocation"])
	query:Insert("family", organize["family"])
	query:Insert("employment", organize["employment"])
	query:Insert("date", TimeString)
	query:Insert("steamid", organize["steamid"])
	query:Insert("char_id", organize["char_id"])
	query:Insert("response", "")
	query:Insert("seen", "false")

	query:Callback(function(result, status, lastID)
		--print("Response OK")
		ply:GetCharacter():SetData("applicationopen", true)
	end)

	query:Execute()
	ix.log.AddRaw(ply:Name() .. " has submitted an application.")
end)

netstream.Hook("ApplicationSeen", function(ply, data)
	if data[1] == "cp" then
		if data[2] == true then
		local Timestamp = os.time()
		local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )
		local str = "Name: " .. data[4] .. "\nIssue Date: " .. TimeString
		local data2 = {
		["application"] = str
	}
	local inv = ply:GetCharacter():GetInventory()
	inv:Add("acceptance_paper", 1, data2)
		end
	end
	--print("test")
	local query = mysql:Update("ix_applications")
	query:Update("seen", "true")
	query:Where("app_id", data[3])
	query:Execute()
	ix.log.AddRaw(ply:Name() .. " has seen their applications' response.")
end)
--table.Add(cp_apps, organize)