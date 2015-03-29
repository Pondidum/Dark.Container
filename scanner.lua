local addon, ns = ...

local class = ns.lib.class
local frameMap = ns.frameMap

local scanner = class:extend({

	ctor = function(self, providers, containerIDs)
		self.providers = providers
		self.containerIDs = containerIDs
	end,

	layout = function(self)

		for i, bagID in ipairs(self.containerIDs) do

			for slot = 1, GetContainerNumSlots(bagID) do

				local provider = self:getProvider(bagID, slotID)
				local itemFrame = frameMap[bagID][slotID]

				provider:createContainer(bagID, slotID)
				provider:add(bagID, slotID, itemFrame)

			end

		end
	end,

	getProvider = function(self, bagID, slotID)

		for i, provider in ipairs(self.providers) do

			if provider:canHandle(bagID, slotID) then
				return provider
			end

		end

	end,
})

ns.scanner = scanner
