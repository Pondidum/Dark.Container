local addon, ns = ...

local style = ns.lib.style

local styleBagItems = function(frameMap)

	frameMap:forEach(function(bagID, slotID, frame)
		style:frame(frame)
	end)

end

ns.styleBagItems = styleBagItems
