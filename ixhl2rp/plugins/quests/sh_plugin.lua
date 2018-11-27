PLUGIN.name = "Quests"
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.description = "Quests to keep people busy."

GLOBAL_Quests = {
	--TODO: POPULATE QUESTS
	--TODO: ADD QUEST COOLDOWN
	--TODO: ADD CID RELATED CODE
	--TODO: TAB MENU QUEST
	--VV ID, must be unique.
	["retrieval1"] = {
		["name"] = "Retrieve 3 Scrap Metal", --name in the tab menu and notify
		["dialogue"] = {
			["start"] = "Yeah, I do, try and find me some Scrap Metal, I need at least 3 pieces.", --start message
			["complete"] = "Awesome, here's 70 tokens.", --reward message
			["question"] = "How do you forget such a simple task? I need 3 scrap metal, pronto.\nI'm sure you can scavenge some from vehicles, or find some lying around." --more info about the quest
		},
		["reward"] = {
			["tokens"] = 70 --tokens 
		},
		["requirements"] = {
			["scrap_metal"] = 3 --item id's must be used
		}
	},
	--items that must be turned in
	--[[["retrieval2"] = {
		["name"] = "Retrieve a CID.",
		["dialogue"] = {
			["start"] = "Yeah, I do, I need you to get me a registered CID.\n I'll pay you big cash for it, I don't want your CID, either.",
			["complete"] = "You're quite the schemer, here's 450 tokens.",
			["question"] = "A registered CID, how hard of a concept is that to you? Bribe an officer or something."
		},
		["cidquest"] = true,
		["reward"] = {
			["tokens"] = 450
		},
		["requirements"] = {
			["cid"] = 1
		}
	},--]]
	["retrieval3"] = {
		["name"] = "Retrieve 5 Charred Metals.",
		["dialogue"] = {
			["start"] = "I've been working closely with a guy who knows how to manufacture some metal parts.\nI need 5 charred out metal pieces, I'll give you a cut of what gets refined.",
			["complete"] = "Thanks for your help, here's a piece of what got refined.",
			["question"] = "I need 5 pieces of Charred Metal. They're pretty simple to find, just look about on the streets."
		},
		["reward"] = {
			["refined_metal"] = 1
		},
		["requirements"] = {
			["burned_metal"] = 5
		}
	},
	["retrieval4"] = {
		["name"] = "Acquire a USPM94 CCA Pistol.", --the name that shows up in the tab menu
		["dialogue"] = {
			["start"] = "I need some weapons to arm militants, specifically pistols.\nGet me a standard issue CCA pistol and I'll pay you nicely for it.",
			["complete"] = "I appreciate your hard work, thanks, here's some coins and tokens for your trouble.",
			["question"] = "You can get the weapon from either mugging CCA officers in a group, or by purchasing it from the Railroad asshole over there.\nI don't have enough coins to really get any from him."
		},
		-- all of these are self explanatory, \n means a new line, the text in the box doesn't wrap automatically so try to new line after every sentence.
		["reward"] = {
			["railroad_coin"] = 1, --use item ID's, if you dont know the ID or you want an item made just put in a name and i'll fix it later
			["tokens"] = 850
		},
		["requirements"] = {
			["pistol"] = 1
		}
	},
	--unique ID really important just make sure it's unique
	["retrieval5"] = {
		["name"] = "Acquire a CCA mask.", --the name that shows up in the tab menu
		["dialogue"] = {
			["start"] = "I've been working on a fake set of CCA gear in an attempt to infiltrate some operations\nI need you to get me a CCA mask.",
			["complete"] = "I appreciate your hard work, thanks, here's some coins and tokens for your trouble.",
			["question"] = "You can get the mask from either mugging CCA officers in a group, or by purchasing it from the Railroad asshole over there.\nI don't have enough coins to really get any from him."
		},
		-- all of these are self explanatory, \n means a new line, the text in the box doesn't wrap automatically so try to new line after every sentence.
		["reward"] = {
			["railroad_coin"] = 1, --use item ID's, if you dont know the ID or you want an item made just put in a name and i'll fix it later
			["tokens"] = 850
		},
		["requirements"] = {
			["metropolice_mask"] = 1
		}
	},
	["retrieva15"] = { --unique ID really important just make sure it's unique
		["name"] = "Acquire 3 Cloth Scraps.", --the name that shows up in the tab menu
		["dialogue"] = { -- all of these are self explanatory, \n means a new line, the text in the box doesn't wrap automatically so try to new line after every sentence.
			["start"] = "Looking for something a little new to wear?\nFind me some cloth and I'll see what I can make for you.",
			["complete"] = "Nice, I can make some new clothes for you with this.",
			["question"] = "You can find some cloth all over, just look around.\nShouldn't really be that hard to find."
		},
		["reward"] = {
			["Green_Citizen_Clothing"] = 1, --use item ID's, if you dont know the ID or you want an item made just put in a name and i'll fix it later
		},
		["requirements"] = {
			["cloth_scrap"] = 3
		}
	},
	["retrieva18"] = { --unique ID really important just make sure it's unique
		["name"] = "Acquire 1 Refined Metal", --the name that shows up in the tab menu
		["dialogue"] = { -- all of these are self explanatory, \n means a new line, the text in the box doesn't wrap automatically so try to new line after every sentence.
			["start"] = "I'm sure I do, I've been needing a brick of refined metal to get a project going.\nGet me some metal and I'll reward you with some ammunition.",
			["complete"] = "This is enough, good.\nI'll get your ammo.",
			["question"] = "You can find metal scattered around the area, forming lower metals into higher metals is what I'd advise."
		},
		["reward"] = {
			["pistolammo"] = 1, --use item ID's, if you dont know the ID or you want an item made just put in a name and i'll fix it later
		},
		["requirements"] = {
			["refined_metal"] = 1
		}
	},
	["retrieva17"] = { --unique ID really important just make sure it's unique
		["name"] = "Acquire 4 Cloth Scrap", --the name that shows up in the tab menu
		["dialogue"] = { -- all of these are self explanatory, \n means a new line, the text in the box doesn't wrap automatically so try to new line after every sentence.
			["start"] = "So I'm trying to put together a new piece of cloth, but I only need one more scrap.\nFind me some cloth and I'll get you a pouch with what's left over.",
			["complete"] = "Great, this is good.\nWait here.",
			["question"] = "Cloth can be found all over the place.\nLook in garbage cans or the ground."
		},
		["reward"] = {
			["backpack"] = 1, --use item ID's, if you dont know the ID or you want an item made just put in a name and i'll fix it later
		},
		["requirements"] = {
			["cloth_scrap"] = 4
		}
	}
}

--unique ID really important just make sure it's unique
--[[-------------------------------------------------------------------------
Additionals can only go one layer deep.
TODO: Make it so that you can go infinitely with additionals.
---------------------------------------------------------------------------]]
GLOBAL_PreDefinedDialogue = {
	["railroad"] = {
		["Button"] = "What is the Underground Railroad?",
		["Response"] = [[The Underground Railroad was founded shortly after the Saturday Massacre. 
		It's served as a beacon for refugees in the cities looking to minimize Combine survelliance.
		It's not known exactly who founded it, but it's since become a strong network throughout a couple cities.
		Most are fairly certain that the Combine know about the Railroad, but don't choose to do anything about it.
		Mostly because it isolates them to a more containable area. But if you ask me, after all the cop-killing we do...
		I think they're just unaware.
		]],
		["Callback"] = false,
		["Additional"] = {
			["satmassacre"] = {
				["Button"] = "The Saturday Massacre?",
				["Response"] = [[How could you have not heard of the Saturday Massacre? It's one of the biggest events of City 18.
				Unless you're a new transfer, are you? ... I'm sure that doesn't matter. In any case, there was a big riot around fall of 2015.
				It ended up causing a big ruckus and Overwatch had to be caqlled in to contain it, one of the first times I'd ever seen one.
				About 3,500 people ended getting injured in the rally, which was all over some sort of bill that the DA was passing.
				The bill got cancelled by Sector Administration because of the incident at the rally, I don't know a lot more than that, but after it, the Railroad was founded.
				]]
			},
			["arealocation"] = {
				["Button"] = "What can you tell me about the area?",
				["Response"] = [[Well this place, is our camp, we use it as a staging area for any operations we do.
				I'm apart of the militant railroad members, which means I directly take part in attacks on the Combine.
				Generally we use this area as a social hub, where we can talk about things freely without fear of oppression.
				The City in general is pretty famous for having The Saturday Massacre occur, people are pretty scared of congregating for that reason.
				There is a large amount of stigma that comes with the City, the Civil Protection here are generally considered unforgiving, even compared to that of City 8.
				If you want to learn more, you might find a tour guide, although those are Union Filtered so you won't find anything negative about the City in them.]]
			}
		}
	}
}

--[[-------------------------------------------------------------------------
Separate all shit into sv_ and cl_ files later.
---------------------------------------------------------------------------]]
if SERVER then
	netstream.Hook("GetQuest", function(ply, data)
		if ply:GetCharacter():GetData("quest", false) then
			ply:Notify("You already have a quest, and should not of been able to collect another, contact a developer.")

			return
		else
			local ent = data[1]
			local quests = ent:GetNetVar("quests", {})

			if table.Count(quests) > 0 then
				ply:SetQuest(data[2])

				for k, v in pairs(GLOBAL_Quests) do
					if k == data[2] then
						ply:Notify("You have started a quest: " .. v.name)
					end
				end
			else
				ply:Notify("This NPC has no quests available, but the dialogue option appeared anyway, contact a developer.")

				return
			end
		end
	end)

	local playerMeta = FindMetaTable("Player")

	function playerMeta:SetQuest(quest)
		if quest then
			for k, v in pairs(GLOBAL_Quests) do
				local char = self:GetCharacter()

				if quest == k then
					char:SetData("quest", k)
					print("set quest to " .. k)
				end
			end
		end
	end

	function playerMeta:RemoveQuest()
		local char = self:GetCharacter()
		char:SetData("quest", false)
	end

	netstream.Hook("DialogueOptionAdd", function(ply, data)
		local dialogue_key = data[1]
		local dialogue_table = data[2]
		local ent = data[3]

		if ent then
			local curdata = ent:GetNetVar("dialogue", {})
			table.insert(curdata, dialogue_key)
			ent:SetNetVar("dialogue", curdata)
		else
			print("Tried to add dialogue to non-existant NPC!")
		end
	end)

	netstream.Hook("DialogueOptionRemove", function(ply, data)
		local dialogue_key = data[1]
		local dialogue_table = data[2]
		local ent = data[3]

		if ent then
			local curdata = ent:GetNetVar("dialogue", {})
			table.RemoveByValue(curdata, dialogue_key)
			ent:SetNetVar("dialogue", curdata)
		else
			print("Tried to remove dialogue to non-existant NPC!")
		end
	end)

	netstream.Hook("QuestOptionRemove", function(ply, data)
		local dialogue_key = data[1]
		local dialogue_table = data[2]
		local ent = data[3]

		if ent then
			local curdata = ent:GetNetVar("quests", {})
			table.RemoveByValue(curdata, dialogue_key)
			ent:SetNetVar("quests", curdata)
		else
			print("Tried to remove quest to non-existant NPC!")
		end
	end)

	netstream.Hook("QuestOptionAdd", function(ply, data)
		local dialogue_key = data[1]
		local dialogue_table = data[2]
		local ent = data[3]

		if ent then
			local curdata = ent:GetNetVar("quests", {})
			table.insert(curdata, dialogue_key)
			ent:SetNetVar("quests", curdata)
		else
			print("Tried to add quest to non-existant NPC!")
		end
	end)

	netstream.Hook("QuestCompleted", function(ply, data)
		local ent = data[1]
		local quest = data[2]
		local char = ply:GetCharacter()
		local inv = char:GetInventory()

		for k, v in pairs(GLOBAL_Quests) do
			if k == quest then
				for k2, v2 in pairs(v.reward) do
					if k2 == "tokens" then
						ply:GetCharacter():GiveMoney(v2)
						ply:Notify("You have received " .. v2 .. " tokens from completing a quest.")
						--inv:Add(k2)
					else
						for i = 1, v2 do
							if (not inv:Add(k2)) then
								ix.item.Spawn(k2, ply)
								ply:Notify("You could not fit some of the items from the rewards in your inventory.")
							end
						end
					end
				end

				for k3, v3 in pairs(v.requirements) do
					for i = 1, v3 do
						local item = inv:HasItem(k3)

						if item then
							item:Remove()
						end
					end
				end

				ply:Notify("You have completed a quest! " .. v.name)
			end
		end

		ply:RemoveQuest()
		--ply:SetNetVar("NextQuest", os.time() + 10800)
		char:SetData("NextQuest", os.time() + 10800)
	end)

	netstream.Hook("EndQuest", function(ply, data)
		ply:GetCharacter():SetData("NextQuest", os.time() + 10800)
		ply:RemoveQuest()
	end)

	netstream.Hook("ChangeNPCValues", function(ply, data)
		local npc = data[1]
		local name = data[2]
		local desc = data[3]
		local mdl = data[4]
		local anim = data[5]
		npc:SetNetVar("Name", name)
		npc:SetNetVar("Description", desc)
		npc:SetModel(mdl)
		npc:SetNetVar("anim", anim)
		npc:SetupAnimation(anim)
	end)
	--[[-------------------------------------------------------------------------
	Dialogue NPC
	---------------------------------------------------------------------------]]
	--[[-------------------------------------------------------------------------
	NPC Editor
	---------------------------------------------------------------------------]]
	--self:AddDialogueOption(v.Button, v.Callback, v.Response)
	--logic for 'collect' quests.
	--do say for quest start
	--self.DialoguePanelList:AddItem(self.CurDialogue)
	-- creates labels in the status screen
	-- populates labels in the status screen

	function PLUGIN:SaveData()
		local data = {}
		for k, v in pairs(ents.FindByClass("ix_questgiver")) do
			data[#data + 1] = {
				pos = v:GetPos(),
				ang = v:GetAngles(),
				quests = v:GetNetVar("quests", {}),
				dialogue = v:GetNetVar("dialogue", {}),
				name = v:GetNetVar("Name", "dsfsdf"),
				desc = v:GetNetVar("Description", "dfssdf"),
				model = v:GetModel()
			}
			self:SetData(data)
		end
	end

	function PLUGIN:LoadData()
		local data = self:GetData()
		for k, v in pairs(data) do
			local ent = ents.Create("ix_questgiver")
			ent:SetPos(v.pos)
			ent:SetAngles(v.ang)
			ent:Spawn()
			if IsValid(ent) then
				ent:SetNetVar("quests", v.quests)
				ent:SetNetVar("dialogue", v.dialogue)
				ent:SetNetVar("Name", v.name)
				ent:SetNetVar("Description", v.desc)
				timer.Simple(1, function()
				ent:SetModel(v.model)
				ent:SetupAnimation(4)
			end)
			end
		end
	end
else
	local PANEL = {}

	function PANEL:Init()
		ix.gui.dialogue = self
		self:SetSize(ScrW() / 3, ScrH() / 4)
		self:MakePopup()
		local scrW, scrH = ScrW(), ScrH()
		self:SetPos(scrW / 3, scrH / 1.5)
		self:SetTitle("Engaged in Dialogue")
		local w, h = self:GetSize()
		self.TextPanel = self:Add("DPanel")
		self.TextPanel:Dock(BOTTOM)
		self.TextPanel:SetTall(h / 2.5)
		self.TextPanel.PanelList = self.TextPanel:Add("DPanelList")
		self.TextPanel.PanelList:Dock(FILL)
		self.TextPanel.PanelList:EnableVerticalScrollbar(true)
		self.DialoguePanel = self:Add("DPanel")
		self.DialoguePanel:Dock(TOP)
		self.DialoguePanel:SetTall(h / 2.5)
		self.DialogueList = self.DialoguePanel:Add("DScrollPanel")
		self.DialogueList:Dock(FILL)
		self.CurDialogue = self.DialoguePanel:Add("DLabel")
		self.CurDialogue:Dock(TOP)
		self.CurDialogue:SetWrap(true)
		self.CurDialogue:SetFont("ixSmallFont")
		self.CurDialogue:SetText("What is it you need?")
		self.CurDialogue:SetAutoStretchVertical(true)
		self.DialogueList:AddItem(self.CurDialogue)
		self.DialoguePanelList = self:Add("DPanelList")
		self.DialoguePanelList:Dock(FILL)
		self.DialoguePanelList:EnableVerticalScrollbar(true)
	end

	function PANEL:Say(text)
		self.CurDialogue:SetText(text)
		self.CurDialogue:SizeToContents()
	end

	function PANEL:AddDialogueOption(text, callback, response)
		local button = self:Add("DButton")
		button:SetText(text)
		self.TextPanel.PanelList:AddItem(button)
		button:Dock(TOP)
		button.id = text

		function button:DoClick()
			surface.PlaySound("buttons/button24.wav")

			if callback then
				callback()
			end

			if response then
				ix.gui.dialogue:Say(response)
			end
		end
	end

	function PANEL:SetCharacter(ent)
		ix.gui.dialogue.ent = ent

		for k, v in pairs(ent:GetNetVar("dialogue", {})) do
			for k2, v2 in pairs(GLOBAL_PreDefinedDialogue) do
				if v == k2 then
					if not v2.Additional then
						self:AddDialogueOption(v2.Button, v2.Callback, v2.Response)
					else
						self:AddDialogueOption(v2.Button, function()
							for k3, v3 in pairs(v2.Additional) do
								self:AddDialogueOption(v3.Button, v3.Callback, v3.Response)

								if v2.Callback then
									v2.Callback()
								end
							end
						end, v2.Response)
					end
				end
			end
		end

		if table.Count(ent:GetNetVar("quests", {})) > 0 and not LocalPlayer():GetCharacter():GetData("quest", false) then
			self:AddDialogueOption("Do you have any work for me to do? ", function()
				if LocalPlayer():GetCharacter():GetData("quest", false) or LocalPlayer():GetCharacter():GetData("NextQuest", 0) > os.time() then
					local alreadyQuest = {"Word on the street is you already had a job.", "I don't have any work right now for you.", "Nope."}
					ix.gui.dialogue:Say(table.Random(alreadyQuest))

					return
				end

				local quests = ent:GetNetVar("quests", {})

				if table.Count(quests) < 1 then
					LocalPlayer():Notify("You should not of been able to start a quest with this NPC, contact a developer.")
				else
					local rnd = table.Random(quests)

					for k, v in pairs(GLOBAL_Quests) do
						if k == rnd then
							ix.gui.dialogue:Say(v.dialogue.start)
							PrintTable(v)
						end
					end

					netstream.Start("GetQuest", {ent, rnd})
				end
			end, false)
		end

		self:QuestStuff(ent)

		self:AddDialogueOption("Goodbye.", function()
			ix.gui.dialogue:Remove()
		end, false)
	end

	function PANEL:QuestStuff(ent)
		if LocalPlayer():GetCharacter():GetData("quest", false) and table.HasValue(ent:GetNetVar("quests", {}), LocalPlayer():GetCharacter():GetData("quest", false)) then
			self:AddDialogueOption("About that Quest...", function()
				self:AddDialogueOption("Can you tell me more about it?", function()
					for k, v in pairs(GLOBAL_Quests) do
						if k == LocalPlayer():GetCharacter():GetData("quest", false) then
							ix.gui.dialogue:Say(v.dialogue.question)
						end
					end
				end, false)

				self:AddDialogueOption("I completed it.", function()
					ix.gui.dialogue:CheckQuestCompletion(ent)
				end, false)

				self:AddDialogueOption("I can't do this quest for you.", function()
					ix.gui.dialogue:EndQuest(ent)
				end, false)
			end, "What about it?")
		end
	end

	function PANEL:CheckQuestCompletion(ent)
		local char = LocalPlayer():GetCharacter()
		local inv = char:GetInventory()
		local items = inv:GetItems()
		local quest = char:GetData("quest", false)

		for k, v in pairs(GLOBAL_Quests) do
			if quest then
				if quest == k then
					for k2, v2 in pairs(v.requirements) do
						if inv:GetItemCount(k2) < v2 then
							ix.gui.dialogue:Say("You haven't completed it, are you trying to punk me?")

							return
						end
					end

					ix.gui.dialogue:Say(v.dialogue.complete)
					netstream.Start("QuestCompleted", {ent, quest})
				end
			end
		end
	end

	function PANEL:StartQuest(ent)
		if LocalPlayer():GetCharacter():GetData("NextQuest", 0) > os.time() then
			ix.gui.dialogue:Say("I have no work for you right now.")

			return
		end

		local quests = ent:GetNetVar("quests", {})

		if table.Count(quests) < 1 then
			LocalPlayer():Notify("You should not of been able to start a quest with this NPC, contact a developer.")
		else
			netstream.Start("GetQuest", {ent})
		end
	end

	function PANEL:EndQuest()
		netstream.Start("EndQuest", {})
		ix.gui.dialogue:Say("That's a shame. I'll give it to someone else.")
	end

	vgui.Register("ixDialogueUI", PANEL, "DFrame")
	local PANEL = {}

	function PANEL:Init()
		ix.gui.npcedit = self
		self:SetSize(ScrW() / 4, ScrH() / 4)
		self:Center()
		self:MakePopup()
		self.Desc = self:Add("DLabel")
		self.Desc:Dock(TOP)
		self.Desc:SetText("What do you want to edit?")
		self.Desc:SizeToContents()
		self.ButtonDialogue = self:Add("DButton")
		self.ButtonDialogue:SetText("Predefined Dialogue")
		self.ButtonDialogue:Dock(BOTTOM)
		self.ButtonQuests = self:Add("DButton")
		self.ButtonQuests:Dock(BOTTOM)
		self.ButtonQuests:SetText("Quests")

		timer.Simple(0.1, function()
			self.TextName = self:Add("DTextEntry")
			self.TextName:Dock(TOP)
			self.TextName:SetText(ix.gui.npcedit.npc:GetNetVar("Name", "Name"))
			self.DescBox = self:Add("DTextEntry")
			self.DescBox:Dock(TOP)
			self.DescBox:SetText(ix.gui.npcedit.npc:GetNetVar("Description", "Description"))
			self.ModelBox = self:Add("DTextEntry")
			self.ModelBox:Dock(TOP)
			self.ModelBox:SetText(ix.gui.npcedit.npc:GetModel())
			self.AnimLabel = self:Add("DLabel")
			self.AnimLabel:Dock(TOP)
			self.AnimLabel:SetText("Animation Index, must be a number.")
			self.AnimLabel:SizeToContents()
			self.AnimBox = self:Add("DTextEntry")
			self.AnimBox:Dock(TOP)
			self.AnimBox:SetText(ix.gui.npcedit.npc:GetNetVar("anim", 4))
			self.SubmitBox = self:Add("DButton")
			self.SubmitBox:Dock(TOP)
			self.SubmitBox:SetText("Submit Changes")

			self.SubmitBox.DoClick = function()
				netstream.Start("ChangeNPCValues", {ix.gui.npcedit.npc, self.TextName:GetText(), self.DescBox:GetText(), self.ModelBox:GetText(), self.AnimBox:GetText()})
			end
		end)

		function self.ButtonDialogue:DoClick()
			local ui = vgui.Create("DFrame")
			ui:SetSize(ScrW() / 2, ScrH() / 2)
			ui:Center()
			ui:MakePopup()

			for k, v in pairs(GLOBAL_PreDefinedDialogue) do
				local checkbox = ui:Add("DCheckBoxLabel")
				checkbox:Dock(TOP)
				checkbox.dialogue = {k, v}
				checkbox:SetText(v.Button)
				local data = ix.gui.npcedit.npc:GetNetVar("dialogue", {})

				if table.HasValue(data, k) then
					checkbox:SetChecked(true)
				end

				function checkbox:OnChange(val)
					if val then
						netstream.Start("DialogueOptionAdd", {k, v, ix.gui.npcedit.npc})
					else
						netstream.Start("DialogueOptionRemove", {k, v, ix.gui.npcedit.npc})
					end
				end
			end
		end

		function self.ButtonQuests:DoClick()
			local ui = vgui.Create("DFrame")
			ui:SetSize(ScrW() / 2, ScrH() / 2)
			ui:Center()
			ui:MakePopup()

			for k, v in pairs(GLOBAL_Quests) do
				local checkbox = ui:Add("DCheckBoxLabel")
				checkbox:Dock(TOP)
				checkbox.quest = {k, v}
				checkbox:SetText(v.name)
				local data = ix.gui.npcedit.npc:GetNetVar("quests", {})

				if table.HasValue(data, k) then
					checkbox:SetChecked(true)
				end

				function checkbox:OnChange(val)
					if val then
						netstream.Start("QuestOptionAdd", {k, v, ix.gui.npcedit.npc})
					else
						netstream.Start("QuestOptionRemove", {k, v, ix.gui.npcedit.npc})
					end
				end
			end
		end
	end

	function PANEL:SetCharacter(ent)
		ix.gui.npcedit.npc = ent
	end

	vgui.Register("ixNPCEdit", PANEL, "DFrame")

	netstream.Hook("OpenQuestDialogue", function(data)
		local ui = vgui.Create("ixDialogueUI")
		ui:SetCharacter(data[1])
	end)

	netstream.Hook("OpenQuestEditMenu", function(data)
		local ui = vgui.Create("ixNPCEdit")
		ui:SetCharacter(data[1])
	end)

	function PLUGIN:CreateCharacterInfo(panel)
		panel.quest = panel:Add("ixListRow")
		panel.quest:SetList(panel.list)
		panel.quest:Dock(TOP)
		panel.quest:DockMargin(0, 0, 0, 8)
	end

	function PLUGIN:UpdateCharacterInfo(panel)
		panel.quest:SetLabelText("Quest")
		local quest = "None"

		for k, v in pairs(GLOBAL_Quests) do
			if k == LocalPlayer():GetCharacter():GetData("quest", false) then
				quest = v.name
			end
		end

		panel.quest:SetText(quest)
		panel.quest:SizeToContents()
	end
end