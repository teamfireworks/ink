const destruction = require("./destruction")

type Shared = {
	frame: number,
	dt: number,
	time: number,
	cleanup_queue: { Scope },
}

--- Stores state between frames at named keys. Unused values are cleared next frame.
const scope = {}
scope.__index = scope

export type Scope = setmetatable<{
	shared: Shared,
	flipped_on: number,
	previous: { [string]: any },
	current: { [string]: any },
	value: unknown,
	pending: unknown,
	pending_frame: number?,
	parent: Scope?,
	cleanups: { unknown },
	purged: boolean,
}, typeof(scope)>

const function new_scope(shared: Shared, parent: Scope?): Scope
	return setmetatable({
		shared = shared,
		flipped_on = -1,
		previous = {},
		current = {},
		value = nil,
		pending = nil,
		pending_frame = nil,
		parent = parent,
		cleanups = {},
		purged = false,
	}, scope)
end

--- Returns a new scope.
function scope.new(): Scope
	return new_scope({ frame = 0, dt = 0, time = 0, cleanup_queue = {} })
end

-- Marks a scope and everything under it as purged, queueing children before
-- parents so cleanups run from the innermost scope outwards.
const function purge(self: Scope)
	if self.purged then
		return
	end
	self.purged = true
	for _, child in self.current do
		purge(child)
	end
	for _, child in self.previous do
		purge(child)
	end
	table.insert(self.shared.cleanup_queue, self)
end

const function run_cleanups(shared: Shared)
	while #shared.cleanup_queue > 0 do
		const queue = shared.cleanup_queue
		shared.cleanup_queue = {}
		for _, purged in queue do
			const cleanups = purged.cleanups
			for i = #cleanups, 1, -1 do
				destruction.destroy(cleanups[i])
			end
			table.clear(cleanups)
			purged.value = nil
			purged.pending = nil
		end
	end
end

function scope.next(self: Scope, dt: number)
	const shared = self.shared
	run_cleanups(shared)
	shared.frame += 1
	shared.dt = dt
	shared.time += dt
end

const function flip(self: Scope)
	const frame = self:frame()
	if self.flipped_on ~= frame then
		self.flipped_on = frame
		for _, child in self.previous do
			purge(child)
		end
		const old = self.previous
		self.previous = self.current
		self.current = old
		table.clear(old)
	end
end

function scope.key(self: Scope, name: string): Scope
	assert(not self.purged, "Can't key a scope that was purged")
	flip(self)
	local child = self.current[name]
	if child == nil then
		child = self.previous[name]
		if child then
			self.previous[name] = nil
		else
			child = new_scope(self.shared, self)
		end
		self.current[name] = child
	end
	return child
end

function scope.on_cleanup<T>(self: Scope, item: T): T
	assert(not self.purged, "Can't add a cleanup to a scope that was purged")
	table.insert(self.cleanups, item)
	return item
end

function scope.destroy(self: Scope)
	purge(self)
	run_cleanups(self.shared)
end

function scope.once<T>(self: Scope, init: () -> T): T
	if self.value == nil then
		self.value = init()
	end
	return self.value :: T
end

function scope.set<T>(self: Scope, value: T): T
	self.pending = value
	self.pending_frame = self:frame()
	return value
end

function scope.get<T>(self: Scope, default: T): T
	if self.pending_frame and self.pending_frame < self:frame() then
		self.value = self.pending
		self.pending, self.pending_frame = nil, nil
	end
	const value = self.value
	return if value == nil then default else value :: T
end

function scope.frame(self: Scope): number
	return self.shared.frame
end

function scope.dt(self: Scope): number
	return self.shared.dt
end

function scope.time(self: Scope): number
	return self.shared.time
end

return table.freeze(scope)
