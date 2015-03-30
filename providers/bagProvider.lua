local addon, ns = ...

local layout = ns.lib.layout

local provider = ns.provider

local bagProvider = provider:extend({

	ctor = function(self, parentContainer)
		self:base():ctor(parentContainer)
		self.engines = {}
	end,

	canHandle = function(self, bagID, slotID)
		return true
	end,

	createContainer = function(self, bagID, slotID)

		if self.engines[bagID] then
			return
		end

		local frame = CreateFrame("Frame", "DarkBagProvider"..bagID, self.parent)
		local engine = layout:new(frame, {
			layout = "horizontal",
			origin = "BOTTOMLEFT",
			itemSize = 24,
			itemSpacing = 2,
			autosize = "x"
		})

		self.engines[bagID] = engine
	end,

	add = function(self, bagID, slotID, frame)

		local engine = self.engines[bagID]

		engine:addChild(frame)
		engine:performLayout()

	end,

})

ns.allProviders.bagProvider = bagProvider
