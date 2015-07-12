local addon, ns = ...


local layout = Darker.layoutEngine
local style = Darker.style


local createGroup = function(bagID)

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

	frame.layout = function(self)
		engine:performLayout()
	end

	return frame

end

local builders = {
	get = function(self, bagID, slotID)
		for i, set in ipairs(self) do
			if set.condition(bagID, slotID) then
				return set
			end
		end
	end,
}

table.insert(builders, {
	key = function(bagID, slotID)
		return "Hyper"
	end,
	condition = function(bagID, slotID)

		local texture, count, locked, quality, readable, lootable, link = GetContainerItemInfo(bagID, slotID)

		if not link then
			return false
		end

		local name = GetItemInfo(link)

		return name == "Hyper Augment Rune"
	end,
	create = function(bagID, slotID)
		return createGroup("Hyper")
	end,
	addTo = function(collection, frame)
		table.insert(collection, 1, frame)
	end,
})

table.insert(builders, {
	key = function(bagID, slotID)
		return bagID
	end,
	condition = function(bagID, slotID)
		return true
	end,
	create = function(bagID, slotID)
		return createGroup(bagID)
	end,
	addTo = function(collection, frame)
		table.insert(collection, frame)
	end,
})



local run = function()

	local containerIDs = {}

	for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		table.insert(containerIDs, i)
	end

	local groups = {}
	local groupLayout = {}


	local getGroup = function(bagID, slotID)

		local builder = builders:get(bagID, slotID)
		local key = builder.key(bagID, slotID)

		if groups[key] then
			return groups[key]
		end

		local group = builder.create(bagID, slotID)

		builder.addTo(groupLayout, group)
		groups[key] = group

		return group

	end

	for i, bagID in ipairs(containerIDs) do

		local bagTotal = GetContainerNumSlots(bagID)
		for slotID = 1, bagTotal do

			local cellName = string.format("ContainerFrame%dItem%d", bagID+1, bagTotal +1 - slotID)
			local cell = _G[cellName]

			cell.OriginalClear = cell.ClearAllPoints
			cell.OriginalSetPoint = cell.SetPoint

			cell.ClearAllPoints = function() end
			cell.SetPoint = function() end

			getGroup(bagID, slotID):add(cell)

		end

	end


	local prev

	for i, f in ipairs(groupLayout) do

		if not prev then
			f:SetPoint("CENTER")
		else
			f:SetPoint("TOP", prev, "BOTTOM", 0, -5)
		end

		prev = f

		f:layout()

	end

end

local runOnce = function()

	run()
	run =function() end

end

hooksecurefunc("ToggleAllBags", runOnce)
