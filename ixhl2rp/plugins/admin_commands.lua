PLUGIN.name = "Admin Commands"
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.description = "Administration Suite for Helix"

ix.command.Add("PlyKick", {
	syntax = "<string Player> <string Reason>",
	adminOnly = true,
	description = "Kick a player from the server.",
	arguments = {ix.type.character, bit.bor(ix.type.string, ix.type.optional)},
	OnRun = function(self, client, target, reason)
		if SERVER then
			if target then
				serverguard.command.Run(client, "kick", false, target.player:Name(), reason)
			end
		end
	end
})

ix.command.Add("PlyBan", {
	syntax = "<string Player> <string Reason>",
	adminOnly = true,
	description = "Ban a player from the server.",
	arguments = {ix.type.character, ix.type.number, bit.bor(ix.type.string, ix.type.optional)},
	OnRun = function(self, client, target, length, reason)
		if SERVER then
			if target then
				serverguard.command.Run(client, "ban", false, target.player:Name(), length, reason)
			end
		end
	end
})

ix.command.Add("PlyTeleport", {
	syntax = "<string Player>",
	adminOnly = true,
	description = "Bring a player to your target location.",
	arguments = {ix.type.character, bit.bor(ix.type.bool, ix.type.optional)},
	OnRun = function(self, client, target, silent)
		if SERVER then
			if target then
				serverguard.command.Run(client, "send", silent or false, target.player:Name())
			end
		end
	end
})

ix.command.Add("PlyBring", {
	syntax = "<string Player>",
	adminOnly = true,
	description = "Bring a player to you.",
	arguments = {ix.type.character},
	OnRun = function(self, client, target)
		if SERVER then
			if target then
				serverguard.command.Run(client, "send", true, target.player:Name(), client:Name())

				ix.util.Notify(client:Name() .. " has brought " .. target.player:Name() .. " to them.")
			end
		end
	end
})

ix.command.Add("PlyBringS", {
	syntax = "<string Player>",
	adminOnly = true,
	description = "Bring a player to you silently.",
	arguments = {ix.type.character},
	OnRun = function(self, client, target)
		if SERVER then
			if target then
				serverguard.command.Run(client, "send", true, target.player:Name(), client:Name())

				--ix.util.Notify(client:Name() .. " has brought " .. target.player:Name() .. " to them.")
			end
		end
	end
})

ix.command.Add("PlySend", {
	syntax = "<string Player>",
	adminOnly = true,
	description = "Send a player to another player.",
	arguments = {ix.type.character, ix.type.character, bit.bor(ix.type.bool, ix.type.optional)},
	OnRun = function(self, client, target, destination, silent)
		if SERVER then
			if target then
				serverguard.command.Run(client, "send", silent or false, target.player:Name(), destination.player:Name())
			end
		end
	end
})

ix.command.Add("PlyGoto", {
	syntax = "<string Player>",
	adminOnly = true,
	description = "Send a player to another player.",
	arguments = {ix.type.character, bit.bor(ix.type.bool, ix.type.optional)},
	OnRun = function(self, client, target, silent)
		if SERVER then
			if target then
				serverguard.command.Run(client, "tp", silent or false, target.player:Name())
			end
		end
	end
})


ix.command.Add("PlySetHP", {
	syntax = "<string Player>",
	adminOnly = true,
	description = "Set a player's HP.",
	arguments = {ix.type.character, ix.type.number, bit.bor(ix.type.bool, ix.type.optional)},
	OnRun = function(self, client, target, hp, silent)
		if SERVER then
			if target then
				serverguard.command.Run(client, "hp", silent or false, target.player:Name(), hp)
			end
		end
	end
})

ix.command.Add("PlySetArmor", {
	syntax = "<string Player>",
	adminOnly = true,
	description = "Set a player's armor.",
	arguments = {ix.type.character, ix.type.number, bit.bor(ix.type.bool, ix.type.optional)},
	OnRun = function(self, client, target, armor, silent)
		if SERVER then
			if target then
				serverguard.command.Run(client, "armor", silent or false, target.player:Name(), armor)
			end
		end
	end
})

ix.command.Add("PlyNotarget", {
	syntax = "<string Player>",
	adminOnly = true,
	description = "Toggle notarget for a player.",
	arguments = {ix.type.character, bit.bor(ix.type.bool, ix.type.optional)},
	OnRun = function(self, client, target, silent)
		if SERVER then
			if target then
				serverguard.command.Run(client, "npctarget", (silent or false), target.player:Name())
			end
		end
	end
})

ix.command.Add("PlyGod", {
	syntax = "<string Player>",
	adminOnly = true,
	description = "Toggle God Mode for a player.",
	arguments = {ix.type.character, bit.bor(ix.type.bool, ix.type.optional)},
	OnRun = function(self, client, target, silent)
		if SERVER then
			if target then
				serverguard.command.Run(client, "god", silent or false, target.player:Name())
			end
		end
	end
})

ix.command.Add("PlyFreeze", {
	syntax = "<string Player>",
	adminOnly = true,
	description = "Toggle Freezing for a player.",
	arguments = {ix.type.character, bit.bor(ix.type.bool, ix.type.optional)},
	OnRun = function(self, client, target, silent)
		if SERVER then
			if target then
				serverguard.command.Run(client, "freeze", silent or false, target.player:Name())
			end
		end
	end
})

ix.command.Add("PlySetGroup", {
	syntax = "<string Player>",
	adminOnly = true,
	description = "Set a player's group.",
	arguments = {ix.type.character, ix.type.string, bit.bor(ix.type.number, ix.type.optional)},
	OnRun = function(self, client, target, rank, length)
		if SERVER then
			if target then
				serverguard.command.Run(client, "setrank", silent or false, target.player:Name(), rank, length or 0)
			end
		end
	end
})

ix.command.Add("PlyDemote", {
	syntax = "<string Player>",
	adminOnly = true,
	description = "Demote a player to user.",
	arguments = ix.type.character,
	OnRun = function(self, client, target)
		if SERVER then
			if target then
				serverguard.command.Run(client, "setrank", silent or false, target.player:Name(), "user", 0)
			end
		end
	end
})

ix.command.Add("Respawn", {
	syntax = "<string Player>",
	adminOnly = true,
	description = "Respawn a player.",
	arguments = {ix.type.character, bit.bor(ix.type.string, ix.type.optional)},
	OnRun = function(self, client, target, silent)
		if SERVER then
			if target then
				serverguard.command.Run(client, "respawn", silent or false, target.player:Name())
			end
		end
	end
})

ix.command.Add("RespawnBring", {
	syntax = "<string Player>",
	adminOnly = true,
	description = "Respawn a player and teleport them to your target location.",
	arguments = {ix.type.character, bit.bor(ix.type.string, ix.type.optional)},
	OnRun = function(self, client, target, silent)
		if SERVER then
			if target then
				serverguard.command.Run(client, "respawn", silent or false, target.player:Name())
				serverguard.command.Run(client, "send", true, target.player:Name())
			end
		end
	end
})

ix.command.Add("RespawnStay", {
	syntax = "<string Player>",
	adminOnly = true,
	description = "Respawn a player at their current location.",
	arguments = {ix.type.character, bit.bor(ix.type.string, ix.type.optional)},
	OnRun = function(self, client, target, silent)
		if SERVER then
			if target then
				local pos = target.player:GetPos()
				serverguard.command.Run(client, "respawn", silent or true, target.player:Name())
				target.player:SetPos(pos)
			end
		end
	end
})

ix.command.Add("CharTie", {
	syntax = "<string Player>",
	adminOnly = true,
	description = "Tie a player.",
	arguments = {ix.type.character},
	OnRun = function(self, client, target, silent)
		if SERVER then
			if target then
				target.player:SetNetVar("restricted", not target.player:GetNetVar("restricted"))

				if target.player:GetNetVar("restricted") then
					client:Notify("You have tied " .. target.player:Name() .. ".")
					target.player:Notify("You have been tied by an admin.")
				else
					client:Notify("You have untied " .. target.player:Name() .. ".")
					target.player:Notify("You have been untied by an admin.")
				end
			end
		end
	end
})
