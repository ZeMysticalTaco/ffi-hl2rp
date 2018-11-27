--[[-------------------------------------------------------------------------
					CID VIEW
				---------------------------------------------------------------------------]]
surface.CreateFont("BudgetLabelSmall", {
	font = "BudgetLabel",
	size = 15,
	extended = true,
	weight = 500
})

local PANEL = {}

function PANEL:Init()
	ix.gui.cidview = self
	self:SetSize(ScrW() / 2, ScrH() / 2)
	self:Center()
	self:MakePopup()
	self.SidePanel = self:Add("DPanel")
	self.SidePanel:Dock(LEFT)
	--Panel Title
	self.SidePanelTextTitle = self.SidePanel:Add("DLabel")
	self.SidePanelTextTitle:SetContentAlignment(5)
	self.SidePanelTextTitle:SetFont("ixBigFont")
	self.SidePanelTextTitle:SetText("Identification Record")
	self.SidePanelTextTitle:Dock(TOP)
	self.SidePanelTextTitle:SizeToContents()
	self.SidePanelTextTitle:SetExpensiveShadow(3)
	--Panel Information about Citizen
	self.SidePanelTextName = self.SidePanel:Add("DLabel")
	self.SidePanelTextName:SetContentAlignment(5)
	self.SidePanelTextName:SetFont("ixSmallFont")
	self.SidePanelTextName:SetText("Citizen Name: John Doe\nCitizen ID: 11111\nIssue Date: 10/28/18\nIssuing Officer: MPF-GAY.10100")
	self.SidePanelTextName:Dock(TOP)
	self.SidePanelTextName:SizeToContents()
	self.SidePanelTextName:SetExpensiveShadow(3)
	local w, h = self.SidePanel:GetSize()
	self.SidePanel:SetSize(300, h)
	self.AddRecordButton = self:Add("DButton")
	self.AddRecordButton:SetText("Add Record")
	self.AddRecordButton:Dock(BOTTOM)
	self.CheckBox1 = self.SidePanel:Add("DCheckBoxLabel")
	self.CheckBox1:SetPos(20, 200)
	self.CheckBox1:SetText("Wanted for Questioning")
	self.CheckBox1:SetTextColor(Color(255, 255, 255, 255))
	self.CheckBox2 = self.SidePanel:Add("DCheckBoxLabel")
	self.CheckBox2:SetPos(20, 215)
	self.CheckBox2:SetText("Survey Closely")
	self.CheckBox2:SetTextColor(Color(255, 255, 255, 255))
	self.CheckBox3 = self.SidePanel:Add("DCheckBoxLabel")
	self.CheckBox3:SetPos(20, 230)
	self.CheckBox3:SetText("Elevated Citizen Status")
	self.CheckBox3:SetTextColor(Color(255, 255, 255, 255))

	function self.AddRecordButton:DoClick()
		local ui = vgui.Create("DFrame")
		ui:SetSize(ScrW() / 3, ScrH() / 7)
		ui:Center()
		ui:MakePopup()
		local titlebox = ui:Add("DTextEntry")
		titlebox:Dock(TOP)
		titlebox:SetText("Record Title...")
		local reasonbox = ui:Add("DTextEntry")
		reasonbox:Dock(TOP)
		reasonbox:SetText("Record Reason...")
		reasonbox:SetTall(50)
		reasonbox:SetMultiline(true)
		local submitbutton = ui:Add("DButton")
		submitbutton:Dock(BOTTOM)
		submitbutton:SetText("Submit")
		local numberwang = ui:Add("DNumberWang")
		numberwang:Dock(BOTTOM)

		function submitbutton:DoClick()
			ix.gui.cidview:AddRecord(titlebox:GetText(), reasonbox:GetText(), LocalPlayer():Name(), numberwang:GetValue())
			ui:Close()
		end
	end

	self.ViewRecordButton = self:Add("DButton")
	self.ViewRecordButton:SetText("View Record")
	self.ViewRecordButton:Dock(BOTTOM)

	function self.ViewRecordButton:DoClick()
		local selected = ix.gui.cidview.ListView:GetSelectedLine()
		local line = ix.gui.cidview.ListView:GetLine(selected)
		local record_title = tostring(line:GetColumnText(1))
		local ui = vgui.Create("DFrame")
		ui:SetSize(ScrW() / 3, ScrH() / 3)
		ui:Center()
		ui:MakePopup()
		local title = ui:Add("DLabel")
		title:SetContentAlignment(5)
		title:Dock(TOP)
		title:SetText("Viewing Record: " .. record_title)
		title:SetFont("ixSmallFont")
		title:SetExpensiveShadow(1)
		title:SetTall(32)
		local descriptiontitle = ui:Add("DLabel")
		descriptiontitle:SetContentAlignment(5)
		descriptiontitle:Dock(TOP)
		descriptiontitle:SetText("Description")
		descriptiontitle:SetFont("ixSmallFont")
		descriptiontitle:SetExpensiveShadow(1)
		descriptiontitle:SetTall(32)
		local description = ui:Add("DLabel")
		description:SetContentAlignment(5)
		description:Dock(TOP)
		description:SetText(line:GetColumnText(2) .. " ~" .. line:GetColumnText(3))
		description:SetFont("ixSmallFont")
		description:SetExpensiveShadow(1)
		description:SizeToContents()
		description:SetWrap(true)
		description:SetAutoStretchVertical(true)
		local removebox = ui:Add("DButton")
		removebox:Dock(BOTTOM)
		removebox:SetText("Remove Record")

		function removebox.DoClick()
			ix.gui.cidview:RemoveRecord()
		end
	end

	self.ListView = self:Add("DListView")
	self.ListView:Dock(FILL)
	self.ListView:AddColumn("Record Title")
	self.ListView:AddColumn("Record Reason")
	self.ListView:AddColumn("Issuing Officer")
	self.ListView:AddColumn("Point Change")
end

function PANEL:SetItem(item)
	--this is where all the data will be pulled
	ix.gui.cidview.item = item
	ix.gui.cidview.itemid = item.id
	self.SidePanelTextName:SetText("Citizen Name: " .. item:GetData("citizen_name", "Unissued") .. "\n" .. "Citizen ID: " .. item:GetData("cid", "000000") .. "\n" .. "Issue Date: " .. item:GetData("issue_date", "Unissued") .. "\n" .. "Issuing Officer: " .. item:GetData("officer", "Unissued") .. "\nTotal Loyalty Points: " .. item:GetData("points", 0))
	self.SidePanelTextName:SizeToContents()

	for k, v in pairs(item:GetData("record", {})) do
		local line = self.ListView:AddLine(v[1], v[2], v[3], v[4])

		if v[4] > 0 then
			function line.Paint(this, w, h)
				surface.SetDrawColor(Color(0, 255, 0, 150))
				surface.DrawRect(0, 0, w, h)
			end
		elseif v[4] < 0 then
			function line.Paint(this, w, h)
				surface.SetDrawColor(Color(255, 0, 0, 150))
				surface.DrawRect(0, 0, w, h)
			end
		else
			function line.Paint(this, w, h)
				surface.SetDrawColor(Color(50, 50, 50, 150))
				surface.DrawRect(0, 0, w, h)
			end
		end

		line.id = k
	end

	local data = item:GetData("checkboxes", {})
	PrintTable(data)

	for k, v in pairs(data) do
		if item:GetData("elevated", false) then
			self.CheckBox3:SetChecked(true)
		end

		if k == "wanted" and v == true then
			self.CheckBox1:SetChecked(true)
		end

		if k == "survey" and v == true then
			self.CheckBox2:SetChecked(true)
		end
	end
end

function PANEL:OnClose()
	local item = ix.gui.cidview.item
	local checkbox1 = self.CheckBox1:GetChecked()
	local checkbox2 = self.CheckBox2:GetChecked()
	local checkbox3 = self.CheckBox3:GetChecked()

	--[[-------------------------------------------------------------------------
	Manually set these to false because netstream can't send nil values.
	---------------------------------------------------------------------------]]
	if not checkbox1 then
		checkbox1 = false
	end

	if not checkbox2 then
		checkbox2 = false
	end

	if not checkbox3 then
		checkbox3 = false
	end

	netstream.Start("updatecheckboxes", {item.id, checkbox1, checkbox2, checkbox3})
end

function PANEL:AddRecord(title, reason, ply, points)
	local line = self.ListView:AddLine(title, reason, ply, points)

	if points > 0 then
		function line.Paint(this, w, h)
			surface.SetDrawColor(Color(0, 255, 0, 150))
			surface.DrawRect(0, 0, w, h)
		end
	elseif points < 0 then
		function line.Paint(this, w, h)
			surface.SetDrawColor(Color(255, 0, 0, 150))
			surface.DrawRect(0, 0, w, h)
		end
	else
		function line.Paint(this, w, h)
			surface.SetDrawColor(Color(50, 50, 50, 150))
			surface.DrawRect(0, 0, w, h)
		end
	end

	--Add additional logic for sending a net message to the server to add it to item data.
	netstream.Start("IDAddRecord", {title, reason, ply, ix.gui.cidview.itemid, points})
end

function PANEL:RemoveRecord()
	local selLine = self.ListView:GetSelectedLine()
	local panLine = self.ListView:GetLine(selLine)
	--Add additional logic for sending a net message to the server to add it to item data.
	netstream.Start("IDRemoveRecord", {title, reason, ply, ix.gui.cidview.itemid, panLine.id})
	panLine:Remove()
end

vgui.Register("ixRecordPanel", PANEL, "DFrame")
--[[-------------------------------------------------------------------------
			CID CREATOR
		---------------------------------------------------------------------------]]
local PANEL = {}

function PANEL:Init()
	ix.gui.cidcreator = self
	self:SetSize(ScrW() / 4, ScrH() / 7)
	self:Center()
	self:MakePopup()
	self:SetBackgroundBlur(true)
	self.toptext = self:Add("DLabel")
	self.toptext:SetContentAlignment(5)
	self.toptext:Dock(TOP)
	self.toptext:SetText("Automatic Registration Center")
	self.toptext:SetExpensiveShadow(2)
	self.toptext:SetFont("ixSmallFont")
	self.toptext:SetTall(32)
	self.nametext = self:Add("DLabel")
	self.nametext:SetContentAlignment(5)
	self.nametext:Dock(TOP)
	self.nametext:SetText("Input Name")
	self.nametext:SetExpensiveShadow(2)
	self.nametext:SetFont("ixSmallFont")
	self.nameinput = self:Add("DTextEntry")
	self.nameinput:Dock(TOP)
	self.itemswang = self:Add("DComboBox")
	self.itemswang:Dock(BOTTOM)
	self.itemswang:SetValue("Or select a transfer card.")

	self.itemswang.OnSelect = function()
		self.nameinput:SetDisabled(true)
		self.nameinput:SetText("")
	end

	self.submitbutton = self:Add("DButton")
	self.submitbutton:Dock(BOTTOM)
	self.submitbutton:SetText("Submit")

	for k, v in pairs(LocalPlayer():GetCharacter():GetInventory():GetItems()) do
		if v.uniqueID == "transfer_papers" then
			self.itemswang:AddChoice(v:GetData("citizen_name", "no name?????"))
		end
	end

	function self.submitbutton:DoClick()
		if string.len(ix.gui.cidcreator.nameinput:GetText()) == 0 and not ix.gui.cidcreator.itemswang:GetSelected() then
			return
		end

		if string.len(ix.gui.cidcreator.nameinput:GetText()) > 1 then
			netstream.Start("SubmitNewCID", {ix.gui.cidcreator.nameinput:GetText()})
			ix.gui.cidcreator:Close()
		elseif ix.gui.cidcreator.itemswang:GetSelected() ~= "Or select a transfer card." then
			netstream.Start("SubmitNewCID", {ix.gui.cidcreator.itemswang:GetSelected()})
			ix.gui.cidcreator:Close()
		else
			LocalPlayer():Notify("You need to input a name or select a transfer card!")
		end
	end
end

vgui.Register("ixCIDCreater", PANEL, "DFrame")
--[[ LOYALTY KIOSK ]]
local PANEL = {}

function PANEL:Init()
	ix.gui.loyalty = self
	self:SetSize(ScrW() / 2.8, ScrH() / 2)
	self:Center()
	self:MakePopup()
	self.infotext = self:Add("DLabel")
	self.infotext:Dock(TOP)
	self.infotext:SetContentAlignment(5)
	self.infotext:SetText("Click on an icon to receive it's item, or hover over it to get more information.")
	self.infotext:SetFont("ixSmallFont")
	self.infotext:SetExpensiveShadow(1)

	self.infotext.Paint = function(this, w, h)
		surface.SetDrawColor(0, 0, 0, 75)
		surface.DrawRect(0, 0, w, h)
	end

	--self:MakePopup()
	--self:SetTitle("Crafting")
	self.LoyaltyList = self:Add("DPanelList")
	self.LoyaltyList:Dock(FILL)
	self.LoyaltyList:SetSpacing(2)
	self.LoyaltyList:SetPadding(5)
	local w, h = self:GetSize()
	self.LoyaltyList:DockMargin(0, 0, 0, 0)
	self.LoyaltyList:EnableHorizontal(true)
	self.LoyaltyList:EnableVerticalScrollbar(true)

	--[[for i = 1, 50 do
		self:AddItem("Test Item Man", "models/humans/group02/male_02.mdl", "Description", {
			["cid"] = 3,
			["chinese_takeout"] = 1
		}, {
			["cid"] = 1
		})
	end--]]
	for k, v in pairs(STORED_LOYALTY) do
		--printTable(v)
		if v.data.factions then
			for k2, v2 in pairs(v.data.factions) do
				if LocalPlayer():Team() == v2 then
					self:AddItem(v["name"], v["model"], v["desc"], v["results"], v["id"], v["cooldown"], v["data"])
				end
			end
		end

		if not v.data.factions then
			self:AddItem(v["name"], v["model"], v["desc"], v["results"], v["id"], v["cooldown"], v["data"])
		end
	end

	self.CIDList = self:Add("DComboBox")
	self.CIDList:Dock(BOTTOM)
	self.CIDList:SetText("Select the CID you want to use for this transaction.")

	for k, v in pairs(LocalPlayer():GetCharacter():GetInventory():GetItems()) do
		if v.uniqueID == "cid" then
			if v:GetData("citizen_name") and v:GetData("cid") then
				local str = v:GetData("citizen_name") .. " #" .. v:GetData("cid")
				self.CIDList:AddChoice(str, v)
			end
		end
	end

	ix.gui.cidlist = self.CIDList

	function self.CIDList:OnSelect(index, value, data)
		print("test")
		print(self:GetSelected())
		print(data)
		ix.gui.loyalty.cid = data:GetID()
	end
end

function PANEL:AddItem(name, icon, desc, results, id, cooldown, data)
	--[[-------------------------------------------------------------------------
	Structure:
	1: Item Name
	2: Icon
	3: Description
	4: Requirements
	5: Results
	---------------------------------------------------------------------------]]
	--	print(self.LoyaltyList)

	self.test = self.LoyaltyList:Add("ixLoyaltyItem")
	self.test:SetItem(name, icon, desc, results, id, cooldown)
	self.LoyaltyList:AddItem(self.test)

	if data.disables then
		for k, v in pairs(data.disables) do
			local icon = ix.gui.gui_icons[v]
			if icon then
				icon:Remove()
			end
		end
	end

	--self.test:Dock(FILL)
	--self.test2 = self:Add("DPanel")
	--self.test2:Dock(FILL)
end

vgui.Register("ixLoyalty", PANEL, "DFrame")
local PANEL = {}

function PANEL:Init()
	self:SetSize(128, 128)
	self.Icon = self:Add("SpawnIcon")
	self.Icon:SetModel("models/player.mdl")
	self.Icon:SetSize(72, 72)
	self.Icon:Center()

	function self.Icon:DoClick()
		local parent = self:GetParent()
		--parent:SetItem("Test Name", "models/humans/group01/male_01.mdl", "Test Description", {"Test Requirements"})
		local cid = ix.gui.loyalty.cid
		local ent = ix.gui.loyalty.ent
		netstream.Start("ixLoyaltyMachine", {parent.results, parent.id, parent.cooldown, ent, cid})
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
ix.gui.gui_icons = {}
function PANEL:SetItem(name, icon, desc, results, id, cooldown)
	ix.gui.gui_icons[id] = self
	self.name:SetText(name)
	self.Icon:SetModel(icon)
	self.description = desc
	self.requirements = req
	self.results = results
	self.skill = skill
	self.id = id

	if cooldown then
		self.cooldown = cooldown
	end

	self.Icon:SetHelixTooltip(function(tooltip)
		local title = tooltip:AddRow("title")
		title:SetImportant()
		title:SetText(self.name:GetText())
		title:SetBackgroundColor(ix.config.Get("color"))
		title:SizeToContents()
		local description = tooltip:AddRow("description")
		description:SetText(self.description)
		description:SizeToContents()
	end)
end

vgui.Register("ixLoyaltyItem", PANEL, "DPanel")
--end
--vgui.Create("ixLoyalty")