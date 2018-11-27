PLUGIN.name = "Combine MOTD"
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.description = "Why use viewobjectives when you can just, not use viewobjectives?"

ix.command.Add("ViewMOTD", {
	OnRun = function(self, client)
		local update = ix.data.Get("CMBUpdates", "There is currently no important message for today.")
		local directives = ix.data.Get("CMBDirectives", "There are currently no directives.")
		local listings = ix.data.Get("listings", {})
		netstream.Start(client, "OpenCombineMOTD", {update, directives, listings})
	end
})

if CLIENT then
	local PLUGIN = PLUGIN
	local PANEL = {}
	--[[-------------------------------------------------------------------------
	Main MOTD Panel
	---------------------------------------------------------------------------]]
	function PANEL:Init()
		if not LocalPlayer():IsCombine() then return end
		ix.gui.cmotd = self
		self:SetSize(ScrW() / 3, ScrH() / 2.1)
		self:Center()
		self:MakePopup()
		self:SetTitle("Systems Booted, Welcome.")
		//Scroll Panel
		self.ScrollPanel = self:Add("DScrollPanel")
		self.ScrollPanel:Dock(FILL)
		self.ScrollPanel:SetVerticalScrollbarEnabled(true)
		//Title
		self.TitleText = self:Add("DLabel")
		self.TitleText:SetFont("ixBigFont")
		self.TitleText:SetText("Message of the Day")
		self.TitleText:SetContentAlignment(5)
		self.TitleText:Dock(TOP)
		self.TitleText:SizeToContents()
		self.ScrollPanel:AddItem(self.TitleText)
		//Title of Important Text
		self.ImportantTextT = self:Add("DLabel")
		self.ImportantTextT:Dock(TOP)
		self.ImportantTextT:SetFont("ixMediumFont")
		self.ImportantTextT:SetText("Current Update")
		self.ImportantTextT:SetContentAlignment(5)
		self.ImportantTextT:SetTall(42)
		self.ScrollPanel:AddItem(self.ImportantTextT)
		//Important Text
		self.ImportantText = self:Add("DLabel")
		self.ImportantText:Dock(TOP)
		self.ImportantText:SetFont("ixSmallFont")
		self.ImportantText:SetContentAlignment(5)
		self.ImportantText:SetWrap(true)
		self.ScrollPanel:AddItem(self.ImportantText)
		//Directives Title
		self.DirectivesT = self:Add("DLabel")
		self.DirectivesT:Dock(TOP)
		self.DirectivesT:SetTall(42)
		self.DirectivesT:SetFont("ixMediumFont")
		self.DirectivesT:SetText("Current Directives")
		self.DirectivesT:SetContentAlignment(5)
		self.ScrollPanel:AddItem(self.DirectivesT)

		//Directives
		self.Directives = self:Add("DLabel")
		self.Directives:Dock(TOP)
		self.Directives:SetFont("ixSmallFont")
		self.Directives:SetContentAlignment(5)
		self.Directives:SetWrap(true)
		self.ScrollPanel:AddItem(self.Directives)

		//Unit Status Title
		self.UnitT = self:Add("DLabel")
		self.UnitT:Dock(TOP)
		self.UnitT:SetTall(42)
		self.UnitT:SetFont("ixMediumFont")
		self.UnitT:SetText("Individual Status")
		self.UnitT:SetContentAlignment(5)
		self.ScrollPanel:AddItem(self.UnitT)

		//Unit Status
		self.Unit = self:Add("DLabel")
		self.Unit:Dock(TOP)
		self.Unit:SetFont("ixSmallFont")
		self.Unit:SetContentAlignment(5)
		local rank = string.match(LocalPlayer():Name(), "%p%d%d%p") or string.match(LocalPlayer():Name(), "%p%a%a")
		self.Unit:SetText("Unit Identifier & Rank: " .. string.match(LocalPlayer():Name(), "%d%d%d") .. "" .. rank .. "\nUnit Vital Status: " .. LocalPlayer():Health() .. "/100" .. "\nUnit Protection Status: " .. LocalPlayer():Armor() .. "/100" .. "\nRespiratory Systems: 100/100\nRadio Systems: 100/100.. Connected to CCA MAIN!\nMalfunctions Detected: NONE\nNext Maintenance Due: N/A")
		self.Unit:SizeToContents()
		self.ScrollPanel:AddItem(self.Unit)
		//buttons
		--self.Button1 = self:Add("DButton")
		----self.Button1:Dock(BOTTOM)
		--self.Button1:SetText("Be On Lookout(BOL) List")
		self.Button2 = self:Add("DButton")
		self.Button2:Dock(BOTTOM)
		self.Button2:SetText("Close")
		self.Button2.DoClick = function()
			ix.gui.cmotd:Close()
		end
		if LocalPlayer():IsCombineCommand() then
			self.Button3 = self:Add("DButton")
			self.Button3:Dock(BOTTOM)
			self.Button3:SetText("Edit")
		end
		self.Button4 = self:Add("DButton")
		self.Button4:Dock(BOTTOM)
		self.Button4:SetText("Recent Updates")

		self.Button4.DoClick = function()
			PLUGIN:OpenUnitListings()
		end
	end

	function PANEL:SetUpdates(text)
		self.ImportantText:SetText(text)
	end

	function PANEL:SetDirectives(text)
		self.Directives:SetText(text)
	end

	vgui.Register("ixCMBMOTD", PANEL, "DFrame")

	netstream.Hook("OpenCombineMOTD", function(data)
		if LocalPlayer():IsCombine() then
			local ui = vgui.Create("ixCMBMOTD")
			ui:SetUpdates(data[1])
			ui:SetDirectives(data[2])
			ui.listings = data[3]
		end
	end)
	function PLUGIN:GetListings()
		return ix.gui.cmotd.listings
	end
	function PLUGIN:OpenUnitListings()
		if not LocalPlayer():IsCombine() then return end
		local ui = vgui.Create("ixCMBListings")
		for k,v in SortedPairs(ix.gui.cmotd.listings) do
			ui:PopulateListings(v.name, v.title, v.description, k, v.date)
		end
		
	end

	--[[-------------------------------------------------------------------------
	Unit Listings Panel, a global update panel any unit can contribute to.
	---------------------------------------------------------------------------]]

	local PANEL = {}
	function PANEL:Init()
		if not LocalPlayer():IsCombine() then return end
		ix.gui.unitlistings = self
		self:SetSize(ScrW() / 2.5, ScrH() / 2.5)
		self:MakePopup()
		self:Center()


		self.ContainerPanel = self:Add("DPanel")
		self.ContainerPanel:Dock(LEFT)
		self.ContainerPanel:SetWide(256)
		
		self.ScrollPanel = self.ContainerPanel:Add("DScrollPanel")
		self.ScrollPanel:Dock(FILL)
		self.ScrollPanel:SetVerticalScrollbarEnabled(true)

		
		self.ContainerPanel.UnitT = self.ContainerPanel:Add("DLabel")
		self.ContainerPanel.UnitT:Dock(TOP)
		self.ContainerPanel.UnitT:SetFont("ixMediumFont")
		self.ContainerPanel.UnitT:SetText("Unit Reporting")
		self.ContainerPanel.UnitT:SizeToContents()
		self.ScrollPanel:AddItem(self.ContainerPanel.UnitT)


		self.ContainerPanel.Unit = self.ContainerPanel:Add("DLabel")
		self.ContainerPanel.Unit:Dock(TOP)
		self.ContainerPanel.Unit:SetFont("ixSmallFont")
		self.ContainerPanel.Unit:SetText("No Entry Selected")
		self.ScrollPanel:AddItem(self.ContainerPanel.Unit)

		self.ContainerPanel.Title = self.ContainerPanel:Add("DLabel")
		self.ContainerPanel.Title:Dock(TOP)
		self.ContainerPanel.Title:SetFont("ixMediumFont")
		self.ContainerPanel.Title:SetText("Entry Title")
		self.ContainerPanel.Title:SizeToContents()
		self.ScrollPanel:AddItem(self.ContainerPanel.Title)

		self.ContainerPanel.TitleText = self.ContainerPanel:Add("DLabel")
		self.ContainerPanel.TitleText:Dock(TOP)
		self.ContainerPanel.TitleText:SetFont("ixSmallFont")
		self.ContainerPanel.TitleText:SetText("No Entry Selected")
		self.ScrollPanel:AddItem(self.ContainerPanel.TitleText)


		self.ContainerPanel.EntryTextT = self.ContainerPanel:Add("DLabel")
		self.ContainerPanel.EntryTextT:Dock(TOP)
		self.ContainerPanel.EntryTextT:SetFont("ixMediumFont")
		self.ContainerPanel.EntryTextT:SetText("Entry Description")
		self.ContainerPanel.EntryTextT:SizeToContents()
		self.ScrollPanel:AddItem(self.ContainerPanel.EntryTextT)

		self.ContainerPanel.EntryText = self.ContainerPanel:Add("DLabel")
		self.ContainerPanel.EntryText:Dock(TOP)
		self.ContainerPanel.EntryText:SetFont("ixSmallFont")
		self.ContainerPanel.EntryText:SetText("No Entry Selected")
		self.ContainerPanel.EntryText:SetWrap(true)
		self.ContainerPanel.EntryText:SetAutoStretchVertical(true)
		self.ScrollPanel:AddItem(self.ContainerPanel.EntryText)

		self.ListingsPanel = self:Add("DListView")
		self.ListingsPanel:Dock(FILL)
		self.ListingsPanel:AddColumn("Entry Title")
		self.ListingsPanel:AddColumn("Entry Description")
		self.ListingsPanel:AddColumn("Entry Date")
		self.ListingsPanel.OnRowSelected = function(panel, rowindex, row)
			ix.gui.unitlistings.ContainerPanel.Unit:SetText(row.unit)
			ix.gui.unitlistings.ContainerPanel.TitleText:SetText(row:GetValue(2))
			ix.gui.unitlistings.ContainerPanel.EntryText:SetText(row:GetValue(3))
			ix.gui.unitlistings.SelectedRow = row
			ix.gui.unitlistings.SelectedRowIndex = rowindex
		end

		self.AddButton = self:Add("DButton")
		self.AddButton:Dock(BOTTOM)
		self.AddButton:SetText("Add Entry")

		function self.AddButton:DoClick()
			local ui = vgui.Create("DFrame")
			ix.gui.addunitlisting = ui
			ui:SetSize(ScrW() / 3, ScrH() / 3)
			ui:Center()
			ui:SetBackgroundBlur(true)
			ui:MakePopup()

			ui.title = ui:Add("DTextEntry")
			ui.title:Dock(TOP)
			ui.title:SetText("Title")

			ui.description = ui:Add("DTextEntry")
			ui.description:Dock(TOP)
			ui.description:SetText("Description")
			ui.description:SetMultiline(true)
			ui.description:SetTall(256)

			ui.button = ui:Add("DButton")
			ui.button:Dock(BOTTOM)
			ui.button:SetText("Add Entry")
			ui.button.DoClick = function()
				ix.gui.unitlistings:AddListing(ui.title:GetText(), ui.description:GetText(), "date")
				ui:Close()
			end
		end

		if LocalPlayer():IsCombineCommand() then
			self.RemoveButton = self:Add("DButton")
			self.RemoveButton:Dock(BOTTOM)
			self.RemoveButton:SetText("Remove Entry")
			self.RemoveButton.DoClick = function()
				ix.gui.unitlistings:RemoveListing(ix.gui.unitlistings.SelectedRow.index, ix.gui.unitlistings.SelectedRowIndex)
			end
		end

	end

	function PANEL:AddListing(title, description, index, date)
		netstream.Start("AddUnitListing", {title, description})
		local line = self.ListingsPanel:AddLine("date", title, description)
		line.unit = LocalPlayer():Name()
		line.index = index
		ix.gui.cmotd.listings[#ix.gui.cmotd.listings] = {
			["name"] = LocalPlayer():Name(),
			["title"] = title,
			["description"] = description,
			["date"] = "close and reopen"
		}
	end

	function PANEL:RemoveListing(index, row)
		print(index)
		netstream.Start("RemoveUnitListing", {index})
		ix.gui.unitlistings.ListingsPanel:RemoveLine(row)
		ix.gui.cmotd.listings[index] = nil
	end

	function PANEL:PopulateListings(name, title, description, index, date)
			local line = self.ListingsPanel:AddLine(date, title, description)
			line.unit = name
			line.index = index
	end
	vgui.Register("ixCMBListings", PANEL, "DFrame")
else
	netstream.Hook("AddUnitListing", function(ply, data)
		local Timestamp = os.time()
		local TimeString = os.date( "%d/%m/%Y - %H:%M:%S" , Timestamp )
		local datal = ix.data.Get("listings", {})
		local data2 = {
			["name"] = ply:Name(),
			["title"] = data[1],
			["description"] = data[2],
			["date"] = TimeString
		}
		datal[#datal + 1] = data2
		ix.data.Set("listings", datal, false, true)
	end)

	netstream.Hook("RemoveUnitListing", function(ply, data)
		ix.log.AddRaw(ply:Name() .. " has removed a unit listing.")
		local datak = ix.data.Get("listings")
		print(data[1])
		print("before")
		PrintTable(datak)
		datak[data[1]] = nil
		print("after")
		PrintTable(datak)
		ix.data.Set("listings", datak, false, true)
	end)
end