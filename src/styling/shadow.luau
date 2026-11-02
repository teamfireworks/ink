local map_primitives = require("../composites/map_primitives")
local types = require("../types")

const function shadow(c: types.Composite, style: types.ShadowStyle): types.Composite
	return map_primitives(c, function(primitive, style)
		primitive.shadow = style
	end, style)
end

return shadow
