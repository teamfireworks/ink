local inset_rect = require("../rects/inset_rect")
local types = require("../types")

--- Grows a composite's bounds by a separate amount on each side, without moving its contents.
const function pad_sides(c: types.Composite, top: number?, left: number?, bottom: number?, right: number?)
	const out = table.clone(c)
	out.bounds = inset_rect(c.bounds, -(top or 0), -(left or 0), -(bottom or 0), -(right or 0))
	return out
end

return pad_sides
