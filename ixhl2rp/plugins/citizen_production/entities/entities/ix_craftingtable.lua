AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Crafting Table"
ENT.Author = "Black Tea"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup 		= RENDERGROUP_BOTH
ENT.Category = "ixScript"
ENT.invType = "crafttable"
ix.item.RegisterInv(ENT.invType, 5, 4)

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_wasteland/controlroom_desk001b.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetNetVar("active", false)
		self:SetUseType(SIMPLE_USE)
		self.loopsound = CreateSound(self, "plats/elevator_move_loop1.wav")
		self.receivers = {}
		local physicsObject = self:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			physicsObject:Wake()
		end

		ix.item.NewInv(0, self.invType, function(inventory)
			self:SetInventory(inventory)
			inventory.noBags = true

			function inventory:onCanTransfer(client, oldX, oldY, x, y, NewInvID)
				return hook.Run("StorageCanTransfer", inventory, client, oldX, oldY, x, y, NewInvID)
			end
		end)
	end

	function ENT:activate(client)
		if (client:canCraft()) then
			local blueprint, weapon
			local blurprintNum, weaponNum = 0, 0
			local inv = self:GetInventory()
			local craftableItems = inv:GetItems()

			for k, v in pairs(craftableItems) do
				if (v.isBlueprint) then
					blueprint = v
					blurprintNum = blurprintNum + 1
				end

				if (v.isWeapon) then
					weapon = v
					weaponNum = weaponNum + 1
				end
			end
			self:EmitSound("physics/metal/metal_barrel_impact_hard"..math.random(1,7)..".wav")
			client:ForceSequence("throwitem")
			-- this part is for generic crafting
			if (blueprint) then
				if (blurprintNum == 1) then
					local itemsToRemove = {}
					for _, req in ipairs(blueprint.requirements) do
						local item = inv:GetItemCount(req[1])
						
						if (item < req[2]) then
							client:NotifyLocalized("You need more crafting ingredients to craft this recipe.")
							return false
						else
							table.insert(itemsToRemove, {req[1], req[2]})
						end
					end

					for _, q in ipairs(itemsToRemove) do
						for i=1, q[2] do
							inv:HasItem(q[1]):Remove()
						end
					end

					local notified = false
					for _, add in ipairs(blueprint.result) do
						for i=1, add[2] do
							local succ, res = self:GetInventory():Add(add[1])

							if (!succ) then
								if (res == "noSpace") then
									if (notified) then
										client:NotifyLocalized("You don't have enough inventory space.")

										notified = true
									end

									ix.item.Spawn(add[1], self:GetPos() + self:GetUp() * 15)
								else
									client:NotifyLocalized("Uncertified access, this incident has been logged.")
									ix.log.AddRaw(client:Name() .. " uncertified table access, potential exploit?")
								end
							end
						end
					end

					return true
				else
					if (blurprintNum > 1) then
						client:NotifyLocalized("You can only have one blueprint in the table at a time.")
					end

					return false
				end
			elseif (weapon) then
				return
				--[[if (weaponNum == 1) then
					local attachments = weapon:GetData("mod") or {}
					local weaponTable = weapons.GetStored(weapon.class)

					if (weaponTable) then
						local availableAttachments = {}
						local attachTable = {}
						local itemsToRemove = {}

						-- remove attachments
						for k, v in pairs(attachments) do
							inv:Add(v)
						end

						-- attach attachments
						-- get available attachments
						for k, v in pairs(craftableItems) do
							if (v.isAttachment) then
								availableAttachments[v.uniqueID] = v
							end
						end
						-- set target attachments
						for atcat, data in ipairs(weaponTable.Attachments) do
							for k, name in pairs(data.atts) do
								local atItem = availableAttachments[name]

								if (atItem and !attachTable[atcat]) then
									attachTable[atcat] = name

									table.insert(itemsToRemove, atItem)
								end
							end
						end

						-- remove attached items.
						for k, v in pairs(itemsToRemove) do
							v:Remove()
						end
						-- yeah .. attachSpecificAttachment(attachmentName)

						-- save attachment data on the item.
						if (table.Count(attachTable) <= 0) then
							attachTable = nil
						end

						weapon:SetData("mod", attachTable)
					else
						client:NotifyLocalized("invalid", "weapon information")
					end
				else
					if (weaponNum > 1) then
						client:NotifyLocalized("You can only craft one weapon.")
					end
				end--]]
			else
				client:NotifyLocalized("You don't have a recipe book inside the table.")
			end
		end
	end

	function ENT:SetInventory(inventory)
		if (inventory) then
			self:SetNetVar("id", inventory:GetID())

			inventory.onAuthorizeTransfer = function(inventory, client, oldInventory, item)
				if (IsValid(client) and IsValid(self) and self.receivers[client]) then
					return true
				end
			end

			inventory.getReceiver = function(inventory)
				local receivers = {}

				for k, v in pairs(self.receivers) do
					if (IsValid(k)) then
						receivers[#receivers + 1] = k
					end
				end

				return #receivers > 0 and receivers or nil
			end
		end
	end
	
	function ENT:Use(activator)
		local inventory = self:GetInventory()

		if (inventory and (activator.ixNextOpen or 0) < CurTime()) then
			if (activator:GetChar()) then
				activator:SetAction("Opening...", 0.5, function()
					if (activator:GetPos():Distance(self:GetPos()) <= 100) then
						self.receivers[activator] = true
						activator.ixBagEntity = self
						
						inventory:Sync(activator)
						inventory:AddReceiver(activator)
						netstream.Start(activator, "craftingTableOpen", self, inventory:GetID())
					end
				end)
			end

			activator.ixNextOpen = CurTime() + 1.5
		end
	end

	function ENT:OnRemove()
		self.loopsound:Stop()
		
		local index = self:GetNetVar("id")

		if (!ix.shuttingDown and !self.ixIsSafe and index) then
			local item = ix.item.inventories[index]

			if (item) then
				ix.item.inventories[index] = nil

				----ix.db:Query("DELETE FROM ix_items WHERE _invID = "..index)
				---ix.db:Query("DELETE FROM ix_inventories WHERE _invID = "..index)

				hook.Run("StorageItemRemoved", self, item)
			end
		end
	end

	function ENT:GetInventory()
		return ix.item.inventories[self:GetNetVar("id", 0)]
	end

	function ENT:Think()
		if (self:GetNetVar("gone")) then
			return
		end
	end

	netstream.Hook("doCraft", function(client, entity, seconds)
		local distance = client:GetPos():Distance(entity:GetPos())
		
		if (entity:IsValid() and client:IsValid() and client:GetChar() and
			distance < 128) then
			entity:activate(client)
		end
	end)
else
	function ENT:Draw()
		self:DrawModel()
	end

	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(container)
		local name = container:AddRow("name")
		name:SetImportant()
		name:SetText("Combine Manufacturing Bench")
		name:SizeToContents()
		

		local description = container:AddRow("Description")
		description:SetText("You can manufacture items here.")
		description:SizeToContents()
	end
end
