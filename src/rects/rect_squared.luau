const compat = require("../compat")
const Rect, Vector2 = compat.Rect, compat.Vector2

--- Creates a rect of the given side length at the origin.
const function rect_squared(length: number): Rect
	return Rect.new(Vector2.zero, Vector2.new(length, length))
end

return rect_squared
