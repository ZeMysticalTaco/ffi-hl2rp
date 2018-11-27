netstream.Hook("ixLoyaltyMachine", function(ply, data, data2)
	--PrintTable(data)
	--print(data2)
	local results = data[1]
	local id = data[2]
	local cooldown = data[3]
	local ent = data[4]
	local item = ix.item.instances[data[5]]
	--print(item)
	local char = ply:GetChar()
	local inv = char:GetInventory()
	local items = inv:GetItems()
	--PrintTable(data)

	if not item then
		ply:Notify("You did not select a CID!")
	end



	if item:GetData("cooldown_"..id, 0) > os.time() then
		print(item:GetData("cooldown_"..id))
		print(os.time())
		ent:DisplayError(4, 2)
		return
	end

	for k, v in pairs(results) do
		if k == "tokens" then
			char:GiveMoney(v)
			char:GetPlayer():Notify("You have received " .. v .. " tokens from the kiosk.")
		else
			ent:StartDispense(k, 2)
		end
		ix.log.AddRaw(ply:Name() .. " has obtained " .. k .. " from a kiosk.")
	end
	if cooldown then
		item:SetData("cooldown_" .. id, os.time() + cooldown)
		print(item:GetData("cooldown_"..id, 0))
		print(os.time())
	end
end)

netstream.Hook("updatecheckboxes", function(ply, data)
	local item = ix.item.instances[data[1]]
	local cb1 = data[2]
	local cb2 = data[3]
	local cb3 = data[4]

	local tbl = item:GetData("checkboxes", {})
	tbl["wanted"] = cb1
	tbl["survey"] = cb2
	if cb3 then
		item:SetData("elevated", true)
	else
		item:SetData("elevated", false)
	end
	item:SetData("checkboxes", tbl)
end)