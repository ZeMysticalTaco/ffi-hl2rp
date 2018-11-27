PLUGIN.name = "Miscellaneous"
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.description = "Cool things such as auto-grenade callouts."
PLUGIN.SaveEnts = PLUGIN.SaveEnts or {}
--skinny bars are disgusting
BAR_HEIGHT = 12

--[[-------------------------------------------------------------------------
MPF Models
---------------------------------------------------------------------------]]

for i = 1, 9 do
	ix.anim.SetModelClass("models/police/c18_police_male_0"..i..".mdl", "metrocop")
end

for i = 1, 4 do
	ix.anim.SetModelClass("models/police/c18_police_female_0"..i..".mdl", "metrocop")
end

for i = 6, 9 do
	ix.anim.SetModelClass("models/police/c18_police_female_0"..i..".mdl", "metrocop")
end

ix.anim.SetModelClass("models/police/c18_police.mdl", "metrocop")
ix.anim.SetModelClass("models/police/c18_police_female.mdl", "metrocop")

--[[-------------------------------------------------------------------------
Auto Grenade Callout
---------------------------------------------------------------------------]]
function PLUGIN:PlayerTick(ply)
	for k, v in pairs(ents.FindByClass("npc_grenade_frag")) do
		if v:GetPos():Distance(ply:GetPos()) < 150 then
			if not ply.NextGrenadeTick or ply.NextGrenadeTick <= CurTime() then
				ix.chat.Send(ply, "ic", "Grenade!")
				ply:EmitSound("npc/metropolice/vo/grenade.wav")
				ply.NextGrenadeTick = CurTime() + 5

				return
			end
		end
	end
end

--[[-------------------------------------------------------------------------
Saving misc. ents.
---------------------------------------------------------------------------]]

local save_ents = {"ix_loyaltykiosk", "ix_applicationterminal", "ix_cidterminal"}

function PLUGIN:SaveData()
	for k, v in pairs(save_ents) do
		for k2, v2 in pairs(ents.FindByClass(v)) do
			local tbl = {}

			tbl[#tbl + 1] = {
				v2:GetPos(),
				v2:GetAngles(),
				v2:GetNetVar("destroyed", false),
			}

			ix.data.Set(v, tbl)
		end
	end
end

function PLUGIN:InitPostEntity()
	for k, v in ipairs(save_ents) do
		for _, v2 in ipairs(ix.data.Get(v) or {}) do
			local ent = ents.Create(v)
			ent:SetPos(v2[1])
			ent:SetAngles(v2[2])
			ent:Spawn()
			ent:SetNetVar("destroyed", v2[3])
		end
	end
end
--[[-------------------------------------------------------------------------
	Restrict business
---------------------------------------------------------------------------]]
function PLUGIN:CanPlayerUseBusiness()
	return false
end
--[[-------------------------------------------------------------------------
	move settings to tab
---------------------------------------------------------------------------]]
if CLIENT then
	hook.Add("CreateMenuButtons", "ixSettings", function(tabs)
	tabs["settings"] = {
		Create = function(info, container)
			container:SetTitle(L("settings"))

			local panel = container:Add("ixSettings")
			panel:SetSearchEnabled(true)

			for category, options in SortedPairs(ix.option.GetAllByCategories(true)) do
				category = L(category)
				panel:AddCategory(category)

				-- sort options by language phrase rather than the key
				table.sort(options, function(a, b)
					return L(a.phrase) < L(b.phrase)
				end)

				for _, data in pairs(options) do
					local key = data.key
					local row = panel:AddRow(data.type, category)
					local value = ix.util.SanitizeType(data.type, ix.option.Get(key))

					row:SetText(L(data.phrase))
					row:Populate(key, data)

					-- type-specific properties
					if (data.type == ix.type.number) then
						row:SetMin(data.min or 0)
						row:SetMax(data.max or 10)
						row:SetDecimals(data.decimals or 0)
					end

					row:SetValue(value, true)
					row:SetShowReset(value != data.default, key, data.default)
					row.OnValueChanged = function()
						local newValue = row:GetValue()

						row:SetShowReset(newValue != data.default, key, data.default)
						ix.option.Set(key, newValue)
					end

					row.OnResetClicked = function()
						row:SetShowReset(false)
						row:SetValue(data.default, true)

						ix.option.Set(key, data.default)
					end

					row:GetLabel():SetHelixTooltip(function(tooltip)
						local title = tooltip:AddRow("name")
						title:SetImportant()
						title:SetText(key)
						title:SizeToContents()
						title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

						local description = tooltip:AddRow("description")
						description:SetText(L(data.description))
						description:SizeToContents()
					end)
				end
			end

			panel:SizeToContents()
			container.panel = panel
		end,

		OnSelected = function(info, container)
			container.panel.searchEntry:RequestFocus()
		end
	}
end)

hook.Add("PopulateScoreboardPlayerMenu", "ixAdmin", function(client, menu)
	--[[-------------------------------------------------------------------------
	WAY too lazy to convert this
	---------------------------------------------------------------------------]]
	local options = {}
	options["Set Name"] = {
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			if (IsValid(client) and LocalPlayer():IsAdmin()) then
				Derma_StringRequest("Change Character Name", "What do you want to change this character's name to?", client:Name(), function(text)
					ix.command.Send("CharSetName", client:Name(), text)
				end, nil, "Change", "Cancel")
			end
		end
	}

	options["Set Health"] = {
		
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			if (IsValid(client) and LocalPlayer():IsAdmin()) then
				Derma_StringRequest("Change Character Health", "What do you want to change their health to?", client:Health(), function(text)
					ix.command.Send("PlySetHP", client:Name(), text, "true") --Need to put ix.type.bools in quotes????
				end, nil, "Set", "Cancel")
			end
		end
	}

	options["Set Armor"] = {
		
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			if (IsValid(client) and LocalPlayer():IsAdmin()) then
				Derma_StringRequest("Change Character Armor", "What do you want to change their armor to?", client:Armor(), function(text)
					ix.command.Send("PlySetArmor", client:Name(), text, "true")
				end, nil, "Set", "Cancel")
			end
		end
	}

	options["Kick Player"] = {
		
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			if (IsValid(client) and LocalPlayer():IsAdmin()) then
				Derma_StringRequest("Kick Player", "Why do you want to kick them?", "", function(text)
					ix.command.Send("PlyKick", client:Name(), text)
				end, nil, "Kick", "Cancel")
			end
		end
	}

	options["Ban Player"] = {
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			if (IsValid(client) and LocalPlayer():IsAdmin()) then
				Derma_StringRequest("Ban Reason", "Why do you want to ban them?", "", function(text)
					--ix.command.Send("PlyBan", client:Name(), text)
					Derma_StringRequest("Ban Length","For how long do you want to ban them? 0 is permanent.","",function(text2) ix.command.Send("PlyBan", client:Name(), text2, text) end, nil)
				end, nil, "Ban", "Cancel")
			end
		end
	}

		options["Change Model"] = {
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			if (IsValid(client) and LocalPlayer():IsAdmin()) then
				Derma_StringRequest("Change Character Model", "What do you want to change this character's model to?", client:GetModel(), function(text)
					ix.command.Send("CharSetModel", client:Name(), text)
				end, nil, "Change", "Cancel")
			end
		end
	}

	options["Change Faction"] = {
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			local menu = vgui.Create("DFrame")
			menu:SetSize(ScrW() / 6, ScrH() / 3)
			menu:MakePopup()
			menu:Center()
			menu:SetTitle("Change Player Faction")
			local header = menu:Add("DLabel")
			header:Dock(TOP)
			header:SetText("Pick a faction to change them to.")
			header:SetTextInset(3, 0)
			header:SetFont("ixMediumFont")
			header:SetTextColor(color_white)
			header:SetExpensiveShadow(1, color_black)
			header:SetTall(28)

			header.Paint = function(this, w, h)
				surface.SetDrawColor(ix.config.Get("color"))
				surface.DrawRect(0, 0, w, h)
			end

			for k, v in pairs(ix.faction.indices) do
				local button = vgui.Create("DButton", menu)
				button:Dock(TOP)
				button:SetText(L(v.name))
				function button:DoClick()
					ix.command.Send("PlyTransfer", client:Name(), v.uniqueID)
				end
			end
		end
	}

		options["Give Item"] = {
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			local menu = vgui.Create("DFrame")
			menu:SetSize(ScrW() / 6, ScrH() / 3)
			menu:MakePopup()
			menu:Center()
			menu:SetTitle("Character Item Menu")
			local panel = menu:Add("DScrollPanel")
			panel:Dock(FILL)
			local header = panel:Add("DLabel")
			header:Dock(TOP)
			header:SetText("Use the box to search for an item.")
			header:SetTextInset(3, 0)
			header:SetFont("ixMediumFont")
			header:SetTextColor(color_white)
			header:SetExpensiveShadow(1, color_black)
			header:SetTall(25)

			header.Paint = function(this, w, h)
				surface.SetDrawColor(ix.config.Get("color"))
				surface.DrawRect(0, 0, w, h)
			end
			local entry = menu:Add("DTextEntry")
			entry:Dock(TOP)
			for k, v in SortedPairs(ix.item.list) do
				local button = vgui.Create("DButton", panel)
				button:Dock(TOP)
				button:SetSize(20,30)
				button:SetText(L(v.name))
				function button:DoClick()
					ix.command.Send("CharGiveItem", client:Name(), v.uniqueID, 1)
				end
				function button.Paint()
					surface.SetDrawColor(Color(200,200,200,255))
				end
				function button:Think()
					if string.len(entry:GetText()) < 1 then self:Show() return end
					if not string.find(v.name, entry:GetText()) then
						panel:SetVerticalScrollbarEnabled(true)
						panel:ScrollToChild(self)
					else
						panel:SetVerticalScrollbarEnabled(true)
						--panel:ScrollToChild()
					end
				end
			end
		end
	}
	for k, v in pairs(options) do
		menu:AddOption(k,v[1])
	end
end)

end

function PLUGIN:PlayerDeath(client, inflictor, attacker)
		if attacker:IsPlayer() then
			ix.log.AddRaw(client:Name() .. " was killed by " .. attacker:Name() .. " using " .. attacker:GetActiveWeapon():GetClass(), nil, Color(255,50,50))
		else
			ix.log.AddRaw(client:Name() .. " was killed by an " .. attacker:GetClass(), nil, Color(255,50,50))
		end
end

function PLUGIN:PlayerHurt(client, attacker, health, damage)
if attacker:IsPlayer() then
		ix.log.AddRaw(client:Name() .. " has taken " .. damage .. " damage from " .. attacker:Name() .. " using " .. attacker:GetActiveWeapon():GetClass() .. " leaving them at " .. health .. " HP!", nil, Color(255, 200, 0))
	else
		ix.log.AddRaw(client:Name() .. " has taken " .. math.floor(damage) .. " damage from " .. attacker:GetClass() .. " leaving them at " .. math.floor(health) .. " HP!", nil, Color(255, 200, 0))
	end
end

--[[-------------------------------------------------------------------------
	BETTER ADMIN ESP
---------------------------------------------------------------------------]]
local dimDistance = -1
	local aimLength = 128
ix.option.Add("itemESP", ix.type.bool, true)

	function PLUGIN:HUDPaint()
		local client = LocalPlayer()

		if (client:IsAdmin() and client:GetMoveType() == MOVETYPE_NOCLIP and not client:InVehicle() and ix.option.Get("observerESP", true)) then
			local scrW, scrH = ScrW(), ScrH()

			if ix.option.Get("itemESP") then
				for k, v in pairs(ents.GetAll()) do
					if v:GetClass() == "ix_item" then
						local espcol = Color(255,255,255,255)
						local screenPosition = v:GetPos():ToScreen()
						local marginX, marginY = scrH * .1, scrH * .1
						local x2, y2 = math.Clamp(screenPosition.x, marginX, scrW - marginX), math.Clamp(screenPosition.y, marginY, scrH - marginY)
						local distance = client:GetPos():Distance(v:GetPos())
						local factor = 1 - math.Clamp(distance / dimDistance, 0, 1)
						local size2 = math.max(10, 32 * factor)
						local alpha2 = math.max(255 * factor, 80)
						local itemTable = v:GetItemTable()
						local espcols = {
							["Weapons"] = Color(255,50,50),
							["Ammunition"] = Color(155,50,50),
							["Food"] = Color(100,255,100),
							["Crafting"] = Color(150,200,50),
							["Clothes"] = Color(65,200,150),
							["Attachments"] = Color(50,255,175),
							["Survival"] = Color(50,255,175)

						}

						for k2, v2 in pairs(espcols) do
							if itemTable.category == k2 then
								espcol = v2
							end
						end
						ix.util.DrawText(itemTable.name, x2, y2 - size2, espcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha2)
						--ix.util.DrawText(itemTable.category, x2, y2 - size2 + 15, espcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha2)
					end
				end
			end

			for _, v in ipairs(player.GetAll()) do
				if (v == client or not v:GetCharacter()) then continue end
				local screenPosition = v:GetPos():ToScreen()
				local marginX, marginY = scrH * .1, scrH * .1
				local x, y = math.Clamp(screenPosition.x, marginX, scrW - marginX), math.Clamp(screenPosition.y, marginY, scrH - marginY)
				local teamColor = team.GetColor(v:Team())
				local distance = client:GetPos():Distance(v:GetPos())
				local factor = 1 - math.Clamp(distance / dimDistance, 0, 1)
				local size = math.max(10, 32 * factor)
				local alpha = math.max(255 * factor, 80)
				surface.SetDrawColor(teamColor.r, teamColor.g, teamColor.b, alpha)
				surface.SetFont("ixGenericFont")
				local text = v:Name()

				--tables are for faggots.
				if not v.status then
					v.status = "user"
				elseif v:IsUserGroup("superadmin") then
					v.status = "SA"
				elseif v:IsUserGroup("admin") then
					v.status = "A"
				elseif v:IsUserGroup("operator") then
					v.status = "O"
				elseif v:IsUserGroup("user") then
					v.status = "user"
				elseif v:IsUserGroup("producer") then
					v.status = "producer"
				else
					v.status = v:GetUserGroup()
				end

				local text2 = v:SteamName() .. "[" .. v.status .. "]"
				local text3 = "H: " .. v:Health() .. " A: " .. v:Armor()
				local text4 = v:GetActiveWeapon().PrintName
				surface.SetDrawColor(teamColor.r * 1.6, teamColor.g * 1.6, teamColor.b * 1.6, alpha)
				local col = Color(255, 255, 255, 255)

				if v:IsWepRaised() then
					col = Color(255, 100, 100, 255)
				end

				ix.util.DrawText(text, x, y - size, ColorAlpha(teamColor, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
				ix.util.DrawText(text2, x, y - size + 20, Color(200, 200, 200, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
				ix.util.DrawText(text3, x, y - size + 40, Color(200, 200, 200, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
				ix.util.DrawText(text4, x, y - size + 60, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
			end
		end
	end

local playerMeta = FindMetaTable("Player")

--[[-------------------------------------------------------------------------
	playerMeta:GetItemWeapon()

	Purpose: Checks the player's currently equipped weapon and returns the item and weapon.
	Syntax: player:GetItemWeapon()
	Returns: @weapon, @item
---------------------------------------------------------------------------]]

function playerMeta:GetItemWeapon()
	local char = self:GetCharacter()
	local inv = char:GetInventory()
	local items = inv:GetItems()
	local weapon = self:GetActiveWeapon()

	for k, v in pairs(items) do
		if v.class then
			if v.class == weapon:GetClass() then
				if v:GetData("equip", false) then
					return weapon, v
				else
					return false
				end
			end
		end
	end
end

function playerMeta:IsCombineCommand()
	return Schema:IsCombineRank(self:Name(), "CL") or Schema:IsCombineRank(self:Name(), "RL")
end

function PLUGIN:ScalePlayerDamage(player, hitGroup, damageInfo)
	--no instakill melee weapons pls
	if string.find(damageInfo:GetAttacker():GetActiveWeapon():GetClass(), "hl2") then
		damageInfo:SetDamageType(DMG_CRUSH)
	end
	if (not damageInfo:IsFallDamage() and not damageInfo:IsDamageType(DMG_CRUSH) and damageInfo:IsBulletDamage()) then
		if (hitGroup == HITGROUP_HEAD) then
			damageInfo:ScaleDamage(5)
		elseif (hitGroup == HITGROUP_CHEST or hitGroup == HITGROUP_GENERIC) then
			damageInfo:ScaleDamage(1)
		elseif (hitGroup == HITGROUP_LEFTARM or hitGroup == HITGROUP_RIGHTARM or hitGroup == HITGROUP_LEFTLEG or hitGroup == HITGROUP_RIGHTLEG or hitGroup == HITGROUP_GEAR) then
			damageInfo:ScaleDamage(3)
		end
	end
end

if SERVER then
	resource.AddWorkshop("282312812") -- HL2RP ID Cards
	resource.AddWorkshop("593929594") -- UU-Branded Prop Pack
	resource.AddWorkshop("444734535") -- HL2TS2 Reskins
	resource.AddWorkshop("496413414") -- The Metropolice of City 18
	resource.AddWorkshop("132931674") -- rp_c18_v1
	resource.AddWorkshop("675824914") -- Half-Life 2 Melee Pack
--[[-------------------------------------------------------------------------
NAME: ADMIN CHAT
CREATOR: TACO
DESC: ADMIN CHAT
---------------------------------------------------------------------------]]
ix.chat.Register("adminchat", {
	format = "whocares",
	--font = "nutRadioFont",
	OnGetColor = function(self, speaker, text)
		return Color(0, 196, 255)
	end,
	OnCanHear = function(self, speaker, listener)
		if listener:IsAdmin() then
			return true
		end

		return false
	end,
	OnCanSay = function(self, speaker, text)

		if not speaker:IsAdmin() then
			speaker:Notify("You aren't an admin.")
		end

		--speaker.NextAR = ix.config.Get("arequestinterval")

		return true
	end,
	OnChatAdd = function(self, speaker, text)
		local color = team.GetColor(speaker:Team())
		chat.AddText(Color(100, 255, 100), "[ADMIN] ", color, speaker:Name() .. " (" .. speaker:SteamName() .. ")", ": ", Color(255, 255, 255), text)
	end,
	prefix = "/a"
})

function PLUGIN:PlayerSay(client, text)
	local chatType, message, anonymous = ix.chat.Parse(client, text, true)

	if (chatType == "ic") then
		if (string.sub(text, 1, 1) == "@") then
			message = string.gsub(message, "@", "", 1)
			print(message)

			if not client:IsAdmin() then
				return
			end

			serverguard.command.Run(client, "a", false, message)

			return false
		end
	end
end
end

ix.chat.Register("adminrequest", {
	format = "whocares",
	--font = "nutRadioFont",
	OnGetColor = function(self, speaker, text)
		return Color(0, 196, 255)
	end,
	OnCanHear = function(self, speaker, listener)
		if listener:IsAdmin() or listener == speaker then
			return true
		end

		return false
	end,
	OnChatAdd = function(self, speaker, text)
		local schar = speaker:GetChar()
		local color = team.GetColor(speaker:Team())
		local whitelist = {"STEAM_1:0:17704583", "STEAM_0:1:34297953", "STEAM_1:1:53007042"}
		if LocalPlayer():IsAdmin() or speaker == LocalPlayer() then
			chat.AddText(Color(225, 50, 50, 255), "[REPORT] ", Color(190, 90, 90), speaker:Name(), color, " (", speaker:SteamName(), "): ", Color(255, 255, 255, 255), text)
		end
		if CLIENT then
			for k, v in pairs(player.GetAll()) do
				if table.HasValue(whitelist, v:SteamID()) then
					--print("you will not receive an alert")
					--print("you will receive an alert")
					return
				else
					if not LocalPlayer().nextbellproc or LocalPlayer().nextbellproc <= CurTime() then
						surface.PlaySound("hl1/fvox/bell.wav")
						LocalPlayer().nextbellproc = CurTime() + 5
					end
				end
			end
		end
	end
})
ix.command.Add("ar", {
	syntax = "<string message>",
	description = "Send a message to the admins.",
	OnRun = function(self, client, arguments)
		local text = table.concat(arguments, " ")
		local admintable = {}

		if client:IsAdmin() then
			client:Notify("You are an admin, use admin chat instead... idiot.")

			return
		end

		--[[if client.NextAR and client.NextAR > CurTime() then
			client:Notify("You cannot use admin request yet!")

			return false
		end--]]

		--client.NextAR = ix.config.Get("arequestinterval")
		ix.chat.Send(client, "adminrequest", text)

		for k, v in pairs(player.GetAll()) do
			if v:IsAdmin() then
				table.insert(admintable, v:Name())
			end
		end

		ix.log.AddRaw(client:Name() .. " requested an admin: " .. text .. " Admins Online: " .. table.concat(admintable, ", "))

		return true
	end
})

--[[-------------------------------------------------------------------------
	Legs?
---------------------------------------------------------------------------]]

g_LegsLog =
[[
	[FIX] problem with leg refresh
	[FIX] problem were thirdperson view in vehicles
]]

g_LegsVer = "3.8.9a"

local PLAYER 			= FindMetaTable("Player")
local ENTITY 			= FindMetaTable("Entity")

local bHasShownNotice = false
do
	ENTITY._SetModel = ENTITY._SetModel or ENTITY.SetModel

	function PLAYER:SetModel( model )
		self:_SetModel(model)
        hook.Run("SetModel", self, model)
	end

	function PLAYER:SetLegsModel( model )
        if (SERVER) then
		    self:SetNWString( "PlayerMeta.PlayerModel", model )
			self:ConCommand("cl_refreshlegs")
	    end
	end

	function PLAYER:GetLegModel()
		local model = self:GetNWString( "PlayerMeta.PlayerModel", false )
		if (!model) then
			model = self:GetModel()
		end
		return model
	end

	hook.Add("SetModel", "GML::SetModel::Hook", function(ply, mdl)
		if (SERVER) then
			ply:SetLegsModel(mdl)
		end
	end)
end


if (SERVER) then
    AddCSLuaFile("sh_legs.lua")
end

if (CLIENT) then
	local LegsBool      	= CreateConVar("cl_legs", "1", {FCVAR_ARCHIVE}, "Enable/Disable the rendering of the legs")
	local VLegsBool     	= CreateConVar("cl_vehlegs", "1", {FCVAR_ARCHIVE}, "Enable/Disable the rendering of the legs in vehicles")

    local Legs = {}
    Legs.LegEnt = nil

	local g_maxseqgroundspeed = 0
	local g_velocity = 0

    function Legs:CheckDrawVehicle()
        if (LocalPlayer():InVehicle()) then
			if LegsBool:GetBool() && !VLegsBool:GetBool() then
				return true
			end
			return false
        end
    end

    function ShouldDrawLegs()
        if (hook.Run("ShouldDisableLegs") == true) then 
            return false 
        end
        if LegsBool:GetBool() then
            return  IsValid(Legs.LegEnt)                                                                      &&
                    (LocalPlayer():Alive() || (LocalPlayer().IsGhosted && LocalPlayer():IsGhosted()))       &&
                    !Legs:CheckDrawVehicle()                                                                    &&
                    GetViewEntity() == LocalPlayer()                                                            &&
                    !LocalPlayer():ShouldDrawLocalPlayer()                                                      &&
                    !IsValid(LocalPlayer():GetObserverTarget())                                                 &&
                    !LocalPlayer().ShouldDisableLegs
        else
            return false
        end
    end

    function GetPlayerLegs(ply)
        return ply && ply != LocalPlayer() && ply || (ShouldDrawLegs() && Legs.LegEnt || LocalPlayer())
    end

    function Legs:SetUp()

		if (!IsValid(self.LegEnt)) then
			self.LegEnt = ClientsideModel(LocalPlayer():GetLegModel(), RENDER_GROUP_OPAQUE_ENTITY)	
		else
			self.LegEnt:SetModel(LocalPlayer():GetLegModel())
		end

        self.LegEnt:SetNoDraw(true)

		for k, v in pairs(LocalPlayer():GetBodyGroups()) do
			local current = LocalPlayer():GetBodygroup(v.id)
			self.LegEnt:SetBodygroup(v.id,  current)
		end

		for k, v in ipairs(LocalPlayer():GetMaterials()) do
			self.LegEnt:SetSubMaterial(k - 1, LocalPlayer():GetSubMaterial(k - 1))
		end

        self.LegEnt:SetSkin(LocalPlayer():GetSkin())
        self.LegEnt:SetMaterial(LocalPlayer():GetMaterial())
        self.LegEnt:SetColor(LocalPlayer():GetColor())
        self.LegEnt.GetPlayerColor = function()
            return LocalPlayer():GetPlayerColor()
        end

		self.LegEnt.Anim = nil
	   	self.PlaybackRate = 1
		self.Sequence = nil
		self.Velocity = 0
		self.OldWeapon = nil
		self.HoldType = nil

		self.BonesToRemove = {}

		self.BoneMatrix = nil

        self.LegEnt.LastTick = 0

		self:Update(g_maxseqgroundspeed)
    end

    Legs.PlaybackRate = 1
    Legs.Sequence = nil
    Legs.Velocity = 0
    Legs.OldWeapon = nil
    Legs.HoldType = nil

    Legs.BonesToRemove = {}

    Legs.BoneMatrix = nil

    function Legs:WeaponChanged(weap)
        if IsValid(self.LegEnt) then
            for i = 0, self.LegEnt:GetBoneCount() do
                self.LegEnt:ManipulateBoneScale(i, Vector(1,1,1))
                self.LegEnt:ManipulateBonePosition(i, vector_origin)
            end

            self.BonesToRemove =
            {
                "ValveBiped.Bip01_Head1",
                "ValveBiped.Bip01_L_Hand",
                "ValveBiped.Bip01_L_Forearm",
                "ValveBiped.Bip01_L_Upperarm",
                "ValveBiped.Bip01_L_Clavicle",
                "ValveBiped.Bip01_R_Hand",
                "ValveBiped.Bip01_R_Forearm",
                "ValveBiped.Bip01_R_Upperarm",
                "ValveBiped.Bip01_R_Clavicle",
                "ValveBiped.Bip01_L_Finger4",
                "ValveBiped.Bip01_L_Finger41",
                "ValveBiped.Bip01_L_Finger42",
                "ValveBiped.Bip01_L_Finger3",
                "ValveBiped.Bip01_L_Finger31",
                "ValveBiped.Bip01_L_Finger32",
                "ValveBiped.Bip01_L_Finger2",
                "ValveBiped.Bip01_L_Finger21",
                "ValveBiped.Bip01_L_Finger22",
                "ValveBiped.Bip01_L_Finger1",
                "ValveBiped.Bip01_L_Finger11",
                "ValveBiped.Bip01_L_Finger12",
                "ValveBiped.Bip01_L_Finger0",
                "ValveBiped.Bip01_L_Finger01",
                "ValveBiped.Bip01_L_Finger02",
                "ValveBiped.Bip01_R_Finger4",
                "ValveBiped.Bip01_R_Finger41",
                "ValveBiped.Bip01_R_Finger42",
                "ValveBiped.Bip01_R_Finger3",
                "ValveBiped.Bip01_R_Finger31",
                "ValveBiped.Bip01_R_Finger32",
                "ValveBiped.Bip01_R_Finger2",
                "ValveBiped.Bip01_R_Finger21",
                "ValveBiped.Bip01_R_Finger22",
                "ValveBiped.Bip01_R_Finger1",
                "ValveBiped.Bip01_R_Finger11",
                "ValveBiped.Bip01_R_Finger12",
                "ValveBiped.Bip01_R_Finger0",
                "ValveBiped.Bip01_R_Finger01",
                "ValveBiped.Bip01_R_Finger02",
                "ValveBiped.Bip01_Spine4",
                "ValveBiped.Bip01_Spine2",
            }

			if ( LocalPlayer():InVehicle() ) then
				self.BonesToRemove =
          	  	{
               		"ValveBiped.Bip01_Head1",
				}
			end

            for k, v in pairs(self.BonesToRemove) do
                local bone = self.LegEnt:LookupBone(v)
                if (bone) then
                    self.LegEnt:ManipulateBoneScale(bone, Vector(0,0,0))
                   	if ( !LocalPlayer():InVehicle() ) then
						self.LegEnt:ManipulateBonePosition(bone, Vector(0,-100,0))
						self.LegEnt:ManipulateBoneAngles(bone, Angle(0,0,0))
					end
                end
            end
        end
    end

    Legs.BreathScale = 0.5
    Legs.NextBreath = 0

    function Legs:Think(maxseqgroundspeed)
        if not LocalPlayer():Alive() then
            Legs:SetUp()
            return
        end

		self:Update(maxseqgroundspeed)
    end

	function Legs:Update(maxseqgroundspeed)
        if IsValid(self.LegEnt) then
            self:WeaponChanged(LocalPlayer():GetActiveWeapon())

            self.Velocity = LocalPlayer():GetVelocity():Length2D()

            self.PlaybackRate = 1

            if self.Velocity > 0.5 then
                if maxseqgroundspeed < 0.001 then
                    self.PlaybackRate = 0.01
                else
                    self.PlaybackRate = self.Velocity / maxseqgroundspeed
                    self.PlaybackRate = math.Clamp(self.PlaybackRate, 0.01, 10)
                end
            end

            self.LegEnt:SetPlaybackRate(self.PlaybackRate)

            self.Sequence = LocalPlayer():GetSequence()

            if (self.LegEnt.Anim != self.Sequence) then
                self.LegEnt.Anim = self.Sequence
                self.LegEnt:ResetSequence(self.Sequence)
            end

            self.LegEnt:FrameAdvance(CurTime() - self.LegEnt.LastTick)
            self.LegEnt.LastTick = CurTime()

            Legs.BreathScale = sharpeye && sharpeye.GetStamina && math.Clamp(math.floor(sharpeye.GetStamina() * 5 * 10) / 10, 0.5, 5) || 0.5

            if Legs.NextBreath <= CurTime() then
                Legs.NextBreath = CurTime() + 1.95 / Legs.BreathScale
                self.LegEnt:SetPoseParameter("breathing", Legs.BreathScale)
            end

            self.LegEnt:SetPoseParameter("move_x", (LocalPlayer():GetPoseParameter("move_x") * 2) - 1) -- Translate the walk x direction
            self.LegEnt:SetPoseParameter("move_y", (LocalPlayer():GetPoseParameter("move_y") * 2) - 1) -- Translate the walk y direction
            self.LegEnt:SetPoseParameter("move_yaw", (LocalPlayer():GetPoseParameter("move_yaw") * 360) - 180) -- Translate the walk direction
            self.LegEnt:SetPoseParameter("body_yaw", (LocalPlayer():GetPoseParameter("body_yaw") * 180) - 90) -- Translate the body yaw
            self.LegEnt:SetPoseParameter("spine_yaw",(LocalPlayer():GetPoseParameter("spine_yaw") * 180) - 90) -- Translate the spine yaw

            if LocalPlayer():InVehicle() then
                self.LegEnt:SetPoseParameter("vehicle_steer", (LocalPlayer():GetVehicle():GetPoseParameter("vehicle_steer") * 2) - 1) -- Translate the vehicle steering
            end
        end
	end

    hook.Add("UpdateAnimation", "GML:UpdateAnimation", function(ply, velocity, maxseqgroundspeed)
        if ply == LocalPlayer() then
            if IsValid(Legs.LegEnt) then
                Legs:Think(maxseqgroundspeed)
				if (string.lower(LocalPlayer():GetLegModel()) != string.lower(Legs.LegEnt:GetModel())) then
                    Legs:SetUp()
				end
            else
				Legs:SetUp()
			end
        end
    end)

    Legs.RenderAngle = nil
    Legs.BiaisAngle = nil
    Legs.RadAngle = nil
    Legs.RenderPos = nil
    Legs.RenderColor = {}
    Legs.ClipVector = vector_up * -1
    Legs.ForwardOffset = -24

	function Legs:DoFinalRender()
	   cam.Start3D(EyePos(), EyeAngles())
            if ShouldDrawLegs() then

                if (LocalPlayer():Crouching() || LocalPlayer():InVehicle()) then
                    self.RenderPos = LocalPlayer():GetPos()
                else
                    self.RenderPos = LocalPlayer():GetPos() + Vector(0,0,5)
                end

                if LocalPlayer():InVehicle() then
                    self.RenderAngle = LocalPlayer():GetVehicle():GetAngles()
                    self.RenderAngle:RotateAroundAxis(self.RenderAngle:Up(), 90)
                else
                    self.BiaisAngles = sharpeye_focus && sharpeye_focus.GetBiaisViewAngles && sharpeye_focus:GetBiaisViewAngles() || LocalPlayer():EyeAngles()
                    self.RenderAngle = Angle(0, self.BiaisAngles.y, 0)
                    self.RadAngle = math.rad(self.BiaisAngles.y)
                    self.ForwardOffset = -22
                    self.RenderPos.x = self.RenderPos.x + math.cos(self.RadAngle) * self.ForwardOffset
                    self.RenderPos.y = self.RenderPos.y + math.sin(self.RadAngle) * self.ForwardOffset

                    if LocalPlayer():GetGroundEntity() == NULL then
                        self.RenderPos.z = self.RenderPos.z + 8
                        if LocalPlayer():KeyDown(IN_DUCK) then
                            self.RenderPos.z = self.RenderPos.z - 28
                        end
                    end
                end

                self.RenderColor = LocalPlayer():GetColor()

                local bEnabled = render.EnableClipping(true)
                    render.PushCustomClipPlane(self.ClipVector, self.ClipVector:Dot(EyePos()))
                        render.SetColorModulation(self.RenderColor.r / 255, self.RenderColor.g / 255, self.RenderColor.b / 255)
                            render.SetBlend(self.RenderColor.a / 255)
                                    self.LegEnt:SetRenderOrigin(self.RenderPos)
                                    self.LegEnt:SetRenderAngles(self.RenderAngle)
                                    self.LegEnt:SetupBones()
                                    self.LegEnt:DrawModel()
									self.LegEnt:SetRenderOrigin()
                                    self.LegEnt:SetRenderAngles()
                            render.SetBlend(1)
                        render.SetColorModulation(1, 1, 1)
                    render.PopCustomClipPlane()
                render.EnableClipping(bEnabled)
            end
        cam.End3D()
	end

	hook.Add("PostDrawTranslucentRenderables", "GML:Render::Foot", function()
		 if (LocalPlayer() && !LocalPlayer():InVehicle()) then
			Legs:DoFinalRender()
        end
    end)

	hook.Add("RenderScreenspaceEffects", "GML:Render::Vehicle", function()
		 if (LocalPlayer():InVehicle()) then
			Legs:DoFinalRender()
        end
    end)

    hook.Add("CalcView", "GML::CalcView::ViewCorrection::Vehicle", function( player, origin, angles, fov )
		if (!player:InVehicle()) then
			return
		end 

		if (!VLegsBool:GetBool()) then
			return
		end

		
		local view = {}
		view.origin		= origin
		view.angles		= angles
		view.fov		= fov
		view.znear		= znear
		view.zfar		= zfar
		view.drawviewer	= false

		local Vehicle	= player:GetVehicle()

		if ( IsValid( Vehicle ) && Vehicle:GetThirdPersonMode() ) then 
			return hook.Run( "CalcVehicleView", Vehicle, player, view ) 
		end

		local headBone = player:LookupBone("ValveBiped.Bip01_Head1")
		if (!headBone) then 
			return 
		end

		local pos, ang  = player:GetBonePosition(headBone)
		if (!pos) then 
			return 
		end

		local baseView = {
			origin = Vector(pos.x, pos.y, pos.z + 5),
			fov = 90,
			znear = 1
		}

		return baseView
    end)

    concommand.Add("cl_togglelegs", function()
        if LegsBool:GetBool() then
            RunConsoleCommand("cl_legs", "0")
        else
            RunConsoleCommand("cl_legs", "1")
        end
    end)

	concommand.Add("cl_togglevlegs", function()
        if VLegsBool:GetBool() then
            RunConsoleCommand("cl_vehlegs", "0")
        else
            RunConsoleCommand("cl_vehlegs", "1")
        end
    end)

	concommand.Add("cl_refreshlegs", function()
		Legs:SetUp()
    end)

    g_Legs = Legs

    function SetupLegs()
        g_Legs:SetUp()
    end

    hook.Add("ShouldDisableLegs", "GML::Support::Prone", function()
        if (!PLAYER.IsProne) then
            return
        end

        if (LocalPlayer():IsProne()) then
            return true
        end
    end)

    hook.Add("ShouldDisableLegs", "GML::Support::MorphMod", function()
        if (!pk_pills) then
            return
        end

        if (pk_pills.getMappedEnt(LocalPlayer())) then
            return true
        end
    end)
end
