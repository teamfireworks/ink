local intersect_rects = require("../rects/intersect_rects")
local types = require("../types")

--- Restricts a composite's visible area to a rect, discarding anything entirely outside it.
const function clip(c: types.Composite, bounds: Rect): types.Composite
	const out = {}
	for _, primitive in c.primitives do
		const region = if primitive.clip then intersect_rects(primitive.clip, bounds) else bounds
		const visible = intersect_rects(primitive.bounds, region)
		if visible.Width > 0 and visible.Height > 0 then
			const copy = table.clone(primitive)
			copy.clip = region
			table.insert(out, copy)
		end
	end
	return { primitives = out, bounds = bounds }
end

return clip
