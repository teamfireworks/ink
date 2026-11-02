local log = require("../runtime/log")
const destruction = {}
destruction.destroy_methods = {
	"Destroy",
	"destroy",
	"Disconnect",
	"disconnect",
}

destruction.destroy_types = {
	["Instance"] = function(instance: Instance)
		instance:Destroy()
	end,

	["RBXScriptConnection"] = function(connection: RBXScriptConnection)
		connection:Disconnect()
	end,

	["function"] = function(fn: () -> ())
		local co = coroutine.create(fn)
		local success = coroutine.resume(co)

		if success then
			-- fallthrough
		elseif coroutine.status(co) ~= "dead" then
			local source, line, name = debug.info(fn, "sln")
			log.warn(log.messages.cleanup_error(name, line, source))
		else
			local source, line, name = debug.info(fn, "sln")
			log.warn(log.messages.cleanup_yielded(name, line, source))
		end
	end,

	["thread"] = function(thread: thread)
		pcall(task.cancel, thread)
	end,

	["table"] = function(tbl: { [any]: any })
		for _, method in destruction.destroy_methods do
			if type(tbl[method]) == "function" then
				tbl[method](tbl)
				return
			end
		end

		local len = #tbl
		if len ~= 0 then
			for index = #tbl, 1, -1 do
				destruction.destroy(tbl[index])
			end
		end
	end,
} :: { [string]: (any) -> () }

function destruction.destroy(x)
	local destructor = destruction.destroy_types[typeof(x)]
	if destructor then
		destructor(x)
	end
end

return table.freeze(destruction)
