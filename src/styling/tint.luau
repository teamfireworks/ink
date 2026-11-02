const map_primitives = require("../composites/map_primitives")
const types = require("../types")

const function fade(existing: number?, amount: number): number
	return 1 - (1 - (existing or 0)) * (1 - amount)
end

const function fade_style<T>(style: T?, amount: number): T?
	if style == nil then
		return nil
	end
	const copy = table.clone(style :: any)
	copy.transparency = fade(copy.transparency, amount)
	return copy
end

const function apply_tint(primitive: types.Primitive, color: Color3?, transparency: number?)
	if color then
		primitive.color = color
	end
	if transparency and transparency > 0 then
		primitive.transparency = fade(primitive.transparency, transparency)
		primitive.stroke = fade_style(primitive.stroke, transparency)
		primitive.shadow = fade_style(primitive.shadow, transparency)
	end
end

--- Recolors and/or fades every primitive in a composite, including modifiers.
--- Transparency fades on top of what's already there.
const function tint(c: types.Composite, color: Color3?, transparency: number?): types.Composite
	return map_primitives(c, apply_tint, color, transparency)
end

return tint
