local map_primitives = require("../composites/map_primitives")
local types = require("../types")

--- Rounds the corners of every primitive in a composite.
const function round(c: types.Composite, amount: number | types.RoundStyle): types.Composite
	const style: types.RoundStyle = type(amount) == "table" and amount
		or {
			top_left = amount,
			top_right = amount,
			bottom_left = amount,
			bottom_right = amount,
		}

	return map_primitives(c, function(primitive, style)
		primitive.round = style
	end, style)
end

return round
