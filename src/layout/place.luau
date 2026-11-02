const compat = require("../compat")
const Rect = compat.Rect

const translate_into = require("./translate_into")
const types = require("../types")

--- Moves each composite so its top-left corner is at the matching position.
const function place(composites: { types.Composite }, positions: { Vector2 }): types.Composite
	const primitives = {}
	local min_x, min_y, max_x, max_y = math.huge, math.huge, -math.huge, -math.huge

	for index, c in composites do
		const b, p = c.bounds, positions[index]
		const dx, dy = p.X - b.Min.X, p.Y - b.Min.Y
		translate_into(c, dx, dy, primitives)

		min_x = math.min(min_x, p.X)
		min_y = math.min(min_y, p.Y)
		max_x = math.max(max_x, p.X + b.Width)
		max_y = math.max(max_y, p.Y + b.Height)
	end

	if min_x > max_x then
		return { primitives = primitives, bounds = Rect.new() }
	end

	return { primitives = primitives, bounds = Rect.new(min_x, min_y, max_x, max_y) }
end

return place
