local map_primitives = require("../composites/map_primitives")
const types = require("../types")

--- Recolors and/or fades every Primitive in a Composite.
const function tint(c: types.Composite, color: Color3?, transparency: number?): types.Composite
	return map_primitives(c, function(primitive, color: Color3?, transparency: number?)
		primitive.color = color or primitive.color
		primitive.transparency = transparency or primitive.transparency
	end, color, transparency)
end

return tint
