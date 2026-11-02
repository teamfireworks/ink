const compat = require("../compat")
const intersect_rects = require("../rects/intersect_rects")
const is_in_rect = require("../rects/is_in_rect")
const types = require("../types")
const Enum, Vector2 = compat.Enum, compat.Vector2

const function visible_bounds(primitive: types.Primitive): Rect
	return if primitive.clip then intersect_rects(primitive.bounds, primitive.clip) else primitive.bounds
end

const function resolve_input(state: types.InputState, frame: types.InputFrame)
	const regions = state.hit_regions
	const pointer = frame.pointer

	local hovered: types.Primitive? = nil
	local wheel_target: types.Primitive? = nil
	local active_primitive: types.Primitive? = nil

	for index = #regions, 1, -1 do
		const primitive = regions[index]
		const region = primitive.hit_region :: types.HitRegion

		region.state = Enum.GuiState.Idle
		region.clicked = false
		region.wheel = 0
		region.drag = Vector2.zero

		if region == state.active then
			active_primitive = primitive
		end

		if is_in_rect(visible_bounds(primitive), pointer) then
			if hovered == nil then
				hovered = primitive
			end
			if wheel_target == nil and primitive.hit_region_wheel then
				wheel_target = primitive
			end
		end
	end

	if state.active and not active_primitive then
		state.active = nil
	end

	const hovered_region = if hovered then hovered.hit_region else nil
	if frame.pressed then
		state.active = hovered_region
		active_primitive = hovered
	end

	if hovered and hovered_region then
		hovered_region.pointer = pointer - hovered.bounds.Min
	end

	const active = state.active
	if active and active_primitive then
		active.state = Enum.GuiState.Press
		active.drag = frame.pointer_delta
		active.pointer = pointer - active_primitive.bounds.Min
	elseif hovered_region then
		hovered_region.state = Enum.GuiState.Hover
	end

	if frame.released then
		if active and active == hovered_region then
			active.clicked = true
		end
		state.active = nil
	end

	if wheel_target then
		(wheel_target.hit_region :: types.HitRegion).wheel = frame.wheel
	end
end

return resolve_input
