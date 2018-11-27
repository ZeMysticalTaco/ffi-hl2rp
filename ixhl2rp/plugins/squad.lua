PLUGIN.name = "Squad"
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.description = "A comprehensive squad and patrol menu for combine characters.."

ix.command.Add("squadmenu", {
	syntax = "<none>",
	description = "Open the Squad Menu.",
	OnRun = function(self, client)
		if client:IsCombine() then
			netstream.Start(client, "OpenSquadMenu", {})
		else
			client:Notify("You are not the Combine!")
		end
	end
})

ix.option.Add("SquadHalos", ix.type.bool, true)

if CLIENT then
	local PANEL = {}

	function PANEL:Init()
		self:SetSize(ScrW() / 3, ScrH() / 4)
		local pnw, pnh = self:GetSize()
		self:Center()
		self:MakePopup()
		self.PlayerSelected = LocalPlayer()
		self:SetTitle("Squad User Interface")
		self.SquadList = self:Add("DListView")
		self.SquadList:AddColumn("Name")
		self.SquadList:AddColumn("Squad Name")
		self.SquadList:AddColumn("D"):SetFixedWidth(0)
		self.SquadList:Dock(FILL)
		self.SquadList:DockMargin(0, 0, pnw / 2, 0)

		function self.SquadList:OnRowSelected(row, pnl)
			self:GetParent():SetPanelPlayer(pnl.Player)
		end

		local playerlist = {}

		if LocalPlayer():IsCombine() then
			for k, v in pairs(player.GetAll()) do
				if v:IsCombine() then
					table.insert(playerlist, v)
				end
			end
		end

		for k, v in pairs(playerlist) do
			local sq = v:GetSquad()

			if not sq then
				sq = "None"
			end

			local line = self.SquadList:AddLine(v:Name(), sq)
			line.Player = v
		end

		self.PlayerLabel = self:Add("DLabel")
		self.PlayerLabel:Dock(TOP)
		self.PlayerLabel:SetText("Select a Player from the list below.")
		self.PlayerLabel:SetTall(32)
		self.PlayerLabel:SetTextColor(Color(255, 255, 255, 255))
		self.PlayerLabel:SetFont("ixMediumFont")
		self.ButtonPanel = self:Add("DPanel")
		self.ButtonPanel:Dock(FILL)
		self.ButtonPanel:DockMargin(pnw / 2, 0, 0, 0)
		self.LeaveButton = self.ButtonPanel:Add("DButton")
		self.LeaveButton:Dock(BOTTOM)
		self.LeaveButton:SetText("Leave Current Squad")

		function self.LeaveButton:DoClick()
			netstream.Start("LeaveSquad", {})
		end

		self.CreateButton = self.ButtonPanel:Add("DButton")
		self.CreateButton:Dock(BOTTOM)
		self.CreateButton:SetText("Create New Squad")

		function self.CreateButton:DoClick()
			if LocalPlayer():GetNetVar("squad", nil) then
				ix.util.Notify("You are already in a squad, leave your current squad first.")

				return
			end

			local rdn_names = {"PT1", "Bravo", "Charlie", "Delta", "Echo", "Patrol Team Alpha", "Patrol Team Bravo", "Patrol Team Charlie", "Patrol Team Delta", "Patrol Team Echo", "Dunksquad", "Danger Zone"}

			Derma_StringRequest("Squad Name", "What do you want your Squad Name to be?", table.Random(rdn_names), function(text)
				local banned = {"false", "true", "N/A", "None", "none"}

				for k, v in pairs(banned) do
					if text == v then
						ix.util.Notify("You cannot make a squad with any of those names!")

						return
					end
				end

				netstream.Start("CreateSquad", {text})
			end)
		end

		if LocalPlayer():GetNetVar("squad") then
			self.SquadText = self.ButtonPanel:Add("DLabel")
			self.SquadText:Dock(TOP)
			self.SquadText:SetText("You are currently in squad: " .. LocalPlayer():GetNetVar("squad", "N/A"))
		end

		self.PlayerNameLabel = self.ButtonPanel:Add("DLabel")
		self.PlayerNameLabel:Dock(TOP)
		self.PlayerNameLabel:SetText(LocalPlayer():Name())
		self.PlayerModelLabel = self.ButtonPanel:Add("SpawnIcon")
		self.PlayerModelLabel:SetSize(64, 64)
		self.PlayerModelLabel:SetModel(LocalPlayer():GetModel())
		local lposx, lposy = self.PlayerNameLabel:GetPos()
		self.PlayerModelLabel:SetPos(0, lposy + 48)
		self.InviteButton = self.ButtonPanel:Add("DButton")
		self.InviteButton:Dock(BOTTOM)
		self.InviteButton:SetText("Invite To Squad")

		function self.InviteButton:DoClick()
			if not LocalPlayer():GetNetVar("squad", nil) then
				ix.util.Notify("You are not apart of a squad.")

				return
			end

			if squadUserInterface.PlayerSelected == LocalPlayer() then
				ix.util.Notify("Aren't you already in your own squad?")

				return
			end

			if squadUserInterface.PlayerSelected.InviteCooldown and squadUserInterface.PlayerSelected.InviteCooldown >= CurTime() then
				ix.util.Notify("You cannot invite this player to your squad yet!")

				return
			end

			netstream.Start("InviteToSquad", {squadUserInterface.PlayerSelected, LocalPlayer():GetNetVar("squad")})
			squadUserInterface.PlayerSelected.InviteCooldown = CurTime() + 10
		end

		squadUserInterface = self
	end

	function PANEL:SetPanelPlayer(player)
		self.PlayerNameLabel:SetText(player:GetName())
		self.PlayerSelected = player
		self.PlayerModelLabel:SetModel(player:GetModel())
	end

	vgui.Register("ixSquadUI", PANEL, "DFrame")

	netstream.Hook("OpenSquadMenu", function()
		vgui.Create("ixSquadUI")
	end)

	netstream.Hook("InviteToSquad", function(data)
		local inviter = data[1]
		local squad = data[2]
		/*
		Derma_Query("You have been invited to " .. squad .. " by " .. inviter:GetName() .. ".", "Squad Invitation!", "Accept", function()
			netstream.Start("AcceptInvite", {squad})
		end, "Reject", function() end)*/
		local frame = vgui.Create("DFrame")
		frame:SetSize(ScrW() / 5, ScrH() - ScrH() + 120)
		frame:MakePopup()
		frame:Center()
		frame:SetTitle("Squad Invitation!")
		
		local dlabel = frame:Add("DLabel")
		dlabel:Dock(TOP)
		dlabel:SetText("You have been invited to " .. squad .. " by " .. inviter:GetName() .. ".")
		dlabel:SetTall(50)
		dlabel:SetWrap(true)
		
		local accept = frame:Add("DButton")
		accept:Dock(BOTTOM)
		accept:SetText("Accept")
		function accept:DoClick()
			netstream.Start("AcceptInvite", {squad})
		end
	end)

	--[[netstream.Hook("UpdateSquadHalos", function(data)
		local squad = data[1]

		if ix.option.Get("SquadHalos") then
			halo.Add(squad, Color(255, 255, 255, 255), 2, 2, 2, true, true)

			for k, v in pairs(squad) do
				if v:GetNetVar("squadleader") then
					halo.Add({v}, Color(100, 255, 100, 255), 2, 2, 2, true, true)
				end
			end
		end
	end)--]]
	hook.Add("PreDrawHalos", "ixDrawSquadHalos", function()
		local squad = LocalPlayer():GetSquadMembers()

		if ix.option.Get("SquadHalos") then
			if squad then
				for k, v in pairs(squad) do
					if v:GetNetVar("squadleader") then
						halo.Add({v}, Color(100, 255, 100, 255), 2, 2, 2, true, true)
						table.RemoveByValue(squad, v)
						break
					end
				end

				halo.Add(squad, Color(255, 255, 255, 255), 2, 2, 2, true, true)
			end
		end
	end)
	--vgui.Create("ixSquadUI") -- remove on production
else
	netstream.Hook("CreateSquad", function(ply, data)
		local squadname = data[1]
		ply:SetNetVar("squad", squadname)
		ply:SetNetVar("squadleader", true)
		ix.log.AddRaw("[SQUAD] " .. ply:GetName() .. " has created a squad named " .. ply:GetSquad() .. ".", nil, Color(255, 255, 255, 255))
		ply:Notify("You have created a squad named " .. ply:GetSquad() .. ".")
	end)

	netstream.Hook("InviteToSquad", function(ply, data)
		netstream.Start(data[1], "InviteToSquad", {ply, data[2]})
		ix.log.AddRaw("[SQUAD] " .. ply:GetName() .. " has invited " .. data[1]:GetName() .. " to " .. ply:GetSquad() .. ".", nil, Color(255, 255, 255, 255))
		ply:Notify("You have invited " .. data[1]:GetName() .. " to your squad.")
	end)

	netstream.Hook("AcceptInvite", function(ply, data)
		local squadname = data[1]
		ply:SetNetVar("squad", squadname)
		ix.log.AddRaw("[SQUAD] " .. ply:GetName() .. " has accepted a squad invite to " .. ply:GetSquad() .. ".", nil, Color(255, 255, 255, 255))
		ply:SetNetVar("squadleader", nil)
		ply:Notify("You have accepted an invite to " .. ply:GetSquad() .. ".")
		local sl = ply:GetSquadLeader()
		sl:Notify(ply:Name() .. " has joined your squad.")
	end)

	netstream.Hook("LeaveSquad", function(ply, data)
		local sq = ply:GetSquad()

		if ply:GetSquadLeader() == ply then
			local memebrs = ply:GetSquadMembers()
			table.RemoveByValue(memebrs, ply)
			local guy = table.Random(memebrs)
			if #memebrs > 1 then
				guy:SetNetVar("squadleader", true)
				ix.util.Notify(memebrs, "Your squad leader has left your squad. " .. guy:GetName() .. " is your new Squad Leader.")
				guy:Notify("You are the new squad leader.")
			end
			ply:SetNetVar("squadleader", nil)
			ply:SetNetVar("squad", nil)

			return
		end

		ix.log.AddRaw("[SQUAD] " .. ply:GetName() .. " has left " .. sq .. ".", nil, Color(255, 255, 255, 255))
		ply:Notify("You have left your squad.")
		ply:SetNetVar("squad", nil)
		ply:SetNetVar("squadleader", nil)
	end)
end

local playerMeta = FindMetaTable("Player")

function playerMeta:GetSquad()
	return self:GetNetVar("squad", nil)
end

function playerMeta:GetSquadMembers()
	local squad = {}

	for k, v in pairs(player.GetAll()) do
		if v:GetSquad() then
			if v:GetSquad() == self:GetSquad() then
				table.insert(squad, v)
			end
		end
	end

	if #squad > 0 then
		return squad
	else
		return nil
	end
end

function playerMeta:GetSquadLeader()
	if not self:GetSquad() then
		return nil
	end

	local squad = self:GetSquadMembers()

	for k, v in pairs(squad) do
		if v:GetNetVar("squadleader") then
			return v
		end
	end
end

function playerMeta:IsSquadLeader()
	if self:GetNetVar("squadleader", nil) then
		return true
	end

	return nil
end