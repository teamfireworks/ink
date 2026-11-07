local map_primitives = require("../composites/map_primitives")
local types = require("../types")

--- Rounds the corners of every primitive in a composite.
const function round(
	c: types.Composite,
	top_left: number?,
	top_right: number?,
	bottom_left: number?,
	bottom_right: number?
): types.Composite
	return map_primitives(c, function(primitive, style)
		primitive.round = style
	end, {
		top_left = top_left,
		top_right = top_right,
		bottom_left = bottom_left,
		bottom_right = bottom_right,
	})
end

return round
