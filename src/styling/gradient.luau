local map_primitives = require("../composites/map_primitives")
local types = require("../types")

const function gradient(c: types.Composite, style: types.GradientStyle): types.Composite
	return map_primitives(c, function(primitive, style)
		primitive.gradient = style
	end, style)
end

return gradient
