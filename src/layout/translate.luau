const compat = require("../compat")
const Rect, Vector2 = compat.Rect, compat.Vector2

const types = require("../types")

--- Moves a composite by a pixel offset.
const function translate(c: types.Composite, x: number?, y: number?): types.Composite
	const offset = Vector2.new(x, y)
	const out_primitives = table.create<<primitives.Primitive>>(#c.primitives)
	for _, primitive in c.primitives do
		primitive = table.clone(primitive)
		primitive.bounds = Rect.new(primitive.bounds.Min + offset, primitive.bounds.Max + offset)
		primitive.clip = primitive.clip and Rect.new(primitive.clip.Min + offset, primitive.clip.Max + offset)
		table.insert(out_primitives, primitive)
	end
	return {
		primitives = out_primitives,
		bounds = Rect.new(c.bounds.Min + offset, c.bounds.Max + offset),
	}
end

return translate
