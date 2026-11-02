const types = require("../types")

--- Returns a new composite with `fn` applied to a copy of each primitive.
const function map_primitives<A...>(c: types.Composite, fn: (types.Primitive, A...) -> (), ...: A...): types.Composite
	const out = table.create<<types.Primitive>>(#c.primitives)
	for index, primitive in c.primitives do
		const copy = table.clone(primitive)
		fn(copy, ...)
		out[index] = copy
	end
	return { primitives = out, bounds = c.bounds }
end

return map_primitives
