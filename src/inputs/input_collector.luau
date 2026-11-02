const compat = require("../compat")
const Vector2, Enum = compat.Vector2, compat.Enum

const resolve_input = require("./resolve_input")
const types = require("../types")

--- Collects player input from an input source, such as UserInputService or a GuiObject.
const input_collector = {}
input_collector.__index = input_collector

export type InputCollector = setmetatable<{
	frame: types.InputFrame,
	state: types.InputState,

	pending_pressed: boolean,
	pending_released: boolean,
	pending_wheel: number,
	pending_keys: { [Enum.KeyCode]: boolean },

	to_local: (Vector2) -> Vector2,
	screen_pointer: Vector2,
	touch: InputObject?,
	connections: { RBXScriptConnection },
}, typeof(input_collector)>

function input_collector.new(source: types.InputSource, to_local: (Vector2) -> Vector2): InputCollector
	const self: InputCollector = setmetatable({
		frame = {
			pointer = Vector2.zero,
			pointer_delta = Vector2.zero,
			down = false,
			pressed = false,
			released = false,
			wheel = 0,
			keys_held = {},
			keys_pressed = {},
		},
		state = { hit_regions = {}, active = nil },

		pending_pressed = false,
		pending_released = false,
		pending_wheel = 0,
		pending_keys = {},

		to_local = to_local,
		screen_pointer = Vector2.zero,
		touch = nil,
		connections = {},
	}, input_collector)

	const frame = self.frame

	const function is_primary(input: InputObject): boolean
		const t = input.UserInputType
		return t == Enum.UserInputType.MouseButton1
			or (t == Enum.UserInputType.Touch and (self.touch == nil or self.touch == input))
	end

	table.insert(
		self.connections,
		source.InputBegan:Connect(function(input)
			if is_primary(input) then
				if input.UserInputType == Enum.UserInputType.Touch then
					self.touch = input
				end
				self.screen_pointer = Vector2.new(input.Position.X, input.Position.Y)
				frame.down = true
				self.pending_pressed = true
			elseif input.UserInputType == Enum.UserInputType.Keyboard then
				frame.keys_held[input.KeyCode] = true
				self.pending_keys[input.KeyCode] = true
			end
		end)
	)

	table.insert(
		self.connections,
		source.InputChanged:Connect(function(input)
			const t = input.UserInputType
			if t == Enum.UserInputType.MouseMovement or (t == Enum.UserInputType.Touch and input == self.touch) then
				self.screen_pointer = Vector2.new(input.Position.X, input.Position.Y)
			elseif t == Enum.UserInputType.MouseWheel then
				self.pending_wheel += input.Position.Z
			end
		end)
	)

	table.insert(
		self.connections,
		source.InputEnded:Connect(function(input)
			if is_primary(input) then
				self.touch = nil
				frame.down = false
				self.pending_released = true
			elseif input.UserInputType == Enum.UserInputType.Keyboard then
				frame.keys_held[input.KeyCode] = nil
			end
		end)
	)

	return self
end

function input_collector.advance(self: InputCollector)
	const frame = self.frame

	const pointer = self.to_local(self.screen_pointer)
	frame.pointer_delta = pointer - frame.pointer
	frame.pointer = pointer

	frame.pressed, self.pending_pressed = self.pending_pressed, false
	frame.released, self.pending_released = self.pending_released, false
	frame.wheel, self.pending_wheel = self.pending_wheel, 0

	const pressed = frame.keys_pressed
	frame.keys_pressed = self.pending_keys
	table.clear(pressed)
	self.pending_keys = pressed

	resolve_input(self.state, frame)
end

function input_collector.commit(self: InputCollector, composite: types.Composite)
	const hit_regions = self.state.hit_regions
	table.clear(hit_regions)
	for _, primitive in composite.primitives do
		if primitive.hit_region then
			table.insert(hit_regions, primitive)
		end
	end
end

function input_collector.destroy(self: InputCollector)
	for _, connection in self.connections do
		connection:Disconnect()
	end
	table.clear(self.connections)
	table.clear(self.state.hit_regions)
	self.state.active = nil
end

return table.freeze(input_collector)
