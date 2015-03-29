local addon, ns = ...

local class = ns.lib.class

local provider = class:extend({

	ctor = function(self, parentContainer)
		self.parent = parentContainer
	end,

	canHandle = function(self, bagID, slotID)
		return false
	end,

	createContainer = function(self, bagID, slotID)

	end,

	add = function(self, bagID, slotID)

	end,

})

ns.provider = provider
