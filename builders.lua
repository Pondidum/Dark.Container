local addon, ns = ...

local layout = Darker.layoutEngine
local style = Darker.style

local defaultBuilder = {

	key = function(self, bagID, slotID)
		return bagID
	end,

	condition = function(self, bagID, slotID)
		return true
	end,

	create = function(self, bagID, slotID)
		return self:createGroup(bagID)
	end,

	addTo = function(self, collection, frame)
		table.insert(collection, 1, frame)
	end,

	createGroup = function(self, bagID)

		local frame = CreateFrame("Frame", "DarkBagProvider"..bagID, UIParent)
		frame:SetWidth(390)
		style:frame(frame)

		local engine = layout:new(frame, {
			layout = "horizontal",
			origin = "TOPLEFT",
			itemSize = 24,
			itemSpacing = 2,
			autosize = "y",
			wrap = true,

			setPoint = function(child, ...)
				child:OriginalClear()
				child:OriginalSetPoint(...)
			end,
		})

		frame.add = function(self, other)
			engine:addChild(other)
		end

		frame.clear = function(self)
			engine:clearChildren()
		end

		frame.layout = function(self)
			engine:performLayout()
		end

		return frame

	end
}

ns.builders = {

	builders = {},

	get = function(self, bagID, slotID)
		for i, set in ipairs(self.builders) do
			if set:condition(bagID, slotID) then
				return set
			end
		end
	end,

	add = function(self, builder)
		table.insert(self.builders, setmetatable(builder, { __index = defaultBuilder }))
	end,

}
