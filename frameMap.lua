local addon, ns = ...

local map = {}

for bagID = 1, NUM_CONTAINER_FRAMES do

	map[bagID] = {}

	for slotID = 1, MAX_CONTAINER_ITEMS do

		local name = string.format("ContainerFrame%dItem%d", bagID, slotID)

		map[bagID][slotID] = _G[name]

	end

end

ns.frameMap = map
