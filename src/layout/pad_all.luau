local inset_rect = require("../rects/inset_rect")
local types = require("../types")

--- Grows a composite's bounds by the same amount on every side, without moving its contents.
const function pad(c: types.Composite, amount: number)
	const out = table.clone(c)
	out.bounds = inset_rect(c.bounds, -amount)
	return out
end

return pad
