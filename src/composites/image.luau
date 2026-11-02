local types = require("../types")

--- Creates a composite containing an image.
const function image(bounds: Rect, content: string, style: types.ImageStyle?): types.Composite
	return {
		primitives = { { kind = "image", bounds = bounds, image = content, image_style = style } },
		bounds = bounds,
	}
end

return image
