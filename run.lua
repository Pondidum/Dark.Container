local addon, ns = ...

local style = ns.lib.style

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

local styleButton = function(button)

	if button.styledAlready then
		return
	end

	local count = button.Count
	local icon = button.icon
	local cooldown = _G[button:GetName() .."Cooldown"]

	button:SetPushedTexture("")
	button:SetNormalTexture("")

	button:ClearAllPoints()
	button:SetSize(24, 24)

	style:border(button)

	button.IconBorder:SetTexture(nil)
	button.IconBorder:Hide()

	button.BattlepayItemTexture:SetTexture(nil)
	button.BattlepayItemTexture:Hide()
	button:Show()

	count:ClearAllPoints()
	count:SetPoint("BottomRight")
	count:Show()

	icon:SetAllPoints(button)
	icon:SetTexCoord(.08, .92, .08, .92)

	button.styledAlready = true

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

			styleButton(cell)
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

hooksecurefunc("ToggleAllBags", run)

Dark.container = ns