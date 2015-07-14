local addon, ns = ...

ns.builders:add(ns.builders.itemBuilder:new("Hyper Augment Rune"))
ns.builders:add(ns.builders.defaultBuilder:new())


local groups = {}
local groupLayout = {}

local containerIDs = {}

for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
	table.insert(containerIDs, i)
end

local getGroup = function(bagID, slotID)

	local builder = ns.builders:get(bagID, slotID)
	local key = builder:key(bagID, slotID)

	if groups[key] then
		return groups[key]
	end

	local group = builder:create(bagID, slotID)

	builder:addTo(groupLayout, group)
	groups[key] = group

	return group

end

local run = function()

	for k, group in pairs(groups) do
		group:clear()
	end

	for i, bagID in ipairs(containerIDs) do

		local bagTotal = GetContainerNumSlots(bagID)
		for slotID = 1, bagTotal do

			local cellName = string.format("ContainerFrame%dItem%d", bagID+1, bagTotal +1 - slotID)
			local cell = _G[cellName]

			cell.OriginalClear = cell.OriginalClear or cell.ClearAllPoints
			cell.OriginalSetPoint = cell.OriginalSetPoint or cell.SetPoint

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
end

hooksecurefunc("ToggleAllBags", runOnce)

Dark.container = ns