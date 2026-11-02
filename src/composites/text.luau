local TextService = game:GetService("TextService")

local types = require("../types")

--- Creates a composite containing measured text.
const function text(content: string, style: types.TextStyle): types.Composite
	const frame = Vector2.new(style.max_width or math.huge, math.huge)
	const size = TextService:GetTextSize(content, style.size, style.font, frame)
	const bounds = Rect.new(Vector2.zero, size)

	const primitive: types.Primitive = {
		kind = "text",
		bounds = bounds,
		text = content,
		text_style = style,
	}

	return { primitives = { primitive }, bounds = bounds }
end

return text
