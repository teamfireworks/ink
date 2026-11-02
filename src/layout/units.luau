const context = require("../state/context")
const types = require("../types")

export type Units = { scale: number, rem: number }

const units = {}

--- The current scale.
units.context = context.new({ scale = 1, rem = 16 } :: Units)

--- Returns a design-time pixel value, rounded to a whole pixel.
function units.px(s: types.Scope, n: number): number
	return math.round(n * units.context:get(s).scale)
end

--- Returns a multiple of the base size, scaled and rounded.
function units.rem(s: types.Scope, n: number): number
	const u = units.context:get(s)
	return math.round(n * u.rem * u.scale)
end

--- Returns a scale from the viewport height relative to a reference height.
function units.viewport_scale(viewport: Rect, reference_height: number, min: number?, max: number?): number
	return math.clamp(viewport.Height / reference_height, min or 0, max or math.huge)
end

return table.freeze(units)
