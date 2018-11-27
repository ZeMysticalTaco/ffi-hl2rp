local PLUGIN = PLUGIN

--[[function PLUGIN:PlayerWebDataInitialized(player, primary_group, secondary_groups)
	local donator_groups = {

		["5"] = "DonatorStandard"

	}

	for k, v in pairs(donator_groups) do
		if primary_group == k or string.find(secondary_groups, k) then
			print("he's a donator all right.")
		end
	end
end--]]