const compat = require("../compat")
const Vector2 = compat.Vector2

const types = require("../types")

--- Returns the top-left position each item should move to.
const function stack_layout(axis: "x" | "y", composites: { types.Composite }, gap: number?, align: number?): { Vector2 }
	const spacing = gap or 0
	const positions = table.create<<Vector2>>(#composites)
	if #composites == 0 then
		return positions
	end

	const vertical = axis == "y"

	local cross_start, cross_size = math.huge, 0
	if align then
		for _, c in composites do
			const b = c.bounds
			cross_start = math.min(cross_start, if vertical then b.Min.X else b.Min.Y)
			cross_size = math.max(cross_size, if vertical then b.Width else b.Height)
		end
	end

	const first = composites[1].bounds
	local main = if vertical then first.Min.Y else first.Min.X

	for index, c in composites do
		const b = c.bounds
		const own_cross = if vertical then b.Min.X else b.Min.Y
		const own_size = if vertical then b.Width else b.Height
		const cross = if align then cross_start + (cross_size - own_size) * align else own_cross

		positions[index] = if vertical then Vector2.new(cross, main) else Vector2.new(main, cross)
		main += (if vertical then b.Height else b.Width) + spacing
	end

	return positions
end

return stack_layout
