local PANEL = {}

function PANEL:Init()
	ix.gui.crafting = self
	self:SetSize(ScrW() / 2.8, ScrH() / 2)
	self:Center()
	self.infotext = self:Add("DLabel")
	self.infotext:Dock(TOP)
	self.infotext:SetContentAlignment(5)
	self.infotext:SetText("Hover over a recipe's icon to get information on that recipe, click it to attempt to craft it.")
	self.infotext:SetFont("ixSmallFont")
	self.infotext:SetExpensiveShadow(1)

	self.infotext.Paint = function(this, w, h)
		surface.SetDrawColor(0, 0, 0, 75)
		surface.DrawRect(0, 0, w, h)
	end

	--self:MakePopup()
	--self:SetTitle("Crafting")
	self.CraftingList = self:Add("DPanelList")
	self.CraftingList:Dock(FILL)
	self.CraftingList:SetSpacing(2)
	self.CraftingList:SetPadding(5)
	local w, h = self:GetSize()
	self.CraftingList:DockMargin(0, 0, 0, 0)
	self.CraftingList:EnableHorizontal(true)
	self.CraftingList:EnableVerticalScrollbar(true)

	--[[for i = 1, 50 do
		self:AddItem("Test Item Man", "models/humans/group02/male_02.mdl", "Description", {
			["cid"] = 3,
			["chinese_takeout"] = 1
		}, {
			["cid"] = 1
		})
	end--]]
	for k, v in pairs(STORED_RECIPES) do
		--printTable(v)
		if v["blueprint"] then
			local data = LocalPlayer():GetCharacter():GetData("blueprints", {})

			--print(v["blueprint"])
			if table.HasValue(data, v["blueprint"]) then
				local item = self:AddItem(v["name"], v["model"], v["desc"], v["req"], v["results"], v["skill"], v["blueprint"],v["guns"], v["entity"])
				item.id = v["id"]
			end
		end
		if not v["blueprint"] then
			local item = self:AddItem(v["name"], v["model"], v["desc"], v["req"], v["results"], v["skill"], v["guns"], v["entity"])
			item.id = v["id"]
		end
		
		--print(v["requirements"])
	end
end

function PANEL:AddItem(name, icon, desc, req, results, skill, blueprint, guns, entity)
	--[[-------------------------------------------------------------------------
	Structure:
	1: Item Name
	2: Icon
	3: Description
	4: Requirements
	5: Results
	---------------------------------------------------------------------------]]
	self.test = self.CraftingList:Add("ixCraftingItem")
	self.test:SetItem(name, icon, desc, req, results, skill, blueprint or false, guns or false, entity or false)
	local recipe = self.CraftingList:AddItem(self.test)
	return self.test
	--self.test:Dock(FILL)
	--self.test2 = self:Add("DPanel")
	--self.test2:Dock(FILL)
end

vgui.Register("ixCrafting", PANEL, "DPanel")
local PANEL = {}

function PANEL:Init()
	self:SetSize(128, 128)
	self.Icon = self:Add("SpawnIcon")
	self.Icon:SetModel("models/player.mdl")
	self.Icon:SetSize(72, 72)
	self.Icon:Center()
	self.button = self:Add("DButton")
	self.button:SetSize(self:GetWide(), self:GetTall())
	self.button.Paint = function() end
	self.button:SetText("")

	function self.button:DoClick()
		local parent = self:GetParent()
		--parent:SetItem("Test Name", "models/humans/group01/male_01.mdl", "Test Description", {"Test Requirements"})
		netstream.Start("ixCraftItem", {parent.id})
	end

	self.name = self:Add("DLabel")
	self.name:Dock(BOTTOM)
	self.name:SetText("Piece of Cloth")
	self.name:SetContentAlignment(5)
	self.name:SetTextColor(color_white)
	self.name:SetFont("ixSmallFont")
	self.name:SetExpensiveShadow(1, Color(0, 0, 0, 200))

	self.name.Paint = function(this, w, h)
		surface.SetDrawColor(0, 0, 0, 75)
		surface.DrawRect(0, 0, w, h)
	end
end

function PANEL:SetItem(name, icon, desc, req, results, skill, blueprint, guns, entity)
	--[[-------------------------------------------------------------------------
	Structure:
	1: Item Name
	2: Icon
	3: Description
	4: Requirements
	5: Results
	---------------------------------------------------------------------------]]
	self.name:SetText(name)
	self.Icon:SetModel(icon)
	self.description = desc
	self.requirements = req
	self.results = results
	self.skill = skill
	self.blueprint = blueprint
	self.guns = guns
	self.entity = entity

	self.button:SetHelixTooltip(function(tooltip)
		local title = tooltip:AddRow("title")
		title:SetImportant()
		title:SetText(self.name:GetText())
		title:SetBackgroundColor(ix.config.Get("color"))
		title:SizeToContents()
		local description = tooltip:AddRow("description")
		description:SetText(self.description)
		description:SizeToContents()
		local requirements = tooltip:AddRow("requirements")
		local realreq = {}

		for k, v in pairs(self.requirements) do
			local item = ix.item.Get(k)
			realreq[#realreq + 1] = item.name .. " (" .. v .. "x)"
		end

		requirements:SetText("Requirements: " .. table.concat(realreq, ", "))
		local missing = {}
		local inv = LocalPlayer():GetCharacter():GetInventory()

		for k, v in pairs(self.requirements) do
			if inv:GetItemCount(k) < v then
				print(inv:GetItemCount(k))
				local i = ix.item.Get(k)
				missing[#missing + 1] = i.name
			end
		end

		if #missing > 0 then
			requirements:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		else
			requirements:SetBackgroundColor(derma.GetColor("Success", tooltip))
		end
		--requirements:SizeToContents()
		if #realreq >= 4 then
			requirements:SizeToContents()
			requirements:SetTall(56)
		else
			requirements:SizeToContents()
		end
		local results = tooltip:AddRow("results")
		local realres = {}

		for k, v in pairs(self.results) do
			local item = ix.item.Get(k)
			realres[#realres + 1] = item.name .. " (" .. v .. "x)"
		end

		results:SetText("Results: " .. table.concat(realres, ", "))

		if self.skill then
			local skill = tooltip:AddRow("skill")
			local skillist = {}

			for k, v in pairs(self.skill) do
				local attrib = ix.attributes.list[k]
				skillist[#skillist + 1] = attrib.name .. " (" .. v .. ")"
			end

			skill:SetText("Required Skills: " .. table.concat(skillist, ", "))
			skill:SizeToContents()

			local skillslist = {}

			for k, v in pairs(self.skill) do
				if LocalPlayer():GetCharacter():GetAttribute(k, 0) < v then
					skillslist[#skillslist + 1] = k
				end
			end
			if #skillslist > 0 then
				skill:SetBackgroundColor(derma.GetColor("Error", tooltip))
			else
				skill:SetBackgroundColor(derma.GetColor("Success", tooltip))
			end
		else
			local skill = tooltip:AddRow("skill")
			skill:SetText("No Required Skills")
			skill:SizeToContents()
		end

		if self.blueprint then
			local bp = tooltip:AddRow("blueprint")
			bp:SetColor(ix.config.Get("color"))
			bp:SetText("Unlocked by Blueprint")
			bp:SizeToContents()
		end
	end)
end

vgui.Register("ixCraftingItem", PANEL, "DPanel")

hook.Add("CreateMenuButtons", "ixCrafting", function(tabs)
	--if (hook.Run("BuildBusinessMenu", tabs) != false) then
	tabs["crafting"] = function(container)
		container:Add("ixCrafting")
	end
end)