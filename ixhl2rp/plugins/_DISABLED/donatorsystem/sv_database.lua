--xf_user_external_auth
function PLUGIN:CharacterLoaded(char)
	local query = mysql:Select("xf_user_external_auth")
	query:Select("user_id")
	query:Where("provider_key", char.player:SteamID64())

	query:Callback(function(results)
		if #results > 0 then
			
			local query2 = mysql:Select("xf_user")
			query2:Select("user_group_id")
			query2:Select("secondary_group_ids")
			query2:Where("user_id", results[1].user_id)
			query2:Callback(function(results2)
				hook.Run("PlayerWebDataInitialized", char.player, results2[1].user_group_id, results2[1].secondary_group_ids)
			end)
			query2:Execute()
		end
	end)

	query:Execute()
	self:DoDonatorNotify(char.player)
end

function PLUGIN:PlayerWebDataInitialized(ply, primary, secondary)
	local groups = {
		[5] = "Management",
		[14] = "StandardPackage"
	}

	for k, v in pairs(groups) do
		if primary == k or string.find(secondary, k) then
			hook.Run("AssignForumGroup", ply, v)
			ply:SetData(v, true)
		end

		if string.find(v, "Package") then
			ply:SetData("PackageHolder", true)
		else
			ply:SetData("PackageHolder", false)
		end
	end
end

function PLUGIN:DoDonatorNotify(ply)
	if not ply:GetData("DonatorNotified") then
		
	end
end