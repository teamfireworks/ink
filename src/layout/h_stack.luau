local place = require("./place")
local stack_layout = require("./stack_layout")
const types = require("../types")

--- Arranges composites left to right, optionally aligning them within the tallest one.
const function h_stack(cs: { types.Composite }, gap: number?, align: number?): types.Composite
	return place(cs, stack_layout("x", cs, gap, align))
end

return h_stack
