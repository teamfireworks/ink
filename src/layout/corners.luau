const corners = {}

function corners.new(
	top_left: number?,
	top_right: number?,
	bottom_left: number?,
	bottom_right: number?
): (number, number, number, number)
	return top_left or 0, top_right or 0, bottom_left or 0, bottom_right or 0
end

function corners.all(amount: number)
	return corners.new(amount, amount, amount, amount)
end

function corners.top(amount: number)
	return corners.new(amount, amount, 0, 0)
end

function corners.bottom(amount: number)
	return corners.new(0, 0, amount, amount)
end

function corners.left(amount: number)
	return corners.new(amount, 0, amount, 0)
end

function corners.right(amount: number)
	return corners.new(0, amount, 0, amount)
end

function corners.zero()
	return corners.new()
end

return table.freeze(corners)
