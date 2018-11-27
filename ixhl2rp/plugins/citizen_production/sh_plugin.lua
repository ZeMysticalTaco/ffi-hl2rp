local PLUGIN = PLUGIN
PLUGIN.name = "Citizen Production"
PLUGIN.author = "ZeMysticalTaco & Black Tea"
PLUGIN.desc = "A full fledged Citizen Production System."
PLUGIN.craftingData = {}
local playerMeta = FindMetaTable("Player")
local entityMeta = FindMetaTable("Entity")
ix.util.Include("sh_items.lua")

function playerMeta:canCraft(craftID)
	-- is player occuping the crafting table?
	-- is player is capable of crafting? (ex. not dead, not tied, etc...)
	-- does player has enough ingredients?
	-- has flags or perks that preventing player from crafting item?
	if (not self:Alive()) then
		return false
	end
	-- add some conditions

	return true
end

function playerMeta:doCraft(craftID)
	-- check the condition
	-- strip the ingredients
	-- add the result into player's inventory
	return true
end

function entityMeta:isCraftingTable()
	local class = self:GetClass()

	return (class == "ix_craftingtable")
end

-- Register HUD Bars.
if (CLIENT) then
	netstream.Hook("craftingTableOpen", function(entity, index)
		local inventory = ix.item.inventories[index]

		if (IsValid(entity) and inventory and inventory.slots) then
			ix.gui.inv1 = vgui.Create("ixInventory")
			ix.gui.inv1:ShowCloseButton(true)
			ix.gui.inv1:Center()
			ix.gui.inv1:MakePopup()
			local inventory2 = LocalPlayer():GetChar():GetInventory()

			if (inventory2) then
				ix.gui.inv1:SetInventory(inventory2)
			end

			local panel = vgui.Create("ixInventory")
			panel:ShowCloseButton(true)
			panel:SetTitle("Crafting Table")
			panel:Center()
			panel:SetInventory(inventory)
			panel:MoveLeftOf(ix.gui.inv1, 4)

			panel.OnClose = function(this)
				if (IsValid(ix.gui.inv1) and not IsValid(ix.gui.menu)) then
					ix.gui.inv1:Remove()
				end
			end

			--netstream.Start("invExit")
			function ix.gui.inv1:OnClose()
				if (IsValid(panel) and not IsValid(ix.gui.menu)) then
					panel:Remove()
				end
				--netstream.Start("invExit")
			end

			local actPanel = vgui.Create("DPanel")
			--actPanel:SetDrawOnTop(true)
			actPanel:SetSize(100, panel:GetTall())

			actPanel.Paint = function()
				local col = Color(50, 50, 50, 50)
				draw.RoundedBox(4, 0, 0, actPanel:GetWide(), actPanel:GetTall(), Color(col.r, col.g, col.b, 255))
			end

			actPanel.Think = function(this)
				if (not panel or not panel:IsValid() or not panel:IsVisible()) then
					this:Remove()

					return
				end

				local x, y = panel:GetPos()
				this:SetPos(x - this:GetWide() - 5, y)
			end

			local btn = actPanel:Add("DButton")
			btn:Dock(TOP)
			btn:SetText("Produce!")
			btn:SetColor(Color(255, 255, 255, 255))
			btn:DockMargin(5, 5, 5, 0)

			btn.Paint = function()
				draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(0, 0, 0, 225))
			end

			function btn.DoClick()
				netstream.Start("doCraft", entity, v)
			end

			if LocalPlayer():Team() == FACTION_CWU or LocalPlayer():IsCombine() then
				local btn2 = actPanel:Add("DButton")
				btn2:Dock(TOP)
				btn2:SetText("Menu")

				function btn2.DoClick()
					vgui.Create("ixProductionGet")
				end

				btn2:DockMargin(5, 5, 5, 0)

				btn2.Paint = function()
					draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(0, 0, 0, 225))
				end
			end

			ix.gui["inv" .. index] = panel
		end
	end)

	--[[
		local savedTable = self:GetData() or {}

		for k, v in ipairs(savedTable) do
			local stove = ents.Create(v.class)
			stove:SetPos(v.pos)
			stove:SetAngles(v.ang)
			stove:Spawn()
			stove:Activate()
		end
		]]
	--[[
		local savedTable = {}

		for k, v in ipairs(ents.GetAll()) do
			if (v:isStove()) then
				table.insert(savedTable, {class = v:GetClass(), pos = v:GetPos(), ang = v:GetAngles()})
			end
		end

		self:SetData(savedTable)
		]]
	local PANEL = {}

	function PANEL:Init()
		self:SetSize(ScrW() / 2, ScrH() / 2)
		self:Center()
		self:MakePopup()
		self.ScrollPanel = self:Add("DScrollPanel")
		self.ScrollPanel:Dock(FILL)
		self.ScrollPanel:SetVerticalScrollbarEnabled(true)
		ix.gui.prodmenu = self

		for i, o in pairs(ix.item.list) do
			if o.category == "Schematics" then
				local title = self:Add("DLabel")
				title:Dock(TOP)
				title:SetContentAlignment(5)
				title:SetText(o.name)
				title:SetFont("ixBigFont")
				title:SizeToContents()
				self.ScrollPanel:AddItem(title)
				local btn = self:Add("DButton")
				btn:Dock(TOP)
				btn:SetText(o.name)
				btn.item = o.uniqueID
				self.ScrollPanel:AddItem(btn)

				function btn:DoClick()
					netstream.Start("GetProductionItem", {btn.item})
				end

				for i2, o2 in pairs(o.requirements) do
					local item = ix.item.Get(o2[1])
					local button = self:Add("DButton")
					button:Dock(TOP)
					button:SetText(item.name)
					button.item = item.uniqueID
					self.ScrollPanel:AddItem(button)

					function button:DoClick()
						netstream.Start("GetProductionItem", {button.item})
					end
				end
			end
		end
	end

	vgui.Register("ixProductionGet", PANEL, "DFrame")
	--[[-------------------------------------------------------------------------
	no cheating allowed here!
	---------------------------------------------------------------------------]]
else
	allowed_items = {}

	for k2, v2 in pairs(ix.item.list) do
		if v2.category == "Schematics" then
			allowed_items[#allowed_items + 1] = v2.uniqueID

			for k3, v3 in pairs(v2.requirements) do
				allowed_items[#allowed_items + 1] = v3[1]
			end
		end
	end

	netstream.Hook("GetProductionItem", function(ply, data)
		if not table.HasValue(allowed_items, data[1]) then
			return
		end

		for k, v in pairs(ents.FindInSphere(ply:GetPos(), 128)) do
			if v:GetClass() == "ix_craftingtable" then
				local item = ix.item.Get(data[1])
				ply:Notify("You have requested and acquired 1 " .. item.name)
				ply:GetCharacter():GetInventory():Add(item.uniqueID, 1)

				return
			end
		end
	end)

	local PLUGIN = PLUGIN

	function PLUGIN:LoadData()
	end

	function PLUGIN:SaveData()
	end

	function PLUGIN:PlayerDeath(client)
	end

	function PLUGIN:PlayerSpawn(client)
	end
end