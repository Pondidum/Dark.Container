local addon, ns = ...

local class = ns.lib.class

local frameMap = class:extend({

	ctor = function(self)
		self.frames = {}

		self:fillNames()
	end,

	fillNames = function(self)

		for bagID = 1, NUM_CONTAINER_FRAMES do

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

		--this +1 is due to bagFrame being 1 in the ui and 0 in api calls
		local framesAvailable = self.frames[bagID + 1]
		local offset = GetContainerNumSlots(bagID) + 1

		return framesAvailable[offset - slotID]


	end,

	forEach = function(self, action)

		for bagID, slots in pairs(self.frames) do
			for slotID, frame in pairs(slots) do
				action(bagID, slotID, frame)
			end
		end

	end,

})

ns.frameMap = frameMap
