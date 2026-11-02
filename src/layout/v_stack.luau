local place = require("./place")
local stack_layout = require("./stack_layout")
const types = require("../types")

--- Arranges composites top to bottom, optionally aligning them within the longest one.
const function v_stack(cs: { types.Composite }, gap: number?, align: number?): types.Composite
	return place(cs, stack_layout("y", cs, gap, align))
end

return v_stack
