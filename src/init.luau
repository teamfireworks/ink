const after = require("@self/timing/after")
const align = require("@self/layout/align")
const aspect_cover = require("@self/rects/aspect_cover")
const aspect_fit = require("@self/rects/aspect_fit")
const async = require("@self/state/async")
const clip = require("@self/layout/clip")
const color = require("@self/animation/color")
const compose = require("@self/layout/compose")
const context = require("@self/state/context")
local destruction = require("@self/state/destruction")
const distribute = require("@self/rects/distribute")
const every = require("@self/timing/every")
const expensive = require("@self/state/expensive")
const gradient = require("@self/styling/gradient")
const h_stack = require("@self/layout/h_stack")
const hit_region = require("@self/inputs/hit_region")
local hoarcekat_story = require("@self/render/hoarcekat_story")
const image = require("@self/composites/image")
const input_collector = require("@self/inputs/input_collector")
const inset_rect = require("@self/rects/inset_rect")
const inset_rect_sides = require("@self/rects/inset_rect_sides")
const inset_rect_xy = require("@self/rects/inset_rect_xy")
const intersect_rects = require("@self/rects/intersect_rects")
const is_equal_rects = require("@self/rects/is_equal_rects")
const is_in_rect = require("@self/rects/is_in_rect")
const lerp = require("@self/animation/lerp")
const map_primitives = require("@self/composites/map_primitives")
const masonry = require("@self/layout/masonry")
const mount = require("@self/render/mount")
const pad_all = require("@self/layout/pad_all")
const pad_sides = require("@self/layout/pad_sides")
const pad_xy = require("@self/layout/pad_xy")
local place = require("@self/layout/place")
const rect = require("@self/rects/rect")
const rect_sized = require("@self/rects/rect_sized")
local rect_squared = require("@self/rects/rect_squared")
const renderer = require("@self/render/renderer")
const resolve_input = require("@self/inputs/resolve_input")
const rotate = require("@self/styling/rotate")
const round = require("@self/styling/round")
const scope = require("@self/state/scope")
const shadow = require("@self/styling/shadow")
const solid = require("@self/composites/solid")
const spring = require("@self/animation/spring")
local stack_layout = require("@self/layout/stack_layout")
const stroke = require("@self/styling/stroke")
const text = require("@self/composites/text")
const text_field = require("@self/inputs/text_field")
const timer = require("@self/timing/timer")
const tint = require("@self/styling/tint")
const translate = require("@self/layout/translate")
const tween = require("@self/animation/tween")
const types = require("@self/types")
const ui_labs_story = require("@self/render/ui_labs_story")
const union_rects = require("@self/rects/union_rects")
local units = require("@self/units")
const v_stack = require("@self/layout/v_stack")
local version = require("@self/version")
const visible_range = require("@self/layout/visible_range")

export type Primitive = types.Primitive
export type PrimitiveKind = types.PrimitiveKind
export type Composite = types.Composite
export type Length = types.Length

export type TextStyle = types.TextStyle
export type ImageStyle = types.ImageStyle
export type RoundStyle = types.RoundStyle
export type StrokeStyle = types.StrokeStyle
export type GradientStyle = types.GradientStyle
export type ShadowStyle = types.ShadowStyle

export type HitRegion = types.HitRegion
export type HitRegionOptions = types.HitRegionOptions
export type TextField = types.TextField
export type TextFieldOptions = types.TextFieldOptions
export type InputSource = types.InputSource
export type InputFrame = types.InputFrame
export type InputState = types.InputState
export type InputCollector = input_collector.InputCollector

export type Scope = scope.Scope
export type Context<T> = context.Context<T>

export type Units = units.Units

export type Renderer = renderer.Renderer
export type Story<C = nil> = types.Story<C>
export type StoryProperties<C = nil> = types.StoryProperties<C>

--- @class ink
--- Roblox UI beyond the instance tree.
const ink = {}
ink.version = version

-- Composites
ink.solid = solid
ink.text = text
ink.image = image
ink.map_primitives = map_primitives

-- Inputs
ink.hit_region = hit_region
ink.text_field = text_field
ink.input_collector = input_collector.new
ink.resolve_input = resolve_input

-- Layout
ink.compose = compose
ink.translate = translate
ink.align = align
ink.place = place
ink.stack_layout = stack_layout
ink.h_stack = h_stack
ink.v_stack = v_stack
ink.masonry = masonry
ink.visible_range = visible_range
ink.pad_all = pad_all
ink.pad_sides = pad_sides
ink.pad_xy = pad_xy
ink.clip = clip

ink.ALIGN_START = 0
ink.ALIGN_MID = 0.5
ink.ALIGN_END = 1

-- Styling
ink.tint = tint
ink.rotate = rotate
ink.round = round
ink.stroke = stroke
ink.gradient = gradient
ink.shadow = shadow

-- Rects
ink.rect = rect
ink.rect_sized = rect_sized
ink.rect_squared = rect_squared
ink.inset_rect = inset_rect
ink.inset_rect_xy = inset_rect_xy
ink.inset_rect_sides = inset_rect_sides
ink.union_rects = union_rects
ink.intersect_rects = intersect_rects
ink.is_equal_rects = is_equal_rects
ink.is_in_rect = is_in_rect
ink.aspect_fit = aspect_fit
ink.aspect_cover = aspect_cover
ink.distribute = distribute

-- Units
ink.units = units.context
ink.px = units.px
ink.rem = units.rem
ink.viewport_scale = units.viewport_scale

-- Animation
ink.color = color
ink.lerp = lerp
ink.tween = tween
ink.spring = spring

-- Timing
ink.timer = timer
ink.after = after
ink.every = every

-- State
ink.scope = scope.new
ink.context = context.new
ink.expensive = expensive
ink.async = async
ink.destroy_methods = destruction.destroy_methods
ink.destroy_types = destruction.destroy_types
ink.destroy = destruction.destroy

-- Render
ink.renderer = renderer.new
ink.mount = mount
ink.ui_labs_story = ui_labs_story
ink.hoarcekat_story = hoarcekat_story

return table.freeze(ink)
