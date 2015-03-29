local addon, ns = ...

local layout = ns.lib.layout

local provider = ns.provider

local bagProvider = provider:extend({

	canHandle = function(self, bagID, slotID)
		return true
	end,

	createContainer = function(self, bagID, slotID)

		if self.frames[bagID] then
			return
		end
		local frame = CreateFrame("Frame", "DarkBagProvider"..bagID, self.parent)
		layout:init(frame, {
			--?
		})

		self.frames[bagID] = frame
	end,

	add = function(self, bagID, slotID, frame)

		local container = self.frames[bagID]

		container:addChild(frame)

	end,

})

ns.allProviders.bagProvider = bagProvider
