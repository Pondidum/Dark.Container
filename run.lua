local addon, ns = ...

local frames = ns.frameMap:new()
ns.styleBagItems(frames)

local providers = {}

for name, provider in pairs(ns.allProviders) do
	table.insert(providers, provider:new(UIParent))
end

local containers = { BACKPACK_CONTAINER }

local scanner = ns.scanner:new(frameMap, providers, containers)

scanner:layout()
