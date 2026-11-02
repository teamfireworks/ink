local scope = require("./state/scope")

-- Utility

export type Cleanup = () -> ()

export type Pack<T = unknown> = { [number]: T, n: number }

-- Styling

export type GradientStyle = {
	color: ColorSequence?,
	offset_x: number?,
	offset_y: number?,
	rotation: number?,
	scale: number?,
	tile: Enum.GradientTileMode?,
	transparency: NumberSequence?,
	type: Enum.GradientType?,
}

export type StrokeStyle = {
	color: Color3?,
	gradient: GradientStyle?,
	mode: Enum.ApplyStrokeMode?,
	thickness: number?,
	transparency: number?,
}

export type ShadowStyle = {
	color: Color3?,
	inset: boolean?,
	mode: Enum.ApplyShadowMode,
	radius: number?,
	show_behind_parent: boolean?,
	spread_x: number?,
	spread_y: number?,
	transparency: number?,
}

export type RoundStyle = {
	top_left: number?,
	top_right: number?,
	bottom_left: number?,
	bottom_right: number?,
}

export type TextStyle = {
	size: number,
	font: Enum.Font,
}

export type ImageStyle = {
	scale_type: Enum.ScaleType?,
	slice_center: Rect?,
	slice_scale: number?,
	rect_offset: Vector2?,
	rect_size: Vector2?,
	resample: Enum.ResamplerMode?,
	tile_size: UDim2?,
}

-- Composites

export type PrimitiveKind = "solid" | "text" | "image" | "hit_region" | "text_field"

export type Primitive = {
	kind: PrimitiveKind,
	bounds: Rect,
	clip: Rect?,

	color: Color3?,
	transparency: number?,
	rotation: number?,

	round: RoundStyle?,
	gradient: GradientStyle?,
	shadow: ShadowStyle?,
	stroke: StrokeStyle?,

	text: string?,
	text_style: TextStyle?,
	text_wrapped: boolean?,

	text_field: TextField?,
	text_field_options: TextFieldOptions?,

	image: string?,
	image_style: ImageStyle?,

	hit_region: HitRegion?,
	hit_region_wheel: boolean?,
}

export type Composite = {
	primitives: { Primitive },
	bounds: Rect,
}

export type Length = number | { read fr: number }

-- Inputs

export type InputSource = {
	read InputBegan: RBXScriptSignal<InputObject>,
	read InputChanged: RBXScriptSignal<InputObject>,
	read InputEnded: RBXScriptSignal<InputObject>,
}

export type InputFrame = {
	pointer: Vector2,
	pointer_delta: Vector2,
	down: boolean,
	pressed: boolean,
	released: boolean,
	wheel: number,
	keys_held: { [Enum.KeyCode]: boolean },
	keys_pressed: { [Enum.KeyCode]: boolean },
}

export type InputState = {
	hit_regions: { Primitive },
	active: HitRegion?,
}

export type HitRegionOptions = { wheel: boolean? }
export type HitRegion = Composite & {
	state: Enum.GuiState,
	clicked: boolean,
	wheel: number,
	drag: Vector2,
	pointer: Vector2,
	bounds: Rect,
}

export type TextFieldOptions = { multiline: boolean?, editable: boolean? }
export type TextField = Composite & {
	value: string,
	selection_start: number,
	selection_cursor: number,
	focused: boolean,
	changed: boolean,
	submitted: boolean,
	state: Enum.GuiState,

	pending_value: string?,
	pending_selection_start: number?,
	pending_selection_cursor: number?,
	pending_focus: boolean?,
}

-- Runtime

export type Scope = scope.Scope

export type function ProcessControls(controls: type): type
	const CONTROL_VALUE = types.singleton("ControlValue")

	if controls.tag ~= "table" then
		return controls
	end

	const result = types.newtable()
	for key, control in controls:properties() do
		local control_value = control.read
		if control.read and control.read.tag == "table" then
			control_value = control.read:readproperty(CONTROL_VALUE)
		end
		result:setreadproperty(key, control_value)
	end

	return result
end

export type StoryProperties<C = nil> = {
	controls: ProcessControls<C>,
	target: GuiObject,
	target_bounds: Rect,
	scope: scope.Scope,
}

export type Story<C = nil> = {
	name: string?,
	summary: string?,
	cleanup: Cleanup?,
	controls: C?,
	render: (properties: StoryProperties<C>) -> Composite,
}

return nil
