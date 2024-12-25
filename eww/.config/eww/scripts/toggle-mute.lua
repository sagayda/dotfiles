#!/usr/bin/wpexec

local args = {}
local commands = {}

commands.mute = function(mixer, id)
	mixer:call("set-volume", id, { mute = true })
	print("true")
end

commands.unmute = function(mixer, id)
	mixer:call("set-volume", id, { mute = false })
	print("false")
end

commands.toggle = function(mixer, id)
	local route = mixer:call("get-volume", id)
	mixer:call("set-volume", id, { mute = not route.mute })
	print(not route.mute)
end

if not ... then
	Core.quit()
	return
end

for k, v in pairs((...):parse()) do
	args[k] = v
end

local function getId(default_nodes_api)
	if not args.id then
		return nil
	end

	if args.id == "DEFAULT_SOURCE" then
		return default_nodes_api:call("get-default-node", "Audio/Source")
	end

	if args.id == "DEFAULT_SINK" then
		return default_nodes_api:call("get-default-node", "Audio/Sink")
	end

	return tonumber(args.id)
end

Core.require_api("default-nodes", "mixer", function(default_nodes, mixer)
	local id = getId(default_nodes)
	local cmd = commands[args.command]

	if not id or not cmd then
		Core.quit()
		return
	end

	cmd(mixer, id)

	Core.quit()
end)
