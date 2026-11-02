const compat = require("../compat")
const Vector2 = compat.Vector2

const place = require("./place")
const types = require("../types")

--- Places each composite in whichever column is currently shortest.
const function masonry(
	composites: { types.Composite },
	columns: number,
	column_width: number,
	gap: number
): types.Composite
	const heights = table.create(columns, 0)
	const positions = table.create<<Vector2>>(#composites)

	for index, c in composites do
		local column = 1
		for i = 2, columns do
			if heights[i] < heights[column] then
				column = i
			end
		end
		const y = heights[column]
		positions[index] = Vector2.new((column - 1) * (column_width + gap), y)
		heights[column] = y + c.bounds.Height + gap
	end

	return place(composites, positions)
end

return masonry
