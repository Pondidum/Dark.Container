local addon, ns = ...

local class = ns.lib.class

local frameMap = class:extend({

	ctor = function(self)
		self.frames = {}

		self:fillNames()
	end,

	fillNames = function(self)

		for bagID = 0, NUM_CONTAINER_FRAMES do

			local bag = {}

			for slotID = 1, MAX_CONTAINER_ITEMS do

				local name = string.format("ContainerFrame%dItem%d", bagID, slotID)

				bag[slotID] = _G[name]

			end

			self.frames[bagID] = bag

		end

	end,

	getFrame = function(self, bagID, slotID)

		--MAX_CONTAINER_ITEMS = 36
		-- bag 0:
		--  GetContainerNumSlots = 16
		--  Frame for slotID 1 = 16
		--  Frame for slotID 2 = 15

		-- bag 1:
		--  GetContainerNumSlots = 28
		--  Frame for slotID 1 = 28
		--  Frame for slotID 2 = 27

		local offset = GetContainerNumSlots(bagID) + 1
		local framesAvailable = self.frames[bagID]

		return framesAvailable[offset - slotID]


	end,

})

ns.frameMap = frameMap
