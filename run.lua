local addon, ns = ...


local layout = Darker.layoutEngine
local style = Darker.style


local run = function()

	local containerIDs = {B}

	for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		table.insert(containerIDs, i)
	end

	local groups = {}

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

	local getGroup = function(bagID, slotID)

		local texture, count, locked, quality, readable, lootable, link = GetContainerItemInfo(bagID, slotID)

		if link then
			local name = GetItemInfo(link)

			if name == "Hyper Augment Rune" then

				groups["Hyper"] = groups["Hyper"] or createGroup("Hyper")
				return groups["Hyper"]

			end
		end

		groups[bagID] = groups[bagID] or createGroup(bagID)

		return groups[bagID]

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



	for k, f in pairs(groups) do

		if type(k) == "string" then
			f:SetPoint("BOTTOM", groups[0], "TOP", 0, 5)
		elseif k == 0 then
			f:SetPoint("CENTER")
		else
			f:SetPoint("TOP", groups[k-1], "BOTTOM", 0, -5)
		end

		f:layout()

	end

end

local runOnce = function()

	run()
	run =function() end

end

hooksecurefunc("ToggleAllBags", runOnce)
