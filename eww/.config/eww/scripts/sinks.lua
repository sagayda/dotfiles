#!/usr/bin/wpexec

local json_module = require("json")

local default_sink = nil
local default_source = nil
local sinks = {}
local sinks_count = 0
local sources = {}
local sources_count = 0

local dump = function()
	local json = {
		default_source = { description = "empty" },
		default_sink = { description = "empty" },
		sinks = sinks,
		sinks_count = sinks_count,
		sources = sources,
		sources_count = sources_count,
	}

	for _, sink in ipairs(sinks) do
		if sink.name == default_sink then
			json.default_sink = sink
			break
		end
	end

	for _, source in ipairs(sources) do
		if source.name == default_source then
			json.default_source = source
			break
		end
	end

	print(json_module.encode(json))
end

sources_om = ObjectManager({
	Interest({ type = "node", Constraint({ "media.class", "=", "Audio/Source" }) }),
})

sinks_om = ObjectManager({
	Interest({ type = "node", Constraint({ "media.class", "=", "Audio/Sink" }) }),
})

metadata_om = ObjectManager({
	Interest({ type = "metadata", Constraint({ "metadata.name", "=", "default", type = "pw-global" }) }),
})

sinks_om:connect("objects-changed", function(om)
	sinks = {}
	sinks_count = 0
	for node in om:iterate() do
		local props = node.properties
		local sink = {
			id = tonumber(props["object.id"]),
			name = props["node.name"] or "empty",
			description = props["node.description"] or "empty",
			volume = 0,
		}

		for prop in node:iterate_params("Props") do
			local volumes = prop:parse().properties.channelVolumes
			if volumes then
				sink.volume = volumes[1] ^ (1 / 3)
				break
			end
		end

		table.insert(sinks, sink)
		sinks_count = sinks_count + 1
	end
	dump()
end)

sources_om:connect("objects-changed", function(om)
	sources = {}
	sources_count = 0
	for node in om:iterate() do
		local props = node.properties
		local source = {
			id = tonumber(props["object.id"]),
			name = props["node.name"] or "empty",
			description = props["node.description"] or "empty",
			volume = 0,
			mute = true,
		}

		for prop in node:iterate_params("Props") do
			local properties = prop:parse().properties

			if properties.mute ~= nil or properties.channelVolumes ~= nil then
				source.volume = properties.channelVolumes[1] ^ (1 / 3)
				source.mute = properties.mute
			end
		end

		table.insert(sources, source)
		sources_count = sources_count + 1
	end
	dump()
end)

metadata_om:connect("installed", function(om)
	local on_default_changed = function(key, value)
		if key == "default.audio.sink" then
			default_sink = json_module.decode(value).name
			dump()
			return
		elseif key == "default.audio.source" then
			default_source = json_module.decode(value).name
			dump()
			return
		end
	end

	for metadata in om:iterate() do
		for _, k, _, v in metadata:iterate(Id.ANY) do
			on_default_changed(k, v)
		end

		metadata:connect("changed", function(_, _, k, _, v)
			on_default_changed(k, v)
		end)
	end
end)

metadata_om:activate()

sources_om:activate()
sinks_om:activate()
