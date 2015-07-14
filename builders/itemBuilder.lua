local addon, ns = ...

local itemBuilder = ns.builders.defaultBuilder:extend({

	new = function(self, name)

		local this = setmetatable({}, { __index = self })
		this.name = name

		return this
	end,

	key = function(self, bagID, slotID)
		return self.name
	end,

	condition = function(self, bagID, slotID)

		local texture, count, locked, quality, readable, lootable, link = GetContainerItemInfo(bagID, slotID)

		if not link then
			return false
		end

		local name = GetItemInfo(link)

		return name == self.name
	end,

	create = function(self, bagID, slotID)
		return self:createGroup(self.name)
	end,

	addTo = function(self, collection, frame)
		table.insert(collection, 1, frame)
	end,

})

ns.builders.itemBuilder = itemBuilder
