#!/usr/bin/wpexec

local json_module = require("json")

local default_sink = nil
local default_source = nil
local nodes = {}

local inited = false

local dump = function()
	if not inited then
		inited = default_sink ~= nil and default_source ~= nil and nodes ~= nil

		if not inited then
			return
		end
	end

	local json = {
		sources = {},
		sinks = {},
		default_sink = {},
		default_source = {},
		sinks_count = 0,
		sources_count = 0,
	}

	for id, node in pairs(nodes) do
		local props = node.properties
		local media_class = props["media.class"]

		local json_node = {
			name = props["node.name"],
			description = props["node.description"],
			id = id,
			volume = 0,
			mute = true,
		}

		for prop in node:iterate_params("Props") do
			local properties = prop:parse().properties

			if properties.channelVolumes then
				json_node.volume = properties.channelVolumes[1] ^ (1 / 3)
			end

			if properties.mute ~= nil then
				json_node.mute = properties.mute
			end
		end

		if media_class == "Audio/Sink" then
			table.insert(json.sinks, json_node)
			json.sinks_count = json.sinks_count + 1
		else
			table.insert(json.sources, json_node)
			json.sources_count = json.sources_count + 1
		end

		if json_node.name == default_sink then
			json.default_sink = json_node
		elseif json_node.name == default_source then
			json.default_source = json_node
		end
	end

	print(json_module.encode(json))
end

nodes_om = ObjectManager({
	Interest({ type = "node", Constraint({ "media.class", "in-list", "Audio/Sink", "Audio/Source" }) }),
})

metadata_om = ObjectManager({
	Interest({ type = "metadata", Constraint({ "metadata.name", "=", "default", type = "pw-global" }) }),
})

local on_node_changed = function(_, params)
	if params == "Props" then
		dump()
	end
end

local on_metadata_changed = function(_, _, key, _, value)
	if key == "default.audio.sink" then
		default_sink = json_module.decode(value).name
		dump()
		return
	end

	if key == "default.audio.source" then
		default_source = json_module.decode(value).name
		dump()
		return
	end
end

nodes_om:connect("object-added", function(_, node)
	local id = node.properties["object.id"]
	nodes[id] = node
	dump()

	node:connect("params-changed", on_node_changed)
end)

nodes_om:connect("object-removed", function(_, node)
	local id = node.properties["object.id"]
	nodes[id] = nil
	dump()
end)

metadata_om:connect("installed", function(om)
	for metadata in om:iterate() do
		for _, k, _, v in metadata:iterate(Id.ANY) do
			on_metadata_changed(0, 0, k, 0, v)
		end

		metadata:connect("changed", on_metadata_changed)
	end
end)

nodes_om:activate()
metadata_om:activate()
