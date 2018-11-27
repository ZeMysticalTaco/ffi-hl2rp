local PLUGIN = PLUGIN
PLUGIN.name = "Combine HUD"
PLUGIN.author = "Elec / ZeMysticalTaco"
PLUGIN.description = "Facial Recognition for Clockwork, adapted for use on HELIX and CMRP, thanks for the code, Elec!"
ix.option.Add("CombineHUD", ix.type.bool, false)

ix.config.Add("code_mpf", "ASSIST, DEFEND", "The font used to display titles.", nil, {
	category = "Miscellaneous"
})

ix.config.Add("code_overwatch", "ASSIST, SACRIFICE", "The font used to display titles.", nil, {
	category = "Miscellaneous"
})

ix.command.Add("CharSetDivision", {
	syntax = "<string Player>",
	adminOnly = true,
	description = "Set a players' CP Division.",
	arguments = {ix.type.character, ix.type.string},
	OnRun = function(self, client, target, arguments)
		if target then
			target:SetData("mpfdivision", arguments)
			target.player:SetNetVar("mpfdivision", arguments)
			ix.util.Notify(client:Name() .. " has set " .. target.player:Name() .. "'s division to " .. arguments)
		end
	end
})

hook.Add("PlayerSpawn", "ixSetDivision", function(ply)
	if ply:GetChar() then
		ply:SetNetVar("mpfdivision", ply:GetChar():GetData("mpfdivision", ""))
	end
end)

if CLIENT then
	-- hud
	local alphas = {}
	local sizes = {}
	local str_lens = {}

	local function MatrixText(text, font, x, y, color, scale, rotation)
		surface.SetFont(font)
		local matrix = Matrix()
		matrix:Translate(Vector(x, y, 1))
		matrix:Scale(scale or Vector(1, 1, 1))
		matrix:Rotate(rotation or Angle(0, 0, 0))
		cam.PushModelMatrix(matrix)
		surface.SetTextPos(0, 0)
		surface.SetTextColor(color.r, color.g, color.b, color.a)
		surface.DrawText(text)
		cam.PopModelMatrix()
	end

	surface.CreateFont("FaceRecog", {
		font = "Roboto",
		size = 120,
		antialias = true
	})

	function PLUGIN:HUDPaint()
		if not LocalPlayer():IsCombine() then
			return
		end

		for k, v in pairs(player.GetAll()) do
			-- we can't see the faces of MPF/OTA
			-- this aint facial recognition anymore ELEC BOYE
			if v ~= LocalPlayer() and v:GetMoveType() ~= MOVETYPE_NOCLIP and v:IsCombine() then
				--if table.HasValue(no_recog_models, v:GetModel()) then return end
				if not alphas[v:EntIndex()] then
					alphas[v:EntIndex()] = 0
				end

				if not sizes[v:EntIndex()] then
					sizes[v:EntIndex()] = 100
				end

				if not str_lens[v:EntIndex()] then
					str_lens[v:EntIndex()] = 0
				end

				local head = v:LookupBone("ValveBiped.Bip01_Head1")
				local headpos
				local headposP

				if head then
					headposP = v:GetBonePosition(head)
					headpos = v:GetBonePosition(head):ToScreen()
				else
					headposP = v:EyePos()
					headpos = v:EyePos():ToScreen()
				end

				-- scale stuff properly with distance
				local size = sizes[v:EntIndex()]
				local scale = v:GetPos():Distance(LocalPlayer():GetPos()) / 384
				size = size / scale
				local name = v:Name()
				surface.SetFont("FaceRecog")
				local ns_x, ns_y = surface.GetTextSize(name)
				local range = 512
				local recog_on = ix.option.Get("CombineHUD")

				-- check if the player is in range, that their face is visible and that they're alive. and, of course, if facial recog is turned on.
				local tr = util.TraceLine({
					start = EyePos(),
					endpos = headposP,
					mask = MASK_VISIBLE_AND_NPCS,
					filter = {LocalPlayer(), v}
				})

				if v:GetPos():Distance(LocalPlayer():GetPos()) <= range and v:Alive() and recog_on and not tr.Hit then
					-- if yes, make magic with alphas, sizes, etc.
					alphas[v:EntIndex()] = Lerp(FrameTime() * 5, alphas[v:EntIndex()], 255)
					sizes[v:EntIndex()] = Lerp(FrameTime() * 5, sizes[v:EntIndex()], 20)
					local str_len_mul = 6

					if sizes[v:EntIndex()] < 40 then
						str_len_mul = 50
					end

					str_lens[v:EntIndex()] = Lerp(FrameTime() * str_len_mul, str_lens[v:EntIndex()], ns_x)
				else
					alphas[v:EntIndex()] = Lerp(FrameTime() * 10, alphas[v:EntIndex()], 0)
					sizes[v:EntIndex()] = Lerp(FrameTime() * 10, sizes[v:EntIndex()], 80)
					str_lens[v:EntIndex()] = Lerp(FrameTime() * 10, str_lens[v:EntIndex()], 0)
				end

				--[[and v:GetAimVector():Dot(LocalPlayer():GetAimVector()) < 0--]]
				-- draw the box/line
				surface.SetDrawColor(255, 255, 255, alphas[v:EntIndex()])
				--surface.DrawOutlinedRect(headpos.x - size / 2, headpos.y - size / 2, size, size)
				--surface.DrawRect(headpos.x + size / 1.9, headpos.y - size * 0.9, 150, 10)
				--surface.DrawCircle(headpos.x - size / 2, headpos.y - size / 2, size,Color(255,255,255,255))
				-- draw the name in their team color (citizens brown, admins yellow, etc.)
				local team_color = team.GetColor(v:Team())
				local name_size = 0.075
				local digits = string.match(v:Name(), "%d%d%d%d?%d?") or "CANNOT PARSE DIGITS"
				--[[-------------------------------------------------------------------------
			If we ever go to ALL CAPS ranks i'll kill myself.
			---------------------------------------------------------------------------]]
				--local rank = string.match(v:Name(), "%p%a%a%a%p") or string.match(v:Name(), "%p%d%d%p") or "CANNOT PARSE RANK"
				local rank = "none"

				--if string.find(v:Name(), "OTA") or string.find(v:Name(), "USF:D") then
				--	rank = string.match(v:Name(), "%p%a%a%a%p")
				if v:Team() == FACTION_MPF then
					rank = string.match(v:Name(), "%p%d%d%p") or string.match(v:Name(), "%p%a%a%a%p") or string.match(v:Name(), "%p%a%a%p")
				else
					rank = "NO RANK FOUND"
				end

				local delta = string.find(v:Name(), "USF:D")
				local airw = string.find(v:Name(), "OTA")
				local mpf = string.find(v:Name(), "JTF")
				assessment = ix.config.Get("code_mpf")
				division = v:GetNetVar("mpfdivision", "UNIT")
				local squad = v:GetSquad() or "NONE"

				-- draw text
				if v:IsCombine() then

					MatrixText(division .. rank .. "" .. digits, "FaceRecog", headpos.x + size / 1.9, headpos.y - size * 0.9, Color(team_color.r, team_color.g, team_color.b, alphas[v:EntIndex()]), Vector(name_size / scale, name_size / scale, 1))
					-- scaling with random numbers sure is fun
					--MatrixText("RANK: " .. rank, "FaceRecog", headpos.x + size / 1.9, headpos.y - size / 2, Color(255, 255, 255, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))
					MatrixText("ASSESSMENT: " .. assessment, "FaceRecog", headpos.x + size / 1.9, headpos.y - size / 4, Color(255, 255, 255, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))
					-- scaling with random numbers sure is fun
					--MatrixText("Rank: " .. string.gsub(rank,"%p", ""), "FaceRecog", headpos.x + size / 1.9, headpos.y - size / 2, Color(255, 255, 255, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))
					MatrixText("PATROL TEAM: " .. squad, "FaceRecog", headpos.x + size / 1.9, headpos.y - size * 1.1, Color(team_color.r - 50, team_color.g - 50, team_color.b - 50, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))

					if v:IsSquadLeader() then
						MatrixText("PATROL LEADER", "FaceRecog", headpos.x + size / 1.9, headpos.y - size * 1.6, Color(220, 255, 100, 255), Vector(0.05 / scale, 0.05 / scale, 1))
					end

					if delta then
						MatrixText("STRIKE FORCE: DELTA", "FaceRecog", headpos.x + size / 1.9, headpos.y - size * 1.3, Color(200, 0, 0, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))
					elseif airw then
						MatrixText("AIRWATCH INFANTRY UNIT", "FaceRecog", headpos.x + size / 1.9, headpos.y - size * 1.3, Color(180, 50, 100, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))
					elseif mpf then
						MatrixText("SOCIO CONTROL UNIT", "FaceRecog", headpos.x + size / 1.9, headpos.y - size * 1.3, Color(10, 50, 100, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))
					end

					if v:GetNetVar("squad", "none") == LocalPlayer():GetNetVar("squad", "") then
						MatrixText("SQUAD ASSET", "FaceRecog", headpos.x + size / 1.9, headpos.y - size / 16 + 16, Color(255, 255, 255, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))
					end
				end

				local line_matrix = Matrix()
				line_matrix:Translate(Vector(headpos.x + size / 1.9, headpos.y - size / 2, 0))
				line_matrix:Scale(Vector(name_size / scale, 1, 1))
				cam.PushModelMatrix(line_matrix)
				surface.DrawOutlinedRect(0, 0, str_lens[v:EntIndex()], 1)
				cam.PopModelMatrix()
			end
		end
	end
end
//Denzel Washington was here.