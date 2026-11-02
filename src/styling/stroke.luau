local map_primitives = require("../composites/map_primitives")
local types = require("../types")

const function stroke(c: types.Composite, style: types.StrokeStyle): types.Composite
	return map_primitives(c, function(primitive, style)
		primitive.stroke = style
	end, style)
end

return stroke
