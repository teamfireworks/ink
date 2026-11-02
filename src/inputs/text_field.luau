const types = require("../types")

const compat = require("../compat")
const Rect, Enum = compat.Rect, compat.Enum

const function new(): types.TextField
	const self = {
		primitives = nil,
		bounds = Rect.new(),
		value = nil,
		selection_start = -1,
		cursor = -1,
		focused = false,
		changed = false,
		submitted = false,
		state = Enum.GuiState.Idle,
	} :: types.TextField

	self.primitives = {
		{
			kind = "text_field",
			bounds = self.bounds,
			text_field = self,
		},
	}

	return self
end

const function text_field(
	s: types.Scope,
	bounds: Rect,
	default_value: string,
	style: types.TextStyle,
	color: Color3?,
	transparency: number?,
	options: types.TextFieldOptions?
): types.TextField
	const self = s:once(new)

	if self.value == nil then
		self.value = default_value
	end

	self.bounds = bounds
	const primitive = self.primitives[1]
	primitive.bounds = bounds
	primitive.color = color
	primitive.transparency = transparency
	primitive.text_style = style
	primitive.text_field_options = options

	return self
end

return text_field
