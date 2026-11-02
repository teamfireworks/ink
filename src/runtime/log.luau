const log = {}
log.output = (warn or print) :: <T...>(T...) -> ()

function log.format(id: string, text: string)
	return `[ink] {text} ({id})`
end

function log.error(id: string, text: string): never
	error(log.format(id, text), 2)
end

function log.warn(id: string, text: string)
	log.output(log.format(id, text))
end

const function format_function_name(name: string?)
	return if name == "" or name == nil then "anonymous cleanup callback" else "cleanup callback " .. name
end

log.messages = {
	unsupported_api = function(api: string)
		return "unsupported_api", `runtime does not provide {api} as a global`
	end,

	cannot_animate = function(kind: string)
		return "cannot_animate", `cannot animate a value of type {kind}`
	end,

	lerp_mismatch = function(a: string, b: string)
		return "lerp_mismatch", `cannot interpolate a {a} towards a {b}`
	end,

	scope_purged = function()
		return "scope_purged",
			"scope has been purged because its key wasn't requested last frame; retain by `:key()`-ing every frame"
	end,

	callback_yielded = function(fn: string)
		return "callback_yielded", `{fn} callback cannot yield`
	end,

	callback_errored = function(fn: string, err: unknown)
		return "callback_errored", `error in {fn} callback: {err}`
	end,

	cleanup_error = function(name: string?, line: number, source: string, err: unknown)
		return "cleanup_yielded", `error in {format_function_name(name)} from line {line} of {source}: {err}`
	end,

	cleanup_yielded = function(name: string?, line: number, source: string)
		return "cleanup_yielded",
			`{format_function_name(name)} from line {line} of {source} attempted to yield during cleanup`
	end,
}

return table.freeze(log)
